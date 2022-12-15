/*
Cleaning Data in SQL Queries
*/

Select *
From [Portfolio SQL].dbo.NashvilleHousing

-- Standardize Date Format

ALTER TABLE [Portfolio SQL].dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE [Portfolio SQL].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

