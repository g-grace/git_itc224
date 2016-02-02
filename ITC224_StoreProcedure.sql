--Community Assist querites .... Creating Views & Procedures for reports
use CommunityAssist

-- Total Donations by year and month
-- Total Grants requested vs. Amount allocated
-- Total Grants by Service
-- How long the employees have works
-- Total Grants per recipient -- compared to lifetime maximums

CREATE VIEW vw_TotalDonations
AS
Select Year(DonationDate) as [Year],
month(DonationDate) as [Month],
Sum(DonationAmount) as [Total]
From Donation
Group by Year(DonationDate), 
		 Month(DonationDate)
go

Select* from vw_TotalDonations


 

Alter view vw_TotalGrantsByService
as
Select serviceName as [Service],
Sum(GrantAmount) as Requested,
Sum(GrantAllocation) as Allocated,
Sum(GrantAmount) - Sum(GrantAllocation) 
As [Difference]
From CommunityService cs
inner join ServiceGrant sg
on cs.ServiceKey=sg.ServiceKey
group by ServiceName

 

--Run Select, Run Create, Run Select*....OrderBy
Select * from vw_EmployeeInfo
Order By [Years With Charity] desc

 

Create view vw_GrantsAndServiceMaximums
As 
Select PersonFirstName [First Name],
PersonLastName [Last Name],
ServiceName [Service],
ServiceLifeTimeMaximum [Maximum],
Sum(GrantAllocation) Allocation
From Person p
Inner Join ServiceGrant sg
on p.PersonKey = sg.PersonKey
Inner Join  CommunityService cs
on cs.ServiceKey = sg.ServiceKey
Group By PersonFirstName,
PersonLastName,
ServiceName, 
ServiceLifeTimeMaximum



 
