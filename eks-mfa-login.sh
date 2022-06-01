#!/bin/bash
set -e

if [ ! $# -eq 4 ]; then
  echo "Version: 0.0.1 -- See https://github.com/vilaca/eks-mfa-login for help."
  FILENAME=$(basename "$BASH_SOURCE")
  echo "Usage: ./$FILENAME arn cluster region mfa-token"
  exit 1
fi

ARN=$1
CLUSTER=$2
REGION=$3
MFA=$4

SESSION_TOKEN=$(aws sts get-session-token --serial-number "$ARN" --token-code "$MFA")
export AWS_ACCESS_KEY_ID=$(echo $SESSION_TOKEN | jq -r .Credentials.AccessKeyId)
export AWS_SESSION_TOKEN=$(echo $SESSION_TOKEN | jq -r .Credentials.SessionToken)
export AWS_SECRET_ACCESS_KEY=$(echo $SESSION_TOKEN | jq -r .Credentials.SecretAccessKey)

aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER"
