resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = var.replicate_source_db == null ? var.db_name : null
  username               = var.replicate_source_db == null ? var.db_user : null
  password               = var.replicate_source_db == null ? var.db_password : null
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = var.environment == "prod" ? true : false
  replicate_source_db    = var.replicate_source_db

  tags = {
    Name        = "${var.environment}-db"
    Environment = var.environment
  }
}
