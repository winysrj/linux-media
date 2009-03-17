Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:47057 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbZCQOX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 10:23:27 -0400
Received: from jenix (c220-239-230-109.thorn1.nsw.optusnet.com.au [220.239.230.109])
	by mail12.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id n2HBxEFj019591
	for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 22:59:16 +1100
To: linux-media@vger.kernel.org
Subject: No subsystem id (and therefore no =?UTF-8?Q?cx=38=38=5Fdvb=20loaded=29=20?=
 =?UTF-8?Q?after=20reboot?=
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 22:59:14 +1100
From: Grant Gardner <grant@lastweekend.com.au>
Message-ID: <e0f27036e7a5af1cc8e8a725b522593b@localhost>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>






I'm looking for some pointers on debugging a problem with my DVICO

FusionHDTV Hybrid DVB-T card.



The device was working perfectly prior to a reconfiguration of my machine,

kernel upgrade etc...



Now, on a cold start everything seems to start smoothly but I can't tune

channels.



Then, after a reboot the device is not detected due to "invalid subsystem

id". As below lspci reports no subsystem information at all. 



Comparing the lspci output seems to be around the "Region 0: Memory at

ee000000 v de000000", but I'm not

sure what this means, and whether fixing the reboot problem will fix the

channel tuning problem.



Running mythbuntu 8.10

2.6.27-11-generic #1 SMP Thu Jan 29 19:28:32 UTC 2009 x86_64 GNU/Linux



lspci -vvnn after cold start



00:0a.0 Multimedia video controller [0400]: Conexant Systems, Inc.

CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)

	Subsystem: DViCO Corporation Device [18ac:db40]

	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-

Stepping- SERR- FastB2B- DisINTx-

	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-

<MAbort- >SERR- <PERR- INTx-

	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes

	Interrupt: pin A routed to IRQ 18

	Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]

	Capabilities: [44] Vital Product Data <?>

	Capabilities: [4c] Power Management version 2

		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA

PME(D0-,D1-,D2-,D3hot-,D3cold-)

		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

	Kernel driver in use: cx8800

	Kernel modules: cx8800



00:0a.1 Multimedia controller [0480]: Conexant Systems, Inc. CX23880/1/2/3

PCI Video and Audio Decoder [Audio Port] [14f1:8811] (rev 05)

	Subsystem: DViCO Corporation Device [18ac:db40]

	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-

Stepping- SERR- FastB2B- DisINTx-

	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-

<MAbort- >SERR- <PERR- INTx-

	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes

	Interrupt: pin A routed to IRQ 11

	Region 0: Memory at df000000 (32-bit, non-prefetchable) [size=16M]

	Capabilities: [4c] Power Management version 2

		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA

PME(D0-,D1-,D2-,D3hot-,D3cold-)

		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

	Kernel modules: cx88-alsa



00:0a.2 Multimedia controller [0480]: Conexant Systems, Inc. CX23880/1/2/3

PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)

	Subsystem: DViCO Corporation Device [18ac:db40]

	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-

Stepping- SERR- FastB2B- DisINTx-

	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-

<MAbort- >SERR- <PERR- INTx-

	Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes

	Interrupt: pin A routed to IRQ 18

	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]

	Capabilities: [4c] Power Management version 2

		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA

PME(D0-,D1-,D2-,D3hot-,D3cold-)

		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

	Kernel driver in use: cx88-mpeg driver manager

	Kernel modules: cx8802





lspci -vvnn after warm reboot



00:0a.0 Multimedia video controller [0400]: Conexant Systems, Inc.

CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)

      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-

Stepping- SERR- FastB2B- DisINTx-

      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-

<TAbort- <MAbort- >SERR- <PERR- INTx-

      Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes

      Interrupt: pin A routed to IRQ 18

      Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=16M]

      Capabilities: [44] Vital Product Data <?>

      Capabilities: [4c] Power Management version 2

              Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA

PME(D0-,D1-,D2-,D3hot-,D3cold-)

              Status: D0 PME-Enable- DSel=0 DScale=0 PME-

      Kernel driver in use: cx8800

      Kernel modules: cx8800
