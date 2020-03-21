#!/bin/sh

# Initialize ccache if needed
if [ ! -f ${CCACHE_DIR}/ccache.conf ]; then
	echo "Initializing ccache in /srv/ccache..."
	ccache -M ${CCACHE_SIZE}
fi

# in Docker, the USER variable is unset by default
# but some programs (like jack toolchain) rely on it
export USER="$(whoami)"

# Begin build
repo init -u https://github.com/LineageOS/android.git -b $1

repo sync
source build/envsetup.sh
breakfast $2

croot
brunch $2

