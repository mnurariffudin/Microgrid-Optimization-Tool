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
BL                                       lifetime - battery energy storage      /12/
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
ChargeEfficiency                         efficiency - charging (battery)    /0.94/ 
DischargeEfficiency                      efficiency - discharging (battery) /0.94/
DischargeDepth                           depth of discharge (battery energy storage)    /0.8/
SolarInvestmentCost                      investment cost - solar pv (USD per kW)        /1500/ 
InverterInvestmentCost                   investment cost - inverter (USD per kW)        /60/
BatteryEnergyInvestmentCost              investment cost - battery-energy (USD per kWh) /380/
BatteryPowerInvestmentCost               investment cost - battery-power (USD per kW)   /360/
SolarOperatingCost                       operating cost - solar pv (USD per kW year)        /15/
BatteryPowerOperatingCost                operating cost - battery-power (USD per kW year)   /10/
ElectricityTariff                        tariff - electricity (USD per kWh)   /0.0545/
VRETarget                                VRE penetration target /1/
;
free variable
TotalCost                                objective function (USD per year)
positive variables
MicrogridAreaSolar                       allocated area for solar PV in microgrid system (kWh)
SolarEnergyProduced(T)                   total solar energy produced (kWh)
SolarEnergy2Demand(T)                    solar energy allocated to meet electricity demand directly (kWh)
SolarEnergyStorageCharged(T)             solar energy storage charging (kWh)
SolarEnergyStorageDischarged(T)          solar energy storage discharging to meet electricity demand (kWh)
SolarEnergySOC(T)                        solar energy storage state-of-charging (kWh)
EnergyFromGrid(T)                        electricity from grid allocated to meet electricity demand (kWh)
SOCSolarStorageCapacity                  capacity of solar battery state-of-charge (energy related) (kWh)
StorageSolarCapacity                     capacity of solar battery storage (power related) (kWh)
InverterCapacitySolar                    capacity of solar inverter (kWh)
binary variables
BC(T)                                    binary occurence - no discharging when charging
BD(T)                                    binary occurence - no charging when discharging
equations
ObjectiveFunction
SolarEnergyProduction
SolarEnergyProductionBalance
SolarEnergyStateOfCharge
UpperBoundBatteryStoragePowerRelated
UpperBoundBatteryStorageDischargingCapacity
ChargingOccurence
DischargingOccurence
BinaryOccurence
UpperBoundBatteryStorageEnergyRelated
UpperBoundInverterCapacity
EnergyDemand
VREPenetrationTarget
;


*--------------------------------- Objective function ------------------------------------------------------------------------------------
ObjectiveFunction..
        TotalCost =E=
* Solar Cost        
        MicrogridAreaSolar*SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1)) + SolarOperatingCost)
* Battery-Energy Cost
        + SOCSolarStorageCapacity*BatteryEnergyInvestmentCost*(i*((1+i)**BL)/(((1+i)**BL)-1))
* Battery-Power Cost
        + StorageSolarCapacity*(BatteryPowerInvestmentCost*(i*((1+i)**BL)/(((1+i)**BL)-1)) + BatteryPowerOperatingCost)
* Inverter Cost
        + InverterCapacitySolar*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1))
* Grid Electricity Cost
        + SUM((T),EnergyFromGrid(T)*ElectricityTariff*NumberOfDays)
;

*--------------------------------- Energy Balance ----------------------------------------------------------------------------------------
*------------------------Solar Microgrid Area-------------------------------
SolarEnergyProduction(T).. MicrogridAreaSolar*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProduced(T);
*------------------------Solar Energy Balance-------------------------------
SolarEnergyProductionBalance(T).. SolarEnergyProduced(T) =E= SolarEnergy2Demand(T) + SolarEnergyStorageCharged(T);
*------------------------Solar Battery SOC-------------------------------
SolarEnergyStateOfCharge(T).. SolarEnergySOC(T++1) =E= SolarEnergySOC(T) + SolarEnergyStorageCharged(T)*ChargeEfficiency
                                                       - SolarEnergyStorageDischarged(T);
*--------------------Solar Charging/Discharging Constraint--------------------
* Solar Charging
UpperBoundBatteryStoragePowerRelated(T).. SolarEnergyStorageCharged(T) =L= StorageSolarCapacity;
* Solar discharging
UpperBoundBatteryStorageDischargingCapacity(T).. SolarEnergyStorageDischarged(T) =L= StorageSolarCapacity;
* Charging occurence - no charging when discharging
ChargingOccurence(T).. SolarEnergyStorageCharged(T) =L= BC(T)*1000000;
* Discharging occurence - no discharging when charging
DischargingOccurence(T).. SolarEnergyStorageDischarged(T) =L= BD(T)*1000000;
* Binary charging and discharging balance
BinaryOccurence(T).. 1 - BC(T) =E= BD(T);
*--------------------Solar Battery Capacity Constraint--------------------       
UpperBoundBatteryStorageEnergyRelated(T).. SolarEnergySOC(T) =L= SOCSolarStorageCapacity*DischargeDepth;
*--------------------Solar Inverter Capacity-------------------- 
UpperBoundInverterCapacity(T).. SolarEnergy2Demand(T) + SolarEnergyStorageDischarged(T) =L= InverterCapacitySolar;
*------------------------Electricity Demand-------------------------------
EnergyDemand(T).. SolarEnergy2Demand(T)*InverterEfficiency + SolarEnergyStorageDischarged(T)*DischargeEfficiency*InverterEfficiency
                  + EnergyFromGrid(T) =E= ElectricityDemand(T);
VREPenetrationTarget.. SUM((T),SolarEnergy2Demand(T)*InverterEfficiency
                       + SolarEnergyStorageDischarged(T)*DischargeEfficiency*InverterEfficiency)
                       =E=  SUM((T),ElectricityDemand(T))*VRETarget;


MODEL MicroGrid /ALL/;
SOLVE MicroGrid USING MIP MINIMIZING TotalCost;

Execute_Unload "MicroGridOut.gdx";