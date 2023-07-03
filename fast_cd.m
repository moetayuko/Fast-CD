function [y_ind, obj] = fast_cd(A, y_ind, n_iter)
%   F. Nie, J. Lu, D. Wu, R. Wang and X. Li, "A Novel Normalized-Cut Solver
%   with Nearest Neighbor Hierarchical Initialization," in IEEE Transactions on
%   Pattern Analysis and Machine Intelligence, doi: 10.1109/TPAMI.2023.3279394.
%
%   SPDX-FileCopyrightText: 2023 Jitao Lu <dianlujitao@gmail.com>
%   SPDX-License-Identifier: MIT
  if nargin < 3
    n_iter = 50;
  end

  Y = ind2vec(y_ind')';
  n = size(Y, 1);
  n_clu = full(sum(Y));

  H = A * Y;
  D = full(sum(H, 2));
  yAy = full(sum(H .* Y));
  yDy = full(sum(H));
  H = full(H);  % For efficient slicing

  obj(1) = sum(yAy ./ yDy);
  for iter = 1:n_iter
    for m = 1:n
      p = y_ind(m);
      if n_clu(p) == 1
        continue;
      end

      a_Y = H(m, :);

      yAy_k = yAy + 2 * a_Y;
      yAy_k(p) = yAy(p);

      yDy_k = yDy + D(m);
      yDy_k(p) = yDy(p);

      yAy_0 = yAy;
      yAy_0(p) = yAy(p) - 2 * a_Y(p);

      yDy_0 = yDy;
      yDy_0(p) = yDy(p) - D(m);

      delta = yAy_k ./ yDy_k - yAy_0 ./ yDy_0;

      [~, r] = max(delta);
      if r ~= p
        yAy(p) = yAy_0(p);
        yDy(p) = yDy_0(p);
        yAy(r) = yAy_k(r);
        yDy(r) = yDy_k(r);

        A_m = A(:, m);
        H(:, r) = H(:, r) + A_m;
        H(:, p) = H(:, p) - A_m;

        y_ind(m) = r;
        n_clu(p) = n_clu(p) - 1;
        n_clu(r) = n_clu(r) + 1;
      end
    end
    obj(iter + 1) = sum(yAy ./ yDy);

    if iter > 2 && abs((obj(iter + 1) - obj(iter)) / obj(iter)) < 1e-9
      break;
    end
  end
end
