#!/usr/bin/env bash

# Install required packages
sudo apt-get install --yes --force-yes python python2.7-dev python-pyasn1 libxml2-dev libxslt1-dev python-setuptools python-mysqldb screen libxss-dev
sudo easy_install pip
sudo pip install mitmproxy
sudo pip install pyOpenssl
sudo pip install selenium

# Create symbolic link
ln -s `pwd` ~/fpbase

# Install mysql server and phpmyadmin preventing password propmt by setting password beforehand ('fpdetective')
echo 'mysql-server-5.5 mysql-server/root_password password fpdetective' | sudo debconf-set-selections
echo 'mysql-server-5.5 mysql-server/root_password_again password fpdetective' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password fpdetective' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password fpdetective' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password fpdetective' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
sudo apt-get -y install --yes --force-yes apache2 php5 libapache2-mod-php5
sudo /etc/init.d/apache2 restart
sudo apt-get -y install --yes --force-yes mysql-server phpmyadmin

# Generate mysql schema
mysql -u root --password=fpdetective < db/create_fp_database.sql

# Download alexa top 1m
cd run
wget http://s3.amazonaws.com/alexa-static/top-1m.csv.zip
unzip top-1m.csv.zip
sudo rm -f top-1m.csv.zip

# Download browser binaries from git repo
#phantom 64
cd phantom
wget https://github.com/fpdetective/phantomjs/releases/download/v1.9/phantomjsm64.tar.gz
tar -xzf phantomjsm64.tar.gz
sudo rm -f phantomjsm64.tar.gz

#chromium64
cd ../chromium
wget https://github.com/fpdetective/phantomjs/releases/download/v1.9/chromium64.tar.gz
tar -xzf chromium64.tar.gz
sudo rm -f chromium64.tar.gz
cd ../..

echo "The setup script has finished."
