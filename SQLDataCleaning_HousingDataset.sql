/*
Cleaning Data in SQL Queries
*/


Select *
From Portfolio_Project.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate, CONVERT(Date,SaleDate)
From Portfolio_Project.dbo.NashvilleHousing


Update NashvilleHousing
SET saledate2 = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add saledate2 Date;

Update NashvilleHousing
SET saledate2 = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Drop column SaleDateConverted;
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Portfolio_Project.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

--Self Join on Parcel Id and distinct UniqueId to find address of NULLS
-- ISNULL() to populate nulls
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Using alias to update*
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project.dbo.NashvilleHousing a
JOIN Portfolio_Project.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAddress into Individual Columns (Address, City) using CHARINDEX


Select PropertyAddress
From Portfolio_Project.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Portfolio_Project.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertyAddressSplit Nvarchar(255);

Update NashvilleHousing
SET PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertyCitySplit Nvarchar(255);

Update NashvilleHousing
SET PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select PropertyAddressSplit, PropertyCitySplit
from Portfolio_Project..NashvilleHousing

--------------------------------------------------------------------------------------------------------
-----Breaking OwnerAddress into individual columns (Address, City, State)

--Using PARSENAME()

Select OwnerAddress
From Portfolio_Project.dbo.NashvilleHousing

Select PARSENAME(replace(OwnerAddress, ',', '.'), 1) as State,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(replace(OwnerAddress, ',', '.'), 3) as Address
From Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddressSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressSplit = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerCitySplit Nvarchar(255);

Update NashvilleHousing
SET OwnerCitySplit = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerStateSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerStateSplit = PARSENAME(replace(OwnerAddress, ',', '.'), 1) 

Select *
From Portfolio_Project.dbo.NashvilleHousing


------------------------------------------------------------------------------------
---- Changing y , n to yes and no in col SoldAsVacant

Select Distinct(SoldAsVacant) , Count(SoldAsVacant)
From Portfolio_Project.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From Portfolio_Project.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

---------------------------------------------------------------------------------------
----Removing Duplicates

--USING CTE ( Common Table Expression )
With rownumCTE as(
Select *,
ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference,
				 LandValue
				 Order by
				 UniqueID) as row_num

From Portfolio_Project.dbo.NashvilleHousing
)
Delete 
From rownumCTE
where row_num>1

With rownumCTE as(
Select *,
ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference,
				 LandValue
				 Order by
				 UniqueID) as row_num

From Portfolio_Project.dbo.NashvilleHousing
)
Select *
From rownumCTE
where row_num>1


-------------------------------------------------------------------------------------------
-----Deleting Unused Columns

Alter table NashvilleHousing
Drop column PropertyAddress, SaleDate, OwnerAddress 

select *
from Portfolio_Project..NashvilleHousing

