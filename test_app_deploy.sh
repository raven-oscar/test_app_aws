#!/bin/bash

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            --bandle)              BANDLE=${VALUE} ;;
            *)   
    esac
done 


if [ "$1" == "-h" ]; then
  echo """test_app deploy
Usage: ./test_app_deploy.sh --[args]

args:
  --bandle: zip bundle uploaded to s3

env vars mast be set:
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  """
  exit 0
fi

aws deploy create-deployment \
    --application-name test_app \
    --deployment-config-name CodeDeployDefault.OneAtATime \
    --deployment-group-name test_app \
    --s3-location bucket=e-task-app,bundleType=zip,key=${BANDLE} \
    --region eu-central-1
