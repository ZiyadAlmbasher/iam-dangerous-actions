<p align="center">
  <img src="supporting-files/logo.png">
</p>

# iam-dangerous-actions


## Table of Contents

1. [Problem Statement](#Problem-Statement)
2. [What is iam-dangerous-actions](#What-is-iam-dangerous-actions)
3. [Getting Started: Real-world use cases](#Getting-Started-Real-world-use-cases)
4. [How are security risks assigned to IAM actions?](#How-are-security-risks-assigned-to-iam-actions)
5. [Available-formats](#Available-formats)
6. [List of current AWS services](#List-of-current-AWS-services)
7. [Total number of iam-dangerous-actions](#Total-number-of-iam-dangerous-actions)
8. [How is this different from other IAM tools?](#How-is-this-different-from-other-IAM-tools)
9. [Who is this for?](#Who-is-this-for)
10. [Exclusions](#Exclusions)
11. [What is the difference between dangerous and high privilege IAM actions?](#What-is-the-difference-between-dangerous-and-high-privilege-IAM-actions)
12. [Future plans](#Future-plans)
13. [Contributions and feedback](#Contributions-and-feedback)
14. [Acknowledgements](#Acknowledgements) 

<br />

## Problem Statement

One of the most effective ways to secure an AWS account — and, by extension, the organization as a whole — is to minimize security threats and attack vectors, whether they are internal or external.

The next logical step is to implement the least-privilege principle for IAM roles and permission-sets in a well-configured manner.

This [introduction](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/introduction.md) explains some of the challenges with IAM and the reasoning behind creating ```iam-dangerous-actions```, which aims to **"Find and Lock Down Your Dangerous IAM Roles, Fast!"**.

<br />

## What is ```iam-dangerous-actions```? 

A **list** of hand-picked **dangerous** IAM actions that, if used with malicious intent, or assigned carelessly, can lead to the following security risks:

1. AWS privilege escalation (PE)
2. Evasion or Disabling of security controls (DC)
3. Data Exfiltration (DE)
4. Hiding one's tracks (HT)

**Each** of the ```iam-dangerous-actions``` is assigned to one or more of the **security risks** listed above. The process by which these security risks are assigned to each IAM action is [explained here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/how-are-risks-assigned.md).  


The ```iam-dangerous-actions``` list is available in different [formats](#Available-formats) (or sublists), for various [real-world use cases](#Real-world-use-cases).


<br />

## Getting started: Real-world use cases

There are currently 3 [real-world use cases](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/real-world-use-cases.md) to explore some of the capabilities of ```iam-dangerous-actions```.

Here’s a quick demo of one of the use‑case scenarios: "[Checking which IAM policies are dangerous](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/real-world-use-cases.md#scenario-3-checking-which-iam-policies-are-dangerous)":


<!-- Image of test1.svg -->

![Demo1](supporting-files/demo1.svg)


<br />

## How are security risks assigned to IAM actions? 
A detailed overview is available [here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/how-are-risks-assigned.md). 

<br />


## Available formats

```iam-dangerous-actions``` is available in different [formats, or "sub-lists"](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/available-formats.md). 



<br />

## List of current AWS services: 
While AWS offers more than 300 services today, only a carefully selected subset of [services](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/supporting-files/current_services.txt) are included in the ```iam-dangerous-actions``` [lists](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/tree/main/lists). 

These AWS services are selected based on their importance and the security risks they pose. They generally fall under the following categories: 
- AWS security services, such as IAM, AWS Config, AWS Organizations, and SecurityHub
- Data-related AWS services, including data analytics services, databases, and storage  
- AWS Compute services, such as EC2, Lambda, and API Gateway  

The planned AWS services to be included are listed [here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/issues?q=state%3Aopen%20label%3A%22Services-to-add%22).

<br />

## Total number of ```iam-dangerous-actions```

All of the ```iam-dangerous-actions``` [lists](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/tree/main/lists) are versioned and include an exact count of the current IAM actions included. A version history file can be found [here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/supporting-files/versions.txt). 

Once all planned AWS services have been [added](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/issues?q=state%3Aopen%20label%3A%22Services-to-add%22), it is estimated that ```iam-dangerous-actions``` will contain approximately 800-1500 unique IAM actions. This equates to approximately 4–8% of the 18,000+ [AWS IAM actions](https://aws.permissions.cloud/) available.

As more IAM actions corresponding to important AWS services are [added](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/issues?q=state%3Aopen%20label%3A%22Services-to-add%22), ```iam-dangerous-actions``` will become more powerful, useful, and complete.

<br />


## How is this different from other IAM tools?

Although many excellent IAM tools are available today, most focus on finding IAM misconfigurations, including least-privilege issues.  

```iam-dangerous-actions``` aims to address IAM [from a different perspective](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/how-is-this-different.md), focusing on identifying inherently risky IAM actions in our IAM Roles and policies. Each one of these dangerous IAM actions will be classified under its own security risk label.  

The project is therefore intended to be used alongside other IAM tools in order to offer a complementary perspective, rather than replace existing solutions. 

<br />

## Who is this for? 

- **Cloud security admins** who frequently create or validate existing IAM Roles, policies, and permission-sets. 

- **AWS Security auditors** conducting comprehensive reviews of IAM Roles, policies, and permission-sets as part of AWS Account-wide security audits and compliance assessments.

- **Pentesters** and **internal security teams** can also use ```iam-dangerous-actions``` to identify internal or external attack vectors and perform security threat assessments.    

<br />

## Exclusions
```iam-dangerous-actions``` does **not** include actions that are **purely** harmful or destructive in nature, such as deleting Lambda functions, Transit Gateways, or S3 buckets. There are excellent [SCPs](https://github.com/aws-samples/service-control-policy-examples/tree/main) that can help prevent these scenarios.

However, the exception to this rule is when IAM actions will directly lead to the disabling of security controls or deleting resources in order to gain higher privileges.

<br />


## What is the difference between "dangerous" and "high privilege" IAM actions? 
The difference between the two is explained [here](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/documentations/define-dangerous-actions.md). 

<br />


## Future plans
The list(s) generated by ```iam-dangerous-actions``` will feed another project in the future: ```iam-security-risks```. 

```iam-security-risks``` will use [iam-collect](https://github.com/cloud-copilot/iam-collect), [iam-lens](https://github.com/cloud-copilot/iam-lens), and ```iam-dangerous-actions``` to identify security risks and classify them by severity. The following [example](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/blob/main/supporting-files/attack-vector-examples.md) illustrates the basic concept of ```iam-security-risks```.

<br />


## Contributions and feedback
Please submit any suggestions or feedback through the [issues page](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/issues), or [PRs](https://github.com/ZiyadAlmbasher/iam-dangerous-actions/pulls) for any improvements. 

<br />

## Acknowledgements
Many thanks to [David Kerber](https://www.linkedin.com/in/davidkerber/) and [DanK](https://github.com/danktec) for supporting various aspects of this project throughout its different stages. 