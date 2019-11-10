#! /bin/bash

FILES=./2019/*
for f in $FILES
do
  filename=$(basename "$f")
  fname="${filename%.*}"
  if [[ -z ${TRAVIS} ]];
  then
    source .env
    newman run "${f}" --env-var slack-web-hook=$SLACKWEBHOOK
  else
    node_modules/.bin/newman run "${f}" --env-var slack-web-hook=$SLACKWEBHOOK
  fi
done
