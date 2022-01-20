fname  = {'#subjcode_Tone_2_BEPOCH.Mastoid_REF.set'};
   % '#subjcode_Check_2_BEPOCH.Mastoid_REF.set', ...
   % '#subjcode_Tone_1_BEPOCH.Mastoid_REF.set', ...
   % '#subjcode_Tone_2_BEPOCH.Mastoid_REF.set'}; % list of BEPOCH set files you want to compute the Event-Related Spectrum Perturbation (ERSP) for a whole EEG singal with respect to an event start time.

pathname = '.../BEPOCH.Average_REF';% path where you have the BEPOCH data processed EEG singal using ERPLAB

freq_band = { [.5 1], [1 2], [2 3], [4], [5], [6], [7], [8], [9], [10], ...
    [11], [12], [13], [14], [15], [15 18], [19 24], [25 35], [37 49], [72 75]};% frequecy bands used to extract the ERSP at those frequencies
c = 1;
for i = 1:length(fname) % loop through each BEPOCH set file
EEG = pop_loadset('filename', [fname{i}], 'filepath', pathname);%load set file
for j = 1:length(freq_band) % loop throguh each frequency band of interest
EEG = TR_series_freq_extract(EEG, freq_band{j});% function to extract the ERSP at a frequecy band of interest with respect to the MRI TR triggered experiment

% naming the setname withing the non-scaler structure
if length(freq_band{j}) == 1 
Time_series(c).name = [fname{i}(1:end-22) num2str(freq_band{j})];
elseif length(freq_band{j}) == 2
 Time_series(c).name = [fname{i}(1:end-22) num2str(freq_band{j}(1)) 'to' num2str(freq_band{j}(2))];   
end
% structure information 
Time_series(c).data = EEG.data;
Time_series(c).times = EEG.times;
Time_series(c).channels = EEG.nbchan;
Time_series(c).srate = EEG.srate;
Time_series(c).chanlocs = EEG.chanlocs;
c = c+1;
end
end  
% save non-scaler structure in mat file
save('EEG_timeseries_whole_scan_AttAud2.mat', 'Time_series')
% if you have multiple BEPOCH set data, I recommend saving the ERSP from
% one BEPOCH set with all frequency band of interest because if you try
% saving the ERSP from all .set files into a single non-scaler structure it
% might give you problems saving it in a mat file because of its large
% size.