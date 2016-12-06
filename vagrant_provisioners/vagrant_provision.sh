#!/usr/bin/env bash


printf "\n\n"
echo "### Add swap file"

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  fallocate -l 5G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# output results to terminal
df -h
free -m
cat /proc/swaps
cat /proc/meminfo | grep Swap
swapon -s

export DEBIAN_FRONTEND=noninteractive

printf "\n\n"
echo "### Add color prompt"
touch /home/vagrant/.nano_history
chown vagrant:vagrant /home/vagrant/.nano_history
sed -i -e"s/#force_color_prompt=yes/force_color_prompt=yes/g" /home/vagrant/.bashrc
source /home/vagrant/.bashrc

printf "\n\n"
echo "### Running apt-get -y autoremove "
apt-get -y autoremove

printf "\n\n"
echo "### Running apt-get -y clean "
apt-get -y clean

printf "\n\n"
echo "### Running apt-get update "
apt-get -y update > /dev/null

printf "\n\n"
echo "### Running apt-get upgrade "
apt-get -y upgrade > /dev/null

printf "\n\n"
echo "### Setup languages"
apt-get -y remove --purge locales
apt-get -y install locales language-pack-en-base
dpkg-reconfigure locales
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# export C_CTYPE="en_US"
# export LC_NUMERIC="en_US"
# export LC_TIME="en_US"


printf "\n\n"
echo "### Installing necessary packages"
apt-get -y install \
    build-essential git git-flow \
    mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev \
    libssl-dev zlib1g-dev unzip xvfb \
    libxml2 libxml2-dev libxslt1-dev curl libcurl3 libcurl3-gnutls \
    libcurl4-openssl-dev \
    vim nano libreadline6-dev libyaml-dev libsqlite3-dev sqlite3\
    autoconf libgmp-dev libgdbm-dev libncurses5-dev automake libtool \
    bison libffi-dev file google-chrome-stable nodejs npm openssl libreadline6 libreadline6-dev nano

printf "\n\n"
echo 'Starting MySql...'
service mysql start

printf "\n\n"
echo "### Change default editor to nano"
if [ -z "`grep -Fl 'EDITOR=nano' /home/vagrant/.bashrc`" ]; then
  echo $'\n''export EDITOR=nano' >> /home/vagrant/.bashrc
  source /home/vagrant/.bashrc
fi

printf "\n\n"
echo "### Cleanup packages apt-get -y autoremove && apt-get -y clean"
apt-get -y autoremove
apt-get -y clean

printf "\n\n"
echo "### Creating Downloads and bin folder and running chown on bin folder"
mkdir -p /home/vagrant/downloads
mkdir -p /home/vagrant/bin
chown -R vagrant:vagrant /home/vagrant/bin

printf "\n\n"
echo "### Setting GUI to headless"
if [ "$GUI" == "headless" ]; then
  echo "GUI is already set to headless"
else
  echo "export GUI=\"headless\"" >> /home/vagrant/.profile
  echo "export GUI=\"headless\"" >> /home/vagrant/.zshenv
fi



# printf "\n\n"
# echo "### Installing Virtualbox Guest Additions"
# wget -q http://download.virtualbox.org/virtualbox/5.0.22/VBoxGuestAdditions_5.0.22.iso
# mkdir /media/VBoxGuestAdditions
# mount -o loop,ro VBoxGuestAdditions_5.0.22.iso /media/VBoxGuestAdditions
# sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run <<!
# yes
# !
# rm VBoxGuestAdditions_5.0.22.iso
# umount /media/VBoxGuestAdditions
# rmdir /media/VBoxGuestAdditions

# currently rebooting in the middle of provisioning can only be done with Windows. Ubuntu can't handle reboots during provisioning
# shutdown -t 30 -r -f
echo "**end"
