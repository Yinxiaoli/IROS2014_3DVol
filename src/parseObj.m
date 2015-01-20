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