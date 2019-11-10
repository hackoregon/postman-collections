#! /bin/bash

# newman run 2019/Hack\ Oregon\ Housing\ 2019\ API.postman_collection.json

FILES=./2019/*
for f in $FILES
do
  filename=$(basename "$f")
  fname="${filename%.*}"
  echo $fname
  echo "Processing $fname file..."
  if [[ -z ${TRAVIS} ]];
  then
    newman run "${f}"
    echo "here"
  else
    node_modules/.bin/newman run "${f}"
    echo "there"
  fi
done
