CREATE DATABASE car_transactions;
USE car_transactions;
SELECT * FROM countries;


#CREATING TABLES INTO car_transactions Database------------------------------------------------------------------------------------

CREATE TABLE categories(catId INT PRIMARY KEY AUTO_INCREMENT,
						category VARCHAR(30)
						);
                        
CREATE TABLE countries(countryid INT PRIMARY KEY AUTO_INCREMENT,
                        country  VARCHAR(50)
                        );
                        
CREATE TABLE cities(cityid INT PRIMARY KEY AUTO_INCREMENT,
				    countryid INT,
                    city VARCHAR(30),
                    FOREIGN KEY (countryid) REFERENCES countries(countryid)
				   );
                   
CREATE TABLE customers( custid INT PRIMARY KEY,
                        cityid INT,
                        surname VARCHAR(30),
                        name VARCHAR(30),
                        FOREIGN KEY (cityid) REFERENCES cities(cityid)
                    );
CREATE TABLE  salesmen(salesmenid INT PRIMARY KEY AUTO_INCREMENT,
					   surname VARCHAR(30),
                       name VARCHAR(30),
                       empdate DATETIME,
                       bossid INT
                     );
CREATE TABLE company( companyid INT PRIMARY KEY AUTO_INCREMENT,
					  cityid INT,
					  company VARCHAR(50),
					  FOREIGN KEY (cityid) REFERENCES cities(cityid)
					);
CREATE TABLE cars( carid INT PRIMARY KEY AUTO_INCREMENT,
                     categoryid INT,
                     companyid INT,
                     car VARCHAR(30),
                     model VARCHAR(30),
                     FOREIGN KEY (categoryid) REFERENCES categories(catId),
                     FOREIGN KEY (companyid) REFERENCES company(companyid)
                   );  
CREATE TABLE transactions_facts_table( transactionsid INT PRIMARY KEY AUTO_INCREMENT, 
									   carid INT,
									   customerid INT,
                                       salesmenid INT,
                                       salesdate DATETIME,
                                       price DOUBLE,
                                       amount DOUBLE,
                                       value  DOUBLE,
                                       FOREIGN KEY (carid) REFERENCES cars(carid),
                                       FOREIGN KEY (customerid) REFERENCES customers(custid),
                                       FOREIGN KEY (salesmenid) REFERENCES salesmen(salesmenid)
                                     );
#DATA INSERTION INTO TABLES----------------------------------------------------------------------------------------------------------

INSERT INTO categories(category) VALUES('Hatchback'),('Sedan'),('Coupe'),('Convertible'),('Wagon'),('SUV');
  
INSERT INTO countries(country) VALUES('Germany'),('USA'),('Japan'),('UK'),('South Korea'),('Italy');
  
   INSERT INTO cities(city) VALUES('Germany'),('USA'),('Japan'),('UK'),('South Korea'),('Italy'); 
  
  
  
  
  
                     
                     