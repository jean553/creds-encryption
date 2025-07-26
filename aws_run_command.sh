#!/bin/bash

# we voluntarily prints to stderr instead of stdout,
# because if the aws custom function is piped (ex: aws s3 ls | wc -l),
# then the output of "aws" custom function would be connected
# to the input of "wc", so the message would not be displayed;
echo "Passphrase:" >&2
read -s PASSPHRASE

STS_CREDENTIALS=( $(openssl enc -pbkdf2 -aes-256-cbc -d -in ~/.aws/credentials_sts_encrypted -pass pass:$PASSPHRASE) )

AWS_ACCESS_KEY_ID=$(echo ${STS_CREDENTIALS[0]} | sed 's/.*=//g')
AWS_SECRET_ACCESS_KEY=$(echo ${STS_CREDENTIALS[1]} | sed 's/.*=//g')
AWS_SESSION_TOKEN=$(echo ${STS_CREDENTIALS[2]} | sed 's/.*=//g')

AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN AWS_DEFAULT_REGION=eu-west-3 aws "$@"
