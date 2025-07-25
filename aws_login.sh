#!/bin/bash

echo "MFA:"
read MFA
echo "Passphrase:"
read -s PASSPHRASE

BASE_CREDENTIALS=( $( openssl enc -pbkdf2 -aes-256-cbc -d -in ~/.aws/credentials_base_encrypted -pass pass:$PASSPHRASE) )

STS_CREDENTIALS_JSON=$(AWS_ACCESS_KEY_ID=${BASE_CREDENTIALS[3]} AWS_SECRET_ACCESS_KEY=${BASE_CREDENTIALS[6]} AWS_DEFAULT_REGION=eu-west-3 aws sts get-session-token --serial-number YOUR_ACCOUNT_ARN --token-code $MFA)

AWS_ACCESS_KEY_ID=$(jq -r --argjson stsCredentialsJson "$STS_CREDENTIALS_JSON" -n '$stsCredentialsJson.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(jq -r --argjson stsCredentialsJson "$STS_CREDENTIALS_JSON" -n '$stsCredentialsJson.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(jq -r --argjson stsCredentialsJson "$STS_CREDENTIALS_JSON" -n '$stsCredentialsJson.Credentials.SessionToken')

# "printf" handles "\n" better than "echo"
printf "aws_access_key_id=$AWS_ACCESS_KEY_ID\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY\naws_session_token=$AWS_SESSION_TOKEN" | openssl enc -pbkdf2 -aes-256-cbc -out ~/.aws/credentials_sts_encrypted -pass pass:$PASSPHRASE

echo "Done!"
