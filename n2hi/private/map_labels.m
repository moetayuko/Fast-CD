function y = map_labels(y_prev, y_cur)
  [~, ~, ic] = unique(y_prev);
  y = y_cur(ic);
end
