% a script to demonstrate how to use the recognize function.

load('../dat/meshes.mat');  % database to search
load('../dat/features.mat');  % queries

ids = recognize(meshes, features)

for i = 1: length(ids)
    fnTrain = strrep(meshes{ids(i)}.fn, ['sweater1vertex'], '');
    idTrain = str2double(strrep(fnTrain, '.obj', ''));
    idTest = str2double(strrep(features{i}.fn, '.obj', ''));
    fprintf('Recognition result: %d, ground truth %d\n', idTest, idTrain);
end
