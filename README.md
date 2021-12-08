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
First, you'll be prompted to select the number for your OS / Distro.  Currently I support CentOS 7 and 8, Debian 10 and 11, Ubuntu 18.04, 20.04, 21.04, and 21.10. 

Next, you'll be asked to answer "y" to any of the four software packages you'd like to install. 
- Docker-CE
- Docker-Compose
- NGinx Proxy Manager
- Portainer-CE
  - if you answer y to Portainer, you'll be asked another question

Do you want full Portainer-CE with the web UI, or just Portainer-agent (which you connect to another full portainer instance). 

Make that selection, and the install will continue.

Answering "n" to any of them will cause them to be skipped.

### NOTE
* You must have Docker-CE (or some version of Docker) installed in order to run any of the other three packages.
* You must have Docker-Compose installed in order to run NGinX Proxy Manager.

Before prompting to install Docker or Docker-Compose, I do try to see if you already have them installed, and I skep the prompt if you do (or I try to anyway).

## Recent changes
1. Removed a lot of the "screen spam" from stdout, and just provide step information for what is running.
2. Imrpoved the Debian 11 wait time for the Docker service to start up and be running.

## Future Work
[ ] Make it work for Raspberry Pi
[ ] Make it work for Arch
[ ] Make it work for OpenSuse
[ ] Maybe add a few other default containers to pull down and start running
[ ] Prompt for Credentials to use in NGinX Proxy Manager db settings vs. using the defaults.

## Contributing
If you find issues, please let me know. I'm always open to new contributors helping me add Distro support, more software packages, etc.  Just clone the project and make a pull request with any changes you add. 

## Licensing
My script is offered without warranty against defect, and is free for you to use any way / time you want.  You may modify it in any way you see fit.  Please see the individual project pages of the software packages for their licensing.