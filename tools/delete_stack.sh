#!/bin/bash

# Delete the stack
aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION --profile $AWS_PROFILE

# Wait for the stack deletion to complete
echo "Waiting for stack deletion to complete..."
aws cloudformation wait delete-stack --stack-name $STACK_NAME --region $REGION --profile $AWS_PROFILE

echo "Stack deletion complete. Proceeding with deployment..."

