#!/bin/bash

# Your OpenAI API Key
API_KEY="YOUR_API_KEY"

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure the latest data from the remote repository
git fetch origin

# Get the list of changed files on the current branch compared to the main branch
CHANGED_FILES=$(git diff --name-only origin/main..$CURRENT_BRANCH)

# Initialize an empty string to store diffs
ALL_DIFFS=""

# Get the diffs for each changed file and concatenate them
for FILE in $CHANGED_FILES; do
  if [[ -f $FILE ]]; then
    DIFF=$(git diff origin/main..$CURRENT_BRANCH -- "$FILE")
    ALL_DIFFS+="$DIFF\n\n"
  fi
done

# Optionally, truncate the diffs if they are too large
TRUNCATED_DIFFS=$(echo "$ALL_DIFFS" | head -c 20)



# Prepare JSON payload
PAYLOAD=$(jq -n \
  --arg model "gpt-4o-mini" \
  --arg prompt "Here are the changes made to the files in branch $CURRENT_BRANCH compared to origin/main:\n\n$TRUNCATED_DIFFS\n\nPlease provide a summary of these changes." \
  '{
    model: $model,
    messages: [
      { role: "system", content: "You are an assistant tasked with summarizing code changes." },
      { role: "user", content: $prompt }
    ]
  }')

# Save the payload to a temporary file
PAYLOAD_FILE=$(mktemp)
echo "$PAYLOAD" > "$PAYLOAD_FILE"

# Make a request to OpenAI's API to summarize the changes
RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  --data @"$PAYLOAD_FILE")

echo $RESPONSE

# Remove the temporary file
rm "$PAYLOAD_FILE"

# Extract and display the summary from the response
SUMMARY=$(echo $RESPONSE | jq -r '.choices[0].message.content')
echo ""
echo ""
echo ""
echo "Summary of file changes on $CURRENT_BRANCH:"
echo "$SUMMARY"
