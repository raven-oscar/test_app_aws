resource "aws_vpc" "test_task" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "app_subnet_c1a" {
  availability_zone = "eu-central-1a"
  vpc_id            = "${aws_vpc.test_task.id}"
  cidr_block        = "172.16.16.0/24" 
}
resource "aws_subnet" "app_subnet_c1b" {
  availability_zone = "eu-central-1b"
  vpc_id            = "${aws_vpc.test_task.id}"
  cidr_block        = "172.16.17.0/24" 
}
resource "aws_subnet" "app_subnet_c1c" {
  availability_zone = "eu-central-1c"
  vpc_id            = "${aws_vpc.test_task.id}"
  cidr_block        = "172.16.18.0/24" 
}

resource "aws_internet_gateway" "test_app" {
  vpc_id = aws_vpc.test_task.id
}

resource "aws_default_security_group" "security_group_default" {
  vpc_id = "${aws_vpc.test_task.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}