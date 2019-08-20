#!/bin/bash

BASE="https://github.com/GetMyParking/"
BRANCH="LocalSetUpTest"
mkdir LocalTest
cp ./docker-compose.yaml ./LocalTest
cd LocalTest

declare -a arr=("authorizations" "parking-session" "parking" "authentication" "tariff-engine" "offer-engine" "pass" "consumer-users" "dashboard" "payments")
echo "1. Authorizations \n2. Parking Session \n3. Parking \n4. Authentication \n5. Tariff Engine \n6. Offer Engine \n7. Pass \n8. Consumer Users \n9. Dashboard \n10. Payments"

for service in "${arr[@]}"
do 
    mkdir $service
done
echo "Enter comma seperated values to skip"
read -p "Enter Microservice to skip: "  skipIndex

#Calculate and skip the services not required
OIFS=$IFS;
IFS=",";
skipServiceIds=($skipIndex);

function contains() {
    local a=$1
    local value="$2"   # Save first argument in a variable
    shift 
    for k in ${a[@]};
    do
        if [ $k == $value ]; then
            return 1
        fi
    done
    return 0
}

function skip_build_deploy() {
    declare -a skipService
    declare -a selectedServices
    
    #Find Services from Index
    for service in "${skipServiceIds[@]}"
    do 
        j=`expr $service - 1`;
        skipService+=(${arr[$j]})
    done
    
    #Skip And Build
    for i in "${arr[@]}"
    do
        contains "${skipService[*]}" $i;
        local result=$?
        if [ $result == 1 ];
        then
            echo "Skipping $i"
            continue
        fi

    if [ -d $i/.git ]; 
      then 
          pushd $i; git pull origin $BRANCH; popd; > /dev/null 2>&1
          echo $i " : Pulling Latest"
    else 
        git clone --single-branch --branch $BRANCH $BASE$i.git; > /dev/null 2>&1
        echo $i " : Getting Latest"
    fi

    cd $i
    echo "################### $i : Build Creation in progress ######################"
    sh ./local.sh > /dev/null 2>&1
    cd ..
    selectedServices+=($i)
    done

    echo "####################### Creating Docker Images  ##########################"
    echo "${selectedServices[*]}"
    docker-compose build ${selectedServices[*]} > /dev/null 2>&1
    echo "#################### Creating Docker Containers #########################"
    docker-compose up ${selectedServices[*]}
    echo "Thanks for using the Local Deploy Tool"
}

skip_build_deploy




