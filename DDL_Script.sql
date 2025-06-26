create schema water_supplay;

set search_path to water_supplay;

CREATE TABLE Pin_Code (
 Pin_Code VARCHAR(10) PRIMARY KEY,
 City VARCHAR(50), 
 Area VARCHAR(50),
 District VARCHAR(50),
 State VARCHAR(50)
);

CREATE TABLE Municipal_Corporation (
 Corporation_ID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL,
 Contact_Info VARCHAR(100),
 Pin_Code VARCHAR(10) NOT NULL,
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code)
);

CREATE TABLE Water_Source (
 Water_Source_ID INT PRIMARY KEY,
 Type VARCHAR(50),
 Status VARCHAR(20),
 W_Capacity INT,
 Corporation_ID INT NOT NULL,
 Pin_Code VARCHAR(10) NOT NULL,
 FOREIGN KEY (Corporation_ID) REFERENCES Municipal_Corporation(Corporation_ID),
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code)
);

CREATE TABLE Customer_Type (
 Customer_Type_ID INT PRIMARY KEY,
 Type_Name VARCHAR(50) NOT NULL,
 Description TEXT
);

CREATE TABLE Customer (
 Customer_ID INT PRIMARY KEY,
 Customer_Name VARCHAR(100) NOT NULL,
 Phone_Number VARCHAR(15),
 Connection_Status VARCHAR(20),
 Customer_Type_ID INT NOT NULL,
 Billing_Cycle VARCHAR(50),
 Block_Flat_No VARCHAR(50),
 Street VARCHAR(100),
 Pin_Code VARCHAR(10) NOT NULL,
 Feedback VARCHAR(255),
 FOREIGN KEY (Customer_Type_ID) REFERENCES Customer_Type(Customer_Type_ID),
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code)
);

CREATE TABLE Water_Rate (
 Rate_ID INT PRIMARY KEY,
 Customer_Type_ID INT NOT NULL,
 Rate_Start_Date DATE,
 Rate_End_Date DATE,
 Corporation_ID INT,
 Water_Rate DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (Customer_Type_ID) REFERENCES Customer_Type(Customer_Type_ID),
 FOREIGN KEY (Corporation_ID) REFERENCES Municipal_Corporation(Corporation_ID)
);

CREATE TABLE Purification_Plant (
 Plant_ID INT PRIMARY KEY,
 Plant_Type VARCHAR(50),
 P_Capacity INT,
 Pin_Code VARCHAR(10) NOT NULL,
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code)
);

CREATE TABLE Purifies (
 Plant_ID INT NOT NULL,
 Water_Source_ID INT NOT NULL,
 Before_WQI DECIMAL(5,2),
 After_WQI DECIMAL(5,2),
 PRIMARY KEY (Plant_ID, Water_Source_ID),
 FOREIGN KEY (Plant_ID) REFERENCES Purification_Plant(Plant_ID),
 FOREIGN KEY (Water_Source_ID) REFERENCES Water_Source(Water_Source_ID)
);

CREATE TABLE Water_Reservoir (
 Reservoir_ID INT PRIMARY KEY,
 R_Capacity INT,
 Status VARCHAR(20),
 Water_Level DECIMAL(10,2),
 Pin_Code VARCHAR(10) NOT NULL,
 Plant_ID INT NOT NULL,
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code),
 FOREIGN KEY (Plant_ID) REFERENCES Purification_Plant(Plant_ID)
);

CREATE TABLE Water_Distribution_Station (
 Station_ID INT PRIMARY KEY,
 S_Capacity INT,
 Number_Of_Meters INT,
 Reservoir_ID INT NOT NULL,
 Water_Level DECIMAL(10,2),
 Pin_Code VARCHAR(10) NOT NULL,
 FOREIGN KEY (Reservoir_ID) REFERENCES Water_Reservoir(Reservoir_ID),
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code)
);

CREATE TABLE Maintainence_Team (
 Team_ID INT PRIMARY KEY,
 Team_Type VARCHAR(50)
);

CREATE TABLE Maintenance_Schedule (
 Maintenance_ID INT PRIMARY KEY,
 Maintenance_Type VARCHAR(50),
 Status VARCHAR(20),
 Date DATE,
 Start_Time TIME,
 End_Time TIME,
 Reservoir_ID INT NOT NULL,
 Team_ID INT NOT NULL,
 FOREIGN KEY (Reservoir_ID) REFERENCES Water_Reservoir(Reservoir_ID),
 FOREIGN KEY (Team_ID) REFERENCES Maintainence_Team(Team_ID)
);

CREATE TABLE Outage (
 Outage_ID INT PRIMARY KEY,
 Outage_Type VARCHAR(50),
 Status VARCHAR(20),
 Cause TEXT,
 Start_Date_Time TIMESTAMP,
 End_Date_Time TIMESTAMP,
 Maintenance_ID INT,
 FOREIGN KEY (Maintenance_ID) REFERENCES Maintenance_Schedule(Maintenance_ID)
);

CREATE TABLE Affect_Area (
 Affected_Area_ID INT PRIMARY KEY,
 Area_Type VARCHAR(50),
 Pin_Code VARCHAR(10) NOT NULL,
 Outage_ID INT NOT NULL,
 FOREIGN KEY (Pin_Code) REFERENCES Pin_Code(Pin_Code),
 FOREIGN KEY (Outage_ID) REFERENCES Outage(Outage_ID)
);

CREATE TABLE Meter (
 Meter_ID INT PRIMARY KEY,
 Customer_ID INT NOT NULL,
 Station_ID INT NOT NULL,
 Current_Reading DECIMAL(10,2),
 Status VARCHAR(20),
 Installation_Date DATE,
 Last_Reading_Date DATE,
 FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
 FOREIGN KEY (Station_ID) REFERENCES Water_Distribution_Station(Station_ID)
);

CREATE TABLE Bill (
 Bill_ID INT PRIMARY KEY,
 Rate_ID INT NOT NULL,
 Meter_ID INT NOT NULL,
 Total_Price DECIMAL(10,2),
 Billing_Date DATE,
 Payment_Status VARCHAR(20),
 FOREIGN KEY (Rate_ID) REFERENCES Water_Rate(Rate_ID),
 FOREIGN KEY (Meter_ID) REFERENCES Meter(Meter_ID)
);

CREATE TABLE Employee (
 Employee_ID INT PRIMARY KEY,
 Employee_Name VARCHAR(100),
 Role VARCHAR(50),
 Department VARCHAR(50),
 Contact_Info VARCHAR(100),
 Salary DECIMAL(10,2),
 Reservoir_ID INT,
 Team_ID INT,
 FOREIGN KEY (Reservoir_ID) REFERENCES Water_Reservoir(Reservoir_ID),
 FOREIGN KEY (Team_ID) REFERENCES Maintainence_Team(Team_ID)
);
