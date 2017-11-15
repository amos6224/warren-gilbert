variable "AWS_REGION" {
  default = "us-west-2"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "/Users/jeff.destine/.ssh/id_rsa"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "/Users/jeff.destine/.ssh/id_rsa.pub"
}

variable "AMIS" {
  type = "map"

  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
  }
}
