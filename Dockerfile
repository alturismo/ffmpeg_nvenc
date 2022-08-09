FROM nvidia/cuda:11.7.0-devel-ubuntu20.04
RUN apt update && apt install -y git build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev pkg-config

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install && \
    cd ..

RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/ && cd ffmpeg && \
    ./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 && \
    make -j 8 && make install

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
