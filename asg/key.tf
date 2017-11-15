resource "aws_key_pair" "mykeypair" {
  key_name   = "amos6224"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"

  lifecycle {
    ignore_changes = ["public_key"]
  }
}
