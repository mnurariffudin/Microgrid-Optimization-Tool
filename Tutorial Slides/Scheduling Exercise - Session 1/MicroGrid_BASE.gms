*****************************************************************************
* ---------------  MODEL: Solar Scheduling
* ---------------  DATE: 07/04/2022
*****************************************************************************

sets
T                                        hour of the day /0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23/
;
parameters
i                                        interest rate                          /0.03/
NumberOfDays                             number of days of the clustered hours  /365/
SL                                       lifetime - solar PV                    /20/
IL                                       lifetime - inverter                    /10/
SolarAreaDensity                         area density - solar PV (kW per m2)    /0.08/
SolarIrradiance(T)                       solar irradiance at each hour T (kW per m2)
/0 0, 1 0, 2 0, 3 0, 4 0, 5 0, 6 0, 7 0.02821, 8 0.16645, 9 0.34343, 10 0.51119,
11 0.63695,12 0.71436, 13 0.72238, 14 0.66178, 15 0.54851, 16 0.39157, 17 0.21876,
18 0.06934, 19 0.00150,20 0, 21 0, 22 0, 23 0/
ElectricityDemand(T)                     demand - electricity (kWh)
/0 67, 1 64, 2 60, 3 57, 4 55, 5 55, 6 56, 7 48, 8 50, 9 56, 10 61,
11 63,12 61, 13 60, 14 63, 15 64, 16 64, 17 60,
18 58, 19 67,20 73, 21 73, 22 70, 23 67/
SolarEfficiency                          efficiency - solar PV  /0.18/
InverterEfficiency                       efficiency - inverter  /0.96/
SolarInvestmentCost                      investment cost - solar pv (USD per kW)        /1500/ 
InverterInvestmentCost                   investment cost - inverter (USD per kW)        /60/
SolarOperatingCost                       operating cost - solar pv (USD per kW year)        /15/
ElectricityTariff                        tariff - electricity (USD per kWh)   /0.0545/
;
free variable
TotalCost                                objective function (USD per year)
positive variables
MicrogridAreaSolar                       allocated area for solar PV in microgrid system (kWh)
SolarEnergyProduced(T)                   total solar energy produced (kWh)
EnergyFromGrid(T)                        electricity from grid allocated to meet electricity demand (kWh)
InverterCapacitySolar                    capacity of solar inverter (kWh)
equations
ObjectiveFunction
SolarEnergyProduction
UpperBoundInverterCapacity
EnergyDemand
;


ObjectiveFunction..
        TotalCost =E=
        MicrogridAreaSolar*SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1)) + SolarOperatingCost)
        + InverterCapacitySolar*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1))
        + SUM((T),EnergyFromGrid(T)*ElectricityTariff*NumberOfDays)
;
SolarEnergyProduction(T).. MicrogridAreaSolar*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProduced(T);
UpperBoundInverterCapacity(T).. SolarEnergyProduced(T) =L= InverterCapacitySolar;
EnergyDemand(T).. SolarEnergyProduced(T)*InverterEfficiency + EnergyFromGrid(T) =E= ElectricityDemand(T);


MODEL MicroGrid /ALL/;
SOLVE MicroGrid USING LP MINIMIZING TotalCost;

Execute_Unload "MicroGridOut.gdx";