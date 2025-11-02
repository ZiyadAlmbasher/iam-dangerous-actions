#!/bin/bash

# Author: David Kerber, with some AI code changes.
# Usage: sh all-actions-for-all-roles-mac.sh 


# Prompt for AWS Account Number
read -p "Enter the AWS Account Number: " account

# Validate input (must be exactly 12 digits)
if ! echo "$account" | grep -Eq '^[0-9]{12}$'; then
    echo "Error: Invalid AWS Account Number. Must be exactly 12 digits." >&2
    exit 1
fi

# Check if iam-lens is installed
if ! iam-lens --version > /dev/null 2>&1; then
    if ! version_output=$(iam-lens --version 2>&1); then
        echo "Error: iam-lens is not installed." >&2
        echo "To install iam-lens, please run: sudo npm install -g @cloud-copilot/iam-lens" >&2
        exit 1
    fi
fi

# Create the results directory if it doesn't exist
mkdir -p results

# Find all metadata.json files and loop over them
find iam-data/aws/aws/accounts/"$account"/iam/role/ -type f -name metadata.json | while read -r file; do
  # Extract the ARN using jq
  arn=$(jq -r '.arn' "$file")

  # Skip if ARN is empty
  if [ -z "$arn" ]; then
    echo "No ARN found in $file"
    continue
  fi

  # Generate a safe filename from the ARN (replace colons and slashes)
  filename=$(echo "$arn" | sed 's/[^a-zA-Z0-9]/_/g')

  # Call iam-lens and save the output
  iam-lens principal-can --principal "$arn" > "results/$filename.txt"

  echo "Processed $arn -> results/$filename.txt"
done