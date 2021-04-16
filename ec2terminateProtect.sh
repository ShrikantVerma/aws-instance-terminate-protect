#!/bin/bash

INSTANCE_ID=`wget -q -O - http://instance-data/latest/meta-data/instance-id`
echo $INSTANCE_ID
PUBLIC_IP=`curl http://checkip.amazonaws.com`
echo $PUBLIC_IP
FILE_NAME_TEMP="$PUBLIC_IP-$INSTANCE_ID.log"
echo $FILE_NAME_TEMP
aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name 'scaling_froup_name' --protected-from-scale-in
#aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name 'scaling_froup_name' --protected-from-scale-in
while :
  do
    a=`ps -ef | grep -v grep | grep python | wc -l`
    b="0"
    echo $b >> $FILE_NAME_TEMP
    echo $a >> $FILE_NAME_TEMP
    echo "In External While" >> $FILE_NAME_TEMP
    now=$(date +"%T")
    sleep 3m
    echo "Current time : $now" >> $FILE_NAME_TEMP
    if [[ $a == $b ]];then
      echo "Inside First a ==b before sleep python" >> $FILE_NAME_TEMP
      now=$(date +"%T")
      echo "Current time : $now" >> $FILE_NAME_TEMP
      sleep 3m
      echo "Inside First a ==b after sleep python" >> $FILE_NAME_TEMP
      now=$(date +"%T")
      echo "Current time : $now" >> $FILE_NAME_TEMP
      a=`ps -ef | grep -v grep | grep python | wc -l`
      b="0"
      echo $b >> $FILE_NAME_TEMP
      echo $a >> $FILE_NAME_TEMP

      if [[ $a == $b ]];then
        echo "Inside Second a ==b after sleep python" >> $FILE_NAME_TEMP
        now=$(date +"%T")
        echo "Current time : $now" >> $FILE_NAME_TEMP
        echo "$NOW no pyhon files are running removing scaleIn protction from instance $INSTANCE_ID" >> $FILE_NAME_TEMP
        break
      fi
    fi
done
echo "Going to Kill delayed jobs gracefully" >> $FILE_NAME_TEMP
now=$(date +"%T")
echo "Current time : $now" >> $FILE_NAME_TEMP
ps -ef | grep -v grep |grep delayed |awk '{print $2}' |xargs kill -15
echo "Killed delayed jobs gracefully" >> $FILE_NAME_TEMP
now=$(date +"%T")
echo "Current time : $now" >> $FILE_NAME_TEMP
while :
  do
    a=`ps -ef | grep -v grep | grep delayed | wc -l`
    b="0"
    echo $b >> $FILE_NAME_TEMP
    echo $a >> $FILE_NAME_TEMP
    echo "In External While delayed job check" >> $FILE_NAME_TEMP
    now=$(date +"%T")
    echo "Current time : $now" >> $FILE_NAME_TEMP
    if [[ $a == $b ]];then
      echo "Inside First a ==b before sleep delayed" >> $FILE_NAME_TEMP
      now=$(date +"%T")
      echo "Current time : $now" >> $FILE_NAME_TEMP
      sleep 2m
       echo "Inside First a ==b after sleep delayed" >> $FILE_NAME_TEMP
       now=$(date +"%T")
      echo "Current time : $now" >> $FILE_NAME_TEMP
      a=`ps -ef | grep -v grep | grep delayed | wc -l`
      b="0"
      echo $b >> $FILE_NAME_TEMP
      echo $a >> $FILE_NAME_TEMP
      if [[ $a == $b ]];then
        echo "Inside Second a ==b after sleep delayed" >> $FILE_NAME_TEMP
        echo "$NOW no delayed jobs are running removing scaleIn protction from instance $INSTANCE_ID" >> $FILE_NAME_TEMP
        now=$(date +"%T")
        echo "Current time : $now" >> $FILE_NAME_TEMP
        break
      fi
    fi
done
echo "Removing protection" >> $FILE_NAME_TEMP
now=$(date +"%T")
echo "Current time : $now" >> $FILE_NAME_TEMP

scp $FILE_NAME_TEMP deploy@1.1.1.1:/home/deploy/scaled_machine_logs/

aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name 'scaling_froup_name' --no-protected-from-scale-in
#aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name 'scaling_froup_name' --no-protected-from-scale-in


sleep 5
echo "Removed protection" >> $FILE_NAME_TEMP
now=$(date +"%T")
echo "Current time : $now" >> $FILE_NAME_TEMP
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "script is completed" >> /home/deploy/scriptstatus.txt
now=$(date +"%T")
echo "Current time : $now" >> $FILE_NAME_TEMP
