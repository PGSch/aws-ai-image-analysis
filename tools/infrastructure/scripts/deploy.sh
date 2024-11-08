#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Load environment variables from .env file if it exists
ENV_FILE="$SCRIPT_DIR/../../.env"
echo "Looking for .env file at: $ENV_FILE"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    echo ".env file loaded successfully."
else
    echo "Warning: .env file not found. Ensure AWS_PROFILE is set in the environment."
fi

# Define stack name, region, and template path
STACK_NAME="vegetable-image-analysis-stack"
REGION="us-east-1"
TEMPLATE_FILE="$SCRIPT_DIR/../templates/template.yaml"  # Pointing to the single consolidated template file

# Ensure AWS_PROFILE is set
if [[ -z "$AWS_PROFILE" ]]; then
    echo "Error: AWS_PROFILE is not set. Please make sure it's set in the environment."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it to proceed."
    exit 1
fi

# Start deployment process
echo "Starting deployment of CloudFormation stack: $STACK_NAME in region: $REGION using profile: $AWS_PROFILE"
echo "Using template file: $TEMPLATE_FILE"

# Deploy CloudFormation stack with verbose output
aws cloudformation deploy \
  --template-file "$TEMPLATE_FILE" \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --profile "$AWS_PROFILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --output text \
  --debug

# Capture the exit status of the deploy command
EXIT_STATUS=$?

# Check if deployment was successful
if [ $EXIT_STATUS -ne 0 ]; then
    echo "Error: CloudFormation deployment failed with status $EXIT_STATUS. Check above logs for more details."
    exit $EXIT_STATUS
else
    echo "Deployment complete. Stack name: $STACK_NAME in region: $REGION"
    echo "You can check the stack status in the AWS Management Console or use the AWS CLI to describe the stack."
fi

