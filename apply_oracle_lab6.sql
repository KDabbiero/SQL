-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab6.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
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
--   sql> @apply_oracle_lab6.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@/home/student/lab5/apply_oracle_lab5.sql

-- Open log file.
SPOOL apply_oracle_lab6.txt

-- Set the page size.
SET ECHO ON
SET PAGESIZE 999

-- ----------------------------------------------------------------------
--  Step #1 : Add two columns to the RENTAL_ITEM table.
-- ----------------------------------------------------------------------
SELECT  'Step #1' AS "Step Number" FROM dual;

-- ------------------------------------------ ----------------------------
--  Objective #1: Add the RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns
--                to the RENTAL_ITEM table. Both columns should use a
--                NUMBER data type in Oracle, and an int unsigned data
--                type.
-- ----------------------------------------------------------------------

-- --------------------------------------------------
--  Step 1: Write the ALTER statement.
-- --------------------------------------------------
ALTER TABLE rental_item
ADD rental_item_type NUMBER;

ALTER TABLE rental_item
ADD rental_item_price NUMBER;



-- ----------------------------------------------------------------------
--  Verification #1: Verify the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #2 : Create the PRICE table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Objective #1: Conditionally drop a PRICE table before creating a
--                PRICE table and PRICE_S1 sequence.
-- ----------------------------------------------------------------------

-- Conditionally drop PRICE table and sequence.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE PRICE CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE PRICE_S1';
  END LOOP;
END;
/

-- --------------------------------------------------
--  Step 1: Write the CREATE TABLE statement.
-- --------------------------------------------------
CREATE TABLE price
( price_id             NUMBER 
, item_id              NUMBER           CONSTRAINT nn_price_1 NOT NULL 
, price_type           NUMBER           
, active_flag          VARCHAR2(1)      CONSTRAINT nn_price_2 NOT NULL
, start_date           DATE             CONSTRAINT nn_price_3 NOT NULL
, end_date             DATE             
, amount               NUMBER           CONSTRAINT nn_price_4 NOT NULL
, created_by           NUMBER           CONSTRAINT nn_price_5 NOT NULL
, creation_date        DATE             CONSTRAINT nn_price_6 NOT NULL
, last_updated_by      NUMBER           CONSTRAINT nn_price_7 NOT NULL
, last_update_date     DATE             CONSTRAINT nn_price_8 NOT NULL
, CONSTRAINT pk_price PRIMARY KEY (price_id)
, CONSTRAINT fk_price_1 FOREIGN KEY (item_id) REFERENCES item (item_id)
, CONSTRAINT fk_price_2 FOREIGN KEY (price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, CONSTRAINT fk_price_4 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
, CONSTRAINT yn_price CHECK (active_flag IN ('Y','N')));


-- --------------------------------------------------
--  Step 2: Write the CREATE SEQUENCE statement.
-- --------------------------------------------------
CREATE SEQUENCE price_s1 START WITH 1001 NOCACHE;



-- ----------------------------------------------------------------------
--  Objective #2: Verify the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;
-- ----------------------------------------------------------------------
--  Objective #3: Verify the table constraints.
-- ----------------------------------------------------------------------
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- ----------------------------------------------------------------------
--  Step #3 : Insert new data into the model.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Objective #3: Rename ITEM_RELEASE_DATE column to RELEASE_DATE column,
--                insert three new DVD releases into the ITEM table,
--                insert three new rows in the MEMBER, CONTACT, ADDRESS,
--                STREET_ADDRESS, and TELEPHONE tables, and insert
--                three new RENTAL and RENTAL_ITEM table rows.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
--  Step #3a: Rename ITEM_RELEASE_DATE Column.
-- ----------------------------------------------------------------------
ALTER TABLE item
RENAME COLUMN item_release_date TO release_date;


-- ----------------------------------------------------------------------
--  Verification #3a: Verify the column name change.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        data_type
||      '('||data_length||')' AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #3b: Insert three rows in the ITEM table.
-- ----------------------------------------------------------------------
INSERT INTO item
(item_id
, item_barcode
, item_type 
, item_title
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date
, rating_id)
VALUES 
(item_s1.nextval
, '45656-12343'
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Tron'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE
, (SELECT rating_id
FROM rating
WHERE rating = 'PG'))
;

INSERT INTO item
(item_id
, item_barcode
, item_type 
, item_title
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date
, rating_id)
VALUES 
(item_s1.nextval
, '45656-12344'
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Napolean Dynamite'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE
, (SELECT rating_id
FROM rating
WHERE rating = 'PG'));

INSERT INTO item
(item_id
, item_barcode
, item_type 
, item_title
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date
, rating_id)
VALUES 
(item_s1.nextval
, '45656-12345'
, (SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Elysium'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE
, (SELECT rating_id
FROM rating
WHERE rating = 'PG'));


-- ----------------------------------------------------------------------
--  Verification #3b: Verify the column name change.
-- ----------------------------------------------------------------------
COLUMN item_title FORMAT A14
COLUMN today FORMAT A10
COLUMN release_date FORMAT A10 HEADING "RELEASE|DATE"
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- ----------------------------------------------------------------------
--  Step #3c: Insert three new rows in the MEMBER, CONTACT, ADDRESS,
--            STREET_ADDRESS, and TELEPHONE tables.
-- ----------------------------------------------------------------------
INSERT INTO member
(member_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(member_s1.nextval
, (SELECT common_lookup_id
FROM common_lookup WHERE common_lookup_type = 'GROUP')
, 'US00011'
, '6011 0000 0000 0078'
, (SELECT common_lookup_id
FROM common_lookup WHERE common_lookup_type = 'DISCOVER_CARD')
, (SELECT DISTINCT system_user_id
    FROM system_user 
    WHERE system_user_name IN ('DBA2'))
, SYSDATE
, (SELECT DISTINCT system_user_id
    FROM system_user 
    WHERE system_user_name IN ('DBA2'))
, SYSDATE);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval       
,(SELECT common_lookup_id
 FROM common_lookup WHERE common_lookup_context = 'CONTACT' AND common_lookup_type = 'CUSTOMER')       
,'Harry' 
,'Potter' 
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

 
INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_type = 'HOME')
,'Provo'
,'UT'
,'84604'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
  );
  
INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( street_address_s1.nextval
, address_s1.currval
,'900 E 300 N'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_context = 'MULTIPLE'
AND common_lookup_type = 'HOME')
,'USA'
,'801'
,'333-3333'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval       
,(SELECT common_lookup_id
 FROM common_lookup WHERE common_lookup_context = 'CONTACT' AND common_lookup_type = 'CUSTOMER')       
,'Ginny' 
,'Potter' 
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_type = 'HOME')
,'Provo'
,'UT'
,'84604'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);
  
INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( street_address_s1.nextval
, address_s1.currval
,'900 E 300 N'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);  

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_context = 'MULTIPLE'
AND common_lookup_type = 'HOME')
,'USA'
,'801'
,'333-3333'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval       
,(SELECT common_lookup_id
 FROM common_lookup WHERE common_lookup_context = 'CONTACT' AND common_lookup_type = 'CUSTOMER')       
,'Lily' 
,'Luna'
,'Potter' 
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

 
INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_type = 'HOME')
,'Provo'
,'UT'
,'84604'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);
  
INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( street_address_s1.nextval
, address_s1.currval
,'900 E 300 N'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_context = 'MULTIPLE'
AND common_lookup_type = 'HOME')
,'USA'
,'801'
,'333-3333'
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
,(SELECT system_user_id
FROM system_user
WHERE system_user_name = 'DBA2')
, SYSDATE
);
-- ----------------------------------------------------------------------
--  Verification #3c: Verify the three new CONTACTS and their related
--                    information set.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- ----------------------------------------------------------------------
--  Step #3d: Insert three new RENTAL and RENTAL_ITEM table rows..
-- ----------------------------------------------------------------------
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT contact_id
FROM contact
WHERE last_name = 'Potter'
AND first_name = 'Harry')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT r.rental_id
FROM rental r
, contact c
WHERE r.customer_id = c.contact_id
AND c.last_name = 'Potter'
AND c.first_name = 'Harry')
,(SELECT i.item_id
FROM item i
, common_lookup cl
WHERE i.item_title = 'Star Wars I'
AND i.item_subtitle = 'Phantom Menace'
AND i.item_type = cl.common_lookup_id
AND cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT r.rental_id
FROM rental r
, contact c
WHERE r.customer_id = c.contact_id
AND c.last_name = 'Potter'
AND c.first_name = 'Harry')
,(SELECT i.item_id
FROM item i
, common_lookup cl
WHERE i.item_title = 'Tron'
AND i.item_type = cl.common_lookup_id
AND cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT contact_id
FROM contact
WHERE last_name = 'Potter'
AND first_name = 'Ginny')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT r.rental_id
FROM rental r
, contact c
WHERE r.customer_id = c.contact_id
AND c.last_name = 'Potter'
AND c.first_name = 'Ginny')
,(SELECT i.item_id
FROM item i
, common_lookup cl
WHERE i.item_title = 'Napolean Dynamite'
AND i.item_type = cl.common_lookup_id
AND cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT contact_id
FROM contact
WHERE last_name = 'Potter'
AND first_name = 'Lily')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT r.rental_id
FROM rental r
, contact c
WHERE r.customer_id = c.contact_id
AND c.last_name = 'Potter'
AND c.first_name = 'Lily')
,(SELECT i.item_id
FROM item i
, common_lookup cl
WHERE i.item_title = 'Elysium'
AND i.item_type = cl.common_lookup_id
AND cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);
-- ----------------------------------------------------------------------
--  Verification #3d: Verify the three new CONTACTS and their related
--                    information set.
-- ----------------------------------------------------------------------
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Objective #4: Modify the design of the COMMON_LOOKUP table, insert
--                new data into the model, and update old non-compliant
--                design data in the model.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
--  Step #4a: Drop Indexes.
-- ----------------------------------------------------------------------
DROP INDEX common_lookup_n1;

DROP INDEX common_lookup_u2;



-- ----------------------------------------------------------------------
--  Verification #4a: Verify the unique indexes are dropped.
-- ----------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- ----------------------------------------------------------------------
--  Step #4b: Add three new columns.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup
ADD common_lookup_table VARCHAR2(30);

ALTER TABLE common_lookup
ADD common_lookup_column VARCHAR2(30);

ALTER TABLE common_lookup
ADD common_lookup_code VARCHAR2(2);



-- ----------------------------------------------------------------------
--  Verification #4b: Verify the unique indexes are dropped.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #4c: Migrate data subject to re-engineered COMMON_LOOKUP table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(1): Query the pre-change state of the table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(2): Query the post COMMON_LOOKUP_TABLE changes where the
--               COMMON_LOOKUP_CONTEXT is equal to the table names.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(2): Update the records.
-- ----------------------------------------------------------------------
UPDATE common_lookup 
SET common_lookup_table = common_lookup_context
WHERE NOT common_lookup_context = 'MULTIPLE';



-- ----------------------------------------------------------------------
--  Step #4c(2): Verify update of the records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(3): Query the post COMMON_LOOKUP_TABLE changes where the
--               COMMON_LOOKUP_CONTEXT is not equal to the table names.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(3): Update the records.
-- ----------------------------------------------------------------------
UPDATE common_lookup 
SET common_lookup_table = 'ADDRESS'
WHERE common_lookup_context = 'MULTIPLE';



-- ----------------------------------------------------------------------
--  Step #4c(3): Verify update of the records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(4): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Update the type records.
-- ----------------------------------------------------------------------
UPDATE common_lookup 
SET common_lookup_column = common_lookup_context || '_TYPE'
WHERE NOT common_lookup_context = 'MULTIPLE';



-- ----------------------------------------------------------------------
--  Step #4c(4): Verify update of the type records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(4): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Update the ADDRESS table type records.
-- ----------------------------------------------------------------------
UPDATE common_lookup 
SET common_lookup_column = 'ADDRESS' || '_TYPE'
WHERE common_lookup_contexT = 'MULTIPLE';




-- ----------------------------------------------------------------------
--  Step #4c(4): Verify update of the ADDRESS table type records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(5): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Alter the table and remove the unused column.
-- ----------------------------------------------------------------------
--ALTER TABLE common_lookup 
--DROP COLUMN common_lookup_context;



-- ----------------------------------------------------------------------
--  Step #4c(4): Verify modification of table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #4c(6): Insert new rows for the TELEPHONE table.
-- ----------------------------------------------------------------------
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_context
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
(common_lookup_s1.nextval
, ' '
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME'
, 'Home'
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_context
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
(common_lookup_s1.nextval
, ' '
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK'
, 'Work'
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- ----------------------------------------------------------------------
--  Step #4c(6): Verify insert of new rows to the TELEPHONE table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4d: Alter the table structure.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup 
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY common_lookup_table NOT NULL;

ALTER TABLE common_lookup
MODIFY common_lookup_column NOT NULL;


-- ----------------------------------------------------------------------
--  Step #4d: Verify changes to the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

-- ----------------------------------------------------------------------
--  Step #4d: Add unique index.
-- ----------------------------------------------------------------------
CREATE UNIQUE INDEX index_common_lookup
ON common_lookup (common_lookup_table, common_lookup_column, common_lookup_type);



-- ----------------------------------------------------------------------
--  Step #4d: Verify new unique index.
-- ----------------------------------------------------------------------
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
ON       ui.index_name = uic.index_name
AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('common_lookup')
ORDER BY ui.index_name
,        uic.column_position;

-- ----------------------------------------------------------------------
--  Step #4d: Update the foreign keys of the TELEPHONE table.
-- ----------------------------------------------------------------------
UPDATE telephone
SET telephone_type = (
SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_table = 'TELEPHONE'
AND common_lookup_type = 'HOME');
-- ----------------------------------------------------------------------
--  Step #4d: Verify the foreign keys of the TELEPHONE table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

SPOOL OFF
