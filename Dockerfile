FROM nvcr.io/nvidia/pytorch:23.11-py3

WORKDIR /

# change the download source of apt, comment it out if you are abroad
COPY sources.list /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y openssh-server vim curl inetutils-ping net-tools telnet lsof

COPY start.sh /start.sh
COPY sshd_config /etc/ssh/sshd_config
COPY nccl-tests /nccl-tests

CMD ["/bin/bash", "start.sh"]