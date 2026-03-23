% Parámetros configurables
A = 1;              % Amplitud
fc = 1000;          % Frecuencia de la señal (Hz)
fs_cont = 100000;   % Frecuencia de muestreo "continua" (Hz)
Ts_cont = 1/fs_cont;

t = 0:Ts_cont:0.01; % Vector de tiempo (10 ms por ejemplo)

% Señal sinusoidal
m = A * sin(2*pi*fc*t);

% Gráfico
figure;
plot(t, m);
title('Señal sinusoidal m(t)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;