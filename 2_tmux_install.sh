#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE
echo "config tmux ..."
TIME_STAMPS=$(date "+%Y-%m-%d_%H-%M-%S")

pushd $HOME
if [ -e .tmux.conf ]; then
  cp .tmux.conf .tmux.conf_${TIME_STAMPS}
fi
cp $HERE/tmux/.tmux.conf .
popd
