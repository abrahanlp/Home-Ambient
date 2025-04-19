clear;

%SEPIC converter
%=========================================
%SEPIC voltage out
Vout_v = 3.3;

%SEPIC voltage in range
bat_min_v = 2.8;
bat_max_v = 4.2;
bat_range_v = [bat_min_v:0.02:bat_max_v];

full_dutty_range = [0.2:0.01:0.8];

%SEPIC full duty cycle range
full_k = full_dutty_range ./ (1 - full_dutty_range);
%SEPIC battery powered duty cycle range
battery_k = Vout_v ./ bat_range_v;
battery_dutty_range = battery_k ./ (1 + battery_k);

plot(full_dutty_range, full_k, 'k', "linewidth", 1)
xlabel("Dutty cycle (ton/toff)");
ylabel("Vout/Vin");
title("SEPIC Battery Powered");
hold on
plot(battery_dutty_range, battery_k, 'r', "linewidth", 3);
plot([0.5 0.5], [0 max(full_k)], 'k', "linestyle", ':', "linewidth", 1);
text(0.49, 2, "Buck", "horizontalalignment", "right", "verticalalignment", "top");
text(0.51, 2, "Boost", "horizontalalignment", "left", "verticalalignment", "top");
hold off

