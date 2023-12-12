# VPC - Data Center 
resource "aws_vpc" "tf-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc"
  }
}
#VPC subnet
 resource "aws_subnet" "tf-subnet" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"
availability_zone = "us-east-1c"
map_public_ip_on_launch = "true"
  tags = {
    Name = "tf-subnet"
  }
}


# Internet gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-gateway"
  }
}
# route table
resource "aws_route_table" "tf-rtb" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    Name = "tf-route-table"
  }
}

# route table - subnet association
resource "aws_route_table_association" "tf-rt-sn" {
  subnet_id      = aws_subnet.tf-subnet.id
  route_table_id = aws_route_table.tf-rtb.id
}

# security group
resource "aws_security_group" "tf-sg" {
  name        = "allow_tf"
  description = "Allow SSH - HTTP inbound traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-sg"
  }
}

#AWS Instance
resource "aws_instance" "tf-ec2" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.medium"
  key_name= "key1"
  subnet_id=aws_subnet.tf-subnet.id
  vpc_security_group_ids = [aws_security_group.tf-sg.id]
  user_data = file("ecomm.sh")
  tags = {
    Name = "ecomm-server"
  }
}
