Kreirao sam DNS record prema uputama:

 ![image](https://user-images.githubusercontent.com/123903166/234608188-851b7fb8-6b98-4b6c-a8ff-414b04aa0813.png)
 
 Koristio sam komandu:
 ```
 aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"hamza-kovac.awsbosnia.com","Type":"A","TTL":60,"ResourceRecords":[{"Value":"52.59.202.158"}]}}]}'  
 ```
 Name i Value ispisao sam uz pomoc komande:
 
 ![image](https://user-images.githubusercontent.com/123903166/234608639-9a5dd3eb-b4d4-4108-84d1-f43c9c23577b.png)
```
aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "hamza-kovac.awsbosnia.com.") | {Name,Value}'
```

Instalirao sam Lets Encript alat i kreirao certifikat:
```
$sudo dnf install python3 augeas-libs
$ sudo python3 -m venv /opt/certbot/
$ sudo /opt/certbot/bin/pip install --upgrade pip
$ sudo /opt/certbot/bin/pip install certbot certbot-nginx
$ sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
$ sudo certbot certonly --nginx
```

Konfigurisam sam nginx.conf file:

```
[root@ip-172-31-32-210 ~]# more /etc/nginx/conf.d/node-app.conf
server {
  listen 80;
  server_name hamza-kovac.awsbosnia.com;
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl;
  server_name hamza-kovac.awsbosnia.com;

  ssl_certificate /etc/letsencrypt/live/hamza-kovac.awsbosnia.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/hamza-kovac.awsbosnia.com/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:8008;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
```

Provjerio sam certifikat 
![image](https://user-images.githubusercontent.com/123903166/234609547-037e0f8f-9a68-48ba-af98-9354b7ff0e6c.png)

Autorenuewall certifikata sam omogućio prema preporukama kreirajući skriptu:
```
SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
```

Provjerio sam datum isteka certifikata:
```
openssl s_client -showcerts -connect hamza-kovac.awsbosnia.com:443
```
![image](https://user-images.githubusercontent.com/123903166/234610797-519f7f0e-9b25-4956-83c9-98c2fcfb5418.png)

Importovao sam certifikat na AWS Cert Manager

![image](https://user-images.githubusercontent.com/123903166/234610943-fa5fce18-377d-4f97-b61d-708dc28c9973.png)

Validirao sam kroz browser:

![image](https://user-images.githubusercontent.com/123903166/234611117-12f9070d-b1aa-47b6-ac67-d77fce35fcaa.png)

Provjerio sam datum njegovog isteka:

![image](https://user-images.githubusercontent.com/123903166/234611367-76557cf5-76c7-435c-be2b-01e14f215f7b.png)

Kreirao sam novi certifikat kroz ACM:

![image](https://user-images.githubusercontent.com/123903166/234611872-213ee0da-2ac2-4b0e-ad09-1e25b8a2c022.png)

Validirao sam certifikat kroz browser:

![image](https://user-images.githubusercontent.com/123903166/234612053-b2a6c49f-d633-466e-bf37-5411ce231c49.png)


