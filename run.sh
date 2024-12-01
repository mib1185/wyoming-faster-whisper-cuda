#!/bin/bash

export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`

python3 -m wyoming_faster_whisper --uri tcp://0.0.0.0:10300 --data-dir /data --download-dir /data --device cuda "$@"
