elk-cookbooks
=============

A set of cookbooks to run an ELK (Elasticsearch Logstash Kibana) stack with OpsWorks.

Instructions
------------

Before creating the stack we will need to create several resources that you cannot create within OpsWorks:
- An IAM profile for elasticsearch ec2 discovery
- An ELB (Elastic Load Balancer) for elasticsearch
- An ELB for logstash

### IAM profile for elasticsearch discovery

Go to `IAM > Roles`, and create a new role named `elasticsearch-aws-plugin`.
Choose `Amazon EC2` as the service role.
Then choose `Custom Policy`, and use the following `Policy Document` (the name does not matter):

```
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "EC2:Describe*",
            "Resource": "*"
        }
    ]
}
```

### ELBs

Note: I will not go over the security groups details because it can be different based on whether you use a VPC or not.
Just be aware that by default a non internal ELB will expose your elasticsearch/logstash to the world.

Go to `EC2 > Network & Security > Load Balancers` (Make sure you have selected the right region, right of the top
toolbar).

Create an ELB named `opsworks-elk-elasticsearch` with the following `Listener Configuration`:

| Load Balancer Protocol | Load Balancer Port | Instance Protocol | Instance Port |
|------------------------|--------------------|-------------------|---------------|
| HTTP                   | 9200               | HTTP              | 9200          |
| TCP                    | 9300               | TCP               |               |

Then configure use the following configuration for the health check:

| Setting       | Value            |
|---------------|------------------|
| Ping Protocol | HTTP             |
| Ping Port     | 9200             |
| Ping Path     | /_cluster/health |

Finish the creation without adding any instance.

Repeat the process for the Logstash ELB with TCP port 514 for syslog, or more if you need more inputs.

### Stack

Create a stack with the following settings:
- Chef `11.10`
- `Use custom Chef cookbooks` checked with the git repository referenced
- `Manage Berkshelf` checked

Use the following `Custom JSON`:

```json
{
    "logstash": {
        "instance": {
            "server": {
                "inputs": [
                    {
                        "syslog": {}
                    }
                ]
            }
        }
    }
}
```

### Layers

#### Elasticsearch

```json
{
    "type": "custom",
    "name": "Elasticsearch",
    "short name": "elasticsearch",
    "recipes": {
        "setup": ["opsworks_elasticsearch"]
    },
    "ebs-volumes": [
        {
            "mount-point": "/usr/local/var/data/elasticsearch"
        }
    ],
    "layer-profile": "elasticsearch-aws-plugin"
}
```

#### Kibana

```json
{
    "type": "custom",
    "name": "Kibana",
    "short name": "kibana",
    "recipes": {
        "setup": ["opsworks_kibana"]
    }
}
```

#### Logstash

```json
{
    "type": "custom",
    "name": "Logstash",
    "short name": "logstash",
    "recipes": {
        "setup": ["opsworks_logstash"]
    }
}
```
