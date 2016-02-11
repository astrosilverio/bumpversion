#!/bin/bash

# Get which version to bump
if [ -z "$*" ]; then BUMP_BUGFIX=true; fi

for i in "$@"
do
case $i in
    -m|--major)
    BUMP_MAJOR=true
    ZERO_MINOR=true
    ZERO_BUGFIX=true
    shift # past argument
    ;;
    -n|--minor)
    BUMP_MINOR=true
    ZERO_BUGFIX=true
    shift # past argument
    ;;
    -b|--bugfix)
    BUMP_BUGFIX=true
    ;;
    --dryrun)
    DRYRUN=true
    ;;
esac
shift # past argument or value
done

MAJOR_INDEX=2
MINOR_INDEX=4
BUGFIX_INDEX=6

FILENAME="setup.py"

CURRENT_VERSION=$(sed -n 's/__version__ = //p' setup.py)

CURRENT_MAJOR=$(echo $CURRENT_VERSION | sed -n -E "s/\'([0-9]+).*/\1/p")
CURRENT_MINOR=$(echo $CURRENT_VERSION | sed -n -E "s/\'[0-9]+\.([0-9]+).*/\1/p")
CURRENT_BUGFIX=$(echo $CURRENT_VERSION | sed -n -E "s/\'[0-9]+\.[0-9]+\.([0-9]+).*/\1/p")

if [ "$BUMP_MAJOR" = true ] ; then
    NEW_MAJOR=$(($CURRENT_MAJOR+1))
    NEW_MINOR=0
    NEW_BUGFIX=0
elif [ "$BUMP_MINOR" = true ] ; then
    NEW_MAJOR=$CURRENT_MAJOR
    NEW_MINOR=$(($CURRENT_MINOR+1))
    NEW_BUGFIX=0
else
    NEW_MAJOR=$CURRENT_MAJOR
    NEW_MINOR=$CURRENT_MINOR
    NEW_BUGFIX=$((CURRENT_BUGFIX+1))
fi

NEW_VERSION="'"$NEW_MAJOR"."$NEW_MINOR"."$NEW_BUGFIX"'"

echo CHANGING VERSION FROM "$CURRENT_VERSION" TO "$NEW_VERSION"

if [ -z "$DRYRUN" ]; then
    sed -i '' -- "s/$CURRENT_VERSION/$NEW_VERSION/g" setup.py
fi

