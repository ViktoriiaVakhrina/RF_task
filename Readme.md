Instruction for Windows
# Environment setup

## Create and activate virtual environment for tests execution:
1. Run command line as administrator
2. Go to folder where project is located by running the following command:
	cd <path to folder>
3. Setup virtual environment:
	python -m venv venv
4. Activate the environment:
	venv\Scripts\activate
5. Install dependencies:
	pip install -r requirements.txt

# Before tests execution:
1. In file resources/variables.py make changes (if necessary):
	- if SQL Server authentication is used - write your login and password in lines 12 and 13
	- for primary login use account that has rights to create users and logins
	- write login, password and username for test user in lines 21, 22 and 23
		Note: login and user created for testing are deleted after tests execution.

# To run tests:
1. Run tests by running the following command:
	robot Tests/tests.robot
2. To run only specific tests:
	- open file Tests/tests.robot, read tests and get tags of tests you want to run
	- run the following command usign tags you have:
	robot -i <tag name> Tests/tests.robot
	
#Deactivate virtual environment
By running
	deactivate
command in command line

# Logs
Logs can be found in RF_Task/Tests/log.html
Report can be found in RF_task/Tests/report.html
