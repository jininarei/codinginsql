-- Selecting fields
SELECT 
	`c`.`customer_id`,
    `c`.`sex_at_birth`,
	IF(`o`.`occupation`='?', 0, `o`.`occupation`) AS `occupation1`, -- Getting rid of '?' in column occupation
    IF(`et`.`employment_type`='?', 0, `et`.`employment_type`) AS `employment_type1`, -- Getting rid of '?' in column employment type
    `ed`.`education`,
    `c`.`completed_years_of_education`,
    `ms`.`marital_status`,
    `rh`.`relationship_in_household`,
    `r`.`race`,
    IF(`ct`.`country_code`='?', 0, `ct`.`country_code`) AS `original_country`, -- Getting rid of '?' in column country_code
    `invoice_summary`.`invoice_count`,
    `invoice_summary`.`avg_invoice_line`,
    `invoice_summary`.`total_qty_products`,
    `invoice_summary`.`max_total_qty_per_product`,
    `invoice_summary`.`avg_total_qty_per_product`,
	`invoice_summary`.`total_price`,
    `toc`.`type_of_client`
FROM `H_Retail`.`customer` AS `c`
-- Creating an inner join with customer and occupation tables
INNER JOIN
	`H_Retail`.`occupation` as `o`
	ON `c`.`occupation_id` = `o`.`occupation_id`
-- Creating an inner join with customer and employment_type tables
INNER JOIN
	`H_Retail`.`employment_type` AS `et`
	ON `c`.`employment_type_id` = `et`.`employment_type_id`
-- Creating an inner join with customer and education tables
INNER JOIN
	`H_Retail`.`education` AS `ed`
	ON `c`.`education_id` = `ed`.`education_id`
-- Creating an inner join with customer and marital_status tables
INNER JOIN
	`H_Retail`.`marital_status` AS `ms`
	ON `c`.`marital_status_id` = `ms`.`marital_status_id`
-- Creating an inner join with customer and relationship_in_household tables
INNER JOIN
	`H_Retail`.`relationship_in_household` AS `rh`
	ON `c`.`relationship_in_household_id` = `rh`.`relationship_in_household_id`
-- Creating an inner join with customer and race tables
INNER JOIN
	`H_Retail`.`race` AS `r`
	ON `c`.`race_id` = `r`.`race_id`
-- Creating an inner join with customer and country tables
INNER JOIN
	`H_Retail`.`country` AS `ct`
	ON `c`.`original_country_of_citizenship_id` = `ct`.`country_id`
-- Creating an inner join with tables customer and invoice_summary (subquery)
INNER JOIN
	(SELECT DISTINCT
		COUNT(`il`.`invoice_id`) AS `invoice_count`, 				-- Getting the total count of invoice_id
        AVG(`il`.`invoice_line`) AS `avg_invoice_line`, 			-- Getting the average of invoice_line
		ABS(SUM(`il`.`quantity`)) AS `total_qty_products`, 				-- Getting the absolute sum of all products
        ABS(MAX(`il`.`quantity`)) AS `max_total_qty_per_product`, 		-- Getting the absolute maximum quantity purchased for a certain product
		ABS(AVG(`il`.`quantity`)) AS `avg_total_qty_per_product`, 		-- Getting the absolute average quantity purchased for a certain product
        ABS(SUM(`il`.`quantity` * `il`.`unit_price`)) AS `total_price`,	-- Getting the absolute total price paid by a customer
		`i`.`customer_id`
	FROM
    `H_Retail`.`invoice_line` as `il`
    -- Creating an inner join with invoice_line and invoice10
    INNER JOIN 
    `H_Retail`.`invoice10` as `i`
    ON `il`.`invoice_id` = `i`.`invoice_id`
    -- grouping by customer_id and aliasing the new subquery as invoice_summary
    GROUP BY `i`.`customer_id`) AS `invoice_summary` ON `c`.`customer_id` = `invoice_summary`.`customer_id`
-- Creating a left join for customer and type_of_client_staging10 tables
LEFT JOIN
    `H_Retail`.`type_of_client_staging10` AS `toc`
    ON `c`.`customer_id` = `toc`.`customer_id`
-- Filtering the customer_id that are not zero 
WHERE `c`.`customer_id` <> 0 
-- ordering by total_qty_products in descending order
ORDER BY `total_qty_products` ASC;
;