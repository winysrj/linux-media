Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns2.station176.com ([203.194.196.208]:41807 "EHLO
	station176.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053Ab0GIE5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 00:57:48 -0400
Message-ID: <4C36AC40.9040306@kayosdesign.com>
Date: Fri, 09 Jul 2010 14:57:36 +1000
From: Dave Withnall <dave@kayosdesign.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Leadtek WinFast PxDVR3200 H scan issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I've aquired myself a /Leadtek WinFast PxDVR3200 H/ and am trying to get 
it working under Ubuntu 10.04.

It's now installed and showing up in the system. I've extracted the 
firmware and installed it as per 
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware

lspci -vv
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI 
Video and Audio Decoder (rev 03)
         Subsystem: LeadTek Research Inc. Device 6f39
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: Memory at fac00000 (64-bit, non-prefetchable) [size=2M]
         Capabilities: [40] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [90] Vital Product Data <?>
         Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [100] Advanced Error Reporting <?>
         Capabilities: [200] Virtual Channel <?>
         Kernel driver in use: cx23885
         Kernel modules: cx23885

However, when I try to scan for channels I get the following errors 
showing up in messages.

scan /usr/share/dvb/dvb-t/au-Brisbane
scanning /usr/share/dvb/dvb-t/au-Brisbane
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 585625000 1 2 9 3 1 2 0
 >>> tune to: 
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
....
etc

dmesg has the following errors repeated
[   61.354294] cx23885 0000:02:00.0: firmware: requesting xc3028-v27.fw
[   61.379255] xc2028 2-0061: Loading 80 firmware images from 
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   61.577772] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[   62.065878] xc2028 2-0061: i2c output error: rc = -5 (should be 64)
[   62.065886] xc2028 2-0061: -5 returned from send
[   62.065894] xc2028 2-0061: Error -22 while loading base firmware

Any assistance in helping out with getting this to work would be 
appreciated.

Regards,

Dave.

