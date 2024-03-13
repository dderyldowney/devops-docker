FROM ubuntu:noble
LABEL maintainer="D Deryl Downey <ddd@davidderyldowney.com>"
LABEL org.opencontainers.image.source="https://github.com/dderyldowney/devops-docker"
LABEL org.opencontainers.image.description="Dockerized development environment for local coding using Docker or Docker Desktop"
LABEL org.opencontainers.image.licenses="MIT"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get dist-upgrade -y && apt-get install -y --no-install-recommends locales sudo apt-transport-https ca-certificates zsh curl wget git-core gnupg keychain build-essential less vim zip autoconf patch rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev libpq-dev && locale-gen en_US.UTF-8 && /usr/sbin/update-ca-certificates && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && adduser --quiet --disabled-password --shell /usr/bin/zsh --home /home/devops --gecos "Johnnie Q. DevOps" devops && echo "devops:devops" | chpasswd &&  usermod -aG sudo devops

# INSTALL GITHUB-CLI & LATEST NODEJS FROM PPAs
# USES SEPERATE RUN COMMAND TO CREATE A SEPERATE LAYER TO EASE FUTURE REMOVAL IF DESIRED
RUN type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y) && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y && apt-get clean && cd ~ && curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && /bin/bash ./nodesource_setup.sh && apt-get install -y nodejs && apt-get clean

# Expose base port
EXPOSE "3000:3000"
EXPOSE "5432:5432"

# CHANGE CONTEXT TO DEFAULT NON-PRIVILEGED USER
WORKDIR /home/devops
USER devops
RUN echo 'devops' | chsh -s /usr/bin/zsh && echo 'devops' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install rbenv and ruby-build for ruby developers & directory for git repos
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc && echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc && mkdir -p ~/github

ENV SHELL="/usr/bin/zsh"
ENV LANG en_US.utf8
ENV TERM xterm
ENV EDITOR vim
CMD ["/usr/bin/zsh"]
