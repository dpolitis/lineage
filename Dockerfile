# Build environment for LineageOS

FROM ubuntu:16.04

ENV CCACHE_SIZE=50G \
    CCACHE_DIR=/srv/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1

# Fix repositories
RUN sed -i 's/main$/main universe/' /etc/apt/sources.list; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
        bc \
        bison \
        build-essential \
        ccache \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        gnupg \
        gperf \
        imagemagick \
        lib32ncurses5-dev \
        lib32readline-dev \
        lib32z1-dev \
        liblz4-tool \
        libncurses5-dev \
        libsdl1.2-dev \
        libssl-dev \
        libwxgtk3.0-dev \
        libxml2 \
        libxml2-utils \
        lzop \
        pngcrush \
        rsync \
        schedtool \
        squashfs-tools \
        xsltproc \
        zip \
        zlib1g-dev \
        android-tools-adb \
        android-tools-fastboot; \
    apt-get -o Dpkg::Options::="--force-overwrite" install -y openjdk-8-jdk; \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -U --uid 1000 build; \
    mkdir -p /home/build/bin; \
    mkdir -p /home/build/android/lineage; \
    chown -R build:build /home/build

RUN curl -k https://storage.googleapis.com/git-repo-downloads/repo > /home/build/bin/repo; \
    chmod a+x /home/build/bin/repo

COPY --chown=build:build build.sh /home/build/build.sh
ADD  --chown=build:build files/i9300_blobs.tar.xz /home/build/android/

RUN chmod a+x /home/build/build.sh

USER build
WORKDIR /home/build/android/lineage

ENTRYPOINT ["/home/build/build.sh"]
CMD ["cm-14.1", "samsung", "i9300", "cm-14.1"]
