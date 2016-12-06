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
ln -s /usr/share/zoneinfo/Region/City /etc/localtime


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
pacman -Syu automake-wrapper
pacman -Syu bash
pacman -Syu bash-completion
pacman -Syu bison
pacman -Syu bsdcpio
pacman -Syu bsdtar
pacman -Syu bzip2
pacman -Syu catgets
pacman -Syu coreutils
pacman -Syu crypt
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
pacman -Syu info
pacman -Syu less
pacman -Syu lndir
pacman -Syu make
pacman -Syu man-db
pacman -Syu mercurial
pacman -Syu mingw-w64-x86_64-freeglut
pacman -Syu mingw-w64-x86_64-gcc
pacman -Syu mingw-w64-x86_64-gcc-fortran
pacman -Syu mingw-w64-x86_64-gsl
pacman -Syu mingw-w64-x86_64-hdf5
pacman -Syu mingw-w64-x86_64-openblas
pacman -Syu mintty
pacman -Syu msys2-keyring
pacman -Syu msys2-launcher-git
pacman -Syu msys2-runtime
pacman -Syu ncurses
pacman -Syu pacman
pacman -Syu pacman-mirrors
pacman -Syu pactoys-git
pacman -Syu patch
pacman -Syu pax-git
pacman -Syu perl
pacman -Syu pkg-config
pacman -Syu pkgfile
pacman -Syu rebase
pacman -Syu sed
pacman -Syu tar
pacman -Syu tftp-hpa
pacman -Syu time
pacman -Syu tzcode
pacman -Syu unzip
pacman -Syu util-linux
pacman -Syu which gnupg readline

echo "1) gnustep-make"
pacman -Syu autogen automake  autoconf2.13 libtool mingw-w64-i686-libtool
pacman -Syu mingw-w64-i686-toolchain
pacman -Syu mingw-w64-i686-pkg-config

echo "3) gnustep-gui"
pacman -Syu mingw-w64-i686-libjpeg-turbo
pacman -Syu mingw-w64-i686-libtiff
pacman -Syu mingw-w64-i686-giflib
pacman -Syu mingw-w64-i686-icu
pacman -Syu mingw-w64-i686-libsndfile
pacman -Syu mingw-w64-i686-aspell
pacman -Syu mingw-w64-i686-lcms mingw-w64-i686-lcms2
pacman -Syu mingw-w64-i686-sqlite3
pacman -Syu mingw-w64-bison

pacman -Syu asciidoc
pacman -Syu mingw-w64-i686-windows-default-manifest

echo "4) gnustep-back"
pacman -Syu mingw-w64-i686-cairo


pacman -Syfu \
    base-devel abs git gitflow-git \
    lib32-openssl lib32-zlib xorg-server \
    lib32-libxml2 libxml2-dev  lib32-libxslt \
    gvim nano  libreadline6-dev libyaml sqlite\
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


echo "**end"
