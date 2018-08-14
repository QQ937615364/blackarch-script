#!/bin/bash
echo "//chinese english"
echo "this script can install zsh;rvm;msfdatabase;privoxy"
echo "but u must set the ip:port in /etc/privoxy/config line 784"
#install zsh;rvm;msfdatabase;privoxy
#run wicd to connect the internet
wicd
#enable system services
systemctl enable postgresql.service
systemctl enable wicd.service
#change system mirrors
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
mv /etc/pacman.d/blackarch-mirrorlist /etc/pacman.d/blackarch-mirrorlist.bak
echo "Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist
echo "Server = https://mirrors.ustc.edu.cn/blackarch/$repo/os/$arch" > /etc/pacman.d/blackarch-mirrorlist
#install zsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
#install and set rvm and ruby
  #rm old gemrc
  rm -rf /etc/gemrc
  #add $PATH to PATH=
  sed -e 's/${HOME}/$PATH:${HOME}/;s/${PATH}/$PATH:${PATH}/' ~/.bashrc > ~/.bashrc.bak
  sed -e 's/${HOME}/$PATH:${HOME}/;s/${PATH}/$PATH:${PATH}/' ~/.bash_profile > ~/.bash_profile.bak
  rm ~/.bashrc
  rm ~/.bash_profile
  mv ~/.bashrc.bak ~/.bashrc
  mv ~/.bash_profile.bak ~/.bash_profile
  #set the rvm source
  echo "[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"" >> ~/.zshrc
  echo "source /usr/local/rvm/scripts/rvm" >> ~/.zshrc
  echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc
  echo "source /usr/local/rvm/scripts/rvm" >> ~/.bash_profile
  #refuse source
  source ~/.bashrc
  source ~/.bash_profile
  source ~/.zshrc
  #add key
  gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  #install rvm
  sudo curl -sSL https://get.rvm.io | bash -s stable
  #add user(root) to rvm group
  usermod -a -G rvm root
  #install bundler and rails
  gem install bundler
  gem install rails
#set the database of msf
echo "production:" > ~/.msf4/database.yml
echo " adapter: postgresql" >> ~/.msf4/database.yml
echo " database: msfbook" >> ~/.msf4/database.yml
echo " username: postgres" >> ~/.msf4/database.yml
echo " password: postgres" >> ~/.msf4/database.yml
echo " hosts: 127.0.0.1" >> ~/.msf4/database.yml
echo " port: 5432" >> ~/.msf4/database.yml
echo " pool: 5" >> ~/.msf4/database.yml
echo " timeout: 5" >> ~/.msf4/database.yml
#echo dbs connect to rc
echo "db_connect -y ~/.msf4/database.yml" > db_connect.rc
msfconsole -r db_connect.rc
rm db_connect.rc
#upgrade system and install "privoxy"
pacman -Syu privoxy
#set privoxy
mv /etc/privoxy/config /etc/privoxy/config.bak
sed '783a\forward-socks5   \/              /*here u set the proxy ip and port like xxx.xxx.xxx.xxx:xxxxx(ip:port),please delete this(233333 chinese english QWQ)*/ \.' /etc/privoxy/config.bak > /etc/privoxy/config
rm /etc/privoxy/config.bak
echo "export http_proxy=http://127.0.0.1:8118/" >> ~/.zshrc
systemctl restart privoxy.serivce
systemctl enable privoxy.service
#reboot
reboot
