#!/bin/bash 
declare -i duration=10 
declare hasUrl="" 
declare endpoint 
declare -i status200count=0 
endpoint="https://pytestapp20.azurewebsites.net" 



healthcheck() { 
  declare url=$1 
  result=$(curl -i $url 2>/dev/null | grep HTTP/2) 
  echo $result 
}

for i in {1..12} 

do 
  result=`healthcheck $endpoint`
  echo "---> $result" 
  declare status 

  if [[ -z $result ]]; then 
    status="N/A" 
    echo "Site not found" 
  else 
    status=${result:7:3} 
    timestamp=$(date "+%Y%m%d-%H%M%S") 
    if [[ -z $hasUrl ]]; then 
      echo "$timestamp | $status " 
    else 
      echo "$timestamp | $status | $endpoint " 
    fi 
    
    if [ $status -eq 200 ]; then 
      ((status200count=status200count + 1)) 
       if [ $status200count -gt 5 ]; then 
        break 
       fi
    fi 
    sleep $duration 
  fi 
 done 
  
if  [ $status200count -gt 5 ]; then 
 echo "API UP" # APISTATUS is a pipeline variable 
 APISTATUS="Up" 
else 
 echo "API DOWN" 
 APISTATUS="Down" 
# exit 1; 
fi
