function [ tab ] = derivaCaratteristicheAcciaio()
%DERIVACARATTERISTICHE derive fundamental values for rebar steel 
%   the funtcion caluclate each of the fundamental properties of rebar
%   steel B450C. Output is a table with each of these values.
tab = table;

tab.f_yk = 450;
tab.f_tk = 540;
tab.gamma_s = 1.15;
tab.f_yd = tab.f_yk/tab.gamma_s;
tab.E_s = 210000;
tab.esu = 67.5e-3;
tab.eyd = tab.f_yd/tab.E_s;

end