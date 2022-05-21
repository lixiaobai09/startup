#!/bin/bash

HERE="$(dirname $(readlink -f $0))"
echo $HERE

echo "clean the building files"

pushd $HERE/source_code
for source_dir in $(ls .)
do
  pushd $source_dir
    make clean
    make distclean
  popd
done
popd
