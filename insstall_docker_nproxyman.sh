#!/bin/bash

installApps()
{
    echo "We can install Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE."
    echo "Please select 'y' for each item you would like to install."
    echo "NOTE: Without Docker you cannot use Docker-Compose, NGinx Proxy Manager, or Portainer-CE."
    echo "       You also must have Docker-Compose for NGinX Proxy Manager to be installed."
    echo ""
    echo ""
    
    read -p "Docker-CE (y/n): " DOCK
    read -p "Docker-Compose (y/n): " DCOMP
    read -p "NGinX Proxy Manager (y/n): " NPM
    read -p "Portainer-CE - Docker Management GUI (y/n): " PTAIN

    echo "Updating Packages..."
    echo ""
    echo ""
    sleep 2s

    #######################################################
    ###           Install for Debian / Ubuntu           ###
    #######################################################

    if [[ "$REPLY" != "1" ]]; then
        sudo apt update
        echo ""
        echo ""
        echo "Install Prerequisite Packages..."
        echo ""
        echo ""
        sleep 2s

        sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

        if [[ "$DOCK" == *[yY]* ]]; then
            echo ""
            echo ""
            echo "Retrieving Signing Keys for Docker..."
            echo ""
            echo ""
            sleep 2s

            if [[ "$REPLY" == 2 ]]; then
                curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            fi

            if [[ "$REPLY" == "3" ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
            fi

            if [[ "$REPLY" == "4" ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            fi
            sudo apt update
            sudo apt-cache policy docker-ce

            echo ""
            echo ""
            echo "Installing Docker-CE (Community Edition)..."
            echo ""
            echo ""
            sleep 2s

            sudo apt install docker-ce -y
        fi
    fi

    #######################################################
    ###              Install for CentOS 7               ###
    #######################################################
    if [[ "$REPLY" == "1" ]]
        if [[ "$DOCK" == *[yY]* ]]; then
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
        fi
    fi

    if [[ "$DOCK" == *[yY]* ]]; then
        # add current user to docker group so sudo isn't needed
        echo ""
        echo ""
        echo "Attempting to add the currently logged in user to the docker group..."
        echo ""
        echo ""
        sleep 2s
        sudo usermod -aG docker ${USER}
    fi


    #####################################
    ###     Install Docker-Compose    ###
    #####################################

    if [[ "$DCOMP" = [yY] ]]; then
        # install docker-compose
        echo ""
        echo ""
        echo "Installing Docker-Compose..."
        echo ""
        echo ""
        sleep 2s

        ######################################
        ###     Install Debian / Ubuntu    ###
        ######################################        
        
        if [[ "$REPLY" != "1" ]]; then
            sudo apt install docker-compose -y

            echo ""
            echo ""
            echo "Now you should log out and back in, or reboot your system."
            echo ""
            echo ""
        fi

        ######################################
        ###        Install CentOS 7        ###
        ######################################

        if [[ "$REPLY" == "1" ]]; then
            sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

            sudo chmod +x /usr/local/bin/docker-compose
        fi

        echo ""
        echo ""
        echo "Docker Compose Version is now: "
        docker-compose --version
        echo ""
        echo ""
        sleep 3s
    fi


    if [[ "$NPM" == [yY] ]]; then
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
        echo "The default login credentials for NGinX Proxy Manager are:"
        echo "    username: admin@example.com"
        echo "    password: changeme"

        echo ""
        echo ""
        echo ""
        sleep 5s
        cd
    fi

    if [[ "$PTAIN" == [yY] ]]; then
        # pull an nginx proxy manager docker-compose file from github
        echo ""
        echo ""
        echo "Preparing to Install Portainer-CE"

        sudo docker volume create portainer_data
        sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
        echo ""
        echo ""
        echo "Navigate to your server hostname / IP address on port 9000 and create your admin account for Portainer-CE"

        echo ""
        echo ""
        echo ""
        sleep 5s
    fi
}

echo ""
echo ""

echo "Now, let's figure out which OS / Distro you are running."
PS3 = "Please select the number for your OS / distro: "
select _ in \
    "CentOS 7" \
    "Debian 10" \
    "Ubuntu 18.04" \
    "Ubuntu 20.04" \
    "End this Installer" \
do
    CASE $REPLY in
      1) installApps ;;
      2) installApps ;;
      3) installApps ;;
      4) installApps ;;
      5) return ;;
      *) echo "Invalid selection, please try again..." ;;
    ESAC
done