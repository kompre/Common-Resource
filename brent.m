function [ite] = brent( x, output, fx, f0, a, b, varargin )
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

strPrec = sprintf('%%0.%df', precisione);
errore = 10^-(precisione);
%%
evalin('caller', [ x '=' sprintf(strPrec, a) ';']);   % assegno x = a
fa = evalin('caller', fx) - f0; % calcolo di f(a)
evalin('caller', [ x '=' sprintf(strPrec, b) ';']);   % assegno x = b
fb = evalin('caller', fx) - f0; % calcolo di f(b)

% verifica che l'intervallo contenga la radice della funzione 
if fa*fb >= 0 
    error('L''intervallo non contiente radice');
end

% verifica quale dei due valori è una migliore approssimazione della radice
if abs(fa) < abs(fb) 
    [a, b] = swap(a,b); % scambia i valori di a e b in modo tale che b sia sempre una migliore stima della radice di x
    [fa, fb] = swap(fa, fb);
end

c = a;  % c è il valore dell'iterazione -1, inizializzato ad a per la prima iterazione
fc = fa;

mflag = true;   % flag che segnala se è stato usato il metodo di bisezione all'iterazione precedente. Inizializzato a true per la prima iterazione
delta = errore;
ite = 0;
%tab = table % for debug
while fb ~= 0 && abs(b-a) > errore
    ite = ite +1;
    if fa~=fc && fb~=fc % tutti i valori di f(x) sono distinti per x = a, x = b e x = c;
        s = a*fb*fc/((fa-fb)*(fa-fc)) + b*fa*fc/((fb-fa)*(fb-fc)) + c*fa*fb/((fc-fa)*(fc-fb)); % interpolazione quadratica inversa
    else
        s = b - fb*(b - a)/(fb - fa);   % secante
    end
   
    if      ~and(s > min((3*a+b)/4,b), s < max((3*a+b)/4,b)) ||...
            (mflag && abs(s-b) >= abs(b-c)/2) || ...
            (~mflag && abs(s-b) >= abs(c-d)/2) ||...
            (mflag && abs(b-c) < abs(delta)) ||...
            (~mflag && abs(c-d) < abs(delta))
        s = (b + a)/2; % bisezione
        mflag = true;
    else
        mflag = false;
    end
    
    % calcolo della f(x) per x = s
    evalin('caller', [ x '=' sprintf(strPrec, s) ';']);
    fs = evalin('caller', fx) - f0;   % il risultato principale della funzione è salvato localmente
    
    % tab = [tab; table(a, fa, b, fb, s, fs, c, fc)] % for debug
    % assegnazione valori a d, variabile di iterazione -2
    d = c;
    
    % asssegnazione valori a c, variabile di iterazione -1
    c = b;
    fc = fb;
    
    if fa*fs < 0
        b = s;
        fb = fs;
    else
        a = s;
        fa = fs;
    end
    if abs(fa) < abs(fb)
        [a, b] = swap(a, b);
        [fa, fb] = swap(fa, fb);
    end
    
end

evalin('caller', [ x '=' num2str(b ,precisione) ';']);
evalin('caller', [ output ' = ' fx]); % scrive i risultati della funzione fx nel ws della funzione chiamante


end

