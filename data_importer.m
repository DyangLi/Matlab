folder = uigetdir();
list = dir(folder);
u = 1;
for i = 1:length(list)
    [pathstr,name,ext] = fileparts(list(i).name);
    if strcmp(ext, '.dat')
        data{u} = importdata(strcat(folder, '\',list(i).name));
        id{u} = list(i).name;
        u = u+1;
    end; 
end;