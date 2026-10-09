#!/bin/bash

DB="CollegeDB"
TOTAL=0
FAILED=0

# MySQL connection
MYSQL="mysql -h 127.0.0.1 -P 3306 -uroot -p${MYSQL_ROOT_PASSWORD}"

echo "========================================"
echo " INNER JOIN - Student Department"
echo "========================================"

echo "Checking MySQL connection..."

if ! $MYSQL -e "SELECT 1;" > /dev/null 2>&1; then
    echo "FAIL: Cannot connect to MySQL server."
    exit 1
fi

echo "MySQL connection successful."
echo ""

echo "Creating fresh CollegeDB database..."

$MYSQL -e "
DROP DATABASE IF EXISTS $DB;
CREATE DATABASE $DB;
" || exit 1

echo "Executing student_solution.sql..."

if $MYSQL < student_solution.sql; then
    echo "SQL execution completed."
else
    echo "FAIL: SQL execution error."
    exit 1
fi

echo ""

# Test 1
echo "Test Case 1: Department table..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema='$DB'
AND table_name='Department';
")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Department table exists."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Department table not found."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 2
echo "Test Case 2: Student table..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema='$DB'
AND table_name='Student';
")

if [ "$RESULT" -eq 1 ]; then
    echo "PASS: Student table exists."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Student table not found."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 3
echo "Test Case 3: Department records..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*) FROM $DB.Department;
")

if [ "$RESULT" -eq 3 ]; then
    echo "PASS: 3 Department records inserted."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Expected 3 Department records."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 4
echo "Test Case 4: Student records..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*) FROM $DB.Student;
")

if [ "$RESULT" -eq 4 ]; then
    echo "PASS: 4 Student records inserted."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Expected 4 Student records."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 5
echo "Test Case 5: Department columns..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM information_schema.columns
WHERE table_schema='$DB'
AND table_name='Department'
AND column_name IN ('DepartmentID','DepartmentName');
")

if [ "$RESULT" -eq 2 ]; then
    echo "PASS: Department columns are correct."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Department columns are incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 6
echo "Test Case 6: Student columns..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM information_schema.columns
WHERE table_schema='$DB'
AND table_name='Student'
AND column_name IN ('StudentID','StudentName','DepartmentID');
")

if [ "$RESULT" -eq 3 ]; then
    echo "PASS: Student columns are correct."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Student columns are incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 7
echo "Test Case 7: Department values..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM $DB.Department
WHERE
(DepartmentID=101 AND DepartmentName='Computer Science')
OR
(DepartmentID=102 AND DepartmentName='Mathematics')
OR
(DepartmentID=103 AND DepartmentName='Physics');
")

if [ "$RESULT" -eq 3 ]; then
    echo "PASS: Department values are correct."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Department values are incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 8
echo "Test Case 8: Student values..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM $DB.Student
WHERE
(StudentID=1001 AND StudentName='Arun' AND DepartmentID=101)
OR
(StudentID=1002 AND StudentName='Divya' AND DepartmentID=102)
OR
(StudentID=1003 AND StudentName='Karthik' AND DepartmentID=101)
OR
(StudentID=1004 AND StudentName='Nisha' AND DepartmentID=103);
")

if [ "$RESULT" -eq 4 ]; then
    echo "PASS: Student values are correct."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Student values are incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 9
echo "Test Case 9: INNER JOIN results..."

RESULT=$($MYSQL -Nse "
SELECT COUNT(*)
FROM $DB.Student s
INNER JOIN $DB.Department d
ON s.DepartmentID = d.DepartmentID;
")

if [ "$RESULT" -eq 4 ]; then
    echo "PASS: INNER JOIN returned 4 records."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: INNER JOIN result is incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

# Test 10
echo "Test Case 10: Student-Department mapping..."

EXPECTED="Arun|Computer Science
Divya|Mathematics
Karthik|Computer Science
Nisha|Physics"

ACTUAL=$($MYSQL -Nse "
SELECT s.StudentName, d.DepartmentName
FROM $DB.Student s
INNER JOIN $DB.Department d
ON s.DepartmentID = d.DepartmentID
ORDER BY s.StudentID;
" | sed 's/	/|/')

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "PASS: Student-Department mapping is correct."
    TOTAL=$((TOTAL+1))
else
    echo "FAIL: Student-Department mapping is incorrect."
    FAILED=$((FAILED+1))
fi

echo ""

echo "========================================"
echo "Total Marks: $TOTAL / 10"
echo "========================================"

if [ "$FAILED" -eq 0 ]; then
    echo "All test cases passed."
    exit 0
else
    echo "$FAILED test case(s) failed."
    exit 1
fi
