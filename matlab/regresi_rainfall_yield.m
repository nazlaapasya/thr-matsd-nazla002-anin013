% ANALISIS HUBUNGAN CURAH HUJAN & HASIL PANEN (RICE, PADDY)
clear; clc; close all;

%% Membersihkan Dataset dan Eksplorasi Data (EDA)

fprintf('         Membersihkan Dataset dan Eksplorasi Data (EDA)          \n');

% 1. Import file dari folder
if ~exist('rainfall.csv', 'file') || ~exist('yield.csv', 'file')
    error('Error: File "rainfall.csv" atau "yield.csv" tidak ditemukan di folder ini!');
end

% 2. Membaca file CSV yang sudah diimport
opts_rain = detectImportOptions('rainfall.csv', 'TextType', 'string');
opts_yield = detectImportOptions('yield.csv', 'TextType', 'string');
df_rain = readtable('rainfall.csv', opts_rain);
df_yield = readtable('yield.csv', opts_yield);

% 3. Normalisasi nama kolom (menghilangkan spasi tak sengaja di awal/akhir nama kolom)
df_rain.Properties.VariableNames = strtrim(df_rain.Properties.VariableNames);
df_yield.Properties.VariableNames = strtrim(df_yield.Properties.VariableNames);

% 4. Pembersihan data rainfall (mengonversi '..' menjadi NaN dan menghapusnya)
if ~isnumeric(df_rain.average_rain_fall_mm_per_year)
    df_rain.average_rain_fall_mm_per_year = str2double(df_rain.average_rain_fall_mm_per_year);
end
df_rain(isnan(df_rain.average_rain_fall_mm_per_year), :) = [];

% 5. Penggabungan datset yield dan rainfall berdasarkan kesamaan kolom area dan year
merged_data = innerjoin(df_yield, df_rain, 'Keys', {'Area', 'Year'});

% Filtering data untuk mengecek korelasi curah hujan dengan satu jenis tanaman
pilih_tanaman = 'Rice, paddy'; 

if ~strcmpi(pilih_tanaman, 'All')
    merged_data = merged_data(strcmpi(merged_data.Item, pilih_tanaman), :);
    fprintf('Menyaring data khusus untuk komoditas: %s\n', pilih_tanaman);
end

% Menentukan Variabel X dan Y
X = merged_data.average_rain_fall_mm_per_year; % X = Curah hujan (mm)
Y = merged_data.Value / 10000; % Y = Hasil panen diubah dari hg/ha menjadi Ton/ha

% 6. Perhitungan Statistik Deskriptif
fprintf('\nStatistik Deskriptif Variabel X (Curah Hujan):\n');
fprintf('  Mean   : %.2f mm\n  Median : %.2f mm\n  Std Dev: %.2f mm\n', mean(X), median(X), std(X));
fprintf('Statistik Deskriptif Variabel Y (Hasil Panen %s):\n', pilih_tanaman);
fprintf('  Mean   : %.2f Ton/ha\n  Median : %.2f Ton/ha\n  Std Dev: %.2f Ton/ha\n\n', mean(Y), median(Y), std(Y));

% 7. Deteksi outliers menggunakan Metode IQR pada Variabel Y
Q1 = prctile(Y, 25); Q3 = prctile(Y, 75); IQR_val = Q3 - Q1;
batas_bawah = Q1 - 1.5 * IQR_val; batas_atas = Q3 + 1.5 * IQR_val;
outliers = (Y < batas_bawah) | (Y > batas_atas);
fprintf('Analisis Outlier Data:\n  Jumlah data outliers terdeteksi: %d dari %d data.\n\n', sum(outliers), length(Y));

% 8. Pembuatan Scatter Plot
figure('Name', 'Tahap 01: Scatter Plot Hasil Join Data', 'NumberTitle', 'off');
scatter(X, Y, 25, 'filled', 'MarkerFaceColor', [0.1 0.6 0.4], 'MarkerEdgeColor', 'none'); 
grid on; hold on;
title(['Scatter Plot Data Riil: Curah Hujan vs Hasil Panen (', pilih_tanaman, ')']);
xlabel('Curah Hujan Tahunan (mm)'); ylabel('Hasil Panen (Ton/ha)');

%% Pemilihan dan Justifikasi Model
fprintf('\nModel regresi yang digunakan untuk dataset ini adalah regresi parabolik\n');

%% Implementasi Perhitungan Persamaan Normalisasi 

fprintf('         \nPerhitungan Persamaan Normalisasi             \n');

% Pembagian Data: 80% Training Set & 20% Testing Set
rng(10); % Mengunci keacakan agar hasil konsisten saat dijalankan ulang
n_total = length(X);
porsi_train = 0.8;
idx_acak = randperm(n_total);
idx_train = idx_acak(1:round(porsi_train * n_total));
idx_test = idx_acak(round(porsi_train * n_total) + 1:end);

X_train = X(idx_train); Y_train = Y(idx_train);
X_test = X(idx_test);   Y_test = Y(idx_test);

% Perhitungan sigma
n_tr = length(X_train);
s_x = sum(X_train);      s_x2 = sum(X_train.^2);
s_x3 = sum(X_train.^3);  s_x4 = sum(X_train.^4);
s_y = sum(Y_train);      s_xy = sum(X_train .* Y_train);  s_x2y = sum((X_train.^2) .* Y_train);

% Matriks Normal untuk Model Parabolik (Derajat 2)
Matriks_A_Para = [n_tr,   s_x,  s_x2; ...
                  s_x,   s_x2,  s_x3; ...
                  s_x2,  s_x3,  s_x4];
Matriks_B_Para = [s_y; s_xy; s_x2y];
coef_manual = Matriks_A_Para \ Matriks_B_Para; % Menyelesaikan persamaan [a; b; c]

% Toolbox dan utility MATLAB
p_lin_matlab  = polyfit(X_train, Y_train, 1); % Model Linier bawaan
p_para_matlab = polyfit(X_train, Y_train, 2); % Model Parabolik bawaan

fprintf('Validasi hasil komputasi ')
fprintf('Validasi Hasil Komputasi Koefisien Kuadratik:\n');
fprintf('  -> Hasil Rumus Manual  : a = %7.4f, b = %7.4f, c = %7.6f\n', coef_manual(1), coef_manual(2), coef_manual(3));
fprintf('  -> Hasil Utility MATLAB: a = %7.4f, b = %7.4f, c = %7.6f\n\n', p_para_matlab(3), p_para_matlab(2), p_para_matlab(1));

%% Evaluasi Model dan Uji Data Test

fprintf('                Evaluasi Model                         \n');

% Prediksi menggunakan data uji (Test Set)
Y_pred_lin  = polyval(p_lin_matlab, X_test);
Y_pred_para = polyval(p_para_matlab, X_test);

% Metrik Performa Model Linier
mae_lin  = mean(abs(Y_test - Y_pred_lin));
rmse_lin = sqrt(mean((Y_test - Y_pred_lin).^2));
r2_lin   = 1 - (sum((Y_test - Y_pred_lin).^2) / sum((Y_test - mean(Y_test)).^2));

% Metrik Performa Model Parabolik
mae_para  = mean(abs(Y_test - Y_pred_para));
rmse_para = sqrt(mean((Y_test - Y_pred_para).^2));
r2_para   = 1 - (sum((Y_test - Y_pred_para).^2) / sum((Y_test - mean(Y_test)).^2));

% Menampilkan Tabel Perbandingan Evaluasi
fprintf('TABEL PERBANDINGAN PERFORMA (PADA DATA UJI):\n');
fprintf('--------------------------------------------------\n');
fprintf('Metrik Evaluasi   | Model Linier | Model Parabolik\n');
fprintf('--------------------------------------------------\n');
fprintf('MAE (Sifat Error) |   %7.4f    |   %7.4f\n', mae_lin, mae_para);
fprintf('RMSE (Akurasi)    |   %7.4f    |   %7.4f\n', rmse_lin, rmse_para);
fprintf('R-Square (R2)     |   %7.4f    |   %7.4f\n', r2_lin, r2_para);
fprintf('--------------------------------------------------\n\n');

% Visualisasi Kurva Fitting Terbaik
X_domain = linspace(min(X), max(X), 1000);
plot(X_domain, polyval(p_lin_matlab, X_domain), 'r--', 'LineWidth', 2);
plot(X_domain, polyval(p_para_matlab, X_domain), 'b-', 'LineWidth', 2.5); % Mengubah warna garis parabolik menjadi biru
legend('Data Aktual Padi', 'Tren Garis Linier', 'Tren Parabolik Kuadratik', 'Location', 'Best');

% Grafik Analisis Galat (Residual Plot) Model Parabolik
figure('Name', 'Tahap 04: Grafik Analisis Residual', 'NumberTitle', 'off');
stem(X_test, Y_test - Y_pred_para, 'filled', 'Color', [0.2 0.5 0.3]);
hold on; yline(0, 'k-', 'LineWidth', 1.5); grid on;
title(['Plot Residual Plot Model Parabolik - ', pilih_tanaman]);
xlabel('Curah Hujan (mm)'); ylabel('Sisaan Error (Ton/ha)');

%% Interpretasi hasil
fprintf('          Interpretasi Hasil         \n');

c_opt = p_para_matlab(1);
b_opt = p_para_matlab(2);
a_opt = p_para_matlab(3);

% Menghitung titik puncak kurva parabolik (Vertex)
X_optimal = -b_opt / (2 * c_opt);
Y_maksimal = polyval(p_para_matlab, X_optimal);

fprintf('Persamaan Matematika Hasil Pemodelan Parabolik (%s):\n', pilih_tanaman);
fprintf('  Y = (%.4e)X^2 + (%.4f)X + (%.4f)\n\n', c_opt, b_opt, a_opt);
fprintf('HASIL ANALISIS TITIK PUNCAK OPTIMAL:\n');
fprintf('  -> Rekomendasi Curah Hujan Optimal  : %.2f mm/tahun\n', X_optimal);
fprintf('  -> Estimasi Hasil Panen Maksimum    : %.2f Ton/ha\n', Y_maksimal);