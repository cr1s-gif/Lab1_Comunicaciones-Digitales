clc; clear; close all;

%% 🔹 1) Parámetros del mensaje
A = 1;
fm = 1000;

%% 🔹 2) Tiempo
dt = 1/100000;
t_final = 3 * (1/fm);
t = 0:dt:t_final;

%% 🔹 3) Modulación PAM
fs = 10000;
d = 0.3;

mensaje = A * sin(2*pi*fm*t);

Ts_pam = 1/fs;
tau = d * Ts_pam;
tren_pulsos = mod(t, Ts_pam) < tau;

% PAM Natural
pam_natural = mensaje .* tren_pulsos;

% PAM Instantáneo
t_muestras = floor(t * fs) / fs;
mensaje_retenido = A * sin(2*pi*fm*t_muestras);
pam_instantaneo = mensaje_retenido .* tren_pulsos;

%% 🔹 4) TRANSFORMADA DE FOURIER

N = length(t);
fs_cont = 1/dt;

f = (0:N-1)*(fs_cont/N);

M = abs(fft(mensaje))/N;
PAM_nat = abs(fft(pam_natural))/N;
PAM_inst = abs(fft(pam_instantaneo))/N;

half = 1:floor(N/2);

f_pos = f(half);
M_pos = M(half);
PAM_nat_pos = PAM_nat(half);
PAM_inst_pos = PAM_inst(half);

%% 🔹 5) FIGURA FFT (TODO BLANCO REAL)

fig_fft = figure;
set(fig_fft, 'Color','w');
set(fig_fft, 'InvertHardcopy','off');

tlo2 = tiledlayout(fig_fft,3,1,'Padding','compact','TileSpacing','compact');

% --- Señal original ---
ax1 = nexttile;
set(ax1, 'Color','w');
plot(ax1, f_pos, M_pos, 'Color', [0 0.6 0], 'LineWidth', 1.5);
title('FFT Señal Original');
ylabel('|X(f)|');
grid on;
xlim([0 20000]);

% --- PAM natural ---
ax2 = nexttile;
set(ax2, 'Color','w');
plot(ax2, f_pos, PAM_nat_pos, 'Color', [0.85 0 0], 'LineWidth', 1.5);
title('FFT PAM Natural');
ylabel('|X(f)|');
grid on;
xlim([0 20000]);

% --- PAM instantáneo ---
ax3 = nexttile;
set(ax3, 'Color','w');
plot(ax3, f_pos, PAM_inst_pos, 'Color', [0 0 0.8], 'LineWidth', 1.5);
title('FFT PAM Instantáneo');
xlabel('Frecuencia (Hz)');
ylabel('|X(f)|');
grid on;
xlim([0 20000]);

% Sincronizar ejes
linkaxes([ax1 ax2 ax3], 'x');