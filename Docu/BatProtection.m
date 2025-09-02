clear all; clc;

%Undervoltage battery protection based on MCP65R4XT
%Under-voltage protecction is intended to be around 2.85V
%measured on battery terminals
UVP_v = 2.85;

%Vref depend on MCP65R46 PartNumber:
%2.40V for MCP65R4XT-24XX
%1.21V for MCP65R4XT-12XX
Vref_v = 2.4;

%Vol could reach 0,2V
Vol_v = 0;

%Voh will vary with battery voltage and switch drop
%Under discharging condition the switch resistor (PMOS DMG2301L):
Rsw_ohm = 0.150;
%Load will vary between 30mA and 100mA without relay
%increased by ~115mA with the relay powered
load_A = 0.2;
Voh_v = UVP_v - Rsw_ohm*(load_A);

R1_ohm = 10000;
Rf_ohm = 20000;

%Undervoltage is triggered at
Vthl_v = Vref_v*(1 + R1_ohm/Rf_ohm) - Voh_v*(R1_ohm/Rf_ohm);

