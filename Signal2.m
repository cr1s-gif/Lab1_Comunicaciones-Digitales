clc; clear; close all;

%% 🔹 1) Parámetros señal original
A = 1;              % Amplitud
fc = 1000;          % Frecuencia señal (Hz)

fs_cont = 100000;   % "Frecuencia continua" (Hz)
Ts_cont = 1/fs_cont;

t = 0:Ts_cont:0.01; % Tiempo (10 ms)

% Señal original
m = A * sin(2*pi*fc*t);

%% 🔹 2) Parámetros PAM natural
fs = 5000;          % Frecuencia de muestreo PAM (Hz)
Ts = 1/fs;

d = 0.3;            % Duty cycle (0 < d < 1)
tau = d * Ts;       % Ancho del pulso

%% 🔹 3) Tren de pulsos
p = zeros(size(t));

for i = 1:length(t)
    if mod(t(i), Ts) < tau
        p(i) = 1;
    end
end

%% 🔹 4) PAM natural
pam_natural = m .* p;

%% 🔹 5) Gráfica
figure;
plot(t, m, 'b', 'LineWidth', 1.2); hold on;
plot(t, pam_natural, 'r', 'LineWidth', 1.2);

legend('m(t)', 'PAM natural');
title('Modulación PAM con muestreo natural');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;