# EKS MFA Login

Login to AWS EKS using MFA.

## Usage

    ./eks-mfa-login.sh arn profile region mfa

## Example

    ./eks-mfa-login.sh arn:aws:iam::12345678901:mfa/username mfa eu-west-1 123456

## Requirements

Only *[jq](https://github.com/stedolan/jq)* and *[aws cli](https://aws.amazon.com/en/cli/)* are required to be installed.

