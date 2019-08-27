# LocalTestSetUp

Step 1 : Pull the Latest LocalTestSetUp Repo.

Step 2 : Make sure docker/mysql is running in background and matching the below configuration.
    
   DB Configuration
   =================
        host : localhost
        port : 3306
        user : test
        password : [no password]
        database : get_my_parking
   
   Create User and Assign priviliges [Ignore if already done]
   ==========================================================
        CREATE USER 'test'@'localhost' IDENTIFIED BY '';
        GRANT ALL PRIVILEGES ON *.* TO 'test'@'localhost';
        FLUSH PRIVILEGES;

Step 3 : sh ./localRun.sh

    1. Authorizations 
    2. Parking Session 
    3. Parking 
    4. Authentication 
    5. Tariff Engine 
    6. Offer Engine 
    7. Pass 
    8. Consumer Users 
    9. Dashboard 
    10. Payments
    Enter comma seperated values to skip
    Enter Microservice to skip: 2,3,5,10
    
Step 4 : Wait for a while. The services will start in background.

Step 5 : Proceed with your local testing.

Step 6 : Closing the service.
  
    cd LocalTest
    docker-compose down
    ./remove-prev-images.sh
