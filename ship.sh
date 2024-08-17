#!/bin/bash

# Check if version number is passed as an argument
if [ -z "$1" ]; then
  echo "Error: No version number supplied."
  echo "Usage: ./create_pr.sh <version_number>"
  exit 1
fi

# Set variables
VERSION=$1
TARGET_REPO="git@github.com:nphotchkin/target-project.git"  # Replace with your target repository
TARGET_BRANCH="main"  # Replace with the default branch name of your target repository


# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get the summary of the latest 5 commits pushed to the current branch
# You can adjust the -n value to include more or fewer commits
COMMIT_SUMMARY=$(git log origin/$CURRENT_BRANCH --oneline -n 5)

# Print the commit summary
echo "Summary of the last 5 commits pushed to $CURRENT_BRANCH:"
echo "$COMMIT_SUMMARY"

# Clone the target repository
git clone "$TARGET_REPO"
cd target-project || { echo "Failed to navigate to repository"; exit 1; }

# Create a new branch with the version number
git checkout -b "$VERSION"

# Create the target directory if it doesn't exist
mkdir -p ./target

# Copy files from the build directory to the target directory
cp -r ../build/* ./target/

# Stage and commit the changes
git add ./target
git commit -m "Add files for version $VERSION"

# Push the new branch to the remote repository
git push origin "$VERSION"

# Create a detailed pull request description
PR_BODY=$(cat <<EOF
## Release $VERSION

This pull request includes the files for version $VERSION.

### Summary of commits from source repository:
$COMMIT_SUMMARY
EOF
)

# Create a pull request using the GitHub CLI (gh)
gh pr create --base "$TARGET_BRANCH" --head "$VERSION" --title "Release $VERSION" --body "$PR_BODY"

# Clean up by going back to the previous directory and removing the cloned repo
cd ..
rm -rf target-project

echo "Pull request created for version $VERSION."
