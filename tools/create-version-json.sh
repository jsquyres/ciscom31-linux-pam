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

# Developers may have more than 1 remote.  Make a best guess as to
# what the real repo is.
file=git-remotes.$$.txt
rm -f $file
git remote -v | grep fetch | awk '{ print $2 }' > $file
wcl=`wc -l $file | awk '{ print $1 }'`
if test "$wcl" -eq 1; then
    SOURCE_GIT_REPO=`cat $file`
else
    tmp="`grep CiscoM31 $file`"
    if test -n $tmp; then
        SOURCE_GIT_REPO=$tmp
    else
        SOURCE_GIT_REPO="`cat $file | head -n 1`"
    fi
fi
rm -f $file
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
