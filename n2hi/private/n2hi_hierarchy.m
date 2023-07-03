function [y_hier, num_clusters] = n2hi_hierarchy(A)
  [y_cur, num_clusters] = find_nn_clusters(A);
  y_hier = y_cur;
  if num_clusters <= 1
      return;
  end

  while true
    A = graph_coarsen(A, y_cur);
    [y_cur, c_cur] = find_nn_clusters(A);
    if c_cur <= 1
        break;
    end
    y_hier = [y_hier; map_labels(y_hier(end, :), y_cur)];
    num_clusters = [num_clusters, c_cur];
  end
end

function [y, c] = find_nn_clusters(A)
  n = size(A, 1);
  % mask self
  A(1:n + 1:end) = 0;
  [~, nn_idx] = max(A, [], 2);
  G = graph(1:n, nn_idx);
  [y, clu_sizes] = conncomp(G);
  c = numel(clu_sizes);
end
