% Filtering the channels that involve the letter "O" for occipital
occipital = find(contains(ch_names,"O"));
% Filtering the channels that involve the letter "F" for frontal
frontal = find(contains(ch_names, "F"));
% Filtering the channels that involve the letter "C" for central
central = find(contains(ch_names, "C"));
% Filtering the channels that involve the letter "P" for parietal
parietal = find(contains(ch_names, "P"));
% Filtering the channels that involve the letter "T" for temporal
temporal = find(contains(ch_names, "T"));

% 0.1 seconds equals to 41th index of times variable

% This code gives the every visual condition at 0.1 seconds for only
% occipital channels.

occipital_voltage_point1second = eeg(:,occipital,41);

% This code gives the every visual condition at 0.1 seconds for only
% frontal channels
frontal_voltage_point1second = eeg(:,frontal,41);

% Now that we have the voltages for occipital and frontal, we can find the
% means.
mean_occipital = mean(occipital_voltage_point1second,"all");
mean_frontal = mean(frontal_voltage_point1second,"all");

%Take the average of all image conditions and exclude the dimension
mean_eeg = squeeze(mean(eeg,1));
%%
%Now that we squeezed, mean_eeg,1 is the channels so there will be as many
%plots as there are channels
figure;
hold on;
for i = 1:size(mean_eeg,1)
    plot(times, mean_eeg(i,:));
end
xlabel("Time")
ylabel("Mean voltage")
hold off

%Simiralities and differences can be explained by how the different
%locations of the brain react different to the stimulation types. 
% Since this is a visual task, occipital lobe would be expected to have higher activity.
% Additionally, giving meaning and the inclusion of the higher cognition to the stimulus 
% might have induced the frontal lobe activity through the time.%




%%
% timecourse of the (i) mean EEG voltage across all image conditions and frontal channels %
figure;
hold on;
for i = 1:size(frontal)
    plot(times, mean_eeg(frontal(i),:));
end
xlabel("Time")
ylabel("Mean voltage")
hold off

% timecourse of the (i) mean EEG voltage across all image conditions and occipital channels %

figure;
hold on;
for i = 1:size(occipital)
    plot(times, mean_eeg(occipital(i),:));
end
xlabel("Time")
ylabel("Mean voltage")
hold off

%Like mentioned in the earlier, occipital lobe seems to react in an
%interval-like shape where increases and decreases create a trend.
%However, frontal lobe activity seems to increase by time which might be
%explained by the interpretation of the stimuli and higher cognitive
%activity
%%

%timecourse of the (i) mean EEG voltage across all occipital channels for the 
% first image condition and second image condition % 

%first image for all times filtered to occipital channels%
occipital_img1 = squeeze(mean(eeg(1, occipital, :), 2));
%second image for all times filtered to occipital channels%
occipital_img2 = squeeze(mean(eeg(2, occipital, :), 2));

%plot for first image%

figure;
hold on;
plot(times, occipital_img1);
xlabel("Time")
ylabel("Mean voltage")
hold off

%plot for second image%

figure;
hold on;
plot(times, occipital_img2);
xlabel("Time")
ylabel("Mean voltage")
hold off

%For the differences and similarities regarding the first and second image
%generally, there seems they are more similar than they are different. Only
%differences is seen through the .15 to .32 seconds approximately. This
%might be caused by the complexity of the visual stimulus and how occipital
%lobe reacts to it but generally plots seem to look alike.