#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE
echo "install environment ..."
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")

cpu_arch=$(lscpu | head -n 1 | awk '{print $2}')

pushd $HERE
  echo "install conda ..."

  which conda
  if [ $? -ne 0 ]; then
    # install miniconda
    conda_file=Miniconda3-py38_4.11.0-Linux-${cpu_arch}.sh
    if [ ! -e $conda_file ]; then
      wget https://repo.anaconda.com/miniconda/${conda_file};
      if [ $? -ne 0 ]; then
        echo "download miniconda fail!"
        popd
        exit 1
      fi
    fi
    bash $conda_file
    # install softwares
    source $HOME/.bashrc
    conda install cmake
  fi

  echo "install conda successfully"
popd

if [ ! -e $HOME/software ]; then mkdir $HOME/software; fi
if [ ! -e $HOME/software/source_code ]; then mkdir $HOME/software/source_code; fi


# install ag and universal-ctags
pushd $HERE

# install ag
read -p "install the silver search ag? [y/n]" ans
if [ "$ans" == "y" ]; then
  # apt dependencies
  echo "Note: make sure installed software"
  echo "  pkg-config libpcre3-dev zlib1g-dev liblzma-dev"
  pushd source_code/the_silver_searcher
   ./build.sh --prefix=$HOME/software 
   if [ $? -ne 0 ]; then
      echo "Note: make sure installed software"
      echo "  pkg-config libpcre3-dev zlib1g-dev liblzma-dev"
      exit 1
   fi
   make install
  popd
fi

# install universal-ctags
read -p "install universal-ctags? [y/n]" ans
if [ "$ans" == "y" ]; then
  pushd source_code/ctags
    ./autogen.sh
    ./configure --prefix=$HOME/software
    make -j
    make install
  popd
fi

popd

# change enviroment values
read -p "add env values? [y/n]" ans

if [ "$ans" == "y" ]; then
  pushd $HOME
  cp .bashrc .bashrc.old
  echo -e "\n\n# custom software setting" >> .bashrc
  echo 'export PATH="$HOME/software/bin:$PATH"' >> .bashrc
  echo 'export LD_LIBRARY_PATH="$HOME/software/lib:$HOME/software/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"' >> .bashrc
  echo 'export LIBRARY_PATH="$HOME/software/lib:$HOME/software/lib/x86_64-linux-gnu:$LIBRARY_PATH"' >> .bashrc
  echo 'export CPATH="$HOME/software/include:$CPATH"' >> .bashrc
  echo 'export MANPATH="$HOME/software/share/man:$MANPATH"' >> .bashrc

popd
fi
