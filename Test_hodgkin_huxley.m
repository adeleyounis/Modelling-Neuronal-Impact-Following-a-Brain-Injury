classdef Test_hodgkin_huxley < matlab.unittest.TestCase
    
    methods (Test)
        
        % Test fT values are within range.
        function testInputfTValidation(testCase)
            
            velocity = 14.0;
    
            % Verify that an error is thrown when input parameter fT is
            % outside the valid range (0 - 1)
            fT_low = -0.1;
            fT_high = 1.1;
            
            % Verify error for fT too low
            try
                simulate.solve_hodgkin_huxley_ode(fT_low, velocity);
            catch ex_low
                testCase.verifyEqual(ex_low.identifier, 'MATLAB:validation:InvalidInput', 'Error identifier does not match for low fT');
            end
            
            % Verify error for fT too high
            try
                simulate.solve_hodgkin_huxley_ode(fT_high, velocity);
            catch ex_high
                testCase.verifyEqual(ex_high.identifier, 'MATLAB:validation:InvalidInput', 'Error identifier does not match for high fT');
            end
        end
        
        % Test voltage shift outputs are consistent with previous results.
        function testVoltageShift(testCase)
            fT = 0.5; % Initial fT value
            velocities = [14.00, 18.00, 20.00];
            
            for velocity = velocities
                % Call solve ode and get Vs
                [x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);
                
                % Check the value of Vs and perform different actions accordingly
                if velocity == 14.00
                    % Test case for Vs = 20
                    disp("Testing for Vs = 20");
        
                    % Calculate the final Vm and VmT values from the simulation
                    % Vm is constant
                    final_Vm = max(x(1,:));
                    final_VmT = max(x(5,:));
        
                    % Previous Results
                    expected_final_Vm = 35.963;
                    expected_final_VmT = 31.609; 
        
                    % Verify that the final Vm and VmT values match the expected shifted values
                    testCase.verifyEqual(final_Vm, expected_final_Vm, 'AbsTol', 1e-3);
                    testCase.verifyEqual(final_VmT, expected_final_VmT, 'AbsTol', 1e-3);

                elseif velocity == 18.00
                    % Test case for Vs = 14
                    disp("Testing for Vs = 14");

                    % Calculate the final Vm and VmT values from the simulation
                    final_VmT = max(x(5,:));

                     % Previous Results
                    expected_final_VmT = -11.293;

                    % Verify that the final VmT value matches the expected shifted value
                    testCase.verifyEqual(final_VmT, expected_final_VmT, 'AbsTol', 1e-3);

                elseif velocity == 20.00
                    % Test case for Vs = 10
                    disp("Testing for Vs = 10");

                    % Calculate the final Vm and VmT values from the simulation
                    final_VmT = max(x(5,:));

                    % Previous Results
                    expected_final_VmT = -11.293; 

                    % Verify that the final VmT value matches the expected shifted value
                    testCase.verifyEqual(final_VmT, expected_final_VmT, 'AbsTol', 1e-3);

                else
                    % If simulate.Vs has an unexpected value, display a warning
                    warning("Unexpected value of simulate.Vs");
                end
            end
        end

        
        % test equilibrium points for perfect condition axonal transmission
        function testPerfectConditionEquilibriumPoints(testCase)
            
            % Expected values
            n_eq_expected = 0.31768;
            m_eq_expected = 0.052932;
            h_eq_expected = 0.59612;

            % Call the functions to get the equilibrium points
            n_eq = hodgkin_huxley.get_alpha_n(0) / (hodgkin_huxley.get_alpha_n(0) + hodgkin_huxley.get_beta_n(0));
            m_eq = hodgkin_huxley.get_alpha_m(0) / (hodgkin_huxley.get_alpha_m(0) + hodgkin_huxley.get_beta_m(0));
            h_eq = hodgkin_huxley.get_alpha_h(0) / (hodgkin_huxley.get_alpha_h(0) + hodgkin_huxley.get_beta_h(0));
          
            % Verify that the calculated equilibrium points match the expected values
            testCase.verifyEqual(n_eq, n_eq_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(m_eq, m_eq_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(h_eq, h_eq_expected, 'AbsTol', 1e-3);
        end

        % Test equilibrium points for perfect condition axonal transmission
        function testTraumaConditionEquilibriumPoints(testCase)
            
            % Expected values
            mT_eq_expected_10 = 0.01625;
            hT_eq_expected_10 = 0.86517;
            mT_eq_expected_14 = 0.009904;
            hT_eq_expected_14 = 0.92078;
            mT_eq_expected_20 = 0.0046278;
            hT_eq_expected_20 = 0.96602;

            % Call the functions to get the equilibrium points with a voltage shift of 20 mV
            % Uses (Vm_eq, Vs)
            mT_eq_10 = hodgkin_huxley.get_alpha_mT(0,10) / (hodgkin_huxley.get_alpha_mT(0,10) + hodgkin_huxley.get_beta_mT(0,10));
            hT_eq_10 = hodgkin_huxley.get_alpha_hT(0,10) / (hodgkin_huxley.get_alpha_hT(0,10) + hodgkin_huxley.get_beta_hT(0,10));
            mT_eq_14 = hodgkin_huxley.get_alpha_mT(0,14) / (hodgkin_huxley.get_alpha_mT(0,14) + hodgkin_huxley.get_beta_mT(0,14));
            hT_eq_14 = hodgkin_huxley.get_alpha_hT(0,14) / (hodgkin_huxley.get_alpha_hT(0,14) + hodgkin_huxley.get_beta_hT(0,14));
            mT_eq_20 = hodgkin_huxley.get_alpha_mT(0,20) / (hodgkin_huxley.get_alpha_mT(0,20) + hodgkin_huxley.get_beta_mT(0,20));
            hT_eq_20 = hodgkin_huxley.get_alpha_hT(0,20) / (hodgkin_huxley.get_alpha_hT(0,20) + hodgkin_huxley.get_beta_hT(0,20));
          
            % Verify that the calculated equilibrium points match the expected values
            testCase.verifyEqual(mT_eq_10, mT_eq_expected_10, 'AbsTol', 1e-3);
            testCase.verifyEqual(hT_eq_10, hT_eq_expected_10, 'AbsTol', 1e-3);
            testCase.verifyEqual(mT_eq_14, mT_eq_expected_14, 'AbsTol', 1e-3);
            testCase.verifyEqual(hT_eq_14, hT_eq_expected_14, 'AbsTol', 1e-3);
            testCase.verifyEqual(mT_eq_20, mT_eq_expected_20, 'AbsTol', 1e-3);
            testCase.verifyEqual(hT_eq_20, hT_eq_expected_20, 'AbsTol', 1e-3);
        end
        
        % Test maximum values for state variables
        function testMaxPerfectConditionValues(testCase)
  
            % Initial parameters
            fT = 0.4; 
            velocity = 14.00;
            
            % Initialize values
            [x, t] = simulate.solve_hodgkin_huxley_ode(fT, velocity);
            
            % Calculate the maximum values of the state variables from the simulation
            max_n = max(x(2,:));
            max_m = max(x(3,:));
            min_h = min(x(4,:));
            
            % Verify that the maximum values match the expected, previously
            % measured, values.
            max_n_expected = 0.76654;
            max_m_expected = 0.99165;
            min_h_expected = 0.080746;
            
            % Verify the results are correct
            testCase.verifyEqual(max_n, max_n_expected, 'AbsTol', 1e-2);
            testCase.verifyEqual(max_m, max_m_expected, 'AbsTol', 1e-2);
            testCase.verifyEqual(min_h, min_h_expected, 'AbsTol', 1e-2);
        end
    end
end
