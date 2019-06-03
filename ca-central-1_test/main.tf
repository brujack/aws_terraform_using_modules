provider "aws" {
  region     = "ca-central-1"
}

# module "iam" {
#   source = "git@github.com:brujack/aws_terraform_modules.git//iam"

# }

module "remote_state" {
  source = "git@github.com:brujack/aws_terraform_modules.git//remote_state"

  remote_state_full_access_users = ["bruce"]
  remote_state_read_users = ["bruce-read"]
}

# Create the terraform.tfstate file in a unique path based of of the environment_name
# This needs to be done in each environment.  The s3 bucket is setup in the infrastructure "environment" beforehand
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "conecrazy-test-terraform-remote-state-storage-s3"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "ca-central-1"
    key            = "conecrazy-test-terraform-remote-state-storage-s3/bruce/terraform.tfstate"
  }
}

module "vpc" {
  source = "git@github.com:brujack/aws_terraform_modules.git//vpc"

  environment_name = "bruce"
  vpc_cidr = "10.192.0.0/20"
  public_subnet_cidr_blocks = ["10.192.1.0/24"]
  public_subnet_avail_zones = ["ca-central-1a"]
  public_subnet_names = ["bruce-0_pub-1a"]
  private_subnet_cidr_blocks = ["10.192.3.0/24"]
  private_subnet_avail_zones = ["ca-central-1a"]
  private_subnet_names = ["bruce-0_prv-1a"]

  vpn_gateway_endpoint = "conecrazy"
  home_cidr_block = "192.16.1.0/24"

  route53_private_zone_name = "conecrazy.aws"
}
