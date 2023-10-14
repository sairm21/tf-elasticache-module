resource "aws_elasticache_subnet_group" "elasticache"  {
  name       = "${var.component}-${var.env}-cluster-subent-group"
  subnet_ids = var.subnet_ids

  tags = { Name = "${var.env}-${var.component}-subnet-group" }
}

resource "aws_security_group" "elasticache_sg" {
  name        = "${var.component}-${var.env}-SG"
  description = "Allow ${var.component}-${var.env}-Traffic"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow inbound traffic for ${var.component}-${var.env}"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.env}-${var.component}-SG"
  },
    var.tags)
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id       = "${var.component}-${var.env}-redis-cluster"
  description                = "${var.component}-${var.env}-elasticache replication group"
  node_type                  = var.node_type
  port                       = var.port
  engine                     = var.engine
  engine_version             = var.engine_version
  parameter_group_name       = var.parameter_group_name
  automatic_failover_enabled = true

  num_node_groups         = var.num_node_groups
  replicas_per_node_group = var.replicas_per_node_group

  subnet_group_name = aws_elasticache_subnet_group.elasticache.name
  security_group_ids = [aws_security_group.elasticache_sg.id]
  kms_key_id = var.kms_key_id
}