#!/bin/bash

INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id`" && \
echo $INSTANCE_ID
aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "vs-testing-autoscaling" --protected-from-scale-in
while :
do
  a=`ps -ef | grep -v grep | grep python | wc -l`
  #a=`ps -ef | grep -v grep | grep top | wc -l`
  b="0"
  echo $b
  echo $a
  if [[ $a == $b ]];then
        sleep 5m
        a=`ps -ef | grep -v grep | grep python | wc -l`
        #a=`ps -ef | grep -v grep | grep top | wc -l`
        b="0"
        echo $b
        echo $a

        if [[ $a == $b ]];
        then
        echo "$NOW no pyhon files are running removing scaleIn protction from instance $INSTANCE_ID"
        break
fi
#  sleep 1
fi
done
#sleep 16
ps -ef | grep -v grep |grep delayed |awk '{print $2}' |xargs kill
aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "vs-testing-autoscaling" --no-protected-from-scale-in

sleep 1m

aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "script is completed" >> /home/deploy/scriptstatus.txt



######################

# Loop through all EC2 instances and enable termination protection
##for I in $(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text); do aws ec2 modify-instance-attribute --disable-api-termination --instance-id $I; done
for I in $(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text); do aws ec2 describe-instance-attribute --instance-id $I --attribute disableApiTermination ; done > new1.txt

# Loop through all EC2 instances and disable termination protection
##for I in $(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text); do aws ec2 modify-instance-attribute --no-disable-api-termination --instance-id $I;done


#aws iam list-users | grep -i '"UserName":' | awk '{print $2}'| cut -d '"' -f2
#aws ec2 describe-images --owners $user --output json | jq '.Images[]' | grep -i '"Name":' | wc -l

for I in $(aws iam list-users | grep -i '"UserName":' | awk '{print $2}'| cut -d '"' -f2 ); do aws ec2 describe-images --owners $user --output json | jq '.Images[]' | grep -i '"Name":' | wc -l; done > new1.txt
