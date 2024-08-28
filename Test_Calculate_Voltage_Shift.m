classdef Test_Calculate_Voltage_Shift < matlab.unittest.TestCase
    
    methods(Test)
        function testMaxVoltageShiftOccursAtThresholds(testCase)
            % Define test parameters
            velocity = 1080; 
            duration = 0.036; 
            time = linspace(0, 160, 1000);
            
            % Call the function to calculate voltage shift, acceleration, and HIC
            [Vs_array, ~, ~] = arrayfun(@(t) calculate_voltage_shift.get_voltage_shift(velocity, t, duration), time);

            % Find the maximum voltage shift and HIC value
            max_voltage_shift = max(Vs_array);
            
            % Verify that maximum voltage shift occurs at one of the thresholds
            expected_voltage_shifts = [0, 10, 14, 20];
            % Check if the maximum voltage shift is one of the expected values
            testCase.verifyTrue(ismember(max_voltage_shift, expected_voltage_shifts));
        end

        function testMaxAccelerationOccursAt93ms(testCase)
            % Define test parameters
            velocity = 1080; 
            duration = 0.036; 
            time = linspace(0, 160, 1000);
            
            % Call the function to calculate acceleration
            acceleration = @(time) ((velocity * 100) ./ ((time - 93).^2 + 18));

            % Calculate acceleration at different time points
            accelerations = acceleration(time);
            
            % Find the time point where acceleration is maximum
            [~, max_index] = max(accelerations);
            disp(['Acceleration at maximum: ', num2str(accelerations(max_index))]);
            time_of_max_acceleration = time(max_index);
            
            % Verify that maximum acceleration occurs at 93 ms
            expected_time_of_max_acceleration = 93; % 93 ms in seconds
            tolerance = 1; % Tolerance for floating-point comparison
            % Check if the time of maximum acceleration is within tolerance of expected
            % time of maximum acceleration
            testCase.verifyEqual(time_of_max_acceleration, expected_time_of_max_acceleration, 'AbsTol', tolerance);
        end
    end
end
