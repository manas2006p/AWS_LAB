# open command prompt and use command "terraform apply" for applying this code, "terraform destroy" for destroying the setup.
# Configure the AWS Provider

provider "aws" {
  access_key = "${local.access_key}"
  secret_key = "${local.secret_key}"
  region     = "us-west-2" #"us-east-1"
}

resource "aws_vpc" "Manas_result" {
  cidr_block       = "${local.cidr_block}"
  #instance_tenancy = "dedicated"

  tags {
    Name = "Manas_result_VPC_1"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id = "${aws_vpc.Manas_result.id}"
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-west-2a"
  tags {
    Name = "Manas_result_SB_1"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = "${aws_subnet.my_subnet.id}"
  private_ips = ["172.16.10.100"]
  tags {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
    ami = "ami-22b9a343" # us-west-2
    instance_type = "t2.micro"
    key_name = "Manas_instance"
    tags {
      Name = "Manas_result_EC2_1"
    }
    network_interface {
     network_interface_id = "${aws_network_interface.foo.id}"
     device_index = 0
     }
}
