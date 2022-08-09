FROM nvidia/cuda:11.7.0-devel-ubuntu20.04 AS devel-base

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
    ./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-vaapi --enable-libass --enable-libmfx && \
    make -j 8 && make install

RUN rm -rf /ffmpeg

RUN DEBIAN_FRONTEND=noninteractive apt remove -y git cmake g++

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
