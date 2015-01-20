% The MIT License (MIT)
% 
% Copyright (c) 2015 Yinxiao Li and Yan Wang
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function mesh = parseObj(fn)
% parse an obj file and return the result mesh
% vertices
fprintf('Parsing the obj file... ');
mesh = [];
system(sprintf('bash -c "cat %s | grep ''^v '' | sed ''s/v //'' > tmp.txt"', fn));
mesh.v = load('tmp.txt', '-ascii')';
mesh.v = mesh.v(1: 3, :);
mesh.vn = size(mesh.v, 2);
% normal vectors
system(sprintf('bash -c "cat %s | grep ''^vn '' | sed ''s/vn //'' > tmp.txt"', fn));
mesh.n = load('tmp.txt', '-ascii')';
% faces
system(sprintf('bash -c "cat %s | grep ''^f '' | sed ''s/\\/\\/[0-9]*//g'' | sed ''s/f //'' > tmp.txt"', fn));
mesh.f = load('tmp.txt', '-ascii')';
mesh.fn = size(mesh.f, 2);
% clean up
system('bash -c "rm tmp.txt"');
fprintf('Done. %d vertices, %d edges.\n', mesh.vn, mesh.fn);
end
