#!/bin/bash

set -euxo pipefail

name=linux-pam-build
ver=latest

start=`date`
echo "== Build start: $start"

# Setup the environment
. $GITHUB_WORKSPACE/alma8/env.sh

build=alma8

# Find the top dir
topdir=`readlink -f .`
if test ! -d $build; then
    topdir=`readlink -f ..`
fi

# Start the build
cd $build

# Selectively edit the packaging files
sed -i \
    -e 's/@CISCO_VERSION@/'$CISCO_VERSION/ \
    SPECS/pam.spec

# Make the Cisco version JSON
$GITHUB_WORKSPACE/tools/create-version-json.sh \
    $SOURCE_PACKAGE_VERSION "$CISCO_VERSION" \
    SOURCES/cisco-package-version.json

# JMS How to inject the json file into the package?
#echo cisco-package-version.json >> debian/libpam0g-cisco.docs

# Build the Alma 8 docker image.  Note that this doesn't actually
# build the RPMs that we want -- see the comments below for an
# explanation why.
image=temp-alma8-image
docker build --security-opt= -f Dockerfile \
       --tag $image .

# Make the output directory here in the host filesystem where the
# built RPMs will eventually be deposited.
mkdir -p out
chmod 777 out

# The Alma "mock" command (which builds the RPMs) must be run with in
# a docker container with --privileged, and therefore can't be run
# during the building of the docker image. :-( Hence, we have to
# "docker run ..." here to get the container running so that we can
# launch "mock" inside it.  We'll then copy the generated RPMs out to
# a bind-mounted filesystem outside of the container.

p=`pwd`
idu=`id -u`
idg=`id -g`
container=temp-alma8-container
docker run -t --privileged --name $container \
       --mount type=bind,source=$p/out,target=/out $image &

# Let the container and bindmound get settled
sleep 5

# We can't use wildcards in the commands run via "docker exec" (to
# find the created SRPM and RPMs), so use indirect methods.

# Find the SRPM that was created when we built the image.  There will
# only be 1 matching file.
srpm_dir=/home/builder/rpmbuild/SRPMS
srpm=`docker exec $container find $srpm_dir -type f`

# Run mock to build the RPMs
docker exec $container mock -v --isolation=simple -r almalinux-8-x86_64 \
       --rebuild $srpm

# Copy the built RPMs out of the running container.
# This is where mock puts the built RPMs in the container:
outdir=/var/lib/mock/almalinux-8-x86_64/result
rpms=`docker exec $container find $outdir -type f | grep -E '\.rpm$'`
for rpm in $rpms; do
    docker exec $container mv $rpm /out
done

# Kill the build container process so that this script doesn't hang at
# the end
kill -9 %1

# Bundle up the output
mkdir "${OUTNAME}"
mv $topdir/$build/out/* "${OUTNAME}"
tar cvf "${OUTNAME}.tar" "${OUTNAME}"

end=`date`
echo "== Build start: $start"
echo "== Build end:   $end"
