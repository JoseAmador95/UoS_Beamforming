## Real Implementation
These models use the subsystems described in the [report](Report.pdf) to achieve a real communication system using 
the Software Defined-Radio unit, being this [Nuand's Blade RF A4](https://www.nuand.com/bladerf-2-0-micro/). Both 
models in this section require the use of the MIMO interface for the BladeRF, coded especifically for this project. 
More info about the interface is avaiable in [its repository](https://github.com/JoseAmador95/BladeRF_MIMO).

## FM Retransmission Test
The model in [_test_sdr_mimo.slx_](Real_Implementation/test_sdr_mimo.slx) uses the MIMO subsystem to transmit the
IQ signals from a FM station to a higher section of the ISM band. The phase-shift difference between the IQ signals 
of both RX channels can be used to estimate the Direction of Arrival of the incoming signal. The model may also be set
to send an unbalanced sinusoidal IQ signal, to better visualise the phase-phase shift and the impact of the onboard
Automatic Gain Controller on the received IQ signal.

## Hardware-in-the-Loop Demonstration
The model in [_hil_demo.slx_](Real_Implementation/hil_demo.slx) serves as a the demo that uses both beamformers, 
modulator and receiver. The steering angles for both beamformers may be changed in run-time, for them to see how the
Direction of Departure affects the Direction of Arrival.

This model was used as the UE tracking in the [report](Report.pdf) as it features two antenna arrays, one for the
transmitting end and the other for the receiving end.
