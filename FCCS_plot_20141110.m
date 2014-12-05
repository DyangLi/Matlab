set(0,'defaultlinelinewidth',2)
for set_num =1:15
    
    figure; hold on;
    if strfind(cell2mat(data{set_num}.textdata(2,2)), '-3') > 1
        scale_factor = 0.001;
    else scale_factor = 1;
    end;
    plot(data{set_num}.data(:,1), scale_factor*data{set_num}.data(:,2), 'b');
    if strfind(cell2mat(data{set_num}.textdata(2,4)), '-3') > 1
        scale_factor = 0.001;
    else scale_factor = 1;
    end;
    plot(data{set_num}.data(:,3), scale_factor*data{set_num}.data(:,4), 'g');
    if strfind(cell2mat(data{set_num}.textdata(2,6)), '-3') > 1
        scale_factor = 0.001;
    else scale_factor = 1;
    end;
    plot(data{set_num}.data(:,5), scale_factor*data{set_num}.data(:,6), 'r');
    hold off;
    FCCS_format;
end;