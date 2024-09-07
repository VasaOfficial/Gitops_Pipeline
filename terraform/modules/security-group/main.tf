# Security Group for EKS Cluster
resource "aws_security_group" "eks_cluster" {
  vpc_id = aws_vpc.main.id
  description = "Security group for EKS Cluster"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes" {
  vpc_id = aws_vpc.main.id

  # Allow inbound traffic from the EKS control plane
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
    description = "Allow communication from EKS cluster"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-nodes-sg"
  }
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
  description = "Security group for Application Load Balancer"

  # Allow inbound traffic on port 80 and 443 (HTTP and HTTPS)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to worker nodes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
