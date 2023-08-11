#!/bin/bash

#set -x
echo 
echo "********** Provided variales ********************************"
echo

# provoding git credentials
GIT_USERNAME='satishkollati'
GIT_PASSWORD='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'
bbname='satishkollati'
WORKSPACE='codepipeline9'

echo
echo "************ getting Bitbucket Repos Reports******************"
echo

curl -u satishkollati:ATBBk5MJVVd7eTPajnKFCC3zW5Vg3B3BCDE6 --request GET --url "https://api.bitbucket.org/2.0/repositories/codepipeline9?q=project.key%3D%22AW%22" | jq -r '.values[] | .name' >repos.txt
dos2unix repos.txt
repos=$(cat repos.txt)

cat repos.txt | while read REPO; do
    echo "$REPO" fetching
    git clone https://satishkollati@bitbucket.org/codepipeline9/$REPO
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

    git push --mirror git@github.com:$GIT_USERNAME/$REPO.git

    cd ..

    echo
    echo "*********** Removing $REPO in local *****************************"
    echo

    rm -rf $REPO

    echo "$REPO Repository Migration is completed successfully!"

done
