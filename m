Return-path: <linux-media-owner@vger.kernel.org>
Received: from edernet.hu ([78.131.56.161]:60569 "EHLO mail.edernet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaKSIeN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 03:34:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.edernet.hu (Postfix) with ESMTP id 89EB511BA1C
	for <linux-media@vger.kernel.org>; Wed, 19 Nov 2014 09:28:37 +0100 (CET)
Received: from mail.edernet.hu ([127.0.0.1])
	by localhost (edernet.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MJ6hJn1eOI0M for <linux-media@vger.kernel.org>;
	Wed, 19 Nov 2014 09:28:32 +0100 (CET)
Received: from [10.0.8.101] (92-249-143-20.static.digikabel.hu [92.249.143.20])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: zseder@edernet.hu)
	by mail.edernet.hu (Postfix) with ESMTPSA id 4392D11BA1C
	for <linux-media@vger.kernel.org>; Wed, 19 Nov 2014 09:28:07 +0100 (CET)
Message-ID: <546C5494.4000908@edernet.hu>
Date: Wed, 19 Nov 2014 09:28:04 +0100
From: =?ISO-8859-2?Q?=C9der_Zsolt?= <zsolt.eder@edernet.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: SAA7164 firmware for Asus MyCinema
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I found at the site: 
http://www.linuxtv.org/wiki/index.php/ATSC_PCIe_Cards that if I have a 
TV-tuner card which is currently unsupported, you may help me how I can 
make workable this device.

I have an Asus MyCinema EHD3-100/NAQ/FM/AV/MCE RC dual TV-Tuner card 
with SAA7164 chipset.

My OS version is:

~# lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 14.04.1 LTS
Release:        14.04
Codename:       trusty

grep for saa7164:

~# dmesg | grep saa
[   12.564005] saa7164 driver loaded
[   12.564142] saa7164[0]: Your board isn't known (yet) to the driver.
[   12.564142] saa7164[0]: Try to pick one of the existing card configs via
[   12.564142] saa7164[0]: card=<n> insmod option.  Updating to the latest
[   12.564142] saa7164[0]: version might help as well.
[   12.564248] saa7164[0]: Here are valid choicesfor  the card=<n> 
insmod option:
[   12.564277] saa7164[0]:    card=0 -> Unknown
[   12.564295] saa7164[0]:    card=1 -> Generic Rev2
[   12.564315] saa7164[0]:    card=2 -> Generic Rev3
[   12.564334] saa7164[0]:    card=3 -> Hauppauge WinTV-HVR2250
[   12.564357] saa7164[0]:    card=4 -> Hauppauge WinTV-HVR2200
[   12.564380] saa7164[0]:    card=5 -> Hauppauge WinTV-HVR2200
[   12.564403] saa7164[0]:    card=6 -> Hauppauge WinTV-HVR2200
[   12.564427] saa7164[0]:    card=7 -> Hauppauge WinTV-HVR2250
[   12.564450] saa7164[0]:    card=8 -> Hauppauge WinTV-HVR2250
[   12.564473] saa7164[0]:    card=9 -> Hauppauge WinTV-HVR2200
[   12.564496] saa7164[0]:    card=10 -> Hauppauge WinTV-HVR2200
[   12.565287] CORE saa7164[0]: subsystem: 1043:48cb, board: Unknown 
[card=0,autodetected]
[   12.565291] saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 16, 
latency: 0, mmio: 0xfe400000
[   12.565302] saa7164_initdev() Unsupported board detected, registering 
without firmware


My TV-Tuner detected parameters:

~# lspci -vvv
...
03:00.0 Multimedia controller: Philips Semiconductors SAA7164 (rev 81)
         Subsystem: ASUSTeK Computer Inc. Device 48cb
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at fe400000 (64-bit, non-prefetchable) [size=4M]
         Region 2: Memory at fe000000 (64-bit, non-prefetchable) [size=4M]
         Capabilities: [40] MSI: Enable- Count=1/16 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [50] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<256ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x2, ASPM L0s L1, 
Exit Latency L0s <4us, L1 <64us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [74] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [7c] Vendor Specific Information: Len=84 <?>
         Capabilities: [100 v1] Vendor Specific Information: ID=0000 
Rev=0 Len=060 <?>
         Capabilities: [160 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable- ID=0 ArbSelect=Fixed TC/VC=00
                         Status: NegoPending- InProgress-
         Kernel driver in use: saa7164
...


Currently I use KDE4 (installed from the original Ubuntu 14.04 
distribution).

If you need any other parameters to detect my device, please write me 
some instructions how can I get it from my system.
I am software developer so if you have any instructions how can I turn 
on the TV on my computer with this TV-Tuner, please contact me.

Thank you in advance.

Regards,
Zsolt
