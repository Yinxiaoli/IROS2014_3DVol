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
