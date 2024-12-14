terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}


provider "aws" {
  # configuration options
  region = var.region
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "static-hosting-tf-bucket"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./index.html"
  key    = "index.html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
}