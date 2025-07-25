# Credentials Encryption
Scripts to keep locally stored AWS credentials encrypted.
Credentials are **always encrypted** on disk.

## Requirements
 * openssl
 * awscli
 * jq

## Configuration
Check `~/.aws/credentials` file format:
```sh
[aws]
aws_access_key_id = ...
aws_secret_access_key = ...
```
> [!WARNING]
> The format must be exactly as shown above, with spaces preserved exactly as in the example.

Encrypt credentials:
```sh
openssl enc \
    -pbkdf2 -aes-256-cbc \
    -in ~/.aws/credentials \                   # usual plain text aws credentials file
    -out ~/.aws/credentials_base_encrypted
```

Add the custom function to your `~/.zshrc`:
```sh
function aws {
    echo "Running AWS custom function..."
    bash ~/Desktop/git/creds-encryption/aws_run_command.sh "$@"
}
```

In `aws_login.sh`, replace `YOUR_ACCOUNT_ARN` with your actual account ARN. For instance: `arn:aws:iam::101010101010:mfa/my-iam-user`.

## Usage
Retrieve an STS token:
```sh
./aws_login.sh
```

Run commands as usual:
```sh
aws s3 ls
```
You will be prompted to input your passphrase.
