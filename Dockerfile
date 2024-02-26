FROM ubuntu:noble
LABEL maintainer="D Deryl Downey <ddd@davidderyldowney.com>"
LABEL org.opencontainers.image.source="https://github.com/dderyldowney/devops-docker"
LABEL org.opencontainers.image.description="Dockerized DevOps image"
LABEL org.opencontainers.image.licenses="MIT"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get dist-upgrade -y && apt-get install -y --no-install-recommends locales sudo apt-transport-https ca-certificates curl wget git-core gnupg keychain build-essential less vim zip && locale-gen en_US.UTF-8 && /usr/sbin/update-ca-certificates && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && adduser --quiet --disabled-password --shell /bin/bash --home /home/devops --gecos "Johnnie Q. DevOps" devops && echo "devops:devops" | chpasswd &&  usermod -aG sudo devops

# INSTALL GITHUB-CLI & LATEST NODEJS FROM PPAs
# USES SEPERATE RUN COMMAND TO CREATE A SEPERATE LAYER TO EASE FUTURE REMOVAL IF DESIRED
RUN type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y) && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y && apt-get clean && cd ~ && curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && /bin/bash ./nodesource_setup.sh && apt-get install -y nodejs && apt-get clean 

# CHANGE CONTEXT TO DEFAULT NON-PRIVILEGED USER
WORKDIR /home/devops
USER devops
ENV LANG en_US.utf8
ENV TERM xterm
CMD ["/bin/bash"]
