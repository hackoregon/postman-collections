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

    # Push and Deploy only if it's not a pull request
    if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

      # Push only if we're testing the master branch
      if [ "$TRAVIS_BRANCH" == "master" ]; then
        node_modules/.bin/newman run "${f}" --env-var slack-web-hook=$SLACKWEBHOOK

        curl -X POST \
          $SLACKWEBHOOK \
          -H 'Content-Type: application/json' \
          -d '{
            "attachments": [{"pretext":"Travis Build URL:","text":"'$TRAVIS_BUILD_WEB_URL'","mrkdwn_in":["text","pretext"]}]
        }'

      else
           echo "Skipping deploy because branch is not master"
       fi
    else
       echo "Skipping deploy because it's a pull request"
    fi
  fi
done
