provider "aws" {}

resource "aws_vpc" "bs" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags {
    Name = "warren-gilber"
  }
}

resource "aws_subnet" "ps" {
  cidr_block = "${var.subnet_private}"
  vpc_id = "${aws_vpc.bs.id}"
  tags {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "fs" {
  cidr_block = "${var.subnet_public}"
  vpc_id = "${aws_vpc.bs.id}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "public-subnet"
  }
}

resource "aws_instance" "vs" {
  ami = "ami-cd0f5cb6"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.fs.id}"
  key_name = "${aws_key_pair.gs.id}"
}

resource "aws_security_group" "cs" {
  vpc_id = "${aws_vpc.bs.id}"
  name = "web-sec"
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = ["${var.home_ip}/32"]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "ss" {
  vpc_id = "${aws_vpc.bs.id}"
  tags {
    Name = "gilber-warren-route_table}"
  }
}

resource "aws_internet_gateway" "zs" {
  vpc_id = "${aws_vpc.bs.id}"
  tags {
    Name = "gilber-warren_internet_gateway"
}
}

resource "aws_route_table_association" "sn" {
  subnet_id = "${aws_subnet.fs.id}"
  route_table_id = "${aws_route_table.ss.id}"
}

resource "aws_eip" "lse" {
  vpc  = true
}

resource "aws_nat_gateway" "ns" {
  allocation_id = "${aws_eip.lse.id}"
  subnet_id = "${aws_subnet.ps.id}"
  depends_on = ["aws_internet_gateway.zs"]
}

resource "aws_key_pair" "gs" {
  key_name = "Jeff"
  public_key = "sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdri+EtVNNCYf+EuTEajy1W5drWQREyMVeCBTOncrHjQR5UByEUwrtTQC5K678IwiNqXrf9VN2LMvsUFAFPwPPl0scIQ+93WKD3VBUdtmp7ov7406GXYnbHxhUTnHdOKKmizgUcRsDESf1htHkMY/t3BgzuVJZvypmQ2yHhyshiU6XPm1h75gdTLOGLeUwCWqn19ih2/C22edYzdgyiP0aIPRRQd2MvWIDFWfDm7XaL3Vc0/KmVeYNmHV8iVgbBZgacLbNy1zmd//e4jLw4FLztaYUcSmY4+XrUJ0VE9Zndkq2vCCGubnvtwrxkZb6XoeaUr06udb++JQ8+2A08ISR jeff.destine@NYCMBP4.local"
}

output "ip" {
  value = "${aws_instance.vs.public_ip}"}
