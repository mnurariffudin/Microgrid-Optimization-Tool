*****************************************************************************
* ---------------  MODEL: Microgrid Tool
* ---------------  DATE: 05/04/2022
* ---------------  DEVELOPED BY: Mohd Idris, M.N., Hashim, H., Wai Shin, H., Muis, Z.A.
* ---------------  INSTITUTION: Universiti Teknologi Malaysia (UTM)
*****************************************************************************

*****************************************************************************
*Read data from excel speadsheets
*****************************************************************************
* Select problem case.
$set Case 'Microgrid_INPUT'
* Read data from Excel and store in GDX file.
$call gdxxrw %Case%.xlsx skipempty=0 trace=2 index=Specs!A1
$gdxin %Case%.gdx


* ==============================================================================
*   - SETS -
* ==============================================================================

sets
T                                        hour
;

* Load sets from GDX file
$load T

* ==============================================================================
*   - PARAMETERS -
* ==============================================================================

parameters
i                                        interest rate
NumberOfDays                             number of days of the clustered hours
SL                                       lifetime - solar PV
WL                                       lifetime - wind turbine
BL                                       lifetime - battery energy storage
IL                                       lifetime - inverter
RL                                       lifetime - rectifier
EVL                                      lifetime - electric vehicle
BEVL                                     lifetime - electric vehicle battery
MaximumArea                              maximum area of microgrid installation (m2)
MaximumGridSupply                        maximum grid electricity supply (kWh)
EVUnit                                   number of electric vehicle unit (#)
EVUnitCommercial                         fraction of EV unit going to commercial workplace
EVUnitIndustrial                         fraction of EV unit going to industrial workplace
BatteryCapacity                          capacity - battery energy storage (kWh)
WindTurbineCapacity                      capacity - wind turbine (kWh)
EVStorageCapacity                        capacity - electric vehicle battery (kWh)
EVChargingCapacityResidential            capacity - electric vehicle charging at residential area (kW)
EVChargingCapacityCommercial             capacity - electric vehicle charging at commercial area (kW)
EVChargingCapacityIndustrial             capacity - electric vehicle charging at industrial area (kW)
EVDischargingCapacityV2G                 capacity - electric vehicle discharging for vehicle-to-grid (kW)
SolarAreaDensity                         area density - solar PV (kW per m2)
WindAreaDensity                          area density - wind density (kW per m2)
SolarIrradiance(T)                       solar irradiance at each hour T (kW per m2)
CapacityFactorWind(T)                    capacity factor of solar PV at each hour T
ResidentialDemand(T)                     demand - electricity (residential) (kWh)
CommercialDemand(T)                      demand - electricity (commercial) (kWh)
IndustrialDemand(T)                      demand - electricity (industrial) (kWh)
TravelDemand(T)                          demand - electric vehicle traveling (km)
SolarEfficiency                          efficiency - solar PV
InverterEfficiency                       efficiency - inverter
RectifierEfficiency                      efficiency - rectifier
ChargeEfficiency                         efficiency - charging (battery) 
DischargeEfficiency                      efficiency - discharging (battery) 
EVChargeEfficiency                       efficiency - charging (electric vehicle)
EVDischargeEfficiency                    efficiency - discharging (electric vehicle)
EVInverterEfficiency                     efficiency - inverter for V2G
EVTravelEfficiency                       efficiency - energy use by electric vehicle per distance (kWh per km)
DischargeDepth                           depth of discharge (battery energy storage)
EVDischargeDepth                         depth of discharge (electric vehicle)
EVMinBatteryLevel                        minimum battery level (electric vehicle)
BinaryEVRequirementResidential(T)        binary parameter - EV charging occurence (residential)
BinaryEVRequirementCommercial(T)         binary parameter - EV charging occurence (commercial)
BinaryEVRequirementIndustrial(T)         binary parameter - EV charging occurence (industrial)
BinaryEVConsumption(T)                   binary parameter - Occurence of EV discharging for traveling
BinaryV2GConsumption(T)                  binary parameter - Occurence of EV discharging for V2G
BinaryBatteryStorageCharge(T)            binary parameter - Battery charging occurence
BinaryBatteryStorageDischarge(T)         binary parameter - Battery discharging occurence
SolarInvestmentCost                      investment cost - solar pv (USD per kW) 
WindInvestmentCost                       investment cost - wind turbine (USD per kW) 
InverterInvestmentCost                   investment cost - inverter (USD per kW) 
RectifierInvestmentCost                  investment cost - rectifier (USD per kW) 
BatteryEnergyInvestmentCost              investment cost - battery-energy (USD per kWh)
BatteryPowerInvestmentCost               investment cost - battery-power (USD per kW)
EVInvestmentCost                         investment cost - electric vehicle (USD per unit EV)
EVBatteryCost                            investment cost - electric vehicle battery (USD per unit EV)
SolarOperatingCost                       operating cost - solar pv (USD per kW year)
WindOperatingCost                        operating cost - wind turbine (USD per kW year)
BatteryPowerOperatingCost                operating cost - battery-power (USD per kW year)
EVMaintenanceCost                        maintenance cost - electric vehicle (USD per unit EV per year)
LandCost                                 land cost - solar pv and wind turbine (USD per m2)
ElectricityTariffResidential(T)          tariff - electricity (residential) (USD per kWh)
ElectricityTariffCommercial(T)           tariff - electricity (commercial) (USD per kWh)
ElectricityTariffIndustrial(T)           tariff - electricity (industrial) (USD per kWh)
V2GTariffCommercial(T)                   tariff - V2G (commercial) (USD per kWh)
V2GTariffIndustrial(T)                   tariff - V2G (industrial) (USD per kWh)
V2GAllow                                 V2G allowance - 1 if allowed and 0 if not allowed
VRETarget                                VRE target for power demand only (excluding EV) - put 0 for EV unit demand when using this target
;

* Load parameters from GDX file
$load i, NumberOfDays, SL, WL, BL, IL, RL, EVL, BEVL, MaximumArea, MaximumGridSupply, EVUnit, EVUnitCommercial, EVUnitIndustrial
$load BatteryCapacity, WindTurbineCapacity, EVStorageCapacity, EVChargingCapacityResidential, EVChargingCapacityCommercial, EVChargingCapacityIndustrial, EVDischargingCapacityV2G 
$load SolarAreaDensity, WindAreaDensity, SolarIrradiance, CapacityFactorWind, ResidentialDemand, CommercialDemand, IndustrialDemand, TravelDemand  
$load SolarEfficiency, InverterEfficiency, RectifierEfficiency, ChargeEfficiency, DischargeEfficiency, EVChargeEfficiency, EVDischargeEfficiency, EVInverterEfficiency, EVTravelEfficiency
$load DischargeDepth, EVDischargeDepth, EVMinBatteryLevel, BinaryEVRequirementResidential, BinaryEVRequirementCommercial, BinaryEVRequirementIndustrial, BinaryEVConsumption, BinaryV2GConsumption,
$load BinaryBatteryStorageCharge, BinaryBatteryStorageDischarge, SolarInvestmentCost, WindInvestmentCost, InverterInvestmentCost, RectifierInvestmentCost, BatteryEnergyInvestmentCost  
$load BatteryPowerInvestmentCost, EVInvestmentCost, EVBatteryCost, SolarOperatingCost, WindOperatingCost, EVMaintenanceCost, BatteryPowerOperatingCost, LandCost 
$load ElectricityTariffResidential, ElectricityTariffCommercial, ElectricityTariffIndustrial, V2GTariffCommercial, V2GTariffIndustrial, V2GAllow, VRETarget 

* ==============================================================================
*   - VARIABLES -
* ==============================================================================

free variable
TotalCost                                                        objective function (USD per year)

positive variables
MicrogridAreaSolarResidential                                    allocated area for solar PV in microgrid system - residential (kWh)
MicrogridAreaSolarCommercial                                     allocated area for solar PV in microgrid system - commercial (kWh)
MicrogridAreaSolarIndustrial                                     allocated area for solar PV in microgrid system - industrial (kWh)
SolarEnergyProducedResidential(T)                                total solar energy produced - residential (kWh)
SolarEnergyProducedCommercial(T)                                 total solar energy produced - commercial (kWh)
SolarEnergyProducedIndustrial (T)                                total solar energy produced - industrial (kWh)
SolarEnergyCurtailedResidential(T)                               total solar energy curtailment - residential (kWh)
SolarEnergyCurtailedCommercial(T)                                total solar energy curtailment - commercial (kWh)
SolarEnergyCurtailedIndustrial (T)                               total solar energy curtailment - industrial (kWh)
SolarEnergy2ResidentialDemand(T)                                 solar energy allocated to meet residential electricity demand directly (kWh)
SolarEnergy2CommercialDemand(T)                                  solar energy allocated to meet commercial electricity demand directly (kWh)
SolarEnergy2IndustrialDemand(T)                                  solar energy allocated to meet industrial electricity demand directly (kWh)
SolarEnergy2EVStorageChargedResidential(T)                       solar energy allocated for EV charging in residential area (kWh)
SolarEnergy2EVStorageChargedCommercial(T)                        solar energy allocated for EV charging in commercial area (kWh)
SolarEnergy2EVStorageChargedIndustrial(T)                        solar energy allocated for EV charging in industrial area (kWh)
EnergyEVStorageDischarged(T)                                     EV electricity storage discharging for travelling (kWh)
EnergyEVStorageDischargedV2G2Commercial(T)                       EV electricity storage discharging for V2G (kWh)
EnergyEVStorageDischargedV2G2Industrial(T)                       EV electricity storage discharging for V2G (kWh)
EnergyEVSOC(T)                                                   EV electricity storage state-of-charging (kWh)
EVBatteryStorageCapacity                                         EV battery storage capacity (kWh)
EnergyFromGrid2EVBatteryResidential(T)                           electricity from grid to EV battery for charging in residential area (kWh)
EnergyFromGrid2EVBatteryCommercial(T)                            electricity from grid to EV battery for charging in commercial area (kWh)
EnergyFromGrid2EVBatteryIndustrial(T)                            electricity from grid to EV battery for charging in industrial area (kWh)
SolarEnergyStorageChargedResidential(T)                          solar energy storage charging - residential (kWh)
SolarEnergyStorageChargedCommercial(T)                           solar energy storage charging - commercial (kWh)
SolarEnergyStorageChargedIndustrial(T)                           solar energy storage charging - industrial (kWh)
SolarEnergyStorageDischarged2Residential(T)                      solar energy storage discharging to meet residential electricity demand (kWh)
SolarEnergyStorageDischarged2Commercial(T)                       solar energy storage discharging to meet commercial electricity demand (kWh)
SolarEnergyStorageDischarged2Industrial(T)                       solar energy storage discharging to meet industrial electricity demand (kWh)
SolarEnergyStorageDischargedResidential2EV(T)                    solar energy storage discharging to meet EV electricity demand - residential (kWh)
SolarEnergyStorageDischargedCommercial2EV(T)                     solar energy storage discharging to meet EV electricity demand - commercial (kWh)
SolarEnergyStorageDischargedIndustrial2EV(T)                     solar energy storage discharging to meet EV electricity demand - industrial (kWh)
SolarEnergySOCResidential(T)                                     solar energy storage state-of-charging - residential (kWh)
SolarEnergySOCCommercial(T)                                      solar energy storage state-of-charging - commercial (kWh)
SolarEnergySOCIndustrial(T)                                      solar energy storage state-of-charging - industrial (kWh)
EnergyFromGrid2Residential(T)                                    electricity from grid allocated to meet residential electricity demand (kWh)
EnergyFromGrid2Commercial(T)                                     electricity from grid allocated to meet commercial electricity demand (kWh)
EnergyFromGrid2Industrial(T)                                     electricity from grid allocated to meet industrial electricity demand (kWh)
SOCSolarStorageCapacityResidential                               capacity of solar battery state-of-charge (energy related) - residential (kWh)
SOCSolarStorageCapacityCommercial                                capacity of solar battery state-of-charge (energy related) - commercial (kWh)
SOCSolarStorageCapacityIndustrial                                capacity of solar battery state-of-charge (energy related) - industrial (kWh)
StorageSolarCapacityResidential                                  capacity of solar battery storage (power related) - residential (kWh)
StorageSolarCapacityCommercial                                   capacity of solar battery storage (power related) - commercial (kWh)
StorageSolarCapacityIndustrial                                   capacity of solar battery storage (power related) - industrial (kWh)
InverterCapacitySolarResidential                                 capacity of solar inverter - residential (kWh)
InverterCapacitySolarCommercial                                  capacity of solar inverter - commercial (kWh)
InverterCapacitySolarIndustrial                                  capacity of solar inverter - industrial (kWh)
InverterCapacityEVCommercial                                     capacity of EV inverter - commercial (kWh)
InverterCapacityEVIndustrial                                     capacity of EV inverter - industrial (kWh)
MicrogridAreaWindResidential                                     allocated area for wind turbine in microgrid system - residential (kWh)
MicrogridAreaWindCommercial                                      allocated area for wind turbine in microgrid system - commercial (kWh)
MicrogridAreaWindIndustrial                                      allocated area for wind turbine in microgrid system - industrial (kWh)
WindEnergyProducedResidential(T)                                 total wind energy produced - residential (kWh)
WindEnergyProducedCommercial(T)                                  total wind energy produced - commercial (kWh)
WindEnergyProducedIndustrial(T)                                  total wind energy produced - industrial (kWh)
WindCapacityResidential                                          capacity of wind turbine - residential (kWh)
WindCapacityCommercial                                           capacity of wind turbine - commercial (kWh)
WindCapacityIndustrial                                           capacity of wind turbine - industrial (kWh)
WindEnergyCurtailedResidential(T)                                total wind energy curtailment - residential (kWh)
WindEnergyCurtailedCommercial(T)                                 total wind energy curtailment - commercial (kWh)
WindEnergyCurtailedIndustrial (T)                                total wind energy curtailment - industrial (kWh)
WindEnergy2ResidentialDemand(T)                                  wind energy allocated to meet residential electricity demand directly (kWh)
WindEnergy2CommercialDemand(T)                                   wind energy allocated to meet commercial electricity demand directly (kWh)
WindEnergy2IndustrialDemand(T)                                   wind energy allocated to meet industrial electricity demand directly (kWh)
WindEnergy2EVStorageChargedResidential(T)                        wind energy allocated for EV charging in residential area (kWh)
WindEnergy2EVStorageChargedCommercial(T)                         wind energy allocated for EV charging in commercial area (kWh)
WindEnergy2EVStorageChargedIndustrial(T)                         wind energy allocated for EV charging in industrial area (kWh)
WindEnergyStorageChargedResidential(T)                           wind energy storage charging - residential (kWh)
WindEnergyStorageChargedCommercial(T)                            wind energy storage charging - commercial (kWh)
WindEnergyStorageChargedIndustrial(T)                            wind energy storage charging - industrial (kWh)
WindEnergySOCResidential(T)                                      wind energy storage state-of-charging - residential (kWh)
WindEnergySOCCommercial(T)                                       wind energy storage state-of-charging - commercial (kWh)
WindEnergySOCIndustrial(T)                                       wind energy storage state-of-charging - industrial (kWh)
WindEnergyStorageDischarged2Residential(T)                       wind energy storage discharging to meet residential electricity demand (kWh)
WindEnergyStorageDischarged2Commercial(T)                        wind energy storage discharging to meet commercial electricity demand (kWh)
WindEnergyStorageDischarged2Industrial(T)                        wind energy storage discharging to meet industrial electricity demand (kWh)
WindEnergyStorageDischargedResidential2EV(T)                     wind energy storage discharging to meet EV electricity demand - residential (kWh)
WindEnergyStorageDischargedCommercial2EV(T)                      wind energy storage discharging to meet EV electricity demand - commercial (kWh)
WindEnergyStorageDischargedIndustrial2EV(T)                      wind energy storage discharging to meet EV electricity demand - industrial (kWh)
SOCWindStorageCapacityResidential                                capacity of wind battery state-of-charge (energy related) - residential (kWh)
SOCWindStorageCapacityCommercial                                 capacity of wind battery state-of-charge (energy related) - commercial (kWh)
SOCWindStorageCapacityIndustrial                                 capacity of wind battery state-of-charge (energy related) - industrial (kWh)
StorageWindCapacityResidential                                   capacity of wind battery storage (power related) - residential (kWh)
StorageWindCapacityCommercial                                    capacity of wind battery storage (power related) - commercial (kWh)
StorageWindCapacityIndustrial                                    capacity of wind battery storage (power related) - industrial (kWh)
InverterCapacityWindResidential                                  capacity of wind inverter - residential (kWh)
InverterCapacityWindCommercial                                   capacity of wind inverter - commercial (kWh)
InverterCapacityWindIndustrial                                   capacity of wind inverter - industrial (kWh)
RectifierCapacityWindResidential                                 capacity of wind rectifier - residential (kWh)
RectifierCapacityWindCommercial                                  capacity of wind rectifier - commercial (kWh)
RectifierCapacityWindIndustrial                                  capacity of wind rectifier - industrial (kWh)
;

binary variable
BC(T)                                                            EV charging allowance - when 1 charging is allowed and discharging is not allowed
BD(T)                                                            EV discharging allowance - when 1 discharging is allowed and charging is not allowed
BSC(T)                                                           Solar charging allowance - when 1 charging is allowed and discharging is not allowed
BSD(T)                                                           Solar discharging allowance - when 1 discharging is allowed and charging is not allowed
BWC(T)                                                           Wind charging allowance - when 1 charging is allowed and discharging is not allowed
BWD(T)                                                           Wind discharging allowance - when 1 discharging is allowed and charging is not allowed
;

integer variables
BWTR                                                             Number of wind turbine unit - residential
BWTC                                                             Number of wind turbine unit - commercial
BWTI                                                             Number of wind turbine unit - industrial
BWUR                                                             Number of battery storage unit - wind turbine (residential)
BWUC                                                             Number of battery storage unit - wind turbine (commercial)
BWUI                                                             Number of battery storage unit - wind turbine (industrial) 
BSUR                                                             Number of battery storage unit - solar PV (residential)
BSUC                                                             Number of battery storage unit - solar PV (commercial)
BSUI                                                             Number of battery storage unit - solar PV (industrial) 
;

* ==============================================================================
*   - EQUATIONS -
* ==============================================================================
equations
UpperBoundElectricityGridSupply
UpperBoundMicrogridArea
SolarEnergyProductionResidential
SolarEnergyProductionCommercial
SolarEnergyProductionIndustrial
SolarEnergyProductionBalanceResidential
SolarEnergyProductionBalanceCommercial
SolarEnergyProductionBalanceIndustrial
EnergyEVStateOfCharge
BinaryEVChargingConstraint
BinaryEVDischargingConstraint
BinarySolarChargingConstraint
BinarySolarDischargingConstraint
BinaryWindChargingConstraint
BinaryWindDischargingConstraint
BinaryEVBalance
BinarySolarBalance
BinaryWindBalance
SolarEnergyStateOfChargeResidential
SolarEnergyStateOfChargeCommercial
SolarEnergyStateOfChargeIndustrial
EnergyDemandResidential
EnergyDemandCommercial
EnergyDemandIndustrial
EnergyEVChargingRequirementResidential
EnergyEVChargingRequirementCommercial
EnergyEVChargingRequirementIndustrial
EnergyEVStorageDischarging
EVBatteryStorageCapacityLimit
UpperBoundEVStorageSOCCapacity
LowerBoundEVStorageSOCCapacity
EnergyEVStorageDischargingV2GCommercial
EnergyEVStorageDischargingV2GIndustrial
UpperBoundBatterySolarStorageEnergyRelatedResidential
UpperBoundBatteryStorageSolarEnergyRelatedCommercial
UpperBoundBatteryStorageSolarEnergyRelatedIndustrial
UpperBoundBatteryStorageSolarPowerRelatedResidential
UpperBoundBatteryStorageSolarPowerRelatedCommercial
UpperBoundBatteryStorageSolarPowerRelatedIndustrial
UpperBoundBatteryStorageSolarDischargingCapacityResidential
UpperBoundBatteryStorageSolarDischargingCapacityCommercial
UpperBoundBatteryStorageSolarDischargingCapacityIndustrial
UpperBoundInverterCapacitySolarResidential
UpperBoundInverterCapacitySolarCommercial
UpperBoundInverterCapacitySolarIndustrial
UpperBoundInverterCapacityEVCommercial
UpperBoundInverterCapacityEVIndustrial
V2GAllowance
ObjectiveFunction
V2GLimitCommercial
V2GLimitIndustrial
NumberBatteryStorageSolarResidential
NumberBatteryStorageSolarCommercial
NumberBatteryStorageSolarIndustrial
WindEnergyAreaResidential
WindEnergyAreaCommercial
WindEnergyAreaIndustrial
WindEnergyProductionResidential
WindEnergyProductionCommercial
WindEnergyProductionIndustrial
WindEnergyProductionBalanceResidential
WindEnergyProductionBalanceCommercial
WindEnergyProductionBalanceIndustrial
WindEnergyStateOfChargeResidential
WindEnergyStateOfChargeCommercial
WindEnergyStateOfChargeIndustrial
UpperBoundBatteryWindStorageEnergyRelatedResidential
UpperBoundBatteryStorageWindEnergyRelatedCommercial
UpperBoundBatteryStorageWindEnergyRelatedIndustrial
UpperBoundBatteryStorageWindPowerRelatedResidential
UpperBoundBatteryStorageWindPowerRelatedCommercial
UpperBoundBatteryStorageWindPowerRelatedIndustrial
UpperBoundBatteryStorageWindDischargingCapacityResidential
UpperBoundBatteryStorageWindDischargingCapacityCommercial
UpperBoundBatteryStorageWindDischargingCapacityIndustrial
UpperBoundInverterCapacityWindResidential
UpperBoundInverterCapacityWindCommercial
UpperBoundInverterCapacityWindIndustrial
UpperBoundRectifierCapacityWindResidential
UpperBoundRectifierCapacityWindCommercial
UpperBoundRectifierCapacityWindIndustrial
NumberBatteryStorageWindResidential
NumberBatteryStorageWindCommercial
NumberBatteryStorageWindIndustrial
NumberWindTurbineResidential
NumberWindTurbineCommercial
NumberWindTurbineIndustrial
VRETargetEnergyDemand
;


***********************************************************************************************
****************************************  MAIN   **********************************************
***********************************************************************************************

*--------------------------------- Objective function ----------------------------------------------------------------------------------------
ObjectiveFunction..
        TotalCost =E=
* Solar Cost        
        (MicrogridAreaSolarResidential + MicrogridAreaSolarCommercial + MicrogridAreaSolarIndustrial)*(LandCost + SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1)) + SolarOperatingCost))
* Wind Cost
        + (MicrogridAreaWindResidential + MicrogridAreaWindCommercial + MicrogridAreaWindIndustrial)*(LandCost + WindAreaDensity*(WindInvestmentCost*(i*((1+i)**WL)/(((1+i)**WL)-1)) + WindOperatingCost))
* Battery-Energy Cost
        + (SOCSolarStorageCapacityResidential + SOCSolarStorageCapacityCommercial + SOCSolarStorageCapacityIndustrial
        + SOCWindStorageCapacityResidential + SOCWindStorageCapacityCommercial + SOCWindStorageCapacityIndustrial)*(BatteryEnergyInvestmentCost*(i*((1+i)**BL)/(((1+i)**BL)-1)))
* Battery-Power Cost
        + (StorageSolarCapacityResidential + StorageSolarCapacityCommercial + StorageSolarCapacityIndustrial
        + StorageWindCapacityResidential + StorageWindCapacityCommercial + StorageWindCapacityIndustrial)*((BatteryPowerInvestmentCost)*(i*((1+i)**BL)/(((1+i)**BL)-1)) + BatteryPowerOperatingCost)
* Inverter Cost
        + (InverterCapacitySolarResidential + InverterCapacitySolarCommercial + InverterCapacitySolarIndustrial + InverterCapacityEVCommercial + InverterCapacityEVIndustrial
        + InverterCapacityWindResidential + InverterCapacityWindCommercial + InverterCapacityWindIndustrial)*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1))
* Rectifier Cost
        + (RectifierCapacityWindResidential + RectifierCapacityWindCommercial + RectifierCapacityWindIndustrial)*RectifierInvestmentCost*(i*((1+i)**RL)/(((1+i)**RL)-1))
* EV Cost 
        + EVUnit*(EVInvestmentCost*(i*((1+i)**EVL)/(((1+i)**EVL)-1)) + EVMaintenanceCost)
        + EVBatteryStorageCapacity*(EVBatteryCost/EVStorageCapacity)*(i*((1+i)**BEVL)/(((1+i)**BEVL)-1))
* Grid Electricity Cost
        + SUM((T),((EnergyFromGrid2Residential(T) + EnergyFromGrid2EVBatteryResidential(T))*ElectricityTariffResidential(T)
        + (EnergyFromGrid2Commercial(T) + EnergyFromGrid2EVBatteryCommercial(T))*ElectricityTariffCommercial(T)
        + (EnergyFromGrid2Industrial(T) + EnergyFromGrid2EVBatteryIndustrial(T))*ElectricityTariffIndustrial(T))*NumberOfDays)
* V2G Revenue
        - SUM((T), ((EnergyEVStorageDischargedV2G2Commercial(T)*V2GTariffCommercial(T) + EnergyEVStorageDischargedV2G2Industrial(T)*V2GTariffIndustrial(T))*EVDischargeEfficiency*EVInverterEfficiency)*NumberOfDays)
;

*--------------------------------- Energy Balance ----------------------------------------------------------------------------------------
*MaximumArea
UpperBoundMicrogridArea..
         MicrogridAreaSolarResidential + MicrogridAreaSolarCommercial + MicrogridAreaSolarIndustrial
         + MicrogridAreaWindResidential + MicrogridAreaWindCommercial + MicrogridAreaWindIndustrial =L= MaximumArea;

***********************************************************************************************
**********************************GRID ELECTRICITY*********************************************
***********************************************************************************************
*Maximum Grid Electricity Supply
UpperBoundElectricityGridSupply(T)..
         EnergyFromGrid2Residential(T) + EnergyFromGrid2EVBatteryResidential(T) + EnergyFromGrid2Commercial(T) + EnergyFromGrid2EVBatteryCommercial(T)
         + EnergyFromGrid2Industrial(T) + EnergyFromGrid2EVBatteryIndustrial(T) =L= MaximumGridSupply;


***********************************************************************************************
*****************************************SOLAR PV**********************************************
***********************************************************************************************

*------------------------Solar Microgrid Area-------------------------------
* Solar Energy production - residential
SolarEnergyProductionResidential(T)..
         MicrogridAreaSolarResidential*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProducedResidential(T);
* Solar Energy production - commercial
SolarEnergyProductionCommercial(T)..
         MicrogridAreaSolarCommercial*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProducedCommercial(T);
* Solar Energy production - industrial
SolarEnergyProductionIndustrial(T)..
         MicrogridAreaSolarIndustrial*SolarIrradiance(T)*SolarEfficiency =E= SolarEnergyProducedIndustrial(T);

*------------------------Solar Energy Balance-------------------------------
* Solar Energy production balance - residential
*SolarEnergyCurtailedResidential(T) +
SolarEnergyProductionBalanceResidential(T)..
         SolarEnergyProducedResidential(T) =E= SolarEnergy2ResidentialDemand(T) + SolarEnergy2EVStorageChargedResidential(T)
                                               + SolarEnergyStorageChargedResidential(T);
* Solar Energy production balance - commercial
*SolarEnergyCurtailedCommercial(T) +
SolarEnergyProductionBalanceCommercial(T)..
         SolarEnergyProducedCommercial(T) =E= SolarEnergy2CommercialDemand(T)+ SolarEnergy2EVStorageChargedCommercial(T)
                                               + SolarEnergyStorageChargedCommercial(T);
* Solar Energy production balance - industrial
*SolarEnergyCurtailedIndustrial(T) +
SolarEnergyProductionBalanceIndustrial(T)..
         SolarEnergyProducedIndustrial(T) =E= SolarEnergy2IndustrialDemand(T) + SolarEnergy2EVStorageChargedIndustrial(T)
                                               + SolarEnergyStorageChargedIndustrial(T);

*------------------------Solar Battery SOC-------------------------------
* Energy state of charge balance for solar energy - residential
SolarEnergyStateOfChargeResidential(T)..
         SolarEnergySOCResidential(T++1) =E= SolarEnergySOCResidential(T) + (SolarEnergyStorageChargedResidential(T))*ChargeEfficiency
         - SolarEnergyStorageDischarged2Residential(T) - SolarEnergyStorageDischargedResidential2EV(T);
* Energy state of charge balance for solar energy - commercial
SolarEnergyStateOfChargeCommercial(T)..
         SolarEnergySOCCommercial(T++1) =E= SolarEnergySOCCommercial(T) + (SolarEnergyStorageChargedCommercial(T))*ChargeEfficiency
         - SolarEnergyStorageDischarged2Commercial(T) - SolarEnergyStorageDischargedCommercial2EV(T);
* Energy state of charge balance for solar energy - industrial
SolarEnergyStateOfChargeIndustrial(T)..
         SolarEnergySOCIndustrial(T++1) =E= SolarEnergySOCIndustrial(T) + (SolarEnergyStorageChargedIndustrial(T))*ChargeEfficiency
         - SolarEnergyStorageDischarged2Industrial(T) - SolarEnergyStorageDischargedIndustrial2EV(T);

*--------------------Solar Charging Binary Occurences--------------------
* Binary Solar Charging Constraint
BinarySolarChargingConstraint(T)..
         (SolarEnergyStorageChargedResidential(T) + SolarEnergyStorageChargedCommercial(T) + SolarEnergyStorageChargedIndustrial(T))*ChargeEfficiency =L= BSC(T)*100000;
* Binary Solar Discharging Constraint
BinarySolarDischargingConstraint(T)..
         SolarEnergyStorageDischarged2Residential(T) + SolarEnergyStorageDischargedResidential2EV(T)
         + SolarEnergyStorageDischarged2Commercial(T) + SolarEnergyStorageDischargedCommercial2EV(T)
         + SolarEnergyStorageDischarged2Industrial(T) + SolarEnergyStorageDischargedIndustrial2EV(T) =L= BSD(T)*100000;
* Binary Solar Charging/Discharging Balance
BinarySolarBalance(T)..
         1 - BSC(T) =E= BSD(T);


*--------------------Solar Charging/Discharging Schedules--------------------
* VRE battery solar charging capacity - power related (residential)
UpperBoundBatteryStorageSolarPowerRelatedResidential(T)..
         SolarEnergyStorageChargedResidential(T) =L= StorageSolarCapacityResidential*BinaryBatteryStorageCharge(T);
* VRE battery solar charging capacity - power related (commercial)
UpperBoundBatteryStorageSolarPowerRelatedCommercial(T)..
         SolarEnergyStorageChargedCommercial(T) =L= StorageSolarCapacityCommercial*BinaryBatteryStorageCharge(T);
* VRE battery solar charging capacity - power related (industrial)
UpperBoundBatteryStorageSolarPowerRelatedIndustrial(T)..
         SolarEnergyStorageChargedIndustrial(T) =L= StorageSolarCapacityIndustrial*BinaryBatteryStorageCharge(T);
* VRE battery solar discharging (residential)
UpperBoundBatteryStorageSolarDischargingCapacityResidential(T)..
         SolarEnergyStorageDischarged2Residential(T) + SolarEnergyStorageDischargedResidential2EV(T) =L= StorageSolarCapacityResidential*BinaryBatteryStorageDischarge(T);
* VRE battery solar discharging (commercial)
UpperBoundBatteryStorageSolarDischargingCapacityCommercial(T)..
         SolarEnergyStorageDischarged2Commercial(T) + SolarEnergyStorageDischargedCommercial2EV(T) =L= StorageSolarCapacityCommercial*BinaryBatteryStorageDischarge(T);
* VRE battery solar discharging (industrial)
UpperBoundBatteryStorageSolarDischargingCapacityIndustrial(T)..
         SolarEnergyStorageDischarged2Industrial(T) + SolarEnergyStorageDischargedIndustrial2EV(T) =L= StorageSolarCapacityIndustrial*BinaryBatteryStorageDischarge(T);

*--------------------Solar Battery Capacity Constraint--------------------       
* VRE battery solar storage capacity - energy related (residential)
UpperBoundBatterySolarStorageEnergyRelatedResidential(T)..
         SolarEnergySOCResidential(T) =L= SOCSolarStorageCapacityResidential*DischargeDepth;
* VRE battery solar storage capacity - energy related (commercial)
UpperBoundBatteryStorageSolarEnergyRelatedCommercial(T)..
         SolarEnergySOCCommercial(T) =L= SOCSolarStorageCapacityCommercial*DischargeDepth;
* VRE battery solar storage capacity - energy related (industrial)
UpperBoundBatteryStorageSolarEnergyRelatedIndustrial(T)..
         SolarEnergySOCIndustrial(T) =L= SOCSolarStorageCapacityIndustrial*DischargeDepth;

*--------------------Solar Inverter Capacity-------------------- 
* Solar inverter capacity (residential)
UpperBoundInverterCapacitySolarResidential(T)..
         SolarEnergy2ResidentialDemand(T) + SolarEnergyStorageDischarged2Residential(T) =L= InverterCapacitySolarResidential;
* Solar inverter capacity (commercial)
UpperBoundInverterCapacitySolarCommercial(T)..
         SolarEnergy2CommercialDemand(T) + SolarEnergyStorageDischarged2Commercial(T) =L= InverterCapacitySolarCommercial;
* Solar inverter capacity (industrial)
UpperBoundInverterCapacitySolarIndustrial(T)..
         SolarEnergy2IndustrialDemand(T) + SolarEnergyStorageDischarged2Industrial(T) =L= InverterCapacitySolarIndustrial;

*--------------------Number of Solar Battery Units-------------------- 
* Number of solar battery storage unit (residential)
NumberBatteryStorageSolarResidential..
          SOCSolarStorageCapacityResidential =E= BatteryCapacity*BSUR;
* Number of solar battery storage unit (commercial)
NumberBatteryStorageSolarCommercial..
          SOCSolarStorageCapacityCommercial =E= BatteryCapacity*BSUC;
* Number of solar battery storage unit (industrial)
NumberBatteryStorageSolarIndustrial..
          SOCSolarStorageCapacityIndustrial =E= BatteryCapacity*BSUI;


***********************************************************************************************
***************************************WIND TURBINE********************************************
***********************************************************************************************

*------------------------Solar Microgrid Area-------------------------------
* Wind energy area footprint - residential
WindEnergyAreaResidential(T)..
         WindCapacityResidential/WindAreaDensity =E= MicrogridAreaWindResidential;
* Wind energy area footprint - commercial
WindEnergyAreaCommercial(T)..
         WindCapacityCommercial/WindAreaDensity =E= MicrogridAreaWindCommercial;
* Wind energy area footprint - industrial
WindEnergyAreaIndustrial(T)..
         WindCapacityIndustrial/WindAreaDensity =E= MicrogridAreaWindIndustrial;
* Wind energy production - residential
WindEnergyProductionResidential(T)..
         CapacityFactorWind(T)*WindCapacityResidential =E= WindEnergyProducedResidential(T);
* Wind energy production - commercial
WindEnergyProductionCommercial(T)..
         CapacityFactorWind(T)*WindCapacityCommercial =E= WindEnergyProducedCommercial(T);
* Wind energy production - industrial
WindEnergyProductionIndustrial(T)..
         CapacityFactorWind(T)*WindCapacityIndustrial =E= WindEnergyProducedIndustrial(T);

*------------------------Wind Energy Balance-------------------------------
* Wind Energy production balance - residential
*WindEnergyCurtailedResidential(T) +
WindEnergyProductionBalanceResidential(T)..
         WindEnergyProducedResidential(T) =E= WindEnergy2ResidentialDemand(T) + WindEnergy2EVStorageChargedResidential(T)
                                               + WindEnergyStorageChargedResidential(T);
* Wind Energy production balance - commercial
*WindEnergyCurtailedCommercial(T) +
WindEnergyProductionBalanceCommercial(T)..
         WindEnergyProducedCommercial(T) =E= WindEnergy2CommercialDemand(T) + WindEnergy2EVStorageChargedCommercial(T)
                                               + WindEnergyStorageChargedCommercial(T);
* Wind Energy production balance - industrial
*WindEnergyCurtailedIndustrial(T) +
WindEnergyProductionBalanceIndustrial(T)..
         WindEnergyProducedIndustrial(T) =E= WindEnergy2IndustrialDemand(T) + WindEnergy2EVStorageChargedIndustrial(T)
                                               + WindEnergyStorageChargedIndustrial(T);

*------------------------Wind Battery SOC-------------------------------
* Energy state of charge balance for wind energy - residential
WindEnergyStateOfChargeResidential(T)..
         WindEnergySOCResidential(T++1) =E= WindEnergySOCResidential(T) + (WindEnergyStorageChargedResidential(T))*RectifierEfficiency*ChargeEfficiency
         - WindEnergyStorageDischarged2Residential(T) - WindEnergyStorageDischargedResidential2EV(T);
* Energy state of charge balance for wind energy - commercial
WindEnergyStateOfChargeCommercial(T)..
         WindEnergySOCCommercial(T++1) =E= WindEnergySOCCommercial(T) + (WindEnergyStorageChargedCommercial(T))*RectifierEfficiency*ChargeEfficiency
         - WindEnergyStorageDischarged2Commercial(T) - WindEnergyStorageDischargedCommercial2EV(T);
* Energy state of charge balance for wind energy - industrial
WindEnergyStateOfChargeIndustrial(T)..
         WindEnergySOCIndustrial(T++1) =E= WindEnergySOCIndustrial(T) + (WindEnergyStorageChargedIndustrial(T))*RectifierEfficiency*ChargeEfficiency
         - WindEnergyStorageDischarged2Industrial(T) - WindEnergyStorageDischargedIndustrial2EV(T);

*--------------------Wind Charging Binary Occurences--------------------
* Binary Wind Charging Constraint
BinaryWindChargingConstraint(T)..
         (WindEnergyStorageChargedResidential(T) + WindEnergyStorageChargedCommercial(T) + WindEnergyStorageChargedIndustrial(T))*RectifierEfficiency*ChargeEfficiency =L= BWC(T)*100000;
* Binary Wind Discharging Constraint
BinaryWindDischargingConstraint(T)..
         WindEnergyStorageDischarged2Residential(T) + WindEnergyStorageDischargedResidential2EV(T)
         + WindEnergyStorageDischarged2Commercial(T) + WindEnergyStorageDischargedCommercial2EV(T)
         + WindEnergyStorageDischarged2Industrial(T) + WindEnergyStorageDischargedIndustrial2EV(T) =L= BWD(T)*100000;
* Binary Wind Charging/Discharging Balance
BinaryWindBalance(T)..
         1 - BWC(T) =E= BWD(T);

*--------------------Wind Battery Capacity Constraint-------------------- 
* VRE battery wind storage capacity - energy related (residential)
UpperBoundBatteryWindStorageEnergyRelatedResidential(T)..
         WindEnergySOCResidential(T) =L= SOCWindStorageCapacityResidential*DischargeDepth;
* VRE battery wind storage capacity - energy related (commercial)
UpperBoundBatteryStorageWindEnergyRelatedCommercial(T)..
         WindEnergySOCCommercial(T) =L= SOCWindStorageCapacityCommercial*DischargeDepth;
* VRE battery wind storage capacity - energy related (industrial)
UpperBoundBatteryStorageWindEnergyRelatedIndustrial(T)..
         WindEnergySOCIndustrial(T) =L= SOCWindStorageCapacityIndustrial*DischargeDepth;

*--------------------Wind Charging/Discharging Schedules--------------------
* VRE battery wind charging capacity - power related (residential)
UpperBoundBatteryStorageWindPowerRelatedResidential(T)..
         WindEnergyStorageChargedResidential(T) =L= StorageWindCapacityResidential*BinaryBatteryStorageCharge(T);
* VRE battery wind charging capacity - power related (commercial)
UpperBoundBatteryStorageWindPowerRelatedCommercial(T)..
         WindEnergyStorageChargedCommercial(T) =L= StorageWindCapacityCommercial*BinaryBatteryStorageCharge(T);
* VRE battery wind charging capacity - power related (industrial)
UpperBoundBatteryStorageWindPowerRelatedIndustrial(T)..
         WindEnergyStorageChargedIndustrial(T) =L= StorageWindCapacityIndustrial*BinaryBatteryStorageCharge(T);
* VRE battery wind discharging (residential)
UpperBoundBatteryStorageWindDischargingCapacityResidential(T)..
         WindEnergyStorageDischarged2Residential(T) + WindEnergyStorageDischargedResidential2EV(T) =L= StorageWindCapacityResidential*BinaryBatteryStorageDischarge(T);
* VRE battery wind discharging (commercial)
UpperBoundBatteryStorageWindDischargingCapacityCommercial(T)..
         WindEnergyStorageDischarged2Commercial(T) + WindEnergyStorageDischargedCommercial2EV(T) =L= StorageWindCapacityCommercial*BinaryBatteryStorageDischarge(T);
* VRE battery wind discharging (industrial)
UpperBoundBatteryStorageWindDischargingCapacityIndustrial(T)..
         WindEnergyStorageDischarged2Industrial(T) + WindEnergyStorageDischargedIndustrial2EV(T) =L= StorageWindCapacityIndustrial*BinaryBatteryStorageDischarge(T);

*--------------------Wind Rectifier Capacity-------------------- 
* Wind rectifier capacity (residential)
UpperBoundRectifierCapacityWindResidential(T)..
          WindEnergyStorageChargedResidential(T) + WindEnergy2EVStorageChargedResidential(T) + WindEnergy2ResidentialDemand(T)*InverterEfficiency =L= RectifierCapacityWindResidential;
* Wind rectifier capacity (commercial)
UpperBoundRectifierCapacityWindCommercial(T)..
          WindEnergyStorageChargedCommercial(T) + WindEnergy2EVStorageChargedCommercial(T) + WindEnergy2CommercialDemand(T)*InverterEfficiency =L= RectifierCapacityWindCommercial;
* Wind rectifier capacity (industrial)
UpperBoundRectifierCapacityWindIndustrial(T)..
          WindEnergyStorageChargedIndustrial(T) + WindEnergy2EVStorageChargedIndustrial(T) + WindEnergy2IndustrialDemand(T)*InverterEfficiency =L= RectifierCapacityWindIndustrial;

*--------------------Wind Inverter Capacity-------------------- 
* Wind inverter capacity (residential)
UpperBoundInverterCapacityWindResidential(T)..
         WindEnergy2ResidentialDemand(T)*(1 + InverterEfficiency*RectifierEfficiency) + WindEnergyStorageDischarged2Residential(T) =L= InverterCapacityWindResidential;
* Wind inverter capacity (commercial)
UpperBoundInverterCapacityWindCommercial(T)..
         WindEnergy2CommercialDemand(T)*(1 + InverterEfficiency*RectifierEfficiency) + WindEnergyStorageDischarged2Commercial(T) =L= InverterCapacityWindCommercial;
* Wind inverter capacity (industrial)
UpperBoundInverterCapacityWindIndustrial(T)..
         WindEnergy2IndustrialDemand(T)*(1 + InverterEfficiency*RectifierEfficiency) + WindEnergyStorageDischarged2Industrial(T) =L= InverterCapacityWindIndustrial;

*--------------------Number of Wind Battery Units-------------------- 
* Number of battery wind storage unit (residential)
NumberBatteryStorageWindResidential..
          SOCWindStorageCapacityResidential =E= BatteryCapacity*BWUR;
* Number of battery wind storage unit (commercial)
NumberBatteryStorageWindCommercial..
          SOCWindStorageCapacityCommercial =E= BatteryCapacity*BWUC;
* Number of battery wind storage unit (industrial)
NumberBatteryStorageWindIndustrial..
          SOCWindStorageCapacityIndustrial =E= BatteryCapacity*BWUI;

*--------------------Number of Wind Turbine Units-------------------- 
* Number of wind turbine unit (residential)
NumberWindTurbineResidential..
          WindCapacityResidential =E= WindTurbineCapacity*BWTR;
* Number of wind turbine unit (commercial)
NumberWindTurbineCommercial..
          WindCapacityCommercial =E= WindTurbineCapacity*BWTC;
* Number of wind turbine unit (industrial)
NumberWindTurbineIndustrial..
          WindCapacityIndustrial =E= WindTurbineCapacity*BWTI;


***********************************************************************************************
***************************************ELECTRIC VEHICLE****************************************
***********************************************************************************************

*------------------------EV Battery SOC-------------------------------
* Energy state of charge balance for EV
EnergyEVStateOfCharge(T)..
         EnergyEVSOC(T++1) =E= EnergyEVSOC(T)*0.99993 + (EnergyFromGrid2EVBatteryResidential(T) + EnergyFromGrid2EVBatteryCommercial(T) + EnergyFromGrid2EVBatteryIndustrial(T)
                               + SolarEnergy2EVStorageChargedResidential(T) + SolarEnergy2EVStorageChargedCommercial(T) + SolarEnergy2EVStorageChargedIndustrial(T)
                               + SolarEnergyStorageDischargedResidential2EV(T) + SolarEnergyStorageDischargedCommercial2EV(T) + SolarEnergyStorageDischargedIndustrial2EV(T)
                               + (WindEnergy2EVStorageChargedResidential(T) + WindEnergy2EVStorageChargedCommercial(T) + WindEnergy2EVStorageChargedIndustrial(T))*RectifierEfficiency
                               + WindEnergyStorageDischargedResidential2EV(T) + WindEnergyStorageDischargedCommercial2EV(T) + WindEnergyStorageDischargedIndustrial2EV(T))*EVChargeEfficiency
                               - EnergyEVStorageDischarged(T) - EnergyEVStorageDischargedV2G2Commercial(T)- EnergyEVStorageDischargedV2G2Industrial(T);

*--------------------EV Charging Binary Occurences--------------------
* Binary EV Charging Constraint
BinaryEVChargingConstraint(T)..
                               (EnergyFromGrid2EVBatteryResidential(T) + EnergyFromGrid2EVBatteryCommercial(T) + EnergyFromGrid2EVBatteryIndustrial(T)
                               + SolarEnergy2EVStorageChargedResidential(T) + SolarEnergy2EVStorageChargedCommercial(T) + SolarEnergy2EVStorageChargedIndustrial(T)
                               + SolarEnergyStorageDischargedResidential2EV(T) + SolarEnergyStorageDischargedCommercial2EV(T) + SolarEnergyStorageDischargedIndustrial2EV(T)
                               + (WindEnergy2EVStorageChargedResidential(T) + WindEnergy2EVStorageChargedCommercial(T) + WindEnergy2EVStorageChargedIndustrial(T))*RectifierEfficiency
                               + WindEnergyStorageDischargedResidential2EV(T) + WindEnergyStorageDischargedCommercial2EV(T) + WindEnergyStorageDischargedIndustrial2EV(T))*EVChargeEfficiency
                               =L= BC(T)*100000;
* Binary EV Discharging Constraint
BinaryEVDischargingConstraint(T)..
         EnergyEVStorageDischarged(T) + EnergyEVStorageDischargedV2G2Commercial(T) + EnergyEVStorageDischargedV2G2Industrial(T) =L= BD(T)*100000;
* Binary EV Charging/Discharging Balance
BinaryEVBalance(T)..
         1 - BC(T) =E= BD(T);

*--------------------EV Charging Schedules--------------------
* EV charging schedule - residential
EnergyEVChargingRequirementResidential(T)..
         (EnergyFromGrid2EVBatteryResidential(T) + SolarEnergy2EVStorageChargedResidential(T) + SolarEnergyStorageDischargedResidential2EV(T)
          + WindEnergy2EVStorageChargedResidential(T) + WindEnergyStorageDischargedResidential2EV(T))*EVChargeEfficiency =L= BinaryEVRequirementResidential(T)*EVChargingCapacityResidential*EVUnit;
* EV charging schedule - commercial
EnergyEVChargingRequirementCommercial(T)..
         (EnergyFromGrid2EVBatteryCommercial(T) + SolarEnergy2EVStorageChargedCommercial(T) + SolarEnergyStorageDischargedCommercial2EV(T)
          + WindEnergy2EVStorageChargedCommercial(T) + WindEnergyStorageDischargedCommercial2EV(T))*EVChargeEfficiency =L= BinaryEVRequirementCommercial(T)*EVChargingCapacityCommercial*EVUnit*EVUnitCommercial;
* EV charging schedule - industrial
EnergyEVChargingRequirementIndustrial(T)..
         (EnergyFromGrid2EVBatteryIndustrial(T) + SolarEnergy2EVStorageChargedIndustrial(T) + SolarEnergyStorageDischargedIndustrial2EV(T)
         + WindEnergy2EVStorageChargedIndustrial(T) + WindEnergyStorageDischargedIndustrial2EV(T))*EVChargeEfficiency =L= BinaryEVRequirementIndustrial(T)*EVChargingCapacityIndustrial*EVUnit*EVUnitIndustrial;

*--------------------EV Capacity Constraints--------------------
* Upper bound - EV battery SOC capacity
EVBatteryStorageCapacityLimit..
         EVBatteryStorageCapacity =E= EVStorageCapacity*EVUnit;
* Upper bound - EV battery SOC capacity
UpperBoundEVStorageSOCCapacity(T)..
         EnergyEVSOC(T) =L= EVBatteryStorageCapacity*EVDischargeDepth;
* Lower bound - EV battery SOC capacity
LowerBoundEVStorageSOCCapacity(T)..
         EnergyEVSOC(T) =G= EVBatteryStorageCapacity*EVMinBatteryLevel;

*--------------------V2G Capacity and Discharging Constraints--------------------
* EV battery discharging schedule (V2G - Commercial)
EnergyEVStorageDischargingV2GCommercial(T)..
         EnergyEVStorageDischargedV2G2Commercial(T) =L= BinaryV2GConsumption(T)*EVDischargingCapacityV2G*EVUnit*EVUnitCommercial;
* EV battery discharging schedule (V2G - Industrial)
EnergyEVStorageDischargingV2GIndustrial(T)..
         EnergyEVStorageDischargedV2G2Industrial(T) =L= BinaryV2GConsumption(T)*EVDischargingCapacityV2G*EVUnit*EVUnitCommercial;

*--------------------EV Inverter Capacity--------------------         
* EV inverter capacity (commercial)
UpperBoundInverterCapacityEVCommercial(T)..
         EnergyEVStorageDischargedV2G2Commercial(T) =L= InverterCapacityEVCommercial;
* EV inverter capacity (industrial)
UpperBoundInverterCapacityEVIndustrial(T)..
         EnergyEVStorageDischargedV2G2Industrial(T) =L= InverterCapacityEVIndustrial;


***********************************************************************************************
******************************************ENERGY DEMAND****************************************
***********************************************************************************************

*------------------------Grid Electricity + Solar + Wind + Battery + V2G -------------------------------
* Energy demand - residential
EnergyDemandResidential(T)..
         (SolarEnergy2ResidentialDemand(T) + WindEnergy2ResidentialDemand(T)*InverterEfficiency*RectifierEfficiency)*InverterEfficiency
         + (SolarEnergyStorageDischarged2Residential(T) + WindEnergyStorageDischarged2Residential(T))*DischargeEfficiency*InverterEfficiency + EnergyFromGrid2Residential(T) =E= ResidentialDemand(T);
* Energy demand - commercial
EnergyDemandCommercial(T)..
         (SolarEnergy2CommercialDemand(T) + WindEnergy2CommercialDemand(T)*InverterEfficiency*RectifierEfficiency)*InverterEfficiency + EnergyEVStorageDischargedV2G2Commercial(T)*EVDischargeEfficiency*EVInverterEfficiency
         + (SolarEnergyStorageDischarged2Commercial(T) + WindEnergyStorageDischarged2Commercial(T))*DischargeEfficiency*InverterEfficiency + EnergyFromGrid2Commercial(T) =E= CommercialDemand(T);
* Energy demand - industrial
EnergyDemandIndustrial(T)..
         (SolarEnergy2IndustrialDemand(T) + WindEnergy2IndustrialDemand(T)*InverterEfficiency*RectifierEfficiency)*InverterEfficiency + EnergyEVStorageDischargedV2G2Industrial(T)*EVDischargeEfficiency*EVInverterEfficiency
         + (SolarEnergyStorageDischarged2Industrial(T) + WindEnergyStorageDischarged2Industrial(T))*DischargeEfficiency*InverterEfficiency + EnergyFromGrid2Industrial(T) =E= IndustrialDemand(T);
* EV battery discharging schedule (travel demand)
EnergyEVStorageDischarging(T)..
         EnergyEVStorageDischarged(T)*EVTravelEfficiency =E= BinaryEVConsumption(T)*TravelDemand(T)*EVUnit;


***********************************************************************************************
******************************************V2G CONSTRAINT***************************************
***********************************************************************************************
* V2GLimit - industrial
V2GLimitIndustrial(T)..
         EnergyEVStorageDischargedV2G2Industrial(T)*EVDischargeEfficiency*EVInverterEfficiency =L=
         (SolarEnergy2IndustrialDemand(T) + WindEnergy2IndustrialDemand(T)*InverterEfficiency*RectifierEfficiency)*InverterEfficiency
         + (SolarEnergyStorageDischarged2Industrial(T) + WindEnergyStorageDischarged2Industrial(T))*DischargeEfficiency*InverterEfficiency;
* V2GLimit - commercial
V2GLimitCommercial(T)..
         EnergyEVStorageDischargedV2G2Commercial(T)*EVDischargeEfficiency*EVInverterEfficiency =L=
         (SolarEnergyStorageDischarged2Commercial(T) + WindEnergyStorageDischarged2Commercial(T))*DischargeEfficiency*InverterEfficiency
         + (SolarEnergy2CommercialDemand(T) + WindEnergy2CommercialDemand(T)*InverterEfficiency*RectifierEfficiency)*InverterEfficiency;
* V2G Allowance
V2GAllowance..
         SUM((T),EnergyEVStorageDischargedV2G2Commercial(T) + EnergyEVStorageDischargedV2G2Industrial(T)) =L= V2GAllow*100000;

***********************************************************************************************
*******************************************VRE TARGET******************************************
***********************************************************************************************
*Note that this target will be applied to the power demand only, excluding EV charging demand
*Thus, when using this feature, put 0 for the EV unit demand in the excel sheet
VRETargetEnergyDemand$(VRETarget gt 0)..
         SUM((T),(SolarEnergy2ResidentialDemand(T))*InverterEfficiency
         + SolarEnergyStorageDischarged2Residential(T)*DischargeEfficiency*InverterEfficiency
         + WindEnergy2ResidentialDemand(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency
         + WindEnergyStorageDischarged2Residential(T)*DischargeEfficiency*InverterEfficiency) +
         SUM((T),(SolarEnergy2CommercialDemand(T))*InverterEfficiency + EnergyEVStorageDischargedV2G2Commercial(T)*EVDischargeEfficiency*EVInverterEfficiency
         + SolarEnergyStorageDischarged2Commercial(T)*DischargeEfficiency*InverterEfficiency
         + WindEnergy2CommercialDemand(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency
         + WindEnergyStorageDischarged2Commercial(T)*DischargeEfficiency*InverterEfficiency) +
         SUM((T),(SolarEnergy2IndustrialDemand(T))*InverterEfficiency + EnergyEVStorageDischargedV2G2Industrial(T)*EVDischargeEfficiency*EVInverterEfficiency
         + SolarEnergyStorageDischarged2Industrial(T)*DischargeEfficiency*InverterEfficiency
         + WindEnergy2IndustrialDemand(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency
         + WindEnergyStorageDischarged2Industrial(T)*DischargeEfficiency*InverterEfficiency) =E= SUM((T),ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T))*VRETarget;



************************************
FILE cplexOpt/ cplex.opt /;
PUT cplexOpt;
PUT "PARALLELMODE = 1"/;
PUT "threads=2"/;
PUTCLOSE cplexOpt;
************************************
MODEL MicroGrid /ALL/;
MicroGrid.OPTCA     =     0;
MicroGrid.OPTCR     =     0;
************************************
SOLVE MicroGrid USING MIP MINIMIZING TotalCost;

parameter
AverageLCOE
SolarCAPEX
SolarLandCAPEX
SolarOPEX
WindCAPEX
WindLandCAPEX
WindOPEX
BatteryCAPEXPower
BatteryCAPEXEnergy
BatteryOPEX
InverterCAPEX
RectifierCAPEX
V2GRevenue
GridCost
EVCostCAPEX
EVBatteryCostCAPEX
EVCostOPEX
;

AverageLCOE =  ((MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L)*(LandCost + SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1)) + SolarOperatingCost))
                      + (MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L)*(LandCost + WindAreaDensity*(WindInvestmentCost*(i*((1+i)**WL)/(((1+i)**WL)-1)) + WindOperatingCost))
                      + (SOCSolarStorageCapacityResidential.L + SOCSolarStorageCapacityCommercial.L + SOCSolarStorageCapacityIndustrial.L
                      + SOCWindStorageCapacityResidential.L + SOCWindStorageCapacityCommercial.L + SOCWindStorageCapacityIndustrial.L)*(BatteryEnergyInvestmentCost*(i*((1+i)**BL)/(((1+i)**BL)-1)))
                      + (StorageSolarCapacityResidential.L + StorageSolarCapacityCommercial.L + StorageSolarCapacityIndustrial.L
                      + StorageWindCapacityResidential.L + StorageWindCapacityCommercial.L + StorageWindCapacityIndustrial.L)*((BatteryPowerInvestmentCost)*(i*((1+i)**BL)/(((1+i)**BL)-1)) + BatteryPowerOperatingCost)
                      + (InverterCapacitySolarResidential.L + InverterCapacitySolarCommercial.L + InverterCapacitySolarIndustrial.L + InverterCapacityEVCommercial.L + InverterCapacityEVIndustrial.L
                      + InverterCapacityWindResidential.L + InverterCapacityWindCommercial.L + InverterCapacityWindIndustrial.L)*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1))
                      + (RectifierCapacityWindResidential.L + RectifierCapacityWindCommercial.L + RectifierCapacityWindIndustrial.L)*RectifierInvestmentCost*(i*((1+i)**RL)/(((1+i)**RL)-1))
                      + SUM((T),((EnergyFromGrid2Residential.L(T) + EnergyFromGrid2EVBatteryResidential.L(T))*ElectricityTariffResidential(T)
                      + (EnergyFromGrid2Commercial.L(T) + EnergyFromGrid2EVBatteryCommercial.L(T))*ElectricityTariffCommercial(T)
                      + (EnergyFromGrid2Industrial.L(T) + EnergyFromGrid2EVBatteryIndustrial.L(T))*ElectricityTariffIndustrial(T))*NumberOfDays)
                      - SUM((T), ((EnergyEVStorageDischargedV2G2Commercial.L(T)*V2GTariffCommercial(T) + EnergyEVStorageDischargedV2G2Industrial.L(T)*V2GTariffIndustrial(T))*EVDischargeEfficiency*EVInverterEfficiency)*NumberOfDays)

)
/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays)
;

SolarCAPEX =  (MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L)*(SolarAreaDensity*(SolarInvestmentCost*(i*((1+i)**SL)/(((1+i)**SL)-1))));
SolarLandCAPEX =  (MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L)*LandCost;
SolarOPEX =   (MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L)*(SolarAreaDensity*SolarOperatingCost);
WindCAPEX = (MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L)*(WindAreaDensity*(WindInvestmentCost*(i*((1+i)**WL)/(((1+i)**WL)-1))));
WindLandCAPEX = (MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L)*LandCost;
WindOPEX = (MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L)*(WindAreaDensity*WindOperatingCost);
BatteryCAPEXPower = (SOCSolarStorageCapacityResidential.L + SOCSolarStorageCapacityCommercial.L + SOCSolarStorageCapacityIndustrial.L
                    + SOCWindStorageCapacityResidential.L + SOCWindStorageCapacityCommercial.L + SOCWindStorageCapacityIndustrial.L)*(BatteryEnergyInvestmentCost*(i*((1+i)**BL)/(((1+i)**BL)-1)));
BatteryCAPEXEnergy = (StorageSolarCapacityResidential.L + StorageSolarCapacityCommercial.L + StorageSolarCapacityIndustrial.L
                    + StorageWindCapacityResidential.L + StorageWindCapacityCommercial.L + StorageWindCapacityIndustrial.L)*((BatteryPowerInvestmentCost)*(i*((1+i)**BL)/(((1+i)**BL)-1)));
BatteryOPEX =  (StorageSolarCapacityResidential.L + StorageSolarCapacityCommercial.L + StorageSolarCapacityIndustrial.L
                    + StorageWindCapacityResidential.L + StorageWindCapacityCommercial.L + StorageWindCapacityIndustrial.L)*(BatteryPowerOperatingCost);
InverterCAPEX = (InverterCapacitySolarResidential.L + InverterCapacitySolarCommercial.L + InverterCapacitySolarIndustrial.L + InverterCapacityEVCommercial.L + InverterCapacityEVIndustrial.L
                 + InverterCapacityWindResidential.L + InverterCapacityWindCommercial.L + InverterCapacityWindIndustrial.L)*InverterInvestmentCost*(i*((1+i)**IL)/(((1+i)**IL)-1));
RectifierCAPEX = (RectifierCapacityWindResidential.L + RectifierCapacityWindCommercial.L + RectifierCapacityWindIndustrial.L)*RectifierInvestmentCost*(i*((1+i)**RL)/(((1+i)**RL)-1));
V2GRevenue = SUM((T), ((EnergyEVStorageDischargedV2G2Commercial.L(T)*V2GTariffCommercial(T) + EnergyEVStorageDischargedV2G2Industrial.L(T)*V2GTariffIndustrial(T))*EVDischargeEfficiency*EVInverterEfficiency)*NumberOfDays);
GridCost =   SUM((T),((EnergyFromGrid2Residential.L(T) + EnergyFromGrid2EVBatteryResidential.L(T))*ElectricityTariffResidential(T)
                      + (EnergyFromGrid2Commercial.L(T) + EnergyFromGrid2EVBatteryCommercial.L(T))*ElectricityTariffCommercial(T)
                      + (EnergyFromGrid2Industrial.L(T) + EnergyFromGrid2EVBatteryIndustrial.L(T))*ElectricityTariffIndustrial(T))*NumberOfDays);
EVCostCAPEX = EVUnit*(EVInvestmentCost*(i*((1+i)**EVL)/(((1+i)**EVL)-1)));
EVBatteryCostCAPEX = EVBatteryStorageCapacity.L*(EVBatteryCost/EVStorageCapacity)*(i*((1+i)**BEVL)/(((1+i)**BEVL)-1));
EVCostOPEX = EVUnit*EVMaintenanceCost;


parameter
Report_SystemCost(*)
Report_NetSystemCost(*)
Report_RevenueV2G(*)
Report_AverageElectricityCost(*)
Report_CostDistribution(*)
Report_AverageElectricityCostDistribution(*)
Report_MicrogridArea(*)
Report_MicrogridAreaSolar(*)
Report_MicrogridAreaWind(*)
Report_MicrogridAreaResidential(*)
Report_MicrogridAreaCommercial(*)
Report_MicrogridAreaIndustrial(*)
Report_SolarCapacity(*)
Report_WindCapacity(*)
Report_InverterCapacity(*)
Report_RectifierCapacity(*)
Report_BatteryCapacity(*)
Report_EVBatteryCapacity(*)
;


Report_SystemCost('System Cost (USD/year)') = TotalCost.L + V2GRevenue + EPS;
Report_NetSystemCost('Net System Cost (USD/year)') = TotalCost.L + EPS;
Report_RevenueV2G('Revenue - V2G (USD/year)') = V2GRevenue + EPS;
Report_AverageElectricityCost('Average Electricity Cost (USD/kWh)') = AverageLCOE + EPS; 
Report_CostDistribution('CAPEX (Solar PV)') = SolarCAPEX + EPS;
Report_CostDistribution('CAPEX (Wind Turbine)') = WindCAPEX + EPS;
Report_CostDistribution('CAPEX (Inverter)') = InverterCAPEX + EPS;
Report_CostDistribution('CAPEX (Rectifier)') = RectifierCAPEX + EPS;
Report_CostDistribution('CAPEX (Battery-Energy)') = BatteryCAPEXEnergy + EPS;
Report_CostDistribution('CAPEX (Battery-Power)') = BatteryCAPEXPower + EPS;
Report_CostDistribution('CAPEX (Land)') = SolarLandCAPEX + WindLandCAPEX + EPS;
Report_CostDistribution('CAPEX (EV)') = EVCostCAPEX + EPS;
Report_CostDistribution('CAPEX (EV Battery)') = EVBatteryCostCAPEX + EPS;
Report_CostDistribution('OPEX (Solar PV)') = SolarOPEX + EPS;
Report_CostDistribution('OPEX (Wind Turbine)') = WindOPEX + EPS + EPS;
Report_CostDistribution('OPEX (Battery-Power)') = BatteryOPEX + EPS;
Report_CostDistribution('OPEX (EV)') = EVCostOPEX + EPS;
Report_CostDistribution('Grid Electricity Cost') = GridCost + EPS;
Report_CostDistribution('Revenue (V2G)') = - V2GRevenue + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Solar PV)') = SolarCAPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Wind Turbine)') = WindCAPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Inverter)') = InverterCAPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Rectifier)') = RectifierCAPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Battery-Energy)') = BatteryCAPEXEnergy/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Battery-Power)') = BatteryCAPEXPower/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('CAPEX (Land)') = (SolarLandCAPEX + WindLandCAPEX)/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('OPEX (Solar PV)') = SolarOPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('OPEX (Wind Turbine)') = WindOPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('OPEX (Battery-Power)') = BatteryOPEX/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('Grid Electricity Cost') = GridCost/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_AverageElectricityCostDistribution('Revenue (V2G)') = - V2GRevenue/SUM((T),(ResidentialDemand(T) + CommercialDemand(T) + IndustrialDemand(T) + EnergyEVStorageDischarged.L(T))*NumberOfDays) + EPS;
Report_MicrogridArea('Total Microgrid Area (m2)') = MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L + MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L + EPS;   
Report_MicrogridAreaSolar('Microgrid Area - Solar (m2)') = MicrogridAreaSolarResidential.L + MicrogridAreaSolarCommercial.L + MicrogridAreaSolarIndustrial.L + EPS;   
Report_MicrogridAreaWind('Microgrid Area - Wind (m2)') = MicrogridAreaWindResidential.L + MicrogridAreaWindCommercial.L + MicrogridAreaWindIndustrial.L + EPS; 
Report_MicrogridAreaResidential('Microgrid Area - Residential (m2)') = MicrogridAreaSolarResidential.L + MicrogridAreaWindResidential.L + EPS;   
Report_MicrogridAreaCommercial('Microgrid Area - Commercial (m2)') = MicrogridAreaSolarCommercial.L + MicrogridAreaWindCommercial.L + EPS;   
Report_MicrogridAreaIndustrial('Microgrid Area - Industrial (m2)') = MicrogridAreaSolarIndustrial.L + MicrogridAreaWindIndustrial.L + EPS;   
Report_SolarCapacity('Total Capacity - Solar PV (kW)') = SMAX(T,SolarEnergyProducedResidential.L(T) + SolarEnergyProducedCommercial.L(T) + SolarEnergyProducedIndustrial.L(T)) + EPS;
Report_WindCapacity('Total Capacity - Wind Turbine (kW)') = WindCapacityResidential.L + WindCapacityCommercial.L + WindCapacityIndustrial.L + EPS;
Report_InverterCapacity('Total Capacity - Inverter (kW)') = InverterCapacitySolarResidential.L + InverterCapacitySolarCommercial.L + InverterCapacitySolarIndustrial.L + InverterCapacityEVCommercial.L + InverterCapacityEVIndustrial.L
                                                            + InverterCapacityWindResidential.L + InverterCapacityWindCommercial.L + InverterCapacityWindIndustrial.L + EPS;
Report_RectifierCapacity('Total Capacity - Rectifier (kW)') = RectifierCapacityWindResidential.L + RectifierCapacityWindCommercial.L + RectifierCapacityWindIndustrial.L + EPS;
Report_BatteryCapacity('Total Capacity - Battery-Energy (kWh)') = SOCSolarStorageCapacityResidential.L + SOCSolarStorageCapacityCommercial.L + SOCSolarStorageCapacityIndustrial.L
                                                           + SOCWindStorageCapacityResidential.L + SOCWindStorageCapacityCommercial.L + SOCWindStorageCapacityIndustrial.L;
Report_EVBatteryCapacity('Total Capacity - EV Battery (kWh)') = EVStorageCapacity*EVUnit;

parameter
Report_EVCharging_Grid(T)
Report_EVCharging_VRE(T)
Report_EVDischarging_Travel(T)
Report_EVDischarging_V2G(T)
SMAX_EnergyEVSOC
Report_EVSOC(T)
;

Report_EVCharging_Grid(T) = (EnergyFromGrid2EVBatteryResidential.L(T) + EnergyFromGrid2EVBatteryCommercial.L(T) + EnergyFromGrid2EVBatteryIndustrial.L(T))*EVChargeEfficiency + EPS;

Report_EVCharging_VRE(T) = (SolarEnergy2EVStorageChargedResidential.L(T) + SolarEnergy2EVStorageChargedCommercial.L(T) + SolarEnergy2EVStorageChargedIndustrial.L(T)
                               + SolarEnergyStorageDischargedResidential2EV.L(T) + SolarEnergyStorageDischargedCommercial2EV.L(T) + SolarEnergyStorageDischargedIndustrial2EV.L(T)
                               + (WindEnergy2EVStorageChargedResidential.L(T) + WindEnergy2EVStorageChargedCommercial.L(T) + WindEnergy2EVStorageChargedIndustrial.L(T))*RectifierEfficiency
                               + WindEnergyStorageDischargedResidential2EV.L(T) + WindEnergyStorageDischargedCommercial2EV.L(T) + WindEnergyStorageDischargedIndustrial2EV.L(T))*EVChargeEfficiency + EPS;
Report_EVDischarging_Travel(T) = EnergyEVStorageDischarged.L(T)  +  EPS;
Report_EVDischarging_V2G(T) = EnergyEVStorageDischargedV2G2Commercial.L(T) + EnergyEVStorageDischargedV2G2Industrial.L(T)  +  EPS;
SMAX_EnergyEVSOC = SMAX((T),EnergyEVSOC.L(T)) +  EPS;
Report_EVSOC(T) = EnergyEVSOC.L(T) + (EVBatteryStorageCapacity.L - SMAX_EnergyEVSOC) +  EPS;


parameter
Report_LoadResidential(T,*)
Report_LoadCommercial(T,*)
Report_LoadIndustrial(T,*)
Report_LoadTotal(T,*)
;

Report_LoadResidential(T,'Grid Electricity') = EnergyFromGrid2Residential.L(T) + EPS;
Report_LoadResidential(T,'Solar PV') = SolarEnergy2ResidentialDemand.L(T)*InverterEfficiency + EPS;
Report_LoadResidential(T,'Wind Turbine') = WindEnergy2ResidentialDemand.L(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency + EPS;
Report_LoadResidential(T,'V2G') = 0 + EPS;
Report_LoadResidential(T,'Battery-Solar') = SolarEnergyStorageDischarged2Residential.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadResidential(T,'Battery-Wind') = WindEnergyStorageDischarged2Residential.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadCommercial(T,'Grid Electricity') = EnergyFromGrid2Commercial.L(T) + EPS;
Report_LoadCommercial(T,'Solar PV') = SolarEnergy2CommercialDemand.L(T)*InverterEfficiency + EPS;
Report_LoadCommercial(T,'Wind Turbine') = WindEnergy2CommercialDemand.L(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency + EPS;
Report_LoadCommercial(T,'V2G') = EnergyEVStorageDischargedV2G2Commercial.L(T)*EVDischargeEfficiency*EVInverterEfficiency + EPS;
Report_LoadCommercial(T,'Battery-Solar') = SolarEnergyStorageDischarged2Commercial.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadCommercial(T,'Battery-Wind') = WindEnergyStorageDischarged2Commercial.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadIndustrial(T,'Grid Electricity') = EnergyFromGrid2Industrial.L(T) + EPS;
Report_LoadIndustrial(T,'Solar PV') = SolarEnergy2IndustrialDemand.L(T)*InverterEfficiency + EPS;
Report_LoadIndustrial(T,'Wind Turbine') = WindEnergy2IndustrialDemand.L(T)*InverterEfficiency*RectifierEfficiency*InverterEfficiency + EPS;
Report_LoadIndustrial(T,'V2G') = EnergyEVStorageDischargedV2G2Industrial.L(T)*EVDischargeEfficiency*EVInverterEfficiency + EPS;
Report_LoadIndustrial(T,'Battery-Solar') = SolarEnergyStorageDischarged2Industrial.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadIndustrial(T,'Battery-Wind') = WindEnergyStorageDischarged2Industrial.L(T)*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadTotal(T,'Grid Electricity') = EnergyFromGrid2Residential.L(T) + EnergyFromGrid2Commercial.L(T) + EnergyFromGrid2Industrial.L(T) + EPS;
Report_LoadTotal(T,'Solar PV') = (SolarEnergy2ResidentialDemand.L(T) + SolarEnergy2CommercialDemand.L(T) + SolarEnergy2IndustrialDemand.L(T))*InverterEfficiency + EPS;
Report_LoadTotal(T,'Wind Turbine') = (WindEnergy2ResidentialDemand.L(T) + WindEnergy2CommercialDemand.L(T) + WindEnergy2IndustrialDemand.L(T))*InverterEfficiency*RectifierEfficiency*InverterEfficiency + EPS;
Report_LoadTotal(T,'V2G') = (EnergyEVStorageDischargedV2G2Commercial.L(T) + EnergyEVStorageDischargedV2G2Industrial.L(T))*EVDischargeEfficiency*EVInverterEfficiency + EPS;
Report_LoadTotal(T,'Battery-Solar') = (SolarEnergyStorageDischarged2Residential.L(T) + SolarEnergyStorageDischarged2Commercial.L(T) + SolarEnergyStorageDischarged2Industrial.L(T))*DischargeEfficiency*InverterEfficiency + EPS;
Report_LoadTotal(T,'Battery-Wind') = (WindEnergyStorageDischarged2Residential.L(T) + WindEnergyStorageDischarged2Commercial.L(T) + WindEnergyStorageDischarged2Industrial.L(T))*DischargeEfficiency*InverterEfficiency + EPS;


*parameter
*Report_BatterySOC(T,*)
*Report_BatteryCharging(T,*) 
*Report_BatteryDischarging(T,*)
*;

*Report_BatterySOC(T,'Total') = SolarEnergySOCResidential.L(T) + WindEnergySOCResidential.L(T) + SolarEnergySOCCommercial.L(T) + WindEnergySOCCommercial.L(T) + SolarEnergySOCIndustrial.L(T) + WindEnergySOCIndustrial.L(T) + EPS;
*Report_BatterySOC(T,'Solar') = SolarEnergySOCResidential.L(T) + SolarEnergySOCCommercial.L(T) + SolarEnergySOCIndustrial.L(T) + EPS;
*Report_BatterySOC(T,'Wind') = WindEnergySOCResidential.L(T) + WindEnergySOCCommercial.L(T)+ WindEnergySOCIndustrial.L(T) + EPS;
*Report_BatteryCharging(T,'Total') = (SolarEnergyStorageChargedResidential.L(T) + SolarEnergyStorageChargedCommercial.L(T) + SolarEnergyStorageChargedIndustrial.L(T))*ChargeEfficiency +
*                                    (WindEnergyStorageChargedResidential.L(T) + WindEnergyStorageChargedCommercial.L(T) + WindEnergyStorageChargedIndustrial.L(T))*RectifierEfficiency*ChargeEfficiency + EPS;
*Report_BatteryCharging(T,'Solar') = (SolarEnergyStorageChargedResidential.L(T) + SolarEnergyStorageChargedCommercial.L(T) + SolarEnergyStorageChargedIndustrial.L(T))*ChargeEfficiency + EPS;
*Report_BatteryCharging(T,'Wind') = (WindEnergyStorageChargedResidential.L(T) + WindEnergyStorageChargedCommercial.L(T) + WindEnergyStorageChargedIndustrial.L(T))*RectifierEfficiency*ChargeEfficiency + EPS;
*Report_BatteryDischarging(T,'Total') = SolarEnergyStorageDischarged2Residential.L(T) + SolarEnergyStorageDischargedResidential2EV.L(T) + SolarEnergyStorageDischarged2Commercial.L(T) + SolarEnergyStorageDischargedCommercial2EV.L(T) + SolarEnergyStorageDischarged2Industrial.L(T) + SolarEnergyStorageDischargedIndustrial2EV.L(T)
*                                       + WindEnergyStorageDischarged2Residential.L(T) + WindEnergyStorageDischargedResidential2EV.L(T) + WindEnergyStorageDischarged2Commercial.L(T) + WindEnergyStorageDischargedCommercial2EV.L(T) + WindEnergyStorageDischarged2Industrial.L(T) + WindEnergyStorageDischargedIndustrial2EV.L(T) + EPS;
*Report_BatteryDischarging(T,'Solar') = SolarEnergyStorageDischarged2Residential.L(T) + SolarEnergyStorageDischargedResidential2EV.L(T) + SolarEnergyStorageDischarged2Commercial.L(T) + SolarEnergyStorageDischargedCommercial2EV.L(T) + SolarEnergyStorageDischarged2Industrial.L(T) + SolarEnergyStorageDischargedIndustrial2EV.L(T) + EPS;
*Report_BatteryDischarging(T,'Wind') = WindEnergyStorageDischarged2Residential.L(T) + WindEnergyStorageDischargedResidential2EV.L(T) + WindEnergyStorageDischarged2Commercial.L(T) + WindEnergyStorageDischargedCommercial2EV.L(T) + WindEnergyStorageDischarged2Industrial.L(T) + WindEnergyStorageDischargedIndustrial2EV.L(T) + EPS;


$set File S1
Execute_Unload "MicroGridOut_%File%.gdx";
Execute 'gdxxrw.exe i=MicroGridOut_%File%.gdx EpsOut=0 o=Microgrid_OUTPUT.xlsx squeeze=n index=Output!A1'