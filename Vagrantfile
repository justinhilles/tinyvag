hostname = "site.localhost"
bootstrap_file = "bootstrap.sh"
shared_folder = "../../../."
public_folder = "/var/www/html/site"
ip = "192.168.56.101"
memory = 2048

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.network :private_network, ip: ip
    config.vm.synced_folder shared_folder, public_folder
    config.vm.host_name = hostname

    config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", memory]
        v.customize ["modifyvm", :id, "--name", hostname]
    end

    config.vm.provision :shell, :path => bootstrap_file, args: [hostname, ip]
end