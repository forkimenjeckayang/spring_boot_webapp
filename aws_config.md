## Setting Up With AWS

- Make sure you have a properly configured Dockerfile which will be used to create your container on amazon ECR.
- Also make sure you have the AWS CLI installed and configured.
By running the below command, you setup your aws credentials 
```bash
aws configure
```
- To make sure you securely connect to your ECR regsitry and store your credentials securely too(and not in the docker json config file), you need the following
* Docker installed on your system
* golang-docker-credential-helpers
* pass password manager installed and configured on your system
* A GPG key for encrypting the pass password store

*golang-docker-credential-helpers is a set of tools that help Docker securely store and manage login credentials (like usernames and passwords). Instead of keeping these credentials in plain text files, these helpers use secure storage solutions provided by the operating system or other secure systems.*

# Steps

- Install golang-docker-credential-helpers
```bash
sudo apt install golang-docker-credential-helpers
```
- Setting up the pass Credential Helper
Install pass
```bash
sudo apt-get install pass
```
- Configure with GPG key If you don't have a GPG key already, generate a new one using the command below:
```bash
gpg --gen-key
```
- After generating your GPG Key you will need to use the ID to initialize pass. You can get the ID of the GPG Key as follows:

```bash
gpg --list-key
```
The output will look as follows:

```bash
pub   rsa3072 2021-02-09 [SC] [expires: 2022-02-09]
      3782CBB60147010B330523DD26FBCC7836BF353A
uid                      John Doe (Fedora Docs) <johndoe@example.com>
sub   rsa3072 2021-02-09 [E] [expires: 2022-02-09]
```
- The ID of the key is just the last 8 characters of the hexadecimal number in the result above *3782CBB60147010B330523DD26FBCC7836BF353A* which will be *36BF353A*

- Finally Initialize the Credential Helper using the command:
```bash
pass init "Your GPG Key ID"
```
Configure Docker to Use the Credential Helper: Open your Docker configuration file (usually located at ~/.docker/config.json on Unix-based systems) and add the following:
```json
{
  "credsStore": "pass"
}
```
- Try Connecting to any container registry in our case we will test AWS ECR
To login to ECR  use the command provided to you by the AWS. It should be something like this:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 339712861758.dkr.ecr.us-east-1.amazonaws.com
```
# NOTE
- When you login to your AWS console and head to the ECR, you create a private repo
- Access the private repo and view push commands
- The commands provided by aws will allow to login which we did above, build image (using Dockerfile), tag image and push to ECR

## NOTE
- In our app, we are using a PostgreSQL database , so we have to make sure our Database is up and running before building our application.
- Head to RDS in AWS Console and create a new database
- After creating , make sure you modify the security group such that we allow inboud traffic on the port (default database port ie 5432 for postgres)
- We need now the *Endpoint* & *port* of the database provided by AWS when the database has been created to link to our application (for us in our application.properties file).
Something Like this
```yml
spring.datasource.url=jdbc:postgresql://<endpoint>:<port>/<database_name>
```
- If your application now runs with the AWS RDS postgres instance, then you can go ahead and build package and create your image on that configuration


# Now you can follow up which the creation of your container on ECR before proceeding to ECS

# ECS configuration

- We have our database up and running
- Our image on ECR uploaded successfully
- Now we need to run our Conatainer to access our application

## STEPS
- Head over to ECS

- Create a cluster : *a Cluster is a logical grouping of tasks or services. It allows you to manage and scale a collection of container instances or Fargate tasks. Clusters enable the deployment, management, and monitoring of containerized applications within a shared resource pool.*

- Create a task-definition :  *a Task is the instantiation of a task definition, which is a blueprint for your application. It specifies the Docker containers to run, including details like the image, CPU, and memory requirements, and networking configuration*
Set the port which your container is running on and the image you are using for the task definition

- Now create a service in your *Cluster* .Decide your service name, select your task definition which will be used with the Service your creating 
  # Create an Application Load Balancer if your application is accessed via HTTP(S) OR Network Load Balancer if application is accessed at the network layer TCP/UDP of the OSI model

  # In creating your service , a target group is created. Which is used by the load balancer to route traffic to a particular IP address of the service
The above should get your service running

- Now our application has a specific port to which it listens to , so it will be good to add this port and part of the inbount rules in the security group so that we can access our application.
(Custom TCP: On Port 8080 and allows all IPv4 addresses to access it)

- Go to your *Service* , access *tasks*, there you will see your pulic IP. You can use that together with the port to access see if your application is accessible. If it is, then we need to have a secure connection and a nice name for our Application.

## ROUTE 53

- Provided by Amazon for us to purchase domain names which can be used to acces our applications
- Head to Route 53 on your AWS console
- Now click Hosted Zones (provided you already have a domain which has been bought and Hosted)
- Select your Hosted zone and create a record (basically a subdomain)
- U can use the pulic IP to assign to the record or take the ALias option (Akias to Application and Elastic Load Balancer) in our case , then choose your region.
- That said you should be able to access your application via the record name (subdomain)

- Head over to your Load Balancer where we have Listerners and Rules , select the listener and click edit listener 
- Chang from HTTP to HTTPS which sets the port at 443, target group automatically slected and lastly you select the Certificate to use for secure communication(BAsically the certificate provided by the hosting provider or you reqquest new  ACM certificate) 




