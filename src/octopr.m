function deriv = pder(f, n, varargin); 
  #calculates symmetric partial derivative, differential quotient by h = 10^-8
  #takes (f, n, args)
  #f - pointer to the to be diff. function
  #n - position of the argument in the args array to be diff. by
  #args - the arguments array to pass to f, defining the point where pder is to be calculated
  h = 10^(-8);
  l = nargin();
  argsplus = varargin;
  argsminus = varargin;
  argsplus{n} = argsplus{n} .+ h/2;
  argsminus{n} = argsminus{n} .- h/2;
  deriv = (f(argsplus{1:(l-2)}) .- f(argsminus{1:(l-2)}))./h;
endfunction

function unsich = gausserr(f, varargin)  
  # varargin = params, dparams
  #calculate uncertainty of f(params) by the Gauss rule, provided the argument uncertainties dparams (as comma-sep. sets, not vectors/lists)
  #returns single unsich values, or a set of points, if input is set of points
  #f to be passed as @f (handle);
  #f must be called as f(params), params as a set (not vector/list - just comma separated values)

  l = (nargin()-1)/2;
  summa = 0;
  for n = 1:l
    summa = summa .+ (pder(f, n, varargin{1:l}).*varargin{l+n}).**2;
  endfor
  unsich = sqrt(summa);
endfunction

function  [xbar, dx] = getstat(x)
  #mittelwert und standardabweichung/sqrt(n)
  l = length(x);
  xbar = sum(x)/l;
  summa = 0;
  for i = 1:l
    summa += (xbar - x(i))**2;
  endfor
  dx = sqrt(1/l/(l-1)*summa);
endfunction

function [xbar, dxbar] = getwavg(x, dx)
  #gewichteter mittelwert, mit unsich
  l = length(x);
  weights = (dx(1)^2)./(dx.^2);
  xbar = sum(weights.*x)/sum(weights);
  suma = 0;
  for i = 1:l
    suma += (dx(i)*weights(i))^2;
  endfor
  dxbar = sqrt(suma)/sum(weights);
endfunction

function [chi2, dof, c2d] = chi2dof(fitval, mesval, dy, nparam)
  #berechne chi^2, dof, und chi^2/dof werte.
  # input: fitval- Werte aus dem fit,
  # input: mesval- Gemessene werte,
  # input: dy- Unsicherheiten für Messwerte
  chi2 = sum((fitval.-mesval).**2/dy.**2);
  dof = length(mesval).-nparam;
  c2d = chi2./dof;
endfunction