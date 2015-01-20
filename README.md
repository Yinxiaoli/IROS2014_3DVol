## Data Structure

All the data including the `trainData` and `testData` in the core functions have the following format. Examples are available in `/dat`.

![Data structure](https://github.com/Yinxiaoli/IROS2014_3DVol/blob/master/doc/DataStructure.png)

The `v` field can be easily extracted from the 3D model files. We provide `/src/parseObj.m` as an example to convert from `.obj` files.
We also use another field `fn` to store the ground truth for evaluation.
But that's not necessary to use our code.

## Core functions

    ids=recognize(trainData,testData)

Use `trainData` as the database to search, and `testData` as the query. 
This function uses the RankSVM weights encoded in `weights.txt`, and then returns a cell array of the id of the most similar instance in trainData regarding to the weighted Hamming distance.

    feature=buildPtPyramid(data)

Extract the pyramid volumetric feature as mentioned in the paper.
`data` has the same format as `trainData`, which is illustrated in the Data structure part.

Note this MATLAB version is modified from our C# implementation for easier use for the community, and therefore it doesn't directly use the Signed Distance Function but brute-forcely compute the features, which may result in a performance loss.

## Usage

We provide a sample MATLAB script with sample data to demonstrate the usage of our code.
Simply enter `/src`, and type `run()` in MATLAB command line to check the demo. There is nothing requiring compilation in this version.

## Citation 

Please kindly cite our paper if you use our code.

* Yinxiao Li, Yan Wang, Michael Case, Shih-Fu Chang, and Peter K. Allen, "Real-time Pose Estimation of Deformable Objects Using a Volumetric Approach," Proc. of IROS, 2014.

bibtex:

    @InProceedings{IROS14:volumetric,
        Author = {Li, Yinxiao and Wang, Yan and
    Case, Michael and Chang, Shih-Fu and Allen,
    Peter K.},
        Title = {Real-time Pose Estimation of
    Deformable Objects Using a Volumetric
    Approach},
        BookTitle = {Proceedings of the IEEE/RSJ
    International Conference on Intelligent
    Robots and Systems (IROS)},
        Month = {September},
        Year = {2014}
    }
