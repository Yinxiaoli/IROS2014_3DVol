function ids = recognize(trainData, testData)

%% Parameter settings
param.divided = 16;
param.layers  = 16;
param.rings   = 16;
param.start_angle = 0;

% extract features 
histbar_train = BuildPtPyramid(trainData, param);
histbar_test = BuildPtPyramid(testData, param);
ids = zeros(length(testData), 1);

%% Actual testing
weight = load('../dat/weights.txt');
tid = tic;
result = zeros(length(histbar_test), 2);
for iTest = 1: length(testData)
    fnTest = testData{iTest}.fn;
    distsModels = zeros(length(trainData), 1);
    for iTrain = 1: length(trainData)  
        % work on the lower bound of the distance -- first seek for the
        % best possible feature alignment
        f = histbar_test{iTest}; m = histbar_train{iTrain}; dists = zeros(param.divided, 1);
        for j = 1: param.divided
            dists(j) = sum(xor(f, m));  % this is distance, not similarity
            
            % rotate
            tmp = reshape(f, param.rings, numel(f) / param.rings);
            for k = 1: 21   % number of slices in total
                tmp(:, [(k - 1) * param.divided + 2: k * param.divided, (k - 1) * param.divided + 1]) = tmp(:, (k - 1) * param.divided + 1: k * param.divided);
            end
            f = reshape(tmp, numel(tmp), 1);
        end
        
        % generate the 'best' feature for the test data
        [~, id] = min(dists);
        f = histbar_test{iTest};
        tmp = reshape(f, param.rings, numel(f) / param.rings);
        for j = 1: id - 1
            for k = 1: 21   % number of slices in total
                tmp(:, [(k - 1) * param.divided + 2: k * param.divided, (k - 1) * param.divided + 1]) = tmp(:, (k - 1) * param.divided + 1: k * param.divided);
            end
        end
        f = reshape(tmp, numel(tmp), 1);
        % generate the 'best' feature for the test data
        distsModels(iTrain) = dot(weight, xor(f, m));   % here we use max because the result is svm score
    end
    [~, ids(iTest)] = max(distsModels);
end

end
