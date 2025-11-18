%% Assignment 5 – EEG Encoding Models (Extended Version)
% This code trains simple regression models to predict EEG from DNN features.
clear; close all; clc;

%% Load the dataset
% Here we load the EEG and DNN feature data from a .mat file.
load("data_assignment_5.mat")

% Get the sizes of the training data
[numTrain, numChannels, numTime] = size(eeg_train);
numFeatures = size(dnn_train, 2);
numTest = size(eeg_test, 1);

% Different training sizes we want to test
train_sizes = [250, 1000, 10000, 16540];

% Different feature counts we want to test
feature_sizes = [25, 50, 75, 100];

%% --------------------------------------------------
%% 1) EFFECT OF TRAINING DATA AMOUNT
%% --------------------------------------------------

% We will save the results for each training size here
results_train = zeros(length(train_sizes), numTime);

for ti = 1:length(train_sizes)

    curTrain = train_sizes(ti);
    fprintf("\nTraining size = %d\n", curTrain);

    % Randomly choose some training samples
    idx = randperm(numTrain, curTrain);

    % Take only the selected samples
    X_train = dnn_train(idx, :);            % DNN features
    EEG_train_sub = eeg_train(idx, :, :);   % EEG data

    % This matrix will store correlations for all channels and times
    R = zeros(numChannels, numTime);

    % Train a model for each channel and time
    for ch = 1:numChannels
        for t = 1:numTime

            % This is the EEG signal we want to predict
            y = EEG_train_sub(:, ch, t);

            % Train a simple linear regression model
            mdl = fitlm(X_train, y);

            % Predict EEG for the test set
            pred = predict(mdl, dnn_test);

            % Compute correlation between real and predicted EEG
            real_vec = eeg_test(:, ch, t);
            r = corr(real_vec, pred);
            if isnan(r); r = 0; end

            R(ch, t) = r;
        end
    end

    % Average across channels to get a single timecourse
    results_train(ti, :) = mean(R, 1);
end

%% Plot results for different training sizes
figure; hold on;
for i = 1:length(train_sizes)
    plot(times, results_train(i,:), "LineWidth", 2);
end
xlabel("Time (s)");
ylabel("Mean correlation");
title("Effect of Training Data Amount");
legend("250","1000","10000","16540");
grid on;


%% --------------------------------------------------
%% 2) EFFECT OF FEATURE AMOUNT
%% --------------------------------------------------

% We will save the results for each feature size here
results_feat = zeros(length(feature_sizes), numTime);

for fi = 1:length(feature_sizes)

    k = feature_sizes(fi);
    fprintf("\nFeature size = %d\n", k);

    % Use only the first k features
    X_train = dnn_train(:, 1:k);
    X_test  = dnn_test(:, 1:k);

    % Correlation results
    R = zeros(numChannels, numTime);

    for ch = 1:numChannels
        for t = 1:numTime

            % EEG we want to predict
            y = eeg_train(:, ch, t);

            % Train linear regression model
            mdl = fitlm(X_train, y);

            % Predict with the test features
            pred = predict(mdl, X_test);

            % Compute correlation
            real_vec = eeg_test(:, ch, t);
            r = corr(real_vec, pred);
            if isnan(r); r = 0; end

            R(ch, t) = r;
        end
    end

    % Average across channels
    results_feat(fi, :) = mean(R, 1);
end


%% Plot results for different feature sizes
figure; hold on;
for i = 1:length(feature_sizes)
    plot(times, results_feat(i,:), "LineWidth", 2);
end
xlabel("Time (s)");
ylabel("Mean correlation");
title("Effect of DNN Feature Amount");
legend("25","50","75","100");
grid on;

%% Summary interpretation — Effect of Training Data Amount
% Pattern:
% - Correlation increases steadily as training size grows (250 → 16540).
% - Small datasets produce noisy, low-performing curves.
% - Large datasets (10000–16540) give similar, high accuracy (saturation).

% Reason:
% - More training samples give more stable and accurate regression weights.
% - EEG is noisy, so larger datasets reduce overfitting and improve
%   generalization.
% - After a certain point, additional data adds little new information.

%% Summary interpretation — Effect of DNN Feature Amount
% Pattern:
% - Using more DNN features (25 → 100) increases correlation.
% - Higher feature counts (75–100) show diminishing returns.

% Reason:
% - More features provide richer stimulus information for predicting EEG.
% - With too few features, important stimulus dimensions are missing.
% - After enough features are included, extra features add little benefit.
