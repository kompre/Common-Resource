function [ite] = dicotomico( varname, output, fx, f0, varA, varB, varargin )
%DICOTOMICO Metodo dicotomico applicato alla funzione fx, per la variabile
%var
%   Con il metodo dicotomico di ricercano gli zero della funzione fx,
%   rispetto al valore f0, variando la variabile var, nell'intervallo
%   specificato [varA, varB] (n.b. varA < varB)

%% load optional value
precisione = 10;    % impostazione di default precisione del metodo 
while ~isempty(varargin)
    switch lower(varargin{1})
        case 'precisione'
            precisione = varargin{2};
        otherwise
            error('Unexpected argument')
    end
    varargin(1:2) = [];    
end
errore = 10^-(precisione);
%%
err = 1;  % inizializzazione variabile di controllo
ite = 0;
while err >= errore
    ite = ite +1;
    var = (varB + varA)/2; % valore medio tra i due estremi
    evalin('caller', [ varname '=' num2str(var,precisione) ';']);
    ris = evalin('caller', fx);   % il risultato principale della funzione è salvato localmente
    fm = ris - f0;
    if fm < 0
        varA = var;
    else
        varB = var;
    end
    err = (varB - varA)/2;
end

evalin('caller', [ output ' = ' fx]); % scrive i risultati della funzione fx nel ws della funzione chiamante


end

