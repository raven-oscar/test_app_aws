#!/bin/bash

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            --version)              VERSION=${VALUE} ;;
            *)   
    esac
done 


if [ "$1" == "-h" ]; then
  echo """test_app build
Usage: ./test_app_build.sh --[args]

args:
  --version: app version

aws-cli tools mast be installed

env vars mast be set:
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  """
  exit 0
fi

rm -rf build_dir
mkdir build_dir
mkdir build_dir/test_app 

cp -R repo/scripts build_dir/
cp -R repo/systemd build_dir/
cp repo/appspec.yml build_dir/appspec.yml
cp repo/distrib/eVision-product-ops.linux.${VERSION} build_dir/test_app/app
chmod 755 build_dir/test_app/app
cd build_dir
zip -r app-${VERSION}.zip *
aws s3 cp app-${VERSION}.zip s3://e-task-app/
cd ..
rm -rf build_dir


