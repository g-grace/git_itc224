-- Summary how many buses are assigned to each bus barn
-- Schedule for a particular bus (busKey => Parameter)
-- Total Revenues/City/ Year
-- Total Cost of buses by BusType
-- The Total Revenue/Year
-- The Count of Employees by Position
-- Total Amount earned by a driver in a year (make it a stored procedure. Pass in Year & DriverKey as parameter)

Use MetroAlt
-- Summary how many buses are assigned to each bus barn

Create View vw_AmountBusesInBarn
As
Select COUNT(b.BusBarnKey) [BusBarn Ky],
BusBarnCity [City]
From Bus b
Inner Join BusBarn bb
on b.BusBarnKey= bb.BusBarnKey
Group By BusBarnCity
Go

select * from BusRouteStops
Select * from BusStop


Alter Proc usp_BusScheduleStop 
@BusRouteKey INT
AS
Select 
BusRouteKey [Route Key],
BusStopAddress [Stop Address]
From BusStop bt
Inner Join BusRouteStops br
on bt.BusStopKey=br.BusStopKey
Where BusRouteKey = @BusRouteKey
Group by BusRouteKey, BusStopAddress
Go

Exec usp_BusScheduleStop '3'

-- Schedule for a particular bus (busKey => Parameter)

Create View vw_TotalRevenueCityYear
AS
Select Year(BusScheduleAssignmentDate) as[Year]
,BusRoutezone,
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end
 [Bus Fare],
Count(Riders) as [total Riders],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end *  count(riders) as [Total Fares]
from BusRoute br
inner join BusScheduleAssignment bsa
on br.BusRouteKey=bsa.BusRouteKey
inner Join Ridership r
on r.BusScheduleAssigmentKey=
bsa.BusScheduleAssignmentKey
Group by Year(BusScheduleAssignmentDate),
busRouteZone

Select* from vw_TotalRevenueCityYear


-- Total Cost of buses by BusType
Create View vw_TotalCostByBusType
AS
Select bt.BusTypeKey as [Bus Type Key],
BusTypeDescription as [Bus Type],
Sum(BustypePurchasePrice) as [Total Cost of Bus/Type],
Count(b.BusKey) as [Bus Key]
From Bus b
Inner Join BusType bt on b.BusTypekey= bt.BusTypekey
Group By BusTypeDescription, bt.BusTypekey

select * From vw_TotalCostByBusType


-- The Count of Employees by Position
Create View vw_TotalEmployee
AS
Select PositionName as [Position Name],
Count(p.PositionKey) as [Total Employees By Position]
From EmployeePosition EP
Inner Join Position P on EP.PositionKey= P.PositionKey
Group By PositionName


-- The Total Revenue/Year
Create View vw_TotalRevenuePerYear
AS
Select Year(BusScheduleAssignmentDate) as[Year],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end
 [Bus Fare],
Count(Riders) as [total Riders],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end *  count(riders) as [Total Fares]
from BusRoute br
inner join BusScheduleAssignment bsa
on br.BusRouteKey=bsa.BusRouteKey
inner Join Ridership r
on r.BusScheduleAssigmentKey=
bsa.BusScheduleAssignmentKey
Group by Year(BusScheduleAssignmentDate)


-- Total Amount earned by a driver in a year (make it a stored procedure. Pass in Year & DriverKey as parameter)
Create Proc usp_TotaltEarnedByDriver
@Year INT, @EmployeeKey INT
AS
Select EmployeeLastName,
EmployeefirstName,
PositionName,
YEar(BusScheduleAssignmentDate) [Year],
EmployeeHourlyPayRate,
Sum(DateDiff(hh, BusDriverShiftSTarttime, BusDriverShiftStopTime)) [total Hours],
Sum(DateDiff(hh, BusDriverShiftSTarttime, BusDriverShiftStopTime)) * EmployeeHourlyPayRate [Annual Pay]
From employee e
inner Join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p
on  p.PositionKey=ep.PositionKey
inner join BusScheduleAssignment bsa
on e.EmployeeKey=bsa.EmployeeKey
inner Join BusDriverShift bs
on bs.BusDriverShiftKey =bsa.BusDriverShiftKey
Where YEar(BusScheduleAssignmentDate)= @Year
And e.EmployeeKey= @EmployeeKey
Group by  EmployeeLastName,
EmployeefirstName,
PositionName,
YEar(BusScheduleAssignmentDate),
EmployeeHourlyPayRate

exec usp_TotaltEarnedByDriver 2013, 22


-- Cost of a bus vs Amount of Fares earned by that bus across 3 years (Pass in BusKey)
Create View vw_TotalRevenuePerYear
AS
Select Year(BusScheduleAssignmentDate) as[Year],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end
 [Bus Fare],
Count(Riders) as [total Riders],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end *  count(riders) as [Total Fares]
from BusRoute br
inner join BusScheduleAssignment bsa
on br.BusRouteKey=bsa.BusRouteKey
inner Join Ridership r
on r.BusScheduleAssigmentKey=
bsa.BusScheduleAssignmentKey
Group by Year(BusScheduleAssignmentDate)
