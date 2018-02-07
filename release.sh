#!/bin/bash
set -e

rm -rf ./dist;
./build_android.sh;
./build_ios.sh;

cd ./dist;

tar -czvf ../release.tar.gz ./