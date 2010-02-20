Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36450 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0BTR03 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 12:26:29 -0500
Subject: Re: Auto detection for PV- series capture cards
From: Andy Walls <awalls@radix.net>
To: Curtis Hall <curt@bluecherry.net>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <4B7F1D40.8060501@bluecherry.net>
References: <4B7F1D40.8060501@bluecherry.net>
Content-Type: text/plain
Date: Sat, 20 Feb 2010 12:25:57 -0500
Message-Id: <1266686757.3078.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-19 at 17:22 -0600, Curtis Hall wrote:
> Please excuse me if this is not the correct list.

Curtis,

You'll want to resend your e-mail to the linux-media@vger.kernel.org
list.  I've done a reply and Cc:'ed the list, so maybe everything has
gotten forwarded via this message.

> I'm writing concerning the Provideo PV-149, PV-155, PV-981-* and 
> PV-183-*.  We have been the US distributor for these cards since 2004 
> and our main focus with these cards is open source applications that 
> make use of the V4L API.

Just the man I need to speak with. :)

I have a patch for the PV-947D (PCI ID 1540:9673) for the ivtv driver:

http://linuxtv.org/hg/~awalls/v4l-dvb-misc/rev/a45c59b269d1

It doesn't work very well.  I need information to to populate
the .video_inputs, .audo_inputs, and .gpio* arrays properly.

If you can provide any information on how the inputs of the CX2584x chip
are wired up and how the GPIOs control various audio and video input
selections, that would be very helpful.

Thank you

Regards,
Andy

>   These cards, for the most part, are drop in 
> and 'just work' with the bttv driver.
> 
> However the PV-149 / PV-981 / PV-155 gets auto detected as the Provideo 
> PV-150, which is not a valid Provideo part number.  The PV-183-* is 
> detected as 'Unknown / Generic' and requires setting 
> card=98,98,98,98,98,98,98,98.
> 
> I believe the text concerning 'detected: Provideo PV150A-1' should be 
> changed to 'detected: Provideo PV149 / PV981 / PV155'
> 
> I've attached outputs from the bttv kernel logs for the PV-149 / PV-981 
> / PV-183.  If there's something I'm missing please let me know and I'll 
> get it for you.
> 
> Just for reference the PV-149 / PV-981 / PV-183 series cards are:
> 
> PV-149 - 4 port, 4 BT878a chips - no forced card setting required
> PV-155 - 16 port, 4 BT878a chips - card=77,77,77,77  (Shares the same 
> board and PCI ID / subsystem as the PV-149)
> 
> PV-183-8: 8 port, 8 BT878a chips - card=98,98,98,98,98,98,98,98
> PV-183-16: 16 port, 8 BT878a chips - card=98,98,98,98,98,98,98,98 
> (Shares the same board and PCI ID / subsystem as the PV-183-8)
> 
> PV-981-4: 4 port, 4 BT878a chips - no modprobe setting required
> PV-981-8: 8 port, 4 BT878a chips  - no modprobe setting required (Shares 
> the same board as the PV-981-4)
> PV-981-16: 16 port, 4 BT878a chips - card=98,98,98,98,98,98,98,98 
> (Shares the same board and PCI ID / subsystem as the PV-981-4)
> 
> 
> Thanks!
> 
> 
> --
> 
> Curtis Hall (curt@bluecherry.net)
> Bluecherry - www.bluecherry.net
> (877) 418-3391 x 201 
> 
> plain text document attachment (kern.log-pv149.txt)
> [   10.287287] bttv: driver version 0.9.17 loaded
> [   10.287289] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [   10.287336] bttv: Bt8xx card found (0).
> [   10.287345] bttv 0000:04:08.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   10.287354] bttv0: Bt878 (rev 17) at 0000:04:08.0, irq: 22, latency: 64, mmio: 0xfdfff000
> [   10.287367] bttv0: detected: Provideo PV150A-1 [card=98], PCI subsystem ID is aa00:1460
> [   10.287369] bttv0: using: ProVideo PV150 [card=98,autodetected]
> [   10.287392] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   10.287810] bttv0: tuner absent
> [   10.287893] bttv0: registered device video0
> [   10.287925] bttv0: registered device vbi0
> [   10.287946] bttv0: PLL: 28636363 => 35468950 ..<6>hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
> [   10.316095]  ok
> [   10.316109] bttv: Bt8xx card found (1).
> [   10.316125] bttv 0000:04:09.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [   10.316137] bttv1: Bt878 (rev 17) at 0000:04:09.0, irq: 23, latency: 64, mmio: 0xfdffd000
> [   10.316190] bttv1: detected: Provideo PV150A-2 [card=98], PCI subsystem ID is aa01:1461
> [   10.316193] bttv1: using: ProVideo PV150 [card=98,autodetected]
> [   10.316219] bttv1: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   10.316272] bttv1: tuner absent
> [   10.316320] bttv1: registered device video1
> [   10.316354] bttv1: registered device vbi1
> [   10.316375] bttv1: PLL: 28636363 => 35468950 .. ok
> [   10.348096] bttv: Bt8xx card found (2).
> [   10.348112] bttv 0000:04:0a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [   10.348123] bttv2: Bt878 (rev 17) at 0000:04:0a.0, irq: 20, latency: 64, mmio: 0xfdffb000
> [   10.348160] bttv2: detected: Provideo PV150A-3 [card=98], PCI subsystem ID is aa02:1462
> [   10.348163] bttv2: using: ProVideo PV150 [card=98,autodetected]
> [   10.348197] bttv2: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   10.348258] bttv2: tuner absent
> [   10.348302] bttv2: registered device video2
> [   10.348337] bttv2: registered device vbi2
> [   10.348360] bttv2: PLL: 28636363 => 35468950 .. ok
> [   10.380043] bttv: Bt8xx card found (3).
> [   10.380058] bttv 0000:04:0b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [   10.380069] bttv3: Bt878 (rev 17) at 0000:04:0b.0, irq: 21, latency: 64, mmio: 0xfdff9000
> [   10.380128] bttv3: detected: Provideo PV150A-4 [card=98], PCI subsystem ID is aa03:1463
> [   10.380131] bttv3: using: ProVideo PV150 [card=98,autodetected]
> [   10.380157] bttv3: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   10.380217] bttv3: tuner absent
> [   10.380267] bttv3: registered device video3
> [   10.380299] bttv3: registered device vbi3
> [   10.380319] bttv3: PLL: 28636363 => 35468950 .. ok
> 
> plain text document attachment (kern.log-pv183.txt)
> [   13.438351] bttv 0000:02:04.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
> [   13.438363] bttv0: Bt878 (rev 17) at 0000:02:04.0, irq: 17, latency: 32, mmio: 0xd5100000
> [   13.438412] bttv0: subsystem: 1830:1540 (UNKNOWN)
> [   13.438414] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.438416] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.438453] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.474501] bttv0: tuner type unset
> [   13.474503] bttv0: i2c: checking for MSP34xx @ 0x80... not found
> [   13.476477] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.477175] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.477963] bttv0: registered device video0
> [   13.477980] bttv0: registered device vbi0
> [   13.478024] bttv: Bt8xx card found (1).
> [   13.478041] bttv 0000:02:05.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
> [   13.478052] bttv1: Bt878 (rev 17) at 0000:02:05.0, irq: 18, latency: 32, mmio: 0xd5102000
> [   13.478084] bttv1: subsystem: 1831:1540 (UNKNOWN)
> [   13.478086] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.478088] bttv1: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.478115] bttv1: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.514141] bttv1: tuner type unset
> [   13.514144] bttv1: i2c: checking for MSP34xx @ 0x80... not found
> [   13.514849] bttv1: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.515544] bttv1: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.516430] bttv1: registered device video1
> [   13.516613] bttv1: registered device vbi1
> [   13.516651] bttv: Bt8xx card found (2).
> [   13.516953] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
> [   13.516960] bttv 0000:02:06.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
> [   13.516972] bttv2: Bt878 (rev 17) at 0000:02:06.0, irq: 19, latency: 32, mmio: 0xd5104000
> [   13.517003] bttv2: subsystem: 1832:1540 (UNKNOWN)
> [   13.517004] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.517006] bttv2: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.517043] bttv2: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.553571] bttv2: tuner type unset
> [   13.553575] bttv2: i2c: checking for MSP34xx @ 0x80... not found
> [   13.554287] bttv2: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.554982] bttv2: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.555724] bttv2: registered device video2
> [   13.555741] bttv2: registered device vbi2
> [   13.555778] bttv: Bt8xx card found (3).
> [   13.556068] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> [   13.556075] bttv 0000:02:07.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
> [   13.556088] bttv3: Bt878 (rev 17) at 0000:02:07.0, irq: 16, latency: 32, mmio: 0xd5106000
> [   13.556116] bttv3: subsystem: 1833:1540 (UNKNOWN)
> [   13.556118] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.556120] bttv3: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.556157] bttv3: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.592217] bttv3: tuner type unset
> [   13.592221] bttv3: i2c: checking for MSP34xx @ 0x80... not found
> [   13.592930] bttv3: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.593625] bttv3: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.594416] bttv3: registered device video3
> [   13.594455] bttv3: registered device vbi3
> [   13.594492] bttv: Bt8xx card found (4).
> [   13.594512] bttv 0000:02:08.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
> [   13.594526] bttv4: Bt878 (rev 17) at 0000:02:08.0, irq: 17, latency: 32, mmio: 0xd5108000
> [   13.594557] bttv4: subsystem: 1837:1540 (UNKNOWN)
> [   13.594558] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.594560] bttv4: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.594588] bttv4: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.630641] bttv4: tuner type unset
> [   13.630644] bttv4: i2c: checking for MSP34xx @ 0x80... not found
> [   13.631340] bttv4: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.632037] bttv4: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.632807] bttv4: registered device video4
> [   13.632829] bttv4: registered device vbi4
> [   13.632866] bttv: Bt8xx card found (5).
> [   13.632883] bttv 0000:02:09.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
> [   13.632894] bttv5: Bt878 (rev 17) at 0000:02:09.0, irq: 18, latency: 32, mmio: 0xd510a000
> [   13.632920] bttv5: subsystem: 1834:1540 (UNKNOWN)
> [   13.632921] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.632923] bttv5: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.632950] bttv5: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.668972] bttv5: tuner type unset
> [   13.668975] bttv5: i2c: checking for MSP34xx @ 0x80... not found
> [   13.669671] bttv5: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.670366] bttv5: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.671112] bttv5: registered device video5
> [   13.671131] bttv5: registered device vbi5
> [   13.671166] bttv: Bt8xx card found (6).
> [   13.671183] bttv 0000:02:0a.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
> [   13.671196] bttv6: Bt878 (rev 17) at 0000:02:0a.0, irq: 19, latency: 32, mmio: 0xd510c000
> [   13.671232] bttv6: subsystem: 1835:1540 (UNKNOWN)
> [   13.671234] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.671236] bttv6: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.671265] bttv6: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.699171] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
> [   13.699421] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   13.699424] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
> [   13.699462] HDA Intel 0000:00:09.0: setting latency timer to 64
> [   13.707325] bttv6: tuner type unset
> [   13.707327] bttv6: i2c: checking for MSP34xx @ 0x80... not found
> [   13.708023] bttv6: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.708724] bttv6: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.709473] bttv6: registered device video6
> [   13.709492] bttv6: registered device vbi6
> [   13.709527] bttv: Bt8xx card found (7).
> [   13.709540] bttv 0000:02:0b.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
> [   13.709550] bttv7: Bt878 (rev 17) at 0000:02:0b.0, irq: 16, latency: 32, mmio: 0xd510e000
> [   13.709566] bttv7: subsystem: 1836:1540 (UNKNOWN)
> [   13.709568] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> [   13.709570] bttv7: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> [   13.709596] bttv7: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   13.745609] bttv7: tuner type unset
> [   13.745612] bttv7: i2c: checking for MSP34xx @ 0x80... not found
> [   13.746307] bttv7: i2c: checking for TDA9875 @ 0xb0... not found
> [   13.747002] bttv7: i2c: checking for TDA7432 @ 0x8a... not found
> [   13.747747] bttv7: registered device video7
> [   13.747766] bttv7: registered device vbi7
> 
> plain text document attachment (kern.log-pv981.txt)
> [    9.852114] bttv: driver version 0.9.17 loaded
> [    9.852117] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [    9.852171] bttv: Bt8xx card found (0).
> [    9.852185] bttv 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    9.852195] bttv0: Bt878 (rev 17) at 0000:02:00.0, irq: 16, latency: 64, mmio: 0xfdeff000
> [    9.852239] bttv0: detected: Provideo PV150A-1 [card=98], PCI subsystem ID is aa00:1460
> [    9.852241] bttv0: using: ProVideo PV150 [card=98,autodetected]
> [    9.852262] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [    9.852314] bttv0: tuner absent
> [    9.852383] bttv0: registered device video0
> [    9.852415] bttv0: registered device vbi0
> [    9.852438] bttv0: PLL: 28636363 => 35468950 .. ok
> [    9.884047] bttv: Bt8xx card found (1).
> [    9.884063] bttv 0000:02:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    9.884075] bttv1: Bt878 (rev 17) at 0000:02:01.0, irq: 17, latency: 64, mmio: 0xfdefd000
> [    9.884132] bttv1: detected: Provideo PV150A-2 [card=98], PCI subsystem ID is aa01:1461
> [    9.884135] bttv1: using: ProVideo PV150 [card=98,autodetected]
> [    9.884159] bttv1: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [    9.884218] bttv1: tuner absent
> [    9.884269] bttv1: registered device video1
> [    9.884302] bttv1: registered device vbi1
> [    9.884324] bttv1: PLL: 28636363 => 35468950 ..<6>HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [    9.909559] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    9.916097]  ok
> [    9.916113] bttv: Bt8xx card found (2).
> [    9.916125] bttv 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    9.916135] bttv2: Bt878 (rev 17) at 0000:02:02.0, irq: 18, latency: 64, mmio: 0xfdefb000
> [    9.916152] bttv2: detected: Provideo PV150A-3 [card=98], PCI subsystem ID is aa02:1462
> [    9.916155] bttv2: using: ProVideo PV150 [card=98,autodetected]
> [    9.916178] bttv2: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [    9.916248] bttv2: tuner absent
> [    9.916302] bttv2: registered device video2
> [    9.916336] bttv2: registered device vbi2
> [    9.916358] bttv2: PLL: 28636363 => 35468950 ..<6>hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
> [    9.948094]  ok
> [    9.948109] bttv: Bt8xx card found (3).
> [    9.948123] bttv 0000:02:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    9.948135] bttv3: Bt878 (rev 17) at 0000:02:03.0, irq: 19, latency: 64, mmio: 0xfdef9000
> [    9.948171] bttv3: detected: Provideo PV150A-4 [card=98], PCI subsystem ID is aa03:1463
> [    9.948174] bttv3: using: ProVideo PV150 [card=98,autodetected]
> [    9.948207] bttv3: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [    9.948266] bttv3: tuner absent
> [    9.948316] bttv3: registered device video3
> [    9.948349] bttv3: registered device vbi3
> [    9.948371] bttv3: PLL: 28636363 => 35468950 .. ok
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

