#!/bin/bash
echo "Updating Packages..."
echo ""
echo ""
sleep 2s

sudo yum check-update

echo ""
echo ""
echo "Installing Docker-CE (Community Edition)..."
echo ""
echo ""
sleep 2s

curl -fsSL https://get.docker.com/ | sh

echo ""
echo ""
echo "Starting the Docker Service..."
echo ""
echo ""
sleep 2s

sudo systemctl start docker

echo ""
echo ""
echo "Enabling the Docker Service..."
echo ""
echo ""
sleep 2s

sudo systemctl enable docker

# add current user to docker group so sudo isn't needed
echo ""
echo ""
echo "Attempting to add the currently logged in user to the docker group..."
echo ""
echo ""
sleep 2s

sudo usermod -aG docker $(whoami)

# install docker-compose

echo ""
echo ""
echo "Installing Docker-Compose..."
echo ""
echo ""
sleep 2s

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo ""
echo ""
echo "Docker Compose Version is now: "
docker-compose --version
echo ""
sleep 3s

echo ""
echo ""
echo "Now you should log out and back in, or reboot your system."
echo ""
echo ""
