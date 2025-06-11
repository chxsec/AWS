#!/bin/bash

# Check if regions file was provided
if [ -z "$1" ]; then
    echo "Error: Missing first argument — path to aws.regions"
    echo "Usage: $0 <path-to-aws.regions> <aws-profile>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: Missing second argument — AWS profile"
    echo "Usage: $0 <path-to-aws.regions> <aws-profile>"
    exit 1
fi

REGIONS_FILE="$1"
PROFILE="$2"

# Verify that the file exists
if [ ! -f "$REGIONS_FILE" ]; then
    echo "Error: File '$REGIONS_FILE' not found."
    exit 1
fi

# Loop through each line (region)
while read -r REGION; do
    # Skip empty lines
    [ -z "$REGION" ] && continue

    echo "Enumerating Lambda functions in region: $REGION"
    aws lambda list-functions --region "$REGION" --profile "$PROFILE"
    echo "-----------------------------"
done < "$REGIONS_FILE"
