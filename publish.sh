#!/bin/bash

# Publish on gp-pages branch....
#
# because I prefer scripting this step


WORKPLACE=$(mktemp -d)
trap "rm -rf $WORKPLACE" EXIT

jekyll clean
JEKYLL_ENV=production jekyll build

if [ -d "./_site" ]; then
  mv ./_site $WORKPLACE
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if git checkout gh-pages; then
    ls | xargs rm -rf
    mv $WORKPLACE/_site/* .
    git add -A
    git commit -m "[`whoami`] on @`date +%Y-%m-%d_%H:%M`@ publish those weird posts"
    if git push origin gh-pages; then
      echo "PUBLISH: deployed"
    else
      echo "PUBLISH: deploy fail"
    fi
    git checkout $CURRENT_BRANCH
  else
    echo "PUBLISH: You should commit changes before publishing"
  fi
  else
    echo "PUBLISH: build fail"
fi
