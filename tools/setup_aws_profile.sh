#!/bin/bash

# Load environment variables from .env file
echo "Loading environment variables from .env file..."

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo ".env file loaded successfully."
else
  echo "Error: .env file not found. Please create one with AWS_PROFILE, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, and AWS_OUTPUT."
  exit 1
fi

# Check if required variables are set
missing_vars=()

if [[ -z "$AWS_PROFILE" ]]; then
  missing_vars+=("AWS_PROFILE")
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
  missing_vars+=("AWS_ACCESS_KEY_ID")
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  missing_vars+=("AWS_SECRET_ACCESS_KEY")
fi

if [[ -z "$AWS_REGION" ]]; then
  missing_vars+=("AWS_REGION")
fi

if [[ -z "$AWS_OUTPUT" ]]; then
  missing_vars+=("AWS_OUTPUT")
fi

if [ ${#missing_vars[@]} -ne 0 ]; then
  echo "Error: Missing required environment variables: ${missing_vars[*]}"
  exit 1
fi

echo "All required environment variables are set."

# Configure AWS profile using AWS CLI
echo "Configuring AWS profile '$AWS_PROFILE'..."

# Set Access Key
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$AWS_PROFILE"
if [ $? -ne 0 ]; then
  echo "Error: Failed to set aws_access_key_id for profile $AWS_PROFILE."
  exit 1
else
  echo "aws_access_key_id set successfully."
fi

# Set Secret Access Key
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$AWS_PROFILE"
if [ $? -ne 0 ]; then
  echo "Error: Failed to set aws_secret_access_key for profile $AWS_PROFILE."
  exit 1
else
  echo "aws_secret_access_key set successfully."
fi

# Set Region
aws configure set region "$AWS_REGION" --profile "$AWS_PROFILE"
if [ $? -ne 0 ]; then
  echo "Error: Failed to set region for profile $AWS_PROFILE."
  exit 1
else
  echo "Region set to $AWS_REGION successfully."
fi

# Set Output Format
aws configure set output "$AWS_OUTPUT" --profile "$AWS_PROFILE"
if [ $? -ne 0 ]; then
  echo "Error: Failed to set output format for profile $AWS_PROFILE."
  exit 1
else
  echo "Output format set to $AWS_OUTPUT successfully."
fi

echo "AWS CLI profile '$AWS_PROFILE' configured successfully."

# Test the profile with a simple AWS command
echo "Testing AWS CLI configuration with profile '$AWS_PROFILE'..."

aws sts get-caller-identity --profile "$AWS_PROFILE" --output "$AWS_OUTPUT"
if [ $? -ne 0 ]; then
  echo "Error: Failed to authenticate with AWS using profile '$AWS_PROFILE'. Please check your credentials."
  exit 1
else
  echo "AWS profile '$AWS_PROFILE' is set up and working correctly."
fi

