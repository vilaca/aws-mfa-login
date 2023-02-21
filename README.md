# AWS MFA Login

Login to AWS using MFA.

## Usage

    ./aws-mfa-login.sh arn profile region

## Example

    ./aws-mfa-login.sh arn:aws:iam::12345678901:mfa/username mfa eu-west-1

## Requirements

Only *[jq](https://github.com/stedolan/jq)* and *[aws cli](https://aws.amazon.com/en/cli/)* are required to be installed.

