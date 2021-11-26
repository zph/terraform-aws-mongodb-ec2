provider "aws" {
  region  = var.region
  #profile = "terraform-provisioner-ansible"
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}


data "aws_vpc" "default" {
  default = true
}

# TODO: make sure we create all subnets not just this one
data "aws_subnet" "subnet" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = var.replicasets[0].data_volumes[0].availability_zone
}

module "mongodb_rs0" {
  replicaset_name = var.replicasets[0].name
  data_volumes    = var.replicasets[0].data_volumes
  count           = var.replicasets[0].count
  replica_count   = var.replicasets[0].count
  tags = {
    Name        = "mongodb-${var.replicasets[1].name}-${count.index}"
    Environment = "terraform-mongo-testing"
  }

  source          = "../../"
  vpc_id          = data.aws_vpc.default.id
  subnet_id       = data.aws_subnet.subnet.id
  ssh_user        = "ubuntu"
  instance_type   = "t2.micro"
  ami_filter_name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ami_owners      = ["099720109477"] # Official Ubuntu
  mongodb_version = "3.6"
  private_key     = file("~/.ssh/id_ed25519")
  public_key      = file("~/.ssh/id_ed25519.pub")
  keypair_name    = var.keypair_name
}

module "mongodb_rs1" {
  replicaset_name = var.replicasets[1].name
  data_volumes    = var.replicasets[1].data_volumes
  count           = var.replicasets[1].count
  replica_count   = var.replicasets[1].count
  tags = {
    Name        = "mongodb-${var.replicasets[1].name}-${count.index}"
    Environment = "terraform-mongo-testing"
  }

  source          = "../../"
  vpc_id          = data.aws_vpc.default.id
  subnet_id       = data.aws_subnet.subnet.id
  ssh_user        = "ubuntu"
  instance_type   = "t2.micro"
  ami_filter_name = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  ami_owners      = ["099720109477"] # Official Ubuntu
  mongodb_version = "3.6"
  private_key     = file("~/.ssh/id_ed25519")
  public_key      = file("~/.ssh/id_ed25519.pub")
  keypair_name    = var.keypair_name
}

variable "replicasets" {
  type = list(object({
    name     = string
    count    = number
    data_volumes = list(object({
      ebs_volume_id     = string
      availability_zone = string
    }))
  }))
  description = "List of replicasets"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "keypair_name" {
  type        = string
  description = "Keypair name"
  default     = "mongo-publicKey"
}

output "mongo_server_ip_address_rs1" {
  value = module.mongodb_rs1
}

output "mongo_server_ip_address_rs0" {
  value = module.mongodb_rs0
}

# output "subnets" {
#   value = [var.replicasets.[*].data_volumes.[*].availability_zone]
# }
