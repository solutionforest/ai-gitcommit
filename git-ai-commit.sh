#!/bin/bash

diff=$(git diff --cached | cat)
if [ -z "$diff" ]; then
 echo "No staged changes to commit."
 exit 1
fi

escaped_diff=$(echo "$diff" | jq -Rsa .)

data=$(jq -n --arg diff "$escaped_diff" '{
 "model": "gitdiff",
 "stream": false,
 "prompt": ("" + $diff)
}')

response=$(curl -s -X POST http://localhost:11434/api/generate -d "$data" -H "Content-Type: application/json")

commit_message=$(echo "$response" | jq -r '.response')

echo "$commit_message" > .git/COMMIT_EDITMSG

git commit -eF .git/COMMIT_EDITMSG
