% Simulation 1: Vs = 10 mV, fT = 10%

fT = 0.1;  % 10% of affected NaV Ion Channels
velocity = 12.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 2: Vs = 10 mV, fT = 50%

fT = 0.5;  % 50% of affected NaV Ion Channels
velocity = 12.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 3: Vs = 10 mV, fT = 90%

fT = 0.9;  % 90% of affected NaV Ion Channels
velocity = 12.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 4: Vs = 14 mV, fT = 10%

fT = 0.1;  % 10% of affected NaV Ion Channels
velocity = 14.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 5: Vs = 14 mV, fT = 50%

fT = 0.5;  % 50% of affected NaV Ion Channels
velocity = 14.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 6: Vs = 14 mV, fT = 90%

fT = 0.9;  % 90% of affected NaV Ion Channels
velocity = 14.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 7: Vs = 20 mV, fT = 10%

fT = 0.1;  % 10% of affected NaV Ion Channels
velocity = 18.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 8: Vs = 20 mV, fT = 50%

fT = 0.5;  % 50% of affected NaV Ion Channels
velocity = 18.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

%% 

% Simulation 9: Vs = 20 mV, fT = 90%

fT = 0.9;  % 90% of affected NaV Ion Channels
velocity = 18.00;
[x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);

