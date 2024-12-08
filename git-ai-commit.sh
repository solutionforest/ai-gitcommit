#!/bin/bash

# Check if files are passed as arguments or if the user wants to add all changes
if [ "$#" -eq 0 ]; then
  echo "No files specified. Staging all changes..."
  git add .
else
  echo "Staging specified files..."
  git add "$@"
fi

# Check if there are any staged changes
diff=$(git diff --cached | cat)
if [ -z "$diff" ]; then
  echo "No staged changes to commit."
  exit 1
fi

# Escape the diff for JSON compatibility
escaped_diff=$(echo "$diff" | jq -Rsa .)

# Prepare the payload for Ollama
data=$(jq -n --arg diff "$escaped_diff" '{
  "model": "gitdiff",
  "stream": false,
  "prompt": ("" + $diff)
}')

# Call the Ollama API to generate the commit message
response=$(curl -s -X POST http://localhost:11434/api/generate -d "$data" -H "Content-Type: application/json")

# Extract the commit message from the API response
commit_message=$(echo "$response" | jq -r '.response')

# Check if a commit message was generated
if [ -z "$commit_message" ]; then
  echo "Error: Failed to generate a commit message."
  exit 1
fi

# Display the generated commit message in the console
echo "AI-Generated Commit Message:"
echo "--------------------------------------"
echo "$commit_message"
echo "--------------------------------------"

# Confirm with the user before committing
read -p "Do you want to use this commit message? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Commit aborted."
  exit 1
fi

# Use the generated commit message directly in the commit
git commit -m "$commit_message"

echo "Commit created successfully with AI-generated message!"