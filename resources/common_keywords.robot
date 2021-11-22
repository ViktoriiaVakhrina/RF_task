*** Settings ***

Library     DatabaseLibrary
Library  OperatingSystem

Variables  variables.py

*** Keywords ***

Create new user
    [Documentation]  Creates new login and user in database and connects as new user
    ...  | All connection parameters and credentials for new user can be changed in file variables.py
    Connect To Database Using Custom Params   pyodbc    ${CONNECTION_STRING}
    Execute sql string  CREATE LOGIN ${TEST_LOGIN} WITH PASSWORD = '${TEST_USER_PASSWORD}'
    Execute sql string  USE AdventureWorks2012
    Execute sql string  CREATE USER ${TEST_USER_NAME} FOR LOGIN ${TEST_LOGIN}
    Execute sql string  ALTER ROLE db_datawriter ADD MEMBER ${TEST_USER_NAME}
    Execute sql string  ALTER ROLE db_datareader ADD MEMBER ${TEST_USER_NAME}
    Run and return rc  NET STOP MSSQLSERVER
    Run and return rc    NET START MSSQLSERVER
    Connect To Database Using Custom Params   pyodbc    ${TEST_CONNECTION_STRING}

Delete user and disconnect
    [Documentation]     Delete user and login created for tests
    ...  | 1. Log out from user for tests.
    ...  | 2. Log in using primary credentials
    ...  | 3. Delete user and login created for tests
    ...  | 4. Disconnect from database
    Disconnect From Database
    Run and return rc   NET STOP MSSQLSERVER
    Run and return rc  NET START MSSQLSERVER
    Connect To Database Using Custom Params   pyodbc    ${CONNECTION_STRING}
    Execute sql string  DROP USER IF EXISTS ${TEST_USER_NAME}
    Execute sql string  DROP LOGIN ${TEST_LOGIN}
    Disconnect From Database