clear; 
clc;

% Define experimental factors
familiarity = {'familiar', 'unfamiliar'};
emotion = {'positive', 'neutral', 'negative'};

% Number of participants
n_subjects = 60;

% Create a structure to store block order for each participant
stimlist = struct();

for n = 1:n_subjects

    % First half of participants start with "familiar", second half with "unfamiliar"
    if n <= 30
        fam_first = 'familiar';
    else
        fam_first = 'unfamiliar';
    end
    
    % Randomize the order of emotions for each participant
    emotion_order = randperm(length(emotion));
    
    % Initialize empty list of conditions (blocks)
    conditions = {};
    
    % For each emotion, add both familiarity versions consecutively
    % (e.g., "positive-familiar" followed by "positive-unfamiliar")
    for e = emotion_order
        if strcmp(fam_first, 'familiar')
            conditions = [conditions; {emotion{e} + "-familiar"};{emotion{e} + "-unfamiliar"}];
        else
            conditions = [conditions;{emotion{e} + "-unfamiliar"};{emotion{e} + "-familiar"}];
        end
    end
    
    % Store participant info and block order
    stimlist(n).participant_num = n;
    stimlist(n).blocks = conditions;
end


