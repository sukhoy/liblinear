#!/bin/bash
MOUNT_DIR=$HOME/encfs/hg/liblinear
echo "Unmounting $MOUNT_DIR" &&
umount "$MOUNT_DIR"

# Get the directory where the running script is located.
# http://stackoverflow.com/questions/59895/
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Unmount the patches repository
UMOUNT_SCRIPT="$DIR/.hg/patches/umount_encfs.sh"
if [[ -x "$UMOUNT_SCRIPT" ]]
then
   eval "$UMOUNT_SCRIPT"
fi
