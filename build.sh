#!/bin/bash

# Initialize ccache if needed
if [ ! -f ${CCACHE_DIR}/ccache.conf ]; then
	echo "Initializing ccache in /srv/ccache..."
	ccache -M ${CCACHE_SIZE}
fi

# in Docker, the USER variable is unset by default
# but some programs (like jack toolchain) rely on it
export USER="$(whoami)"
export PATH="$HOME/bin:$PATH"

# Begin downloading sources
repo init -u https://github.com/LineageOS/android.git -b $1
repo sync

# Fix environment variables
. build/envsetup.sh
#ln -s lineage/vendor/lineage lineage/vendor/cm
#export ROOMSERVICE_BRANCHES="$4"
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# Extract Binary Blobs from firmware extract
#cd $HOME/android/lineage/device/$2/$3
#./extract-files.sh ~/android/system/
ln -s $HOME/android/samsung $HOME/android/lineage/vendor/samsung

# Start building
cd $HOME/android/lineage
breakfast $3

croot
brunch $3

# Exiting..
cd $OUT
printf "\nYour ROM file is $OUT/$(ls *.zip)\n"
