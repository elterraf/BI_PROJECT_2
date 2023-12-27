USE [master]
GO

DROP DATABASE IF EXISTS [KGB_DW_2022];

CREATE DATABASE [KGB_DW_2022]
GO

USE [KGB_DW_2022]
GO

create table dim_date (
	sk_date int primary key,
	bk_period date not null, 
	full_name_date nvarchar(50) not null,
	day_number_of_week int not null,
	day_name nvarchar(50) not null ,
	month_name nvarchar(50) not null,
	month_number_of_year int not null,
	day_number_of_year int not null,
	week_number_of_year int not null,
	calendar_quarter int not null,
	calendar_year int not null,
	day_number_of_month int not null
	);
create table dim_product (
	sk_product int identity (1,1) primary key,
	bk_product int not null,
	productcategory nvarchar(50) not null,
	productsubcategory nvarchar (50) not null,
	productcategory_name nvarchar(50) not null,
	productsubcategory_name nvarchar(50) not null,
	standard_cost decimal (18,10) not null,
	colour nvarchar(50) null ,
	list_price decimal (18,10) null,
	size int null,
	dealer_price decimal (18,10) not null ,
	model_name nvarchar(50) not null,
	details nvarchar(250) not null ,
	product_start_date date not null,
	product_end_date date null,
	supplier nvarchar(50) not null,
	supplier_name nvarchar(50) not null,
	transportation_fees int not null
	);
create table dim_customer (
	sk_customer int identity (1,1) primary key,
	bk_customer int not null ,
	customer_name nvarchar(50) null,
	birth_date date null,
	marital_status nvarchar(50) null,
	gender nvarchar(50) null ,
	yearly_income int null,
	number_children_at_home int null,
	occupation nvarchar(50)null ,
	number_cars_owned int null
	);
create table dim_store (
	sk_store int identity(1,1) primary key,
	bk_store nvarchar(50) not null,
	area_m2 decimal(18,10) not null,
	rent_per_month decimal(18,10) , 
	staff_instore int not null,
	expert_staff int not null,
	average_staff_salary_month int not null,
	accessibility_1to5 int not null,
	showcase_quality_level_1to5 int not null,
	active int null
	);
create table dim_territory (
	sk_territory int identity(1,1) primary key,
	bk_territory nvarchar(50) not null,
	region nvarchar(50),
	group_division nvarchar(50) ,
	country nvarchar(50) ,
	city_name nvarchar(50) null,
	bike_lanes_km decimal(18,10) null,
	protected_bike_lanes_km decimal(18,10)  null,
	);
create table fact_sales (
	fk_date int not null foreign key references dim_date(sk_date),
	fk_product int not null foreign key references dim_product(sk_product),
	fk_customer int not null foreign key references dim_customer(sk_customer),
	fk_store int foreign key references dim_store(sk_store),
	fk_territory int foreign key references dim_territory(sk_territory),
	sales_order_number nvarchar(100) not null,
	order_quantity int not null,
	unit_price decimal(15,3) not null,
	product_standard_cost decimal(10,3) not null,
	sales_amount decimal(15,5) not null,
	tax_amount_unit decimal(10,3) not null,
	tax_amount decimal(15,3) not null,
	freight decimal(10,5) not null, 
	total_cost decimal(15,5) not null,
	profit decimal(15,5)  null,
	CONSTRAINT PK_Fact_Sales PRIMARY KEY (sales_order_number, fk_date, fk_product, fk_store, fk_customer, fk_territory)
	);

	
	

