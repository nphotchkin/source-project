#!/bin/bash

# Path to the file
file="./openapi.yaml"

# Read the current version from the file
current_version=$(grep 'version:' "$file" | awk '{print $2}')

# Increment the version number (patch version)
IFS='.' read -r major minor patch <<< "$current_version"
new_patch=$((patch + 1))
new_version="$major.$minor.$new_patch"

# Update the version in the file (macOS syntax)
sed -i '' "s|version: $current_version|version: $new_version|" "$file"

# Output the changes for verification
echo "Updated version from $current_version to $new_version in $file"

git add --all
git tag -a "$new_version" -m "Release version $new_version"
git commit -m "🔖 Bump version to $new_version"
git push