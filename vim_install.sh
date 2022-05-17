#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")
vundle_url="https://github.com/VundleVim/Vundle.vim.git"

pushd $HOME
  # bachup the old vim file
  old_files=".vimrc  .vimrc.bundles  .vimrc.bundles.local  .vimrc.local"
  for file in $old_files
  do
    if [ -f $file ] ; then cp $file ${file}_bak_${TIME_STAMPS}; fi
  done

  # copy vim configures to $HOME
  cp -r $HERE/vim/. .
  if [ ! -f .vim/bundle ]; then mkdir .vim/bundle; fi
  git clone $vundle_url ./.vim/bundle/vundle
  vim +BundleInstall! +BundleClean +q
popd

