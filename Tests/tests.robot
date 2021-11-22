*** Settings ***
Documentation  Examples of tests for AdventureWorks2012 database
Library     DatabaseLibrary
Library     OperatingSystem
Library     String
Library     Collections

Variables   ../resources/variables.py

Resource    ../resources/common_keywords.robot

Suite Setup     Create new user

Suite Teardown  Delete user and disconnect

*** Test Cases ***

Check Person.Address.StateProvinceID Foreign Key Constraint for consistency
    [Tags]  AUTO-1.1, Person, Person.Address
    [Documentation]
    ...  | Check consistency of Foreign Key column
    ...  | Person.Address.StateProvinceID is Foreign key to Person.StateProvince.StateProvinceID
    ...  |
    ...  | * Test Steps *
    ...  | 1. Select rows from Person.Address that have 'StateProvinceID' values
    ...  | that not exist in Person.StateProvince.StateProvinceID
    ...  | 2. Count number of rows returned
    ...  |
    ...  | * Expected result *
    ...  | 1. Number of rows returned by query is 0
    Row Count Is Equal To X  SELECT AddressID FROM Person.Address WHERE NOT EXISTS (SELECT * FROM Person.StateProvince WHERE StateProvinceID = Person.Address.StateProvinceID)  0

Check for empty SpatialAddress
    [Tags]  AUTO-1.2, Person, Person.Address
    [Documentation]  Check SpatialLocation column for emtpy values
    ...  |
    ...  | * Test Steps *
    ...  | 1. Get rows from Person.Address where SpatialLocation is empty using .STIsEmpty() function
    ...  |
    ...  | * Expected results *
    ...  | 1. Number of returned rows = 0
    @{res}  Query    SELECT COUNT(*) FROM Person.Address WHERE SpatialLocation.STIsEmpty() = 1
    should be equal as integers  ${res[0][0]}  0

Checking that Production.Document table exists
    [Tags]  AUTO 2.1, Production, Production.Document
    [Documentation]  Check that table 'Production.Document' exists in the database
    ...  | * Test Steps *
    ...  | 1. Get records from INFORMATION_SCHEMA with TABLE_SCHEMA = 'Production' and TABLE_NAME = 'Document'
    ...  |
    ...  | * Expected results *
    ...  | 1. One record is returned
    Row Count Is Equal To X     SELECT * from INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Production' AND TABLE_NAME = 'Document'   1

Checking default constraint for columns 'ChangeNumber' and 'FolderFlag' in Production.Document table
    [Tags]  AUTO 2.2, Production,Production.Document
    [Documentation]  Checking that default values are inserted into  'ChangeNumber' and 'FolderFlag'
    ...  | when no other value is specified.
    ...  | The default value for  'ChangeNumber' column is 0
    ...  | The default value for 'FolderFlag' column is False
    ...  |
    ...  | * Test steps*
    ...  | 1.   Get existing BusinessEntityID from HumanResources.Employee to satisfy Foreign Key
    ...  | constraint of 'Owner' column in Production.Document table
    ...  | 2. Insert the following values in Production.Document table:
    ...  |   DocumentNode = '/4/0/', Title = 'Test',
    ...  |   Owner = BusinessEntityID FROM HumanResources.Employee (from Setup),
    ...  |   FileName = 'Test',
    ...  |   FileExtension = '.doc',
    ...  |   Revision = 0, Status = 0
    ...  | 3. Get the 'ChangeNumber' and 'FolderFlag' from inserted row.
    ...  |
    ...  | Expected results:
    ...  |   1. 'ChangeNumber' = 0
    ...  |   2. 'FolderFlag' = False
    ...  |
    ...  | Test teardown: delete row that was inserted on step 1.
    @{id}  Query  SELECT TOP(1) BusinessEntityID FROM HumanResources.Employee
    Execute Sql String   INSERT INTO Production.Document(DocumentNode, Title, Owner, FileName, FileExtension, Revision, Status) VALUES ('/4/0/','Test3',${id[0][0]},'Test','.doc',0,2)
    @{result}   Query   SELECT ChangeNumber, FolderFlag FROM Production.Document WHERE DocumentNode.ToString()='/4/0/'
    Should Be Equal As Strings  ${result}   [(0, False)]
    [Teardown]   Execute sql String  DELETE FROM Production.Document WHERE DocumentNode.ToString() = '/4/0/'

Checking that Production.UnitMeasure satisfies Primary Key constraint
    [Tags]  AUTO-3.1, Production, Production.UnitMeasure
    [Documentation]  Checking that column 'UnitMeasureCode' in Production.UnitMeasure table
    ...  | satisfies Primary Key constraint, i.e. has only not-null unique values
    ...  |
    ...  | * Test Steps *
    ...  | 1. Get number of unique not-null values in 'UnitMeasureCode' column
    ...  | 2. Get total number of rows in Production.UnitMeasure table
    ...  |
    ...  | * Expected results *
    ...  | 1. Total number of records in Production.UnitMeasure table is equal to number
    ...  | of distinct not-null values in 'UnitMeasureCode' column
    @{results}  Query  SELECT COUNT (DISTINCT(UnitMeasureCode)), COUNT(*) from Production.UnitMeasure
    should be equal as integers  ${results[0][0]}   ${results[0][1]}

Checking that all values from source file are ingested to column 'UnitMeasureCode' in Production.UnitMeasure table
    [Tags]  AUTO-3.2, Production, Production.UnitMeasure
    [Documentation]  Checking that all values from source file were ingested into Production.UnitMeasure table,
        ...  | 'UnitMeasureCode'column . The path to source file can be changed in variables.py file
    ...  |
    ...  | * Test Steps *
    ...  | 1. Load data from file located in path that is defined by UNIT_MEASURE_SOURCE_FILE_PATH varialbe
    ...  |      in variables.py file
    ...  | 2. Split the data obtained from file to get list of values.
    ...  | 3. Get values of UnitMeasureCode column from Production.UnitMeasure
    ...  | 4. For each value of UnitMeasureCode check if it exists in list of values from file
    ...  |
    ...  | * Expected result *
    ...  | 1. All values from the file are present in UnitMeasureCode column of Production.UnitMeasure table
    ${content} =  get file  ${UNIT_MEASURE_SOURCE_FILE_PATH}
    @{lines}    split to lines  ${content}
    @{result_codes}   Query   SELECT UnitMeasureCode FROM Production.UnitMeasure
    FOR     ${code}  IN  @{result_codes}
        list should contain value  ${lines}     ${code[0]}
    END
