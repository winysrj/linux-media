Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43037 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2ELE6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 00:58:54 -0400
Received: by wgbdr13 with SMTP id dr13so3057733wgb.1
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 21:58:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 12 May 2012 14:58:52 +1000
Message-ID: <CA+i0-i8mZ6Wn4r71MRQoOGSRyj8LhmqYWpUW=K2jq0S1QU9Msw@mail.gmail.com>
Subject: Attempting to get Kworld PE355-2T working: where can I get the
 current NXT SAA716x work?
From: Robert Backhaus <robbak@robbak.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to see what I can do to get the Kworld PE355-2T PCIe Dual
DVB-T card working. I've put all the details I can find up at
http://www.linuxtv.org/wiki/index.php/Kworld_pe355-2T_PCI-E_Dual_DVB-T_TV_Card_Pro

The first step is to get the current experimental NXT SAA716x drivers,
but I cannot find them. Can anyone point me in the right direction?

For completeness:
$ uname -a
Linux mythtv-server 3.2.0-24-generic #37-Ubuntu SMP Wed Apr 25
08:43:52 UTC 2012 i686 i686 i386 GNU/Linux
$ sudo lspci -vvvnn -s03:00.0
03:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7160
[1131:7160] (rev 03)
	Subsystem: KWorld Computer Co. Ltd. Device [17de:7547]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [40] MSI: Enable- Count=1/32 Maskable- 64bit+
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
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [74] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Vendor Specific Information: Len=50 <?>
	Capabilities: [100 v1] Vendor Specific Information: ID=0000 Rev=0 Len=088 <?>
