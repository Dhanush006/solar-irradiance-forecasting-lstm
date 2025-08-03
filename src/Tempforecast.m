function [YPred1] = Tempforecast()
data1=readtable('C:\Users\Dhanush D Shekhar\Downloads\Monthdata.xlsx');
data = table2array(data1(:,3));
Temp = table2array(data1(:,4));
time = datestr(table2array(data1(:,2)),'HH:MM:SS');
tnum = zeros(size(data1,1),1);
data = Temp;
data = data';
for i = 1:1:size(data1,1)
    c = split(time(i,:),':');
    tnum(i) = str2double(c{1}) + str2double(c{2})/60 ;
end

figure
plot(data)
xlabel("Days")
ylabel("Temperature")
title("Monthly variation of the data")
numTimeStepsTrain = floor(0.9*numel(data));

dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 300;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',50, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress','ExecutionEnvironment','cpu');
net = trainNetwork(XTrain,YTrain,layers,options);
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);
net = predictAndUpdateState(net,XTrain);
[net,YPred1] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred1(:,i)] = predictAndUpdateState(net,YPred1(:,i-1),'ExecutionEnvironment','cpu');
end
YTest = dataTestStandardized(2:end);
rmse = sqrt(mean((YPred1-YTest).^2))
YPred = sig*YPred1 + mu;
YTest = sig*YTest + mu;
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Temperature")
title("Forecast")
legend(["Observed" "Forecast"])

figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
ylabel("Temperature")
title("Forecast")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Month")
ylabel("Error")
title("RMSE = " + rmse)

end

