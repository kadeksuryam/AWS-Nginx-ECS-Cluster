resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_ecs_subnet" {
  vpc_id            = aws_vpc.ecs_vpc.id
  count             = length(var.public_subnet_cidr_block)
  cidr_block        = element(var.public_subnet_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)
}

resource "aws_subnet" "private_ecs_subnet" {
  vpc_id            = aws_vpc.ecs_vpc.id
  count             = length(var.private_subnet_cidr_block)
  cidr_block        = element(var.private_subnet_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)
}


resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table" "ecs_rt" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
}

resource "aws_route_table_association" "subnet_route" {
  count          = length(var.public_subnet_cidr_block)
  subnet_id      = element(aws_subnet.public_ecs_subnet[*].id, count.index)
  route_table_id = aws_route_table.ecs_rt.id
}

resource "aws_eip" "nat_eip" {
  vpc   = true
  count = length(var.public_subnet_cidr_block)
}

resource "aws_nat_gateway" "ecs_nat" {
  count         = length(var.public_subnet_cidr_block)
  allocation_id = element(aws_eip.nat_eip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_ecs_subnet[*].id, count.index)
}

resource "aws_route_table" "ecs_rt_private" {
  vpc_id = aws_vpc.ecs_vpc.id
  count  = length(aws_nat_gateway.ecs_nat)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ecs_nat[*].id, count.index)
  }
}

resource "aws_route_table_association" "subnet_route_private" {
  count          = length(var.private_subnet_cidr_block)
  subnet_id      = element(aws_subnet.private_ecs_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.ecs_rt_private[*].id, count.index)
}
