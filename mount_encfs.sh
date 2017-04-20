#!/bin/bash
ENCFS_DIR=$HOME/icloud/encfs/hg/liblinear
MOUNT_DIR=$HOME/encfs/hg/liblinear

echo "Mounting $ENCFS_DIR using encfs at $MOUNT_DIR..." &&
mkdir -p $MOUNT_DIR &&
encfs --extpass="echo bQ2e0sUOs1dNisbXReeAB7Yg6BQi44cSHRyG9FUq7z2ceS0wuT" $ENCFS_DIR $MOUNT_DIR &&
echo " done."


# Get the directory where the running script is located.
# http://stackoverflow.com/questions/59895/
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Mount the patches repository.
P_MOUNT_SCRIPT="$DIR/.hg/patches/mount_encfs.sh"
if [[ -x "$P_MOUNT_SCRIPT" ]]
then
   eval "$P_MOUNT_SCRIPT"
fi
