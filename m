Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq2.gn.mail.iss.as9143.net ([212.54.34.165]:54204 "EHLO
	smtpq2.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab3L3KqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 05:46:13 -0500
Received: from [212.54.34.136] (helo=smtp5.gn.mail.iss.as9143.net)
	by smtpq2.gn.mail.iss.as9143.net with esmtp (Exim 4.71)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1VxZoK-00056S-KI
	for linux-media@vger.kernel.org; Mon, 30 Dec 2013 11:11:00 +0100
Received: from 5ed67808.cm-7-7b.dynamic.ziggo.nl ([94.214.120.8] helo=imail.office.romunt.nl)
	by smtp5.gn.mail.iss.as9143.net with esmtp (Exim 4.71)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1VxZoK-0002vb-5j
	for linux-media@vger.kernel.org; Mon, 30 Dec 2013 11:11:00 +0100
Received: from [192.168.1.15] (cenedra.office.romunt.nl [192.168.1.15])
	by imail.office.romunt.nl (8.14.4/8.14.4/Debian-4) with ESMTP id rBUAAvU6023878
	for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 11:10:58 +0100
Message-ID: <52C146AC.6050208@grumpydevil.homelinux.org>
Date: Mon, 30 Dec 2013 11:10:52 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Digital Devices Cine S2 V6.5, PCIe, Dual
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear List,

I have a DVB card as mentioned in the subject

03:00.0 Multimedia controller [0480]: Device [dd01:0003]
         Subsystem: Device [dd01:0021]
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at f0900000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [90] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, 
Latency L0 unlimited, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range A, TimeoutDis+
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [100 v1] Vendor Specific Information: ID=0000 
Rev=0 Len=00c <?>
         Kernel driver in use: DDBridge
         Kernel modules: ddbridge

Kernel 3.12.3 sees the device, but does not enable it. Only the ddbridge 
driver is loaded, none of the tuner/demod drivers:

root@mythtest:~# lsmod
Module                  Size  Used by
ddbridge               17766  0

Nor, judging from dmesg output, is the firmware loaded:
[    1.624996] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 
Digital Devices GmbH
[    1.652565] pci 0000:01:19.0: enabling device (0000 -> 0002)
[    1.677601] DDBridge driver detected: Digital Devices PCIe bridge
[    1.683598] HW ffffffff FW ffffffff
[    2.160410] Adding 2097148k swap on /dev/sda3.  Priority:-1 extents:1 
across:2097148k
[    2.190386] Switched to clocksource tsc


What is the best kernel to have this dvb-card working?
Or, alternatively, the best combination of kernel version and 
out-of-kernel stack?


Thanks,


Rudy



