function EEG = TR_series_freq_extract(EEG, freq_extract)

% what frequecy band to extract
if length(freq_extract) == 2
    a = freq_extract;   
elseif length(freq_extract)==1 % if freq_extract only specifies on frequency value
    a(1) = freq_extract(1) - .5;
    a(2) = freq_extract(1) + .5;
end


for i = 1:EEG.nbchan %loop to each channel in EEGLAB data structure
% EEGLAB function to compute the ERSP
[ersp itc powbase times frequencies] = pop_newtimef( EEG, 1, i, [0 (EEG.pnts/EEG.srate)*1000], [3         0.5] , 'topovec', i, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption',EEG.chanlocs(i).labels, 'baseline',[0], 'freqs', [a(1) a(2)], 'plotphase', 'off', 'padratio', 1);
close all
% average through the frequency window
ERP = mean(ersp,1);
%resample data back to the original time series time points
ERP_re_sampled(i,:) = resample(ERP, EEG.pnts, length(ERP));
end
EEG.data = ERP_re_sampled; % add the ERSP back to EEG.data structure
%           
end
