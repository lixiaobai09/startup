#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")

read -p "install vim with lua,python? [y/n]" ans
if [ "$ans" == "y" ]; then
  # install lua
  pushd $HERE/source_code/lua-5.4.4
    make -j
    make install "INSTALL_TOP=$HOME/software"
  popd

  # install ncurses
  pushd $HERE/source_code/ncurses-6.3
    ./configure --prefix=$HOME/software
    make -j4
    make install
  popd

  # install vim
  pushd $HERE/source_code/vim
    ./configure \
            --prefix=$HOME/software \
            --enable-luainterp=yes \
            --with-lua-prefix=$HOME/software \
            --enable-python3interp \
            --with-python3-config-dir=$CONDA_PREFIX/lib \
            --enable-cscope \
            --disable-netbeans \
            --enable-terminal \
            --disable-xsmp \
            --enable-fontset \
            --enable-multibyte \
            --enable-fail-if-missing \
            --with-compiledby=leolord \
            --with-modified-by=leolord
    make -j4
    make install
  popd
fi

read -p "install vim plugins? [y/n]" ans
if [ "$ans" == "y" ]; then
  # install python for vim plugin deoplete
  pip install pynvim msgpack
  vundle_url="https://github.com/VundleVim/Vundle.vim.git"
  pushd $HOME
    # store the old vim file
    old_files=".vimrc  .vimrc.bundles  .vimrc.bundles.local  .vimrc.local"
    for file in $old_files
    do
      if [ -f $file ] ; then cp $file ${file}_bak_${TIME_STAMPS}; fi
    done
  
    # copy vim configures to $HOME
    cp -r $HERE/vim/. .
    if [ ! -e .vim/bundle ]; then mkdir .vim/bundle; fi
    git clone $vundle_url ./.vim/bundle/vundle
    vim +BundleInstall! +BundleClean +q
  popd
fi
