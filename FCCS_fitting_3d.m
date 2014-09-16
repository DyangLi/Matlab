function f_x = FCCS_fitting_3d(data, name)
opt = statset('nlinfit');
opt.MaxIter = 5000;
%input: raw data, names for final output
%output: f_x 
%% importing data, define range of data for fitting
trace = data(:,2:2:end);
corr_time = data(:,1);
F3d = @(a,t) a(1)*(1./(1+t/a(2))).*sqrt(1./(1+t/25*a(2)));
tau_fit_end = find(corr_time > 500, 1, 'first')-1;

%% NL fitting, estimate tau as point ~= 1/e G(0)
tau_est = find(mean(trace(1:tau_fit_end, 2:3:end),2) < 0.4*mean(mean(trace(1:5, 2:3:end))), 1, 'first');
g_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 2:3:end),2), F3d, [mean(mean(trace(1:5, 2:3:end))), 1],opt);
tau_est = find(mean(trace(1:tau_fit_end, 3:3:end),2) < 0.4*mean(mean(trace(1:5, 3:3:end))), 1, 'first');
r_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 3:3:end),2), F3d, [mean(mean(trace(1:5, 3:3:end))), 1],opt);
tau_est = find(mean(trace(1:tau_fit_end, 1:3:end),2) < 0.4*mean(mean(trace(1:5, 21:3:end))), 1, 'first');
x_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 1:3:end),2), F3d, [mean(mean(trace(1:5, 1:3:end))), 1],opt);
%% Plotting
figure; 
h = plot(corr_time, mean(trace(:,2:3:end),2), 'g', corr_time, mean(trace(:,3:3:end),2), 'r', corr_time, mean(trace(:,1:3:end),2), 'b');
set(gca, 'XScale', 'log');
f_x = 0.5*(x_beta(1)/g_beta(1) + x_beta(1)/r_beta(1));
y_ax = ylim;
text(10, 0.6*(y_ax(2)-y_ax(1))+y_ax(1),0, strcat('F_{cross} = ',num2str(f_x)), 'FontSize', 12);
xlabel('\tau/ms', 'FontSize', 12);
ylabel('G(\tau)', 'FontSize', 12);

print(gcf, '-dpdf', name);



