# vagrant-antergos64-gnome-rails

This repo provides a Vagrant configuration for deploying Rails Applications into Antergos 64 VM with Gnome

This repo is using a custom vagrant box https://atlas.hashicorp.com/bogdanRada/boxes/antergos64-gnome

You can check the VagrantFile and the files used for provisioning the virtual machine in the "vagrant_provisioners" folder

Initially the vagrant box and this repo were created for this stackoverflow question: http://stackoverflow.com/questions/40920048/sass-error-active-admin-in-rails-5

The Gemfile in this repository is the same one as in the stackoverflow question.

The problem in that stackoverflow was the fact that the system had installed both system ruby and RVM and there were conflicts.

And wanted to help the user correctly configure his Vagrant machine.
