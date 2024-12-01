# wyoming-faster-whisper-cuda

This takes the [wyoming-faster-whisper](https://github.com/rhasspy/wyoming-faster-whisper) and wraps it into an nvidia cuda supported container.

**Note** This is only supported on x86_64 systems, yet.

## Usage

### Prerequisits

1. nvidia cuda compatible gpu
2. [nvidia linux drivers](https://www.nvidia.com/en-us/drivers/unix) installed on the host
3. up and running [docker](https://docs.docker.com/engine/install) installation on the host

### Installation

1. download this repo

    ```shell
    $ git clone https://github.com/mib1185/wyoming-faster-whisper-cuda.git
    ```

2. `compose.yaml` file

    create a `compose.yaml` file, which:

    - builds from the local `Dockerfile`
    - adds the needed parameters for `model` and `language` as command line parameter
    - (_optional_) enables `debug` logging via command line parameter
    - provides a `data` volume or directory
    - exposes the port `10300/tcp`
    - maps your nvidia gpu related devices into the container (_obtain with `ls -la /dev/nvidia*`_)
    - (_optional_) set `restart: always`

    **example `compose.yaml` file**

    ```yaml
    name: wyoming
    services:
    faster-whisper-cuda:
      container_name: faster-whisper-cuda
      build: .
      command: "--model large --language de --debug"
      volumes:
        - ./data:/data
      ports:
        - 10300:10300/tcp
      devices:
        - /dev/nvidia-uvm:/dev/nvidia-uvm
        - /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools
        - /dev/nvidia0:/dev/nvidia0
        - /dev/nvidiactl:/dev/nvidiactl
      restart: always
    ```

3. start service

    on first start, the docker image is build, which needs some time

    ```shell
    $ docker compose up -d
    ```

4. check if service is running

    ```shell
    $ docker ps
    CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                                           NAMES
    474e37a84326   wyoming-faster-whisper-cuda   "/run.sh --model lar…"   3 minutes ago   Up 3 minutes   0.0.0.0:10300->10300/tcp, :::10300->10300/tcp   faster-whisper-cuda
    ```