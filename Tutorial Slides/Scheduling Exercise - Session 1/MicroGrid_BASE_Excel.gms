*****************************************************************************
* ---------------  MODEL: Solar Scheduling
* ---------------  DATE: 07/04/2022
*****************************************************************************


*Read data from excel speadsheets
* Select problem case (Your excel file name).
$set Case 'Microgrid_BASE_INPUT'
* Read data from Excel and store in GDX file.
$call gdxxrw %Case%.xlsx skipempty=0 trace=2 index=Specs!A1
$gdxin %Case%.gdx

sets
T                                        hour of the day
parameters
i                                        interest rate                          
NumberOfDays                             number of days of the clustered hours  
SL                                       lifetime - solar PV                    
IL                                       lifetime - inverter                    
SolarAreaDensity                         area density - solar PV (kW per m2)    
SolarIrradiance(T)                       solar irradiance at each hour T (kW per m2)
ElectricityDemand(T)                     demand - electricity (kWh)
SolarEfficiency                          efficiency - solar PV 
InverterEfficiency                       efficiency - inverter  
SolarInvestmentCost                      investment cost - solar pv (USD per kW) 
InverterInvestmentCost                   investment cost - inverter (USD per kW) 
SolarOperatingCost                       operating cost - solar pv (USD per kW year)  
ElectricityTariff                        tariff - electricity (USD per kWh)
;

$load T,i,NumberOfDays,SL,IL,SolarAreaDensity,SolarIrradiance,ElectricityDemand,SolarEfficiency
$load InverterEfficiency,SolarInvestmentCost,InverterInvestmentCost,SolarOperatingCost,ElectricityTariff 

free variable
TotalCost                                objective function (USD per year)
positive variables
MicrogridAreaSolar                       allocated area for solar PV in microgrid system (m2)
SolarEnergyProduced(T)                   total solar energy produced (kWh)
EnergyFromGrid(T)                        electricity from grid allocated to meet electricity demand (kWh)
InverterCapacitySolar                    capacity of solar inverter (kWh)
equations
ObjectiveFunction
SolarEnergyProduction
UpperBoundInverterCapacity
EnergyDemand
;


*--------------------------------- Objective function ------------------------------------------------------------------------------------
ObjectiveFunction..
        TotalCost =E=
* Solar Cost        
        MicrogridAreaSolar*SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1)) + SolarOperatingCost)
* Inverter Cost
        + InverterCapacitySolar*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1))
* Grid Electricity Cost
        + SUM((T),EnergyFromGrid(T)*ElectricityTariff*NumberOfDays)
;
*--------------------------------- Energy Balance ----------------------------------------------------------------------------------------
*------------------------Solar Microgrid Area-------------------------------
SolarEnergyProduction(T).. MicrogridAreaSolar*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProduced(T);
*--------------------Solar Inverter Capacity-------------------- 
UpperBoundInverterCapacity(T).. SolarEnergyProduced(T) =L= InverterCapacitySolar;
*------------------------Electricity Demand-------------------------------
EnergyDemand(T).. SolarEnergyProduced(T)*InverterEfficiency + EnergyFromGrid(T) =E= ElectricityDemand(T);


MODEL MicroGrid /ALL/;
SOLVE MicroGrid USING LP MINIMIZING TotalCost;

Execute_Unload "MicroGridOut.gdx";
Execute 'gdxxrw.exe i=MicroGridOut.gdx EpsOut=0 o=Microgrid_BASE_OUTPUT.xlsx squeeze=n index=Specs!A1'