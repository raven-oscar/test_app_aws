resource "aws_route_table" "test_app" {
  vpc_id = aws_vpc.test_task.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_app.id
  }
  tags = {
    Name = "devops_Public_Route_Table"
  }
}

resource "aws_route_table_association" "app_subnet_c1a" {
  subnet_id      = aws_subnet.app_subnet_c1a.id
  route_table_id = aws_route_table.test_app.id
}

resource "aws_route_table_association" "app_subnet_c1b" {
  subnet_id      = aws_subnet.app_subnet_c1b.id
  route_table_id = aws_route_table.test_app.id
}

resource "aws_route_table_association" "app_subnet_c1c" {
  subnet_id      = aws_subnet.app_subnet_c1c.id
  route_table_id = aws_route_table.test_app.id
}