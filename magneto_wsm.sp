length sims
.include '22nm_HP.pm'
*.hdl 'rram.va'
.hdl 'wsm.va'
.hdl 'cap.va'

.TEMP 25

.option measform = 3

.GLOBAL vdd 
.OPTION 
+ ARTIST=2
+ INGOLD=2
**+ PSF=2


*************************************************************************
**************************** Parameters *********************************

.unprotect  
.param thin  = 1.22e-9
.param thick = 1.85e-9
.param tox = thin 
.param vtK=0
.param width_r=0.025
.param width=0.1
.param sload = 4 
.param length = 0.01     


************************************ WSM Nanoribbon **********************

Mn1 out1 in1 0 0 nmos w=2*22nm  l=22nm tox = thick  vtK=0 
Mp1 out1 in1 vdd vdd pmos w=8*22nm  l=22nm  tox = thick vtK=0

x1  out1  in2  wsm temp=175 L=5e-4  wi=width_r L=length/3 $ NANOORIBBON 

Mn2 out2 in2 0 0 nmos w=8*22nm  l=4*22nm  tox = thick  vtK=0 
Mp2 out2 in2 vdd vdd pmos w=32*22nm  l=4*22nm  tox = thick vtK=0

x2  out2  c  wsm temp=175 L=5e-4   wi=width_r L=length/6 $ NANOORIBBON 
x3  c 0 cap_wsm W=width $ WIRE CAPACITANCE
x4  c  in3  wsm temp=175 L=5e-4   wi=width_r L=length/6 $ NANOORIBBON 

Mn3 out3 in3 0 0 nmos w=8*22nm  l=4*22nm   tox = thick  vtK=0 
Mp3 out3 in3 vdd vdd pmos w=32*22nm  l=4*22nm   tox = thick vtK=0

x5  out3  in4  wsm temp=175 L=5e-4  wi=width_r L=length/3 $ NANOORIBBON 
**x4  in2 0 cap_wsm $ WIRE CAPACITANCE

Mn4 out4 in4 0 0 nmos w=sload*2*22nm  l=sload*22nm  tox = thick  vtK=0 
Mp4 out4 in4 vdd vdd pmos w=sload*8*22nm  l=sload*22nm  tox = thick vtK=0



**I1 inp 0 100nA
V1 in1   0 pulse   0 1  1n 1p 1p 1n 2n
V2 vdd   0 1  
**V3 n2   0 1
.MEASURE tran rc_delay TRIG V(in1) VAL=0.5 TD =0n RISE=1 TARG V(out4) VAL=0.5 RISE=1
*.measure tran slew1 deriv V(out2) when V(out2)=0.9*V1 rise =1
*.measure tran slew2 deriv V(out2) when V(out2)=0.1*V1 rise =1
.MEASURE tran slew_time TRIG V(out4) VAL=0.1 RISE=1 TARG V(out4) VAL=0.9 RISE=1

**.print V(x3.C_out);
**.print V(x2.I_out);
**.print I1

.MEAS TRAN res1_wsm MAX V(x1.R_out)
.MEAS TRAN res2_wsm MAX V(x2.R_out) 
.MEAS TRAN res4_wsm MAX V(x4.R_out)
.MEAS TRAN res5_wsm MAX V(x5.R_out)
.MEAS TRAN cap_wsm MAX V(x3.C_out) 
**.MEAS TRAN cur_wsm MAX V(x2.I_out) FROM 1n to 50n

.tran   3p 100n SWEEP sload 4 40 4
**SWEEP length 0.001 0.01 0.001 
**SWEEP width_r 0.025 0.5 0.025


.end 

