#!/bin/bash
#
# This script is designed to run in the container built by the
# Dockerfile.

set -euxo pipefail

SOURCE_PACKAGE_VERSION=$1
CISCO_VERSION=$2
OUTPUT_FILE=$3

# Sanity check
if test -z "$SOURCE_PACKAGE_VERSION" -o -z "$CISCO_VERSION"; then
    echo "Usage: $0 SOURCE_PACKAGE_VERSION CISCO_VERSION"
    exit 1
fi

SOURCE_GIT_REPO=$(git remote -v | grep fetch | awk '{ print $2 }')
SOURCE_GIT_DESCRIBE=$(git describe --always)
SOURCE_GIT_HASH=$(git rev-parse HEAD)

rm -f $OUTPUT_FILE
cat > $OUTPUT_FILE <<EOF
{
    "package version" : "$SOURCE_PACKAGE_VERSION",
    "cisco version" : "$CISCO_VERSION",

    "source git repo" : "$SOURCE_GIT_REPO",
    "source git describe" : "$SOURCE_GIT_DESCRIBE",
    "source git hash" : "$SOURCE_GIT_HASH",
}
EOF

cat $OUTPUT_FILE
