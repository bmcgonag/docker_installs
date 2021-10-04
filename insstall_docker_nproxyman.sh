#!/usr/bin/env bash

if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script with sudo."
    exit
fi

# If want to automate you can input to DIST_RUN, else just remove below.
#CHECK_DIST() {
#  if [ -f /etc/os-release ]; then
#    # shellcheck disable=SC1091
#    source /etc/os-release
#    DISTRO=${ID}
#    DISTRO_VERSION=${VERSION_ID}
#  fi
#}

#DIST_RUN() {
#  if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ] || [ "${DISTRO}" == "neon" ]; }; then
#echo "RUN DEB"
#elif { [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ] || [ "${DISTRO}" == "almalinux" ] || [ "${DISTRO}" == "rocky" ]; }; then
#echo "RUN RPM"
#elif { [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ]; }; then
#echo "RUN PAC"
#elif [ "${DISTRO}" == "alpine" ]; then
#echo "RUN APK"
#elif [ "${DISTRO}" == "freebsd" ]; then
#echo "RUN PKG"
#else
#echo "Error: ${DISTRO} is not supported."
#    exit 1
#  fi
#}

installApps()
{
    echo "We can install Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE."
    echo "Please select 'y' for each item you would like to install."
    echo "NOTE: Without Docker you cannot use Docker-Compose, NGinx Proxy Manager, or Portainer-CE."
    echo "       You also must have Docker-Compose for NGinX Proxy Manager to be installed."
    echo ""
    echo ""
    
    read -rp "Docker-CE (y/n): " DOCK
    read -rp "Docker-Compose (y/n): " DCOMP
    read -rp "NGinX Proxy Manager (y/n): " NPM
    read -rp "Portainer-CE - Docker Management GUI (y/n): " PTAIN

    echo "Updating Packages..."
    echo ""
    echo ""
    sleep 2s

    #######################################################
    ###           Install for Debian / Ubuntu           ###
    #######################################################

    if [[ "$REPLY" != "1" ]]; then
        apt update
        echo ""
        echo ""
        echo "Install Prerequisite Packages..."
        echo ""
        echo ""
        sleep 2s

        apt install apt-transport-https ca-certificates curl software-properties-common -y

        if [[ "$DOCK" == [yY] ]]; then
            echo ""
            echo ""
            echo "Retrieving Signing Keys for Docker..."
            echo ""
            echo ""
            sleep 2s

            if [[ "$REPLY" == 2 ]]; then
                curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            fi

            if [[ "$REPLY" == "3" ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
            fi

            if [[ "$REPLY" == "4" ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

                echo ""
                echo ""
                echo "Adding the Docker CE Repository..."
                echo ""
                echo ""
                sleep 2s

                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            fi
            apt update
            apt-cache policy docker-ce

            echo ""
            echo ""
            echo "Installing Docker-CE (Community Edition)..."
            echo ""
            echo ""
            sleep 2s

            apt install docker-ce -y
        fi
    fi

    #######################################################
    ###              Install for CentOS 7               ###
    #######################################################
    if [[ "$REPLY" == "1" ]]; then
        if [[ "$DOCK" == [yY] ]]; then
            yum check-update

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

            systemctl start docker

            echo ""
            echo ""
            echo "Enabling the Docker Service..."
            echo ""
            echo ""
            sleep 2s

            systemctl enable docker
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
        usermod -aG docker "${USER}"
        echo "Reboot/re-login required to apply changes."

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
            apt install docker-compose -y

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
            curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

            chmod +x /usr/local/bin/docker-compose
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

        if [[ "$REPLY" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$REPLY" != "1" ]]; then
           docker-compose up -d
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
        sleep 5s
        cd
    fi


    #####################################
    ###      Install Portainer-CE     ###
    #####################################
    if [[ "$PTAIN" == [yY] ]]; then
        echo -e "By default, Portainer Server will expose the UI over port 9443 and expose a TCP tunnel server over port 8000\n"
        echo "What do you want to do?"
        echo "   1) Expose 9443 and generate a self-signed SSL (Default)"
        echo "   2) Expose 9000 (Legacy)"
        echo "   3) Expose both ports (If you require HTTP port 9000 open for legacy reasons)"
        until [[ "${port_choice}" =~ ^[0-9]+$ ]] && [ "${port_choice}" -ge 1 ] && [ "${port_choice}" -le 3 ]; do
            read -rp "Select: [1-3]:" -e -i 1 port_choice
        done
        case "${port_choice}" in
            1) ports='-p 9443:9443' ;;
            2) ports='-p 9000:9000' ;;
            3) ports='-p 9443:9443 -p 9000:9000' ;;
        esac

        echo -e "Preparing to Install Portainer-CE\n"
        echo ""
        echo ""

        docker volume create portainer_data
        docker run -d -p 8000:8000 $ports --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
        echo ""
        echo ""
        echo "Navigate to your server hostname / IP address on chosen ports and create your admin account for Portainer-CE"

        echo ""
        echo ""
        echo ""
        sleep 5s
    fi
    exit 1
}

echo ""
echo ""

echo "Let's figure out which OS / Distro you are running."
PS3="Please select the number for your OS / distro: "
select _ in \
    "CentOS 7" \
    "Debian 10" \
    "Ubuntu 18.04" \
    "Ubuntu 20.04" \
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
