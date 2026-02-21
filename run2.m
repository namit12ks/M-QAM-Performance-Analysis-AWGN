% --- RUNNER SCRIPT: SImuProjet ---
% Fixed the Random Integer Parameter Name for R2025b
modelName = 'M_QAM';
if ~bdIsLoaded(modelName), open_system(modelName); end

% Force Normal Mode & Interpreted execution (macOS compiler bypass)
set_param(modelName, 'SimulationMode', 'normal');
allBlocks = find_system(modelName, 'Type', 'Block');
for b = 1:length(allBlocks)
    try set_param(allBlocks{b}, 'SimulateUsing', 'Interpreted execution'); catch; end
end

% --- Simulation Parameters ---
snr_dB = 0:1:60; % SNR range in dB
M_values = [4, 16, 64]; % QPSK, 16-QAM, 64-QAM
input_length = 3000; % Base length of random integer sequence
BER_results = zeros(length(M_values), length(snr_dB));

% --- Run Nested Loops ---
for m = 1:length(M_values)
    M = M_values(m);
    k = log2(M); % Bits per symbol
    fprintf('Simulating M = %d...\n', M);
    
    % Adjust input length to be a perfect multiple of k
    adjusted_length = floor(input_length / k) * k;
    
    % Update block parameters using your exact canvas names
    set_param([modelName '/64-QAM_TX'], 'M', num2str(M));
    set_param([modelName '/64-QAM_RX'], 'M', num2str(M));
    
    % --- FIXED PARAMETER HERE ---
    set_param([modelName '/Random Integer'], 'SetSize', num2str(M)); 
    set_param([modelName '/Random Integer'], 'SamplesPerFrame', num2str(adjusted_length));
    
    set_param([modelName '/Integer to Bit Converter'], 'nbits', num2str(k));
    set_param([modelName '/Bit to Integer Converter'], 'nbits', num2str(k));
    
    % --- DYNAMIC CONSTELLATION DIAGRAM FIX ---
    try
        refPoints = sprintf('qammod(0:%d, %d)', M-1, M);
        set_param([modelName '/Constellation Diagram'], 'ReferenceConstellation', refPoints);
    catch
        % Fallback for different naming
        set_param([modelName '/Constellation Diagram After'], 'ReferenceConstellation', refPoints);
    end
    
    % Power Math
    average_power = 100;
    signal_power = average_power * ((2/3) * (M - 1));
    
    for i = 1:length(snr_dB)
        % Calculate Variance based on current SNR
        variance = signal_power / (10^(snr_dB(i) / 10));
        set_param([modelName '/var_input'], 'Value', num2str(variance));
        
        % Run the simulation
        simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
        
        % Robust R2025b data extraction
        if isprop(simOut, 'Bit_Error_Rate')
            data = simOut.Bit_Error_Rate;
        elseif evalin('base', 'exist(''Bit_Error_Rate'',''var'')')
            data = evalin('base', 'Bit_Error_Rate');
        else
            error('Bit_Error_Rate not found in workspace.');
        end
        
        % Extract BER (first element of the vector)
        BER_results(m, i) = data(1); 
    end
end

% --- Plotting ---
figure('Color', 'w');
for m = 1:length(M_values)
    semilogy(snr_dB, BER_results(m, :), '-o', 'LineWidth', 1.5, 'DisplayName', sprintf('%d-QAM', M_values(m)));
    hold on;
end
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('Adaptive M-QAM Performance in AWGN');
legend('show');