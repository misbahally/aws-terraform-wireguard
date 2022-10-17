terraform {
   required_providers {
     aws = {
         source = "hashicorp/aws"
         version = "~> 4.16"
     }
   }

   required_version = ">= 1.2.0"
}

provider "aws" {
    region = "eu-west-1"

}
variable "instance_type" {
   type    = string
   default = "t4g.nano"
}

variable "instance_name" {
   type    = string
   default = "Wireguard-VPN"
}

data "aws_ami_ids" "rocky" {
    owners = ["679593333241"]

    filter {
        name = "name"
        values = ["Rocky-9-EC2-9.0*.aarch64-*"]
    }

    filter {
        name = "architecture"
        values = ["arm64"]
    }
}

resource "aws_instance" "wireguard_server" {
    ami = data.aws_ami_ids.rocky.ids[0]
    instance_type = var.instance_type

    tags = {
        Name = var.instance_name
    }
}