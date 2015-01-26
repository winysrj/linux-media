Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:37605 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbAZFuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 00:50:19 -0500
Received: by mail-la0-f41.google.com with SMTP id gm9so6027062lab.0
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:50:17 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 25 Jan 2015 23:50:17 -0600
Message-ID: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
Subject: PCTV 800i
From: John Klug <ski.brimson@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a new PCTV card with CX23880 (not CX23883 as shown in the picture):

http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)

The description is out of date with respect to my recent card.

It did not work in 3.12.20, 3.17.7, and I finally downloaded the
latest GIT of media_build to no avail (I have a 2nd card that is CX18,
which is interspersed in the output).

All produce the same error:
[   19.895978] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   19.896343] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 18,
latency: 20, mmio: 0xef000000
[   19.896438] cx88[0]/0: registered device video2 [v4l2]
[   19.896466] cx88[0]/0: registered device vbi0
[   19.908270] cx88[0]/2: cx2388x 8802 Driver Manager
[   19.908352] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 18,
latency: 64, mmio: 0xed000000
[   19.926299] cx88/2: cx2388x dvb driver version 1.0.0 loaded
[   19.926303] cx88/2: registering cx8802 driver, type: dvb access: shared
[   19.926305] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV
HD 800i [card=58]
[   19.926307] cx88[0]/2: cx2388x based DVB/ATSC card
[   19.926309] cx8802_alloc_frontends() allocating 1 frontend(s)
[   19.989128] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
(141200 bytes)
[   19.995285] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
[   19.996947] cx88[0]/2: frontend initialization failed
[   19.996950] cx88[0]/2: dvb_register failed (err = -22)
[   19.996951] cx88[0]/2: cx8802 probe failed, err = -22


Here is the output from lspci -vvnn:

01:06.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 20 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at ef000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [44] Vital Product Data
        No end tag found
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx8800
    Kernel modules: cx8800

01:06.1 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801]
(rev 05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx88_audio
    Kernel modules: cx88_alsa

01:06.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev
05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx88-mpeg driver manager
    Kernel modules: cx8802
