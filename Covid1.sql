/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[new_vaccinations]
      ,[rolling_peop_vac]
  FROM [Project1].[dbo].[PopulVsVaccine]