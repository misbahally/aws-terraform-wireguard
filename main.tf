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
   default = "Wireguard VPN"
}
variable "ingress_rules" {
  type    = list(number)
  default = [22]
}
variable "ingress_rules_udp" {
  type    = list(number)
  default = [19872]
}
variable "egress_rules" {
   type    = list(number)
   default = []
}
variable "egress_rules_udp" {
   type    = list(number)
   default = []
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


resource "aws_security_group" "wireguard_security_group" {
   name        = join("",[var.instance_name, " Security Group"])
   description = join("",["Allow traffic to access instance ", var.instance_name, " instance"])
   dynamic "ingress" {
      iterator = port
      for_each = var.ingress_rules
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
     }
   }
   dynamic "ingress" {
      iterator = port
      for_each = var.ingress_rules_udp
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "UDP"
        cidr_blocks = ["0.0.0.0/0"]
     }
   }
   dynamic "egress" {
      iterator = port
      for_each = var.egress_rules
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
     }
  }
   dynamic "egress" {
      iterator = port
      for_each = var.egress_rules_udp
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "UDP"
        cidr_blocks = ["0.0.0.0/0"]
     }
  }
}

resource "aws_instance" "wireguard_server" {
    ami = data.aws_ami_ids.rocky.ids[0]
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.wireguard_security_group.id]
    key_name = "misbah@mlo"
    tags = {
        Name = var.instance_name
    }
}