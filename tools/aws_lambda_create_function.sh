#!/bin/bash

aws lambda create-function \
    --function-name my-function \
    --runtime nodejs14.x \
    --handler index.handler \
    --zip-file fileb://function.zip \
    --role arn:aws:iam::123456789012:role/lambda-execution-role

# You can use the console.log() or print statements in your function code to output log messages. For example:
exports.handler = async (event) => {
    console.log('Event received:', JSON.stringify(event));
    // Function logic goes here
};


# Leverage caching mechanisms, such as Amazon ElastiCache, to store and retrieve frequently accessed data
# With Amazon CloudWatch and AWS X-Ray, you can monitor function logs, set alarms, and gain insights into function execution.
# AWS Step Functions lets you define and orchestrate workflows that involve multiple Lambda functions. You can create complex, multi-step workflows that include branching, parallel execution, and error handling. Step Functions provide a visual interface to design and monitor workflows, making it easier to build and manage serverless applications.

