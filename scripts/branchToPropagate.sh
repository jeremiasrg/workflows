#!/bin/bash

# filter only "release/" branches
# remove "release/" from the brach names
# Sort as number and remove multilines
# releaseBranches=$(git branch -r | grep 'release/' | tr -d 'origin/release/' | sort -n | xargs)
releaseBranches=$(git branch -r | grep 'release/' | tr -d 'origin/release/' | sort -n | xargs)
echo $releaseBranches



# Replace " " by ","
releaseBranches=$( echo ${releaseBranches// /","})

echo $releaseBranches

# get first param and remove "origin/release/"
currentVersion=$(echo $1 | tr -d 'origin/release/')

echo $currentVersion

# Remove frist part of branch string 
branchesToMerge=$( echo $releaseBranches | grep -oP "$currentVersion.*")

# Remove current version from string
branchesToMerge=$( echo ${branchesToMerge//$currentVersion/})

# add "release/" for each version
branchesToMerge=$( echo ${branchesToMerge//,/",release/"})

# Concat with master
branchesToMerge=$branchesToMerge","

# add "release/" for each version
branchesToMerge=$( echo ${branchesToMerge//,/"\",\""})

# remove the the last two caracters (,")
branchesToMerge=${branchesToMerge::-1}

# remove the first caracter of string (",)
branchesToMerge=${branchesToMerge#??}

# Concat with master
branchesToMerge=$branchesToMerge"\"master\""

echo $branchesToMerge 

branchesToMergeMTX=$(echo "[${branchesToMerge}]" | jq '.[]' )
echo $branchesToMergeMTX 

echo "::set-output name=BRANCHES_TO_MERGE_STR::[$branchesToMerge]"
echo "::set-output name=BRANCHES_TO_MERGE_MTX::$branchesToMergeMTX"