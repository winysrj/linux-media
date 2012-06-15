Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52415 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2FOD1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 23:27:47 -0400
Received: by dady13 with SMTP id y13so3431689dad.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 20:27:47 -0700 (PDT)
Message-ID: <4FDAABB0.9040003@gmail.com>
Date: Thu, 14 Jun 2012 20:27:44 -0700
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: pctv hd pci 800i card problem: cx88-dvb does not insert
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear v4l-dvb experts,

I'm stuck trying to get a hybrid tv card that seems to be well supported
working. The box is labeled simply pctv hd card 800i; Newegg sells it as
Hauppauge pctv pci 800i;  Linuxtv has a setup page for it as a Pinnacle
card
(http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29).

Grepping dmesg for the firmware and drivers ("cx88\|xc5000") shows where
I'm stuck---the last few lines:

[   15.667814] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[   15.671012] cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD
800i [card=58,autodetected], frontend(s): 1
[   15.671016] cx88[0]: TV tuner type 76, Radio tuner type -1
[   15.673125] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[   16.040393] xc5000 1-0064: creating new instance
[   16.042076] xc5000: Successfully identified at address 0x64
[   16.042078] xc5000: Firmware has not been loaded previously
[   16.042083] cx88[0]: Calling XC5000 callback
[   16.144338] input: cx88 IR (Pinnacle PCTV HD 800i) as
/devices/pci0000:00/0000:00:1c.2/0000:04:00.0/0000:05:00.0/rc/rc0/input11
[   16.144439] rc0: cx88 IR (Pinnacle PCTV HD 800i) as
/devices/pci0000:00/0000:00:1c.2/0000:04:00.0/0000:05:00.0/rc/rc0
[   16.144490] cx88[0]/0: found at 0000:05:00.0, rev: 5, irq: 18,
latency: 32, mmio: 0xf8000000
[   16.148463] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)...
[   16.198497] xc5000: firmware read 12401 bytes.
[   16.198500] xc5000: firmware uploading...
[   16.198504] cx88[0]: Calling XC5000 callback
[   16.320681] input: MCE IR Keyboard/Mouse (cx88xx) as
/devices/virtual/input/input12
[   16.342673] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 0
[   19.559428] xc5000: firmware upload complete...
[   20.155953] cx88[0]/0: registered device video0 [v4l2]
[   20.156084] cx88[0]/0: registered device vbi0
[   20.156278] cx88[0]/2: cx2388x 8802 Driver Manager
[   20.156316] cx88[0]/2: found at 0000:05:00.2, rev: 5, irq: 18,
latency: 32, mmio: 0xf6000000
[   20.156443] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   20.188403] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   20.188405] cx88/2: registering cx8802 driver, type: dvb access: shared
[   20.188408] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD
800i [card=58]
[   20.188410] cx88[0]/2: cx2388x based DVB/ATSC card
[   20.188411] cx8802_alloc_frontends() allocating 1 frontend(s)
[   20.224518] cx88[0]/2: frontend initialization failed
[   20.224521] cx88[0]/2: dvb_register failed (err = -22)
[   20.224523] cx88[0]/2: cx8802 probe failed, err = -22
[   20.224563] cx88[0]: Calling XC5000 callback
[   20.224602] cx88[0]: Calling XC5000 callback
[   20.232631] modprobe[819]: FATAL: Error inserting cx88_dvb
(/lib/modules/3.3.7-1.fc16.x86_64/kernel/drivers/media/video/cx88/cx88-dvb.ko):
No such device

No /dev/dvb nodes are created; the analog /dev/v4l nodes are created
(and analog video seems to work).

NOTES:
(1) Trying to insert cx88-dvb by hand yields the same error.
(2) I am using Fedora 16 (kernel 3.3.7-1.fc16.x86_64). The drivers are
in the kernel.  I've built the drivers from source against the
3.3.7-1.fc16.x86_64 headers, but the results are the same. 
(3) I tried a workaround in a similar-sounding redhat bug report at
http://linuxtv.org/wiki/index.php/KWorld_ATSC_120:
Boot with cx8800, cx8802, cx88-alsa, and cx88-dvb blacklisted, remove
the blacklist, then modprobe cx88-dvb. cx88-dvb still fails to insert.

Thanks very much for any help!
Mack


For the record, here is the card's lspci -vvnn:

05:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [44] Vital Product Data
        No end tag found
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx8800
    Kernel modules: cx8800

05:00.1 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801] (rev 05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx88_audio
    Kernel modules: cx88-alsa

05:00.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
    Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
    Capabilities: [4c] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: cx88-mpeg driver manager
    Kernel modules: cx8802
