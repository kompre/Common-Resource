function [ tab ] = derivaCaratteristicheAcciaio()
%DERIVACARATTERISTICHE derive fundamental values for rebar steel 
%   the funtcion caluclate each of the fundamental properties of rebar
%   steel B450C. Output is a table with each of these values.
tab = table;

tab.fyk = 450;
tab.ftk = 540;
tab.gamma_s = 1.15;
tab.fyd = tab.fyk/tab.gamma_s;
tab.Es = 210000;
tab.esu = 67.5e-3;
tab.eyd = tab.fyd/tab.Es;

end