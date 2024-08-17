#!/bin/bash

# Define color codes
COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"
COLOR_CYAN="\033[0;36m"


# <-- PROMPT FOR INPUT -->

# Print the ASCII boat in rainbow colors
echo -e "${COLOR_RED}  _________.__    .__        ${COLOR_RESET}"
echo -e "${COLOR_ORANGE}/   _____/|  |__ |__|_____  ${COLOR_RESET}"
echo -e "${COLOR_YELLOW}\_____  \ |  |  \|  \____ \ ${COLOR_RESET}"
echo -e "${COLOR_GREEN}/        \|   Y  \  |  |_> > ${COLOR_RESET}"
echo -e "${COLOR_CYAN}/_______  /|___|  /__|   __/ ${COLOR_RESET}"
echo -e "${COLOR_BLUE}        \/      \/   |__|    ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}                             ${COLOR_RESET}"

# Print a colored prompt and read user input
read -p "$(echo -e "${COLOR_CYAN}Enter a summary of the changes make? ${COLOR_RESET}")" SUMMARY

# Print a personalized message
echo -e "${COLOR_GREEN}The following changes have been made: \n\n ${SUMMARY}!${COLOR_RESET}"

# <-- PROMPT FOR INPUT -->

# Get the latest tag
file="./openapi.yaml"

# Read the current version from the file
NEXT_VERSION=$(grep 'version:' "$file" | awk '{print $2}')

# Set variables
TARGET_REPO="git@github.com:nphotchkin/target-project.git"  # Replace with your target repository
TARGET_BRANCH="main"  # Replace with the default branch name of your target repository
GITHUB_USERNAME=$(gh api user | jq -r '.login')

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure the latest data from the remote repository
git fetch origin
# Get the commit summary of commits on the current branch that are not in other branches
# This includes commits that are unique to your current branch
COMMIT_SUMMARY=$(git log --oneline --no-merges --cherry-pick origin/main..$CURRENT_BRANCH)


#### PUSH TO TARGET
# Clone the target repository
git clone "$TARGET_REPO"
cd target-project || { echo "Failed to navigate to repository"; exit 1; }

# Create a new branch with the version number
git checkout -b "feature/client-$NEXT_VERSION"

# Create the target directory if it doesn't exist
mkdir -p ./target

# Copy files from the build directory to the target directory
cp -r ../build/* ./target/

# Stage and commit the changes
git add ./target
git commit -m "🤖 Add files for version $NEXT_VERSION"

# Push the new branch to the remote repository
git push origin "feature/client-$NEXT_VERSION"

# Create a detailed pull request description
PR_BODY=$(cat <<EOF
## Release $NEXT_VERSION

$GITHUB_USERNAME has created a new release version $NEXT_VERSION.  

### Developer Description Of Changes:
$SUMMARY

### Summary of commits from source repository:
$COMMIT_SUMMARY
EOF
)

# Create a pull request using the GitHub CLI (gh)
gh pr create --base "$TARGET_BRANCH" --head "feature/client-$NEXT_VERSION" --title "🎉 Release $NEXT_VERSION 🚀" --body "$PR_BODY"

# Clean up by going back to the previous directory and removing the cloned repo
cd ..
rm -rf target-project

echo "Pull request created for version $VERSION."


open "https://github.com/nphotchkin/source-project"
open "https://github.com/nphotchkin/target-project/pulls"

