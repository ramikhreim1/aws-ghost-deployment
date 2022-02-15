terraform {
  backend "s3" {
    encrypt = true
    bucket  = "s3terraformstatefiles"
    region  = "eu-north-1"
   #key     = "remote-state-s3-backend/aws/"
  }
}