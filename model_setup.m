%% Model Setup
% This script configures every simulation or implementation model that uses
% the modulator, receiver, DOA estimator or beamformer. It outputs the
% workspace environment variables used in these models.
%
% This script may be opened as a MATLAB Live Script for better
% visualisation.

clear

%% Simulation
% These variables are used in the simulation models as they describe the
% movement and orientation of the User Equipment and the channel's
% conditions. Some of these parameters may be used to make the real
% implementation resemble the simulation in the UE tracking test.

% User Equipment
UE.az = 15;                 % Azimuth, UE orientation relative to the BS
UE.el = 0;                  % Elevation, UE inclination relative to the BS
UE.max_ang = 45;            % Maximum location angle relative to the BS
UE.movement_freq = 0.1;     % Movement frequency in Hz

channel.snr = 20;           % Channel's Signal-to-Noise-Ratio

%% Real Implementation
% The following variables are used only the real implementation, assuming
% there is a Software-Defined Radio unit being used. They mostly describe
% the parameters used by the SDR and assertions given by the the SDR's
% specifications. Similar to the Simulation varaibles, some of these
% variables are used by the simulation model to resemble the real
% implementation.

SDR.samplerate = 1e6;               % Baseband sampling rate in sps
SDR.tx_gain = [1 1] * 60;           % TX front-end gain
SDR.rx_gain = [1 1] * 20;           % RX front-end gain

% USB Parameters for the SDR
SDR.stream.n_buffers = 256;
SDR.stream.n_transfers = 4;
SDR.stream.buffer_size = 1024 * 20;
SDR.stream.timeout = 1000;


%% Subsystem Parameters
% The remaining lines describe the subsystem's parameters. These are used
% in the Modulator, Receiver, DOA estimators and both beamformers.


system.step = 0.01;         % Model time-step in seconds
system.freq = 890e6;        % System's carrier frequency in Hz
system.n_antennas = 2;      % Number of antenna elements in the antenna arrays
system.samples_per_step = SDR.samplerate * system.step; % Samples per time-step

% Carrier signal's wavelength
system.lambda = physconst('Lightspeed')/system.freq;

% Preamble and message bit sequences
frame.preamble.bits = repmat([1 1 0 0 1 0 1 0 1 0]',4 ,1);
frame.message.bits = repmat([1 0 1 1 0 0 1 0 1 1 1 0 0 0 0 1 1 0 1 0]', 8,1);

% System's modulation scheme and reference constellation diagram
system.mod = comm.PSKModulator('ModulationOrder', 4,'BitInput', true, ...
 'PhaseOffset', pi/4);
system.constellation = constellation(system.mod);

% Modulated symbols for the preamble, message and whole frame sequences
frame.preamble.symbols = system.mod(frame.preamble.bits);
frame.message.symbols = system.mod(frame.message.bits);
frame.bits = [frame.preamble.bits' frame.message.bits']';
frame.symbols = system.mod(frame.bits);
assert(mod(length(frame.bits), log2(system.mod.ModulationOrder)) == 0, ...
    'Frame Error: Length(preamble + message) must be a factor of the mod order')

% Modulator: Raised Cosine Filter
% Interpolation factor given by the desired samples per step and input
% sequence lenght
system.tx.rc.interpolation = system.samples_per_step/length(frame.symbols);
system.tx.rc.rolloff = 0.3; % Bandwith Excess factor
system.tx.rc.span = 6; % Filter span

% Receiver: Raised Cosine Filter
system.rx.rc.sps = system.tx.rc.interpolation;  % Samples per symbol
system.rx.rc.rolloff = system.tx.rc.rolloff;    % Bandwidth Excess factor
system.rx.rc.span = system.tx.rc.span;          % Filter Span
system.rx.rc.decimation = 10;                   % Decimation factor (Ndec < Nint)

% Receiver: Automatic Gain Controller
system.rx.agc.step = 0.01;                      % Time-Step in seconds
system.rx.agc.output_power = 1;                 % Desired output power
system.rx.agc.average_length = 100;             % Average length
system.rx.agc.max_power = 100;                  % Max input power

% Receiver: Carrier Synchronisation
system.rx.cs.sps = system.rx.rc.sps/system.rx.rc.decimation; % Samples per symbol
system.rx.cs.damp = 0.7;                        % Damping factor
system.rx.cs.bandwidth = 0.001;                 % Normalised Bandwidth

%Receiver: Symbol Synchronisation
system.rx.ss.sps = system.rx.rc.sps/system.rx.rc.decimation; % Samples per symbol
system.rx.ss.damp = 1;                          % Damping factor
system.rx.ss.bandwidth = 0.01;                  % Normalised Bandwidth
system.rx.ss.gain = 2.7;                        % Detection gain

% Receiver: Preamble Detector
% The preamble detector is set to symbol mode
system.rx.pd.preamble = frame.preamble.symbols; % Preamble sequence symbols
system.rx.pd.threshold = 14;                    % Detection threshold (arbitrary)

% Receiver: Frame Synchronisation
% Preamble and frame lengths
system.rx.fs.preamble_length = length(frame.preamble.symbols); 
system.rx.fs.frame_length = length(frame.preamble.symbols) + ...
 length(frame.message.symbols);

% Modulator & Receiver: Scrambler
system.scramble.polynomial = [1 1 1 0 1];       % Polynomial
system.scramble.initial = [0 0 0 0];            % Initial condition

% Beamformers & DOA estimation: Antenna Array
AntennaArray = phased.ULA('NumElements', system.n_antennas, ...
'ArrayAxis','y');
AntennaArray.ElementSpacing = system.lambda/2;  % Element distancing
AntennaArray.Taper = ones(1,system.n_antennas).';

% Create an isotropic antenna element
Elem = phased.IsotropicAntennaElement;
Elem.FrequencyRange = [0 system.freq];
AntennaArray.Element = Elem;

%% Hardware Assertions
% This lines validate whether the introduced parameters comply with the
% SDR's specifications.

assert(SDR.samplerate > 550e3, ...
    'SDR Error: Samplerate must be greater than 550 ksps')
assert(min(SDR.tx_gain) >= -10 && max(SDR.tx_gain) <= 60, ...
    'SDR Error: TX gain must be between -10 and 60 dB')
assert(min(SDR.rx_gain) >= -10 && max(SDR.rx_gain) <= 90, ...
    'SDR Error: TX gain must be between -10 and 90 dB')
assert(SDR.stream.n_buffers > 2 * SDR.stream.n_transfers, ...
    'SDR Error: #buffers must be > 2 * #transfers')
assert(system.freq > 70e6, ...
    'SDR Error: Carrier frequency must be greater than 70 MHz')
