function y = n2hi(A, c)
%   F. Nie, J. Lu, D. Wu, R. Wang and X. Li, "A Novel Normalized-Cut Solver
%   with Nearest Neighbor Hierarchical Initialization," in IEEE Transactions on
%   Pattern Analysis and Machine Intelligence, doi: 10.1109/TPAMI.2023.3279394.
%
%   SPDX-FileCopyrightText: 2023 Jitao Lu <dianlujitao@gmail.com>
%   SPDX-License-Identifier: MIT
  [y_hier, num_clusters] = n2hi_hierarchy(A);
  idx = find(num_clusters == c, 1);
  if ~isempty(idx)
    y = y_hier(idx, :)';
  elseif any(num_clusters > c)
    refine_starter = find(num_clusters > c, 1, 'last');
    y = req_numclust(A, y_hier(refine_starter, :), c)';
    disp('N2HI refine');
  else
    error('N2HI failed to find %d clusters', c);
  end
end
