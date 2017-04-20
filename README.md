# dexcom_chef_httpd

This readme contains instructions for setting up a hosted Chef server, an AWS EC2 Chef Workstation, and launching an AWS EC2 instance running CentOS 7.2 which joins the hosted Chef org and is then configured as a basic web-server with the "Hello World" web page.<BR>
<BR>
**Even if you already meet the pre-requisites below, please be sure to read the NOTE at the end of each to ensure that you have the needed files and information for the later steps.**

## Pre-requisites:
### Set up hosted Chef Server:
Create a new chef account at https://manage.chef.io/signup.<br>
Click on "Create New Organization"<br>
Enter a full name and short name for your organization.  (I used  dexcom_challenge for mine.)<br>
Click Create Organization<br>
From Administration tab, select your organization and click "Generate Knife Config" from list on left side.  Save the file somewhere you can find it again.<br>
Next, select Users from the left side.  Select your user and click "Reset Key" on the left column.<br>
Click on "Reset Key" on the new pop-up.<br>
A new pop-up will display your private key.  Click "Download" and save the file somewhere you can find it again.<br>
*NOTE: If you already have a chef server and org, you will still need your knife config file and user .pem file.*

### Set Up AWS account:
I didn't document the initial setup, as I didn't do it as part of this exercise.<br>
Browse to https://aws.amazon.com/ and sign in.<br>
Select IAM from the "Security, Identity & Compliance" group<br>
Select Users from left side of screen.<br>
Select "Add user"<br>
Enter a user name for this user.<br>
Select "Programmatic access"<br>
Click "Next: Permissions"<br>
Either select a group or click "Create group"<br>
  Enter a group name and select policies to apply.  For this test, I just created a admin group and checked  "AdministratorAccess".<br>
  Click "Create group"<br>
Click "Next: Review"<br>
Click "Create user"<br>
Copy the entires under "Access key ID" and "Secret access key".  You will need these later.<br>
Click "Close"<br>
*NOTE: If you already have have an AWS account, you may still wish to create a new user.  Either way, you will need an Access key ID and Secret access key.*

### Create Chef Workstation in AWS EC2:
Log in to AWS<br>
Select Services -> EC2<br>
Click on "Launch Instance"<br>
Click "Select" next to the free Red Hat option.<br>
t2.micro should be default.  Click "Next: Configure Instance Details"<br>
Leave defaults and click "Next: Add Storage"<br>
Ensure that Volume Type is "General Purpose SSD (GP2) and that "Delete on Termination" is checked.  Click "Next: Add Tags"<br>
Click "click to add a Name tag" link in center of screen.  Type "Chef Workstation" into the Value field.  Click "Next: Configure Security Group"<br>
Fill in "Security Group Name" with "DexCom-Chef"<br>
SSH should already exist.  Under "Source" Change "Custom" to "Anywhere"<br>
Click "Add Rule"<br>
Change "Rule Type" to "HTTP" and "Source" to "Anywhere"<br>
Click "Add Rule"<br>
Change "Rule Type" to "HTTPS" and "Source" to "Anywhere"<br>
Click "Review and Launch<br>
Review settings and click "Launch"<br>
A new window should pop up to set up ssh keys.  Select "Create a new key pair" and name it dexcom.<br>
Click "Download Key Pair" and save the file someplace you can find it later.<br>
Click "Launch Instances"<br>
Select "Services -> EC2" from menu.<br>
Click "Security Groups" from lefthand panel.<br>
Record the "Group ID" of the "DexCom-Chef" group for later.<br>
Click "Instances" in the lefthand panel.<br>
Watch until instance state changes to "running".  At this point, get the public ip address.  Use whatever ssh method you like to connect using the key you just downloaded and user ec2-user.<br>
*NOTE: If you already have a Chef Workstation, you will need to create a dexcom key pair on AWS EC2 and save it.

## Configure Chef Workstation
Log in to the Chef workstation you just created.<br>
Assuming this is a fresh AWS instance, you'll need to install git:<br>
```
sudo yum -y install git
```
Pull down my chef code from git.<br>
```
git clone https://github.com/No0dleboy/dexcom_chef_httpd.git
cd dexcom_chef_httpd
mkdir .chef
```
Copy the knife.rb and username.pem file you saved during the Chef server setup to the .chef directory.  Since this is a headless system, I had to use sftp to put the files in place.<br>
Also copy the AWS dexcom.pem file from the Workstation setup into the ~/.ssh directory.<br>

You should now be able to run ./config_chef_workstation.  This will prompt you for some of the info that you recorded above, and use it to install and configure chef.  It will also create a new_EC2_webserver script which you can run to automatically spin up a new CentOS instance in AWS and configure it to join the Chef org with the 'web' role.
