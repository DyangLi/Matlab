set(gca, 'XScale', 'log');
set(gca, 'FontSize', 10);
xlim([0 1000]);
xlabel('\tau(ms)', 'FontSize', 16);
ylabel('G(\tau)', 'FontSize', 16);
savefig(strcat(folder,'\',cell2mat(id(set_num)),'.fig'));

