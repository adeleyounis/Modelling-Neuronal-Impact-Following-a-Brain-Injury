% Creating a linear combination of the results 
x1 = [10; 14; 20]; % Independent variable 1
x2 = [10; 50; 90]; % Independent variable 2
y = [-18.9856; -59.4437; -96.642]; % Dependent variable


% Normalize x1
x1_min = min(x1);
x1_max = max(x1);
x1_normalized = (x1 - x1_min) / (x1_max - x1_min);

% Normalize x2
x2_min = min(x2);
x2_max = max(x2);
x2_normalized = (x2 - x2_min) / (x2_max - x2_min);

% Initialize Parameters
beta0 = 0; % Initial value for beta0
beta1 = 0; % Initial value for beta1
beta2 = 0; % Initial value for beta2

% Hyperparameters
learning_rate = 0.0001 % Learning rate
epochs = 700; % Number of iterations

% Gradient Descent
mse_history = zeros(epochs, 1); % To store MSE values across iterations
for epoch = 1:epochs
    % Compute Predictions
    predictions = beta0 + (beta1 * x1_normalized) + (beta2 * x2_normalized);
    
    % Compute MSE
    mse = mean((y - predictions) .^ 2);
    mse_history(epoch) = mse; % Store MSE value
    
    % Compute Gradients
    gradient_beta0 = (-2 / length(x1)) * sum(y - predictions);
    gradient_beta1 = (-2 / length(x1)) * sum(x1 .* (y - predictions));
    gradient_beta2 = (-2 / length(x2)) * sum(x2 .* (y - predictions));
    
    % Update Parameters
    beta0 = beta0 - learning_rate * gradient_beta0;
    beta1 = beta1 - learning_rate * gradient_beta1;
    beta2 = beta2 - learning_rate * gradient_beta2;
end

% Plot MSE across iterations
figure;
plot(1:epochs, mse_history);
xlabel('Epoch');
ylabel('MSE');
title('Convergence of Gradient Descent');

disp(['Coefficient beta0:', num2str(beta0)]);
disp(['Coefficient beta1:', num2str(beta1)]);
disp(['Coefficient beta2:', num2str(beta2)]);
