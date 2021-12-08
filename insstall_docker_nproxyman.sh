#!/bin/bash

installApps()
{
    OS="$REPLY" ## <-- This $REPLY is about OS Selection
    echo "We can install Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE."
    echo "Please select 'y' for each item you would like to install."
    echo "NOTE: Without Docker you cannot use Docker-Compose, NGinx Proxy Manager, or Portainer-CE."
    echo "       You also must have Docker-Compose for NGinX Proxy Manager to be installed."
    echo ""
    echo ""
    
    ISACT=`sudo systemctl is-active docker`
    ISCOMP=`docker-compose -v`
    COMPNO="command not found"

    #### Try to check whether docker is installed and running - don't prompt if it is
    if [[ "$ISACT" != "active" ]]; then
        read -rp "Docker-CE (y/n): " DOCK
    else
        echo "Docker appears to be installed and running."
        echo ""
        echo ""
    fi

    if [[ "$ISCOMP" == *"$COMPNO"* ]]; then
        read -rp "Docker-Compose (y/n): " DCOMP
    else
        echo "Docker-compose appears to be installed."
        echo ""
        echo ""
    fi

    read -rp "NGinX Proxy Manager (y/n): " NPM
    read -rp "Portainer-CE (y/n): " PTAIN

    if [[ "$PTAIN" == [yY] ]]; then
        echo ""
        echo ""
        PS3="Please choose either Portainer-CE or just Portainer Agent: "
        select _ in \
            " Full Portainer-CE (Web GUI for Docker, Swarm, and Kubernetes)" \
            " Portainer Agent - Remote Agent to Connect from Portainer-CE" \
            " Nevermind -- I don't need Portainer after all."
        do
            case $REPLY in
                1) startInstall ;;
                2) startInstall ;;
                3) exit ;;
                *) echo "Invalid selection, please try again..." ;;
            esac
        done
    fi
}

startInstall() 
{
    PORT="$REPLY" ## <- this $REPLY is about Portainer selection
    echo "Updating Packages..."
    echo ""
    echo ""
    sleep 2s

    #######################################################
    ###           Install for Debian / Ubuntu           ###
    #######################################################

    if [[ "$OS" != "1" ]]; then
        sudo apt update
        sudo apt upgrade -y
        echo ""
        echo ""
        echo "Install Prerequisite Packages..."
        echo ""
        echo ""
        sleep 2s

        sudo apt install --quiet apt-transport-https ca-certificates curl software-properties-common -y

        if [[ "$DOCK" == [yY] ]]; then
            echo ""
            echo ""
            echo "Retrieving Signing Keys for Docker... adn adding the Docker-CE repository..."
            echo ""
            echo ""
            sleep 2s

            #### add the Debian 10 Buster key
            if [[ "$OS" == 2 ]]; then
                curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            fi

            if [[ "$OS" == 3 ]] || [[ "$OS" == 4 ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            fi

            sudo apt update
            sudo apt-cache policy docker-ce

            echo ""
            echo ""
            echo "Installing Docker-CE (Community Edition)..."
            echo ""
            echo ""
            sleep 2s

            sudo apt install --quiet docker-ce -y

            docker -v
            sleep 5s

            if [[ "$OS" == 2 ]]; then
                sudo systemctl docker start
            fi
        fi
    fi

    #######################################################
    ###              Install for CentOS 7 or 8          ###
    #######################################################
    if [[ "$OS" == "1" ]]; then
        if [[ "$DOCK" == [yY] ]]; then
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

    if [[ "$DOCK" == [yY] ]]; then
        # add current user to docker group so sudo isn't needed
        echo ""
        echo ""
        echo "Attempting to add the currently logged in user to the docker group..."
        echo ""
        echo ""
        sleep 2s
        sudo usermod -aG docker "${USER}"
        echo ""
        echo ""
        echo "You'll need to log out and back in to finalize addition to the docker group for your user."
        echo ""
        echo ""
        sleep 3s
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
        
        if [[ "$OS" != "1" ]]; then
            sudo apt install --quiet docker-compose -y
        fi

        ######################################
        ###        Install CentOS 7        ###
        ######################################

        if [[ "$OS" == "1" ]]; then
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

    ##########################################
    #### Test if Docker Service is Running ###
    ##########################################
    ISACT=`sudo systemctl is-active docker`
    X=0
    while [[ "$ISACT" != "active" ]] && [[ $X -le 5 ]]; do
        echo "Giving the docker service time to start..."
        sleep 10s
        echo "Trying to start the service again."
        sudo systemctl start docker
        ISACT=`sudo systemctl is-active docker`
        let X=X+1
        echo "$X"
    done

    ##########################################
    ###     Install NGinX Proxy Manager    ###
    ##########################################
    if [[ "$NPM" == [yY] ]]; then
        # pull an nginx proxy manager docker-compose file from github
        echo "Pulling a default NGinX Proxy Manager docker-compose.yml file."
        echo ""
        echo ""

        mkdir nginx-proxy-manager
        cd nginx-proxy-manager

        curl https://raw.githubusercontent.com/bmcgonag/docker_installs/master/docker_compose.nginx_proxy_manager.yml -o docker-compose.yml

        echo ""
        echo ""
        echo "Running the docker-compose.yml to install and start NGinX Proxy Manager"
        echo ""
        echo ""

        if [[ "$OS" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$OS" != "1" ]]; then
          sudo docker-compose up -d
        fi

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
        sleep 3s
        cd
    fi


    #####################################
    ###      Install Portainer-CE     ###
    #####################################
    if [[ "$PORT" == "1" ]]; then
        echo "Preparing to Install Portainer-CE"
        echo ""
        echo ""

        sudo docker volume create portainer_data
        sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
        echo ""
        echo ""
        echo "Navigate to your server hostname / IP address on port 9000 and create your admin account for Portainer-CE"

        echo ""
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$PORT" == "2" ]]; then
        echo "Preparing to install Portainer Agent"
        echo ""
        echo ""

        sudo docker volume create portainer_data
        sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
        echo ""
        echo ""
        echo "From Portainer or Portainer-CE add this Agent instance via the 'Endpoints' option in the left menu."
        echo "   ####     Use the IP address of this server and port 9001"
        echo ""
        echo ""
        echo ""
        sleep 3s
    fi
    exit 1
}

echo ""
echo ""

echo "Let's figure out which OS / Distro you are running."
echo ""
echo ""
echo "From some basic information on your system, you appear to be running: "
echo "    " $(lsb_release -i)
echo "    " $(lsb_release -d)
echo "    " $(lsb_release -r)
echo "    " $(lsb_release -c)
echo ""
echo ""
PS3="Please select the number for your OS / distro: "
select _ in \
    "CentOS 7 and 8" \
    "Debian 10/11 (Buster / Bullseye)" \
    "Ubuntu 18.04 (Bionic)" \
    "Ubuntu 20.04 / 21.04 (Focal)/(Hirsute)" \
    "End this Installer"
do
  case $REPLY in
    1) installApps ;;
    2) installApps ;;
    3) installApps ;;
    4) installApps ;;
    5) exit ;;
    *) echo "Invalid selection, please try again..." ;;
  esac
done
