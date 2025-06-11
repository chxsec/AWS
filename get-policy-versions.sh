#!/bin/bash

# Colors
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for required profile argument
if [ -z "$1" ]; then
  echo "Usage: $0 <aws-profile>"
  exit 1
fi

PROFILE="--profile $1"
echo ""
echo "========== Attached Managed Policy Versions =========="

# Get all role names
role_names=$(aws iam list-roles $PROFILE --query "Roles[*].RoleName" --output text)

# Loop over each role
for role in $role_names; do
  attached_policies=$(aws iam list-attached-role-policies --role-name "$role" $PROFILE --query "AttachedPolicies[*].PolicyArn" --output text)

  for policy_arn in $attached_policies; do
    echo -e "\n--- Policy ARN: $policy_arn"

    # Get default version
    version_id=$(aws iam get-policy --policy-arn "$policy_arn" $PROFILE --query "Policy.DefaultVersionId" --output text)
    echo "Version: $version_id"

    # Get policy document as JSON and parse line by line
    echo "Policy Document:"
    aws iam get-policy-version \
      --policy-arn "$policy_arn" \
      --version-id "$version_id" \
      $PROFILE \
      --query "PolicyVersion.Document" \
      --output json | while IFS= read -r line; do
        if [[ "$line" == *"*"* ]]; then
          echo -e "${YELLOW}${line}${NC}"
        else
          echo "$line"
        fi
      done
  done
done
