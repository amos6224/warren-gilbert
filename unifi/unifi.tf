data "aws_ami" "unifi" {
  most_recent = "true"
  name_regex = "^unifi"
  owners = ["self"]
}

resource "aws_vpc" "unify" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.unify.id}"
  cidr_block = "${var.subnet_cidr}"
}

resource "aws_security_group" "unify" {
  vpc_id = "${aws_vpc.unify.id}"
  description = "unify security group"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.home_ip}"]
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8443
    to_port   = 8443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8880
    to_port   = 8880
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 6789
    to_port   = 6789
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3478
    to_port     = 3478
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5656
    to_port   = 5669
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "unify" {
  ami = "${data.aws_ami.unifi.id}"
  security_groups = ["${aws_security_group.unify.id}"]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.public.id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.unify.id}"
  }

resource "aws_key_pair" "unify" {
  key_name = "Jeff"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdri+EtVNNCYf+EuTEajy1W5drWQREyMVeCBTOncrHjQR5UByEUwrtTQC5K678IwiNqXrf9VN2LMvsUFAFPwPPl0scIQ+93WKD3VBUdtmp7ov7406GXYnbHxhUTnHdOKKmizgUcRsDESf1htHkMY/t3BgzuVJZvypmQ2yHhyshiU6XPm1h75gdTLOGLeUwCWqn19ih2/C22edYzdgyiP0aIPRRQd2MvWIDFWfDm7XaL3Vc0/KmVeYNmHV8iVgbBZgacLbNy1zmd//e4jLw4FLztaYUcSmY4+XrUJ0VE9Zndkq2vCCGubnvtwrxkZb6XoeaUr06udb++JQ8+2A08ISR jeff.destine@NYCMBP4.local"
  }
