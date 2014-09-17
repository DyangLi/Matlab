function f_x = FCCS_fitting_3d(data_x, data_a, data_b, name)
opt = statset('nlinfit');
%opt.MaxIter = 5000;
%input: raw data, names for final output
%output: f_x 
%% importing data, define range of data for fitting
trace_x = data_x(:,2:2:end);
trace_a = data_a(:,2:2:end);
trace_b = data_b(:,2:2:end);
corr_time = data_x(:,1);
F3d = @(a,t) a(1)*(1./(1+t/a(2))).*sqrt(1./(1+t/25*a(2)));
tau_fit_end = find(corr_time > 500, 1, 'first')-1;

%% NL fitting, estimate tau as point ~= 1/e G(0)
tau_est = find(nanmean(trace_x(1:tau_fit_end, :),2) < 0.4*nanmean(nanmean(trace_x(1:5,:))), 1, 'first');
x_beta = nlinfit(corr_time(1:tau_fit_end), nanmean(trace_x(1:tau_fit_end, :),2), F3d, [nanmean(nanmean(trace_x(1:5, :))), 10],opt);
tau_est = find(nanmean(trace_a(1:tau_fit_end, :),2) < 0.4*nanmean(nanmean(trace_a(1:5, :))), 1, 'first');
g_beta = nlinfit(corr_time(1:tau_fit_end), nanmean(trace_a(1:tau_fit_end, :),2), F3d, [nanmean(nanmean(trace_a(1:5, :))), 10],opt);
tau_est = find(nanmean(trace_b(1:tau_fit_end, :),2) < 0.4*nanmean(nanmean(trace_b(1:5, :))), 1, 'first');
r_beta = nlinfit(corr_time(1:tau_fit_end), nanmean(trace_b(1:tau_fit_end, :),2), F3d, [nanmean(nanmean(trace_b(1:5, :))), 10],opt);
%% Plotting
figure; 
h = plot(corr_time, mean(trace_a,2), 'g', corr_time, mean(trace_b,2), 'r', corr_time, mean(trace_x,2), 'b');
set(gca, 'XScale', 'log');
f_x = 0.5*(x_beta(1)/g_beta(1) + x_beta(1)/r_beta(1));
y_ax = ylim;
text(10, 0.6*(y_ax(2)-y_ax(1))+y_ax(1),0, strcat('F_{cross} = ',num2str(f_x)), 'FontSize', 12);
xlabel('\tau/ms', 'FontSize', 12);
ylabel('G(\tau)', 'FontSize', 12);

print(gcf, '-dpdf', name);



