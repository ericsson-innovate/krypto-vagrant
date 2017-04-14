# VAGRANT BOXES

There are currently three Vagrant boxes for Krypto
1. __kryptoblog_box__: Website of the krypto blogger. THe box is running an Ubuntu 16.04 machine and serving a website on NGINX over SSL.
2. __mlp_box__: Proxy server to Manifold server. The box is running on Ubuntu 16.04 and serving a Python/Flask server over SSL.
3. __stripe_box__: Stripe Payment Gateway. The box running on Ubuntu 16.04 and serving a a Python/Flask server over SSL.

## Vagrant configuration

### Link your Vagrant boxes with your local code
Edit Vagrantfile and change the following variables:
```
KRYPTO_BLOG_PATH = <path to krypto blog website code (krypto-blogger-frontend)>
MLP_PATH = <path to Manifold proxy code (krypto-mlp-proxy)>
STRIPE_GW_PATH = <path to Krypto payment gateway (krypto-checkout-gw)>
```

### Configure the ip addresses of your Vagrant boxes (optional)
Edit Vagrantfile and choose the private IPs for every box if desired
```
KRYPTO_BLOG_IP = <krypto blog ip address>
MLP_IP = <mlp ip address>
STRIPE_GW_IP = <stripe gateway ip address>
```
After changing the IP addresses, make sure to edit krypto_blogger_frontend/index.html and change the ip addresses accordingly.

### Configure the CERT files information (email address) for all your Vagrant boxes
All Vagrant boxes need to create CERT files to be able to serve on SSL. Edit the following variable with your email address.
```
CERT_EMAIL_ADDRESS = <your email address>
```

### STRIPE Configuration
Edit Vagrantfile and edit your keys for STRIPE
```
SECRET_KEY = ""
PUBLISHABLE_KEY = ""
```


## Running Krypto
From the root of this directory (at the same level of Vagrantfile), you can start all the boxes all at once:

```shell
vagrant up
```

You can also start each box separately:

```shell
vagrant up kryptoblog_box
```

```shell
vagrant up mlp-box
```


```shell
vagrant up stripe_box
```

## Installing the certificates on your computer
Each Vagrant box will create certificate (at the root level of this directory) to allow the running servers to be trusted on your machine.
- nginx-selfsigned.crt (certificate for the blogger website)
- mlp.crt (certificate for the MLP proxy)
- stripe.crt (certificate for the Stripe gateway)

Install these certificates on your machine and trust them.

Open the certificate

![Open Certificate](/images/cert1.png)


Find the certificate on your system

![Find Certificate](/images/cert2.png)

Trust the certificate to be used with SSL and with X.509 Basic Policy

![Trust Certificate](/images/cert3.png)

## Monitoring Krypto

### MLP PROXY
```shell
vagrant ssh mlp-box
tmux attach -t server
```

To detach from TMUX: 
```
Ctrl-b d
```


### STRIPE GW
```shell
vagrant ssh strip
tmux attach -t server
```

To detach from TMUX: 
```
Ctrl-b d
```
