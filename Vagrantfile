# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "ubuntu-osb"

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 7001, host: 7001 
  config.vm.network :forwarded_port, guest: 7002, host: 7002 
  # config.vm.network :forwarded_port, guest: 8453, host: 8453
  # config.vm.network :forwarded_port, guest: 7453, host: 7453

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM
    vb.customize ["modifyvm", :id,
                  "--name", "ubuntu-osb",
                  "--memory", "2048",
                  "--natdnshostresolver1", "on"]
    vb.gui = false
  end

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "site.pp"
    puppet.options = "--verbose --trace"
  end
end
