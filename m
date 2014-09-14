Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40375 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaINHwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Sep 2014 03:52:50 -0400
Received: by mail-oa0-f48.google.com with SMTP id g18so1700810oah.35
        for <linux-media@vger.kernel.org>; Sun, 14 Sep 2014 00:52:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 14 Sep 2014 15:52:50 +0800
Message-ID: <CAP0kTBbc_DnAmX1g+a0wPWdLkmH+SK+Nnp14yPNvA6VE=k6PMA@mail.gmail.com>
Subject: DVICO Fusion Pro HD 0x9888:0x8229 possible regression linux 3.13.0-35 ?
From: Ben Kelly <kell4now@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My DVICO DVB card has stopped working after I did a release upgrade of
my system (12.04 -> 14.04). The driver looks good, but the dmesg shows
me that the frontend device fails:-

[   21.412769] cx88[1]/2: subsystem: 18ac:db30, board: DViCO
FusionHDTV DVB-T PRO [card=64]

[   21.412771] cx88[1]/2: cx2388x based DVB/ATSC card

[   21.412772] cx8802_alloc_frontends() allocating 1 frontend(s)

[   21.416208] asus_wmi: ASUS WMI generic driver loaded

[   21.416362] i2c i2c-2: sendbytes: NAK bailout.

[   21.416450] zl10353_read_register: readreg error (reg=127, ret==-5)

[   21.417321] cx88[1]/2: dvb frontend not attached. Can't attach xc3028

[   21.417385] cx88[1]/2: dvb_register failed (err = -22)

[   21.417446] cx88[1]/2: cx8802 probe failed, err = -22


Kernel:

Linux mythtv 3.13.0-35-generic #62-Ubuntu SMP Fri Aug 15 01:58:01 UTC
2014 i686 i686 i686 GNU/Linux

Ubuntu 3.13.0-35.62-generic 3.13.11.6


Lspci:

05:02.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)

        Subsystem: DViCO Corporation Device db30

        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-

        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 64 bytes

        Interrupt: pin A routed to IRQ 19

        Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=16M]

        Capabilities: <access denied>

        Kernel driver in use: cx8800



05:02.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [Audio Port] (rev 05)

        Subsystem: DViCO Corporation Device db30

        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-

        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

        Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 64 bytes

        Interrupt: pin A routed to IRQ 19

        Region 0: Memory at f1000000 (32-bit, non-prefetchable) [size=16M]

        Capabilities: <access denied>

        Kernel driver in use: cx88_audio



05:02.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [MPEG Port] (rev 05)

        Subsystem: DViCO Corporation Device db30

        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-

        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 64 bytes

        Interrupt: pin A routed to IRQ 19

        Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=16M]

        Capabilities: <access denied>

        Kernel driver in use: cx88-mpeg driver manager
