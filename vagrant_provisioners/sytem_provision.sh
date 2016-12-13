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
echo "### Install curl"
pacman -Syu curl


printf "\n\n"
echo "### Installing necessary packages"
pacman -Syu autoconf
pacman -Syu bash
pacman -Syu bash-completion
pacman -Syu bison
pacman -Syu bzip2
pacman -Syu coreutils
pacman -Syu curl
pacman -Syu dash
pacman -Syu file
pacman -Syu filesystem
pacman -Syu findutils
pacman -Syu flex
pacman -Syu gawk
pacman -Syu gcc-libs
pacman -Syu grep
pacman -Syu gzip
pacman -Syu inetutils
pacman -Syu less
pacman -Syu make
pacman -Syu man-db
pacman -Syu mercurial
pacman -Syu ncurses
pacman -Syu pacman
pacman -Syu patch
pacman -Syu perl
pacman -Syu pkg-config
pacman -Syu pkgfile
pacman -Syu sed
pacman -Syu tar
pacman -Syu tftp-hpa
pacman -Syu time
pacman -Syu unzip
pacman -Syu util-linux
pacman -Syu which gnupg readline

echo "1) gnustep-make"
pacman -Syu autogen automake  autoconf2.13 libtool
pacman -Syu asciidoc

pacman -Syu \
    base-devel linux-headers linux-headers-lts dkms openssh abs git \
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
if [ "$GUI" == "headless" ]; then
  echo "GUI is already set to headless"
else
  echo "export GUI=\"headless\"" >> /home/vagrant/.profile
  echo "export GUI=\"headless\"" >> /home/vagrant/.zshenv
fi

chmod 0777 /home/vagrant/.profile

echo "**end"
