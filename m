Return-path: <linux-media-owner@vger.kernel.org>
Received: from eastrmmtao103.cox.net ([68.230.240.9]:62854 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZHHAPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 20:15:08 -0400
Received: from eastrmimpo02.cox.net ([68.1.16.120])
          by eastrmmtao103.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090808001508.PEJP27176.eastrmmtao103.cox.net@eastrmimpo02.cox.net>
          for <linux-media@vger.kernel.org>; Fri, 7 Aug 2009 20:15:08 -0400
Message-ID: <98F27778E85D4EEB87540FBD5D29D993@flipsideprime>
From: "Kevin Smith" <flipside@cox.net>
To: <linux-media@vger.kernel.org>
Subject: error in compiled v4l cx88_alsa
Date: Fri, 7 Aug 2009 19:15:09 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cannot get sound working in compiled modules as follows.  Sound in DVB works 
just not v4l (tvtime/myth) - thanks

using
v4l-dvb-0db4331fd64a modles and
Aug  7 18:10:50 flipside kernel: xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
Aug  7 18:10:50 flipside kernel: cx88-mpeg driver manager 0000:05:06.2: 
firmware: requesting dvb-fe-xc5000-1.6.114.fw
Aug  7 18:10:50 flipside kernel: xc5000: firmware uploading...
Aug  7 18:10:50 flipside kernel: xc5000: firmware upload complete...

Aug  7 18:10:50 flipside kernel: cx2388x alsa driver version 0.0.7 loaded
Aug  7 18:11:42 flipside pulseaudio[4278]: alsa-source.c: ALSA woke us up to 
read new data from the device, but there was actually nothing to read!
Aug  7 18:11:42 flipside pulseaudio[4278]: alsa-source.c: Most likely this 
is a bug in the ALSA driver 'cx88_alsa'. Please report this issue to the 
ALSA developers.
Aug  7 18:11:42 flipside pulseaudio[4278]: alsa-source.c: We were woken up 
with POLLIN set -- however a subsequent snd_pcm_avail() returned 0 or 
another value < min_avail.

more

Aug  7 18:10:50 flipside kernel: cx88/2: cx2388x MPEG-TS Driver Manager 
version 0.0.7 loaded
Aug  7 18:10:50 flipside kernel: cx88[0]: subsystem: 11bd:0051, board: 
Pinnacle PCTV HD 800i [card=58,autodetected], frontend(s): 1
Aug  7 18:10:50 flipside kernel: cx88[0]: TV tuner type 76, Radio tuner 
type -1
Aug  7 18:10:50 flipside kernel: cx88/0: cx2388x v4l2 driver version 0.0.7 
loaded
Aug  7 18:10:50 flipside kernel: tuner 1-0064: chip found @ 0xc8 (cx88[0])
Aug  7 18:10:50 flipside kernel: cx88[0]: Calling XC5000 callback
Aug  7 18:10:50 flipside kernel: input: cx88 IR (Pinnacle PCTV HD 800i) as 
/devices/pci0000:00/0000:00:13.1/0000:05:06.2/input/input6
Aug  7 18:10:50 flipside kernel: cx88[0]/2: cx2388x 8802 Driver Manager
Aug  7 18:10:50 flipside kernel: cx88-mpeg driver manager 0000:05:06.2: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
Aug  7 18:10:50 flipside kernel: cx88[0]/2: found at 0000:05:06.2, rev: 5, 
irq: 16, latency: 64, mmio: 0xf9000000
Aug  7 18:10:50 flipside kernel: IRQ 16/cx88[0]: IRQF_DISABLED is not 
guaranteed on shared IRQs
Aug  7 18:10:50 flipside kernel: cx88_audio 0000:05:06.1: PCI INT A -> GSI 
16 (level, low) -> IRQ 16
Aug  7 18:10:50 flipside kernel: IRQ 16/cx88[0]: IRQF_DISABLED is not 
guaranteed on shared IRQs
Aug  7 18:10:50 flipside kernel: cx88[0]/1: CX88x/0: ALSA support for 
cx2388x boards
Aug  7 18:10:50 flipside kernel: cx8800 0000:05:06.0: PCI INT A -> GSI 16 
(level, low) -> IRQ 16
Aug  7 18:10:50 flipside kernel: cx88[0]/0: found at 0000:05:06.0, rev: 5, 
irq: 16, latency: 64, mmio: 0xfb000000
Aug  7 18:10:50 flipside kernel: IRQ 16/cx88[0]: IRQF_DISABLED is not 
guaranteed on shared IRQs
Aug  7 18:10:50 flipside kernel: cx88[0]/0: registered device video0 [v4l2]
Aug  7 18:10:50 flipside kernel: cx88[0]/0: registered device vbi0
Aug  7 18:10:50 flipside kernel: cx88-mpeg driver manager 0000:05:06.2: 
firmware: requesting dvb-fe-xc5000-1.6.114.fw
Aug  7 18:10:50 flipside kernel: cx88/2: cx2388x dvb driver version 0.0.7 
loaded
Aug  7 18:10:50 flipside kernel: cx88/2: registering cx8802 driver, type: 
dvb access: shared
Aug  7 18:10:50 flipside kernel: cx88[0]/2: subsystem: 11bd:0051, board: 
Pinnacle PCTV HD 800i [card=58]
Aug  7 18:10:50 flipside kernel: cx88[0]/2: cx2388x based DVB/ATSC card
Aug  7 18:10:50 flipside kernel: cx8802_alloc_frontends() allocating 1 
frontend(s)
Aug  7 18:10:50 flipside kernel: cx88[0]: Calling XC5000 callback
Aug  7 18:10:50 flipside kernel: cx88[0]: Calling XC5000 callback
Aug  7 18:10:50 flipside kernel: DVB: registering new adapter (cx88[0])
Aug  7 18:11:42 flipside pulseaudio[4278]: alsa-source.c: Most likely this 
is a bug in the ALSA driver 'cx88_alsa'. Please report this issue to the 
ALSA developers.
Aug  7 18:16:58 flipside kernel: cx88[0]: Calling XC5000 callback

kernel
2.6.29.6-217.2.3.fc11.i686.PAE #1 SMP

04:01.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA 
High Definition Audio Controller) (rev 10)
        Subsystem: ASUSTeK Computer Inc. Device 8249
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f8efc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

05:06.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 
PCI Video and Audio Decoder (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>
        Kernel driver in use: cx8800
        Kernel modules: cx8800

05:06.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

05:06.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802


 

