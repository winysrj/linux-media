Return-path: <linux-media-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.241]:41277 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZCAJCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 04:02:24 -0500
Received: by ag-out-0708.google.com with SMTP id 26so3296629agb.10
        for <linux-media@vger.kernel.org>; Sun, 01 Mar 2009 01:02:20 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Mar 2009 20:02:19 +1100
Message-ID: <333d4f210903010102o23a2bbf2p36b0b11fbb754a09@mail.gmail.com>
Subject: saa716x driver for DNTV Live! Dual Hybrid PCI-Express S3
From: Damien Whyte <purplelazy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

  I recently purchased a pair of DNTV Live! Dual Hybrid PCI-Express S3
cards (see http://www.digitalnow.com.au/product_pages/DNTVDualS3.html)
without properly checking that they were supported under Linux. Silly
me.

I see that Manu Abraham is currently working on a saa716x driver, so I
have begun trying to get the driver working with my cards. I
understand that this is still a work in progress so if I am too
premature please tell me to rack off.

However if I can be any help testing the driver (or whatever) I would
like to contribute.

Currently I have managed to load the saa716x_hybrid module - although
I'm not seeing any relevant traces in the kernel logs. Also no adapter
devices are being created.

Anyway thanks for the saa716x driver and v4l/dvb in general.

regards,
Damien.

P.S results of lsmod and lspci.

abraxas tmp # lsmod
Module                  Size  Used by
saa716x_hybrid         10824  0
saa716x_core           59508  1 saa716x_hybrid
dvb_core               87916  2 saa716x_hybrid,saa716x_core
tda1004x               15748  1 saa716x_hybrid
nvidia               7800392  26

abraxas tmp # lspci -s 07:00.0 -vvxxx
07:00.0 Multimedia controller: Philips Semiconductors Device 7162 (rev 01)
	Subsystem: KWorld Computer Co. Ltd. Device 7523
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fbd00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
Count=1/32 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [50] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [74] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Vendor Specific Information <?>
	Capabilities: [100] Vendor Specific Information <?>
00: 31 11 62 71 07 01 10 00 01 00 80 04 10 00 00 00
10: 04 00 d0 fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 de 17 23 75
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 00 00
40: 05 50 8a 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 10 74 01 00 80 00 28 00 10 00 0a 00 11 6c 03 01
60: 08 00 11 00 00 0a 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 01 80 02 3e 00 00 00 00 00 00 00 00
80: 09 00 50 00 03 0c 00 00 02 02 00 00 00 00 00 00
90: 00 07 00 00 00 00 00 08 00 00 10 00 00 00 00 00
a0: 01 00 00 04 03 00 00 00 00 00 01 07 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 20 01 2a 00 00
c0: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
