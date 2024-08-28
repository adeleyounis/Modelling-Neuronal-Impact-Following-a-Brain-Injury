% Data from Table 4

% mT Max, hT Min, Max VmT (mV)

% 10mV shift data
data_10mV = [
    0.98558, 0.14542, 32.1356;
    0.98916, 0.11141, 31.627;
    0.13652, 0.80405, -47.8846
];

% 14mV shift data
data_14mV = [
    0.98071, 0.16933, 30.7197;
    0.98574, 0.11936, 31.6097;
    0.08411, 0.88095, -48.1503
];

% 20mV shift data
data_20mV = [
    0.96921, 0.20451, 28.899;
    0.7214, 0.26579, -11.2934;
    0.044106, 0.94355, -48.321
];

% Affected sodium gate percentage for the x-axis
sodium_percentage = [10,50,90];

% Extracting 10 mV shift data for plotting
mT_max_10mV = data_10mV(:,1); 
hT_min_10mV = data_10mV(:,2);
VmT_max_10mV = data_10mV(:,3);

% Extracting 14 mV shift data for plotting
mT_max_14mV = data_14mV(:,1); 
hT_min_14mV = data_14mV(:,2);
VmT_max_14mV = data_14mV(:,3);

% Extracting 14 mV shift data for plotting
mT_max_20mV = data_20mV(:,1); 
hT_min_20mV = data_20mV(:,2);
VmT_max_20mV = data_20mV(:,3);

% Equilibrium values for mT and hT
% mT Eq, hT Eq
equilibrium_values = [
    0.01625, 0.86517;
    0.009904, 0.92078;
    0.004628, 0.96602
    ];

% voltage shift values
voltage_shift = [10,14,20];

% Extracting data for plotting
mT_eq = equilibrium_values(:, 1);
hT_eq = equilibrium_values(:, 2);

% Plotting mT Max
figure;
plot(sodium_percentage, mT_max_10mV, '-o', 'LineWidth', 2);
hold on;
plot(sodium_percentage, mT_max_14mV, '-s', 'LineWidth', 2);
plot(sodium_percentage, mT_max_20mV, '-d', 'LineWidth', 2);
hold off;
xlabel('Sodium Gates (%)');
ylabel('mT Max');
title('mT Max vs Sodium Gates');
legend('10mV', '14mV', '20mV', 'Location', 'Best');
grid on;
xlim([0, 100]);
ylim([-0.1, 1.1]);

% Plotting hT Min
figure;
plot(sodium_percentage, hT_min_10mV, '-o', 'LineWidth', 2);
hold on;
plot(sodium_percentage, hT_min_14mV, '-s', 'LineWidth', 2);
plot(sodium_percentage, hT_min_20mV, '-d', 'LineWidth', 2);
hold off;
xlabel('Sodium Gates (%)');
ylabel('hT Min');
title('hT Min vs Sodium Gates');
legend('10mV', '14mV', '20mV', 'Location', 'Best');
grid on;
xlim([0, 100]);
ylim([-0.1, 1.1]);

% Plotting VmT Max
figure;
plot(sodium_percentage, VmT_max_10mV,'-o', 'LineWidth', 2);
hold on;
plot(sodium_percentage, VmT_max_14mV, '-s', 'LineWidth', 2);
plot(sodium_percentage, VmT_max_20mV, '-d', 'LineWidth', 2);
hold off;
xlabel('Sodium Gates (%)');
ylabel('VmT Max');
title('VmT Max vs Sodium Gates');
legend('10mV', '14mV', '20mV', 'Location', 'Best');
grid on;

% Plotting mT and hT equilibrium values
figure;

% Subplot for mT Eq
subplot(2, 1, 1);
plot(voltage_shift, mT_eq, '-o', 'LineWidth', 2);
xlabel('Voltage Shift (mV)');
ylabel('mT Eq');
title('mT Eq vs Voltage Shift');
grid on;

% Subplot for hT Eq
subplot(2, 1, 2);
plot(voltage_shift, hT_eq, '-o', 'LineWidth', 2);
xlabel('Voltage Shift (mV)');
ylabel('hT Eq');
title('hT Eq vs Voltage Shift');
grid on;


