-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab3.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate diagnostic scripts.
--  18-Jan-2020    Rewrite labs to queries.
--  
-- ------------------------------------------------------------------
--  This queries some tables by using aggregation mechanics; and
--  two-table joins.
-- ------------------------------------------------------------------
--  Instructions:
-- ------------------------------------------------------------------
--  The two scripts contain spooling commands, which is why there
--  isn't a spooling command in this script. When you run this file
--  you first connect to the Oracle database with this syntax:
--
--    sqlplus student/student
--
--  Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab3.sql
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
@/home/student/lab2/apply_oracle_lab2.sql


SPOOL apply_oracle_lab3.txt
-- ------------------------------------------------------------------
--  Enter Lab #3 Steps:
-- ------------------------------------------------------------------

-- ======================================================================
--  Step #1
--  -------
--   Write a query that returns the count of rows in the member table.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL total_rows          FORMAT 999  HEADING "Total|Rows"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Total
--   Rows
--   -----
--       8
--
--   1 row selected.
-- ======================================================================
COL total_rows FORMAT 999 HEADING "Total|Rows"
SELECT COUNT(*) AS "Total|Rows"
FROM member;


-- ======================================================================
--  Step #2
--  -------
--   Write a query that returns the last_name and count of rows that
--   share the last_name value in alphabetically ascending order.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause but uses a GROUP BY clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name    FORMAT A12  HEADING "Last Name"
--  COL total_rows   FORMAT 999  HEADING "Total|Rows"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Last Name    TOTAL_NAMES
--   ------------ -----------
--   Clinton                1
--   Gretelz                1
--   Moss                   1
--   Royal                  1
--   Smith                  1
--   Sweeney                3
--   Vizquel                2
--   Winn                   2
--   
--   8 rows selected.
-- ======================================================================
COL last_name    FORMAT A12  HEADING "Last Name"
COL total_rows   FORMAT 999  HEADING "Total|Rows"
SELECT last_name 
,  COUNT(last_name) 
FROM contact
GROUP BY last_name
ORDER BY last_name;



-- ======================================================================
--  Step #3
--  -------
--   Write a query that returns the item_rating and the total_count of
--   each item_rating value by ascending order where the item_rating is
--   'G', 'PG', and 'NR'.
-- ----------------------------------------------------------------------
--  Uses: This does use WHERE, GROUP BY, and ORDER BY clauses.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL item_rating    FORMAT A12  HEADING "Item|Rating"
--  COL total_count    FORMAT 999  HEADING "Total|Count"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Item         Total
--   Rating       Count
--   ------------ -----
--   G                4
--   NR               1
--   PG               7
--   
--   3 rows selected.
-- ======================================================================
COL item_rating    FORMAT A12  HEADING "Item|Rating"
COL total_count    FORMAT 999  HEADING "Total|Count"
SELECT item_rating
, COUNT (item_rating) AS "Total Count"
FROM item
WHERE item_rating IN ('G', 'PG', 'NR')
GROUP BY item_rating
ORDER BY item_rating;

-- ======================================================================
--  Step #4
--  -------
--   Write a query that returns the account_number and credit_card_number
--   from the member table and the last_name and count of unique last_name
--   values from the contact table. Use an inner join between the member
--   and contact table in the FROM clause by qualifying the member_id
--   columns in join condition of an ON subclause. The results set should
--   all have more than one value of each last name in the non-aggregated
--   result set, and sorted in ascending last_name order.
-- ----------------------------------------------------------------------
--  Uses: This does not use a WHERE clause but uses GROUP BY, HAVING,
--        and ORDER BY clauses.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL account_number      FORMAT A10  HEADING "Account|Number"
--  COL credit_card_number  FORMAT A19  HEADING "Credit|Card|Number"
--  COL last_name           FORMAT A12  HEADING "Last Name"
--  COL total_count         FORMAT 999  HEADING "Total|Count"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                           Credit
--                Account    Card                Total
--   Last Name    Number     Number              Count
--   ------------ ---------- ------------------- -----
--   Sweeney      B293-71447 3333-4444-5555-6666     3
--   Vizquel      B293-71446 2222-3333-4444-5555     2
--   Winn         B293-71445 1111-2222-3333-4444     2
--
--   3 rows selected.
-- ======================================================================
COL account_number      FORMAT A10  HEADING "Account|Number"
COL credit_card_number  FORMAT A19  HEADING "Credit|Card|Number"
COL last_name           FORMAT A12  HEADING "Last Name"
COL total_count         FORMAT 999  HEADING "Total|Count"
SELECT c.last_name
, m.account_number
, m.credit_card_number
, COUNT(c.last_name) AS "Total Count"
FROM member m
INNER JOIN contact c ON m.member_id=c.member_id
GROUP BY last_name, account_number, credit_card_number
HAVING COUNT (c.last_name) > 1
ORDER BY last_name;




-- ======================================================================
--  Step #5
--  -------
--   Write a query that returns the last_name from the contact table
--   and the city and state_province columns from the address table. 
--   Use an inner join with the using subclause on the contact_id
--   column that is shared between the tables. Filter the result set
--   by checking for a state_province value of only a case sensitive
--   'Utah', and return the set in ascending order based on the last_name
--   values in the SELECT-list.
-- ----------------------------------------------------------------------
--  Uses: This does use WHERE and ORDER BY clauses.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name       FORMAT A12  HEADING "Last Name"
--  COL city            FORMAT A12  HEADING "City"
--  COL state_province  FORMAT A8   HEADING "State|Province"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                             State
--   Last Name    City         Province
--   ------------ ------------ --------
--   Clinton      Provo        Utah
--   Gretelz      Provo        Utah
--   Moss         Provo        Utah
--   Royal        Provo        Utah
--   Smith        Spanish Fork Utah
--   
--   5 rows selected.
-- ======================================================================
COL last_name       FORMAT A12  HEADING "Last Name"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A8   HEADING "State|Province"
SELECT c.last_name
, a.city
, a.state_province
FROM address a
INNER JOIN contact c ON c.contact_id=a.contact_id
WHERE a.state_province IN ('Utah')
ORDER BY c.last_name;


-- ======================================================================
--  Step #6
--  -------
--   Write a query that returns the last_name from the contact table
--   and the area_code and telephone_number columns from the telephone
--   table. Use an inner join with the using subclause on the contact_id
--   column that is shared between the tables. Filter the result set
--   by checking for an area_code value of '801', and return the set in
--   ascending order based on the last_name values in the SELECT-list.
-- ----------------------------------------------------------------------
--  Uses: This uses WHERE and ORDER BY clauses.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL last_name  FORMAT A12  HEADING "Last Name"
--  COL telephone  FORMAT A14  HEADING "Telephone"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--   Last Name    TELEPHONE
--   ------------ -------------------
--   Clinton      (801) 423-1234
--   Gretelz      (801) 423-1236
--   Moss         (801) 423-1235
--   Royal        (801) 423-1237
--   Smith        (801) 423-1238
--
--   5 rows selected.
-- ======================================================================
COL last_name  FORMAT A12  HEADING "Last Name"
COL telephone  FORMAT A14  HEADING "Telephone"
SELECT c.last_name
, '(' || t.area_code || ')' || t.telephone_number AS Telephone
FROM telephone t 
INNER JOIN contact c ON c.contact_id=t.contact_id
WHERE t.area_code IN ('801')
ORDER BY c.last_name;


-- ======================================================================
--  Step #7
--  -------
--   Write a query that returns the following four columns from the 
--   common_lookup table, which is a table of tables:
--     - common_lookup_id
--     - common_lookup_context
--     - common_lookup_type
--     - common_lookup_meaning
--   Filter the result set by checking for a common_lookup_context value
--   of an uppercase 'ITEM' string and a common_lookup_type value that is
--   an uppercase string of either 'DVD_FULL_SCREEN', 'DVD_WIDE_SCREEN',
--   or 'BLU-RAY'. 
-- ----------------------------------------------------------------------
--  Uses: This uses a WHERE clause.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
--  COL common_lookup_context  FORMAT A30   HEADING "Common|Lookup Context"
--  COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
--  COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--      Common Common         Common           Common
--   Lookup ID Lookup Context Lookup Type      Lookup Meaning
--   --------- -------------- ---------------- ----------------
--        1010 ITEM           DVD_FULL_SCREEN  DVD: Full Screen
--        1011 ITEM           DVD_WIDE_SCREEN  DVD: Wide Screen
--        1015 ITEM           BLU-RAY          Blu-ray
--
--   3 rows selected.
-- ======================================================================
COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
COL common_lookup_context  FORMAT A30   HEADING "Common|Lookup Context"
COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
SELECT common_lookup_id
, common_lookup_context
, common_lookup_type
, common_lookup_meaning
FROM common_lookup
WHERE common_lookup_context = 'ITEM' AND (common_lookup_type = 'DVD_FULL_SCREEN' OR common_lookup_type = 'DVD_WIDE_SCREEN' OR common_lookup_type = 'BLU-RAY')
ORDER BY common_lookup_id;


-- ======================================================================
--  Step #8
--  -------
--   Write a query that returns the item_title and item_rating columns
--   in the SELECT-list from a join between the item and rental_item
--   tables that uses the item_id column. Use a WHERE clause that 
--   compares the item_type column value of each row to the result of
--   a subquery, which can be the right operand of an IN, =ANY, or
--   =SOME lookup operator inside a set of parentheses. You shoud use
--   the query you developed as a solution to Step #7 but only return
--   one column in the SELECT-list, which should be the common_lookup_id
--   column. Effectively, the subquery lets you lookup the item_type
--   column values by using their plain English text meaning. Order the
--   results by the item_title column values.
-- ----------------------------------------------------------------------
--  Uses: This uses WHERE and ORDER BY clauses and a scalar subquery.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL item_title   FORMAT A28  HEADING "Item Title"
--  COL item_rating  FORMAT A6   HEADING "Item|Rating"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--                                Item
--   Item Title                   Rating
--   ---------------------------- ------
--   Camelot                      G
--   Hook                         PG
--   I Remember Mama              NR
--   Star Wars I                  PG
--   Star Wars II                 PG
--   Star Wars III                PG13
--   The Hunt for Red October     PG
--
--   7 rows selected.
-- ======================================================================
COL item_title   FORMAT A28  HEADING "Item Title"
COL item_rating  FORMAT A6   HEADING "Item|Rating"
SELECT i.item_title
, i.item_rating
FROM item i
JOIN rental_item ri ON i.item_id=ri.item_id
WHERE item_type IN (SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_context = 'ITEM' AND (common_lookup_type = 'DVD_FULL_SCREEN' OR common_lookup_type = 'DVD_WIDE_SCREEN' OR common_lookup_type = 'BLU-RAY'))
ORDER BY i.item_title;


-- ======================================================================
--  Step #9
--  -------
--   Write a query that returns the following five columns from the 
--   common_lookup table, which is a table of tables:
--     - common_lookup_id
--     - common_lookup_context
--     - common_lookup_type
--     - common_lookup_meaning
--     - card_total, which is a count of the unique common_lookup_type
--       values
--   Use an inner join between the common_lookup and member table, and 
--   use the common_lookup_id value as the primary key and the 
--   credit_card_type column as the foreign key column as the columns
--   in an ON subclause of the FROM clause. 
--
--   Filter the result set by checking for a common_lookup_context value
--   of an uppercase 'MEMBER' string and a common_lookup_type value that is
--   an uppercase 'DISCOVER_CARD', 'MASTER_CARD', or 'VISA_CARD' string.
--   Assign an alias of card_total to the column that counts unique
--   common_lookup_type column values. Order by the ascending values of 
--   the common_lookup_meaning column values.
-- ----------------------------------------------------------------------
--  Uses: The IN, =ANY, or =SOME lookup operator.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
--  COL common_lookup_context  FORMAT A30   HEADING "Common|Lookup Context"
--  COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
--  COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
--  COL card_total             FORMAT 999   HEADING "Card|Total"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--      Common Common         Common           Common            Card
--   Lookup ID Lookup Context Lookup Type      Lookup Meaning   Total
--   --------- -------------- ---------------- ---------------- -----
--        1005 MEMBER         DISCOVER_CARD    Discover Card        3
--        1007 MEMBER         VISA_CARD        Visa Card            5
--
--   2 rows selected.
-- ======================================================================
COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
COL common_lookup_context  FORMAT A15   HEADING "Common|Lookup Context"
COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
COL card_total             FORMAT 999   HEADING "Card|Total"
SELECT c.common_lookup_id
, c.common_lookup_context
, c.common_lookup_type
, c.common_lookup_meaning
, COUNT (c.common_lookup_type) AS "Card|Total"
FROM common_lookup c
INNER JOIN member m ON c.common_lookup_id=m.credit_card_type
WHERE c.common_lookup_type IN ('DISCOVER_CARD', 'MASTER_CARD', 'VISA_CARD') 
AND c.common_lookup_context='MEMBER'
GROUP BY c.common_lookup_id
, c.common_lookup_context
, c.common_lookup_type
, c.common_lookup_meaning
ORDER BY c.common_lookup_meaning;


-- ======================================================================
--  Step #10
--  --------
--   HINT: This is the way to return the count of something that does
--         not exist. It is a very tricky stretch problem to complete,
--         and the key requires that the NVL function returns a zero
--         for a null value, which is then added by a SUM function as
--         a zero and reported as the card count of an unused card type.
--
--   Write a query that returns the following five columns from the 
--   common_lookup table, which is a table of tables:
--     - common_lookup_id
--     - common_lookup_context
--     - common_lookup_type
--     - common_lookup_meaning
--     - card_total, which is a count of the unique common_lookup_type
--       values derived by using a combination of a SUM and NVL function
--       for rows that return a null credit_card_type column from the
--       member table.
--   Use a left join between the common_lookup table on the left of 
--   the join keyword and the member table on the right of the join
--   keyword. You use the common_lookup_id value as the primary key and the 
--   credit_card_type column as the foreign key column as the columns
--   in an ON subclause of the FROM clause. 
--
--   Filter the result set by checking for a common_lookup_context value
--   of an uppercase 'MEMBER' string and a common_lookup_type value that is
--   an uppercase 'DISCOVER_CARD', 'MASTER_CARD', or 'VISA_CARD' string; and
--   a credit_card_type value that is NULL (or, there are three filters in 
--   the where clause of this query. Assign an alias of card_total 
--   to the column that sums a zero for a null credit_card_type column
--   value while meeting the other criteria. This is known as the right
--   relative complement of a left outer join. Order by the ascending
--   values of the common_lookup_meaning column values.
-- ----------------------------------------------------------------------
--  Uses: This uses WHERE, GROUP BY, and ORDER BY clauses, and a combination
--        of a SUM function of the result of a NVL function against the
--        credit_card_type column of the member table.
-- ----------------------------------------------------------------------
--  Uses: The following header for displaying the data.
--
--  COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
--  COL common_lookup_context  FORMAT A30   HEADING "Common|Lookup Context"
--  COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
--  COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
--  COL card_total             FORMAT 999   HEADING "Card|Total"
-- ----------------------------------------------------------------------
--  Anticipated Results
-- ----------------------------------------------------------------------
--      Common Common         Common           Common            Card
--   Lookup ID Lookup Context Lookup Type      Lookup Meaning   Total
--   --------- -------------- ---------------- ---------------- -----
--        1006 MEMBER         MASTER_CARD      Master Card          0
--
--   1 row selected.
-- ======================================================================
COL common_lookup_id       FORMAT 9999  HEADING "Common|Lookup ID"
COL common_lookup_context  FORMAT A16   HEADING "Common|Lookup Context"
COL common_lookup_type     FORMAT A16   HEADING "Common|Lookup Type"
COL common_lookup_meaning  FORMAT A16   HEADING "Common|Lookup Meaning"
COL card_total             FORMAT 999   HEADING "Card|Total"
SELECT c.common_lookup_id
, c.common_lookup_context
, c.common_lookup_type
, c.common_lookup_meaning
, (sum(NVL(credit_card_type, 0))) AS "Card|Total" 
FROM common_lookup c LEFT JOIN member m ON c.common_lookup_id=m.credit_card_type
WHERE c.common_lookup_type IN ('DISCOVER_CARD', 'MASTER_CARD', 'VISA_CARD') 
AND c.common_lookup_context='MEMBER' AND m.credit_card_type IS NULL
GROUP BY c.common_lookup_id
, c.common_lookup_context
, c.common_lookup_type
, c.common_lookup_meaning
ORDER BY c.common_lookup_meaning;



-- ----------------------------------------------------------------------
--  Close log file.
-- ----------------------------------------------------------------------
SPOOL OFF
