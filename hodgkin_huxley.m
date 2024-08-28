classdef hodgkin_huxley

    methods(Static)

        % Calculate the input current based on neuron type and time
        function I_Ext = input_current(t)
            % Initialize current as 0
            I_Ext = 0; % Default value

            if t > 5 && t < 5.4 
                I_Ext = -70;
            end
        end
        

        % Set the value of fT and validate its range
        function set_fT(fT)
            if fT < 0 || fT > 1
                error('MATLAB:validation:InvalidInput', 'fT must be within the range [0, 1].');
            end
            hodgkin_huxley.fT = fT;
        end
        
        function get_membrane_voltage_derivative=get_membrane_voltage_derivative(Vm, n, m, h, I_ext)
        % Calculate the state variable Vm
        % Equation 23, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), n (Potassium
        % activation), m (Sodium activation), h (Sodium inactivation),
        % I_ext (External Current)

        % Outputs: dVm/dt 

            % Constants from literature
            Cm = 1;
            vna = -115;
            vk = 12;
            vl = -10.613;
            gna = 120;
            gk = 36;
            gl = 0.3;
            
            % Hodgkin-Huxley equation for membrane voltage derivative
            get_membrane_voltage_derivative = 1/Cm * (I_ext + gk * n^4 * (vk - Vm) + gna * m^3 * h * (vna - Vm) + gl * (vl - Vm));
        end
        
        function get_membrane_voltage_trauma_derivative=get_membrane_voltage_trauma_derivative(VmT, Vm, n, m, h, I_ext, mT, hT, fT)
        % Calculate the state variable VmT
        % Equation 24, Appendix B

        % Inputs: VmT (Membrane potential - with trauma), n (Potassium
        % activation), m/mT (Sodium activation without/with trauma), h/hT
        % (Sodium inactivation without/with trauma), I_ext (External Current)

        % Outputs: dVmT/dt 

            % Constants and conductances
            Cm = 1;
            vna = -115;
            vk = 12;
            vl = -10.613;
            gna = 120;
            gk = 36;
            gl = 0.3;
            
            % Hodgkin-Huxley equation for membrane voltage derivative under trauma conditions
            get_membrane_voltage_trauma_derivative = 1/Cm * (I_ext + gk * n^4 * (vk - VmT) + gna * ((1-fT) * m^3 * h + fT * mT^3 * hT) * (vna - Vm) + gl * (vl - Vm));
        end
        
        function get_n_derivative=get_n_derivative(Vm, n)
        % Calculate the derivative of gating variable n
        % Equation 10, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), n (Potassium
        % activation)

        % Output: dn/dt 

            get_n_derivative = hodgkin_huxley.get_alpha_n(Vm) * (1 - n) - hodgkin_huxley.get_beta_n(Vm) * n;
        end
        
        function  get_m_derivative=get_m_derivative(Vm, m)

        % Calculate the derivative of gating variable m
        % Equation 8, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), m (Sodium
        % activation)

        % Output: dm/dt     

            get_m_derivative = hodgkin_huxley.get_alpha_m(Vm) * (1 - m) - hodgkin_huxley.get_beta_m(Vm) * m;
        end
       
        function get_h_derivative=get_h_derivative(Vm, h)

        % Calculate the derivative of gating variable h
        % Equation 9, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), h (Sodium
        % inactivation)

        % Output: dh/dt   

            get_h_derivative = hodgkin_huxley.get_alpha_h(Vm) * (1 - h) - hodgkin_huxley.get_beta_h(Vm) * h;
        end

        function get_m_trauma_derivative=get_m_trauma_derivative(VmT, Vs, mT)

        % Calculate the derivative of gating variable mT
        % Equation 17, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), mT (Sodium
        % activation with trauma), Vs (Coupled voltage shift)

        % Output: dmT/dt  

            get_m_trauma_derivative = hodgkin_huxley.get_alpha_mT(VmT, Vs) * (1 - mT) - hodgkin_huxley.get_beta_mT(VmT,Vs) * mT;
        end
        
        function get_h_trauma_derivative=get_h_trauma_derivative(VmT, Vs, hT)

        % Calculate the derivative of gating variable hT
        % Equation 18, Appendix B

        % Inputs: Vm (Membrane potential - no trauma), hT (Sodium
        % inactivation with trauma), Vs (Coupled voltage shift)

        % Output: dhT/dt 

            get_h_trauma_derivative = hodgkin_huxley.get_alpha_hT(VmT,Vs) * (1 - hT) - hodgkin_huxley.get_beta_hT(VmT,Vs) * hT;
        end
        
   
        function get_alpha_n=get_alpha_n(Vm)
        
        % Calculate alpha function for gating variable n
        % Equation 11, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: alpha_n (Potassium forward transition rate)
        
            get_alpha_n = 0.01 * (Vm + 10) / (exp((Vm + 10)/10) - 1);
        end
        
        function get_beta_n=get_beta_n(Vm)

        % Calculate beta function for gating variable n
        % Equation 12, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: beta_n (Potassium backward transition rate)

            get_beta_n = 0.125 * exp(Vm/80);
        end

        function get_alpha_m=get_alpha_m(Vm)

        % Calculate alpha function for gating variable m
        % Equation 13, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: alpha_m (Sodium activation backward transition rate)

            get_alpha_m = 0.1 * (Vm + 25) / (exp((Vm + 25)/10) - 1);
        end
        
        function get_beta_m=get_beta_m(Vm)

        % Calculate beta function for gating variable m
        % Equation 14, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: beta_m (Sodium activation backward transition rate)

            get_beta_m = 4 * exp(Vm/20);
        end

        function get_alpha_mT=get_alpha_mT(VmT,Vs)

        % Calculate alpha function for gating variable mT
        % Equation 19, Appendix B

        % Inputs: VmT (Membrane potential - with trauma), Vs (Coupled
        % voltage shift)

        % Output: alpha_mT (Sodium activation forward transition rate)

            get_alpha_mT = 0.1 * (VmT + Vs + 25) / (exp((VmT + Vs + 25)/10) - 1);
        end
        

        function get_beta_mT=get_beta_mT(VmT,Vs)
        
        % Calculate beta function for gating variable mT
        % Equation 20, Appendix B

        % Inputs: VmT (Membrane potential - with trauma), Vs (Coupled
        % voltage shift)

        % Output: beta_mT (Sodium activation backward transition rate)

            get_beta_mT = 4 * exp((VmT + Vs)/20);
        end

        function get_alpha_h=get_alpha_h(Vm)
        
        % Calculate beta function for gating variable h
        % Equation 15, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: alpha_h (Sodium activation backward transition rate)

            get_alpha_h = 0.07 * exp(Vm/20);
        end
        
        function get_beta_h=get_beta_h(Vm)

        % Calculate beta function for gating variable h
        % Equation 16, Appendix B

        % Inputs: Vm (Membrane potential - no trauma)

        % Output: beta_h (Sodium activation backward transition rate)

            get_beta_h = 1/(exp((Vm + 30)/10) + 1);
        end
        
        function get_alpha_hT=get_alpha_hT(VmT,Vs)

        % Calculate alpha function for gating variable hT
        % Equation 21, Appendix B

        % Inputs: VmT (Membrane potential - with trauma), Vs (Coupled
        % voltage shift)

        % Output: alpha_hT (Sodium inactivation forward transition rate)

            get_alpha_hT = 0.07 * exp((VmT+Vs)/20);
        end
        
        function get_beta_hT=get_beta_hT(VmT,Vs)

        % Calculate beta function for gating variable hT
        % Equation 22, Appendix B

        % Inputs: VmT (Membrane potential - with trauma), Vs (Coupled
        % voltage shift)

        % Output: beta_hT (Sodium inactivation backward transition rate)

            get_beta_hT = 1/(exp((VmT + Vs + 30)/10) + 1);
        end

    end
end
