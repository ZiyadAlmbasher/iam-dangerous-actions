#!/bin/sh

# Author: David Kerber, with AI code enhancements for processing and error handling.
# Usage: sh all-actions-for-all-roles.sh 

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

# Create results directory
mkdir -p results || { echo "Failed to create results directory"; exit 1; }

# Get CPU core count for parallel processing
max_jobs=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Process files using xargs with the user-provided account number
find "iam-data/aws/aws/accounts/$account/iam/role/" -type f -name metadata.json -print0 | \
  xargs -0 -P "$max_jobs" -I {} sh -c '
    file="{}"
    arn=$(jq -r ".arn" "$file" 2>/dev/null)
    
    if [ -z "$arn" ]; then
        echo "Skipping $file: No valid ARN found" >&2
        exit 0
    fi

    filename=$(echo "$arn" | sed "s/[:/]/_/g")

    if ! iam-lens principal-can --principal "$arn" > "results/$filename.txt" 2>&1; then
        echo "Warning: Failed to process $arn (exit code $?)" >&2
        exit 1
    else
        echo "Processed $arn -> results/$filename.txt"
    fi
  '

# Check results
if [ "$(ls -A results)" ]; then
  echo " " 
  echo "All actions for roles have been processed. Check the results directory."
else
  echo "No results were generated. Please check if the metadata.json files contain valid ARNs." >&2
fi  

# End of script