Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodbine.london.02.net ([87.194.255.145]:44057 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2F3N5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 09:57:03 -0400
Received: from ha-server.keynet.dyndns.tv (94.194.138.113) by woodbine.london.02.net (8.5.140)
        id 4FED9DF1000426BB for linux-media@vger.kernel.org; Sat, 30 Jun 2012 14:57:00 +0100
Received: from localhost (localhost [127.0.0.1])
	by ha-server.keynet.dyndns.tv (Postfix) with ESMTP id 53BAE1E382E
	for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 14:57:00 +0100 (BST)
Received: from ha-server.keynet.dyndns.tv ([127.0.0.1])
	by localhost (ha-server.keynet.dyndns.tv [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k1JfDaDBQDwD for <linux-media@vger.kernel.org>;
	Sat, 30 Jun 2012 14:56:59 +0100 (BST)
Received: from [192.168.0.1] (core2duo.lan [192.168.0.1])
	by ha-server.keynet.dyndns.tv (Postfix) with ESMTP id E69B71E37E7
	for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 14:56:59 +0100 (BST)
Message-ID: <4FEF05AA.70209@keynet-technology.com>
Date: Sat, 30 Jun 2012 14:56:58 +0100
From: Richard F <lists@keynet-technology.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: unrecognised BT878 video capture card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an IVC-100-LEG from ebay
http://www.ebay.co.uk/itm/370609954186?ssPageName=STRK:MEWNX:IT&_trksid=p3984.m1497.l2649

It works with insmod option card=110 which is for the vanilla IVC-100


[    8.257854] Linux video capture interface: v2.00
[    8.264465] bttv: driver version 0.9.18 loaded
[    8.265765] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    8.267108] bttv: Bt8xx card found (0).
[    8.268435] bttv 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    8.269833] bttv0: Bt878 (rev 17) at 0000:04:00.0, irq: 18, latency: 
32, mmio: 0xd0001000
[    8.271381] bttv0: subsystem: ff03:a132 (UNKNOWN)
[    8.272753] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    8.272756] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[    8.274227] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    8.274307] bt878 #0 [sw]: Test OK

Output of lspci -vv

04:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Device ff03:a132
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (4000ns min, 10000ns max)
         Interrupt: pin A routed to IRQ 18
         Region 0: Memory at d0001000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: bttv
         Kernel modules: bttv

04:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Device ff03:a132
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (1000ns min, 63750ns max)
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at d0000000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
