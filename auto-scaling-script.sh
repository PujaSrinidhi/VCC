
#!/bin/bash

# Ensure the gcloud CLI is authenticated
gcloud auth activate-service-account --key-file=/path/to/your-service-account-key.json

# Set project and region
gcloud config set project <PROJECT_ID>
gcloud config set compute/region <REGION>

# Create an auto-scaling policy based on CPU usage
gcloud compute instance-groups managed set-autoscaling <INSTANCE_GROUP_NAME>   --max-num-replicas 10   --min-num-replicas 1   --target-cpu-utilization 0.75   --cool-down-period 60

# Enable auto-scaling for the instance group
gcloud compute instance-groups managed apply-autoscaling-policy <INSTANCE_GROUP_NAME>
