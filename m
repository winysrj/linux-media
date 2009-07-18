Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42937 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZGROKI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 10:10:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MSAbz-00089t-3Q
	for linux-media@vger.kernel.org; Sat, 18 Jul 2009 14:10:03 +0000
Received: from host-78-14-97-243.cust-adsl.tiscali.it ([78.14.97.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 14:10:03 +0000
Received: from avljawrowski by host-78-14-97-243.cust-adsl.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 14:10:03 +0000
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Sat, 18 Jul 2009 14:05:22 +0000 (UTC)
Message-ID: <loom.20090718T135733-267@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have a problem with my Pinnacle PCTV Hybrid Pro PCI using recent kernels. With
 2.6.29 both dvbscan and MPlayer stopped to work giving:

dvbscan:
Unable to query frontend status

mplayer:
MPlayer SVN-r29351-4.2.4 (C) 2000-2009 MPlayer Team

Not able to lock to the signal on the given frequency, timeout: 30
dvb_tune, TUNING FAILED

Now with 2.6.30.1 Kaffeine sometimes works and sometimes not, going in timeout.
This is the hardware:

01:02.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Vi
deo Broadcast Decoder (rev d1)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step
ping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (63750ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at cfddf800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=3 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134

dmesg output:

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:01:02.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
saa7133[0]: found at 0000:01:02.0, rev: 209, irq: 22, latency: 32, mmio: 0xcfddf
800
saa7133[0]: subsystem: ffff:ffff, board: Pinnacle PCTV 310i [card=101,insmod opt
ion]
saa7133[0]: board init: gpio is 600c000
IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom read error (err=-5)
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda829x 1-004b: setting tuner address to 61
tda829x 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7134 ALSA driver for DMA sound loaded
IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xcfddf800 irq 22 registered as card -1
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

Can anyone help me getting my tyner working again?
Thanks, avljawrowski

