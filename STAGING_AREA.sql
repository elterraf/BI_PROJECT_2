USE [master]
GO

/* Remove the database, if it already exists, so it's safe to create it! */
DROP DATABASE IF EXISTS [KGB_STG_2022];

CREATE DATABASE [KGB_STG_2022]
GO

USE [KGB_STG_2022]
GO

/* the STAGING dimension table for date: stg_dim_date */
/* In this case, it will be EXACTLY the same as in the DW */

create table stg_dim_date (
	sk_date int not null primary key,
	bk_period date not null, 
	full_name_date nvarchar(50) not null,
	day_number_of_week int  not null,
	day_name nvarchar(50) not null,
	month_name nvarchar(50) not null,
	month_number_of_year int  not null,
	day_number_of_year int not null ,
	week_number_of_year int not null ,
	calendar_quarter int not null,
	calendar_year int not null,
	day_number_of_month int not null
	);

/* the STAGING dimension table for product: stg_dim_product */
/* The SCD fields will be developed later; they're not required for STG.*/

create table stg_dim_product (
	bk_product int primary key ,
	productcategory nvarchar(50) not null ,
	productsubcategory nvarchar(50) not null ,
	productcategory_name nvarchar(50) not null,
	productsubcategory_name nvarchar(50) not null ,
	standard_cost decimal (18,10)  not null,
	colour nvarchar(50) null ,
	list_price decimal (18,10) not null ,
	size int null,
	dealer_price decimal (18,10) not null,
	model_name nvarchar(100) not null,
	details nvarchar(350) not null,
	product_start_date date not null,
	product_end_date date not null,
	supplier nvarchar(50) not null,
	supplier_name nvarchar(50) not null,
	transportation_fees int not null
	);

/* the STAGING dimension table for customer: stg_dim_customer */

create table stg_dim_customer (
	bk_customer int primary key,
	customer_name nvarchar(50) null,
	birth_date date null,
	marital_status nvarchar(50) null,
	gender nvarchar(50) null,
	yearly_income int null,
	number_children_at_home int null,
	occupation nvarchar(50) null,
	number_cars_owned int null 
	);


/* the STAGING dimension table for store: stg_dim_store */
/* The SCD fields will be developed later; they're not required for STG.*/

create table stg_dim_store (
	bk_store nvarchar(50) primary key,
	area_m2 decimal(18,10) not null,
	rent_per_month decimal(18,10) not null,
	staff_instore int not null,
	expert_staff int not null,
	average_staff_salary_month int not null,
	accessibility_1to5 int not null,
	showcase_quality_level_1to5 int not null,
	);


/* the STAGING dimension table for territory: stg_dim_territory */

create table stg_dim_territory (
	bk_territory nvarchar(50) primary key,
	territorysubcategory nvarchar(50) not null,
	territory_name nvarchar(50) not null,
	region nvarchar(50) not null,
	group_division nvarchar(50) not null,
	country nvarchar(50) not null,
	city_name nvarchar(50) not null,
	bike_lanes_km decimal(18,10) null,
	protected_bike_lanes_km decimal(18,10) null,
	);


/* The STG Facts Table for Sales: stg_fact_sales
 * The combination of the FKs make up the PK,
 * and there are NO RELATIONSHIPS in the STG database!
 */

create table stg_fact_sales (
	fk_date int not null,
	fk_product int not null,
	fk_customer int not null,
	fk_store nvarchar(50) not null,
	fk_territory nvarchar(50) not null,
	sales_order_number nvarchar(100) not null,
	order_quantity int not null,
	unit_price decimal(15,3) not null,
	product_standard_cost decimal(10,3) not null,
	sales_amount decimal(15,5) not null,
	tax_amount_unit decimal(10,3) not null,
	tax_amount decimal(15,3) not null,
	freight decimal(10,5) not null, 
	total_cost decimal(15,5) not null,
	profit as (unit_price-product_standard_cost)*order_quantity,
	constraint pk_fact_sales primary key (
		fk_date asc,
		fk_product,
		fk_customer,
		fk_store,
		fk_territory,
		sales_order_number 
		)
	);

create table log_stg_etl(
LOGID int identity(1,1) not null primary key,
ETL_NAME nvarchar (50) not null,
ETL_DESC nvarchar (50) not null
)
