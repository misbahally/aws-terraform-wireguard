packer {
    required_plugins {
        amazon = {
            version = " >= 1.1.1"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "wireguard-ami" {
    ami_name = "wireguard-ami"
    instance_type = "t4g.nano"
    region = "eu-west-1"
    source_ami_filter {
        filters = {
            name = "Rocky Linux 9 (Official) - aarch64"
            architecture = "arm64"
        }
        most_recent = true
        owners = ["679593333241"]
    }
    ssh_username = "rocky"
}

build {
    name = "test"
    sources = [
        "source.amazon-ebs.wireguard-ami"
    ]
}