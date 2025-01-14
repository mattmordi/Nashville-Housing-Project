Business Report: Data Cleaning and Transformation for Nashville Housing Dataset
Objective:
The goal of this report is to provide an overview of the data cleaning and transformation process applied to the "Nashville Housing" dataset, as well as a summary of the results from these operations. The main tasks involve standardizing date formats, populating missing address data, splitting property addresses into individual columns, and standardizing certain categorical fields.

1. Standardizing the Sale Date Format
To ensure consistency in the sale date format, the following steps were performed:

Date Conversion: The SaleDate field was converted into a date format for uniformity.
Update Operations: The SaleDate column was updated using the CONVERT function to ensure proper date formatting.
sql
Copy code
-- Standardizing SaleDate format
select SaleDate, convert(date, SaleDate) from [Nashville Housing];
update [Nashville Housing] set SaleDate = CONVERT(date, SaleDate);
Adding New Column: A new column, SaleDateConverted, was added to store the standardized date values.
Data Population: The new column was populated with the converted SaleDate values.
sql
Copy code
alter table [Nashville Housing] add SaleDateConverted date;
update [Nashville Housing] set SaleDateConverted = CONVERT(date, SaleDate);
2. Populating Missing Property Address Data
A key part of the data cleaning process involved filling in missing property addresses. The following operations were performed:

Identifying Missing Addresses: The dataset was checked for rows where PropertyAddress is NULL.
Joining Tables for Data Recovery: Using the ParcelID, missing property addresses were filled in by joining the table with itself to find and use available addresses from other records.
sql
Copy code
-- Identify rows with missing property addresses
select * from [Nashville Housing] where PropertyAddress is null;

-- Populate missing addresses using joins
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

-- Update the missing addresses
update a set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;
3. Breaking Out Address Into Individual Columns (Address, City, State)
To facilitate easier analysis of addresses, the PropertyAddress field was broken down into separate columns for Address, City, and State:

Address Parsing: The PropertyAddress was split into individual components using string functions (e.g., SUBSTRING and CHARINDEX).
sql
Copy code
-- Breaking out Property Address into individual components
select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
       SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as CityState
from [Nashville Housing];
New Columns Creation: New columns were created for PropertySplitAddress (for the street address) and PropertySplitCity (for the city and state).
sql
Copy code
-- Create and populate PropertySplitAddress column
alter table [Nashville Housing] add PropertySplitAddress nvarchar(255);
update [Nashville Housing] set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

-- Create and populate PropertySplitCity column
alter table [Nashville Housing] add PropertySplitCity nvarchar(255);
update [Nashville Housing] set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
4. Standardizing Categorical Data (Sold As Vacant Field)
The dataset contained inconsistent categorical values in the SoldAsVacant field, with entries being 'Y' or 'N' for 'Yes' or 'No'. This field was standardized to ensure consistency across the dataset:

Value Mapping: The values 'Y' and 'N' were replaced with 'yes' and 'no', respectively.
sql
Copy code
-- Check distinct values and their counts in SoldAsVacant field
select distinct(SoldAsVacant) from [Nashville Housing];
select distinct(SoldAsVacant), COUNT(SoldAsVacant) from [Nashville Housing] group by SoldAsVacant;

-- Standardize 'Y' and 'N' values to 'yes' and 'no'
select SoldAsVacant,
       case when SoldAsVacant = 'Y' then 'yes'
            when SoldAsVacant = 'N' then 'no'
            else SoldAsVacant end
from [Nashville Housing];

-- Update SoldAsVacant field
update [Nashville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'yes'
                        when SoldAsVacant = 'N' then 'no'
                        else SoldAsVacant end;
Conclusion:
The following data transformations have been successfully implemented:

Sale Date Standardization: All date values in the SaleDate column have been standardized.
Missing Property Address Population: Missing property addresses were filled using available data from other records.
Address Breakdown: The PropertyAddress field was split into separate columns for easier analysis.
Categorical Data Standardization: The values in the SoldAsVacant field were standardized to improve consistency.
