#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Check if PORT is set, otherwise set default value
if [ -z "${PORT:-}" ]; then
    PORT=12345
fi

# Check if PASS is set, otherwise set default value
if [ -z "${PASS:-}" ]; then
    PASS=12345
fi

# change the sshd port
sed -i "s/12345/$PORT/" /etc/ssh/sshd_config

# change the root password
echo "root:$PASS" | chpasswd

# start sshd
service ssh start

tail -f /dev/null