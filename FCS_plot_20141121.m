plot_type = 0;
% plot_type: 0 means plotting average of the group, 1 means plotting each
% individual curve.
F2d = @(a,t)a(1)*(1./(1+t/a(2)))+a(3);
beta_0 = [0.3 10 0.002];
set(0,'defaultlinelinewidth',2)
for set_num =1:length(id)
    if strfind(cell2mat(data{set_num}.textdata(2,2)), '-3') > 1
        scale_factor = 0.001;
    else scale_factor = 1;
    end;
    
    plot(data{set_num}.data(:,1),scale_factor * mean(data{set_num}.data(:,2:2:end),2));
        
    beta(set_num,:) = nlinfit(data{set_num}.data(:,1),scale_factor * mean(data{set_num}.data(:,2:2:end),2), F2d, beta_0);
    FCCS_format
end;