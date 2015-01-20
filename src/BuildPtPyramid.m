function histbar = BuildPtPyramid(meshes, param)

nMesh = size(meshes, 1);
histbar = cell(nMesh,1);

% parameters
num_layer   =  param.layers;
num_ring    =  param.rings;
num_divided =  param.divided;
start_angle =  param.start_angle;

% build up shape-based feature vector
for iMesh = 1:nMesh
    
    mesh = meshes{iMesh};
    raw_feat_compressed = [];
    
    % computer model vertical range
    obj_uppper_bound = max(mesh.v(2,:));
    obj_lower_bound  = min(mesh.v(2,:));
    
    % compute principle axis using topper points
    vs = mesh.v(:, mesh.v(2,:) > (obj_uppper_bound - (obj_uppper_bound - obj_lower_bound)/16));
    x = mean(vs(1, :));
    z = mean(vs(3, :));
    
    r = sqrt((mesh.v(1,:)-x).^2 + (mesh.v(3,:)-z).^2);
    max_r = max(r);
    p_angle = atan2((mesh.v(3,:)-z), (mesh.v(1,:)-x));
    % change from [-pi,pi] to [0,2*pi]
    p_angle = p_angle + pi;
    
    layer_width = (obj_uppper_bound - obj_lower_bound)/num_layer + 0.00001; % avoid numerical error
    ring_width  = max_r / num_ring + 0.00001; % avoid numerical error
    angle_width = 2 * pi / num_divided + 0.00001;  % avoid numerical error
    
    % first layer
    for i = 1:num_layer
        cur_upper = obj_uppper_bound - (i-1) * layer_width;
        cur_lower = obj_uppper_bound - i * layer_width;
        idx = find(mesh.v(2,:) <= cur_upper & mesh.v(2,:) > cur_lower);
        featvec = build2Dshapecontext(idx, r, p_angle, start_angle, angle_width, ring_width, num_ring, num_divided);
        raw_feat_compressed = [raw_feat_compressed; featvec];
    end
    
    % second layer 4x4
    for i = 1:4
        step = 4;
        cur_upper = obj_uppper_bound - (i-1) * step * layer_width;
        cur_lower = obj_uppper_bound - i*step*layer_width;
        idx = find(mesh.v(2,:) <= cur_upper & mesh.v(2,:) > cur_lower);
        featvec = build2Dshapecontext(idx, r, p_angle, start_angle, angle_width, ring_width, num_ring, num_divided);
        raw_feat_compressed = [raw_feat_compressed; featvec];
    end
    
    % third layer  16x1
    idx = 1:numel(r);
    featvec = build2Dshapecontext(idx, r, p_angle, start_angle, angle_width, ring_width, num_ring, num_divided);
    raw_feat_compressed = [raw_feat_compressed; featvec];
    
    histbar{iMesh} = logical(raw_feat_compressed);
end

end

function featvec = build2Dshapecontext(idx, r, p_angle, start_angle, angle_width, ring_width, num_ring, num_divided)
if (start_angle ~= 0); error('Yan''s version only supports start_angle == 0'); end
r = floor(r(idx) / ring_width);
p_angle = floor(p_angle(idx) / angle_width);
featvec = zeros(num_ring * num_divided, 1);
for i = 1: numel(r)
    for j = 1: r(i)
        id = p_angle(i) * num_ring + j;
        if (id > num_ring * num_divided); error(); end;
        featvec(id) = 1;
    end
end
end
