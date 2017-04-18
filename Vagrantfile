# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

#read configuration file
current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs']


#assign all variables
KRYPTO_BLOG_PATH = vagrant_config['krypto_blog']['code_path']
MLP_PATH = vagrant_config['mlp_proxy']['code_path']
STRIPE_GW_PATH = vagrant_config['stripe_gw']['code_path']

CERT_NAME = vagrant_config['ssl_certificate']['name']
CERT_EMAIL_ADDRESS = vagrant_config['ssl_certificate']['email']

KRYPTO_BLOG_IP = vagrant_config['krypto_blog']['private_ip']
MLP_IP = vagrant_config['mlp_proxy']['private_ip']
STRIPE_GW_IP = vagrant_config['stripe_gw']['private_ip']

SECRET_KEY = vagrant_config['stripe_gw']['secret_key']
PUBLISHABLE_KEY = vagrant_config['stripe_gw']['publishable_key']



Vagrant.configure(2) do |config|
	# Use a box with ubuntu 16.04
	config.vm.box = "ubuntu/xenial64"

	# Set up SSH agent forwarding.
	config.ssh.forward_agent = true	

	### KRYPTO BLOGGER BOX ###
	config.vm.define "kryptoblog_box" do |kryptoblog_box|
		kryptoblog_box.vm.network "private_network", ip: KRYPTO_BLOG_IP
		kryptoblog_box.vm.network :forwarded_port, host: 8080, guest: 80
		kryptoblog_box.vm.network :forwarded_port, host: 8443, guest: 443
		
    	kryptoblog_box.vm.provision "shell", path: "krypto-blog/bin/script.sh", args: [CERT_NAME, CERT_EMAIL_ADDRESS], privileged: true

		kryptoblog_box.vm.synced_folder KRYPTO_BLOG_PATH, "/var/www/html"
  	end

	### MLP BOX ###
	config.vm.define "mlp_box" do |mlp_box|
		mlp_box.vm.network "private_network", ip: MLP_IP
		mlp_box.vm.network :forwarded_port, host: 5080, guest: 5080	
		mlp_box.vm.network :forwarded_port, host: 5443, guest: 5443	
		
		
    	mlp_box.vm.provision "shell", path: "mlp-proxy/bin/script.sh", privileged: true
    	mlp_box.vm.provision "shell", path: "mlp-proxy/bin/user-script.sh", args: [CERT_NAME, CERT_EMAIL_ADDRESS], privileged: false

		mlp_box.vm.synced_folder MLP_PATH, "/home/ubuntu/krypto-mlp-mockup"
  	end

	### STRIPE GATEWAY BOX ###
	config.vm.define "stripe_box" do |stripe_box|
		stripe_box.vm.network "private_network", ip: STRIPE_GW_IP
		stripe_box.vm.network :forwarded_port, host: 5090, guest: 5090	
		stripe_box.vm.network :forwarded_port, host: 5943, guest: 5943	
		
    	stripe_box.vm.provision "shell", path: "stripe-gw/bin/script.sh", privileged: true
    	stripe_box.vm.provision "shell", path: "stripe-gw/bin/user-script.sh", args: [CERT_NAME, CERT_EMAIL_ADDRESS, SECRET_KEY, PUBLISHABLE_KEY], privileged: false

		stripe_box.vm.synced_folder STRIPE_GW_PATH, "/home/ubuntu/krypto-checkout-gw"
  	end


end

#check if SSH agent is running with keys, if not add them
`ssh-add -l`
 
if not $?.success?
	puts 'Your SSH does not currently contain any keys (or is stopped.)'
	puts 'Adding keys...'
	`ssh-add ~/.ssh/id_rsa`
end
