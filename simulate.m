classdef simulate

    methods(Static)

        function [x, t] = solve_hodgkin_huxley_ode(fT, velocity)
            % HIC Constants
            duration = 0.036;
            time_values = linspace(0, 160, 1000);  % Range of starting times
        
            acceleration_values = zeros(size(time_values));
            HIC_values = zeros(size(time_values));
            Vs_array = zeros(size(time_values));

            % Calculate acceleration, HIC, and Vs for each time value
            for i = 1:numel(time_values)
                [Vs_array(i), acceleration_values(i), HIC_values(i)] = calculate_voltage_shift.get_voltage_shift(velocity, time_values(i), duration);
            end

            Vs = max(Vs_array);
            disp('____________________________');
            disp(' ');
            disp(['Maximum Voltage Shift: ', num2str(Vs), ' mV']);

            % Plot acceleration and HIC over time
            figure;
            subplot(2, 1, 1);
            plot(time_values, acceleration_values);
            xlabel('Time (msec)');
            ylabel('Acceleration (m/s^2)');
            title('Acceleration over impact duration');
        
            subplot(2, 1, 2);
            plot(time_values, HIC_values);
            xlabel('Time');
            ylabel('HIC');
            title('HIC over impact duration');
                    
            % Vary to be between 0.1 to 1
            fprintf('fT as a percentage: %.2f%%\n', fT * 100);
        
            % Set initial conditions at equilibrium
            Vm_eq = 0;
        
            n_eq = hodgkin_huxley.get_alpha_n(Vm_eq) / (hodgkin_huxley.get_alpha_n(Vm_eq) + hodgkin_huxley.get_beta_n(Vm_eq));
            m_eq = hodgkin_huxley.get_alpha_m(Vm_eq) / (hodgkin_huxley.get_alpha_m(Vm_eq) + hodgkin_huxley.get_beta_m(Vm_eq));
            h_eq = hodgkin_huxley.get_alpha_h(Vm_eq) / (hodgkin_huxley.get_alpha_h(Vm_eq) + hodgkin_huxley.get_beta_h(Vm_eq));
            mT_eq = hodgkin_huxley.get_alpha_mT(Vm_eq, Vs) / (hodgkin_huxley.get_alpha_mT(Vm_eq, Vs) + hodgkin_huxley.get_beta_mT(Vm_eq, Vs));
            hT_eq = hodgkin_huxley.get_alpha_hT(Vm_eq, Vs) / (hodgkin_huxley.get_alpha_hT(Vm_eq, Vs) + hodgkin_huxley.get_beta_hT(Vm_eq, Vs));
        
            % display equalibrium values
            disp(['n_eq: ', num2str(n_eq)]);
            disp(['m_eq: ', num2str(m_eq)]);
            disp(['h_eq: ', num2str(h_eq)]);
            disp(['mT_eq: ', num2str(mT_eq)]);
            disp(['hT_eq: ', num2str(hT_eq)]);
        
            % Set initial conditions
            initial_conditions = [0 n_eq m_eq h_eq 0 mT_eq hT_eq];
        
            % Solve Hodgkin-Huxley ODE
            tspan = [0, 30];
            sol = ode45(@(t, x) simulate.state_variables(t, x, Vs, fT), tspan, initial_conditions);
            x = sol.y;
            t = sol.x;
        
            % implement correct starting position
            x(1,:) = -x(1,:) -70; % Vm_shift
            x(5,:) = -x(5,:) -70; % VmT_shift
        
            % Return the results
            maxVm = max(x(1,:));
            maxVmT = max(x(5,:));
            maxN = max(x(2,:));
            maxhT = min(x(7,:));
            maxmT = max(x(6,:));
            maxh = min(x(4,:));
            minm = max(x(3,:));
        
            disp(['Max Vm: ', num2str(maxVm)]);
            disp(['Max VmT: ', num2str(maxVmT)]);
            disp(['Min hT: ', num2str(maxhT)]);
            disp(['Max mT: ', num2str(maxmT)]);
            disp(['Min h: ', num2str(maxh)]);
            disp(['Max m: ', num2str(minm)]);
            disp(['Max n: ', num2str(maxN)]);
            disp('____________________________');
        
            % Plotting membrane voltages
            figure;
            subplot(3,1,1);
            plot(t, x(1,:), 'r'); hold on; % Vm
            plot(t, x(5,:), 'b'); hold on; % VmT
            xlabel('Time (ms)');
            ylabel('Membrane Voltage (mV)');
            legend('Vm','VmT');
            title('Membrane Voltage vs. Time');
        
            % Plotting gating variables
            subplot(3,1,2);
            plot(t, x(2,:)); hold on; % Plot n
            plot(t, x(3,:)); hold on; % Plot m
            plot(t, x(4,:)); hold on; % Plot h
            plot(t, x(6,:)); hold on; % Plot mT
            plot(t, x(7,:)); hold on; % Plot hT
            xlabel('Time (ms)');
            ylabel('Gating Variables');
            legend('n', 'm', 'h', 'mT', 'hT');
            title('State Variables vs. Time');
            
            % Plotting the current spike for visual represenation purposes
            subplot(3,1,3);   
            
            % Define the time span
            current_t_span = linspace(0, 30, 1000);
            
            % Initialize current vector
            I_Ext = zeros(size(current_t_span));
            
            % Show external current at time that matches that in hodgkin_huxley
            for i = 1:length(current_t_span)
                if current_t_span(i) >= 5 && current_t_span(i) <= 5.4
                    I_Ext(i) = -70; 
                end
            end

            % Plot the results
            plot(current_t_span, I_Ext);
            xlabel('Time (ms)');
            ylabel('Current External (mA)');
            title('External Current vs. Time');
            ylim([-80, 0]);

        end
        
        % State Variables
        function state_variables = state_variables(t, x, Vs, fT)
        
            Vm = x(1); % Membrane voltage - no trauma
            n = x(2); % Potassium activation
            m = x(3); % Sodium activation
            h = x(4); % Sodium inactivation
            VmT = x(5); % Membrane voltage - with trauma
            mT = x(6); % Sodium activation - with trauma
            hT = x(7); % Sodium inactivation - with trauma
            I_Ext = hodgkin_huxley.input_current(t); % External current
        
            state_variables = [0; 0; 0; 0; 0; 0; 0];
            
            % calculate derivatives
            state_variables(1) = hodgkin_huxley.get_membrane_voltage_derivative(Vm, n, m, h, I_Ext);
            state_variables(2) = hodgkin_huxley.get_n_derivative(Vm, n);
            state_variables(3) = hodgkin_huxley.get_m_derivative(Vm, m);
            state_variables(4) = hodgkin_huxley.get_h_derivative(Vm, h);
            state_variables(5) = hodgkin_huxley.get_membrane_voltage_trauma_derivative(VmT, Vm, n, m, h, I_Ext, mT, hT, fT);
            state_variables(6) = hodgkin_huxley.get_m_trauma_derivative(VmT, Vs, mT);
            state_variables(7) = hodgkin_huxley.get_h_trauma_derivative(VmT, Vs, hT);
        end

    end
end
