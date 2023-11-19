#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")
num_cores=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $num_cores -ne 1 ]; then
  num_cores=$((num_cores-1))
fi
echo "compile with $num_cores CPUs"

read -p "install vim with lua,python? [y/n]" ans
if [ "$ans" == "y" ]; then
  # install lua
  pushd $HERE/source_code/lua-5.4.4
    make -j $num_cores
    make install "INSTALL_TOP=$HOME/software"
  popd

  # install ncurses
  pushd $HERE/source_code/ncurses-6.3
    ./configure --prefix=$HOME/software
    make -j $num_cores
    make install
  popd

  # install vim
  pushd $HERE/source_code/vim
    p3_v=$(python3 --version | sed 's/Python \([0-9]\.[0-9]*\)\..*/\1/g')
    ln -s ${CONDA_PREFIX}/lib/libpython${p3_v}.so ${HOME}/software/lib/libpython${p3_v}.so
    detail_f_name=$(readlink -f ${CONDA_PREFIX}/lib/libpython${p3_v}.so | awk -F "\/" '{print $NF}')
    ln -s ${CONDA_PREFIX}/lib/${detail_f_name} ${HOME}/software/lib/${detail_f_name}
    ./configure \
            --prefix=$HOME/software \
            --enable-luainterp=yes \
            --with-lua-prefix=$HOME/software \
            --enable-python3interp \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-cscope \
            --disable-netbeans \
            --enable-terminal \
            --disable-xsmp \
            --enable-fontset \
            --enable-multibyte \
            --enable-fail-if-missing \
            --with-compiledby=leolord \
            --with-modified-by=leolord
    make -j $num_cores
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
    # vim +BundleInstall! +BundleClean +q
    vim +BundleInstall +BundleClean +q
  popd
fi
