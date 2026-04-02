terraform {
  backend "s3" {
    bucket = "appbackup2121"
    key    = "state"
    region = "us-east-1"
    dynamodb_table = "backend"
  }
}
