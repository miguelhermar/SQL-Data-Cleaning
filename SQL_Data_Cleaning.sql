/*
Cleaning Data in SQL Queries
*/

Select *
From [Portfolio SQL].dbo.NashvilleHousing;

-- Standardize Date Format

ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data (using self join)

SELECT *
FROM [Portfolio SQL].dbo.NashvilleHousing
-- WHERE PropertyAddress is NULL
ORDER BY ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM [Portfolio SQL].dbo.NashvilleHousing a
JOIN [Portfolio SQL].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a  --Updating Original Table using its alias a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio SQL].dbo.NashvilleHousing a
JOIN [Portfolio SQL].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Portfolio SQL].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM [Portfolio SQL].dbo.NashvilleHousing;

ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));



SELECT * FROM [Portfolio SQL].dbo.NashvilleHousing;



SELECT OwnerAddress FROM [Portfolio SQL].dbo.NashvilleHousing;


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Portfolio SQL].dbo.NashvilleHousing;



ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


SELECT * FROM [Portfolio SQL].dbo.NashvilleHousing;



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio SQL].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 
FROM [Portfolio SQL].dbo.NashvilleHousing;

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM [Portfolio SQL].dbo.NashvilleHousing
--ORDER BY ParcelID;
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM [Portfolio SQL].dbo.NashvilleHousing;


ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;