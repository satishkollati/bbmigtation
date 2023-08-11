#!/bin/bash
# provoding git credentials

set -x
GIT_USERNAME='satishkollati'
GIT_PASSWORD='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'
bbname='satishkollati'
WORKSPACE='codepipeline9'
#read -p 'Enter the  GIT username: ' GIT_USERNAME
#read -p 'Enter the  GIT PASSWD: ' GIT_PASSWORD

# Setting a mirror of source repository
#read -p 'Enetr your bb name: ' bbname
#read -p 'Enter the workspace name: ' WORKSPACE

#read -p 'Enter the repo name: ' REPO
curl -u satishkollati:ATBBk5MJVVd7eTPajnKFCC3zW5Vg3B3BCDE6 --request GET --url "https://api.bitbucket.org/2.0/repositories/codepipeline9?q=project.key%3D%22AW%22" | jq -r '.values[] | .name' >repos.txt
dos2unix repos.txt
repos=$( cat repos.txt )
echo
for REPO in $repos; do

   echo "... Processing $REPO ..."

   #git clone --mirror git@bitbucket.org:$WORKSPACE/$REPO.git
   echo $REPO
   git clone https://satishkollati@bitbucket.org/$WORKSPACE/$REPO.git
   #git clone https://satishkollati@bitbucket.org/codepipeline9/ravi.git
   cd "$REPO"
   if [ $? -ne 0 ]; then
      echo " changed to $REPO "
      exit 1
   fi
   cd ..
   echo

   echo "... $REPO cloned, now creating on github ..."
   echo

   # Creating a repository on github
   curl -u $GIT_USERNAME:$GIT_PASSWORD https://api.github.com/user/repos \
      -d "{\"name\": \"$REPO\", \"private\": true}"
   echo
   echo "... Mirroring $REPO to github ..."
   echo

   # Pushing mirror to github repository
   git push --mirror git@github.com:$GIT_USERNAME/$REPO.git
   cd ..
   # Clean up the local repository
   cd ..
   echo "$REPO Repository Migration is completed successfully!"

done
