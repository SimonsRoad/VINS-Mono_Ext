%% 
% Feb. 9 2018, He Zhang, hxzhang1@ualr.edu 
% compute RMSE using the result from ISAM2 
function [rmse, g_pts] = computeRMSE(result, truth, options)

%% 
import gtsam.*
g_pts = [];
e_pts = [];
rmse = []; 
M = 1 ;
while result.exists(symbol('x', M))
    ii = symbol('x', M); 
    pi = result.at(ii); 
    epi = pose2pt(pi);
    gpi = pose2pt(truth.cameras{M}.pose); 
    e_pts = [e_pts; epi];
    g_pts = [g_pts; gpi];
    rmse_i = computeRMSEArray(e_pts, g_pts); 
    if options.rmse_ratio
        dis = computeDis(g_pts); 
        rmse_i = rmse_i/dis; 
    end
    rmse = [rmse; rmse_i];
    M = M + options.cameraInterval;
end
    
end

%% compute the distance of the traversed route
function dis = computeDis(pts)
    dis = 0; 
    for i=2:size(pts)
        dp = pts(i, :) - pts(i-1, :);
        dis = dis + sqrt(dp * dp');
    end
end

