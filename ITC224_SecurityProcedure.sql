Select * from Position
--Driver access to their own Information
--pay per month
--pay per year
--pay per shift
--select route schedules
--select bus barn

--Manager needs to give permission to employees to look-up DB
--go used to separate command...before going to the next step
go
Create Schema DriverSchema
go
Alter Proc DriverSchema.usp_ViewEmployeeInfo 
@EmployeeID int
As
Select e.EmployeeKey [Employee Number],
EmployeeLastName [Last Name],
EmployeeFirstName [First Name],
EmployeeAddress [Address],
EmployeeCity [City],
EmployeeZipCode [Zip Code],
EmployeePhone [Phone],
EmployeeEmail [Email],
EmployeeHireDate [Hire Date],
PositionName [Position],
EmployeeHourlyPayRate [Pay Rate]
From Employee e
inner Join EmployeePosition ep
on e.EmployeeKey=ep.EmployeeKey
inner Join Position p
on p.PositionKey=ep.PositionKey
where e.EmployeeKey=@EmployeeID

exec DriverSchema.usp_ViewEmployeeInfo 1


Alter Proc DriverSchema.usp_shiftsDrive 
@Month int, 
@Year int,
@EmployeeID int
As
Select
[BusScheduleAssignmentDate] [Date],
[BusDriverShiftName] [Shift],
[BusRouteKey] [Route],
[BusKey] [Bus],
[BusDriverShiftStartTime] [Start],
[BusDriverShiftStopTime] [Stop],
DateDiff (hh,[BusDriverShiftStartTime],[BusDriverShiftStopTime]) [hours]
From [dbo].[BusScheduleAssignment]bsa
inner join BusDriverShift bs
on bsa.BusDriverShiftKey=bs.BusDriverShiftKey
Where Year([BusScheduleAssignmentDate])=@Year
and Month([BusScheduleAssignmentDate])=@Month
and bsa.EmployeeKey=@EmployeeID
Exec DriverSchema.usp_shiftsDrive
@Year=2014,
@Month=7,
@EmployeeID=1

Create Proc DriverSchema.usp_UpdatePersonal
@LastName nvarchar(255),
@FirstName nvarchar(255),
@Address nvarchar(255),
@City nvarchar(255)= 'Seattle',  --Make it default..If not insert anything, it will be Seattle!
@Zip nchar(5),
@Phone nchar(10),
@EmployeeID int
As
If	exists
	(Select EmployeeKey from Employee where EmployeeKey=@EmployeeID)
Begin
Update Employee
Set [EmployeeLastName]=@LastName,
[EmployeeFirstName]=@FirstName,
[EmployeeAddress]=@Address,
[EmployeeCity]=@City,
[EmployeeZipCode]=@Zip,
[EmployeePhone]=@Phone
Where EmployeeKey=@EmployeeID
--RETURN1 option: if want to pull it up.
End
Else
Begin
Declare @msg nvarchar(30)
Set @msg= 'Employee Doesn''t exist' 
Print @msg
Return @msg
End

--update this
exec DriverSchema.usp_UpdatePersonal
@LastName = 'Kenner-Jones',
@FirstName = 'Susanne',
@Address = '234 Some other street',
@City = 'Seattle', 
@Zip = '98100',
@Phone = '2065554321',
@EmployeeID = 1

Select * From Employee

Create Login KJSusa with password='@Passw0rd1'
Use MetroAlt
Create user KJSusa for login KJSusa with default_Schema=DriverSchema
Create role DriverRole
Grant exec, 
Select on Schema::DriverSchema To DriverRole

exec sp_addrolemember 'DriverRole', 'KJSusa'


exec usp_shiftsDrive 5, 2014, 1
