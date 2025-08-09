##Provider for ap-northeast-1
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-northeast-1"
}

##Network
module "network" {
  source = "../../module/network"

  general_config      = var.general_config
  availability_zones  = var.availability_zones
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  internet_gateway_id = module.network.internet_gateway_id
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  dmz_subnets         = var.dmz_subnets
  public_subnet_ids   = module.network.public_subnet_ids
}

##Security Group Internal
module "internal_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_blocks    = ["10.0.0.0/16"]
  sg_role        = "internal"
}

##Secutiry Group Operation
module "operation_sg_1" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_1_cidr
  sg_role        = "operation_1"
}

module "operation_sg_2" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_2_cidr
  sg_role        = "operation_2"
}

##Security Group SSM
module "ssm_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "ssm"
}

##ECS
module "ecs" {
  source = "../../module/ecs"

  general_config     = var.general_config
  task_role          = var.task_role
  ecr_repository_url = module.ecr.ecr_repository_url
  fargate_cpu        = var.fargate_cpu
  fargate_memory     = var.fargate_memory
  dmz_subnet_ids     = module.network.dmz_subnet_ids
  internal_sg_id     = module.internal_sg.security_group_id
  ssm_sg_id          = module.ssm_sg.security_group_id
  iam_ecs_arn        = module.iam_ecs.iam_role_arn
}

##ECR
module "ecr" {
  source = "../../module/ecr"

  general_config      = var.general_config
  ecr_repository_role = var.ecr_repository_role
  region              = var.region
  docker_image_name   = var.docker_image_name
}

##CloudWatch
module "cloudwatch" {
  source = "../../module/cloudwatch"

  general_config = var.general_config
  task_role      = var.task_role
}

##IAM
module "iam_ecs" {
  source = "../../module/iam"

  role_name   = var.role_name_1
  policy_name = var.policy_name_1
  role_json   = file("../../module/ecs/iam_json/fargate_task_assume_role.json")
  policy_json = file("../../module/ecs/iam_json/task_execution_policy.json")
}

##RDS
module "rds" {
  source = "../../module/rds"

  general_config       = var.general_config
  private_subnet_ids   = module.network.private_subnet_ids
  engine_name          = var.engine_name
  major_engine_version = var.major_engine_version
  engine               = var.engine
  engine_version       = var.engine_version
  username             = var.username
  password             = var.password
  instance_class       = var.instance_class
  storage_type         = var.storage_type
  allocated_storage    = var.allocated_storage
  multi_az             = var.multi_az
  internal_sg_id       = module.internal_sg.security_group_id
}

##SSM
module "ssm" {
  source = "../../module/ssm"

  general_config = var.general_config
}