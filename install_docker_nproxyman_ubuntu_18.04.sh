#!/bin/bash
echo "Updating Packages..."
echo ""
echo ""
sleep 2s

sudo apt update

echo ""
echo ""
echo "Install Prerequisite Packages..."
echo ""
echo ""
sleep 2s

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

echo ""
echo ""
echo "Retrieving Signing Keys for Docker..."
echo ""
echo ""
sleep 2s

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo ""
echo ""
echo "Adding the Docker CE Repository..."
echo ""
echo ""
sleep 2s

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce

echo ""
echo ""
echo "Installing Docker-CE (Community Edition)..."
echo ""
echo ""
sleep 2s

sudo apt install docker-ce -y

# add current user to docker group so sudo isn't needed
echo ""
echo ""
echo "Attempting to add the currently logged in user to the docker group..."
echo ""
echo ""
sleep 2s

sudo usermod -aG docker ${USER}

# install docker-compose

echo ""
echo ""
echo "Installing Docker-Compose..."
echo ""
echo ""
sleep 2s

sudo apt install docker-compose -y

echo ""
echo ""
echo "Now you should log out and back in, or reboot your system."
echo ""
echo ""

# pull an nginx proxy manager docker-compose file from github
echo ""
echo ""
echo "Pulling a default NGinX Proxy Manager docker-compose.yml file."
echo ""
echo ""

mkdir nginx-proxy-manager
cd nginx-proxy-manager

curl https://raw.githubusercontent.com/bmcgonag/docker_installs/master/docker_compose.nginx_proxy_manager.yml -o docker-compose.yml
echo ""
echo ""

echo ""
echo ""
echo "Running the docker-compose.yml to install and start NGinX Proxy Manager"
echo ""
echo ""

sudo docker-compose up -d

echo ""
echo ""
echo "Navigate to your server hostname / IP address on port 81 to setup"
echo "NGinX Proxy Manager admin account."
echo ""
echo "The default login credentials are:"
echo "    username: admin@example.com"
echo "    password: changeme"

echo ""
echo ""
echo ""
sleep 10s
cd