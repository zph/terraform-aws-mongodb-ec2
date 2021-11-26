provider "aws" {
# TODO: make this interpolated
  region = "us-west-2"
}

resource "aws_ebs_volume" "mongo-data-vol" {
  count             = var.volume_count
  availability_zone = var.availability_zone
  type              = "gp2"
  size              = var.volume_size

  tags = {
    Name        = "mongo-data-ebs-volume"
    Environment = var.environment_tag
  }
}

variable "volume_count" {
  type        = number
  description = "Number of volumes to create"
  default     = 6
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
# TODO: make this interpolated
  default     = "us-west-2a"
}

variable "volume_size" {
  type        = string
  description = "Size of the DB storage volume."
  default     = "10"
}

variable "environment_tag" {
  type        = string
  description = "Environment tag"
  default     = "Production"
}

output "ebs-vol-id" {
  value = aws_ebs_volume.mongo-data-vol.*.id
}

output "availability_zone" {
  value = {
    availability_zone = aws_ebs_volume.mongo-data-vol.*.availability_zone
    ebs_volume_id = aws_ebs_volume.mongo-data-vol.*.id
  }
}
