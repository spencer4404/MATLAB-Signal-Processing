% Spencer Iannantuono
% ECE 213 
% Computing Excersize 1 
% April 28, 2024
% Computing and Plotting Analytical and Numerical Convolutions 
% of output voltage y(t) of an RC circuit

clear;
clc;

% Basic Variables
V0 = 12; % Input voltage (V)
R = 10; % Resistance (Ohms)
C = 2; % Capacitance (mF)
tau = R * C; % Time constant (ms)
N = 4000; % Number of time intervals
tmax = 8 * tau; % max time to consider (ms)
dt = tmax / N; % time step

% Time array 
t = 0:dt:tmax; % Time vector from 0 to tmax with N intervals

% Functions
xt = V0 * (t >= 0 & t <= 2*tau); % Create the rectangular pulse
ht = (1/tau) * exp(-t/tau); % impulse response

% Analytical solutions, given
yt_analytic1 = V0 * (1 - exp(-t/tau));
yt_analytic2 = V0 * (1 - exp(-2)) * exp(-(t - 2*tau)/tau);

% Convolution
yt_numerical = zeros(1, length(t)); % Output voltage array

for i = 1:length(t)
    for j = 1:i % Perform the convolution
        % Convolution sum
        yt_numerical(i) = yt_numerical(i) + xt(j) * ht(i-j+1) * dt; 
    end
end

% Plotting
figure('Position', [200,200,1400,750]);
plot(t, yt_numerical, 'b-', 'LineWidth', 2) % Numerical solution
hold on;
plot(t, yt_analytic1, 'g:', 'LineWidth', 2) % Charging phase
plot(t, yt_analytic2, 'r:', 'LineWidth', 2) % Discharging phase
ax = gca; ax.FontSize = 14;
title('Output Voltage y(t)', FontSize = 24)
xlabel('Time (ms)', FontSize = 18)
ylabel('Voltage (V)', FontSize = 18)
legend('Numerical Convolution', ...
    '$y_{charge}(t) = V_0\cdot (1 - e^{-t/\tau})$',...
    ['$y_{discharge}(t) = V_0\cdot (1 - e^{-2})' ...
    '\cdot e^{-(t-2\tau)/\tau}$'], ...
     'Interpreter', 'latex', 'Location', 'best', FontSize = 20);
axis([0 tmax 0 V0*1.1])
grid on;

% -------- Checks -------- %

% Check Analytic Solution Equality @ 2tau

yt_analytic1_2tau = V0 * (1 - exp(-2*tau/tau)); % Values at 2tau
yt_analytic2_2tau = V0 * (1 - exp(-2)) * exp(-(2*tau - 2*tau)/tau);
analytic_diff = yt_analytic1_2tau - yt_analytic2_2tau; % Difference
fprintf(['Difference Between Analytic Functions at 2*tau' ...
    ' (should be 0): %f\n'], analytic_diff )

% Check maximum value

% Maximum value in the yt_numerical array, indexed
[max_value, max_index] = max(yt_numerical);

% Difference 1
numerical_analytical_diff1 = yt_analytic1_2tau - max_value; 

fprintf(['Difference Between Max of Numerical and Analytical 1 at ' ...
    '2*tau (should be ~0): %f\n'], numerical_analytical_diff1)

% Difference 2
numerical_analytical_diff2 = yt_analytic2_2tau - max_value; 
fprintf(['Difference Between Max of Numerical and Analytical 2 at ' ...
    '2*tau (should be ~0): %f\n'], numerical_analytical_diff2)

% Check time of max_value, should be 40
max_time = t(max_index); % Find corresponding time
fprintf('The maximum value occurs at time %g\n',max_time);






