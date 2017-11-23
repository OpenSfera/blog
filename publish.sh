#!/bin/bash

# Publish on gp-pages branch....
#
# because I prefer scripting this step


WORKPLACE=$(mktemp -d)
trap "rm -rf $WORKPLACE" EXIT

jekyll clean
jekyll build

if [ -d "./_site" ]; then
  mv ./_site $WORKPLACE
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git checkout gh-pages
  ls | xargs rm -rf
  mv $WORKPLACE/_site/* .
  git add -A
  git commit -m "[`whoami`] on @`date +%Y-%m-%d_%H:%M`@ publish those weird posts"
  if git push origin gh-pages; then
    echo "DEPLOYED"
  else
    echo "DEPLOY FAIL"
  fi
  git checkout $CURRENT_BRANCH
  else
    echo "BUILD FAIL"
fi
