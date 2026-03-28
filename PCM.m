clc; clear; close all;

%% 🔹 1) Parámetros (Según guía)
A = 1;              % Amplitud 
fm = 1000;          % Frecuencia de información (Hz)
fs = 10000;         % Frecuencia de muestreo (configurable) 
Nbits = 3;          % Bits para PCM (configurable) 

%% 🔹 2) Tiempo y Señal Original
dt = 1/100000;      % Muestras cada 10 us 
t_final = 2/fm;     % 2 ciclos para ver bien el gráfico
t = 0:dt:t_final;
mensaje = A * sin(2*pi*fm*t); % m(t) analógica

%% 🔹 3) Muestreo Instantáneo (PAM)
Ts = 1/fs;
t_muestreo = 0:Ts:t_final;
muestras = A * sin(2*pi*fm*t_muestreo); % Samples puntuales (instantáneos)

% Para graficar el PAM instantáneo como pulsos (ancho d)
d = 0.3; 
tau = d * Ts;
pam_inst = zeros(size(t));
for i = 1:length(t_muestreo)
    idx = (t >= t_muestreo(i)) & (t < t_muestreo(i) + tau);
    pam_inst(idx) = muestras(i);
end

%% 🔹 4) Cuantización PCM
L = 2^Nbits;        % Niveles de cuantización 
Vmax = A;
Vmin = -A;
delta = (Vmax - Vmin) / L; % Tamaño del paso (step size)

% Definir los niveles de reconstrucción (centros de los intervalos)
niveles = Vmin + delta/2 : delta : Vmax - delta/2;

% Cuantizar cada muestra al nivel más cercano
muestras_q = zeros(size(muestras));
for i = 1:length(muestras)
    [~, idx_nivel] = min(abs(muestras(i) - niveles));
    muestras_q(i) = niveles(idx_nivel);
end

% Construir señal PAM cuantificada para el gráfico
pam_cuant = zeros(size(t));
for i = 1:length(t_muestreo)
    idx = (t >= t_muestreo(i)) & (t < t_muestreo(i) + tau);
    pam_cuant(idx) = muestras_q(i);
end

%% 🔹 5) Cálculo del Error
% El error se calcula sobre las muestras instantáneas y los niveles asignados
error_q = muestras - muestras_q;

%% 🔹 6) GRÁFICOS COMPACTADOS
fig = figure('Color','w','Name','Resultados PCM');
tlo = tiledlayout(fig, 2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

% --- Gráfico (a): m(t), PAM inst y PAM cuantificado ---
ax1 = nexttile(tlo);
% Color 1: Señal Original (Verde)
plot(ax1, t, mensaje, 'Color', [0 0.6 0], 'LineWidth', 1.5, 'LineStyle', '--', 'DisplayName', 'm(t) original'); hold on;
% Color 2: PAM cuantificado (Rojo, más grueso para que resalte debajo)
plot(ax1, t, pam_cuant, 'Color', [0.85 0 0], 'LineWidth', 2.5, 'DisplayName', 'PAM cuantificado');
% Color 3: PAM instantáneo (Azul)
plot(ax1, t, pam_inst, 'Color', [0 0 0.8], 'LineWidth', 1.2, 'DisplayName', 'PAM instantáneo');

title(ax1, ['PCM: N = ', num2str(Nbits), ' bits (', num2str(L), ' niveles)']);
xlabel(ax1, 'Tiempo (s)'); ylabel(ax1, 'Amplitud');
legend(ax1, 'Location', 'best'); grid(ax1, 'on'); xlim(ax1, [0 t_final]);

% --- Gráfico (b): Error de cuantización ---
ax2 = nexttile(tlo);
% Reutilizamos el Color 2 (Rojo) para no introducir un cuarto color
stem(ax2, t_muestreo, error_q, 'filled', 'Color', [0.85 0 0], 'LineWidth', 1.5);
title(ax2, 'Error de Cuantización por Muestra Instantánea');
xlabel(ax2, 'Tiempo (s)'); ylabel(ax2, 'Error (V)');
grid(ax2, 'on'); xlim(ax2, [0 t_final]);

linkaxes([ax1, ax2], 'x');