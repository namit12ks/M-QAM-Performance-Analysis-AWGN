# Adaptive M-QAM Performance Analysis in AWGN Channels

**Developed for Digital Communications / Telecommunications R&D Portfolio**

##  Project Overview
This project models, simulates, and analyzes an Adaptive Quadrature Amplitude Modulation (M-QAM) digital communication system using **MATLAB R2025b** and **Simulink**. 

The core objective is to evaluate the trade-offs between spectral efficiency (data rate) and Bit Error Rate (BER) across varying Signal-to-Noise Ratios (SNR). By dynamically switching between **4-QAM (QPSK), 16-QAM, and 64-QAM**, the project demonstrates how modern telecommunication networks (like 4G/5G) adapt to fluctuating channel conditions to maintain reliable data links.

---

##  System Architecture

The data pipeline was constructed in Simulink to accurately mirror a real-world baseband transceiver. 
* Baseband Transceiver Architecture engineered in Simulink.*
![Simulink Architecture](Simulink_Model.png)


### Key Components:
* **Transmitter:** A Random Integer Generator creates the data source, strictly converted into a binary stream via an `Integer to Bit Converter` before being mapped by a Rectangular QAM Modulator. 
* **Channel:** An Additive White Gaussian Noise (AWGN) channel simulates atmospheric/environmental interference. The noise variance is left as an open input port to be dynamically controlled by the MATLAB script.
* **Receiver:** A Rectangular QAM Demodulator utilizes Hard Decision decoding to estimate the received symbols, which are then converted back to integers.
* **Metrics Verification:** Dual `Error Rate Calculation` blocks capture both the Symbol Error Rate (SER) and Bit Error Rate (BER), pushing the arrays directly to the MATLAB workspace for analysis.

---

##  Algorithmic Control & Simulation Logic

A custom MATLAB script (`runSimulation.m`) acts as the "intelligent" controller for the Simulink model, executing a nested-loop simulation with several specific engineering optimizations:

1. **Automated Variance Math:** The script mathematically translates the target SNR (sweeping from 0 dB to 60 dB) into an absolute noise variance value based on the specific average signal power of the current M-QAM scheme.
2. **Dynamic Constellation Scaling:** As the loop shifts the modulation order $M$, the script automatically recalculates the spatial boundaries and ideal mathematical reference points (`qammod`), ensuring the visualization scales perfectly.
3. **macOS Compiler Bypass:** Standard R2025b C-MEX compiler errors on macOS were bypassed by programmatically forcing all Simulink blocks into `Interpreted execution` and setting the simulation mode to `Normal`.

---

##  Visualizing the Channel (Constellation Dynamics)

To truly understand the impact of channel noise, the project includes a real-time visualization of the Constellation Diagram as both the modulation order ($M$) and the Signal-to-Noise Ratio (SNR) increase.

* 64-QAM constellation captured mid-simulation. The yellow dots represent received symbols scattered by AWGN, while the red crosses denote the ideal mathematical decision points.*
![64-QAM Constellation](Screenshot%202026-02-21%20at%2011.25.33%20PM.png)

**[🎥 Watch the full Constellation SNR Sweep Video Here](link_to_your_video.mp4)**

* **The SNR Effect:** As the simulation sweeps towards higher SNR values, the video demonstrates the noise variance shrinking. The heavily dispersed yellow clouds rapidly condense into tight, distinct clusters around the red reference crosses, drastically reducing the probability of decision errors.

---

##  Results: BER vs. SNR Waterfall Curves

The core performance analysis is captured in the comparative BER waterfall plots. 
*Simulated Bit Error Rate (BER) vs. SNR performance curves for M=4, 16, and 64.*
![BER vs SNR Waterfall Curve](BER_vs_SNR.png)


### Theoretical Analysis & Trade-offs:
1. **4-QAM (QPSK) - Maximum Robustness:**
   * Achieves a near-zero Bit Error Rate at very low SNR. With only 4 points on the grid, the Euclidean distance between symbols is massive, requiring extreme noise to cause a bit error. 
   * **Trade-off:** Lowest spectral efficiency (2 bits/symbol).
2. **64-QAM - Maximum Throughput:**
   * Triples the data rate (6 bits/symbol) but requires vastly superior channel quality. Because 64 points are packed into the same average signal power, the distance between symbols shrinks drastically, making it highly susceptible to even minor noise fluctuations (as seen by the curve shifting far to the right).
3. **The "Adaptive" Conclusion:**
   * A static network is inefficient. In real-world deployments (like those designed by C-DOT), a system monitors the SNR feedback. If a user has poor signal, it downshifts to 4-QAM to prevent dropped packets. If the user has a clear, high-SNR connection, it upshifts to 64-QAM to maximize download speeds.

---

## How to Run Locally
1. Clone this repository and open MATLAB (R2025b or later recommended).
2. Ensure both `M_QAM.slx` and `runSimulation.m` are in the same active directory.
3. Type `runSimulation` in the MATLAB Command Window to execute the simulation. 
4. The waterfall curve will generate automatically upon completion.
