# Exploratory question

What would be your strategy to deploy and maintain an Apache Spark cluster on Azure (preferentially). Describe a strategy and tools to be used for deploying, maintenance, monitoring and alerts. Please explain briefly your options.

## Strategy

In order to simplify the strategy description, we'll separate between the Infrastructure and the Application.

### Infrastructure

There are several considerations when trying to develop a strategy for deploying infrastructure:

* Do you set it up once and it's done?
* Are you trying to build a multi-environment / multi-cloud infrastructure?
* How big is your team?
* Does your ops team know how to code?

In order to be able to scale, the strategy you use to deploy your infrastructure should be as automated as possible. This will allow anyone on the team to deploy or even the deploys be done by a CI\CD engine. This will allow your team to scale in terms of services / workload. The best strategy to do this is to go with a Infrastructure-as-Code (IaC) approach.

There's 2 ways of accomplishing this:

* Imperative scripting
* Declarative scripting

The end result will be the same, your infrastructure will be deployed, but the way you work will change dramatically. Imperative scripting is more familiar to developers and general programming. You basically "code" how you want your infrastructure to look like. This will be more familiar to DevOps that come from a Development background.

Declarative scripting is a different approach where you basically tell your "automation engine" how you want your infrastructure to be in the end and, through modules, the engine is smart enough to create the infrastructure. This requires some getting used to but can provide a faster build time (you have to code less edge cases, the engine has them dealt with).

If you want to deploy without committing to a platform (i.e. cloud-agnostic), you'll need a tool that allows gives you a DSL (Domain Specific Language) that supports that strategy.

Regarding the Ops / DevOps, there are some considerations to take into account. If the team is more than one person, the need for "state" to be kept is a must. This allows anyone working on top of the infrastructure, to be able to code by seeing the same infrastructure and state. Some tools are stateless in nature, so you'll have to take into account the "fact-gathering" stage or you'll have to rely on the tool to be smart enough to detect the change-set needed.

With large teams there's also a need to establish some sort of code review process, similar to regular software Development.

### Application

Applications should be built from the ground-up to be deployed through either scripts or pipelines. This will allow the deployment procedure to be store "as code", allowing for a better understanding of what needs to be done to deploy an application. This also allows for an automated deployment of the app, without requiring human intervention.

This means that concepts like pipelines as code, dependency versioning and repeatable builds, through the use of virtual environments or sandboxes (i.e. containers), should be used as much as possible.

The build and deployment process should be as transparent as possible to the developer and should happen on commit to the master branch (or trunk). Depending on the needs, separate environments/builds could be triggered by deploying to feature branches, allowing the developers to test their features without causing issues in the master branch. For Regression/QA onwards, the only branch acceptable is the master branch.

In an ideal world, with test coverage close to 100%, the deployment pipeline should advance automatically through the various stages. It could go as follows:

1) Commit is done to the *master* branch.
2) Solution is built and unit tests run on the build artifact.
3) The artifact goes through a static code analyzer, to check for bugs, vulnerabilities or code smells.
4) If it passes everything, it's deployed to the first environment, where regression or ui tests will run.
5) If it passes the tests, it's deployed to the next environment where, hopefully, it will run more integration tests and load tests.
6) If it passes the tests, it can safely be deployed to production.

There are several deployment strategies to choose: rolling-upgrade, canary deployment, blue-green, etc. But the main thing to keep in mind is, it should happen without downtime (or with as less disruption as possible). This could be tricky in an environment that's very reliant of Databases (but that's a topic for another time).

## Tooling

Depending on what you choose for your strategy, on the know-how of the teams, and how deep your pockets are, there are several choices to make.

There are some types of tools you want to have in your tool-belt:

* Infrastructure automation - These are the tools you'll use to deploy your infrastructure. Nothing **should** be done on the infrastructure outside of the scripts. These way you can always deploy the infrastructure and it self-documents.

* Configuration managers - These tools help you automate the configuration of resources after they are deployed by the Infrastructure automation. It should be used if your workloads depend on virtual machines.

* Image builders - If you use Virtual machines, these are a must-have if you want to have immutable servers. Every build artifact will generate a new VM image that will be deployed in a new virtual machine. That virtual machine will replace one of the "old ones" following a strategy like the ones described before (canary, blue-green, etc.).

* Container cluster managers - These tools help you manage the container sprawl. It specially handy if they support self-healing. Only required if your workloads run on containers.

* CI\CD engines - Used to help the deployment of both code and/or infrastructure. They are the glue that keep all the other tools working together.

For this challenge, the tools used were:

* Terraform - used for Infrastructure deployment. Provides a declarative framework, that handles all the conflicts and deployment strategy for you. It provides a base DSL, HCL, that will allow you to target any cloud provider, provided you use the right plugins. If you need some specific behavior, it can be extended by creating your own [plugins](https://www.terraform.io/docs/extend/index.html). It also helps that Terraform as a growing community behind it.

* Kubernetes - used as a target for your deployments. Kubernetes is a container cluster management tool. It can be very complex to set it up and manage it, so it should only be used if you have intention of actually making the commitment to learn and use it. In this challenge I used AKS, which is the Azure managed Kubernetes.

* Azure DevOps - CI\CD Engine managed by Microsoft. It's still not as powerful or modular as Jenkins but it's more modern in it's design and growing rapidly. Given that Microsoft is backing it a lot, it should grow to become one of the market leaders.

### Deployment

The deployment should be automated or close to it. Code reviews should be standard practice and, once the code is merged to master, the pipeline will trigger and will deploy the changes to the infrastructure. If you use a tool that can calculate the changes needed (declarative languages), it will display either the delta of changes needed or the changes required to reach the new state.

The tools that could be used here are:

* Infrastructure managers like Terraform, CloudFormation (AWS) or Azure Templates
* Configuration managers like Ansible, Chef, Salt or Puppet
* Image builders like Packer
* Container cluster managers like Kubernetes, Docker Swarm, Rancher or OpenShift
* CI\CD engines like Azure DevOps, GitLab, Jenkins or GoCD

Whatever "holes" are there in your deployment plans, they should be plugged with a scripting in a Operating System agnostic language like Python. This will allow you to quickly port it to any OS or any CI\CD tool, without having to redevelop everything.

### Maintenance

If you use immutable servers, the maintenance part shouldn't differ from usual infrastructure creation, i.e. you will still have to write code, commit it and review the changes before being merged. It means no one will fix the problem directly on the host but instead write code to make the change.

If you don't use immutable servers, tools like configuration managers are very powerful here, since they can run several tasks / playbooks on a inventory of instances, making changes at scale. This could be orchestrated by tools like Chef Automate, Ansible Tower or Saltstack.

One issue that you must take into account is drift monitoring. This is when your infrastructure diverges from the behavior you are expecting it to have. There are tools that detect infrastructure drift and remediate it, using Configuration managers to do the heavy-lifting.

### Monitoring & Alarms

This will depend on your workloads. Some monitoring tools are better suited for dynamic workloads, like containers. An example of that is Prometheus, that allows you to develop your own monitors, to extract metrics from your containers.

Traditional tools like SolarWinds, Zabix or Nagios provide you with monitoring solutions for more traditicional workloads like virtual machines.

As for alarms, most of this tools are capable of sending alarms through email, REST APIs (Slack, Teams, etc.) or SMS. Some of these can also integrate with tools like PagerDuty. There's also Azure ApplicationInsights that can serve as a log analyzer and as a probing engine, in order to monitor your applications.
