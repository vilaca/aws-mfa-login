#!/bin/bash
set -e

usage() {
  echo "Version: 0.0.4 -- See https://github.com/vilaca/aws-mfa-login for help."
  FILENAME=$(basename "$BASH_SOURCE")
  echo "Usage: ./$FILENAME arn profile region [mfa-token]"
}

if [ $# -lt 3 ]; then    # Check if the number of arguments passed is less than 3. If so, print usage message and exit with status 1
  usage
  exit 1
fi

ARN=$1   # Assign the first argument to the ARN variable
PROFILE=$2   # Assign the second argument to the PROFILE variable
REGION=$3   # Assign the third argument to the REGION variable

# Check if the fourth argument (MFA token) is provided. If not, read it from user input
if [ $# -eq 3 ]; then
  read -p "Enter MFA token: " MFA
  if [ -z "$MFA" ]; then
    echo "MFA token cannot be empty. Exiting."
    usage
    exit 1
  fi
else
  MFA=$4
fi

# Call AWS STS to get temporary credentials using MFA and assign the result to the CREDS variable.
# Uses the ARN and MFA variables defined earlier
CREDS=$(aws sts get-session-token --serial-number "$ARN" --token-code "$MFA")

# Extract the Access Key ID, Secret Access Key, and Session Token from the JSON response of the AWS STS call
AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)

# Set the AWS credentials and session token using the 'aws configure' command and the PROFILE variable
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $PROFILE
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $PROFILE
aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $PROFILE

# Set the AWS profile using the PROFILE variable
export AWS_PROFILE=$PROFILE
