#!/bin/sh

cd ~
[ -d krypto-mlp-mockup ] || mkdir krypto-mlp-mockup 

### Create the SSL Certificate
openssl genrsa -out mlp.key 2048
openssl req -new -key mlp.key -out mlp.csr -subj "/C=US/ST=California/L=Santa Clara/O=Ericsson/OU=BMDA/CN=$1/emailAddress=$2"
openssl x509 -req -days 365 -in mlp.csr -signkey mlp.key -out mlp.crt

cp mlp.crt /vagrant/mlp-vagrant.p12

### Start server
cd krypto-mlp-mockup


[ -d boxenv ] || rm -rf boxenv
virtualenv boxenv
boxenv/bin/pip install --upgrade pip
boxenv/bin/pip install -r requirements.txt

tmux new-session -s server -d 'boxenv/bin/uwsgi --ini app.ini'

