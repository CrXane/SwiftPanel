#!/bin/bash
yum install httpd unzip firewalld -y
yum install php-mysql php-gd php-imap php-ldap php-mbstring php-odbc php-pear php-xml php-xmlrpcyum php-pecl-apc -y

wget -q -O - http://www.atomicorp.com/installers/atomic | sh
yum install php-ioncube-loader -y

yum install -y gcc php-devel php-pear libssh2 libssh2-devel make -y
pecl install -f ssh2

echo extension=ssh2.so > /etc/php.d/ssh2.ini

sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=80/tcp

sudo systemctl start httpd.service
sudo systemctl enable httpd.service

yum remove mysql -y
yum install mariadb-server mariadb -y
service mariadb start
mysql_secure_installation

cd /var/www/html
wget https://raw.githubusercontent.com/ch0sys/SwiftPanel/master/SwiftPanel.zip	 

unzip SwiftPanel.zip && rm -rf Swiftpanel.zip
rm -rf configuration-dist.php

echo type mysql password
read pass

db=$(shuf -zer -n8 {a..z}) 
pw=$(shuf -zer -n8 {a..z}) 

Q1="CREATE DATABASE $db;" 
Q2="CREATE USER '$db'@localhost IDENTIFIED BY '$pw';"
Q3="GRANT ALL PRIVILEGES ON $db.* TO '$db'@localhost;" 
Q4="USE $db;" 
SQL="${Q1}${Q2}${Q3}${Q4}" 

mysql -uroot -p$pass -e "$SQL" 

cat <<EOF > /var/www/html/configuration.php 
<?php 
define('LICENSE','lgnoreMe');
define('DBHOST','localhost');
define('DBNAME','$db');
define('DBUSER','$db');
define('DBPASSWORD','$pw'); 
?>
EOF

yum install epel-release -y
yum install proftpd -y

service proftpd start

firewall-cmd --add-port=21/tcp --permanent
firewall-cmd --reload

yum install glibc.i686 libstdc++.i686 -y
cd /
mkdir game && cd game
wget http://lspublic.com/hlds/rehlds.zip
unzip rehlds.zip && rm rehlds.zip
mv rehlds cs
cd cs && chmod +x *
