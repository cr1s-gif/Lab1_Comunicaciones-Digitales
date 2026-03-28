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

% Figura única con fondo blanco
fig = figure('Color','w');
set(fig, 'InvertHardcopy', 'off');   % preservar fondo blanco al imprimir/guardar

ax = axes('Parent',fig, 'Color','w'); % una sola axes (rectángulo)
hold(ax,'on');

% Ploteo de las tres señales
h1 = plot(ax, t, mensaje,        'Color', [0 0.6 0], 'LineWidth', 1.5, 'DisplayName','Señal Original');
h2 = plot(ax, t, pam_natural,    'Color', [0.85 0 0], 'LineWidth', 2.0, 'DisplayName','PAM Natural');
h3 = plot(ax, t, pam_instantaneo,'Color', [0 0 0.8], 'LineWidth', 1.5, 'DisplayName','PAM Instantáneo');

% Etiquetas, leyenda y aspecto
title(ax, 'Comparación de Señales PAM', 'Color','k');
xlabel(ax, 'Tiempo (s)', 'Color','k');
ylabel(ax, 'Amplitud', 'Color','k');
grid(ax,'on');
legend(ax,'show','Location','northeast');
xlim(ax, [0, 0.0015]);

hold(ax,'off');
