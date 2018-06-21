# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://blog.engineyard.com/2014/building-a-vagrant-box

# Check this https://bugs.launchpad.net/ubuntu/+source/vagrant/+bug/1503565/comments/4
# if you have trouble installing vagrant

host = RbConfig::CONFIG['host_os']

# Give VM 1/4 system memory & access to all cpu cores on the host
if host =~ /darwin/
  cpus = `sysctl -n hw.ncpu`.to_i
  # sysctl returns Bytes and we need to convert to MB
  mem = `sysctl -n hw.memsize`.to_i / 1024
elsif host =~ /linux/
  cpus = `nproc`.to_i
  # meminfo shows KB and we need to convert to MB
  mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i
else
  # powershell may not be available on Windows XP and Vista, so wrap this in a rescue block
  begin
    cpus = `powershell -Command "(Get-WmiObject Win32_Processor -Property NumberOfLogicalProcessors | Select-Object -Property NumberOfLogicalProcessors | Measure-Object NumberOfLogicalProcessors -Sum).Sum"`.to_i
    mem = `powershell -Command "Get-CimInstance -class cim_physicalmemory | % $_.Capacity}"`.to_i / 1024
  rescue
  end
end

if cpus.nil? || cpus.zero?
  cpus = 2
end

if mem.nil? ||  mem.zero? || mem < 2048000
  mem = 1024
else
  mem = (mem / 1024 / 4)
end

defaults = {
  :memory               => 5120,
  :cpus                 => cpus,
  :cpuexecutioncap      => 75,
  :hwvirtex             => 'off',
  :vtxvpid              => 'off',
  :pae                  => 'off',
  :largepages           => 'off',
  :nestedpaging         => 'off',
  :acpi                 => 'on',
  :ioapic               => 'on',
  :accelerate3d         => 'off',
  :accelerate2dvideo    => 'off',
  :nictype1             => 'virtio',
  :nictype2             => 'virtio',
  :natdnshostresolver1  => 'on',
  :natdnsproxy1         => 'on',
  :usb                  => 'off',
  :usbehci              => 'off',
  :tracing              => 'off'
}

ENV["LC_ALL"] = "en_US.UTF-8" if ENV['LC_ALL'].nil? || ENV['LC_ALL'].empty?

job_name =  ENV['JOB_NAME'].to_s.strip.empty? ? nil :  ENV['JOB_NAME'].to_s.strip
vagrant_folder = job_name || "antergos-ssh"
vagrant_folder = vagrant_folder.gsub(/[\/\s]+/, '_')

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # Hostname
  config.vm.host_name = "echo"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bogdanRada/antergos64-gnome"

  if config.respond_to?(:vbguest)
    # set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine
    config.vbguest.auto_update = false
    # do NOT download the iso file from a webserver
    config.vbguest.no_remote = true
  end

  # can see here more options: https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
  config.vm.provider "virtualbox" do |v|
    # Boot with a GUI so you can see the screen. (Default is headless)
    v.gui = false
    v.name = vagrant_folder
    v.linked_clone = true if Vagrant::VERSION =~ /^1.8/
    v.memory = defaults[:memory]
    v.cpus = defaults[:cpus]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "#{defaults[:cpuexecutioncap]}"]
    v.customize ["modifyvm", :id, "--hwvirtex", "#{defaults[:hwvirtex]}"]
    v.customize ["modifyvm", :id, "--vtxvpid", "#{defaults[:vtxvpid]}"]
    v.customize ["modifyvm", :id, "--pae", "#{defaults[:pae]}"]
    v.customize ["modifyvm", :id, "--largepages", "#{defaults[:largepages]}"]
    v.customize ["modifyvm", :id, "--nestedpaging", "#{defaults[:nestedpaging]}"]
    v.customize ["modifyvm", :id, "--acpi",  "#{defaults[:acpi]}"]
    v.customize ["modifyvm", :id, "--ioapic", "#{defaults[:ioapic]}"  ]
    v.customize ["modifyvm", :id, "--accelerate3d",  "#{defaults[:accelerate3d]}"]
    v.customize ["modifyvm", :id, "--accelerate2dvideo",  "#{defaults[:accelerate2dvideo]}"]

    # change the network card hardware for better performance
    v.customize ["modifyvm", :id, "--nictype1", "#{defaults[:nictype1]}" ]
    v.customize ["modifyvm", :id, "--nictype2", "#{defaults[:nictype2]}" ]

    # suggested fix for slow network performance
    # see https://github.com/mitchellh/vagrant/issues/1807
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "#{defaults[:natdnshostresolver1]}"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "#{defaults[:natdnsproxy1]}"]

    # disable USB 2.0 and 3 support
    v.customize ["modifyvm", :id, "--usb", "#{defaults[:usb]}"]
    v.customize ["modifyvm", :id, "--usbehci", "#{defaults[:usbehci]}"]

    # disable tracing
    v.customize ["modifyvm", :id, "--tracing-enabled", "#{defaults[:tracing]}"]
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
   config.vm.box_url = 'https://app.vagrantup.com/bogdanRada/boxes/antergos64-gnome/versions/1.0/providers/virtualbox.box'

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network "private_network", type: "dhcp"

  #config.vm.network :forwarded_port, guest: 80, host: 4567

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Enable caching if plugin installed - need to test this a bit more
  # if Vagrant.has_plugin?("vagrant-cachier")
  #   config.cache.scope = :box
  # end

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.synced_folder ".", "/vagrant", disabled: true
  # config.vm.synced_folder ".", "/#{vagrant_folder}", :nfs => false

  # Use nfs when running on a unix system  and do apt-get install cachefilesd in provisioning file
  # and sudo echo "RUN=yes" > /etc/default/cachefilesd and consider using this setting: git config core.preloadindex true for GIT over NFS
  # if host =~ /darwin/
  #   config.vm.synced_folder ".", "/vagrant", nfs: true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
  # elsif host =~ /linux/
  #   config.vm.synced_folder ".", "/vagrant", nfs: true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2']
  # else
  #   config.vm.synced_folder ".", "/vagrant", mount_options: ['dmode=777','fmode=666']
  # end

  # Provision with a shell script
  config.vm.provision "system_setup", type: "shell", :path => "vagrant_provisioners/sytem_provision.sh",  :args => [vagrant_folder]
  config.vm.provision "ruby_setup", type: "shell", path: "vagrant_provisioners/rvm_ruby_setup.sh", privileged: false, :args => ['2.3.0', '1.13.6'], :run => 'always'
end
