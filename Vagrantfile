$pwd = File.basename(File.expand_path(Dir.pwd + "/../."))
$cfg = '../app/tinyvag.yml'

data = {
    'hostname'  => $pwd << '.vag',
    'bootstrap' => '../vendor/justinhilles/tinyvag/bootstrap.sh',
    'shared'    => '../.',
    'public'    => '/var/www/site',
    'doc_root'  => '/var/www/site',
    'mem'       => 2048,
    'cpus'      => 4,
    'box'       => 'ubuntu/trusty64'
}

if File.exist?($cfg)
puts $cfg
    require 'yaml'
    data.merge!(YAML::load(File.open($cfg)))
end

puts data

Vagrant.configure('2') do |config|
    config.vm.box       = data['box']
    config.vm.host_name = data['hostname']
    config.vm.synced_folder data['shared'], data['public'], type: 'nfs'

    if data.has_key?('ip')
        config.vm.network "private_network", ip: data['ip']
    else
        config.vm.network 'private_network', type: 'dhcp'
    end

    config.vm.provider :virtualbox do |v|
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--name', data['hostname']]
        v.customize ['modifyvm', :id, '--memory', data['mem']]
        v.customize ['modifyvm', :id, '--cpus', data['cpus']]
    end

    config.vm.provision :shell, :path => data['bootstrap'], args: [data['hostname'], '127.0.0.1', data['doc_root']]
end
