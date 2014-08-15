debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password 123'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password 123'

cat /vagrant/hosts >> /etc/hosts
echo "$3 $1" >> /etc/hosts

printf "Running Update"
apt-get update > /dev/null 2>&1

printf "Running Upgrade"
apt-get upgrade > /dev/null 2>&1

printf "Installing Packages"
apt-get -y -q install python-software-properties build-essential apache2 mysql-server libapache2-mod-auth-mysql libapache2-mod-php5 php5 php5-mysql php5-mcrypt php5-memcached php5-curl memcached libmemcached-tools libmemcached-dev libcurl3 libcurl4-gnutls-dev curl vim wget git default-jre > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1 && sudo mv composer.phar /usr/local/bin/composer
gem install sass > /dev/null 2>&1

printf "Configuring Packages"
cat /vagrant/database | mysql -uroot -p123
sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sed -i '/short_open_tag = Off/c short_open_tag = On' /etc/php5/apache2/php.ini
sed -i '/short_open_tag = Off/c short_open_tag = On' /etc/php5/cli/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
cp /vagrant/vhost /etc/apache2/sites-available/site.conf
echo "User vagrant" >> /etc/apache2/apache2.conf
echo "Group vagrant" >> /etc/apache2/apache2.conf

printf "Enable Site"
chown vagrant: /var/www
a2enmod rewrite > /dev/null 2>&1
a2ensite site.conf > /dev/null 2>&1
a2dissite 000-default.conf > /dev/null 2>&1
service apache2 reload > /dev/null 2>&1

printf "Done!"