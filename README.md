# RDBMS Program 9 - INNER JOIN

## Objective

Create Student and Department tables, insert the given records, and perform an INNER JOIN to display the Student Name with Department Name.

## Department Table

| DepartmentID | DepartmentName |
|--------------|----------------|
| 101          | Computer Science |
| 102          | Mathematics |
| 103          | Physics |

## Student Table

| StudentID | StudentName | DepartmentID |
|-----------|-------------|--------------|
| 1001      | Arun        | 101          |
| 1002      | Divya       | 102          |
| 1003      | Karthik     | 101          |
| 1004      | Nisha       | 103          |

## Student Task

Students must:

1. Create the `CollegeDB` database.
2. Create the `Department` table.
3. Insert the three Department records.
4. Create the `Student` table.
5. Insert the four Student records.
6. Perform an `INNER JOIN`.
7. Display:
   - Student Name
   - Department Name

## Expected Output

Student Name    Department Name

Arun            Computer Science
Divya           Mathematics
Karthik         Computer Science
Nisha           Physics

## Important

- Complete only `student_solution.sql`.
- Do not modify `test.sh`.
- Do not modify `.github/workflows/autograding.yml`.
- Save the SQL file as `student_solution.sql`.
- Commit and push the changes to GitHub.
- GitHub Actions will automatically evaluate the program.

## Submission

1. Open `student_solution.sql`.
2. Complete the SQL program.
3. Save the file.
4. Commit the changes.
5. Push to GitHub.
6. Open the **Actions** tab.
7. Check the autograding result.

Total Marks: 10
