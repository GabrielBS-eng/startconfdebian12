#!/bin/bash -e
#
# TODO: - Add user to sudoers
#    	- Remove CD/DVD source from /etc/apt/source.list
#    	- Find easy way to config 'top' through script

sudo apt update -y
sudo apt upgrade -y
sudo apt remove gnome-games -y
sudo apt autoremove -y

sudo apt install -y vim tmux python3-pip ncdu htop net-tools cmake ca-certificates curl gnupg tcpdump speedtest-cli gnome-disk-utility gparted wget iptables man build-essential gdb ninja-build

# for fun
sudo apt install -y cmatrix hollywood

# python extra config
sudo ln -s /usr/bin/python3 /usr/bin/python || true
sudo ln -s /usr/bin/pip3 /usr/bin/pip || true

# vim config file
echo "set nu rnu" > ~/.vimrc
echo "set tabstop=4" >> ~/.vimrc
echo "set shiftwidth=4" >> ~/.vimrc
echo "set expandtab" >> ~/.vimrc
echo "set autoindent" >> ~/.vimrc
echo "set hls" >> ~/.vimrc
echo "set mouse=a" >> ~/.vimrc
echo "syntax enable" >> ~/.vimrc

# tmux config file
echo "set -g status-bg blue" > ~/.tmux.conf
echo "set -g status-fg white" >> ~/.tmux.conf
echo "set -g window-status-current-style bg=black,fg=white" >> ~/.tmux.conf
echo "set -g pane-active-border-style fg=blue" >> ~/.tmux.conf
echo "set -g history-file ~/.tmux_history" >> ~/.tmux.conf
echo "setw -g mouse on" >> ~/.tmux.conf

# .bashrc extra config
config_alias="alias ..='cd ..'"
config_path="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
grep -qFx "$config_alias" ~/.bashrc && echo "$config_alias already added" || echo "$config_alias" >> ~/.bashrc
grep -qFx "$config_path" ~/.bashrc && echo "PATH already configured" || echo "$config_path" >> ~/.bashrc

source ~/.bashrc #not reliable... PATH isn't updated (fix: run this command line manually afterwards)

# remove unecessary folders
rm -rf ~/Public ~/Templates ~/Music || true

############ VS CODE INSTALLATION ############
echo ""
echo "INSTALLING VS CODE..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

echo ""
echo "UPDATING PACKAGE CACHE & CODE PACKAGE INSTALLATION"
sudo apt install apt-transport-https
sudo apt update
sudo apt install code
##############################################

############ DOCKER INSTALLATION ############
echo ""
echo "INSTALLING DOCKER..."
echo ""
echo "UNINSTALL ANY CONFLICTING PACKAGE"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo ""
echo "ADDING DOCKER'S OFFICIAL GPG KEY"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo ""
echo "ADDING REPOSITORY TO APT SOURCES"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo ""
echo "ALL DOCKER PACKAGES INSTALLATION"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo ""
echo "DOCKER HELLO WORLD TEST"
sudo docker run hello-world

echo ""
echo "MANAGING DOCKER AS NON-ROOT"
sudo groupadd docker || true
sudo usermod -aG docker $USER
newgrp docker
#############################################

############ DOCKER INSTALLATION ############
#echo ""
#echo "INSTALLING YOCTO BUILD ENVIRONMENT AND TOOLS..."
#sudo apt install kas
#############################################
