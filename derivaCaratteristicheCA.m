function [ t ] = derivaCaratteristicheCA( f_ck, varargin )
%DERIVACARATTERISTICHE derive charateristic value from fck, Rck
%   the function calculate every fundamental values from the fck
%   value (Rck is given for naming purpose only) according to EC2. the
%   output is a table containg each of this values

%% estrazione argomenti opzionali

R_ck = nan;

while ~isempty(varargin)
    switch varargin{1}
        case 'R_ck'
            R_ck = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end


ni = .2; % coefficiente di Poisson
gamma_cls = 1.5;
alpha_cc = .85;

f_cd = alpha_cc*f_ck/gamma_cls;

f_cm = f_ck +8;

if f_ck <= 50
    f_ctm = .3 *f_ck^(2/3);
else
    f_ctm = 2.12 * log(1+f_cm/10);
end

f_ctk05 = .7 * f_ctm;

f_ctk95 = 1.3 * f_ctm;

E_cm = 22*(f_cm/10)^.3 * 1E3;

G = E_cm/(2*(1+ni));

if f_ck <= 50
    ecu = 3.5;
else
    ecu = 2.6 + 35*((90-f_ck)/100)^4;
end

if f_ck <= 50
    ec2 = 2;
else
    ec2 = 2 + .085*(f_ck-50)^.53;
end

if f_ck <= 50
    ec3 = 1.75;
else
    ec3 = 1.75 + .55*(f_ck-50)/40;
end


if f_ck <= 50
    ec4 = .7;
else
    ec4 = .2*ecu;
end

f_bk = 2.25 * f_ctk05;

ecu = ecu*1e-3;
ec2 = ec2*1e-3;
ec3 = ec3*1e-3;
ec4 = ec4*1e-3;

t = struct('f_ck', f_ck,....
    'R_ck', R_ck,...
    'gamma_cls', gamma_cls,...
    'alpha_cc', alpha_cc,...
    'f_cd', f_cd,...
    'f_cm', f_cm,...
    'f_ctm', f_ctm,...
    'f_ctk05', f_ctk05,...
    'f_ctk95', f_ctk95,...
    'f_bk', f_bk,...
    'E_cm', E_cm,...
    'ni', ni,...
    'G', G,...
    'ecu', ecu,...
    'ec2', ec2,...
    'ec3', ec3,...
    'ec4', ec4);

end

