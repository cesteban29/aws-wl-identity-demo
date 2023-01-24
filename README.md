# TFC Workload Identity Example with AWS

This repository documents an example for integrating the TFC Workload Identity feature to get just-in-time credentials to the AWS provider. As opposed to having static credentials stored in workspace variables or variable sets. 

## Set Up Requirements 

### Configure Trust between TFC and the Cloud Platform

The trust is established by:
https://github.com/cesteban29/aws-wl-identity-demo/blob/576122660b44e22dd25679e9c02bec919a19424c/wl-identity-setup/main.tf#L15-L25

### Configure a Role and Trust Policy

https://github.com/cesteban29/aws-wl-identity-demo/blob/576122660b44e22dd25679e9c02bec919a19424c/wl-identity-setup/main.tf#L27-L80

### Variable Setup

The following variables need to be created as environment variables within TFC/E. These variables can specified in workspace level or variable set level variables as appropriate.

* TFC_WORKLOAD_IDENTITY_AUDIENCE: Sets the audience of the identity token. Needed to enable workload identity functionality.
  * A good default value for this variable is aws.workload.identity. Customization of this value is left up to the user if this is desired.

* TFC_AWS_RUN_ROLE_ARN: The ARN of the role to be assumed
  * For advanced users who want to use different roles and access levels for plan and apply operations, TFC_AWS_PLAN_ROLE_ARN and TFC_AWS_APPLY_ROLE_ARN should be used instead.

### Custom TFC Agent

#### Dockerfile
The Dockerfile used to build the agent code will need to be modified similar to the below to allow for running hooks, and to create a directory for persisting an identity token to.
https://github.com/cesteban29/aws-wl-identity-demo/blob/576122660b44e22dd25679e9c02bec919a19424c/docker-agent/dockerfile#L1-L13

#### Pre-Plan and Pre-Apply Agent Hooks
Terraform Cloud Agents support running custom programs, or hooks, during strategic points of a Terraform run. These hooks allow you to extend the functionality of Terraform runs.
https://github.com/cesteban29/aws-wl-identity-demo/blob/576122660b44e22dd25679e9c02bec919a19424c/docker-agent/hooks/terraform-pre-apply#L1-L18

### Commands
Command to build new docker agent image with the modifications:
```
docker build -t hashicorp/tfc-agent:tag-name .
```

Command to run the new docker agent image:
```
docker run -e TFC_AGENT_TOKEN -e TFC_AGENT_NAME hashicorp/tfc-agent:tag-name
```

