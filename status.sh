#!/bin/bash

#######################
# Get current version
#######################

CURRENT_VERSION=$(sed -n 's/__version__ = //p' "$PWD/${PWD##*/}/version.py")

#############################
# Get last published version
#############################

LATEST_INSTALLED_VERSION=$(pip show ${PWD##*/} | sed -n -e '/Version/p' | sed 's/Version: //')

LAST_VERSION_COMMIT_SHA=$(git log --grep=$CURRENT_VERSION --oneline | head -c 7)

printf "Latest installed version: %s\n\nCurrent local version: %s\n\nCommits since latest installed version:\n\n%s\n" "$LATEST_INSTALLED_VERSION" "$CURRENT_VERSION" "$(git log --oneline 312da19..HEAD)"
