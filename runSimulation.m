


modelName = 'M_QAM';

if ~bdIsLoaded(modelName), open_system(modelName); end


set_param(modelName, 'SimulationMode', 'normal');
allBlocks = find_system(modelName, 'Type', 'Block');

for b = 1:length(allBlocks)

    try set_param(allBlocks{b}, 'SimulateUsing', 'Interpreted execution'); catch; end
end


            snr_dB = 0:1:60; % SNR range in dB
            
            M_values = [4, 16, 64]; 
            
            input_length = 3000; 
            
            BER_results = zeros(length(M_values), length(snr_dB));




% loops for diff M values ( 3 loops here)
for m = 1:length(M_values)

        M = M_values(m);
        k = log2(M);     % Bits per symbol
        fprintf('Simulating M = %d...\n', M);
        
       
        adjusted_length = floor(input_length / k) * k;
   
            set_param([modelName '/64-QAM_TX'], 'M', num2str(M));

            set_param([modelName '/64-QAM_RX'], 'M', num2str(M));
    
        
            set_param([modelName '/Random Integer'], 'SetSize', num2str(M)); 
        
             set_param([modelName '/Random Integer'], 'SamplesPerFrame', num2str(adjusted_length));
    
             set_param([modelName '/Integer to Bit Converter'], 'nbits', num2str(k));
    
            set_param([modelName '/Bit to Integer Converter'], 'nbits', num2str(k));
    


           % constellation diag

           try
    
            refPoints = sprintf('qammod(0:%d, %d)', M-1, M);
    
            set_param([modelName '/Constellation Diagram'], 'ReferenceConstellation', refPoints);
    
            catch
            
            set_param([modelName '/Constellation Diagram After'], 'ReferenceConstellation', refPoints);
            end
        
        

            average_power = 100;
            signal_power = average_power * ((2/3) * (M - 1));
            


            for i = 1:length(snr_dB)


                % Calculate Variance from SNR

                variance = signal_power / (10^(snr_dB(i) / 10));

                set_param([modelName '/var_input'], 'Value', num2str(variance));
                
                % Run  simulation

                simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
                
                
                if isprop(simOut, 'Bit_Error_Rate')
                    data = simOut.Bit_Error_Rate;

                elseif evalin('base', 'exist(''Bit_Error_Rate'',''var'')')
                    data = evalin('base', 'Bit_Error_Rate');

                else
                    error('Bit_Error_Rate not found in workspace.');

                end
                
                
                BER_results(m, i) = data(1); 
            end
end


        % plot

        figure('Color', 'b');

        for m = 1:length(M_values)

            semilogy(snr_dB, BER_results(m, :), '-o', 'LineWidth', 1.5, 'DisplayName', sprintf('%d-QAM', M_values(m)));

            hold on;
        end

            grid on;
        
                xlabel('SNR (dB)');
        
                ylabel('Bit Error Rate (BER)');

            title('Adaptive M-QAM Performance in AWGN');

            legend('show');



