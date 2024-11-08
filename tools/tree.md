.
├── course-info.yaml
├── course-remote-info.yaml
├── requirements.txt
├── task
│   ├── application
│   │   ├── app.py
│   │   ├── lambda_function.py
│   │   └── updated_lambda_function.py
│   ├── main.py
│   ├── test
│   │   ├── __init__.py
│   │   └── tests.py
│   └── tests.py
├── infrastructure
│   ├── templates
│   │   └── main.yaml                    # CloudFormation template for IAM setup
│   └── scripts
│       └── deploy.sh                    # Script to deploy CloudFormation stack
├── config
│   └── aws_credentials.txt              # Placeholder for any AWS CLI credentials info if needed
├── README.md
└── .gitignore

