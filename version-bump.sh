# Path to the file
file="./openapi.yaml"

# Read the current version from the file
current_version=$(grep 'version:' "$file" | awk '{print $2}')

# Increment the version number (patch version)
IFS='.' read -r major minor patch <<< "$current_version"
new_patch=$((patch + 1))
new_version="$major.$minor.$new_patch"

# Update the version in the file
sed -i "s/version: $current_version/version: $new_version/" "$file"

# Output the new version
echo "Updated version to $new_version"