clearvars; close all;
folder = uigetdir();
list = dir(folder);
u=1;
opt = statset('nlinfit');
opt.MaxIter = 5000;
for i = 1:length(list)
    [PathName,FileName,ext] = fileparts(list(i).name);
    if strcmp(ext, '.dat')
        temp_data = importdata(strcat(folder,'\', FileName, ext));
        trace = temp_data.data(:,2:2:end);
        corr_time = temp_data.data(:,1);
        F2d  = @(a,t) a(1)*(1./(1+t/a(2)));
        F3d = @(a,t) a(1)*(1./(1+t/a(2))).*sqrt(1./(1+t/25*a(2)));
        tau_fit_end = find(corr_time > 500, 1, 'first')-1;
        % estimate tau as point ~= 1/e G(0)
        tau_est = find(mean(trace(1:tau_fit_end, 2:3:end),2) < 0.4*mean(mean(trace(1:5, 2:3:end))), 1, 'first');
        g_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 2:3:end),2), F2d, [mean(mean(trace(1:5, 2:3:end))), 1],opt);
        tau_est = find(mean(trace(1:tau_fit_end, 3:3:end),2) < 0.4*mean(mean(trace(1:5, 3:3:end))), 1, 'first');
        r_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 3:3:end),2), F2d, [mean(mean(trace(1:5, 3:3:end))), 1],opt);
        tau_est = find(mean(trace(1:tau_fit_end, 1:3:end),2) < 0.4*mean(mean(trace(1:5, 21:3:end))), 1, 'first');
        x_beta = nlinfit(corr_time(1:tau_fit_end), mean(trace(1:tau_fit_end, 1:3:end),2), F2d, [mean(mean(trace(1:5, 1:3:end))), 1],opt);
        figure; 
        h = plot(corr_time, mean(trace(:,2:3:end),2), 'g', corr_time, mean(trace(:,3:3:end),2), 'r', corr_time, mean(trace(:,1:3:end),2), 'b');
        set(gca, 'XScale', 'log');
        f_x(u) = 0.5*(x_beta(1)/g_beta(1) + x_beta(1)/r_beta(1));
        y_ax = ylim;
        text(10, 0.6*(y_ax(2)-y_ax(1))+y_ax(1),0, strcat('F_{cross} = ',num2str(f_x(u))), 'FontSize', 12);
        xlabel('\tau/ms', 'FontSize', 12);
        ylabel('G(\tau)', 'FontSize', 12);
        newFileName = strrep(FileName, '.dat', '.pdf');
        print(gcf, '-dpdf', newFileName);
        u = u+1;
    end; 
end;

%[FileName,PathName,FilterIndex] = uigetfile('/Users/IMPL-L/Desktop/*.dat');

