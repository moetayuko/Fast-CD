clc;
close all;

addpath('funs');
addpath('n2hi');

[X, y, c, name] = load_dataset(1);

A0 = selftuning(X, 25);
y_init = n2hi(A0, c);

[y_pred, obj] = fast_cd(A0, y_init);

result = ClusteringMeasure_new(y, y_pred)
