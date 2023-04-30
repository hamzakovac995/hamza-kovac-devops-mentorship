S3 bucket policy screenshot ( voditi računa da su minimalne permisije postavljene)

![image](https://user-images.githubusercontent.com/123903166/235211279-a38be0f5-0dba-4d86-8426-9cb12f358d86.png)

 ```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::Bucket-Name/*"
            ]
        }
    ]
}
 ```
 .html i error.html file, DevOps image
 
 ![image](https://user-images.githubusercontent.com/123903166/235211139-85367deb-8b87-47ad-a7d8-bbdad928cc50.png)
 
 Screenshot - S3 website endpointa
 
 ```
 http://hamza-kovac-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com/
 ```
 
 ![image](https://user-images.githubusercontent.com/123903166/235211816-e3d6e98b-ebf9-4729-8089-bc9262c86cd1.png)


Screenshot - distribution endpointa

 ```
 https://d3h8c0xkfimaen.cloudfront.net/
 ```
 
 ![image](https://user-images.githubusercontent.com/123903166/235212016-0e822bb5-1510-4f05-ab58-bbac10035204.png)


Screenshot - R53 recorda koji je uspješno izvršio load distribucije

```
aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"_22f201ae4ad467df2b1414782f819413.www.hamza-kovac.awsbosnia.com.","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"_3563d20e365f29301a5a426f34748165.tctzzymbbs.acm-validations.aws."}]}}]}'
```
![image](https://user-images.githubusercontent.com/123903166/235212730-b698c56f-57e3-4cad-a2cc-d3049230e8ea.png)


 Screenshot konfigurisanoga R53 recorda prema distribuciji
```
change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"www.hamza-kovac.awsbosnia.com","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"d1ka7sqtglji0u.cloudfront.net"}]}}]}' ```
```

![image](https://user-images.githubusercontent.com/123903166/235212773-8d3fa4dd-84fe-44fd-85cd-e1c959d9d40f.png)
