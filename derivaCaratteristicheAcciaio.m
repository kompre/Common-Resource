function [ t ] = derivaCaratteristicheAcciaio()
%DERIVACARATTERISTICHE derive fundamental values for rebar steel 
%   the funtcion caluclate each of the fundamental properties of rebar
%   steel B450C. Output is a table with each of these values.
t = struct;

t.f_yk = 450;
t.f_tk = 540;
t.gamma_s = 1.15;
t.f_yd = t.f_yk/t.gamma_s;
t.E_s = 210000;
t.esu = 67.5e-3;
t.eyd = t.f_yd/t.E_s;

end