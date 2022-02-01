function B = getB(x,y,t)
O = [cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1];
T = [x; y; t];

B = [O T; 0 0 0 1];
end