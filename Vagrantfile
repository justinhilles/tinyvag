hostname = "site.localhost"
host_aliases = %w("")
bootstrap_file = "bootstrap.sh"
shared_folder = "../."
public_folder = "/var/www/html/site"
ip = "192.168.56.101"
memory = 2048

Vagrant.configure("2") do |config|
    config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box"
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