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

printf "\n\n"
echo "### Add color prompt"
touch /home/vagrant/.nano_history
chown vagrant:users /home/vagrant/.nano_history
sed -i -e"s/#force_color_prompt=yes/force_color_prompt=yes/g" /home/vagrant/.bashrc
source /home/vagrant/.bashrc


printf "\n\n"
echo "### PACMAN"
pacman -Syuyyu

printf "\n\n"
echo "### Update system clock"
timedatectl set-ntp true

printf "\n\n"
echo "Set the time zone"
timedatectl set-timezone Etc/UTC

printf "\n\n"
echo "Run hwclock to generate /etc/adjtime:"
hwclock --systohc


printf "\n\n"
echo "Locale configuration"
 locale-gen
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf

printf "\n\n"
echo "Set keyboard Locale configuration"
echo 'KEYMAP=de-latin1' >> /etc/vconsole.conf


printf "\n\n"
echo "### Installing necessary packages"
pacman -Syu --needed \
  autoconf bash bash-completion bison \
  bzip2 coreutils curl dash file filesystem \
  findutils flex gawk gcc-libs grep \
  gzip inetutils less make man-db \
  mercurial ncurses pacman patch \
  perl pkg-config pkgfile sed tar \
  tftp-hpa time unzip util-linux \
  which gnupg readline \
  autogen automake  autoconf2.13 libtool asciidoc \
  base-devel linux-headers linux-lts-headers dkms openssh abs git \
  lib32-openssl lib32-zlib xorg-server \
  lib32-libxml2 lib32-libxslt \
  gvim nano libyaml sqlite\
  gpm

printf "\n\n"
echo "### Change default editor to nano"
if [ -z "`grep -Fl 'EDITOR=nano' /home/vagrant/.bashrc`" ]; then
  echo $'\n''export EDITOR=nano' >> /home/vagrant/.bashrc
  source /home/vagrant/.bashrc
fi

printf "\n\n"
echo "### Creating Downloads and bin folder and running chown on bin folder"
mkdir -p /home/vagrant/downloads
mkdir -p /home/vagrant/bin
chown -R vagrant:users /home/vagrant/bin

printf "\n\n"
echo "### Setting GUI to headless"
systemctl set-default multi-user.target

chmod 0777 /home/vagrant/.profile

echo "**end"
