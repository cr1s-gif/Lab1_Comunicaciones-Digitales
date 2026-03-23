% Script final: Señales PAM con fondo blanco en figura y en las zonas de trazado
% Colores: verde (señal), rojo (PAM natural), azul (PAM instantáneo)
% Compatible con versiones que no soportan ciertas propiedades de tiledlayout/legend

% Parámetros del mensaje
A = 1;
fm = 1000;           % Frecuencia del mensaje en Hz

% Tiempo
dt = 1/100000;       % Paso de tiempo (configurable)
t_final = 3 * (1/fm);% 3 ciclos completos
t = 0:dt:t_final;    % Vector de tiempo

% Modulación PAM
fs = 10000;          % Frecuencia de muestreo PAM
d = 0.3;             % Ciclo de trabajo

% Generamos las señales
mensaje = A * sin(2*pi*fm*t);

Ts_pam = 1/fs;
tau = d * Ts_pam;
tren_pulsos = mod(t, Ts_pam) < tau;

% PAM Natural
pam_natural = mensaje .* tren_pulsos;

% PAM Instantáneo (reteniendo muestras al inicio del pulso)
t_muestras = floor(t * fs) / fs;
mensaje_retenido = A * sin(2*pi*fm*t_muestras);
pam_instantaneo = mensaje_retenido .* tren_pulsos;

% ----------------------------------------------------
% Figura con fondo totalmente blanco y colores resaltados
% ----------------------------------------------------
fig = figure('Color','w');           % fondo de la figura blanco
set(fig, 'InvertHardcopy', 'off');   % preservar fondo blanco al imprimir/guardar

% tiledlayout (sin usar propiedades no soportadas)
tlo = tiledlayout(fig,3,1,'Padding','compact','TileSpacing','compact');

% 1) Señal original (verde)
ax1 = nexttile(tlo);
% Asegurar que la zona de trazado sea blanca
set(ax1, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
h1 = plot(ax1, t, mensaje, 'Color', [0 0.6 0], 'LineWidth', 1.5); % guardar handle
title(ax1, 'Señal Original', 'Color', 'k');
xlabel(ax1, 'Tiempo (s)', 'Color', 'k');
ylabel(ax1, 'Amplitud', 'Color', 'k');
grid(ax1,'on');

set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
xlim([0, 0.0015]);

% 2) PAM Natural (rojo)
ax2 = nexttile(tlo);
set(ax2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
h2 = plot(ax2, t, pam_natural, 'Color', [0.85 0 0], 'LineWidth', 2); % guardar handle
title(ax2, 'PAM Natural', 'Color', 'k');
xlabel(ax2, 'Tiempo (s)', 'Color', 'k');
ylabel(ax2, 'Amplitud', 'Color', 'k');
grid(ax2,'on');

set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
xlim([0, 0.0015]);

% 3) PAM Instantáneo (azul)
ax3 = nexttile(tlo);
set(ax3, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
h3 = plot(ax3, t, pam_instantaneo, 'Color', [0 0 0.8], 'LineWidth', 1.5); % guardar handle
title(ax3, 'PAM Instantáneo', 'Color', 'k');
xlabel(ax3, 'Tiempo (s)', 'Color', 'k');
ylabel(ax3, 'Amplitud', 'Color', 'k');
grid(ax3,'on');


% Ajustes finales: límites y sincronización de ejes
xlim([0, 0.0015]);
linkaxes([ax1 ax2 ax3], 'x'); % sincroniza zoom horizontal

% Opcional: guardar la figura manteniendo fondo blanco (descomentar para usar)
% print(fig, 'PAM_Comparacion.png', '-dpng', '-r300');
% Ejes y zoom
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k');
xlim([0, 0.0015]);
