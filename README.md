# VAGRANT BOXES

There are currently three Vagrant boxes for Krypto
1. __kryptoblog_box__: Website of the krypto blogger. THe box is running an Ubuntu 16.04 machine and serving a website on NGINX over SSL.
2. __mlp_box__: Proxy server to Manifold server. The box is running on Ubuntu 16.04 and serving a Python/Flask server over SSL.
3. __stripe_box__: Stripe Payment Gateway. The box running on Ubuntu 16.04 and serving a a Python/Flask server over SSL.

## Vagrant configuration
Before starting, copy the config_template.yaml file to config.yaml and edit the followings:

### Link your Vagrant boxes with your local code
```
configs -> krypto_blog -> code_path = <path to krypto-blog-frontend>
configs -> mlp_proxy -> code_path = <path to krypto-mlp-mockup>
configs -> stripe_gw -> code_path = <path to krypto-checkout-gw>
```

### Configure the ip addresses of your Vagrant boxes (optional)
The private IPs are already set but you can change them if you desire to.
```
__configs -> krypto_blog -> private_ip__ = <krypto blog ip address>
__configs -> mlp_proxy -> private_ip__ = <mlp ip address>
__configs -> stripe_gw -> private_ip__ = <stripe gateway ip address>
```

### Configure the CERT files information (email address) for all your Vagrant boxes
All Vagrant boxes need to create CERT files to be able to serve on SSL. Edit the following variable with your email address and the ip address of your host machine. 

| type _ifconfig -a_ to find the public ip address of your host machine |


```
name = <public ip address of your HOST machine>
email = <your email address>
```

### STRIPE Configuration
Edit your keys for STRIPE
```
SECRET_KEY = ""
PUBLISHABLE_KEY = ""
```


## Deploy Krypto
From the root of this directory (at the same level of Vagrantfile), you can start all the boxes all at once:

```shell
vagrant up
```

You can also start each box separately:

```shell
vagrant up kryptoblog_box
```

```shell
vagrant up mlp_box
```


```shell
vagrant up stripe_box
```

_IMPORTANT_
You need to edit config.json of krypto_blog_frontend project and change the IP addresses of __mlp_proxy_url__ and __stripe_gw_url__ with a URL that includes the public ip address of your host machine.

| type _ifconfig -a_ to find the public ip address of your host machine |


## Monitor Krypto
### BLOG
```shell
vagrant ssh kryptoblog_box
tail -f /var/log/nginx/access.log
```


### MLP PROXY
```shell
vagrant ssh mlp_box
tmux attach -t server
```

To detach from TMUX: 
```
Ctrl-b d
```

To restart a  new TMUX screen and start the server
```
tmux new-session -s server
cd krypto-mlp-mockup
boxenv/bin/uwsgi --ini app.ini
```

### STRIPE GW
```shell
vagrant ssh stripe_box
tmux attach -t server
```

To detach from TMUX: 
```
Ctrl-b d
```

To stop the server
```
Ctrl-C
```

To restart a  new TMUX screen and start the server
```
tmux new-session -s server
cd krypto-mlp-mockup
boxenv/bin/uwsgi --ini app.ini
```


# RUNNING THE DEMO ON iOS

##Set up the Apple Pay Sandbox and Setting iCloud on iOS
If you don't have a tester account yet, follow the instructions to setup a tester account for Apple Pay [https://stripe.com/docs/apple-pay/web](https://stripe.com/docs/apple-pay/web)

To use Apple Pay while developing your site, you'll need to use the Apple Pay Sandbox. Getting it set up takes just a few minutes.
1. If you don't have one already, create an [Apple Developer account](https://developer.apple.com/).
2. Log into [iTunes Connect](https://itunesconnect.apple.com/).
3. Select Users and Roles, then select the Sandbox Testers link at the top of the page.
4. Next to "Testers", click ⊕ to create a new test user. Fill out the page, taking note of the email and password you used, and click Save in the upper right.
5. On your test iOS device, open the Settings app and tap iCloud. If you're signed in, tap Sign Out at the bottom.
6. Log in using the new test credentials you just made.
7. Tap Back to return to the first page in Settings, then tap Wallet & Apple Pay.
8. Tap Add Credit or Debit Card, then when prompted to photograph your card tap Enter Card Details Manually.
9. Enter 4761 1200 1000 0492, expiration 11/2022, CVV 533 (this is a test Visa card; for more test cards see the [Apple Pay Sandbox Guide](https://developer.apple.com/support/apple-pay-sandbox/)).

## Install the certificates on iOS
Each Vagrant box will create certificate (at the root level of this directory) to allow the running servers to be trusted on your machine.
- kryptoblog_vagrant.p12 (certificate for the blogger website)
- mlp_vagrant.p12 (certificate for the MLP proxy)
- stripe_vagrant.p12 (certificate for the Stripe gateway)

Install these certificates on your device and trust them. (_Tip: use Airdrop to send the certificates over your device._)

## Launch the blog website on iOS
Open Mobile Safari on your device and open the following URL:
__https://<ip_address_of_your_host_machine>:8443__

The IP address of your host machine is the public IP address that you kind find by typing _ifconfig -a_.


# RUNNING THE DEMO ON MacOS + iPhone
If you would like to run the demo using the MacOS, you can use it pairing with an iPhone to confirm the payment with TouchID.

The steps are similar to the previous section (Running the demo on iOS):
- Make sure you login with the iCloud tester account on your Mac.
- Install the certificates on your Mac
    - kryptoblog_vagrant.p12 (certificate for the blogger website)
    - mlp_vagrant.p12 (certificate for the MLP proxy)
    - stripe_vagrant.p12 (certificate for the Stripe gateway)
- Launch the blog website on Safari with the following URL: __https://<ip_address_of_your_host_machine>:8443__



