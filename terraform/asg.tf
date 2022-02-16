resource "aws_launch_configuration" "ghost_lc" {
  name_prefix          = "ghost-lc"
  image_id             = "ami-0e6a67d82bfc95121" # Previously the ubuntu image