classdef calculate_voltage_shift
    methods(Static)  
        function [voltage_shift, acceleration_val, HIC_val]  = get_voltage_shift(velocity, time, duration)
            % Define thresholds for HIC and corresponding voltage shifts
           
            HIC_thresholds = [1000, 1500, 2000];
            voltage_shifts = [10, 14, 20];

            acceleration = @(time) ((velocity * 100) ./ ((time - 93).^2 + 18));
            acceleration_instant = (velocity * 100) ./ ((time - 93).^2 + 18);
            lower_bound = time;
            upper_bound = time + duration;
            acceleration_integral_val = integral(acceleration, lower_bound, upper_bound);
    
            % Calculate HIC value
            H = ((1 / duration) * acceleration_integral_val) ^ 2.5;
            HIC = duration * H;

            % Determine the level of concussion severity based on HIC value
            if HIC < HIC_thresholds(1)
                % Minimal trauma
                voltage_shift = 0;
            elseif HIC >= HIC_thresholds(1) && HIC < HIC_thresholds(2)
                % Mild concussion
                voltage_shift = voltage_shifts(1);
            elseif HIC >= HIC_thresholds(2) && HIC < HIC_thresholds(3)
                % Moderate concussion
                voltage_shift = voltage_shifts(2);
            else
                % Severe concussion
                voltage_shift = voltage_shifts(3);
            end

            % Return values
            acceleration_val = acceleration_instant;
            HIC_val = HIC;
        end
    end
end

