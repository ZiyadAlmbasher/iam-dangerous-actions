# Real-world use cases for ```iam-dangerous-actions```

Below are some practical, real-world use case scenarios for using ```iam-dangerous-actions```.



**Important note**: The scenarios included in this document will use a pre-configured Docker image that contains all the necessary packages and tools defined in this [Dockerfile](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/docker/Dockerfile). This prevents any dependencies or alterations to your current operating system. If you would prefer to install and run all the scripts and required packages manually, please refer to [this guide](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/real-world-use-cases-manual-steps.md).

<br />

## Table of Contents
- [Security Risk Labels](#Security-Risk-Labels) 
- [Scenario 1: Quick "lock-down" of IAM Roles](#scenario-1-quick-lock-down-of-iam-roles)
- [Scenario 2: Finding all dangerous IAM Roles in the AWS account](#scenario-2-finding-all-dangerous-iam-roles-in-the-aws-account)
- [Scenario 3: Checking which IAM policies are "dangerous"](#scenario-3-checking-which-iam-policies-are-dangerous)

<br />


## Security Risk Labels 
PE = Privilege Escalation                     
DC = Disabling or evasion of Security Controls     
DE = Data Exfiltration                             
HT = Hiding one's Tracks     

<br />

## Scenario 1: Quick "lock-down" of IAM Roles

For the first scenario, we will assume that a **security incident**, or **very strict time constraints** require us to quickly secure specific IAM roles in the AWS account(s). These IAM roles can belong to federated Identity Providers, permission-sets, standalone Identity-based IAM Roles, or AWS Service-roles.

- **Step 1**: 

  Let's begin by attaching the following four explicit-deny IAM policies to the problematic IAM Role(s), based on the following security risks: [PE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-PE-risk.txt), [DE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-DE-risk.txt), [DC](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-DC-risk.txt) and [HT](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/explicit-deny-HT-risk.txt). This would mitigate the security risks until further steps are taken.

  **Note:** Before applying these policies, ensure you have a rollback plan and verify that critical business operations won't be disrupted. Test these policies in a non-production environment first when possible.

<br />

- **Step 2**: 

  Finally, we should deploy new SCPs (Service Control Policies) to safeguard these customer-managed, explicit-deny IAM policies against unauthorized access by anyone except security and cloud administrators. This prevents malicious actors from detaching or modifying the protective policies.

<br />

## Scenario 2: Finding all dangerous IAM Roles in the AWS account

This scenario addresses a very common use case: identifying **all existing IAM roles** that may present security risks if exploited by malicious actors—whether internal or external—due to the presence of dangerous IAM actions. The same principle applies to legitimate users who might inadvertently perform harmful operations.

For each IAM role under analysis, **all IAM actions** specified in its attached policies, including inline policies, will be evaluated. Explicit deny actions specified within a role’s policies will be automatically **excluded** from the results.


- **Step 1**:

  If ```Docker``` is not already installed on the system, please follow this [quick guide](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/docker/Docker-install-ubuntu.md) to install it on Ubuntu-based Linux distributions. 

  In Step 2 below, we will use [iam-collect](https://github.com/cloud-copilot/iam-collect), with the following required [IAM actions](https://github.com/cloud-copilot/iam-collect/blob/main/src/aws/collect-policy.json) to run it. Please ensure that these actions are included in the IAM Role permissions that will be used in the subsequent steps.   
  
  Before running the ```docker-run``` commands in Step 2, let's install and configure some prerequisites.     


  ```bash
  sudo apt update
  sudo apt install -y curl unzip git 

  # Creates our working directory and warns us if it already exists  
  [ ! -d ~/iam-dangerous-actions-demo ] && (mkdir ~/iam-dangerous-actions-demo || { echo "Failed to create directory"; exit 1; }) || echo "Directory already exists"       
  
  cd ~/iam-dangerous-actions-demo 


  # Installing the AWS CLI. Skip if it is already installed 
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
  unzip awscliv2.zip && cd aws && sudo ./install && cd .. && rm -rf awscliv2.zip aws 


  # Optional: verify AWS CLI installation
  aws --version


  # Running AWS Configure, mostly to set the Region for the STS tokens 
  aws configure 
    AWS Access Key ID [None]: (press enter to leave empty)
    AWS Secret Access Key [None]: (press enter to leave empty)
    Default region name [None]: us-east-1   
    Default output format [None]: json


  # Export AWS credentials, which will be later used by the Docker container
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
  export AWS_SESSION_TOKEN="your-session-token"     


  # Optional: validate if AWS credentials are OK
  aws sts get-caller-identity


  # Git clone the iam-dangerous-actions repo to get the Dockerfile: 
  cd ~/iam-dangerous-actions-demo 
  git clone https://github.com/ZiyadAlmbasher/iam-dangerous-actions.git && cp iam-dangerous-actions/docker/Dockerfile . 

  ```  
<br />

- **Step 2**:

  Using the [iam-collect](https://github.com/cloud-copilot/iam-collect) tool, let's gather **all** the customer-managed IAM policies in the account through the Docker container so that they are available locally. 

  We will then run the following [shell script](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/scripts/all-actions-for-all-roles.sh), kindly provided by [David Kerber](https://www.linkedin.com/in/davidkerber/), within the Docker container. 
   
  The script will create **one** .txt file for **every IAM role** that exists in the AWS account. Each ```.txt``` file will therefore represent an IAM role and include **all of its combined IAM actions** (for both inline and identity-based policies). The script's output will be stored in a single ```results``` folder,  which will be copied from the container to our local terminal.

  ```bash
  cd ~/iam-dangerous-actions-demo 

  # Build the docker container from our Dockerfile 
  sudo docker build -t iam-dangerous-actions . 
  

  # Download all IAM Roles, policies, etc through iam-collect and leave a copy on our local directory  

  docker run -ti \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  -v "$(pwd)/:/iam-dangerous-actions-demo" -w /root/ iam-dangerous-actions /bin/bash -c \
  "iam-collect download --services iam && cp -rf /root/iam-data /iam-dangerous-actions-demo/" 



  # Run the all-actions-for-all-roles.sh script, as described above, which creates a results folder and
  # syncs it to local terminal 

  docker run -ti \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  -v "$(pwd)/:/iam-dangerous-actions-demo" -w /root/ iam-dangerous-actions /bin/bash -c \
  "cp -rf /iam-dangerous-actions-demo/iam-data /root/iam-data && sh all-actions-for-all-roles.sh && \
  cp -rf /root/results /iam-dangerous-actions-demo/"
  ``` 

  Here is a sample terminal output of ```all-actions-for-all-roles.sh```: 
  ```bash
  ...
  Processed arn:aws:iam::111222333444:role/service-role/ABC -> results/arn_aws_iam__111222333444_role_service-role_ABC.txt
  Processed arn:aws:iam::111222333444:role/DEF -> results/arn_aws_iam__111222333444_role_DEF.txt
 
  All actions for roles have been processed. Check the results directory.
  ```
<br />

 - **Step 3**:

   At this stage, we may choose from the following ```iam-dangerous-actions-security-risk``` lists: [all-security-risks](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-all-risks.txt), [PE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-PE-risk.txt), [DC](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-DC-risk.txt), [DE](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-DE-risk.txt) or [HT](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-HT-risk.txt), in order to cross-reference the ```iam-dangerous-actions``` against the ```results``` folder, which contains all IAM roles and their associated policies within the AWS account.
   
   In this example, we will select the ```iam-actions-HT-risk.txt``` list, and run [this AI-generated Python script](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/scripts/IAM_cross_checker_MP.py) through our Docker container to accomplish all of this.  

   **Side-note:** Using any of the ```iam-dangerous-actions``` lists that **have** security risks assigned to their IAM actions, will save a significant amount of effort later on compared to choosing the [iam-dangerous-actions.txt](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-dangerous-actions.txt) that has **no** security risks assigned. This is because the script below will automatically include the IAM actions **and their respective security risks**, rather than this having to be done manually.

   <br />

   
   ```bash
   cd ~/iam-dangerous-actions-demo 
  
   # Running the IAM_cross_checker_MP.py script. We can also replace "iam-actions-HT-risk.txt" by the name of 
   # any of the other security-lists available. The Docker container has already access to all of them. 

   docker run -ti \
   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
   -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
   -v "$(pwd)/:/iam-dangerous-actions-demo" -w /root/ iam-dangerous-actions /bin/bash -c \
   "cp -rf /iam-dangerous-actions-demo/results /root/ && \
   python3 IAM_cross_checker_MP.py iam-actions-HT-risk.txt results output-all-dangerous-roles.txt && \
   cp -rf /root/output-all-dangerous-roles.txt /iam-dangerous-actions-demo/" 
   ```
   The Docker container will copy the file "output-all-dangerous-roles.txt" to our local working 
   directory ```iam-dangerous-actions-demo```. 



   Sample terminal output of IAM_cross_checker_MP.py: 

   ```
   Loaded 56 actions from iam-actions-HT-risk.txt
   Processing IAM Role: arn_aws_iam__111222333444_role_ABC
   ... ... 
   Processing IAM Role: arn_aws_iam__111222333444_role_DEF
   Report generated: output-all-dangerous-roles.txt
   Roles processed: 125
   Roles with matching dangerous-iam-actions: 44
   ```
   <br />

   Sample file output of output-all-dangerous-roles.txt:

   ``` 
   Role: arn_aws_iam__111222333444_role_Beanstalk-EC2-Role
   "s3:PutObject": HT
   --------------------------------------------------
   Role: arn_aws_iam__111222333444_role_Lambda
   "s3:DeleteObject": HT
   "s3:PutObject": HT
   ...  
   ```
   The output file, ```output-all-dangerous-roles.txt```, contains the ```iam-dangerous-actions``` found across all of the IAM Roles in the account. Happy auditing!


<br />

## Scenario 3: Checking which IAM policies are "dangerous" 

In Scenario 3, we will check if **newly created** or **existing** IAM policies contain any dangerous IAM actions. We will use an AI-generated [python script](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/scripts/IAM_cross_checker_SP.py), which will identify the presence of ```iam-dangerous-actions``` across any IAM policy we would like to audit.  


- **Step 1**: 
    
    **Important note**: If you have not already, please follow all the commands in **Step 1** of Scenario 2 above. 

    Then, let's gather **all** the customer-managed IAM policies in the account using [iam-collect](https://github.com/cloud-copilot/iam-collect) through the Docker container, so they are available in our local directory ```~/iam-dangerous-actions-demo```. 

    ```bash
    # Build the docker image 
    cd ~/iam-dangerous-actions-demo && sudo docker build -t iam-dangerous-actions . 


    # Download all IAM Roles, policies, etc through iam-collect and leave a copy on our local shell directory  

    docker run -ti \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
    -v "$(pwd)/:/iam-dangerous-actions-demo" -w /root/ iam-dangerous-actions /bin/bash -c \
    "iam-collect download --services iam && cp -rf /root/iam-data /iam-dangerous-actions-demo/" 
    ```
    
  <br />

- **Step 2**: 

  Next, we will select 2 things: which IAM policy to audit, and which ```iam-dangerous-actions-security-risk``` list to run against it in order to highlight any matched ```iam-dangerous-actions```. 


  - For the IAM policy, we can copy any of the synced IAM policies to our working directory, which will in turn be synced to our Docker container automatically (take note of the <iam_policy_name_in_lower_case.json> which will be used in the ```docker-run``` command in Step 3 below):  

    ```bash
    # Make sure to change the AWS account number and specific IAM policy name accordingly:  
    
    cp ~/iam-dangerous-actions-demo/iam-data/aws/aws/accounts/111222333444/iam/policy/<iam_policy_name_lower_case>/current_policy.json ~/iam-dangerous-actions-demo/<iam_policy_name_in_lower_case>.json 
    ``` 
  - All of the following ```security-risk-lists``` are already available in the docker container, we just have to take note of the filename and use it directly in the ```docker-run``` command in Step 3 below: ```iam-actions-all-risks.txt```, ```iam-actions-PE-risk.txt```, ```iam-actions-DC-risk.txt```, ```iam-actions-DE-risk.txt``` or ```iam-actions-HT-risk.txt```.
    
  
  In this particular demo, we will use the [all-security-risks-list](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/lists/iam-actions-all-risks.txt), which includes **all** the IAM actions and their respective security risks, as well as the ```dangerous_iam_policy.json``` sample IAM policy, which has the following permissions:

    ```bash
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "SampleDangerousIAMPolicyDoNotUseInProduction",
                "Effect": "Allow",
                "Action": [
                    "iam:*",
                    "lambda:CreateFunction",
                    "sts:AssumeRole",
                    "cloudfront:ListConflictingAliases",
                    "cloudfront:ListAnycastIpLists",
                    "cloudfront:ListDistributions",
                    "s3:*",
                    "ec2:DescribeAccountAttributes",
                    "ec2:DescribeAddresses",
                    "ec2:DescribeImportSnapshotTasks"
                ],

                "Resource": "*"
            }
        ]
    }
    ```
  Notice how `iam:*`, `s3:*`, and `sts:AssumeRole` coexist with other, less harmful IAM actions, such as `ec2:DescribeAccountAttributes`. 

  <br />

- **Step 3**: 

  Finally, we can now run this [Python script](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/scripts/IAM_cross_checker_SP.py) through the Docker container, which will cross-check if there are any ```iam-dangerous-actions``` that exist in both the ```iam-actions-all-risks.txt security-risk-list``` and the IAM policy ```dangerous-iam-policy.json```. Both of these files are already available within the Docker container.
  
  Let's see the script in action: 

  ```bash
  cd ~/iam-dangerous-actions-demo

  # In the example below, we will use "iam-actions-all-risks.txt" and "dangerous-iam-policy.json" as input for 
  # the IAM_cross_checker_SP.py python3 script. However, these two files can be replaced with any IAM policies 
  # or security risk lists, as instructed in Step 2:          

  docker run -ti \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  -v "$(pwd)/:/iam-dangerous-actions-demo" -w /root/ iam-dangerous-actions /bin/bash -c \
  "cp -rf /iam-dangerous-actions-demo/* /root/ && \
  python3 IAM_cross_checker_SP.py iam-actions-all-risks.txt dangerous-iam-policy.json && \
  cp -rf /root/matched_permissions_SP.txt /iam-dangerous-actions-demo/"  
  ```

   The script automatically handles IAM actions with wildcards in the IAM policy, and saves the results to a file named ```matched_permissions_SP.txt```. This file is  copied from the Docker container to the local directory ```~/iam-dangerous-actions-demo```. 

   Here is a sample terminal output of the script: 

  ```bash
  ============================================================
  AWS Permission Checker (Enhanced)
  ============================================================

  🔍 Loaded 401 permissions:
   1. "sts:AssumeRole": PE, (DC, DE, HT)
   2. "sts:AssumeRoleWithSAML": PE, (DC, DE, HT)
   3. "sts:AssumeRoleWithWebIdentity": PE, (DC, DE, HT)
  ... and 398 more

  📜 Policy patterns:
   1. iam:*
   2. lambda:createfunction
   3. sts:assumerole
   4. cloudfront:listconflictingaliases
   5. cloudfront:listanycastiplists
   6. cloudfront:listdistributions
   7. s3:*
   8. ec2:describeaccountattributes
   9. ec2:describeaddresses
  10. ec2:describeimportsnapshottasks

  ============================================================
  💡 RESULT: 132 matches found
  ✅ "iam:AddClientIDToOpenIDConnectProvider": PE
  ✅ "iam:AddRoleToInstanceProfile": (PE, DC)
  ✅ "iam:AddUserToGroup": PE
  ... and 129 more 
  ============================================================

  💾 Saved 132 matched permissions to: matched_permissions_SP.txt
  ```

  As we can see, our IAM policy includes 132 **potentially** dangerous IAM actions, where each IAM action has the appropriate security risk(s) assigned to it. Alternatively, we can also use the `iam-dangerous-actions.txt` list if we need to have output of IAM Actions and no security risks assigned.  

  <br />

  **Important notes and considerations**:

  1. **AWS Services Coverage Limitations**: Not all AWS services in a given IAM policy will fall under the currently supported [list of services](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/tree/main/supporting-files/current_services.txt) for ```iam-dangerous-actions```. Due to the vast size of the AWS universe with over 300 services, many AWS services will **not** be included in the future as part of ```iam-dangerous-actions```.

  2) In the dangerous sample IAM policy above (do not use in production!), EC2 was part of the IAM policy, but it is not **yet** part of ```iam-dangerous-actions```.  This reflects the reality that an IAM policy will more than likely include AWS services that are not yet part of ```iam-dangerous-actions```, and that they may or may not be included in the future.  

     In other words, there could be IAM actions under EC2 that are actually dangerous, but would not be flagged as such today. However, in this specific example, the three EC2 actions in the dangerous sample IAM policy are `describe` in nature and would not be included in the `iam-dangerous-actions` lists, even when the EC2 service is added in the near future.

  3. **Future AWS Services Additions**: The current list of planned AWS services to be added can be found [here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/issues?q=state%3Aopen%20label%3A%22Services-to-add%22). This [ReadMe section](https://github.com/ZiyadAlmbasher/iam-dangerous-actions?tab=readme-ov-file#List-of-current-AWS-services) explains which AWS services are currently included in ```iam-dangerous-actions``` and how other services are chosen. 

<br />
<br />

Back to the main [iam-dangerous-actions page](https://github.com/ZiyadAlmbasher/iam-dangerous-actions).