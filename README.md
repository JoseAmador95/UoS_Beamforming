# User Equipment Tracking Beamforming Using a MIMO Software-Defined Radio
Repository for the models and code used in "UE Tracking Beamforming using a MIMO Software-Defined Radio" MSc project for the course
5G Mobile Communications and Intelligent Embedded Systems at the University of Sussex. The goals, methodology and testing procedures 
are described in the [report](Report.pdf).

The work done is divided into the following sections:
* Model setup script
* Simulations
  * Modulatior and Receiver simulation test model
  * TX Beamformer simulation test model
  * RX Beamformer simulation test model
  * Theoretical Radiation pattern generator
  * User Equipment tracking simulation
* Real Implementation
  * MIMO Interface for the BladeRF
  * MIMO SDR layout test model
  * User Equipment tracking model
* CAD
  * Fusion 360
  * STEP
* Report

## Model Setup Script
This file must be executed before any other as it contains the subsystem parameters for every model, either real or simulation. 
An brief explanation of these parameters and the used parameters for testing are described in the report document, but further 
information may be available in the Mathworks documentation for each Simulink block.

## Simulations
These Simulink systems were used to validate each subsystems performance (Beamformers, DOA estimator, modulator and receiver)
and to test the UE tracking capability of the system.

These model do require to run the model setup script before executing them; also, MATLAB's DSP, Communications and Phased-Array 
toolboxes are required.

## Real Implementation
These models are what the report describes as Hardware-in-the-Loop as they feature real hardware system within the Simulink 
environment. These models use the [MIMO version of the BladeRF MATLAB interface](https://github.com/JoseAmador95/BladeRF_MIMO), 
which repository is linked inside the directory. The MIMO interface for the BladeRF still have the same dependencies as the 
scripts provided by Nuand, so the [official tools](https://www.nuand.com/support/) are still required. Make sure to install and
add the MATLAB tools to the path. More info in the repository.

The models in this section are the testing scenario for the SDR unit and the real implementation of the UE tracking test, which
results are described in the report.

## CAD
The CAD files used for the antenna structure are available in this section, including a parametric design using Fusion 360 and 
a STEP version for it to be used with other CAD software.

