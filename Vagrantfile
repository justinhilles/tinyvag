$pwd = File.basename(File.expand_path(Dir.pwd + "/../."))
$cfg = ['../app/vagrant.yml', '../vagrant.yml', 'vagrant.yml']
$hostname = $pwd << '.vagrant'
@default_file = '../vendor/justinhilles/tinyvag/bootstrap.sh'

data = {
    'hostname'  => $hostname,
    'provision' => {},
    'shared'    => '../.',
    'public'    => '/var/www/site',
    'doc_root'  => '/var/www/site',
    'mem'       => 1024,
    'cpus'      => 1,
    'box'       => 'ubuntu/trusty64'
}

$cfg.each do |file|
    puts "Finding File #{file}"
    if File.exist?(file)
        puts "Found #{file}"
        require 'yaml'
        puts YAML::load(File.open(file))
        data.merge!(YAML::load(File.open(file)))
    end
end

data['provision'][@default_file] = [data['hostname'], '127.0.0.1', data['doc_root']]
data['provision'] = data['provision'].merge(data['provision_extra'])

puts data

Vagrant.configure('2') do |config|
    config.vm.box       = data['box']
    config.vm.host_name = data['hostname']
    config.vm.synced_folder data['shared'], data['public'], type: 'nfs'

    if data.has_key?('ip')
        config.vm.network "private_network", ip: data['ip']
    else
        config.vm.network "private_network", type: 'dhcp'
    end

    config.vm.provider :virtualbox do |v|
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--name', data['hostname']]
        v.customize ['modifyvm', :id, '--memory', data['mem']]
        v.customize ['modifyvm', :id, '--cpus', data['cpus']]
    end

    data['provision'].each do |bootstrap, arguments|
        if File.exist?(bootstrap)
            puts "Running '#{bootstrap}' with #{arguments}"
            config.vm.provision "shell", path: bootstrap, args: arguments
        end
    end
end
