terraform {
  backend "s3" {
    bucket         = "ndeguchi-terraform03stg"
    key            = "tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "ndeguchi-terraform03stg"
  }
}
