#!/bin/bash

# This file is sourced from a few scripts so that we can have common
# data values.

# Get the upper-level env.sh
# We might be running directly as "env.sh", or we might be running as
# a temp script in a Github Action.
base=`basename $0`
if test "$base" == "env.sh"; then
    dir=`dirname $0`
    . $dir/../env.sh
elif test -n "$GITHUB_WORKSPACE"; then
    . $GITHUB_WORKSPACE/env.sh
else
    if test -r "../env.sh"; then
        . ../env.sh
    elif test -r "env.sh"; then
        . ./env.sh
    else
        echo "ERROR: Could not find top-level env.sh"
        exit 1
    fi
fi

# The rest of this env.sh is specific to the Ubuntu 18 package

# Cisco version
export CISCO_VERSION=+1cisco1

# Info about the source
export UPSTREAM_VERSION=1.3.1
export UPSTREAM_DIR=$GITHUB_WORKSPACE/ubuntu20/Linux-PAM-${UPSTREAM_VERSION}
export SOURCE_PACKAGE_VERSION=${UPSTREAM_VERSION}-5ubuntu4.3

# Name of the output directory and tarball
export OUTNAME=libpam0g-ubuntu20-with-4k-misc-buffer
