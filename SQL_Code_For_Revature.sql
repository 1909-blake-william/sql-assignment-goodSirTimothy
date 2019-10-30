--1.0 Setting up Oracle Chinook
--In this section you will begin the process of working with the Oracle Chinook database
--Task – Open the Chinook_Oracle.sql file and execute the scripts within.
--2.0 SQL Queries
--In this section you will be performing various queries against the Oracle Chinook database.
--2.1 SELECT
--Task – Select all records from the Employee table.
SELECT * FROM employee;
--Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee
WHERE UPPER(lastname) = UPPER('king');
--Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee
WHERE firstname = 'Andrew' AND reportsto IS NULL;
--2.2 ORDER BY
--Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album 
ORDER BY(title);
--Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname from customer
ORDER BY(city) ASC;
--2.3 INSERT INTO
--Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name)
VALUES(30, 'Other Genre');
INSERT INTO genre (genreid, name)
VALUES(31, 'Other Genre 2.0');
--Task – Insert two new records into Employee table
INSERT INTO employee (employeeid, lastname, firstname, title, 
                        reportsto, birthdate, hiredate, address, 
                        city, state, country, postalcode, phone, fax, email)
VALUES(9, 'Tim', 'Clinton', 'Epicly Awesome', 2, 
        TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2008-5-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '310 2nd Street', 
                        'Milaca', 'MN', 'Canada', 16548, '+1 (125) 456-2467', '+1 (125) 456-2467', 'email@gmail.com');
INSERT INTO employee (employeeid, lastname, firstname, title, 
                        reportsto, birthdate, hiredate, address, 
                        city, state, country, postalcode, phone, fax, email)
VALUES(26, 'Jimmy', 'Newtron', 'Just some smart kid', 2, 
        TO_DATE('1962-2-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), TO_DATE('2004-8-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '513 5th Ave', 
        'Milaca', 'MN', 'Canada', 16534, '+1 (125) 456-2467', '+1 (125) 456-2467', 'greatEmail@gmai.com');
--Task – Insert two new records into Customer table
INSERT INTO customer(CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, SupportRepId)
    VALUES(60, 'Glen', 'Farshity', null, '9th street NW', 'Awesome Vill', 'VA', 'USA', '53415', '+1 (548) 158-1325', '+1 (548) 158-1325', 'EpicEmail.gmail.com', 5);
INSERT INTO customer(CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, SupportRepId)
    VALUES(61, 'Grant', 'Larsh', null, '91th street', 'Greatness', 'VA', 'USA', '75642', '+1 (567) 158-1345', '+1 (548) 158-1325', 'grand.gmail.com', 5);
--2.4 UPDATE
--Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer SET firstname = 'Robert', lastname = 'Walter'
WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
--Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist set name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';
--2.5 LIKE
--Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
WHERE billingaddress LIKE('T%');
--2.6 BETWEEN
--Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
WHERE total > 15 AND total < 50;
--Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
WHERE hiredate > TO_DATE('2003-6-1 00:00:00','yyyy-mm-dd hh24:mi:ss') 
AND hiredate < TO_DATE('2004-3-1 00:00:00','yyyy-mm-dd hh24:mi:ss');
--2.7 DELETE
--Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline
WHERE invoiceid IN (SELECT invoiceid FROM invoice 
WHERE customerid = (SELECT customerid FROM customer 
                    WHERE customer.firstname = 'Robert' 
                    AND customer.lastname = 'Walter'));
DELETE FROM invoice
WHERE customerid = (SELECT customerid FROM customer 
                    WHERE customer.firstname = 'Robert' 
                    AND customer.lastname = 'Walter');
DELETE FROM customer
WHERE firstname = 'Robert' AND lastname = 'Walter';
--3.0 SQL Functions
--In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
--3.1 System Defined Functions
--Task – Create a function that returns the current time.
SELECT TO_CHAR (SYSDATE, 'MM-DD-YYYY HH24:MI:SS') "NOW" FROM DUAL;
CREATE OR REPLACE FUNCTION get_current_time
RETURN DATE
is
today_date DATE;
BEGIN
    SELECT SYSTIMESTAMP INTO today_date
    FROM DUAL;
    RETURN today_date;
END;

--Task – create a function that returns the length of a mediatype from the mediatype table
SELECT LENGTH(name) FROM mediatype;
CREATE OR REPLACE FUNCTION mediatype_length
    RETURN SYS_REFCURSOR
AS 
    my_cursor SYS_REFCURSOR; 
BEGIN
    OPEN my_cursor FOR SELECT m.name, LENGTH(m.name) FROM mediatype m;
    RETURN my_cursor;
END;
--3.2 System Defined Aggregate Functions
--Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION invoice_avg
RETURN float
is
invoice_average float;
BEGIN
    SELECT AVG(total) INTO invoice_average
    FROM invoice;
    RETURN invoice_average;
END;
--Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION expensive_track
RETURN float
is
track float;
BEGIN
    SELECT MAX(unitprice) INTO track
    FROM track;
    RETURN track;
END;
--3.3 User Defined Scalar Functions
--Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION average_track
RETURN float
is
track_average float;
BEGIN
    SELECT AVG(unitprice) INTO track_average
    FROM invoiceline;
    RETURN track_average;
END;
--3.4 User Defined Table Valued Functions
--Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION all_employees_after_1968
    RETURN SYS_REFCURSOR
AS 
    my_cursor SYS_REFCURSOR; 
BEGIN
    OPEN my_cursor FOR SELECT LASTNAME , FIRSTNAME 
        FROM employee WHERE birthdate > TO_DATE('1968-1-1 00:00:00','yyyy-mm-dd hh24:mi:ss');
    RETURN my_cursor;
END;

--4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
--4.1 Basic Stored Procedure
--Task – Create a stored procedure that selects the first and last names of all the employees.

create or replace PROCEDURE display_employee_names
(results OUT sys_refcursor)
IS  
BEGIN
    open results for
    SELECT firstname, lastname FROM employee;
END display_employee_names;
/
SET SERVEROUTPUT ON;
DECLARE
    results sys_refcursor;
    first_name VARCHAR2(20);
    last_name VARCHAR2(20);
BEGIN
    display_employee_names(results);
    LOOP
        FETCH results INTO first_name, last_name;
        EXIT WHEN results%notfound;
        dbms_output.put_line(first_name || ' | ' || last_name);
    END LOOP;
END;

--4.2 Stored Procedure Input Parameters
--Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE PROCEDURE update_employee_info
(employeeid IN INT, 
address IN VARCHAR2,
city IN VARCHAR2,
state IN VARCHAR2,
country IN VARCHAR2,
postalcode IN VARCHAR2,
phone IN VARCHAR2,
fax IN VARCHAR2,
email IN VARCHAR2)
IS
BEGIN
    UPDATE employee e
    SET e.address = address, e.city = city, e.state = state,
    e.country = country, e.postalcode = postalcode, e.phone = phone,
    e.fax = fax, e.email = email
    WHERE e.employeeid = employeeid;
END update_employee_info;
/
SET SERVEROUTPUT ON;
DECLARE
BEGIN
    update_employee_info(1, '', '', '', '', 5, '', '', '');
END;
SELECT * FROM employee WHERE employeeid = 1;
--Task – Create a stored procedure that returns the managers of an employee.
create or replace PROCEDURE display_manager_names
(results OUT sys_refcursor)
IS  
BEGIN
    open results for
    SELECT e0.employeeid, e0.firstname, e0.lastname, e1.employeeid, e1.firstname, e1.lastname FROM employee e0
    LEFT JOIN employee e1 ON(e0.reportsto = e1.employeeid);
END display_manager_names;
/
SET SERVEROUTPUT ON;
DECLARE
    results sys_refcursor;
    e0.employeeid varchar2(20);
    e0.firstname varchar2(20);
    e0.lastname varchar2(20);
    e1.employeeid varchar2(20);
    e1.firstname varchar2(20);
    e1.lastname varchar2(20);
BEGIN
    display_manager_names(results);
    LOOP
        FETCH results INTO e0.employeeid, e0.firstname, e0.lastname, e1.employeeid, e1.firstname, e1.lastname;
        EXIT WHEN results%notfound;
        dbms_output.put_line(first_name || ' | ' || last_name);
    END LOOP;
END;
--4.3 Stored Procedure Output Parameters
--Task – Create a stored procedure that returns the name and company of a customer.

create or replace PROCEDURE display_customer_names
(results OUT sys_refcursor)
IS
BEGIN
    open results for
    SELECT company, firstname, lastname FROM customer WHERE company IS NOT NULL;
END display_customer_names;
/
SET SERVEROUTPUT ON;
DECLARE
    results sys_refcursor;
    company VARCHAR2(50);
    first_name VARCHAR2(50);
    last_name VARCHAR2(50);
BEGIN
    display_customer_names(results);
    LOOP
        FETCH results INTO company, first_name, last_name;
        EXIT WHEN results%notfound;
        dbms_output.put_line(company || ' | ' || first_name || ' | ' || last_name);
    END LOOP;
END;

--6.0 Triggers
--In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
--6.1 AFTER/FOR
--Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
/
CREATE OR REPLACE TRIGGER employee_trigger
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    dbms_output.put_line('Woot Woot! Table has been INSERTEE');
END;
/
--Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE TRIGGER album_trigger
AFTER UPDATE ON album
FOR EACH ROW
BEGIN
    dbms_output.put_line('Woot Woot! Table has been updatee');
END;
/
UPDATE album SET title = 'blah blab baby' Where albumid = 6;
--Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE TRIGGER delete_trigger
AFTER DELETE ON customer
FOR EACH ROW
BEGIN
    dbms_output.put_line('Woot Woot! Table has been DELETEE');
END;
--Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE TRIGGER delete_restriction_trigger
BEFORE DELETE ON invoice
FOR EACH ROW
BEGIN
    if :old.total > 50 then
        RAISE_APPLICATION_ERROR(-20001, 'UwU There has been an error.');
        dbms_output.put_line('UwU There has been an error.');
    end if;
END;
/
--7.0 JOINS
--In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
--7.1 INNER
--Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT c.firstname, c.lastname, i.invoiceid FROM customer c
INNER JOIN invoice i ON(c.customerid = i.customerid);
--7.2 OUTER
--Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT c.customerid, c.firstname, c.lastname, i.invoiceid, i.total FROM customer c 
FULL OUTER JOIN invoice i ON(c.customerid = i.customerid);
--7.3 RIGHT
--Task – Create a right join that joins album and artist specifying artist name and title.
SELECT art.name, al.title FROM artist art
RIGHT JOIN album al on (art.artistid = al.artistid);
--7.4 CROSS
--Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM artist art
CROSS JOIN album
ORDER BY art.name ASC;
--7.5 SELF
--Task – Perform a self-join on the employee table, joining on the reportsto column.
-- > To make it easier to read the outputs, I only display the id, firstname, lastname. 
SELECT e0.employeeid, e0.firstname, e0.lastname, e1.employeeid, e1.firstname, e1.lastname FROM employee e0
LEFT JOIN employee e1 ON(e0.reportsto = e1.employeeid);