clc
clear all
data1=readtable('C:\Users\Dhanush D Shekhar\Downloads\MonthData_2.xlsx');
data = table2array(data1(:,3))';
Temp = table2array(data1(:,4))';
time = datestr(table2array(data1(:,2)),'HH:MM:SS');
tnum = zeros(size(data1,1),1);
for i = 1:1:size(data1,1)
    c = split(time(i,:),':');
    tnum(i) = str2double(c{1}) + str2double(c{2})/60 ;
end
tnum = tnum';
%standardize datas for train
numTimeStepsTrain = floor(0.8*numel(data));
dataTrain = data(1:numTimeStepsTrain);
TempTrain = Temp(1:numTimeStepsTrain);
tnumTrain = tnum(1:numTimeStepsTrain);

dataVal = data(numTimeStepsTrain+1:numTimeStepsTrain+557);
TempVal = Temp(numTimeStepsTrain+1:numTimeStepsTrain+557);
tnumVal = tnum(numTimeStepsTrain+1:numTimeStepsTrain+557);

dataTest = data(5012:end);
TempTest = Temp(5012:end);
tnumTest = tnum(5012:end);

%data
mu1 = mean(data);
sig1 = std(data);
dataTrainStandardized = (dataTrain - mu1) / sig1;
dataTestStandardized = (dataTest - mu1) / sig1;
dataValStandardized = (dataTest - mu1) / sig1;
%Temp
mu2 = mean(Temp);
sig2 = std(Temp);
TempTrainStandardized = (TempTrain - mu2) / sig2;
TempTestStandardized = (TempTest - mu2) / sig2;
TempValStandardized = (TempTest - mu2) / sig2;
%tnum
mu3 = mean(tnum);
sig3 = std(tnum);
tnumTrainStandardized = (tnumTrain - mu3) / sig3;
tnumTestStandardized = (tnumTest - mu3) / sig3;
tnumValStandardized = (tnumTest - mu3) / sig3;

XTrain = [dataTrainStandardized(1:end-1);tnumTrainStandardized(1:end - 1);TempTrainStandardized(1:end - 1)];
YTrain = dataTrainStandardized(2:end);
XVal = [dataValStandardized(1:end-1);tnumValStandardized(1:end - 1);TempValStandardized(1:end - 1)];
YVal = dataValStandardized(2:end);

numFeatures = 3;
numResponses = 1;
numHiddenUnits = 90;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'ValidationData',{XVal,YVal}, ...
    'ValidationFrequency',3, ...
    'Verbose',0, ...
    'Plots','training-progress','ExecutionEnvironment','gpu');
net = trainNetwork(XTrain,YTrain,layers,options);
XTest = [dataTestStandardized(1:end-1);tnumTestStandardized(1:end - 1);TempTestStandardized(1:end-1)];
YTest = dataTestStandardized(2:end);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,[dataValStandardized(end);tnumValStandardized(end);TempValStandardized(end)]);
numTimeStepsTest = size(XTest,2);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,[XTest(1,i-1);XTest(2,i-1);XTest(3,i-1)],'ExecutionEnvironment','gpu');
end
rmse = sqrt(mean((YPred-YTest).^2));

YPred = sig1*YPred + mu1;
YTest = sig1*YTest + mu1;
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Days")
ylabel("Irradiance")
title("Forecast")
legend(["Observed" "Forecast"])

figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
xlabel("Samples")
ylabel("DNI(W/m^2)")
title("Forecast")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Samples")
ylabel("DNI(W/m^2)")
title("RMSE = " + rmse)





