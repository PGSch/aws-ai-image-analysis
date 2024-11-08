import os
from dotenv import load_dotenv
import boto3
import json

# Load environment variables from .env file
load_dotenv()

# Retrieve environment variables
bucket_name = os.getenv("S3_BUCKET_NAME")
image_path = os.getenv("IMAGE_PATH")
object_name = os.getenv("S3_OBJECT_NAME")

# Ensure all required environment variables are present
if not bucket_name or not image_path or not object_name:
    raise ValueError("Environment variables S3_BUCKET_NAME, IMAGE_PATH, and S3_OBJECT_NAME must be set")

# AWS client setup
s3_client = boto3.client("s3")
rekognition_client = boto3.client("rekognition")

# Upload image to S3
try:
    with open(image_path, "rb") as image_file:
        s3_client.upload_fileobj(image_file, bucket_name, object_name)
    print(f"Image uploaded successfully to {bucket_name}/{object_name}")
except Exception as e:
    print(f"Failed to upload image: {e}")

# Use Rekognition to detect labels
try:
    response = rekognition_client.detect_labels(
        Image={"S3Object": {"Bucket": bucket_name, "Name": object_name}},
        MaxLabels=10
    )

    # Convert response to JSON format and print it
    response_json = json.dumps(response, indent=4)
    print("Detected labels in JSON format:")
    print(response_json)

except Exception as e:
    print(f"Failed to detect labels: {e}")
