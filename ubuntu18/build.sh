#!/bin/bash

set -euxo pipefail

name=iwe-linux-pam-build
ver=latest

start=`date`
echo "== Build start: $start"

# Setup the environment
. $GITHUB_WORKSPACE/ubuntu18/env.sh

# Start the build
cd $UPSTREAM_DIR

# Selectively edit the packaging files
DEB_FRIENDLY_CISCO_VERSION=`echo $CISCO_VERSION | sed -e 's/+/-/'`
sed -i \
    -e 's/@UPSTREAM_VERSION@/'$SOURCE_PACKAGE_VERSION/ \
    -e 's/@CISCO_VERSION@/'$DEB_FRIENDLY_CISCO_VERSION/ \
    debian/changelog

# Make the Cisco version JSON
$GITHUB_WORKSPACE/tools/create-version-json.sh \
    $SOURCE_PACKAGE_VERSION "$CISCO_VERSION" \
    cisco-package-version.json

echo cisco-package-version.json >> debian/libpam0g-cisco.docs

# Do the actual build
debuild -i --build=binary -us -uc

# Bundle up the output
cd ..
mkdir "${OUTNAME}"
mv *deb *build *buildinfo *changes "${OUTNAME}"
tar cvf "${OUTNAME}.tar" "${OUTNAME}"

end=`date`
echo "== Build start: $start"
echo "== Build end:   $end"
