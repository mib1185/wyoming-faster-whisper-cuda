FROM debian:12

ARG WYOMING_FASTER_WHIPSER_VERSION=2.2.0
ARG NVIDIA_DRIVER_VERSION=570.153.02

# install requirements
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pip wget kmod \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install nvidia linux drivers
RUN cd /tmp \
    && wget "https://de.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run" \
    && chmod +x NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run \
    && bash -c "./NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run -s --no-kernel-module" \
    $$ rm NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run

# install wyoming-faster-whisper and nvidia cuda libs
RUN python3 -m pip install --no-cache-dir --break-system-packages "wyoming-faster-whisper @ https://github.com/rhasspy/wyoming-faster-whisper/archive/refs/tags/v${WYOMING_FASTER_WHIPSER_VERSION}.tar.gz" \
    && python3 -m pip install --no-cache-dir --break-system-packages nvidia-cublas-cu12 nvidia-cudnn-cu12==9.*

EXPOSE 10300/tcp
VOLUME [ "/data" ]
    
COPY run.sh /

ENTRYPOINT [ "/run.sh" ]
