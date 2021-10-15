resource "aws_s3_bucket" "test-app" {
  bucket = "e-task-app"
  acl    = "private"

  tags = {
    Name        = "e-task-app"
  }
}