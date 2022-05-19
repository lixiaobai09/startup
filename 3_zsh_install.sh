#!/bash/bin

HERE="$(dirname $(readlink -f $0))"
echo $HERE
echo "install environment ..."
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")

pushd $HERE/zsh

which zsh
if [ $? -ne 0 ]; then
  echo "please install zsh first!"
  exit 1
fi

read -p "install oh-my-zsh? [y/n]" ans
if [ "$ans" == "y" ]; then
  ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
  sh ./ohmyzsh_install.sh

  # copy .zshrc
  if [ -e $HOME/.zshrc ]; then
    cp $HOME/.zshrc $HOME/.zshrc_${TIME_STAMPS}
  fi
  cp ./.zshrc $HOME/
  # copy example.zsh
  if [ -e $ZSH_CUSTOM/example.zsh ]; then
    cp $ZSH_CUSTOM/example.zsh $ZSH_CUSTOM/example.zsh_${TIME_STAMPS}
  fi
  cp ./custom_example.zsh $ZSH_CUSTOM/example.zsh

  # install zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  # support conda
  which conda
  if [ $? -eq 0 ]; then
    conda init zsh
  fi
fi

read -p "use zsh as default shell? [y/n]" ans
if [ "$ans" == "y" ]; then
  if [ -e $HOME/.bash_profile ]; then
    cp $HOME/.bash_profile $HOME/.bash_profile_${TIME_STAMPS}
  fi
  echo "export SHELL=/bin/zsh" > $HOME/.bash_profile
  echo "exec /bin/zsh -l" >> $HOME/.bash_profile
fi

popd

echo    "if ZSH_THEME agnoster is not effictive"
echo    "  please install locales"
echo    "  run command \"locale-gen en_US.UTF-8\" with root privilege"
echo -e "  and use hack font in terminal software(recommend)"
