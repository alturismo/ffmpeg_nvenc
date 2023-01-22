FROM nvidia/cuda:11.7.0-devel-ubuntu20.04 AS devel-base

ENV	    NVIDIA_DRIVER_CAPABILITIES compute,utility,video
ENV	    DEBIAN_FRONTEND=nonintercative
WORKDIR     /tmp/workdir

RUN export TZ=Europe/Berlin && \
    apt-get update && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev pkg-config \
    i965-va-driver vainfo apt-utils libnuma-dev libass-dev tar libva-dev libmfx-dev intel-media-va-driver-non-free g++ libsdl2-dev libbluray-dev libx264-dev libx265-dev wget

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install && \
    cd .. \
    rm -rf /nv-codec-headers

RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/ && cd ffmpeg && \
    ./configure --enable-nonfree --enable-vaapi --enable-libass --enable-libmfx --enable-cuda --enable-cuvid --enable-cuda-nvcc --enable-libbluray --enable-libnpp --enable-libx264 --enable-libx265 --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 && \
    make -j 8 && make install

RUN rm -rf /ffmpeg

RUN DEBIAN_FRONTEND=noninteractive apt remove -y git cmake g++ && \
    apt -y autoremove && \
    apt -y clean

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
