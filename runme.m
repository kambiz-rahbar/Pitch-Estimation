clc
clear
close all
format shortg

% s = zeros(20,1);
% s(11:20) = 1;
% s = repmat(s,[10,1]);

% sample_rate = 10;
% n = (1:1/sample_rate:10)';
% s = sin(2*pi*0.5*n) .* exp(1./(0.3*n));

% Note (pitch)	piano	    trumpet	    flute	    violin
% ----------------------------------------------------------
% G3 (196 Hz)	piano-G3	trumpet-G3	 	 
% C4 (261 Hz)	piano-C4	trumpet-C4	violin-C4	flute-C4
% G4 (392 Hz)	piano-G4	trumpet-G4	violin-G4	flute-G4
% C5 (523 Hz)	piano-C5	trumpet-C5	violin-C5	flute-C5
% G5 (784 Hz)	piano-G5	trumpet-G5	violin-G5	flute-G5
% C6 (1046 Hz)	piano-C6	trumpet-C6	violin-C6	flute-C6
% G6 (1568 Hz)	piano-G6	 	        violin-G6	flute-G6
[s, sample_rate] = audioread('../dataset/trumpet-G5.wav');

tic
my_F0 = calc_pitch([], s, sample_rate, 0.001, 0);
my_time = toc;
my_F0 = mean(my_F0,'omitnan');

tic
F0_matlab = pitch(s,sample_rate);
matlab_time = toc;
F0_matlab = mean(F0_matlab,'omitnan');

tic
F0_nn = pitchnn(s,sample_rate,'ModelCapacity','tiny','ConfidenceThreshold',0.8);
nn_time = toc;
F0_nn = mean(F0_nn,'omitnan');

table(my_F0, F0_matlab, F0_nn, my_time, matlab_time, nn_time)
