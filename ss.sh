#!/bin/bash
set -x
curl -u satishkollati:ATBBk5MJVVd7eTPajnKFCC3zW5Vg3B3BCDE6 --request GET --url "https://api.bitbucket.org/2.0/repositories/codepipeline9?q=project.key%3D%22AW%22" | jq -r '.values[] | .name' >repos.txt
dos2unix repos.txt
cat repos.txt | while read REPO; do
   echo "$REPO"
   git clone https://satishkollati@bitbucket.org/codepipeline9/$REPO
   cd $REPO
   if [ $? -ne 0 ]; then

      echo " changed to $REPO "

      exit 1
   fi
   cd ..
done
