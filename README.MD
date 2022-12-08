## AWS Nginx ECS Cluster

## Prerequisite
- Terraform with version >= 0.12
- AWS account

## How to provision the cluster
- Create a `aws_keys.tfvars` file that will contains `aws_access_key` and `aws_secret_key`. You can follow `aws_keys.tfvars.example` file that I've provided
- Run `terraform apply -var-file="aws_keys.tfvars"`
- Run `terraform output` to get that load balancer host name that you can use to check if nginx ECS Cluster has been provisioned successfully

## Current Architecture
<img width="519" alt="Screen Shot 2022-12-08 at 13 20 21" src="https://user-images.githubusercontent.com/21070615/206376043-8802af13-2d00-4de2-a6bd-63185da4ff5d.png">

## Question?
You can email me at kadeksuryam@gmail.com
