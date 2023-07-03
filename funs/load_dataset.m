function [X, y, c, name] = load_dataset(dataset_id)
    switch dataset_id
        case 1
            [X, y] = load_uni_mat('german_uni');
            name = 'German';
        case 2
            [X, y] = load_uni_mat('GTdb_uni');
            name = 'GTdb';
        case 3
            [X, y] = load_uni_mat('MnistData_10_uni');
            name = 'MNIST10';
            X = im2double(uint8(X));
        case 4
            [X, y] = load_uni_mat('MSRA50_uni');
            name = 'MSRA50';
            X = im2double(uint8(X));
        case 5
            [X, y] = load_uni_mat('segment_uni');
            name = 'Segment';
        case 6
            [X, y] = load_sep_mat('STL-10');
            name = 'STL-10';
        case 7
            [X, y] = load_uni_mat('UmistData_25_uni');
            name = 'UMist-25';
            X = im2double(uint8(X));
        case 8
            [X, y] = load_uni_mat('waveform-21_uni');
            name = 'Waveform-21';
        otherwise
            error('Unknown dataset')
    end
    c = size(unique(y), 1);

    [y, idx] = sort(y);
    X = X(idx, :);

    X = double(X);
end

function [X, y] = load_sep_mat(name)
    files = fullfile('data', name, {'data.mat', 'labels.mat'});

    X = load(files{1});
    X = X.data;

    y = load(files{2});
    y = y.labels;

    if size(y, 2) ~= 1
        y = y';
    end
end

function [X, y] = load_uni_mat(name)
    data = load(fullfile('data', name));
    X = load_multi_fields(data, {'X', 'fea'});
    y = load_multi_fields(data, {'Y', 'y', 'gnd'});

    if size(y, 2) ~= 1
        y = y';
    end
end

function ret = load_multi_fields(data, fields)
    found = false;
    for field = fields
        if isfield(data, field{:})
            ret = data.(field{:});
            found = true;
            break;
        end
    end
    if ~found
        error('field not found');
    end
end

function [X, y] = load_cell_mat(name)
    data = load(fullfile('data', name));

    X = data.fea;
    X = cellfun(@(img) reshape(img, 1, []), X, 'UniformOutput', false);
    X = cell2mat(X');

    y = data.gnd;

    if size(y, 2) ~= 1
        y = y';
    end

    assert(size(X, 1) == size(y, 1));
end
