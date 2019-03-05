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

function rss = RSS(y, fx)
  # Residual sum of squares
  # usage: RSS(observations, fitted value)
  rss = sum((y - fx).^2);
endfunction

function [chi2, dof, chi2dof] = chi2dof(fx, y, dy, np)
  #berechne chi^2, dof, und chi^2/dof werte.
  # input: fx - predicted values,
  # input: y  - observed values,
  # input: dy - uncertainty in observed values
  # input: np - number of parameters f takes besides x
  chi2 = 0;
  for i = 1:length(fx)
    chi2 += (fx(i)-y(i)).^2./dy(i).^2;   
  endfor
  dof = length(y).-np;
  chi2dof = chi2./dof;
endfunction