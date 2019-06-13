provider "aws" {
  region     = "ca-central-1"
}

# module "iam" {
#   source = "git@github.com:brujack/aws_terraform_modules.git//iam"

# }

# this creates or references the workspace defined in terraform enterprise
# you need to define both the organization and the workspaces
terraform {
  backend "remote" {
    organization = "DoU-TFE"
    workspaces {
      name = "bruce-test"
    }
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

module "ubuntu_toolbox_ec2" {
  source = "git@github.com:brujack/aws_terraform_modules.git//ubuntu_toolbox_ec2"

  environment_name = "bruce"

  public_subnet_cidr_blocks = ["10.192.1.0/24"]
  private_subnet_cidr_blocks = ["10.192.3.0/24"]
  home_cidr_block = "192.16.1.0/24"
}
