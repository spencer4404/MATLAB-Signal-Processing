% Spencer Iannantuono
% ECE 213 
% Computing Excersize 2
% May 7, 2024
% Computing and plotting the impulse response of an RLC circuit

clear;
clc;

% Basic Variables, user-inputted
R = input("Resistance (Ohms): ");
Li = input("Inductance (mH): ");
Ci = input("Capacitance (Micro-Farads): ");

% Unit conversion
L = Li/1000;
C = Ci/1000000;

% Time vector 
N = 4001; % Intervals
tmin = 0; % Min time
tmax = .120; % Max Time
ts = linspace(tmin,tmax,N); % Time (s)
tms = ts*1000; % Time (ms), for plotting

% Variables for impulse response
a = R / (2*L); % alpha
w02 = 1 / (L*C); % (Omega nought)^2
s1 = -R/(2*L) + sqrt((R / (2*L) )^2 - 1/(L*C));
s2 = -R/(2*L) - sqrt((R / (2*L) )^2 - 1/(L*C));

% ------ Begin if statements ------ %

% Overdamped
if a^2 > w02
    damp = 'Overdamped';

    % Constants 
    A = -(R/L) * s1 / (s2 - s1);
    B = (R/L) * s2 / (s2 - s1);

    % Impulse Response
    h1t = A*exp(s1*ts);
    h2t = B*exp(s2*ts);
    ht = h1t + h2t; % Sum the parts

    % Legend Strings
    st_h1t = sprintf('$%.2f e^{%d t}$', A, s1);
    st_h2t = sprintf('$%.2f e^{%d t}$', B, s2 );
    st_ht = [st_h1t ' ' st_h2t];
end 

% Critically Damped
if a^2 == w02
    damp = 'Critically Damped';

    % Redefine s
    S = s1;

    % Constants
    A = R / L;
    B = -R / L * a;

    % Impulse response
    h1t = A*exp(-a*ts); 
    h2t = B*ts.*exp(-a*ts);
    ht = h1t + h2t; % Sum the parts

    % Legend Strings
    st_h1t = sprintf('$%d e^{-%d t}$', A,a);
    st_h2t = sprintf('$%d e^{-%d t}$', B,a);
    st_ht = [st_h1t '+' st_h2t];
end

% Underdamped
if a^2 < w02
    damp = 'Underdamped';

    % Define omega
    w = sqrt(w02 - a^2);
    s1 = -a + 1j*w;
    s2 = -a - 1j*w;

    % Constants 
    A = R / L;
    B = R / L * a / w;

    % Impulse Response
    h1t = A*exp(-a*ts) .* cos(w*ts);
    h2t = B*exp(-a*ts) .* sin(w*ts);
    ht = h1t + h2t;

    % Legend strings
    st_h1t = sprintf('$%d e^{-%d t} cos(%d t)$', A, a, w);
    st_h2t = sprintf('$%d e^{-%d t} sin(%d t)$', B, a, w);
    st_ht = [st_h1t '+' st_h2t];
end

% ------ Plotting ------ %

figure('Position', [200,200,1400,750]);
plot(tms, h1t, 'b:', 'LineWidth', 2) 
hold on;
plot(tms, h2t, 'g:', 'LineWidth', 2) 
plot(tms, ht, 'r', 'LineWidth', 2) 
grid on;
ax = gca; ax.FontSize = 14;

% Create dynamic title
title_str = sprintf('Impulse Response $h(t)$ of a(n) %s RLC Circuit:', ...
    damp);
rlc_vals = sprintf('$R = %d\\Omega$, $L = %dmH$, $C = %d \\mu F$', ...
    R, Li, Ci);
title(title_str, rlc_vals, Interpreter='latex' , FontSize= 28)

% Create dynamic legend
legend_str = {st_h1t, st_h2t, st_ht};
legend(legend_str, Interpreter="latex", FontSize=24, Location="Best");

% Axis labels
xlabel('Time (ms)', FontSize=21, Interpreter='latex');
ylabel('Voltage (V)', FontSize=21, Interpreter= 'latex');


