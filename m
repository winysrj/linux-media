Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n2.bullet.mail.mud.yahoo.com ([209.191.127.222])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rvf16@yahoo.gr>) id 1KTY9q-0003aF-Fn
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 10:26:12 +0200
Message-ID: <48A3EBAE.5050204@yahoo.gr>
Date: Thu, 14 Aug 2008 11:24:14 +0300
From: rvf16 <rvf16@yahoo.gr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] CX23885 based AVerMedia AVerTV Hybrid Express Slim tv
 card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1221715405=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1221715405==
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit

Hello.

After viewing the oem22.inf file which appears to be the driver for 
Vista i have come across the following words which might help you define 
tuner or demodulator :
HC81R HC81_C (this is the AVerTV Hybrid Express Slim model)
XC3028 + Afa9013
NT.6
XCeive_L+FM+Afa9013
CX885
oem22.inf:Models.NT.6:CX23885.HC81_C:1.12.0.76:pci\ven_14f1&dev_8852&subsys_d9391461 
(this is the driver)
A885VCap
cx416enc
CX88

this was in another .inf file :
bda

Inside the oem22.inf there was a sector regarding my model which follows :
;----------------------------------------------------------------------------------------- 

; Model HC81_C
;----------------------------------------------------------------------------------------- 

[CX23885.HC81_C]
Include=    ks.inf, kscaptur.inf, wdmaudio.inf, bda.inf
Needs=      KS.Registration,KSCAPTUR.Registration.NT, 
WDMAUDIO.Registration, BDA.Registration,bda.Installation.NT
AddReg=     CX885.AddReg, HC81_C.AddReg, AVerXBAR_B.AddReg, 
CX23885.Xceive.AddReg, AVerXceiveL.AddReg, CXTS.AddReg
CopyFiles=  CX885.CopyDrivers,DSFilters.CopyFiles
RegisterDlls=DSFilters.RegDLL
 
[CX23885.HC81_C.NT]
Include=    ks.inf, kscaptur.inf, wdmaudio.inf, bda.inf
Needs=      KS.Registration.NT,KSCAPTUR.Registration.NT, 
WDMAUDIO.Registration, BDA.Registration,bda.Installation.NT
AddReg=     CX885.AddReg, HC81_C.AddReg, AVerXBAR_B.AddReg, 
CX23885.Xceive.AddReg, AVerXceiveL.AddReg, CXTS.AddReg
CopyFiles=  CX885.CopyDrivers,DSFilters.CopyFiles
RegisterDlls=DSFilters.RegDLL
 
 
[CX23885.HC81_C.Interfaces]
Needs=VID.Interfaces
 
[CX23885.HC81_C.NT.Interfaces]
Needs=VID.Interfaces
 
[CX23885.HC81_C.Services]
AddService = CXSONORA,2,VID.ServiceInstall
 
[CX23885.HC81_C.NT.Services]
AddService = CXSONORA,2,VID.ServiceInstall
 
[HC81_C.AddReg]
;Copy protection method enforced by driver
HKR,"DriverData","CpMethod",0x00010001, 0x04, 0x00, 0x00, 0x00
 
; these registry keys for 3D comb filter enable
; use3DComb entry allows the use of the 3D Comb feature, currently 
connected to the color enable
; property of the capture filter
HKR,"DriverData","Use3DComb",0x00010001, 0x00,0x00,0x00,0x00
 
; this entry sets the initial state of the 3D comb enable when use3DComb 
is specified
HKR,"DriverData","Enable3DComb",0x00010001, 0x00,0x00,0x00,0x00
 
; The following entries just for testing BDA driver
; No demod for now
HKR,"DriverData","TunerModel",0x00010001, 0x03,0x00,0x00,0x00
 
;Enable TS capture and BDA filter registration
HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x03, 0x00, 0x00, 0x00
HKR,"DriverData","DemodI2CAddress",0x00010001, 0x38, 0x00, 0x00, 0x00
 
; these registry keys for TS filter
; DebugTS entry forces creation of TS capture filter without a demod
;HKR,"DriverData","DebugTS",0x00010001, 0x01,0x00,0x00,0x00
; Next line enables the software TS packetizer
;HKR,"DriverData","dwIsTSStream",0x00010001,0x01,0x00,0x00,0x00
 
; this registry keys for the FixNMI option which takes care of the BSODs 
in the 
; ICH6/7 chipsets
HKR,"DriverData","FixNMIBit",0x00010001, 0x00,0x00,0x00,0x00
 
;IR Support
HKR,"DriverData","EnableIR",0x00010001, 0x00, 0x00, 0x00, 0x00
;NEC standard
HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00
 
; GPIO Pin values 
; IMPORTANT !!! if any GPIO is not used - just delete the corresponding 
entry !!!
HKR,"DriverData","tuner_reset_gpio_bit",  0x00010001, 0x02, 0x00, 0x00, 
0x00
HKR,"DriverData","demod_reset_gpio_bit",  0x00010001, 0x00, 0x00, 0x00, 
0x00
HKR,"DriverData","demod_sleep_gpio_bit",  0x00010001, 0x01, 0x00, 0x00, 
0x00
 
; Back Panel = 0x00, Front Panel = 0x01
HKR,"DriverData","comp_select_panel", 0x00010001, 0x00, 0x00, 0x00, 0x00
 
;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
HKR,"DriverData","DemodTransferMode",0x00010001, 0x00, 0x00, 0x00, 0x00
 
;BoardType HC81_C= 0x1E
HKR,"DriverData","BoardType",0x00010001, 0x1e, 0x00, 0x00, 0x00
 
;Init_I2C_Check, 0: don't chack,so driver will register all needed filters.
HKR,"DriverData","Init_I2C_Check",0x00010001, 0x01, 0x00, 0x00, 0x00

I tried out i2cdetect with the following resaults :
[root@XXX]# i2cdetect -l
i2c-0   smbus           SMBus I801 adapter at 10c0              SMBus 
adapter
i2c-1   i2c             cx23885[0]                              I2C adapter
i2c-2   i2c             cx23885[0]                              I2C adapter
i2c-3   i2c             cx23885[0]                              I2C adapter
[root@XXX]# man i2cdetect
[root@XXX]# i2cdetect 1
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-1.
I will probe address range 0x03-0x77.
Continue? [Y/n] y              
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: UU 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        
[root@XXX]# i2cdetect 2
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-2.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        
[root@XXX]# i2cdetect 3
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-3.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- 44 -- -- -- -- -- -- -- 4c -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        


I have no idea what i am doing and i am this close to opening the 
express card case but the loss of 2 years warranty and the possibility 
of damaging this 100¤ card during the process is holding me back.

I should mention that, for the time being, i am mainly interested in 
analog tv and fm radio as there are only 3 digital channels around here 
which require a decoder.

Thank you.
Regards.



--===============1221715405==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1221715405==--
