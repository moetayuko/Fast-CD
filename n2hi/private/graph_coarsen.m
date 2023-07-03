function A = graph_coarsen(A, y)
  if size(y, 1) ~= 1
    y = y';
  end
  Y = ind2vec(y);
  Y = Y ./ sum(Y, 2);
  A = Y * A * Y';
end
