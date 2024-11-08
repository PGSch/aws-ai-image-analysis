#!/bin/bash

# Label Detection:
# This feature identifies objects, people, text, scenes, and activities in images. For example, it can detect objects like cars, trees, and furniture, or activities like running and dancing. You can use the console, SDKs, or CLI commands to detect labels in an image. For instance, to detect images in a file cow.jpg stored in Amazon S3, you could use the following command:
aws rekognition detect-labels \
   --image '{"S3Object":{"Bucket":"your-unique-bucket-name","Name":"cow.jpg"}}' \
   --region us-east-1

# Face Detection and Analysis:
# Amazon Rekognition can detect faces in images and videos and analyze attributes such as age range, gender, emotions, and more. It can also compare faces to determine if they are the same person. Again, you can use any tool you like to interact with the DetectFaces API:
aws rekognition detect-faces \
    --image '{"S3Object":{"Bucket":"your-unique-bucket-name","Name":"example.jpg"}}' \
    --attributes "ALL" \
    --region us-east-1

# Face Comparison:
# This feature allows you to compare a face in an image with faces in another image or in a collection of faces. Here's a CLI command to achieve this:
aws rekognition compare-faces \
    --source-image '{"S3Object":{"Bucket":"your-unique-bucket-name","Name":"source.jpg"}}' \
    --target-image '{"S3Object":{"Bucket":"your-unique-bucket-name","Name":"target.jpg"}}' \
    --region us-east-1

# Celebrity Recognition:
# This feature identifies celebrities in images and videos. It can recognize thousands of famous personalities from various fields. Try it out by uploading a celebrity's image to an S3 bucket and running the following CLI command:
aws rekognition recognize-celebrities \
    --image '{"S3Object":{"Bucket":"your-unique-bucket-name","Name":"celebrity.jpg"}}' \
    --region us-east-1
