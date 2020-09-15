## Simulations

This section holds the Simulink models used to validate the desgin and test the use-case of the beamforming system.
As mentioned in the root directory README, the model setup script must be executed first for any of these models to 
work, but some of this have constant parameters that are meant to be modified inside the Simulink environment. Many 
of the results of these systems are logged in Simulink's Data Inspector tool.

## Theoretical Radiation Pattern Generator
The file [_theoretical_pattern_gen.m_](Simulations/theoretical_pattern_gen.m) plots the magnitude radiation pattern 
of a beamformer system, either TX or RX. The input parameters are the weight vector, which size denotes the number 
of antenna elements in the beamforming system (e.g. `W = ones(1, 2)` or `W = [1 1]`; the other parameter is the 
steering angle, which can be set to a scalar (e.g. `steer = 30`) or to a vector to visualize the moving main lobe 
(e.g. `steer = linspace(-90, 90, 180)`).

## TX Beamformer
The file [_test_tx_bf.slx_](Simulations/test_tx_bf.slx) serves a similar purpose to the Theoretical Radiation Pattern 
Generator, but as a Simulink model using the developed subsystem. The pattern is plot in a XY graph, being the _x_ 
axis the angle in degrees and the _y_ axis the magnitude.

## RX Beamformer
The file [_test_rx_bf_slx](Simulations/test_rx_bf.slx) tests the receiving beamformer using the methodology described 
in the [report](Report.pdf). The model features two signal sources with different incidence angles relative to the 
receiving array, one of these signals is wanted, the other is interference noise. The signals are filtered uisng the 
RX beamforming algorith. The model logs the BER and EVM.

## Modulator and Receiver
The file [_test_modulator_receiver.slx_](Simulations/test_modulator_receiver.slx) consists of a regular communication 
system featuring a real-life like radio that transmits a IQ sequence and receives an impaired IQ signal. The subsystems
contain the following stages.

* Modulator
  1. Scrambler
  2. Preamble addition
  3. QPSK Modulation
  4. Raised Cosine Interpolation Filter
* Receiver
  1. Raised Cosine Decimation Filter
  2. Automatic Gain Controller
  3. Carrier Synchronisation
  4. Symbol Synchronisation
  5. Preamble Detector
  6. Frame Synchronisation
  7. Phase error correction
  8. Preamble removal
  9. QPSK Demodulation
  10. Descrambing

These subsystems are evaluated using the BER and EVM.

## User Equipment Tracking
The model in [_ue_tracking.slx_](Simulations/ue_tracking.slx) consists of all the subsystems described in the [report](Report.pdf) 
(Beamformers, DOA estimator, Modulator and Receiver) to make a beamforming systems capable of steering each device's
main lobe to optimally send or receive data in space. The assumptions and problem statement are shown in the 
[report](Report.pdf).
