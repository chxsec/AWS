#!/bin/bash

# Check for required profile argument
if [ -z "$1" ]; then
  echo "Usage: $0 <aws-profile>"
  exit 1
fi

PROFILE="--profile $1"

# Enumerate all roles and their permissions
for role in $(aws iam list-roles $PROFILE --query "Roles[*].RoleName" --output text); do
  echo "===== Role: $role ====="

  echo "-> Attached Managed Policies:"
  aws iam list-attached-role-policies --role-name "$role" $PROFILE --output table

  echo "-> Inline Policies:"
  inline_policies=$(aws iam list-role-policies --role-name "$role" $PROFILE --query "PolicyNames" --output text)
  for policy in $inline_policies; do
    echo "--> Inline Policy Document for: $policy"
    aws iam get-role-policy --role-name "$role" --policy-name "$policy" $PROFILE --query "PolicyDocument"
  done

  echo ""
done
