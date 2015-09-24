clc;clear all;close all;
tic
addpath ../libsvm-3.20/libsvm-3.20/matlab
% Multi-class 1 vs all: http://stackoverflow.com/questions/9041753/multi-class-classification-in-libsvm

%% Read data
totrain = 0;
types = {'coast', 'forest', 'insidecity', 'mountain'};
bins = 32;
Xtrain = [];
Ytrain = [];

if totrain == 1
    for i = 1:4
        datafolder = ['data/DS4/data_students/' types{i} '/Train/'];
        files = dir([datafolder '*.jpg']);
        for j = 1:size(files,1)
            features = [];
            [i j]
            I = imread([datafolder files(j).name]);
            for k = 1:3
                layer = I(:,:,k);
                lhist = imhist(layer,bins);
                features = [features lhist'];
            end
            Xtrain = [Xtrain;features];
            Ytrain = [Ytrain;i];
        end
    end
    save('Q4train.mat', 'Xtrain', 'Ytrain');
else
    load('Q4train.mat');
end

%% Train classifier and Evaluate
% Vary C and g
folds = 5;
[Xtrainf Ytrainf Xtestf Ytestf] = generateKfolds(Xtrain, Ytrain, folds, 1);
save('Q4gridout/perms.mat', 'Xtrainf', 'Ytrainf', 'Xtestf', 'Ytestf');
numLabels = 4;
acc = zeros(folds,3);
Yhattest = cell(folds,1);
C = cell(folds,1);
model = cell(folds,1);
prob = cell(folds,1);

% cvals = 1*10.^[-3:3];
% gvals = 1*10.^[-3:3];
cvals = 0.01;
gvals = 0:10:100;
for cc = 1:length(cvals)
    cval = cvals(cc);
    for gg = 1:length(gvals)
        [cc gg]
        gval = gvals(gg);
        for i = 1:folds
            numTest = size(Xtestf{i},1);

            model{i} = svmtrain(Ytrainf{i}, Xtrainf{i}, ['-s 0 -t 0 -g ' num2str(gval) ' -c ' num2str(cval) ' -b 1']);
            prob{i} = zeros(numTest,numLabels);

            [Yhattest{i},acc(i,:),prob{i}] = svmpredict(Ytestf{i}, Xtestf{i}, model{i}, '-b 1');
            C{i} = confusionmat(Ytestf{i}, Yhattest{i}); % Confusion matrix    
        end
        foutname = ['Q4gridout/c=10^' num2str(log(cval)/log(10)) ';g=10^' num2str(log(gval)/log(10)) '.mat']
        save(foutname, 'model', 'prob', 'acc', 'Yhattest', 'C');
    end
end
toc