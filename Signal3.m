clc; clear; close all;

%% 🔹 1) Señal original
A = 1;
fc = 1000;

fs_cont = 100000;
Ts_cont = 1/fs_cont;

t = 0:Ts_cont:0.01;

m = A * sin(2*pi*fc*t);

%% 🔹 2) Parámetros muestreo instantáneo
fs = 5000;          % Frecuencia de muestreo
Ts = 1/fs;

t_muestreo = 0:Ts:0.01;

% Obtener muestras de la señal
muestras = A * sin(2*pi*fc*t_muestreo);

%% 🔹 3) Señal PAM instantánea (tipo impulso)
pam_inst = zeros(size(t));

for i = 1:length(t_muestreo)
    [~, idx] = min(abs(t - t_muestreo(i))); % encontrar índice más cercano
    pam_inst(idx) = muestras(i);
end

%% 🔹 4) Gráfica
figure;
plot(t, m, 'b', 'LineWidth', 1.2); hold on;

% usar stem para visualizar mejor
stem(t, pam_inst, 'r', 'filled');

legend('m(t)', 'PAM instantáneo');
title('PAM con muestreo instantáneo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;