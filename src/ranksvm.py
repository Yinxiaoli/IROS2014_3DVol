# The MIT License (MIT)
# 
# Copyright (c) 2015 Yinxiao Li and Yan Wang
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import re
import sys

if len(sys.argv) != 2:
    print 'Usage: ranksvm.py <dimension>'
    sys.exit(-1)
dimen = int(sys.argv[1])
os.system('../bin/svm_rank_learn -c 20 train.txt model.txt')
# convert to matlab format
line = file('model.txt').readlines()
line = [x.strip('# \n') for x in line[-1].split(' ')]
line = line[2:-2]
values = [0 for x in range(dimen)]   # 3360 is the dimension of the feature
for l in line:
    id = int(re.search('(.*):', l).group().strip(':'))
    val = float(re.search(':(.*)', l).group().strip(':'))
    values[id] = val
file('weights.txt', 'w').write('\n'.join([str(x) for x in values]))
