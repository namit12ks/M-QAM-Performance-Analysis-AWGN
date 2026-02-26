
#  M-QAM Performance Analysis in AWGN Channels


##  Project Overview
This project models, simulates, and analyzes an M-Tuple Quadrature Amplitude Modulation (M-QAM) digital communication system using **MATLAB R2025b** and **Simulink**. 

The simulation evaluates the fundamental trade-off between spectral efficiency and Bit Error Rate (BER) across varying Signal-to-Noise Ratios (SNR). By programmatically switching between **4-QAM (QPSK), 16-QAM, and 64-QAM**, it demonstrates how modern telecommunication networks need to adapt to fluctuating channel conditions to maintain reliable data links.

---

##  System Model

The data pipeline mirrors a standard real-world baseband transceiver. 

![Simulink Architecture](Simulink_Model.png)

* **Transmitter:** Random integer generation, bit-conversion, and Rectangular M-QAM baseband modulation.
* **Channel:** Additive White Gaussian Noise (AWGN), with variance dynamically controlled by a MATLAB control script to simulate SNR sweeps (0 dB to 60 dB).
* **Receiver:** Hard-decision demodulation, integer-conversion, and dual Error Rate Calculation (BER & SER).


---

##  Visualizing Channel Noise ( Signal Constellation )

**[ Watch the Constellation & SNR Sweep Simulation](Gif_.mp4)**

* **The SNR Effect:** As the simulation sweeps from low to high SNR, the heavily dispersed signal clouds rapidly condense into tight, distinct clusters around the ideal reference crosses, drastically reducing the probability of decision errors.

---

## BER vs. SNR Waterfall Curves

The core performance analysis is captured in the comparative BER waterfall plots extracted directly from the Simulink workspace.

![BER vs SNR Waterfall Curve](BER_vs_SNR.png)

###  Takeaways:
1.  **4-QAM (QPSK) - Maximum Robustness:** Achieves a near-zero Bit Error Rate at very low SNR. The massive Euclidean distance between the 4 symbols requires extreme noise to cause a bit error, at the cost of the lowest spectral efficiency (2 bits/symbol).
2.  **64-QAM - Maximum Throughput:** Triples the data rate (6 bits/symbol) but requires a vastly superior channel. Packing 64 points into the same average signal power drastically shrinks the distance between symbols, making it highly susceptible to minor noise fluctuations.

### REAL-WORLD CHALLENGE: MULTIPATH PROPAGATION AND NEED FOR ADAPTIVE MODULATION AND CODING (AMC):

In a practical wireless environment :-
 1. Due to multipath propagation, the transmitted signal undergoes severe amplitude attenuation and phase shifts, causing deep, unpredictable channel fades **Rayleigh Fading Channel**. 
2.Due to  MOBILITY of USER Wireless and multipath propagation, communication channels experience unpredictable fluctuations in Signal-to-Noise Ratio (SNR). 

To maintain a reliable link in this environment,a two-step approach at the receiver:
1. **Channel Equalization:** Before demodulation can occur, the receiver must estimate the Channel State Information (CSI). By applying an equalizer (such as Zero-Forcing or MMSE), the system mathematically reverses the phase and amplitude distortions introduced by the Rayleigh channel, restoring the constellation points to their proper quadrants.
2. **Adaptive Modulation and Coding (AMC):** Even after equalization, the effective Signal-to-Noise Ratio (SNR) fluctuates wildly as the user moves. AMC dynamically reacts to this changing SNR feedback. It downshifts to a robust scheme like 4-QAM during deep fades to prevent dropped packets, and upshifts to a dense scheme like 64-QAM during high-SNR peaks to maximize spectral efficiency and throughput.

 ### Related Implementation:
 To see this  Rayleigh channel modeling and dynamic modulation switching—check out my recent simulation:
 
[**QAM Adaptive Modulation and Coding (AMC) over Rayleigh Fading**](https://github.com/namit12ks/QAM-AMC-over-Rayleigh-Fading)


---

##  How to Run
1.  Clone this repository and open MATLAB (R2025b or later recommended).
2.  keep `M_QAM.slx` and `runSimulation.m`  in same directory.
3.  Execute `runSimulation.m` in Matlab.

## By
**Namit Kumar Sahu** : 230102059  
B.Tech in Electronics and Communication Engineering  
Indian Institute of Technology Guwahati (IITG)
