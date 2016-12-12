#!/usr/bin/env bash

# do not generate gem documentation
echo 'gem: --no-rdoc --no-ri' > /home/vagrant/.gemrc

printf "\n\n"
echo "## Setup RVM"
version=$1 || 2.1.5
declare bundler_version=$2 || 1.10.2
if [ ! -f $HOME/rvm_install_flag ]
then
  # install public key
  gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
  # install rvm
  \curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --autolibs=enabled

  # add progress bar
  #echo progress-bar >> ~/.curlrc
  # inject rvm into bash
  echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> .bashrc
  source .bashrc
  source ~/.rvm/scripts/rvm
  rvm requirements
  rvm autolibs enable
  touch $HOME/rvm_install_flag
else
  printf "\n\n"
  echo "rvm already installed, flag set $HOME/rvm_install_flag"
fi

source ~/.rvm/scripts/rvm
bash --login

printf "\n\n"
echo "## Avaiable Rubies:"
rvm list

printf "\n\n"
echo "## Avaiable Gemsets"
rvm gemset list

printf "\n\n"
echo "## Install Ruby $version set to default"
rvm use $version --default --install --quiet-curl

echo "## Show Gem Dir"
rvm gemdir


printf "\n\n"
echo "## Installing RubyGems"
rvm rubygems current --quiet-curl

printf "\n\n"
echo "## Check install"

printf "\n\n"
echo "RVM ruby"
rvm-prompt

printf "\n\n"
echo "Ruby Version"
ruby -v

printf "\n\n"
echo "## Setup RVM to trust .rvmrc files by default"
if [[ -s /vagrant/.rvmrc ]]; then
  rvm rvmrc warning ignore all.rvmrcs
  export rvm_project_rvmrc=1;
  export rvm_trust_rvmrcs_flag=1
  export rvm_project_rvmrc_default=1
  rvm rvmrc trust /vagrant
fi

printf "\n\n"
echo "## Cd to /vagrant"
cd /vagrant
if [[ -s .rvmrc ]]; then source .rvmrc ; fi

printf "\n\n"
echo "## Installing bundler $bundler_version"
gem install bundler -v $bundler_version


printf "\n\n"
echo "## Running bundle install in /vagrant"
bundle check || bundle install

printf "\n\n"
echo "## Running bundle exec rake db:create:all"
 bundle exec rake db:create:all && bundle exec rake db:migrate

printf "\n\n"
echo "## Running bundle exec rake db:test:prepare"
bundle exec rake db:test:prepare



printf "\n\n"
echo "## Setup working directory to /vagrant"
cd /vagrant

printf "\n\n"
echo 'prepare xvfb...'
export DISPLAY=:1.0


printf "\n\n"
echo 'running the  server...'
bundle exec rails s

#Xvfb :1 -screen 0 1024x758x16
echo "**end"
