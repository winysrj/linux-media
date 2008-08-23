Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 212-41-252-45.c-gmitte.xdsl-line.inode.at ([212.41.252.45]
	helo=isengard.syn-net.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dpat@syn-net.org>) id 1KWtj1-0003FO-B6
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 16:04:19 +0200
Received: from localhost (localhost [127.0.0.1])
	by isengard.syn-net.org (Postfix) with ESMTP id 0307E15016
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 16:04:39 +0200 (CEST)
Received: from isengard.syn-net.org ([127.0.0.1])
	by localhost (isengard.syn-net.org [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id p6ARXhTZLIex for <linux-dvb@linuxtv.org>;
	Sat, 23 Aug 2008 16:04:38 +0200 (CEST)
Received: from [127.0.0.1] (unknown [192.168.9.153])
	by isengard.syn-net.org (Postfix) with ESMTP id 2388113BED
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 16:04:38 +0200 (CEST)
Message-ID: <48B018C2.2030706@syn-net.org>
Date: Sat, 23 Aug 2008 16:03:46 +0200
From: Darshaka Pathirana <dpat@syn-net.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Pinnacle PCTV Sat and bttv/dvb-bt8xx support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi!

I am trying to get my Pinnacle PCTV Sat running but get an error when
trying to load the bttv-driver. According to [1] the card-option of
the card is 94 so i did the following:

% modprobe bttv card=94

(I also tried tuner=-1 and/or i2c_hw=1) and got the following:

Aug 23 02:02:39 grml kernel: bttv: driver version 0.9.17 loaded
Aug 23 02:02:39 grml kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
Aug 23 02:02:39 grml kernel: bttv: Bt8xx card found (0).
Aug 23 02:02:39 grml kernel: bttv0: Bt878 (rev 17) at 0000:02:04.0, irq: 19, latency: 66, mmio: 0xfc400000
Aug 23 02:02:39 grml kernel: bttv0: subsystem: 11bd:501c (UNKNOWN)
Aug 23 02:02:39 grml kernel: please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
Aug 23 02:02:39 grml kernel: bttv0: using: Pinnacle PCTV Sat [card=94,insmod option]
Aug 23 02:02:39 grml kernel: bttv0: gpio: en=00000000, out=00000000 in=009f00fc [init]
Aug 23 02:02:39 grml kernel: bttv0: tuner absent
Aug 23 02:02:39 grml kernel: bttv0: registered device video0
Aug 23 02:02:39 grml kernel: bttv0: registered device vbi0
Aug 23 02:02:39 grml kernel: bttv0: PLL: 28636363 => 35468950 . ok
Aug 23 02:02:39 grml kernel: bttv0: add subdevice "dvb0"
Aug 23 02:02:39 grml kernel: bt878: AUDIO driver version 0.0.0 loaded
Aug 23 02:02:39 grml kernel: bt878: Bt878 AUDIO function found (0).
Aug 23 02:02:39 grml kernel: ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 16 (level, low) -> IRQ 19
Aug 23 02:02:39 grml kernel: bt878_probe: card id=[0x501c11bd], Unknown card.
Aug 23 02:02:39 grml kernel: Exiting..
Aug 23 02:02:39 grml kernel: ACPI: PCI interrupt for device 0000:02:04.1 disabled
Aug 23 02:02:39 grml kernel: bt878: probe of 0000:02:04.1 failed with error -22
Aug 23 02:02:39 grml kernel: dvb_bt8xx: unable to determine DMA core of card 0,
Aug 23 02:02:39 grml kernel: dvb_bt8xx: if you have the ALSA bt87x audio driver installed, try removing it.
Aug 23 02:02:39 grml kernel: dvb-bt8xx: probe of dvb0 failed with error -14


The card has Conxant cx24110 Demodulator on it so I tryied to load the
"cx24110" before and afterwards. Without success.

I believe that dvb_bt8xx can not handle the unknown PCI-ID 11bd:501c /
card id=[0x501c11bd] which is completely undocumented in the whole
(google-)internet. (It's an Austrian product in case that matters.)

Is there any chance to patch the dvb_btxx so it still is can handle
this PCI-ID too? Can I give additional infos to get this card running?

% uname -a
Linux grml 2.6.23-grml #1 SMP PREEMPT Mon Feb 11 10:10:21 CET 2008 i686 GNU/Linux

% lspci -vvnn -d 109e:

02:04.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
	Subsystem: Pinnacle Systems Inc. Unknown device [11bd:501c]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fc400000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
	Status: D0 PME-Enable- DSel=0 DScale=0 PME-
												
02:04.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)
	Subsystem: Pinnacle Systems Inc. Unknown device [11bd:501c]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fc401000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
	Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	

Thanks for every help!

Greetings,
 - Darsha

[1] http://www.mjmwired.net/kernel/Documentation/video4linux/CARDLIST.bttv

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
