Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47156 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZENVKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 17:10:42 -0400
Received: by fxm2 with SMTP id 2so1567820fxm.37
        for <linux-media@vger.kernel.org>; Thu, 14 May 2009 14:10:41 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 May 2009 23:10:41 +0200
Message-ID: <23be820f0905141410k3cc3840eyd17b95730ec91f5c@mail.gmail.com>
Subject: twinhan cards
From: Gregor Fuis <gujs.lists@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

can somebody help me get these cards working. I read on some mails in
here that this can be fixed with a patch of bt878.c file so that it
forces some thing for that card. This would be perfect for me because
I don't use any other cards in this computer.

Here is my dmesg log with error:

[    8.547595] Linux video capture interface: v2.00
[    8.667303] bttv: driver version 0.9.18 loaded
[    8.667312] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    8.667457] bttv: Bt8xx card found (0).
[    8.667503] bttv 0000:00:08.0: PCI INT A -> Link[LNKA] -> GSI 12
(level, low) -> IRQ 12
[    8.667527] bttv0: Bt878 (rev 17) at 0000:00:08.0, irq: 12,
latency: 32, mmio: 0xdfdfe000
[    8.692598] bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI
subsystem ID is 1822:0001
[    8.692609] bttv0: using: Twinhan DST + clones [card=113,autodetected]
[    8.692671] bttv0: gpio: en=00000000, out=00000000 in=00f500fd [init]
[    8.692841] bttv0: tuner absent
[    8.692882] bttv0: add subdevice "dvb0"
[    8.692920] bttv: Bt8xx card found (1).
[    8.692956] bttv 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 11
(level, low) -> IRQ 11
[    8.692979] bttv1: Bt878 (rev 17) at 0000:00:09.0, irq: 11,
latency: 32, mmio: 0xdfdfc000
[    8.696538] bttv1: detected: Twinhan VisionPlus DVB [card=113], PCI
subsystem ID is 1822:0001
[    8.696550] bttv1: using: Twinhan DST + clones [card=113,autodetected]
[    8.696609] bttv1: gpio: en=00000000, out=00000000 in=00f500fd [init]
[    8.696764] bttv1: tuner absent
[    8.696806] bttv1: add subdevice "dvb1"
[    8.696835] bttv: Bt8xx card found (2).
[    8.696872] bttv 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 5
(level, low) -> IRQ 5
[    8.696892] bttv2: Bt878 (rev 17) at 0000:00:0a.0, irq: 5, latency:
32, mmio: 0xdfdfa000
[    8.697198] bttv2: detected: Twinhan VisionPlus DVB [card=113], PCI
subsystem ID is 1822:0001
[    8.697206] bttv2: using: Twinhan DST + clones [card=113,autodetected]
[    8.697253] bttv2: gpio: en=00000000, out=00000000 in=00f50cfd [init]
[    8.697356] bttv2: tuner absent
[    8.697392] bttv2: add subdevice "dvb2"
[    8.697420] bttv: Bt8xx card found (3).
[    8.697451] bttv 0000:00:0b.0: PCI INT A -> Link[LNKD] -> GSI 5
(level, low) -> IRQ 5
[    8.697469] bttv3: Bt878 (rev 17) at 0000:00:0b.0, irq: 5, latency:
32, mmio: 0xdfdf8000
[    8.697685] bttv3: detected: Twinhan VisionPlus DVB [card=113], PCI
subsystem ID is 1822:0001
[    8.697693] bttv3: using: Twinhan DST + clones [card=113,autodetected]
[    8.697729] bttv3: gpio: en=00000000, out=00000000 in=00f588fd [init]
[    8.697819] bttv3: tuner absent
[    8.697864] bttv3: add subdevice "dvb3"
[    8.733966] bt878: AUDIO driver version 0.0.0 loaded
[    8.786814] dvb_bt8xx: unable to determine DMA core of card 0,
[    8.786822] dvb_bt8xx: if you have the ALSA bt87x audio driver
installed, try removing it.
[    8.786838] dvb-bt8xx: probe of dvb0 failed with error -14
[    8.786850] dvb_bt8xx: unable to determine DMA core of card 1,
[    8.786853] dvb_bt8xx: if you have the ALSA bt87x audio driver
installed, try removing it.
[    8.786860] dvb-bt8xx: probe of dvb1 failed with error -14
[    8.786873] dvb_bt8xx: unable to determine DMA core of card 2,
[    8.786877] dvb_bt8xx: if you have the ALSA bt87x audio driver
installed, try removing it.
[    8.786883] dvb-bt8xx: probe of dvb2 failed with error -14
[    8.786895] dvb_bt8xx: unable to determine DMA core of card 3,
[    8.786899] dvb_bt8xx: if you have the ALSA bt87x audio driver
installed, try removing it.
[    8.786906] dvb-bt8xx: probe of dvb3 failed with error -14


And here lspci:

00:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at dfdfe000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: bttv
	Kernel modules: bttv

00:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at dfdff000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>

00:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at dfdfc000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: bttv
	Kernel modules: bttv

00:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at dfdfd000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>

00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at dfdfa000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: bttv
	Kernel modules: bttv

00:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at dfdfb000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>

00:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at dfdf8000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: bttv
	Kernel modules: bttv

00:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Subsystem: Twinhan Technology Co. Ltd Device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at dfdf9000 (32-bit, prefetchable) [size=4K]
	Capabilities: <access denied>


Regards,
Gregor
