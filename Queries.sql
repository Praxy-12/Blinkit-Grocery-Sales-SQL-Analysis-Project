--Rank Items by Sales Within Each Outlet
SELECT
	outlet_identifier, 
	item_identifier,
	sales,
	RANK() OVER (PARTITION BY outlet_identifier ORDER BY sales DESC) AS sales_rank
FROM grocery_sales
WHERE sales IS NOT NULL;


--Calculate Sales Growth Compared to Previous Year of Establishment
WITH yearly_sales AS (
SELECT
    outlet_establishment_year,
    SUM(sales) AS total_sales
FROM grocery_sales
GROUP BY outlet_establishment_year
)
SELECT 
	outlet_establishment_year,
	total_sales,
	LAG(total_sales) OVER (ORDER BY outlet_establishment_ year) AS prev_year_sales
	ROUND(total_sales - LAG(total_sales) OVER (ORDER BY outlet_establishment_year)) / LAG(total_sales) OVER (ORDER BY outlet_establishment_year) * 100, 2)
	AS sales_growth_pct
FROM yearly_sales;

-- Average Rating by Outlet Location and Fat Content
SELECT
	outlet_location_type,
	item_fat_content,
	AVG (rating) AS avg_rating,
	CASE
	WHEN AVG(rating) >= 4.5 THEN 'Excellent'
	WHEN AVG(rating) >= 3.5 THEN 'Good'
	ELSE 'Needs Improvement'
	END AS rating_ category
FROM grocery_sales
GROUP BY outlet_location _type, item_fat_content;

--Cumulative Sales Over Outlets Ordered by Establishment Year
SELECT
	outlet _identifier,
	outlet_establishment_ year,
	SUM(sales) OVER (ORDER BY outlet_ establishment year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS cumulative_sales
FROM grocery_sales
GROUP BY outlet identifier, outlet_establishment year;


--Items with Visibility Below Average by Outlet Type
SELECT
	outlet_type,
	item_identifier,
	item_visibility
FROM grocery_sales gs
WHERE item_visibility < (
	SELECT AVG(item _visibility)
	FROM grocery_sales
	WHERE outlet_type = gs.outlet_type
);

--Weighted Average Rating by Item Type
SELECT
	item_type,
	ROUND(SUM(rating * sales) / NULLIF(SUM(sales), 0), 2) AS weighted _avg rating
FROM grocery sales
GROUP BY item_type;


--Outlet Size-wise Average Sales and Item Weight Summary
SELECT
	outlet_size,
	AVG(sales) AS avg_sales,
	AVG(item_weight) AS avg weight,
	COUNT(DISTINCT outlet _identifier) AS outlet _count
FROM grocery_sales
GROUP BY outlet_size;
