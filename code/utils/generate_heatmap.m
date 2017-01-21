function generate_heatmap( target_root, output_root, heatmap_root, method, visulize_heat )
%GENERATE_HEATMAP creat a heat map for target set and output set
%   target_root : directory of all the target images (GT)
%   output_root : directory of all the output images (generated)
%   method : the method for compute distance between target and the output
%           (diff_of, diff_mag, diff_mag_of)
%   visulize_heat : number of heat maps for visualization ("0" for no vis)

dispstat('','init');
if ~exist('visulize_heat','var')
  visulize_heat=0;
end
if ~exist('method','var')
  method='diff_of' ;
  fprintf('##### DISTANCE METHOD DOES NOT EXIST! it automatically sets to *diff_of* ######');
end
if ~exist(heatmap_root,'dir')
    mkdir(heatmap_root);
end

sample_names= dir([target_root '*.jpg']);
heatmap=cell(length(sample_names),1);
for i=1:length(sample_names)
    dispstat(sprintf('generate heatmap %04d/%04d using method : %s',i,length(sample_names),method));
    target = imread ([target_root sample_names(i).name]);
    out = imread ([output_root sample_names(i).name]);
    switch method
    case 'diff_of' 
        diff = target - out;
    case {'diff_magof','diff_mag','diff_mag_vs_magof'}
       out = out(:,:,3);
       target = target(:,:,3);
       diff = target - out;
    otherwise
        warning('Unexpected method type. No heatmap created.')
    end
    %out = out(:,:,3);
    %out = out -128;
    %out = out/max(max(out));
    
    %imagesc(sum(diff,3));{}
    heatmap{i} = diff;
    if (i<visulize_heat)
        image(diff);
        file_name=[heatmap_root sample_names(i).name];
        print(file_name,'-djpeg');
        close all
    end
end
fprintf('all the heatmaps have beed saved:\n%s\n',heatmap_root);
save(sprintf('%sheatmaps_%s.mat',heatmap_root,method), 'heatmap');
end

