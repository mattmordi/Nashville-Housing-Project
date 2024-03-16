
--Cleaning Data in SQL Queries 


 select *
from [nashville housing data cleaning].dbo.[Nashville Housing]




--Standardize Data format


select SaleDate, convert(date, SaleDate)
from [nashville housing data cleaning].[dbo].[Nashville Housing]

update [Nashville Housing]
set SaleDate = CONVERT(date, saledate)


alter table [nashville housing] 
add saledateconverted date;

update [nashville housing]
set SaleDateconverted = CONVERT(date,SaleDate)



--Populatate property Address Data


select *
from [nashville housing data cleaning].[dbo].[Nashville Housing]
where PropertyAddress is null
order by parcelid

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.propertyaddress, ISNULL(a.PropertyAddress, b.propertyaddress)
from [nashville housing data cleaning].dbo.[Nashville Housing] a
join [nashville housing data cleaning].dbo.[Nashville Housing] b
    on a.parcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null   

update a
set propertyaddress =  ISNULL(a.PropertyAddress, b.propertyaddress)
from [nashville housing data cleaning].dbo.[Nashville Housing] a
join [nashville housing data cleaning].dbo.[Nashville Housing] b
    on a.parcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null





--Breaking out address into individual columns (address, city, state)

select propertyaddress
from [nashville housing data cleaning].dbo.[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) as address
, substring (propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))as address
from [nashville housing data cleaning].dbo.[Nashville Housing]


alter table [nashville housing] 
add propertyspiltaddress nvarchar(255);

update [nashville housing]
set propertyspiltaddress = SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) 



alter table [nashville housing] 
add propertyspiltcity nvarchar(255);

update [nashville housing]
set propertyspiltcity = substring (propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))

select *
from [nashville housing data cleaning].dbo.[Nashville Housing]

--change Y and N TO Yes and No in "sold as vacant" field 

select distinct(SoldAsVacant)
from [nashville housing data cleaning].dbo.[Nashville Housing]


select distinct(SoldAsVacant), COUNT(soldASvacant)
from [nashville housing data cleaning].dbo.[Nashville Housing]
group by soldASvacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'yes'
       when SoldAsVacant = 'N' then 'yes'
	   ELSE SoldAsVacant
	   end
from [nashville housing data cleaning].dbo.[Nashville Housing]


update [Nashville Housing]
set soldASvacant = case when SoldAsVacant = 'Y' then 'yes'
       when SoldAsVacant = 'N' then 'yes'
	   ELSE SoldAsVacant
	   end



