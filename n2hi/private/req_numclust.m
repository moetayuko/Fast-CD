function y_req = req_numclust(A, y, c_req)
  c_init = max(y);
  y_req = y;

  for c = c_init - 1:-1:c_req
    A = graph_coarsen(A, y);
    [u, v] = find_top_affinity(A);
    y = [1:v - 1, u, v:c];
    y_req = map_labels(y_req, y);
  end
end

function [u, v] = find_top_affinity(A)
  n = size(A, 1);
  % mask self
  A(1:n + 1:end) = 0;
  [~, ind] = max(A, [], 'all');
  [u, v] = ind2sub([n, n], ind);
  if u > v
    [u, v] = deal(v, u);
  end
end
