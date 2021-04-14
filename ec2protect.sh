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
