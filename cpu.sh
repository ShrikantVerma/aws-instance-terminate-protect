#!/bin/bash
#load1=`uptime | awk -F "load average:" '{ print $2 }' | cut -d, -f1 | sed 's/ //g'`
#load2=1


INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id`" && \
echo $INSTANCE_ID
#aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "vs-testing-autoscaling" --protected-from-scale-in
while :
do
  load1=`uptime | awk -F "load average:" '{ print $2 }' | cut -d, -f1 | sed 's/ //g'`
  #a=`ps -ef | grep -v grep | grep top | wc -l`
  load2="1"
  echo $load1
  echo $load2
  if [[ $load1 > $load2 ]];then
        sleep 5

        else
                echo "$NOW load is less than 1 on server $INSTANCE_ID"
#        break
fi
#  sleep 15
#fi
done
#sleep 16

#ps -ef | grep -v grep |grep delayed |awk '{print $2}' |xargs kill

#aws autoscaling set-instance-protection --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "vs-testing-autoscaling" --no-protected-from-scale-in
