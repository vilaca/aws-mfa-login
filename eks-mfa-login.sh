#!/bin/bash
set -e

if [ ! $# -eq 4 ]; then
  echo "Version: 0.0.2 -- See https://github.com/vilaca/eks-mfa-login for help."
  FILENAME=$(basename "$BASH_SOURCE")
  echo "Usage: ./$FILENAME arn profile region mfa-token"
  exit 1
fi

ARN=$1
PROFILE=$2
REGION=$3
MFA=$4

CREDS=$(aws sts get-session-token --serial-number "$ARN" --token-code "$MFA")
AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $PROFILE
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $PROFILE
aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $PROFILE

export AWS_PROFILE=$PROFILE
