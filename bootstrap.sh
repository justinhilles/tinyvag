[[ -z $1 ]] && { echo "!!! Hostname not set. Check the Vagrant file."; exit 1; }

debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password 123'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password 123'

echo "$2 $1" >> /etc/hosts

printf "Running Update"
apt-get update

printf "Running Upgrade"
apt-get upgrade

printf "Installing Packages"
apt-get -y -q install python-software-properties build-essential apache2 mysql-server libapache2-mod-auth-mysql libapache2-mod-php5 php5 php5-mysql php5-mcrypt php5-memcached php5-curl memcached libmemcached-tools libmemcached-dev libcurl3 libcurl4-gnutls-dev curl vim wget git default-jre
curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer
gem install sass

printf "Configuring Packages"
mysql -uroot -p123 -e 'CREATE DATABASE IF NOT EXISTS `site`;CREATE USER `site`@`localhost` IDENTIFIED BY "123";GRANT ALL ON `site`.* TO `site`@`localhost`;FLUSH PRIVILEGES;'

sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sed -i '/short_open_tag = Off/c short_open_tag = On' /etc/php5/apache2/php.ini
sed -i '/short_open_tag = Off/c short_open_tag = On' /etc/php5/cli/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
echo "<VirtualHost *:80>
    ServerName $1
    DocumentRoot $3
    <Directory $3>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        DirectoryIndex app_dev.php app.php index.php
        Allow from all
        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{REQUEST_URI}::\$1 ^(/.+)/(.*)::\2$
            RewriteRule ^(.*) - [E=BASE:%1]
            RewriteCond %{HTTP:Authorization} .
            RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
            RewriteCond %{ENV:REDIRECT_STATUS} ^$
            RewriteRule ^app\.php(/(.*)|$) %{ENV:BASE}/\$2 [R=301,L]
            RewriteCond %{REQUEST_FILENAME} -f
            RewriteRule .? - [L]
            RewriteRule .? %{ENV:BASE}/app.php [L]
        </IfModule>
    </Directory>
    LogLevel debug
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf
echo "User vagrant" >> /etc/apache2/apache2.conf
echo "Group vagrant" >> /etc/apache2/apache2.conf
chown vagrant: /var/www

printf "Enable Site"
a2enmod rewrite > /dev/null 2>&1
a2ensite 000-default.conf > /dev/null 2>&1
service apache2 reload > /dev/null 2>&1

printf "Done!"