#!/bin/sh

apt-get update
apt-get -y install build-essential
apt-get -y install libssl-dev libffi-dev python-dev python-pip virtualenv tmux


### Allowing ports for FULL NGINX
ufw allow 'OpenSSH'
ufw allow 5080
ufw allow 5443
echo "y" | ufw enable
