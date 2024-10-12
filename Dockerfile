From ubuntu:24.04

RUN apt-get update \
    && apt-get install -y vim git wget python3 pip zsh tmux curl \
    && apt-get install -y silversearcher-ag \
    && apt-get install -y universal-ctags \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN py_version=$(python3 -V | grep -oP 'Python \K[\d.]+(?=.\d)'); \
    rm /usr/lib/python${py_version}/EXTERNALLY-MANAGED; \
    pip install pynvim msgpack

WORKDIR /root/

COPY ./vim/. ./
ARG vundle_url="https://github.com/VundleVim/Vundle.vim.git"
RUN if [ ! -e .vim/bundle ]; then mkdir -p .vim/bundle; fi; \
    git clone $vundle_url ./.vim/bundle/vundle; \
    echo "\n" | vim +BundleInstall +qall 2> /dev/null; \
    echo "success"

RUN mv ./.vim /opt/; \
    ln -s /opt/.vim .vim
