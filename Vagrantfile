# -*- mode: ruby -*-
# vi: set ft=ruby :


$bootstrap_script = <<SCRIPT
#!/bin/bash

/bin/echo "----------------------------------------"
/bin/echo "install java 1.6"
/bin/echo "----------------------------------------"
#http://my.letbox.com/knowledgebase/28/Installing-Java-16-in-CentOS-6--The-Simplest-Way.html
sudo yum install java-1.6.0-openjdk.x86_64 -y
export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.33.x86_64/jre


/bin/echo "----------------------------------------"
/bin/echo "install maven"
/bin/echo "----------------------------------------"
# http://stackoverflow.com/questions/7532928/how-do-i-install-maven-with-yum
sudo yum install -y wget
sudo wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
sudo tar xvf apache-maven-3.0.5-bin.tar.gz
sudo mv apache-maven-3.0.5  /usr/local/apache-maven

export PATH=/usr/local/apache-maven/bin:$PATH
source ~/.bashrc

/bin/echo "----------------------------------------"
/bin/echo "install jenkins - DO NOT START IT"
/bin/echo "----------------------------------------"
sudo yum install -y  http://pkg.jenkins-ci.org/redhat/jenkins-1.554-1.1.noarch.rpm


/bin/echo "----------------------------------------"
/bin/echo "install rbenv"
/bin/echo "----------------------------------------"
sudo yum install -y libssl-dev zlib1g-dev libreadline-dev
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL -l

SCRIPT

$bootstrap_script2 = <<SCRIPT
#!/bin/bash

/bin/echo "----------------------------------------"
/bin/echo "install jruby 1.7.9"
/bin/echo "----------------------------------------"
rbenv install jruby-1.7.9
rbenv rehash
rbenv local jruby-1.7.9

# notes on creating jenkins plugin with jpi
# https://github.com/jenkinsci/jenkins.rb/wiki/Getting-Started-With-Ruby-Plugins
/bin/echo "----------------------------------------"
/bin/echo "install and run jenkins plugin library"
/bin/echo "----------------------------------------"
gem install jpi
SCRIPT

$JPI_script = <<SCRIPT
#!/bin/bash

cd /vagrant
rbenv local jruby-1.7.9
jpi build
bundle update rake
jpi server

SCRIPT





# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  #config.vm.box = "jpi.box" 
  config.vm.network "forwarded_port", guest: 8080, host: 58080
  config.vm.provision "shell", inline: $bootstrap_script, privileged: false
  config.vm.provision "shell", inline: $bootstrap_script2, privileged: false
  config.vm.provision "shell", inline: $JPI_script, privileged: false
end
