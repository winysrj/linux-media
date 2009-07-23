Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos02.frii.com ([216.17.128.162]:64848 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750865AbZGWC3I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 22:29:08 -0400
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by mail.frii.com (FRII) with ESMTP id 23FCE6788F
	for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 20:29:07 -0600 (MDT)
Date: Wed, 22 Jul 2009 20:29:07 -0600
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: TBS 8920 fails to initialize
Message-ID: <20090723022907.GA91591@io.frii.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings:

I am trying out a new TBS 8920 using the 2.6.30 built-in driver and it
fails to initialize. Here are the dmesg lines:

qpc$ dmesg | grep cx88\\[1\\]
cx88[1]: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72,autodetected], frontend(s): 1
cx88[1]: TV tuner type 4, Radio tuner type -1
cx88[1]/2: cx2388x 8802 Driver Manager
cx88[1]/2: found at 0000:01:08.2, rev: 5, irq: 16, latency: 32, mmio: 0xf1000000
IRQ 16/cx88[1]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[1]/0: found at 0000:01:08.0, rev: 5, irq: 16, latency: 32, mmio: 0xf0000000
IRQ 16/cx88[1]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
cx88[1]/2: cx2388x based DVB/ATSC card
cx88[1]/2: frontend initialization failed
cx88[1]/2: dvb_register failed (err = -22)
cx88[1]/2: cx8802 probe failed, err = -22

and the lspci -vv:

01:08.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Device 8920:8888
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
                No end tag found
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx8800

01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Device 8920:8888
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f1000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88-mpeg driver manager

I have not yet built my own driver from current linuxtv.org source but
I expect I will need to do so. Is there anything anyone can discern
from what I have included here?

-- Mark

