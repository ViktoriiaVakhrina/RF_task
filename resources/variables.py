# Initial connection variables:

DRIVER = '{ODBC Driver 17 for SQL Server}'
SERVER = 'localhost'
DATABASE = 'AdventureWorks2012'
TRUSTED_CONNECTION = 'yes'


# if not Windows authentication is used uncomment the following line
# TRUSTED_CONNECTION = 'no'
# and provide valid username and password for primary log in:
UID = ''
PWD = ''


CONNECTION_STRING = "Driver='" + DRIVER + "',Server='" + SERVER + "',Database='" \
                   + DATABASE + "',Trusted_Connection='" + TRUSTED_CONNECTION + "',"\
                    + "UID='" + UID + "',PWD='" + PWD + "'"

# Login and password for test user:
TEST_LOGIN = 'TestLogin15'
TEST_USER_PASSWORD = 'Password1'
TEST_USER_NAME = 'TestUser15'

TEST_CONNECTION_STRING = "Driver='" + DRIVER + "',Server='" + SERVER + "',Database='" \
                        + DATABASE + "',Trusted_Connection='no',"\
                        + "UID='" + TEST_LOGIN + "',PWD='" + TEST_USER_PASSWORD + "'"
UNIT_MEASURE_SOURCE_FILE_PATH = '../RF_task/resources/UnitMeasureCodeValues.txt'
