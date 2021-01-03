-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab2.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate diagnostic scripts.
--  
-- ------------------------------------------------------------------
-- This creates tables, sequences, indexes, and constraints necessary
-- to begin lesson #3. Demonstrates proper process and syntax.
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab2.sql
--
-- ------------------------------------------------------------------

-- Set SQL*Plus environmnet variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/lab1/apply_oracle_lab1.sql

COLUMN table_name FORMAT A30 HEADING "Base Tables"
SELECT   table_name
FROM     user_tables
WHERE    table_name IN
          ('SYSTEM_USER'
          ,'COMMON_LOOKUP'
          ,'MEMBER'
          ,'CONTACT'
          ,'ADDRESS'
          ,'STREET_ADDRESS'
          ,'TELEPHONE'
          ,'ITEM'
          ,'RENTAL'
          ,'RENTAL_ITEM')
ORDER BY CASE
           WHEN table_name LIKE 'SYSTEM_USER%' THEN 0
           WHEN table_name LIKE 'COMMON_LOOKUP%' THEN 1
           WHEN table_name LIKE 'MEMBER%' THEN 2
           WHEN table_name LIKE 'CONTACT%' THEN 3
           WHEN table_name LIKE 'ADDRESS%' THEN 4
           WHEN table_name LIKE 'STREET_ADDRESS%' THEN 5
           WHEN table_name LIKE 'TELEPHONE%' THEN 6
           WHEN table_name LIKE 'ITEM%' THEN 7
           WHEN table_name LIKE 'RENTAL%' AND NOT table_name LIKE 'RENTAL_ITEM%' THEN 8
           WHEN table_name LIKE 'RENTAL_ITEM%' THEN 9
         END;

COLUMN sequence_name FORMAT A30 HEADING "Base Sequences"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name IN 
           ('SYSTEM_USER_S1'
           ,'COMMON_LOOKUP_S1'
           ,'MEMBER_S1'
           ,'CONTACT_S1'
           ,'ADDRESS_S1'
           ,'STREET_ADDRESS_S1'
           ,'TELEPHONE_S1'
           ,'ITEM_S1'
           ,'RENTAL_S1'
           ,'RENTAL_ITEM_S1')
ORDER BY CASE
           WHEN sequence_name LIKE 'SYSTEM_USER%' THEN 0
           WHEN sequence_name LIKE 'COMMON_LOOKUP%' THEN 1
           WHEN sequence_name LIKE 'MEMBER%' THEN 2
           WHEN sequence_name LIKE 'CONTACT%' THEN 3
           WHEN sequence_name LIKE 'ADDRESS%' THEN 4
           WHEN sequence_name LIKE 'STREET_ADDRESS%' THEN 5
           WHEN sequence_name LIKE 'TELEPHONE%' THEN 6
           WHEN sequence_name LIKE 'ITEM%' THEN 7
           WHEN sequence_name LIKE 'RENTAL%' AND NOT sequence_name LIKE 'RENTAL_ITEM%' THEN 8
           WHEN sequence_name LIKE 'RENTAL_ITEM%' THEN 9
         END;

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL apply_oracle_lab2.txt

-- ------------------------------------------------------------------
--  Enter Lab #3 Steps:
-- ------------------------------------------------------------------

-- ======================================================================
--  Step #1
--  -------
--   Write a query that returns the account_number and
--   credit_card_number column values from the member
--   table.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
  COL account_number      FORMAT A12  HEADING "Account|Number"
  COL credit_card_number  FORMAT A22  HEADING "Credit|Card Number"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--  Account      Credit
--  Number       Card Number
--  ------------ ----------------------
--  B293-71445   1111-2222-3333-4444
--  B293-71446   2222-3333-4444-5555
--  B293-71447   3333-4444-5555-6666
--  R11-514-34   1111-1111-1111-1111
--  R11-514-35   1111-2222-1111-1111
--  R11-514-36   1111-1111-2222-1111
--  R11-514-37   3333-1111-1111-2222
--  R11-514-38   1111-1111-3333-1111
--  
--  8 rows selected.
-- ======================================================================

COL account_number      FORMAT A12  HEADING "Account|Number"
COL credit_card_number  FORMAT A22  HEADING "Credit|Card Number"
SELECT account_number
,      credit_card_number
FROM   member;


-- ======================================================================
--  Step #2
--  -------
--   Write a query that returns the first_name, middle_name,
--   and last_name from the contact table ordered by the last name
--   column.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL first_name   FORMAT A12  HEADING "First Name"
--  COL middle_name  FORMAT A12  HEADING "Middle Name"
--  COL last_name    FORMAT A12  HEADING "Last Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--  First Name   Middle Name  Last Name
--  ------------ ------------ ------------
--  Goeffrey     Ward         Clinton
--  Simon        Jonah        Gretelz
--  Wendy                     Moss
--  Elizabeth    Jane         Royal
--  Brian        Nathan       Smith
--  Ian          M            Sweeney
--  Meaghan                   Sweeney
--  Matthew                   Sweeney
--  Oscar                     Vizquel
--  Doreen                    Vizquel
--  Brian                     Winn
--  Randi                     Winn
--  
--  12 rows selected.
-- ======================================================================
COL first_name   FORMAT A12  HEADING "First Name"
COL middle_name  FORMAT A12  HEADING "Middle Name"
COL last_name    FORMAT A12  HEADING "Last Name"
SELECT first_name
,      middle_name
,      last_name
FROM   contact
ORDER BY last_name;

-- ======================================================================
--  Step #3
--  -------
--   Write a query that returns the city, state_province,
--   and postal_code from the address table.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL city            FORMAT A14  HEADING "City"
--  COL state_province  FORMAT A8   HEADING "State|Province"
--  COL postal_code     FORMAT A6   HEADING "Postal|Code"
-- ----------------------------------------------------------------------
--  Anticipated Results (Dates will change to today and 5-days later.)
-- ----------------------------------------------------------------------
--                 State    Postal
--  City           Province Code
--  -------------- -------- ------
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Spanish Fork   Utah     84606
--  
--  12 rows selected.
-- ======================================================================

COL city            FORMAT A14  HEADING "City"
COL state_province  FORMAT A8   HEADING "State|Province"
COL postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT city
,      state_province
,      postal_code
FROM address;

-- ======================================================================
--  Step #4
--  -------
--   Write a query that returns the check_out_date and
--   return_date from the rental table.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL check_out_date  FORMAT A12  HEADING "Check Out|Date"
--  COL return_date     FORMAT A12  HEADING "Return|Date"
-- ----------------------------------------------------------------------
--  Anticipated Results (Dates will change to today and 5-days later.)
-- ----------------------------------------------------------------------
--  Check Out    Return
--  Date         Date
--  ------------ ------------
--  13-JAN-20    18-JAN-20
--  13-JAN-20    18-JAN-20
--  13-JAN-20    18-JAN-20
--  13-JAN-20    18-JAN-20
--  13-JAN-20    18-JAN-20
--  
--  5 rows selected.
-- ======================================================================
COL check_out_date  FORMAT A12  HEADING "Check Out|Date"
COL return_date     FORMAT A12  HEADING "Return|Date"
SELECT check_out_date
,      return_date
FROM rental;


-- ======================================================================
--  Step #5
--  -------
--   Write a query that returns the item_title, item_rating, and
--   item_release_date from the item table where item_title column
--   values is like a string starting with a title case string like
--   'Star' string.
-- ----------------------------------------------------------------------
--  Uses: This does uses a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL item_title         FORMAT A30  HEADING "Item Title"
--  COL item_rating        FORMAT A5   HEADING "Item|Rating"
--  COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                                                 Item
--                                 Item            Release
--  Item Title                     Rating          Date
--  ------------------------------ --------------- ------------
--  Star Wars I                    PG              04-MAY-99
--  Star Wars II                   PG              16-MAY-02
--  Star Wars II                   PG              16-MAY-02
--  Star Wars III                  PG13            19-MAY-05
--  
--  4 rows selected.
-- ======================================================================
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_rating        FORMAT A5   HEADING "Item|Rating"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
SELECT item_title 
,      item_rating
,      item_release_date
FROM item
WHERE item_title LIKE 'Star%';

-- ======================================================================
--  Step #6
--  -------
--   Write a query that returns the item_title, item_rating, and
--   item_release_date from the item table where the item_rating equals
--   an uppercase 'PG' string in ascending order by the item_rating
--   column value.
-- ----------------------------------------------------------------------
--  Uses: This uses a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL item_title         FORMAT A30  HEADING "Item Title"
--  COL item_rating        FORMAT A5   HEADING "Item|Rating"
--  COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                                                 Item
--                                 Item            Release
--  Item Title                     Rating          Date
--  ------------------------------ --------------- ------------
--  Beau Geste                     PG              01-MAR-92
--  Hook                           PG              11-DEC-91
--  Star Wars I                    PG              04-MAY-99
--  Star Wars II                   PG              16-MAY-02
--  Star Wars II                   PG              16-MAY-02
--  The Chronicles of Narnia       PG              16-MAY-02
--  The Hunt for Red October       PG              02-MAR-90
--  
--  7 rows selected.
-- ======================================================================
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_rating        FORMAT A5   HEADING "Item|Rating"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
SELECT item_title
,      item_rating
,      item_release_date
FROM item
WHERE item_rating LIKE '%PG'
ORDER BY item_title;

-- ======================================================================
--  Step #7
--  -------
--   Write a query that returns the first_name, middle_name,
--   and last_name from the contact table where the last
--   name equals 'Sweeney' and middle name is null.
-- ----------------------------------------------------------------------
--  Uses: The IS NULL comparison operator and an equality operator.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL first_name   FORMAT A12  HEADING "First Name"
--  COL middle_name  FORMAT A12  HEADING "Middle Name"
--  COL last_name    FORMAT A12  HEADING "Last Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--  First Name   Middle Name  Last Name
--  ------------ ------------ ------------
--  Meaghan                   Sweeney
--  Matthew                   Sweeney
--  
--  2 rows selected.
-- ======================================================================
COL first_name   FORMAT A12  HEADING "First Name"
COL middle_name  FORMAT A12  HEADING "Middle Name"
COL last_name    FORMAT A12  HEADING "Last Name"
SELECT first_name
,      middle_name
,      last_name
FROM contact
WHERE last_name LIKE '%Sweeney' AND middle_name IS NULL;
-- ======================================================================
--  Step #8
--  -------
--   Write a query that returns the first_name, middle_name,
--   and last_name from the contact table where the last
--   name starts with a case insensitive 'viz' string;
--   and you can promote the column value and string to
--   uppercase values, or demote the column value and
--   string to lowercase values.
-- ----------------------------------------------------------------------
--  Uses: The UPPER or LOWER built-in functions, the '%' wildcard
--        operator, and piped (||) concatenation.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL first_name  FORMAT A12  HEADING "First Name"
--  COL last_name   FORMAT A12  HEADING "Last Name"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--  First Name   Last Name
--  ------------ ------------
--  Oscar        Vizquel
--  Doreen       Vizquel
--  
--  2 rows selected.
-- ======================================================================
COL first_name  FORMAT A12  HEADING "First Name"
COL last_name   FORMAT A12  HEADING "Last Name"
SELECT first_name
,      last_name
FROM contact
WHERE LOWER(last_name) LIKE LOWER('Viz') || '%';

-- ======================================================================
--  Step #9
--  -------
--   Write a query that returns the city, state_province,
--   and postal_code from the address table where the city
--   column name is in the set of 'Provo' and 'San Jose'
--   (A comparison best performed with a lookup operator).
-- ----------------------------------------------------------------------
--  Uses: The IN, =ANY, or =SOME lookup operator.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL city            FORMAT A14  HEADING "City"
--  COL state_province  FORMAT A8   HEADING "State|Province"
--  COL postal_code     FORMAT A6   HEADING "Postal|Code"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                 State    Postal
--  City           Province Code
--  -------------- -------- ------
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  San Jose       CA       95192
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Provo          Utah     84606
--  Spanish Fork   Utah     84606
--  
--  12 rows selected.
-- ======================================================================
COL city            FORMAT A14  HEADING "City"
COL state_province  FORMAT A8   HEADING "State|Province"
COL postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT city
,      state_province
,      postal_code
FROM address
WHERE city IN ('Provo', 'San Jose');

-- ======================================================================
--  Step #10
--  --------
--   Write a query that returns the item_title and 
--   item_release_date columns from the item table where
--   the item_release_date is found in the range between
--   '01-JAN-2003' and '31-DEC-2003'.
-- ----------------------------------------------------------------------
--  Uses: The BETWEEN operator.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL item_title         FORMAT A30  HEADING "Item Title"
--  COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                             Item
--                             Release
--  Item Title                 Date
--  -------------------------- -----------
--  RoboCop                    24-JUL-03
--  Pirates of the Caribbean   30-JUN-03
--  The Chronicles of Narnia   30-JUN-03
--  MarioKart                  17-NOV-03
--  Splinter Cell              08-APR-03
-- 
--  5 rows selected.
-- ======================================================================
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"
SELECT item_title
,      item_release_date
FROM item
WHERE item_release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';


-- ----------------------------------------------------------------------
--  Close log file.
-- ----------------------------------------------------------------------
SPOOL OFF
