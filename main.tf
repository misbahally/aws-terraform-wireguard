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

data "aws_ami" "rocky" {
    most_recent = true
    owners = ["679593333241"]

    filter {
        name = "name"
        values = "Rocky-9-EC2-9.0*.aarch64-*"
    }

    filter {
        name = "architecture"
        values = ["arm64"]
    }
}

resource "aws_instance" "wireguard_server" {
    ami = data.aws_ami.rocky
    instance_type = "t4g.nano"

    tags = {
        Name = "Wireguard VPN"
    }
}