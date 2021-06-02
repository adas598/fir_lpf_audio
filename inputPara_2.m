function [fc, order] = inputPara_2(fs)
    fc = input("Enter a cutoff frequency (not normalised): ");
    order = input("Enter the order of the filter: ");
    fc = fc/fs/2;
end