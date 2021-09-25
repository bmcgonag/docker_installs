# docker_installs
This script will help install any, or all, of Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE.

## Reason for Making this Script
I got tired of running individual commands all the time, so I created some scripts to make this very easy. 

1. Clone the repo ( `git clone https://github.com/bmcgonag/docker_installs.git` ), or copy / paste the code from the `install_docker_nproxyman.sh` file into a file on your server. 
2. Change the permissions of the .sh file to make it executable with.

`chmod +x <your-new-file>.sh`

3. Run the installer with

`./<your-new-file>.sh`

## Prompts from the script:
First, you'll be prompted to select the number for your OS / Distro.  Currently I support CentOS 7, Debian 10, Ubuntu 18.04, and Ubuntu 20.04. 

Next, you'll be asked to answer "y" to any of the four software packages you'd like to install. 
- Docker-CE
- Docker-Compose
- NGinx Proxy Manager
- Portainer-CE

Answering "n" to any of them will cause them to be skipped.

### NOTE
* You must have Docker-CE (or some version of Docker) installed in order to run any of the other three packages.
* You must have Docker-Compose installed in order to run NGinX Proxy Manager.

I do not currently check your selections to make sure you haven't tried to install one without having the other.

## Contributing
If you find issues, please let me know. I'm always open to new contributors helping me add Distro support, more software packages, etc.  Just clone the project and make a pull request with any changes you add. 

## Licensing
My script is offered without warranty against defect, and is free for you to use any way / time you want.  You may modify it in any way you see fit.  Please see the individual project pages of the software packages for their licensing.