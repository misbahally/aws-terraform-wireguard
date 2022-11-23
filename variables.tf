variable "instance_type" {
   type    = string
   default = "t4g.nano"
}
variable "instance_name" {
   type    = string
   default = "Wireguard VPN"
}
variable "ingress_rules" {
  type    = list(number)
  default = [22]
}
variable "ingress_rules_udp" {
  type    = list(number)
  default = [19872]
}
variable "egress_rules" {
   type    = list(number)
   default = [0]
}
variable "egress_rules_udp" {
   type    = list(number)
   default = [0]
}
