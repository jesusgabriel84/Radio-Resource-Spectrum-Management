<!-- Radio Resource and Spectrum Management -->
## Radio Resource and Spectrum Management
In Mobile Communication Systems, the radio spectrum is a limited natural resource which is shared between systems and UEs, for this reason, the radio resources must be allocated properly and scheduled according to the network conditions.

This repository shows some of the codes I implemented for the course Radio Resource Spectrum Management at Aalto Univeristy and is focused on the problems related to sharing of radio resources between users within single system (Radio Resource Management) and sharing of the spectrum between systems (Spectrum Management), covering the following topics:


* [Frequency band selection](frequency-selection)
	This code analyzes two frequency selection strategies using Montecarlo simulation with 200 snapshots in the scenario where there are four frequency bands (2.6 GHz, 2.1 GHz, 1.8 GHz and 900 MHz).

* [Scheduling and Fairness](scheduling-and-fairness) 
	In this code the max-min fair scheduling and the proportional fair scheduling as well as the Nash Bargaining resource allocation method are analyzed.

* [Ultra Dense Networks](UDN)
	In a simulation grid of 45 base stations multiple UEs are distributed randomly and the GADIA (Greedy Asychronous Distributed Interference Avoidance) algorithm is implemented to perform the scheduling of the users in each base station.

* [NB-IoT scheduling techniques](nb-iot-scheduling)
	A literature survey on NB-IoT scheduling techniques, challenges and potential solutions. The aim of this work is to explore the various scheduling techniques proposed in NB-IoT scenarios for both uplink and downlink channel along with existing challenges and potential way out.



### Built With
* [Matlab2018](https://se.mathworks.com/products/matlab.html)