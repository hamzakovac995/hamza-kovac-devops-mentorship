# SERVERLESS AND APPLICATION SERVICES

##  [ASSOCIATESHARED] Architecture Deep Dive - PART1

Event-Driven Architecture - Decoupled systems that run in response to events. An event-driven architecture uses events to trigger and communicate between decoupled services and is common in modern applications built with microservices.

Monolithic Architecture - A monolithic architecture is a traditional model of a software program, which is built as a unified unit that is self-contained and independent from other applications. The word “monolith” is often attributed to something large and glacial, which isn't far from the truth of a monolith architecture for software design.

## [ASSOCIATESHARED] Architecture Deep Dive - PART2

With event-driven architecture:

-Everything happens as soon as possible and nothing is waiting on anything else.

-You don’t have to consider what’s happening downstream, so you can add service instances to scale.

-Topic routing and filtering can divide up services quickly and easily – as in command query responsibility segregation.

-To add another service, you can just have it subscribe to an event and have it generate new events of its own – there’s no impact on existing services.

##  [SHAREDALL] AWS Lambda - PART1, [SHAREDALL] AWS Lambda - PART2, [SHAREDALL] AWS Lambda - PART3

AWS Lambda is a serverless computing service provided by Amazon Web Services (AWS). It allows you to run your code without provisioning or managing servers. With AWS Lambda, you can build applications using functions as the fundamental building blocks, where each function represents a small piece of code that performs a specific task.

When using Lambda, you upload your code, and AWS takes care of the underlying infrastructure, automatically scaling and managing the resources needed to run your functions. You only pay for the compute time consumed by your code, without any upfront costs or ongoing maintenance fees.

## [ASSOCIATESHARED] CloudWatchEvents and EventBridge

CloudWatch Events and EventBridge are both event-driven services provided by AWS that help you route and process events in your applications and systems. While they serve similar purposes, there are some differences between them.

AWS CloudWatch Events:
AWS CloudWatch Events is a service that delivers a stream of system events that describe changes or activities in your AWS resources. It provides near-real-time monitoring of events and allows you to respond to these events with automated actions. CloudWatch Events acts as a central event bus for your AWS environment.
Key features of CloudWatch Events include:

Event Sources: CloudWatch Events can receive events from various AWS services, such as AWS Lambda, Amazon S3, Amazon EC2, AWS Step Functions, and more. These events can be triggered by resource state changes, scheduled events, or custom events.

Event Patterns: You can define rules to match specific events using event patterns. These patterns can filter events based on attributes like resource type, tags, or custom JSON fields.

Targets and Actions: Once an event matches a rule, you can specify targets or actions to be performed in response to the event. Examples of targets include invoking a Lambda function, starting an ECS task, or sending a notification to an SNS topic.

AWS EventBridge:
AWS EventBridge is an event bus service that integrates events from various sources and routes them to targets for processing. It provides a serverless event bus that connects different services within AWS and also supports events from Software-as-a-Service (SaaS) applications.
Key features of EventBridge include:

Event Sources: EventBridge can receive events from AWS services as well as third-party SaaS applications integrated with EventBridge. AWS services such as AWS CloudTrail, AWS IoT, and AWS CodePipeline can emit events to EventBridge.

Event Patterns: You can create event rules with filtering patterns to match specific events. EventBridge supports fine-grained filtering based on event attributes and content.

Targets and Actions: When an event matches a rule, you can specify targets or actions to be performed. EventBridge supports a wide range of targets, including invoking AWS Lambda functions, running AWS Step Functions state machines, sending messages to Amazon SNS topics, and more.

In summary, CloudWatch Events focuses on monitoring events within your AWS environment, while EventBridge provides a broader event integration platform that allows you to connect both AWS and third-party events and route them to various targets for further processing.

## [ASSOCIATESHARED] [DEMO] Automated EC2 Control using Lambda and Events - PART1, [ASSOCIATESHARED] [DEMO] Automated EC2 Control using Lambda and Events - PART2

Stop instanes
 ```
 import boto3
import os
import json

region = 'eu-central-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    instances=os.environ['EC2_INSTANCES'].split(",")
    ec2.stop_instances(InstanceIds=instances)
    print('stopped instances: ' + str(instances))
 ```
 ```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Start*",
                "ec2:Stop*"
            ],
            "Resource": "*"
        }
    ]
}
 ```
![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/12854f4c-b6c1-4e0a-8aa2-a2ca9d048917)

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/456ddccd-4282-4d21-a9b9-45758ce7df1a)

Start instanes
```
import boto3
import os
import json

region = 'eu-central-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    instances=os.environ['EC2_INSTANCES'].split(",")
    ec2.start_instances(InstanceIds=instances)
    print('started instances: ' + str(instances))
```

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/2b43904b-e0f9-4782-bcac-83da243b8d0a)

Protect instanes

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/fc39dda4-33fe-44f3-aca3-ff6da91720c7)

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/ba3fb152-0934-4984-b41f-c1495b48d63e)

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/1d40854e-4422-4b81-a78a-3e33c62ddbba)

Event Pattern:
```
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopped"],
    "instance-id": ["i-030660ac136f35816"]
  }
}
```

Protect instances code:
```
import boto3
import os
import json

region = 'eu-central-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    instances=[ event['detail']['instance-id'] ]
    ec2.start_instances(InstanceIds=instances)
    print ('Protected instance stopped - starting up instance: '+str(instances))
```

Scheduled StopByLambda

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/02510fb1-d93c-4067-976f-3fc34650a442)

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/4dcc5cdd-f89e-40ef-ad7f-809ada25d71f)

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/39ebaa73-6226-461b-aa50-5c8db8d1846a)


## Serverless Architecture

Serverless architecture in AWS refers to a cloud computing model where you can build and run applications without the need to provision, manage, or scale servers. It allows you to focus on writing code and developing applications while abstracting away the underlying infrastructure concerns.

In a serverless architecture, the responsibility for managing servers, operating systems, and infrastructure components shifts to the cloud service provider, in this case, AWS. AWS takes care of provisioning and managing the servers, scaling resources as needed, and ensuring high availability and fault tolerance.

## [ASSOCIATESHARED] Simple Notification Service

Simple Notification Service (SNS) is a fully managed messaging service provided by Amazon Web Services (AWS). It enables you to send notifications and messages to a variety of endpoints, including email, SMS text messages, mobile push notifications, and more. SNS follows a publish-subscribe messaging pattern, where messages are published to topics, and subscribers receive the messages from those topics.

## [ASSOCIATESHARED] Step Functions

AWS Step Functions is a serverless workflow orchestration service provided by Amazon Web Services (AWS). It allows you to build and coordinate state machines that automate the execution of complex workflows and business processes. With Step Functions, you can visually define and organize the different steps and decision points of your workflow, making it easier to manage and monitor the overall execution.

## [SHAREDALL] API Gateway 101

AWS API Gateway is a fully managed service provided by Amazon Web Services (AWS) that allows you to create, deploy, and manage APIs for your applications. It acts as a front-end or entry point for your backend services, enabling you to expose your APIs securely to clients such as web applications, mobile apps, or other services.

##  [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART1

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/520866c5-ac34-4505-8685-f06f946ea9f1)

## [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART2

Code:
```
import boto3, os, json

FROM_EMAIL_ADDRESS = 'hamza.kovac995+test1@gmail.com'

ses = boto3.client('ses')

def lambda_handler(event, context):
    # Print event data to logs .. 
    print("Received event: " + json.dumps(event))
    # Publish message directly to email, provided by EmailOnly or EmailPar TASK
    ses.send_email( Source=FROM_EMAIL_ADDRESS,
        Destination={ 'ToAddresses': [ event['Input']['email'] ] }, 
        Message={ 'Subject': {'Data': 'Whiskers Commands You to attend!'},
            'Body': {'Text': {'Data': event['Input']['message']}}
        }
    )
    return 'Success!'
```

## [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART3

Code:
```
{
  "Comment": "Pet Cuddle-o-Tron - using Lambda for email.",
  "StartAt": "Timer",
  "States": {
    "Timer": {
      "Type": "Wait",
      "SecondsPath": "$.waitSeconds",
      "Next": "Email"
    },
    "Email": {
      "Type" : "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "EMAIL_LAMBDA_ARN",
        "Payload": {
          "Input.$": "$"
        }
      },
      "Next": "NextState"
    },
    "NextState": {
      "Type": "Pass",
      "End": true
    }
  }
}
```

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/8b20bbb4-1f34-450e-9d90-a221b7692ee0)

## [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART4

![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/d4ec13ac-d9a2-449c-b906-f896e5f78bec)

## [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART5

Bucket permission:
```
{
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"PublicRead",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::hamza-kovac-client-app/*"]
      }
    ]
  }
```


![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/8497446a-6b73-4e8c-a6c7-e4b4653d13de)


![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/371aed5b-16a8-40f1-bcbc-ce2d7ebeeb16)


![image](https://github.com/hamzakovac995/hamza-kovac-devops-mentorship/assets/123903166/a7eae9dc-47d8-4a6c-a03d-45696fcb742c)


## [ASSOCIATESHARED] [AdvancedDemo] Build A Serverless App - Pet-Cuddle-o-Tron - PART6


## [ASSOCIATESHARED] Simple Queue Service

Simple Queue Service (SQS) is a fully managed message queuing service provided by Amazon Web Services (AWS). It enables you to decouple the components of your application by allowing them to communicate asynchronously through the exchange of messages. SQS offers reliable and scalable message queuing with high throughput and low latency.

## SQS Standard vs FIFO Queues

Amazon Simple Queue Service (SQS) provides two types of queues: Standard queues and FIFO (First-In-First-Out) queues. Here's a comparison between the two:

Ordering:

Standard Queues: Messages in Standard queues are generally delivered in a best-effort, "at-least-once" order. This means that the order of message delivery is not strictly guaranteed. However, in practice, the majority of messages are delivered in the order they were sent.

FIFO Queues: FIFO queues guarantee strict ordering of messages. Messages sent to a FIFO queue are always delivered in the exact order in which they were sent. This ensures that the messages are processed in a First-In-First-Out manner.


Deduplication:

Standard Queues: Standard queues do not automatically deduplicate messages. It's possible to receive duplicate messages when using Standard queues, so message deduplication needs to be handled by the consumer of the queue if required.

FIFO Queues: FIFO queues automatically deduplicate messages based on the Message Deduplication ID provided by the producer. If a message with the same deduplication ID is sent multiple times within a specific time frame, only the first message is delivered, and subsequent duplicate messages are discarded.

Grouping:

Standard Queues: Standard queues don't have the concept of message grouping. Messages are processed independently of each other.

FIFO Queues: FIFO queues support message grouping. Messages can be grouped based on a specified message group ID, ensuring that the messages with the same group ID are always processed one by one in a strict order.

Throughput:

Standard Queues: Standard queues offer a higher throughput compared to FIFO queues. They can handle a potentially higher volume of messages per second.

FIFO Queues: FIFO queues have a lower maximum throughput compared to Standard queues. They are designed for applications that require strict ordering and don't have a high message throughput requirement.

Exactly-once Processing:

Standard Queues: Standard queues provide "at-least-once" delivery semantics, meaning that a message can be delivered multiple times but not exactly once. The consumer needs to handle potential duplicate messages and idempotent processing.

FIFO Queues: FIFO queues provide exactly-once processing semantics. Messages are delivered exactly once and in the order they were sent, ensuring that each message is processed only once.

When choosing between Standard and FIFO queues, consider the requirements of your application. If strict ordering and deduplication are crucial, and your application can handle the lower throughput, FIFO queues are a better fit. On the other hand, if ordering is not a strict requirement and higher throughput is desired, Standard queues can be used.

## SQS Delay Queues
Amazon Simple Queue Service (SQS) Delay Queues allow you to introduce a delay in the delivery of messages to a queue. When you send a message to a Delay Queue, the message remains in the queue but is not immediately available for processing by the consumers.
