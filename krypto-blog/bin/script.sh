#!/bin/sh

apt-get update
apt-get -y install build-essential
apt-get -y install nginx tmux



### Configure Nginx to Use SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=California/L=Santa Clara/O=Ericsson/OU=BMDA/CN=$1/emailAddress=$2" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

cp /etc/ssl/certs/nginx-selfsigned.crt /vagrant/kryptoblog-vagrant.p12

cp /vagrant/krypto-blog/nginx/self-signed.conf /etc/nginx/snippets/ 
cp /vagrant/krypto-blog/nginx/ssl-params.conf /etc/nginx/snippets/

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
cp /vagrant/krypto-blog/nginx/default /etc/nginx/sites-available/


### Allowing ports for FULL NGINX
ufw allow 'Nginx Full'
ufw allow 'OpenSSH'
echo "y" | ufw enable

### Restart NGINX
systemctl restart nginx
