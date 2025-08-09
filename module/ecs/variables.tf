variable "general_config" {
  type = map(any)
}
variable "task_role" {}
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "iam_ecs_arn" {}
variable "ecr_repository_url" {}
variable "dmz_subnet_ids" {}
variable "internal_sg_id" {}
variable "ssm_sg_id" {}