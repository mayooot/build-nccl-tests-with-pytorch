# Build-NCCL-Tests-With-PyTorch

![license](https://img.shields.io/hexpm/l/plug.svg)
[![docker](https://img.shields.io/docker/pulls/mayooot/nccl-tests-with-pytorch.svg)](https://hub.docker.com/r/mayooot/nccl-tests-with-pytorch)

# Overview

Build [NCCL-Tests](https://github.com/NVIDIA/nccl-tests) and configure SSHD in PyTorch container to help you test NCCL
faster!

PyTorch Version: 23.11

# Quick Start

~~~shell
docker pull mayooot/nccl-tests-with-pytorch:v0.0.1
~~~

# Build From Source

~~~shell
git clone https://github.com/mayooot/build-nccl-tests-with-pytorch
cd build-nccl-tests-with-pytorch

docker build -t nccl-tests-with-pytorch:latest .
~~~

# Usage

The default values for `PORT` and `PASS` are 12345, you can replace them with `-e`.

In addition, you need to mount the host's `id_rsa` and `id_rsa.pub` to the container.

~~~shell
docker run --name foo \
  -d -it \
  --network=host \
  -e PORT=1998 -e PASS=P@88w0rd \
  -v /tmp/id_rsa:/root/.ssh/id_rsa \
  -v /tmp/id_rsa.pub:/root/.ssh/id_rsa.pub \
  --gpus all --shm-size=1g \
  --cap-add=IPC_LOCK --device=/dev/infiniband \
  mayooot/nccl-tests-with-pytorch:v0.0.1 
~~~

The code and executable for NCCL-Tests is located in `/nccl-tests`, so let me show you how to use it,
using `all_reduce_perf` as an example.

Before using `all_reduce_perf`, you need to configure SSH intercommunication.

~~~shell
ssh-copy-id -p 1998 root@all_cluster_ip
~~~

Please replace `--host cluster_ip1,cluster_ip2,...` to the real cluster's IP address.

~~~shell
docker exec -it foo bash

cd /nccl-tests

mpirun --allow-run-as-root \
  -mca plm_rsh_args "-p 1998" \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_HCA=mlx5_10,mlx5_11,mlx5_12,mlx5_13,mlx5_14,mlx5_15,mlx5_16,mlx5_17 \
  --host cluster_ip1,cluster_ip2,... \
  ./build/all_reduce_perf \
  -b 1G -e 4G -f 2 -g 8
~~~

# Contribute

Feel free to open issues and pull requests. Any feedback is highly appreciated!