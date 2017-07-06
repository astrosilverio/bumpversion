#!/bin/bash

#######################################
# Get which part of version to bump
#######################################

# if no version specified, bump bugfix
if [ -z "$*" ]; then BUMP_BUGFIX=1; fi

# if there are args, scan through them to get version to bump
for i in "$@"
do
case $i in
-m|--major)
    BUMP_MAJOR=1
    shift
    ;;
-n|--minor)
    BUMP_MINOR=1
    shift
    ;;
-b|--bugfix)
    BUMP_BUGFIX=1
    ;;
--dryrun)
    DRYRUN=1
    ;;
*)
    echo "unknown command"
    exit 1
    ;;
esac
shift
done

# if the only arg was --dryrun, bump bugfix
if [ "$DRYRUN" ] && ([ -z $BUMP_MAJOR ] || [ -z $BUMP_MINOR ] || [ -z $BUMP_BUGFIX ]); then
    BUMP_BUGFIX=1
fi

# if more than one version to bump is specified, error
if [ $(($BUMP_MAJOR+$BUMP_MINOR+$BUMP_BUGFIX)) -gt 1 ]; then
    echo "more than one version bump specified"
    exit 1
fi

#######################
# Get current version
#######################

CURRENT_VERSION=$(sed -n 's/__version__ = //p' "$(pwd)/${PWD##*/}/version.py")

CURRENT_MAJOR=$(echo $CURRENT_VERSION | sed -n -E "s/\'([0-9]+).*/\1/p")
CURRENT_MINOR=$(echo $CURRENT_VERSION | sed -n -E "s/\'[0-9]+\.([0-9]+).*/\1/p")
CURRENT_BUGFIX=$(echo $CURRENT_VERSION | sed -n -E "s/\'[0-9]+\.[0-9]+\.([0-9]+).*/\1/p")

############################
# Create new version
############################

if [ "$BUMP_MAJOR" ] ; then
    NEW_MAJOR=$(($CURRENT_MAJOR+1))
    NEW_MINOR=0
    NEW_BUGFIX=0
elif [ "$BUMP_MINOR" ] ; then
    NEW_MAJOR=$CURRENT_MAJOR
    NEW_MINOR=$(($CURRENT_MINOR+1))
    NEW_BUGFIX=0
elif [ "$BUMP_BUGFIX" ] ; then
    NEW_MAJOR=$CURRENT_MAJOR
    NEW_MINOR=$CURRENT_MINOR
    NEW_BUGFIX=$(($CURRENT_BUGFIX+1))
fi

NEW_VERSION="'"$NEW_MAJOR"."$NEW_MINOR"."$NEW_BUGFIX"'"

##############################
# Echo and write new version
##############################

echo CHANGING VERSION FROM "$CURRENT_VERSION" TO "$NEW_VERSION"

if [ -z "$DRYRUN" ]; then
    sed -i '' -- "s/$CURRENT_VERSION/$NEW_VERSION/g" "$(pwd)/${PWD##*/}/version.py"
fi
