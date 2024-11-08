#!/bin/bash

# Unset relevant AWS environment variables to avoid conflicts
echo "Unsetting AWS environment variables..."
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_DEFAULT_PROFILE

# Load environment variables from .env file
echo "Loading environment variables from .env file..."

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo ".env file loaded successfully."
else
  echo "Error: .env file not found. Please create one with AWS_PROFILE, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, and AWS_OUTPUT."
  exit 1
fi

# Ensure S3 bucket name and image file are provided
BUCKET_NAME=$1
IMAGE_PATH=$2
REGION="us-east-1"

echo "AWS_ env variables after load:"
echo "AWS_PROFILE is set to: $AWS_PROFILE"
echo "AWS_ACCESS_KEY_ID is set to: $AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY is set to: $AWS_SECRET_ACCESS_KEY"
echo "BUCKET_NAME  is set to: $BUCKET_NAME"
echo "IMAGE_PATH is set to: $IMAGE_PATH"
echo "REGION is set to: $REGION"

# Ensure AWS_PROFILE is set
if [[ -z "$AWS_PROFILE" ]]; then
    echo "Error: AWS_PROFILE is not set. Please make sure it's set in the .env file or in the environment."
    exit 1
fi

if [[ -z "$BUCKET_NAME" || -z "$IMAGE_PATH" ]]; then
    echo "Usage: $0 <bucket-name> <path-to-image-file>"
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it to proceed."
    exit 1
fi

echo "AWS_ env variables before s3 create-bucket:"
echo "AWS_PROFILE is set to: $AWS_PROFILE"
echo "AWS_ACCESS_KEY_ID is set to: $AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY is set to: $AWS_SECRET_ACCESS_KEY"

# Create the S3 bucket, handling region constraint
echo "Creating S3 bucket: $BUCKET_NAME in region: $REGION"
echo "REGION is set to: $REGION"

# Upload the image to the S3 bucket with specified content type
IMAGE_NAME=$(basename "$IMAGE_PATH")
echo "Uploading $IMAGE_NAME to bucket: $BUCKET_NAME with Content-Type set to image/jpeg"
aws s3api put-object \
    --bucket "$BUCKET_NAME" \
    --key "$IMAGE_NAME" \
    --body "$IMAGE_PATH" \
    --content-type "image/jpeg" \
    --profile "$AWS_PROFILE"

if [ $? -ne 0 ]; then
    echo "Error: Failed to upload image to S3 bucket."
    exit 1
fi

# Output the public URL
echo "Public URL for the uploaded image:"
echo "https://$BUCKET_NAME.s3.amazonaws.com/$IMAGE_NAME"

echo "S3 bucket setup complete."
