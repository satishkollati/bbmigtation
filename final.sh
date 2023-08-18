#!/bin/bash

set -x

#LOG_FILE="script.log"

#log() {
 #   local timestamp=$(date +"%Y-%m-%d %T")
 #   echo "[$timestamp] $1" >>"$LOG_FILE"
#}

#log "Script started"
# Your script commands here

DATE=$(date +%F)
SCRIPT_FILE_NAME="bbtestmigration"
LOGFILE==/c/Users/Lenovo/Desktop/testbit/bbmigtation/$SCRIPT_FILE_NAME-$DATE.log

RED="\e[31m"
GREEN="\e[32m"

#echo -e "${RED} "
echo
echo "********** Provided variales ********************************"
echo

# provoding git credentials
GIT_USERNAME='satishkollati'
GIT_PASSWORD='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'
bbname='satishkollati'
WORKSPACE='codepipeline9'
bitbucket_pass='ATBBk5MJVVd7eTPajnKFCC3zW5Vg3B3BCDE6'
projectkey='BB2GHMIG'

echo
echo "************ getting Bitbucket Repos Reports******************"
echo

curl -u $bbname:$bitbucket_pass --request GET --url "https://api.bitbucket.org/2.0/repositories/$WORKSPACE?q=project.key%3D%22$projectkey%22" | jq -r '.values[] | .name' >repos.txt
dos2unix repos.txt

cat repos.txt | while read REPO; do
    echo "$REPO" fetching
    # git clone --mirror https://$bbname@bitbucket.org/$WORKSPACE/$REPO.git
    git clone git@bitbucket.org:codepipeline9/$REPO.git 
    cd $REPO
    if [ $? -ne 0 ]; then
        echo " changed to $REPO "
        exit 1
    fi

    echo
    echo "************ $REPO cloned, now creating on github ***************"
    echo

    # Creating a repository on github
    curl -u $GIT_USERNAME:$GIT_PASSWORD https://api.github.com/user/repos \
        -d "{\"name\": \"$REPO\", \"private\": true}"

    echo
    echo "*********** Mirroring $REPO to github ****************************"
    echo

    git push --mirror git@github.com:$GIT_USERNAME/$REPO.git &>>$LOGFILE

    cd ..

    echo
    echo "*********** Removing $REPO in local *****************************"
    echo

    rm -rf $REPO &>>$LOGFILE
    echo -e "${GREEN} $REPO Repository Migration is completed successfully!"

done

#log "Script finished"
