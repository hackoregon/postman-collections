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

curl -X POST \
  $SLACKWEBHOOK \
  -H 'Content-Type: application/json' \
  -d '{
    "attachments": [{"pretext":"Travis Build URL:","text":"'$TRAVIS_BUILD_WEB_URL'","mrkdwn_in":["text","pretext"]}]
}'
