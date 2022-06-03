USE `H_Accounting`;

-- Markdown- profit and loss
 
-- Running this stored procedure will produce a Profit and Loss (P&L) statement. 
-- The user can input a year from the database attached and it will provide the current year’s P&L statement, 
-- the previous year’s statement, and the change between the current year and previous year. 
-- This stored procedure starts by declaring the variables using a double data type, which is the number of digits that is specified in size. 
-- Then, the stored procedure works to calculate the revenue, cost of goods sold, other income, other expenses and selling expenses. 
-- Additionally, it does this a second time for the previous calendar year. 

-- The stored procedure creates a table with the columns: profit loss line number, the label, amount, previous year’s amount, and the percentage change.
--  Then, it inserts these lines into the report. The percentage change is calculated in the insert into function by taking the previous year,
--  subtracting the current year, and dividing by the current year. Then, it is multiplied by 100 to get a percentage. 
--  The function also utilizes the absolute value to ensure that if there are negative values it would not modify the final percentage. 

-- Finally, the user can call this function by inputting the database and calling the name of the function and inputting only one year. 
-- It is programmed to calculate the previous year. Any questions about this function, feel free to contact team 14 for technical support. 

DROP PROCEDURE IF EXISTS `H_Accounting`.`pl_jgarcia`;
-- The tpycal delimiter for Stored procedures is a double dollar sign
DELIMITER $$

CREATE PROCEDURE `H_Accounting`.`pl_jgarcia`(`varCalendarYear` SMALLINT)
BEGIN
  
	-- We receive as an argument the year for which we will calculate the revenues
    -- This value is stored as an 'YEAR' type in the variable `varCalendarYear`
    -- To avoid confusion among which are fields from a table vs. which are the variables
    -- A good practice is to adopt a naming convention for all variables
    -- In these lines of code we are naming prefixing every variable as "var"
  
	-- We can define variables inside of our procedure
	DECLARE `varTotalRevenues` DOUBLE DEFAULT 0;
	DECLARE `varTotalCOGS` DOUBLE DEFAULT 0;
	DECLARE `varSellingExpenses` DOUBLE DEFAULT 0;
    DECLARE `varOtherExpenses` DOUBLE DEFAULT 0;
    DECLARE `varOtherIncome` DOUBLE DEFAULT 0;
    
	DECLARE `varTotalRevenues2` DOUBLE DEFAULT 0;
	DECLARE `varTotalCOGS2` DOUBLE DEFAULT 0;
	DECLARE `varSellingExpenses2` DOUBLE DEFAULT 0;
    DECLARE `varOtherExpenses2` DOUBLE DEFAULT 0;
    DECLARE `varOtherIncome2` DOUBLE DEFAULT 0;
    
	--  We calculate the value of the total revenues for the given year and we store it into the variable we just declared
    SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00)  INTO `varTotalRevenues`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '401%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear`
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
    
    --  We calculate the value of the total cost of goods sold for the given year and we store it into the variable we just declared
     SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varTotalCOGS`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '501%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear`
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
   
    --  We calculate the value of the selling expenses for the given year and we store it into the variable we just declared  
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varSellingExpenses`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '601%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear`
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
        
	--  We calculate the value of the other expenses for the given year and we store it into the variable we just declared  
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varOtherExpenses`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '701%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear`
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
        
	--  We calculate the value of the other income for the given year and we store it into the variable we just declared   
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varOtherIncome`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '702%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear`
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
      
   -- previous year P&L   
   --  We calculate the value of the total revenues for the previous year and we store it into the variable we just declared   
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00)  INTO `varTotalRevenues2`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '401%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
    
	--  We calculate the value of the total costs of goods sold for the previous year and we store it into the variable we just declared   
     SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varTotalCOGS2`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '501%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
    
	--  We calculate the value of the selling expenses for the previous year and we store it into the variable we just declared
		SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varSellingExpenses2`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '601%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
        
	--  We calculate the value of the other expenses for the previous year and we store it into the variable we just declared
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varOtherExpenses2`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '701%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;
        
	--  We calculate the value of the other income for the previous year and we store it into the variable we just declared  
	SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00)  INTO `varOtherIncome2`
		FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
		LEFT JOIN `H_Accounting`.`account` AS `a` ON `a`.`account_id` = `jeli`.`account_id`
		INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
		WHERE `a`.`account_code` LIKE '702%' 
		AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1
        AND `a`.`profit_loss_section_id` <> 0
        AND `je`.`closing_type` = 0;  
      
    -- Let's drop the `tmp` table where we will input the revenue
	-- The IF EXISTS is important. Because if the table does not exist the DROP alone would fail
	-- A store procedure will stop running whenever it faces an error. 
	DROP TABLE IF EXISTS `H_Accounting`.`jgarcia_tmp`;
  
	-- Now we are certain that the table does not exist, we create with the columns that we need
	CREATE TABLE `H_Accounting`.`jgarcia_tmp`
		(`profit_loss_line_number` INT, 
		 `label` VARCHAR(50), 
	     `amount` VARCHAR(50),
         `amount_previous_year` VARCHAR(50),
         `percentage_change` VARCHAR(50)
		);
  
  -- Now we insert the a header for the report
    INSERT INTO `H_Accounting`.`jgarcia_tmp` 
		   (`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES (1, 'PROFIT AND LOSS STATEMENT', "In '000s of USD","In '000s of USD","%_CHANGE");
  
	-- Next we insert an empty line to create some space between the header and the line items
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
		   (`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(2, '', '', '', '');
    
	-- Finally we insert the Total Revenues with its value
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(3, 'Total Revenues', FORMAT(`varTotalRevenues` / 1000, 2),FORMAT(`varTotalRevenues2` / 1000,2), 
		IF(`varTotalRevenues` = 0, 0, FORMAT(((`varTotalRevenues2`-`varTotalRevenues`)/`varTotalRevenues`)*100,2)));
        
    -- We insert the Total Costs of Goods Sold with its value
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(4, 'Total Costs of Goods Sold', FORMAT(`varTotalCOGS` / 1000, 2),FORMAT(`varTotalCOGS2` / 1000,2), 
		IF(`varTotalCOGS` = 0, 0, FORMAT(((`varTotalCOGS2`-`varTotalCOGS`)/`varTotalCOGS`)*100,2)));
    
    -- We compute for the Gross Profit
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(5, 'Gross Profit', FORMAT((`varTotalRevenues` - `varTotalCOGS`) / 1000, 2),
		FORMAT((`varTotalRevenues2` - `varTotalCOGS2`) / 1000,2),
		IF((`varTotalRevenues` - `varTotalCOGS`) = 0, 0, FORMAT((((`varTotalRevenues2` - `varTotalCOGS2`)-(`varTotalRevenues` - `varTotalCOGS`))/(`varTotalRevenues` - `varTotalCOGS`))*100,2)));
	
    -- We compute for the Total Expenses
    INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
 		VALUES 	(6, 'Total Expenses', FORMAT((`varSellingExpenses` + `varOtherExpenses`)/ 1000, 2),FORMAT((`varSellingExpenses2` + `varOtherExpenses2`)/1000,2),
        IF((`varSellingExpenses` + `varOtherExpenses`) = 0, 0, FORMAT((((`varSellingExpenses2` + `varOtherExpenses2`)-(`varSellingExpenses` + `varOtherExpenses`))/(`varSellingExpenses` + `varOtherExpenses`))*100,2)));
    
    -- Next we insert a label for breakdown of expenses and empty lines 
    INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(7, 'Breakdown of Expenses:', ' ', ' ', ' ');
    
    -- We insert the Selling Expenses with its value
    INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(8, 'Selling Expenses',  FORMAT(`varSellingExpenses` / 1000, 2), FORMAT(`varSellingExpenses2` / 1000,2),
        IF(`varSellingExpenses` = 0, 0, FORMAT(((`varSellingExpenses2`-`varSellingExpenses`)/`varSellingExpenses`)*100,2)));
    
    -- We insert the Other Expenses with its value
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(9, 'Other Expenses', FORMAT(`varOtherExpenses` / 1000, 2), FORMAT(`varOtherExpenses2` / 1000,2),
        IF(`varOtherExpenses` = 0, 0, FORMAT(((`varOtherExpenses2`-`varOtherExpenses`)/`varOtherExpenses`)*100,2)));
    
    -- We insert the Other Income with its value
    INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(10, 'Other Income', FORMAT(`varOtherIncome` / 1000, 2), FORMAT(`varOtherIncome2` / 1000,2),
        IF(`varOtherIncome` = 0, 0, FORMAT(((`varOtherIncome2`-`varOtherIncome`)/`varOtherIncome`)*100,2)));
    
    -- We compute for the Net profit
	INSERT INTO `H_Accounting`.`jgarcia_tmp`
			(`profit_loss_line_number`, `label`, `amount`, `amount_previous_year`,`percentage_change`)
		VALUES 	(11, 'Net Profit', FORMAT((`varTotalRevenues` - (`varSellingExpenses` + `varOtherExpenses` + `varTotalCOGS` + `varOtherIncome`)) / 1000, 2),
		FORMAT((`varTotalRevenues2` - (`varSellingExpenses2` + `varOtherExpenses2` + `varTotalCOGS2` + `varOtherIncome2`)) / 1000,2),
		IF(`varTotalRevenues` - (`varSellingExpenses` + `varOtherExpenses` + `varTotalCOGS` + `varOtherIncome`) = 0, 0, 
		FORMAT(((((`varTotalRevenues2` - (`varSellingExpenses2` + `varOtherExpenses2` + `varTotalCOGS2` + `varOtherIncome2`)) / 1000)-(`varTotalRevenues` - (`varSellingExpenses` + `varOtherExpenses` + `varTotalCOGS` + `varOtherIncome`))/1000)/((`varTotalRevenues` - (`varSellingExpenses` + `varOtherExpenses` + `varTotalCOGS` + `varOtherIncome`)) / 1000))*100,2)));
    
 END $$
 DELIMITER ;
# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;

-- B/S
USE `H_Accounting`;

-- Markdown- Balance Sheet 

-- Running this stored procedure will produce a Balance sheet. The user can input a year from the database attached and 
-- it will provide the current year’s Balance Sheet, the previous year’s Balance Sheet, and the change between the current year and previous year.
-- This stored procedure starts by taking declaring the variables using a double data type, which is the number of digits that is specified in size. 
-- Then, the stored procedure works to calculate the current assets, fixed assets, current liabilities, and equity. 
-- Additionally, it does this a second time for the previous calendar year. 

-- The stored procedure creates a table with the columns: profit loss line number, the label, amount, previous year’s amount, and the percentage change.
-- Then, it inserts these lines into the report. The percentage change is calculated in the insert into function by taking the previous year, 
-- subtracting the current year, and dividing by the current year. Then, it is multiplied by 100 to get a percentage. 
-- The function also utilizes the absolute value to ensure that if there are negative values it would not modify the final percentage. 

-- Finally, the user can call this function by inputting the database and calling the name of the function and inputting only one year. 
-- It is programmed to calculate the previous year. Any questions about this function, feel free to contact team 14 for technical support. 


DROP PROCEDURE IF EXISTS `H_Accounting`.`bs_jgarcia`;

-- The tpycal delimiter for Stored procedures is a double dollar sign
DELIMITER $$

CREATE PROCEDURE `H_Accounting`.`bs_jgarcia`(`varCalendarYear` SMALLINT)
BEGIN

	-- We receive as an argument the year for which we will calculate the revenues
    -- This value is stored as an 'YEAR' type in the variable `varCalendarYear`
    -- To avoid confusion among which are fields from a table vs. which are the variables
    -- A good practice is to adopt a naming convention for all variables
    -- In these lines of code we are naming prefixing every variable as "var"
    
    -- We can define variables inside of our procedure
	DECLARE `varCurrentAssets` DOUBLE DEFAULT 0;
	DECLARE `varFixedAssets` DOUBLE DEFAULT 0;
  	DECLARE `varCurrentLiabilities` DOUBLE DEFAULT 0;
    DECLARE `varEquity` DOUBLE DEFAULT 0;

	DECLARE `varCurrentAssets2` DOUBLE DEFAULT 0;
	DECLARE `varFixedAssets2` DOUBLE DEFAULT 0;
  	DECLARE `varCurrentLiabilities2` DOUBLE DEFAULT 0;
    DECLARE `varEquity2` DOUBLE DEFAULT 0;
 
--  We calculate the value of the current assets for the given year and we store it into the variable we just declared
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00) INTO `varCurrentAssets`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
    WHERE  `se`.`statement_section_code` = 'CA'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear`;
    
 --  We calculate the value of the fixed assets for the given year and we store it into the variable we just declared   
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00) INTO `varFixedAssets`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	WHERE `se`.`statement_section_code` = 'FA'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear`;

 --  We calculate the value of the current liabilities for the given year and we store it into the variable we just declared       
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00) INTO `varCurrentLiabilities`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	WHERE `se`.`statement_section_code` = 'CL'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear`;

 --  We calculate the value of the equity for the given year and we store it into the variable we just declared     
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00) INTO `varEquity`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	AND `se`.`statement_section_code` = 'EQ'
    AND YEAR(`je`.`entry_date`) = `varCalendarYear`;
    
    
-- previous year 
--  We calculate the value of the current assets for the previous year and we store it into the variable we just declared 
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00) INTO `varCurrentAssets2`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
    WHERE  `se`.`statement_section_code` = 'CA'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear` -1;
    
--  We calculate the value of the fixed assets for the previous year and we store it into the variable we just declared     
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`debit`, 0)) - SUM(COALESCE(`jeli`.`credit`, 0)), 2),0.00) INTO `varFixedAssets2`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	WHERE `se`.`statement_section_code` = 'FA'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear` -1;
    
--  We calculate the value of the current liabilities for the previous year and we store it into the variable we just declared  
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00) INTO `varCurrentLiabilities2`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	WHERE `se`.`statement_section_code` = 'CL'
    AND `je`.`debit_credit_balanced` = 1
	AND YEAR(`je`.`entry_date`) = `varCalendarYear` - 1;
    
--  We calculate the value of the equity for the previous year and we store it into the variable we just declared  
SELECT IFNULL(ROUND(SUM(COALESCE(`jeli`.`credit`, 0)) - SUM(COALESCE(`jeli`.`debit`, 0)), 2),0.00) INTO `varEquity2`
	FROM `H_Accounting`.`journal_entry_line_item` AS `jeli`
	INNER JOIN `H_Accounting`.`account`AS `a` ON `a`.`account_id` = `jeli`.`account_id`
	INNER JOIN `H_Accounting`.`journal_entry` AS `je` ON  `je`.`journal_entry_id`= `jeli`.`journal_entry_id`
	INNER JOIN `H_Accounting`.`statement_section` AS `se` ON `se`.`statement_section_id` = `a`.`balance_sheet_section_id`
	AND `se`.`statement_section_code` = 'EQ'
    and YEAR(`je`.`entry_date`) = `varCalendarYear` - 1;
    
     -- Let's drop the `tmp` table where we will input the revenue
	-- The IF EXISTS is important. Because if the table does not exist the DROP alone would fail
	-- A store procedure will stop running whenever it faces an error. 
	DROP TABLE IF EXISTS `H_Accounting`.`kwebster2020_tmp`;
  
	-- Now we are certain that the table does not exist, we create with the columns that we need
	CREATE TABLE `H_Accounting`.`kwebster2020_tmp`
		(`balance_line_number` INT, 
		 `label` VARCHAR(50), 
	     `amount` VARCHAR(50),
         `amount_previous_year` VARCHAR(50),
         `percentage_change` VARCHAR(50)
		);
        
 -- Now we insert the a header for the report
INSERT INTO `H_Accounting`.`kwebster2020_tmp` 
		   (`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES (1, 'BALANCE SHEET', "In '000s of USD", "In '000s of USD", "%_CHANGE");
  
-- Next we insert an empty line to create some space between the header and the line items
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
				(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(2, '', '', '','');
    
-- Finally we insert the Current assets with its value
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(3, 'Current Assets', FORMAT(`varCurrentAssets` / 1000, 2), FORMAT(`varCurrentAssets2` / 1000, 2), 
			IF(`varCurrentAssets` = 0, 0, FORMAT(((`varCurrentAssets2`-ABS(`varCurrentAssets`))/ABS(`varCurrentAssets`))*100, 2)));
    
-- We insert the Fixed assets with its value
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(4, 'Fixed Assets', FORMAT(`varFixedAssets` / 1000, 2), FORMAT(`varFixedAssets2` / 1000, 2),
    IF(`varFixedAssets` = 0, 0, FORMAT(((`varFixedAssets2`-ABS(`varFixedAssets`))/ABS(`varFixedAssets`))*100, 2)));
  
-- We insert the Current Liabilities with its value
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(5, 'Current Liabilities', FORMAT((`varCurrentLiabilities`) / 1000, 2),FORMAT((`varCurrentLiabilities2`) / 1000, 2),
    IF(`varCurrentLiabilities` = 0, 0, FORMAT(((`varCurrentLiabilities2`-ABS(`varCurrentLiabilities`))/ABS(`varCurrentLiabilities`))*100, 2)));
	
-- We insert the Equity with its value
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(6, 'Equity', FORMAT(`varEquity` / 1000, 2), FORMAT(`varEquity2` / 1000, 2),
    IF(`varEquity` = 0, 0, FORMAT(((`varEquity2`-ABS(`varEquity`))/ABS(`varEquity`))*100, 2)));
    
-- Next we insert a label for balance breakdown and empty lines 
INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(7, 'Balance breakdown:', ' ', ' ',' ');
  
-- Next we insert a label for total assets and its formula 
    INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(8, 'Total Assets=', 'Liabilities + Equity:', ' ', ' ');
    
-- We compute for the value of total assets and ensure that it is equal to the liabilities plus equity
	INSERT INTO `H_Accounting`.`kwebster2020_tmp`
			(`balance_line_number`, `label`, `amount`, `amount_previous_year`, `percentage_change`)
	VALUES 	(9, FORMAT((`varCurrentAssets` + `varFixedAssets`)/1000,2), FORMAT((`varCurrentLiabilities` + `varEquity`)/1000, 2), 
    FORMAT((`varCurrentAssets2` + `varFixedAssets2`)/1000, 2),
    IF((`varCurrentAssets2` + `varFixedAssets2`) = 0, 0, FORMAT(((((`varCurrentAssets2` + `varFixedAssets2`) - ABS((`varCurrentAssets` + `varFixedAssets`))))/ABS((`varCurrentAssets` + `varFixedAssets`)))*100, 2)));

    END $$
DELIMITER ;
# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;

-- calling the function for profit and loss statement
CALL `H_Accounting`.`pl_jgarcia` (2019);

-- displaying the profit and loss statement
SELECT * FROM `H_Accounting`.`jgarcia_tmp`;

-- calling the function for balance sheet
CALL `H_Accounting`.`bs_jgarcia`(2019);

-- displaying the balance sheet
SELECT * FROM `H_Accounting`.`kwebster2020_tmp`;


    
    









