function [ Vrd, Vrsd, Vrcd, cot_theta ] = verificaTaglio( sezione, d, Asw, Asl, s, alpha, fck, Ned , varargin)
%VERIFICATAGLIO verifica a taglio sezione in c.a.
%   Verifica a taglio di una sezione in c.a.
%   La funzione verifica 3 tipologie di taglio:
%   1. elementi non armati a taglio
%   2. elementi armati a taglio
%       2.1 verifica in classe di duttilità 'B' (i.e. 1 <= cot(theta) <= 1)
%       2.2 verifica in classe di duttilità 'A' (i.e. cot(theta) = 1)
%   3. verifica taglio delle barre longitudinali agli appoggi

%% Valori di default ed estrazione argomenti opzionali
classe = 'B';   % classe di duttilità

while ~isempty(varargin)
    switch lower(varargin{1})
        case 'classe'
            classe = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end

%% estrazione dei vettori della matrice "sezione"

xm = sezione(:,1);  % il primo campo alla coordinata in xm del baricentro dei rettangoli
ym = sezione(:,2);  % il secondo campo è riservato alla coordinata in ym del baricentro dei rattngoli
db = sezione(:,3);  % il terzo campo è riservato alla larghezza in x dei rettangoli
dh = sezione(:,4);  % il quarto campo è riservato alla larghezza in y dei rettangoli

[uym, ih, ~] = unique(ym);    % elimina le componenti duplicate
H = sum(dh(ih));    % massima altezza della sezione (somma solo una volta dh alla quota ym)
B = zeros(length(uym),2);
for i = 1:length(uym)
    B(i,:) = [sum( abs( db( ym == uym(i) ) ) ), uym(i)]; % larghezza della sezione in funzione dell'altezza
end
Ac = sum(db.*dh);   % area della sezione di cls

%% estrazione dei materiali
mat.cls = derivaCaratteristicheCA(fck);
mat.steel = derivaCaratteristicheAcciaio;
% estraggo le variabili di interesse dalla struttura dei materiali
f_cd = mat.cls.f_cd;
f_ck = mat.cls.f_ck;
gamma_csl = mat.cls.gamma_cls;
f_yd = mat.steel.f_yd;

%% preparazione parametri
bw = min(B(:,1));   % la larghezza della sezione resistente a taglio è il minimo delle larghezze della sezione
alpha = deg2rad(alpha); % alpha è convertito in radianti
dmax = max(d);  % altezza utile della sezione
sigma_cp = Ned/Ac;  % tensione media del cls. NB. Ned deve essere dimensionalemente compatibile con Ac

%% Caso 1: elementi non armati a taglio
if Asw == 0
    k = min(1 +(200/dmax)^.5, 2);
    v_min = .035 * k^(3/2) * f_ck^.5;   % taglio resistente minimo del cls (tensione)
    rho_l = Asl/(bw*dmax);  % percentuale di armatura tesa
    Vrd = max((0.18*k*(100*rho_l*f_ck)^(1/3)/gamma_csl + 0.15*sigma_cp)*bw*dmax, v_min*bw*dmax);    % taglio resistente senza armatura a taglio
else  
    %% Caso 2: elementi armati a taglio
    if sigma_cp == 0
        a_c = 1;
    elseif sigma_cp < 0.25*f_cd
        a_c = 1 + sigma_cp/f_cd;
    elseif sigma_cp <= 0.5*f_cd
        a_c = 1.25;
    else
        a_c = max(2.5*(1-sigma_cp/f_cd), 0);    % se sigma_cp > f_cd, allora la sezione non è verificata a compressione (ma è non è una verifica a taglio)
    end
    switch classe
        case 'B'
            cot_theta = sqrt((bw*a_c*0.5*f_cd)/(Asw/s*f_yd*sin(alpha))-1);
            if cot_theta < 1
                cot_theta = 1;
            elseif cot_theta > 2.5
                cot_theta = 2.5;
            end
        case 'A'
            cot_theta = 1;
    end
    Vrsd = 0.9*d*Asw/s*f_yd*(cot_theta + cot(alpha))*sin(alpha);
    Vrcd = 0.9*d*bw*a_c*0.5*f_cd*(cot_theta + cot(alpha))/(1+cot_theta^2);
    Vrd = min(Vrsd, Vrcd);
end

end

