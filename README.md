# Linux Startup

- [Linux Startup](#linux-startup)
  * [How to use](#how-to-use)
  * [Environment preparation (0_env_prepare.sh)](#environment-preparation-0_env_preparesh)
  * [Vim (1_vim_install.sh)](#vim-1_vim_installsh)
  * [Tmux (2_tmux_install.sh)](#tmux-2_tmux_installsh)
  * [Zsh (3_zsh_install.sh)](#zsh-3_zsh_installsh)

This repository is used to create a new development environment in Linux without root privilege. The environment includes miniconda, the_sivler_searcher, universal-ctags, vim, tmux, oh-my-zsh, and their configuration files.

## How to use

1. Clone this repository to local directory.
2. Run bash scripts sequencely: 0_env_prepare.sh, 1_vim_install.sh, 2_tmux_install.sh, 3_zsh_install.sh.

## Environment preparation (0_env_prepare.sh)

This script will install miniconda, the_sivler_seacher and universal-ctags.

The user needs to run this script twice. 
1. The user installs miniconda and does not install other tools. Then re-entering the current terminal session to let conda usable and run command `conda install cmake`.
2. Install next tools: the_silver_searcher(ag) and universal-ctags.

## Vim (1_vim_install.sh)

This script will install vim, dependency tools of vim, and configure vim with wonderful plugins.

The vim plugins refer to [spf13-vim](https://github.com/spf13/spf13-vim). And this repository changed some plugins and configuration files(Like: neocomplete -> deoplete, mapping cscope shortcut keys).

## Tmux (2_tmux_install.sh)

The user needs to install tmux with a command like `apt install tmux`. Then the user runs this script to configure tmux.

## Zsh (3_zsh_install.sh)

A script to install and configure oh-my-zsh.
