#!/bin/sh

cd ~
[ -d krypto-checkout-gw] || mkdir krypto-checkout-gw

### Create the SSL Certificate
openssl genrsa -out stripe.key 2048
openssl req -new -key stripe.key -out stripe.csr -subj "/C=US/ST=California/L=Santa Clara/O=Ericsson/OU=BMDA/CN=$1/emailAddress=$2"
openssl x509 -req -days 365 -in stripe.csr -signkey stripe.key -out stripe.crt

cp stripe.crt /vagrant

### Start server
cd krypto-checkout-gw

[ -d boxenv ] || rm -rf boxenv
virtualenv boxenv
boxenv/bin/pip install --upgrade pip
boxenv/bin/pip install -r requirements.txt

tmux new-session -s server -d "SECRET_KEY=$3 PUBLISHABLE_KEY=$4 boxenv/bin/uwsgi --ini app.ini"
