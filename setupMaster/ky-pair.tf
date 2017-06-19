resource "aws_key_pair" "key" {
  key_name   = "keyLoadlb"
  public_key = "${file("C:\\Users\\lbushko\\Desktop\\terraform_XXX\\.ssh\\keyLoadlb.pub")}"
}