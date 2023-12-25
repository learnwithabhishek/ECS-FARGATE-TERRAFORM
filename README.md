# node-todo-app creation & deployment on ecs fargate cluster using terraform

# Steps:
Create a ecr repository "todo-app"

Build docker image and tag with ecr repo name
docker build -t <AWS_Account_Id>.dkr.ecr.us-east-1.amazonaws.com/todo-app:latest .

Authenticate your docker client to ecr registory:
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_Account_Id>.dkr.ecr.us-east-1.amazonaws.com

Run the following command to push this image to your newly created AWS repository:
docker push <AWS_Account_Id>.dkr.ecr.us-east-1.amazonaws.com/todo-app:latest

Move to infrastructure directory, it contains terraform files.

Create a S3 bucket in your aws account and save it's name in infrastructure-prod.config file.

Now run terraform commands to create the infra:

terraform init -backend-config="infrastructure-prod.config"

terraform plan -var-file="production.tfvars"

terraform apply -var-file="production.tfvars" -auto-approve