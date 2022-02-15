# ASSIGNMENT FOR THE TECHNICAL INTERVIEW CLOUD ARCHITECT

# AWS Ghost Terraform module

Deploying Ghost 3.0 to AWS using EC2 Auto Scaling, RDS and Terraform.

## Overview and Deliverables

During the interview i will use this guide to present my solution for Drone Shuttles Ltd buissness case.
This cover the Architecture design , Security , Documentation. Have deployed a Ghost blog on EC2 instances behind an Auto Scaling group, RDS and Terraform for high availability and ease of management. the solution should be able to adapt to traffic spikes, could be increases of up to 4 times the typical load. 

To make sure that the ASG always keep 1 healthy instance at all time, Buissness case expected that during the new product launch or marketing campaigns there
could be increases of up to 4 times the typical load, so i have defined the AutoScaling Group asg_min_size and asg_max_size variables value to 4.

This module will allow Drone Shuttles Ltd to deploy a single instance behind an Auto Scaling group and RDS using Terraform for high availability and ease of management. It is free tier eligible if you use the right instance sizes.



# Enable HTTPS , Application Load Balancer .
ALB It supports many different features for web applications supports client TLS session termination (http & https, layer 7),the application will return consistent results across sessions.

Its very important and highly recommend that you look into this before you decide to make your application public facing. You will basically need to create a certificate / import it into the Amazon Certificate Manager, validate it, and add it to your new alb HTTPS listener. This process can vary according to your domain register.

Still we need to create an HTTPS listener, which uses encrypted connections (also known as SSL offload). This feature enables traffic encryption between your load balancer and the clients that initiate SSL or TLS sessions. Application Load Balancer supports client TLS session termination. This enables you to offload TLS termination tasks to the load balancer, while preserving the source IP address for your back-end applications. You can choose from predefined security policies for your TLS listeners in order to meet compliance and security standards. AWS Certificate Manager (ACM) or AWS Identity and Access Management (IAM) can be used to manage your server certificates.


# Diagram

https://lebureau.dev/content/images/2021/05/image_o-26.png 

# Cross-Region disaster recovery of Amazon RDS for SQL Server:
https://aws.amazon.com/blogs/database/cross-region-disaster-recovery-of-amazon-rds-for-sql-server/
Amazon RDS for SQL Server provides a Multi-AZ deployment, which replicates data synchronously across AZs. This highly available Multi-AZ deployment is usually sufficient for a DR strategy within one region in an AWS cloud environment. 
In addition, with the in-Region read replica capability of Amazon RDS for SQL Server, you can use read replicas as a warm standby solution in a different AZ. This provides another in-Region DR strategy.

Before you consider a cross-region DR strategy, you need to evaluate whether an in-Region DR solution meets your needs or not.

Recovery point objective (RPO), recovery time objective (RTO), and cost are three key metrics to consider when developing your DR strategy. Based upon these three metrics, you can define your DR strategy ranging from a cold DR (backup and restore) to a hot DR (active to active). A reliable and effective cross-region DR strategy keeps your business in operation with little or no disruption even if an entire region goes offline.

Cross-Region DR strategy
A cross-Region DR strategy consists of two approaches: snapshot and restore, and continuous replication.

Snapshot and restore
If you have less stringent RTO and RPO requirements for your RDS SQL servers, using cross-Region snapshot and restore is one of the most cost effective cross-Region DR strategies.

In your source Region of your Amazon RDS for SQL Server, you can perform the following actions:

Create snapshots of your Amazon RDS for SQL Server based upon a pre-defined schedule.
Copy the snapshots to your DR Region. The frequency of snapshot copying is determined based on the RPO requirement.
When you test or execute your DR plan in case of a disaster, you can restore the snapshot to a new Amazon RDS for SQL Server instance.

# Devops,Devlopment
Now that our 'base' deployment is done, you might want to integrate custom themes found on the marketplace for your blog. This blog post describes this process, and should be pretty straightforward. But what if our instance fails and get re-created?

Every time you make custom modifications to the theme used and other static content, you can create a custom AMI of your instance and its volume. To do this, go to EC2 > Instances, click on the ghost instance, and at the top right your windows, click on Actions > Image and templates > Create image.
You can then enter an image name you can easily identify, and click on Create image. Once this is done, go to EC2 > Images > AMIs to grab your newly created image ID, so we can update our launch configuration to update the image used by our instances and remove the user_data:

asg.tf

resource "aws_launch_configuration" "ghost_lc" {
  name_prefix          = "ghost-lc"
  image_id             = {custom_ami_id} # Previously the ubuntu image
  [...]
  # user_data = [...] 				     # Remove or comment out this block
  
You can keep the user_data file in case you need it for a new deployment later on. Don't forget to Terraform apply to validate your changes.

Here are some improvements you could make for this Ghost deployment (HTTPS being mandatory):

Add a Cloudfront Distribution to better deliver our static content, potentially with S3.

# Creating an Amazon CloudWatch dashboard to monitor Amazon RDS (Observability).
As a part of Amazon RDS for MySQL database performance monitoring, it’s important to keep an eye on slow query logs and error logs in addition to default monitoring. Slow query logs help you find slow-performing queries in the database so you can investigate the reasons behind the slowness and tune the queries if needed. Error logs help you to find the query errors, which further helps you find the changes in the application due to those errors. However, monitoring these logs manually through log files (on the Amazon RDS console or by downloading locally) is a time-consuming process.

Pre-requisites:
Before you get started, you must complete the following prerequisites:

Since we have an RDS for MySQL instance already created, you can enable log exports to publish to CloudWatch by modifying the instance.
https://aws.amazon.com/premiumsupport/knowledge-center/rds-aurora-mysql-logs-cloudwatch/

Make sure the CloudWatch log group is created and logs are published to CloudWatch by looking at the log groups.
You can also encrypt log data using AWS Key Management Service (AWS KMS). For instructions, see Encrypt Log Data in CloudWatch Logs Using AWS Key Management Service.
https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html

# Creating the CloudWatch dashboard using a template (CloudWatchDashboard.json)

This section focuses on creating the CloudWatch dashboard using a template that creates the same widgets from the previous section.
On the Amazon RDS console, under Databases, find the DB identifier name and Region of your database.

The template code located in the project repository (CloudWatchDashboard.json) open it using any text editor. Replace <your db identifier> with your DB identifier name. If your Region isn’t us-east-1, replace <your region> with your current Region.
  
  follow this guide to Replace the default with the preceding template code:
  https://aws.amazon.com/blogs/database/creating-an-amazon-cloudwatch-dashboard-to-monitor-amazon-rds-and-amazon-aurora-mysql/
  
  


# Requirements

* An AWS account already setup
* A S3 bucket already defined for the Terraform state
* Terraform v0.14.x installed

# Deploying the Infrastructure
We will use Terraform to deploy the multiple infrastructure components within AWS. 

We will have to deploy everything from scratch, including:

A VPC with required subnets and other networking components
An EC2 Auto Scaling group to self heal in case of hardware failure
An Application Load Balancer to direct trafic to the active instance
A RDS instance as our managed DB solution.

## Usage

* Export your AWS credentials using the CLI or tools like Awsume
* Provide your remote state information in backend.tf i used s3 as my default backend since its a demo project s3 server-side encryption with AWS Key Management Service (SSE-KMS) not enabled during this demo, its highy recommended to consider in the futures projects.
  
* Update all the default values in variables.tf 
* Go to the terraform folder and apply the code
```
cd terraform
terraform init
terraform apply
```


