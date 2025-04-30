clear all; clc;

%SEPIC converter
%===============================================================================
%SEPIC parameters
Vout_v = 3.3;
Vripple_v = 0.001;
Iout_A = 0.300;

%SEPIC voltage in range
bat_min_v = 2.8;
bat_max_v = 4.2;
bat_range_v = [bat_min_v:0.02:bat_max_v];

%SEPIC dutty cycle work range
full_dutty_range = [0.2:0.01:0.8];

%SEPIC ideal full duty cycle range
full_k = full_dutty_range ./ (1 - full_dutty_range);
%SEPIC ideal battery powered duty cycle range
battery_k = Vout_v ./ bat_range_v;
battery_dutty_range = battery_k ./ (1 + battery_k);

%Plot ideal working graph
plot(full_dutty_range, full_k, 'k', "linewidth", 1)
xlabel("Dutty cycle (ton/toff)");
ylabel("Vout/Vin");
title("SEPIC 'D' range when battery powered");
hold on
plot(battery_dutty_range, battery_k, 'r', "linewidth", 3);
plot([0.5 0.5], [0 max(full_k)], 'k', "linestyle", ':', "linewidth", 1);
text(0.49, 2, "Buck", "horizontalalignment", "right", "verticalalignment", "top");
text(0.51, 2, "Boost", "horizontalalignment", "left", "verticalalignment", "top");
hold off

%SEPIC components
%===============================================================================
%Initial parameters
%Switching frequency
fsw_hz = 1200000;
Tsw_s = 1/fsw_hz;
tr_s = Tsw_s / 100;
tf_s = tr_s;
%Rectification diode
Vd_v = 0.3;
%Switch Q parameters
Qron_ohm = 0.5;
Qgd_F = 1.0E-9;
Ig = 0.1;
%Feedback divisor
Vfb_v = 1.25;
R1_ohm = 20000;
R2_ohm = (Vfb_v * R1_ohm) / (Vout_v - Vfb_v)
%Undervoltage divisor
Vuv_v = 1.5;

%Calculated parameters
%===============================================================================
Lpk2pk = 0.2;

Dmax = (Vout_v + Vd_v) / (bat_min_v + Vout_v + Vd_v);
Dmin = (Vout_v + Vd_v) / (bat_max_v + Vout_v + Vd_v);
Delta_IL_A = Iout_A * (Vout_v/bat_min_v) * Lpk2pk;

%Inductor independent core
L_H = (bat_min_v / (Delta_IL_A * fsw_hz)) * Dmax
IL1pk_A = Iout_A * ((Vout_v + Vd_v) / bat_min_v) * (1 + Lpk2pk/2);
IL2pk_A = Iout_A * (1 + Lpk2pk/2);

%Inductor on same core
LM_H = L_H / 2

%Switch
Vds_v = bat_max_v + Vd_v + Vout_v
IQpk_A = IL1pk_A + IL2pk_A
IQrms_A = Iout_A * sqrt((Vout_v + bat_min_v + Vd_v) * (Vout_v + Vd_v) / bat_min_v^2);
PQon_W = IQrms_A^2 * Qron_ohm * Dmax;
PQsw_W = (bat_max_v + Vd_v + Vout_v) * IQpk_A * Qgd_F * fsw_hz / Ig;
PQ_W = PQon_W + PQsw_W

%Diode
Vr_v = bat_max_v + Vout_v

%Coupling capacitor
Delta_Vc_v = 0.1 * bat_min_v;
Cs_F = (Iout_A * Dmax) / (fsw_hz * Delta_Vc_v)
Crms_A = Iout_A * sqrt((Vout_v + Vd_v) / bat_min_v);
Cripple_v = (Iout_A * Dmax) / (Cs_F * fsw_hz);

%In capacitor
Cin_rms_A = Delta_IL_A / sqrt(12);

%Out capacitor
Cout_F = (Iout_A * Dmin) / (Vripple_v * 0.5 * fsw_hz)
ESR_ohm = (Vripple_v * 0.5) / (IL1pk_A + IL2pk_A)

