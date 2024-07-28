# Develop Your Way

The provided code is a Dockerfile, which is a script used to create a Docker image. A Docker image is a lightweight, standalone, executable package that includes everything needed to run an application, including the code, runtime, system tools, system libraries, and settings.

Here's a breakdown of what the code does:

Base Image : The Dockerfile starts by specifying the base image as the latest version of Ubuntu (FROM ubuntu:latest).

Metadata : It sets various labels with information about the maintainer, source code repository, description, and licenses.

Environment Variable : It sets the DEBIAN_FRONTEND environment variable to noninteractive to avoid prompts during package installation.

Package Installation : The script updates the package lists, upgrades the installed packages, and installs various development tools and libraries. These include locales, sudo, apt-transport-https, ca-certificates, zsh, curl, wget, git, build-essential, vim, zip, and various libraries for programming languages like Ruby, Node.js, and Rust.

User Creation : It creates a new user named "devops" with a password "devops" and adds the user to the sudo group.

GitHub CLI and Node.js Installation : It installs the GitHub CLI tool and the latest version of Node.js (18.x) from their respective PPAs (Personal Package Archives).

Port Exposure : It exposes ports 3000 and 5432, which are commonly used for web applications and databases, respectively.

Working Directory and User Switch : It changes the working directory to /home/devops and switches to the non-privileged "devops" user.

Oh My Zsh Installation : It installs the Oh My Zsh framework for the Zsh shell, which provides a better user experience and additional functionality.

Ruby Environment Setup : It clones the rbenv and ruby-build repositories, which are used for managing multiple Ruby versions and installing Ruby gems. It also creates a directory for Git repositories.

Environment Variables : It sets various environment variables, such as the default shell, language, terminal emulator, and text editor.

Default Command : Finally, it sets the default command to run the Zsh shell when the container starts.

In summary, this Dockerfile creates a Docker image based on the latest LTS Ubuntu with various development tools and libraries installed, sets up a non-privileged user account, installs additional tools like GitHub CLI, Node.js, and Oh My Zsh, and configures the initial environment for Ruby, NodeJS, and Python3 development. The resulting Docker image can be used as a development environment for coding and running applications locally using Docker or Docker Desktop.

## Current Project Status

[![Publish Docker Image](https://github.com/dderyldowney/devops-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/dderyldowney/devops-docker/actions/workflows/docker-publish.yml)

[![Docker Image for CI](https://github.com/dderyldowney/devops-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/dderyldowney/devops-docker/actions/workflows/docker-image.yml)

[![Anchore Syft SBOM scan](https://github.com/dderyldowney/devops-docker/actions/workflows/anchore-syft.yml/badge.svg)](https://github.com/dderyldowney/devops-docker/actions/workflows/anchore-syft.yml)

## How Do I Use This Thing?

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) on your machine.
- Install [Git For Windows](https://git-scm.com/download/win)
- From either Powershell or a regular CMD window, execute the following:

```zsh
git clone https://github.com/dderyldowney/devops-docker.git
cd devops-docker
docker build --rm --no-cache -t devops-docker:latest -f Dockerfile .
```

This will build the image and tag it as `devops-docker:latest`
To use the image for actual development, you can run:

```zsh
docker run --rm -ti --name devops devops-docker:latest
```

## Any Gotchas?

Remember that as soon as you exit the resulting container your stuff disappears, and the
container returns to the image state. If you want to persist your work, like cloned git repos,
you will need to create and use a Docker volume. For example, you can create a volume and mount
it when you create a container as follows:

```zsh
docker volume create github
docker run --name devops -dt -v github:/home/devops/github devops-docker:latest
docker attach devops
```

This will

- Create a docker volume
- Attach it to `/home/devops/github` in the resulting container
- Put the container into the background with a pseudo tty
- The last command will connect you to it

When you log in, you should see the `github` directory in the devops user's `$HOME`.
This is where that volume you created earlier is mounted for long term storage.
Everything that goes into this directory will persist for later use.

Change into that directory and clone whatever repositories you want/need.
When you disconnect, stop, or even delete the container your data will be safe and sound
in that volume. Cool thing is you can attach it to whatever other containers you wish, as well.

## I want to make changes. How can I store those changes

Lets say you want to add more packages but don't want to constantly have to rebuild the image.
You can update the image you've already built by doing commits from the container against the image.

For example, lets say you decide to install Apache webserver but don't want to specify that in the
initial image build (ie. in the Dockerfile itself). Or, say you install rbenv or add a .gitconfig.
No problem at all! **WITHOUT** exiting the running container, open _another_ shell/cmd/terminal on
the _host machine_ and simply do the following steps in _that_ shell/cmd/terminal:

Run `docker container ls` and find the `CONTAINER ID` sha.

```zsh
$ docker container ls
CONTAINER ID   IMAGE          COMMAND       CREATED       STATUS         PORTS     NAMES
210f5cd9e972   b57a6804f9e1   "/bin/bash"   4 hours ago   Up 5 seconds             devops
$
```

Copy that sha and run the following command:

```zsh
docker commit 210f5cd9e972 devops-docker:latest
```

You can now close the terminal, then exit and stop the container you're working in.

That's it! Now, whenever you create a new container from your existing `devops-docker:latest` image
it will contain anything you've added up to, and including, that particular sha.
Made more changes? No problem! Simply wash, rinse, and repeat.

**NOTE:** If you have a [Docker Hub account](https://hub.docker.com) you can create a repo there, and simply push
your image up. Remember to re-push _every_ time you make a new commit against the original image from the container
to keep the Docker Hub image constantly up to date without having to do a complete rebuild.

```zsh
docker push <your_hub_username>/devops-docker:latest
```

That's about it for now! If you have any suggestions or improvements, feel free to open an Issue or make a Pull Request.

Enjoy!

**POSTNOTE:** I'll be adding how to work with `docker-compose` using this repository, so watch for a `docker-compose.yml`
and these instructions to be updated! Full service fun! Woot!

---

> "Keep moving foward! Learn something new every day!" -- D Deryl Downey
