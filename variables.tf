variable "region" {
  type    = string
  default = "us-central"
}
variable "project" {
  type    = string
  default = "qbe-24052023-demo"
}
variable "user" {
  type    = string
  default = "javedshaikh_gmail_com"
}
variable "email" {
  type    = string
  default = "tf-gcp-sa@qbe-24052023-demo.iam.gserviceaccount.com"
}
variable "privatekeypath" {
  type    = string
  default = "~/.ssh/id_rsa"
}
variable "publickeypath" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}