# Develop Your Way
This is the initial Dockerfile for creating a complete development
environment under Docker / Docker Desktop for local coding use.
This uses the latest Ubuntu development branch, adds baseline apps
like build-essential, sudo, locales, ca-certificates, git, gnupg, and GitHub CLI.

It creates a default non-privileged user called `devops` with the
password set to `devops` and assigns it sudo rights.

# How Do I Use This Thing?

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) on your machine.
- Install [Git For Windows](https://git-scm.com/download/win)
- From either Powershell or a regular CMD window, execute the following:

```
git clone https://github.com/dderyldowney/devops-docker.git
cd devops-docker
docker build --rm --no-cache -t devops-docker:latest -f Dockerfile .
```

This will build the image and tag it as `devops-docker:latest`
To use the image for actual development, you can run:

```
docker run --rm -ti --name devops devops-docker:latest
```

# Any Gotchas?
Remember that as soon as you exit the resulting container your stuff disappears, and the
container returns to the image state. If you want to persist your work, like cloned git repos,
you will need to create and use a Docker volume. For example, you can create a volume and mount
it when you create a container as follows:

```
docker volume create github
docker run --name devops -dt -v github:/home/devops/GitHub devops-docker:latest
docker attach devops
```
This will
  - Create a docker volume
  - Attach it to `/home/devops/GitHub` in the resulting container
  - Put the container into the background with a pseudo tty
  - The last command will connect you to it

When you log in, you should see the `GitHub` directory in the devops user's `$HOME`.
This is where that volume you created earlier is mounted for long term storage.
Everything that goes into this directory will persist for later use.

# NOTE
The first time you attach the volume, the directory in the container you attached it to
will probably be owned by root instead of your user which will prevent you from saving anything
into that directory. Completely simple fix. As the `devops` user, run the following command.
You'll only have to do this once, _the very first time_, for as long as you use the same volume. 
The password `sudo` will ask for is the one for the `devops` user which is.. well.. `devops` 
(lol, see? simple!)

```
sudo chown -R devops:devops /home/devops/GitHub
```

That will change ownership of the mountpoint to the `devops` user and all files written to the directory
will be stored on the volume and maintain their permissions. You should have no read/write issues.

Now, back to the good stuff...

Change into that directory and clone whatever repositories you want/need.
When you disconnect, stop, or even delete the container your data will be safe and sound
in that volume. Cool thing is you can attach it to whatever other containers you wish, as well.

# I want to make changes. How can I store those changes.
Lets say you want to add more packages but don't want to constantly have to rebuild the image.
You can update the image you've already built by doing commits from the container against the image.

For example, lets say you decide to install Apache webserver but don't want to specify that in the 
initial image build (ie. in the Dockerfile itself). Or, say you install rbenv or add a .gitconfig. 
No problem at all! **WITHOUT** exiting the running container, open _another_ shell/cmd/terminal on 
the _host machine_ and simply do the following steps in _that_ shell/cmd/terminal:

Run `docker container ls` and find the `CONTAINER ID` sha.

```
$ docker container ls
CONTAINER ID   IMAGE          COMMAND       CREATED       STATUS         PORTS     NAMES
210f5cd9e972   b57a6804f9e1   "/bin/bash"   4 hours ago   Up 5 seconds             devops
$
```

Copy that sha and run the following command:

```
docker commit 210f5cd9e972 devops-docker:latest
```

You can now close the terminal, then exit and stop the container you're working in.

That's it! Now, whenever you create a new container from your existing `devops-docker:latest` image
it will contain anything you've added up to, and including, that particular sha.
Made more changes? No problem! Simply wash, rinse, and repeat.

**NOTE:** If you have a [Docker Hub account](https://hub.docker.com) you can create a repo there, and simply push
your image up. Remember to re-push _every_ time you make a new commit against the original image from the container
to keep the Docker Hub image constantly up to date without having to do a complete rebuild.

```
docker push <your_hub_username>/devops-docker:latest
```

That's about it for now! If you have any suggestions or improvements, feel free to open an Issue or make a Pull Request.

Enjoy!

**POSTNOTE:** I'll be adding how to work with `docker-compose` using this repository, so watch for a `docker-compose.yml`
and these instructions to be updated! Full service fun! Woot!

---

> "Keep moving foward! Learn something new every day!" -- D Deryl Downey
