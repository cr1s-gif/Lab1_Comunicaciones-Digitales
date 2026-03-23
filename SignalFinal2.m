clc; clear; close all;

%% 🔹 1) Señal original
A = 1;
fc = 1000;

fs_cont = 100000;
Ts_cont = 1/fs_cont;

t = 0:Ts_cont:0.01;

m = A * sin(2*pi*fc*t);

%% 🔹 2) PAM NATURAL
fs = 5000;
Ts = 1/fs;

d = 0.3;
tau = d * Ts;

p = zeros(size(t));

for i = 1:length(t)
    if mod(t(i), Ts) < tau
        p(i) = 1;
    end
end

pam_natural = m .* p;

%% 🔹 3) PAM INSTANTÁNEO
t_muestreo = 0:Ts:0.01;
muestras = A * sin(2*pi*fc*t_muestreo);

pam_inst = zeros(size(t));

for i = 1:length(t_muestreo)
    [~, idx] = min(abs(t - t_muestreo(i)));
    pam_inst(idx) = muestras(i);
end

%% 🔹 4) SUBPLOTS (3 gráficos en una figura)
figure;

% --- Señal original ---
subplot(3,1,1);
plot(t, m, 'b', 'LineWidth', 1.2);
title('Señal original m(t)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% --- PAM natural ---
subplot(3,1,2);
plot(t, pam_natural, 'r', 'LineWidth', 1.2);
title('PAM con muestreo natural');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% --- PAM instantáneo ---
subplot(3,1,3);
stem(t, pam_inst, 'g', 'filled');
title('PAM con muestreo instantáneo');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;

% Opcional: zoom en todos
xlim([0 0.002]);