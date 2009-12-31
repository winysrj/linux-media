Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2.vodamail.co.za ([196.11.146.227]:41946 "EHLO
	vodamail.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751331AbZLaWO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 17:14:58 -0500
Subject: Re: Fwd: Compro S300 - ZL10313
From: JD Louw <jd.louw@mweb.co.za>
To: linux-media@vger.kernel.org
Cc: Theunis Potgieter <theunis.potgieter@gmail.com>
In-Reply-To: <23582ca0912291323s1be512ebnd60bf2ea1988799@mail.gmail.com>
References: <23582ca0912291306v11d0631fia6ad442918961b48@mail.gmail.com>
	 <23582ca0912291307l53ff8d74j928f9e22ce09311@mail.gmail.com>
	 <23582ca0912291323s1be512ebnd60bf2ea1988799@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-WMOHxS0tdUgmj/ssKWW0"
Date: Fri, 01 Jan 2010 00:07:12 +0200
Message-ID: <1262297232.1913.31.camel@Core2Duo>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-WMOHxS0tdUgmj/ssKWW0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2009-12-29 at 23:23 +0200, Theunis Potgieter wrote: 
> Hi mailing list,
> 
> I have a problem with my Compro S300 pci card under Linux 2.6.32.
> 
> I cannot tune with this card and STR/SNRA is very bad compared to my
> Technisat SkyStar 2 pci card, connected to the same dish.
> 
> I have this card and are willing to run tests, tested drivers etc to
> make this work.
> 
> I currently load the module saa7134 with options: card=169
> 
> I enabled some debug parameters on the saa7134, not sure what else I
> should enable. Please find my dmesg log attached.
> 
> lsmod shows :
> 
> # lsmod
> Module                  Size  Used by
> zl10039                 6268  2
> mt312                  12048  2
> saa7134_dvb            41549  11
> saa7134               195664  1 saa7134_dvb
> nfsd                  416819  11
> videobuf_dvb            8187  1 saa7134_dvb
> dvb_core              148140  1 videobuf_dvb
> ir_common              40625  1 saa7134
> v4l2_common            21544  1 saa7134
> videodev               58341  2 saa7134,v4l2_common
> v4l1_compat            24473  1 videodev
> videobuf_dma_sg        17830  2 saa7134_dvb,saa7134
> videobuf_core          26534  3 saa7134,videobuf_dvb,videobuf_dma_sg
> tveeprom               12550  1 saa7134
> thermal                20547  0
> processor              54638  1
> 
> # uname -a
> Linux vbox 2.6.32-gentoo #4 Sat Dec 19 00:54:19 SAST 2009 i686 Pentium
> III (Coppermine) GenuineIntel GNU/Linux
> 
> Thanks,
> Theunis

Hi,

It's probably the GPIO settings that are wrong for your SAA7133 based
card revision. See http://osdir.com/ml/linux-media/2009-06/msg01256.html
for an explanation. For quick confirmation check if you have 12V - 20V
DC going to your LNB. The relevant lines of code is in
~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c:

case SAA7134_BOARD_VIDEOMATE_S350:
dev->has_remote = SAA7134_REMOTE_GPIO;
saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
break;


Looking at your log, at least the demodulator and tuner is responding
correctly. You can see this by looking at the i2c traffic addressed to
0x1c (demodulator) and 0xc0 (tuner). Attached is a dmesg trace from my
working SAA7130 based card.

Regards
JD 

--=-WMOHxS0tdUgmj/ssKWW0
Content-Disposition: attachment; filename="log.txt"
Content-Type: text/plain; name="log.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit



07:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Video Broadcast Decoder [1131:7130] (rev 01)
	Subsystem: Compro Technology, Inc. Device [185b:c900]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at 50004800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: saa7134
	Kernel modules: saa7134




and




[    6.560811] Linux video capture interface: v2.00
[    6.602624] saa7130/34: v4l2 driver version 0.2.15 loaded
[    6.602776] saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.602783] saa7130[0]: found at 0000:07:00.0, rev: 1, irq: 21, latency: 32, mmio: 0x50004800
[    6.602788] saa7130[0]: subsystem: 185b:c900, board: Compro VideoMate S350/S300 [card=169,autodetected]
[    6.602803] saa7130[0]: board init: gpio is 843f00
[    6.602873] input: saa7134 IR (Compro VideoMate S3 as /devices/pci0000:00/0000:00:1e.0/0000:07:00.0/input/input14
[    6.602935] Creating IR device irrcv0
[    6.602939] IRQ 21/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.710132] saa7130[0]: i2c xfer: < a0 00 >
[    6.730092] saa7130[0]: i2c xfer: < a1 =5b =18 =00 =c9 =54 =20 =1c =00 =43 =43 =a9 =1c =55 =d2 =b2 =92 =00 =ff =86 =0f =ff =20 =ff =ff =ff =ff =ff =ff =ff
 =ff =ff =ff =01 =40 =01 =02 =02 =01 =03 =01 =08 =ff =00 =87 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =d6 =00 =c0 
=86 =1c =02 =01 =02 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =cb =30 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =
ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =f
f =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
[    6.780031] saa7130[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[    6.780044] saa7130[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[    6.780056] saa7130[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
[    6.780068] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780080] saa7130[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
[    6.780092] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
[    6.780104] saa7130[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780116] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780127] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780139] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780151] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780163] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780174] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780186] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780198] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780210] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.780222] saa7130[0]: i2c xfer: < 01 ERROR: NO_DEVICE
[    6.780399] saa7130[0]: i2c xfer: < 03 ERROR: NO_DEVICE
[    6.780575] saa7130[0]: i2c xfer: < 05 ERROR: NO_DEVICE
[    6.780750] saa7130[0]: i2c xfer: < 07 ERROR: NO_DEVICE
[    6.780926] saa7130[0]: i2c xfer: < 09 ERROR: NO_DEVICE
[    6.781101] saa7130[0]: i2c xfer: < 0b ERROR: NO_DEVICE
[    6.781277] saa7130[0]: i2c xfer: < 0d ERROR: NO_DEVICE
[    6.781453] saa7130[0]: i2c xfer: < 0f ERROR: NO_DEVICE
[    6.781628] saa7130[0]: i2c xfer: < 11 ERROR: NO_DEVICE
[    6.781804] saa7130[0]: i2c xfer: < 13 ERROR: NO_DEVICE
[    6.781979] saa7130[0]: i2c xfer: < 15 ERROR: NO_DEVICE
[    6.782155] saa7130[0]: i2c xfer: < 17 ERROR: NO_DEVICE
[    6.782331] saa7130[0]: i2c xfer: < 19 ERROR: NO_DEVICE
[    6.782506] saa7130[0]: i2c xfer: < 1b ERROR: NO_DEVICE
[    6.782682] saa7130[0]: i2c xfer: < 1d >
[    6.800032] saa7130[0]: i2c scan: found device @ 0x1c  [???]
[    6.800035] saa7130[0]: i2c xfer: < 1f ERROR: NO_DEVICE
[    6.800212] saa7130[0]: i2c xfer: < 21 ERROR: NO_DEVICE
[    6.800397] saa7130[0]: i2c xfer: < 23 ERROR: NO_DEVICE
[    6.800573] saa7130[0]: i2c xfer: < 25 ERROR: NO_DEVICE
[    6.800749] saa7130[0]: i2c xfer: < 27 ERROR: NO_DEVICE
[    6.800924] saa7130[0]: i2c xfer: < 29 ERROR: NO_DEVICE
[    6.801100] saa7130[0]: i2c xfer: < 2b ERROR: NO_DEVICE
[    6.801276] saa7130[0]: i2c xfer: < 2d ERROR: NO_DEVICE
[    6.801451] saa7130[0]: i2c xfer: < 2f ERROR: NO_DEVICE
[    6.801627] saa7130[0]: i2c xfer: < 31 ERROR: NO_DEVICE
[    6.801802] saa7130[0]: i2c xfer: < 33 ERROR: NO_DEVICE
[    6.801978] saa7130[0]: i2c xfer: < 35 ERROR: NO_DEVICE
[    6.802153] saa7130[0]: i2c xfer: < 37 ERROR: NO_DEVICE
[    6.802329] saa7130[0]: i2c xfer: < 39 ERROR: NO_DEVICE
[    6.802505] saa7130[0]: i2c xfer: < 3b ERROR: NO_DEVICE
[    6.802680] saa7130[0]: i2c xfer: < 3d ERROR: NO_DEVICE
[    6.802856] saa7130[0]: i2c xfer: < 3f ERROR: NO_DEVICE
[    6.803031] saa7130[0]: i2c xfer: < 41 ERROR: NO_DEVICE
[    6.803207] saa7130[0]: i2c xfer: < 43 ERROR: NO_DEVICE
[    6.803383] saa7130[0]: i2c xfer: < 45 ERROR: NO_DEVICE
[    6.803558] saa7130[0]: i2c xfer: < 47 ERROR: NO_DEVICE
[    6.803734] saa7130[0]: i2c xfer: < 49 ERROR: NO_DEVICE
[    6.803909] saa7130[0]: i2c xfer: < 4b ERROR: NO_DEVICE
[    6.804085] saa7130[0]: i2c xfer: < 4d ERROR: NO_DEVICE
[    6.804261] saa7130[0]: i2c xfer: < 4f ERROR: NO_DEVICE
[    6.804436] saa7130[0]: i2c xfer: < 51 ERROR: NO_DEVICE
[    6.804612] saa7130[0]: i2c xfer: < 53 ERROR: NO_DEVICE
[    6.804787] saa7130[0]: i2c xfer: < 55 ERROR: NO_DEVICE
[    6.804963] saa7130[0]: i2c xfer: < 57 ERROR: NO_DEVICE
[    6.805138] saa7130[0]: i2c xfer: < 59 ERROR: NO_DEVICE
[    6.805314] saa7130[0]: i2c xfer: < 5b ERROR: NO_DEVICE
[    6.805489] saa7130[0]: i2c xfer: < 5d ERROR: NO_DEVICE
[    6.805665] saa7130[0]: i2c xfer: < 5f ERROR: NO_DEVICE
[    6.805841] saa7130[0]: i2c xfer: < 61 ERROR: NO_DEVICE
[    6.806016] saa7130[0]: i2c xfer: < 63 ERROR: NO_DEVICE
[    6.806191] saa7130[0]: i2c xfer: < 65 ERROR: NO_DEVICE
[    6.806367] saa7130[0]: i2c xfer: < 67 ERROR: NO_DEVICE
[    6.806542] saa7130[0]: i2c xfer: < 69 ERROR: NO_DEVICE
[    6.806718] saa7130[0]: i2c xfer: < 6b ERROR: NO_DEVICE
[    6.806893] saa7130[0]: i2c xfer: < 6d ERROR: NO_DEVICE
[    6.807069] saa7130[0]: i2c xfer: < 6f ERROR: NO_DEVICE
[    6.807244] saa7130[0]: i2c xfer: < 71 ERROR: NO_DEVICE
[    6.807420] saa7130[0]: i2c xfer: < 73 ERROR: NO_DEVICE
[    6.807596] saa7130[0]: i2c xfer: < 75 ERROR: NO_DEVICE
[    6.807771] saa7130[0]: i2c xfer: < 77 ERROR: NO_DEVICE
[    6.807946] saa7130[0]: i2c xfer: < 79 ERROR: NO_DEVICE
[    6.808122] saa7130[0]: i2c xfer: < 7b ERROR: NO_DEVICE
[    6.808297] saa7130[0]: i2c xfer: < 7d ERROR: NO_DEVICE
[    6.808473] saa7130[0]: i2c xfer: < 7f ERROR: NO_DEVICE
[    6.808648] saa7130[0]: i2c xfer: < 81 ERROR: NO_DEVICE
[    6.808824] saa7130[0]: i2c xfer: < 83 ERROR: NO_DEVICE
[    6.808999] saa7130[0]: i2c xfer: < 85 ERROR: NO_DEVICE
[    6.809175] saa7130[0]: i2c xfer: < 87 ERROR: NO_DEVICE
[    6.809350] saa7130[0]: i2c xfer: < 89 ERROR: NO_DEVICE
[    6.809526] saa7130[0]: i2c xfer: < 8b ERROR: NO_DEVICE
[    6.809701] saa7130[0]: i2c xfer: < 8d ERROR: NO_DEVICE
[    6.809877] saa7130[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[    6.810063] saa7130[0]: i2c xfer: < 91 ERROR: NO_DEVICE
[    6.810238] saa7130[0]: i2c xfer: < 93 ERROR: NO_DEVICE
[    6.810414] saa7130[0]: i2c xfer: < 95 ERROR: NO_DEVICE
[    6.810589] saa7130[0]: i2c xfer: < 97 ERROR: NO_DEVICE
[    6.810765] saa7130[0]: i2c xfer: < 99 ERROR: NO_DEVICE
[    6.810940] saa7130[0]: i2c xfer: < 9b ERROR: NO_DEVICE
[    6.811116] saa7130[0]: i2c xfer: < 9d ERROR: NO_DEVICE
[    6.811291] saa7130[0]: i2c xfer: < 9f ERROR: NO_DEVICE
[    6.811467] saa7130[0]: i2c xfer: < a1 >
[    6.830029] saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
[    6.830033] saa7130[0]: i2c xfer: < a3 ERROR: NO_DEVICE
[    6.830210] saa7130[0]: i2c xfer: < a5 ERROR: NO_DEVICE
[    6.830364] saa7130[0]: i2c xfer: < a7 ERROR: NO_DEVICE
[    6.830539] saa7130[0]: i2c xfer: < a9 ERROR: NO_DEVICE
[    6.830715] saa7130[0]: i2c xfer: < ab ERROR: NO_DEVICE
[    6.830891] saa7130[0]: i2c xfer: < ad ERROR: NO_DEVICE
[    6.831067] saa7130[0]: i2c xfer: < af ERROR: NO_DEVICE
[    6.831281] saa7130[0]: i2c xfer: < b1 ERROR: NO_DEVICE
[    6.831457] saa7130[0]: i2c xfer: < b3 ERROR: NO_DEVICE
[    6.831633] saa7130[0]: i2c xfer: < b5 ERROR: NO_DEVICE
[    6.831808] saa7130[0]: i2c xfer: < b7 ERROR: NO_DEVICE
[    6.831984] saa7130[0]: i2c xfer: < b9 ERROR: NO_DEVICE
[    6.832159] saa7130[0]: i2c xfer: < bb ERROR: NO_DEVICE
[    6.832334] saa7130[0]: i2c xfer: < bd ERROR: NO_DEVICE
[    6.832510] saa7130[0]: i2c xfer: < bf ERROR: NO_DEVICE
[    6.832685] saa7130[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[    6.832861] saa7130[0]: i2c xfer: < c3 ERROR: NO_DEVICE
[    6.833036] saa7130[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[    6.833212] saa7130[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[    6.833387] saa7130[0]: i2c xfer: < c9 ERROR: NO_DEVICE
[    6.833563] saa7130[0]: i2c xfer: < cb ERROR: NO_DEVICE
[    6.833738] saa7130[0]: i2c xfer: < cd ERROR: NO_DEVICE
[    6.833914] saa7130[0]: i2c xfer: < cf ERROR: NO_DEVICE
[    6.834089] saa7130[0]: i2c xfer: < d1 ERROR: NO_DEVICE
[    6.834265] saa7130[0]: i2c xfer: < d3 ERROR: NO_DEVICE
[    6.834440] saa7130[0]: i2c xfer: < d5 ERROR: NO_DEVICE
[    6.834615] saa7130[0]: i2c xfer: < d7 ERROR: NO_DEVICE
[    6.834791] saa7130[0]: i2c xfer: < d9 ERROR: NO_DEVICE
[    6.834966] saa7130[0]: i2c xfer: < db ERROR: NO_DEVICE
[    6.835142] saa7130[0]: i2c xfer: < dd ERROR: NO_DEVICE
[    6.835317] saa7130[0]: i2c xfer: < df ERROR: NO_DEVICE
[    6.835493] saa7130[0]: i2c xfer: < e1 ERROR: NO_DEVICE
[    6.835668] saa7130[0]: i2c xfer: < e3 ERROR: NO_DEVICE
[    6.835844] saa7130[0]: i2c xfer: < e5 ERROR: NO_DEVICE
[    6.836019] saa7130[0]: i2c xfer: < e7 ERROR: NO_DEVICE
[    6.836195] saa7130[0]: i2c xfer: < e9 ERROR: NO_DEVICE
[    6.836370] saa7130[0]: i2c xfer: < eb ERROR: NO_DEVICE
[    6.836546] saa7130[0]: i2c xfer: < ed ERROR: NO_DEVICE
[    6.836721] saa7130[0]: i2c xfer: < ef ERROR: NO_DEVICE
[    6.836897] saa7130[0]: i2c xfer: < f1 ERROR: NO_DEVICE
[    6.837072] saa7130[0]: i2c xfer: < f3 ERROR: NO_DEVICE
[    6.837248] saa7130[0]: i2c xfer: < f5 ERROR: NO_DEVICE
[    6.837423] saa7130[0]: i2c xfer: < f7 ERROR: NO_DEVICE
[    6.837599] saa7130[0]: i2c xfer: < f9 ERROR: NO_DEVICE
[    6.837774] saa7130[0]: i2c xfer: < fb ERROR: NO_DEVICE
[    6.837950] saa7130[0]: i2c xfer: < fd ERROR: NO_DEVICE
[    6.838125] saa7130[0]: i2c xfer: < ff ERROR: NO_DEVICE
[    6.838333] saa7130[0]: registered device video0 [v4l2]
[    6.838359] saa7130[0]: registered device vbi0
[    6.851697] saa7134 ALSA driver for DMA sound loaded
[    6.851700] saa7130[0]/alsa: Compro VideoMate S350/S300 doesn't support digital audio
[    6.900913] dvb_init() allocating 1 frontend
[    6.937822] saa7130[0]: i2c xfer: < 1c 7e [fe quirk] < 1d =05 >
[    7.063256] saa7130[0]: i2c xfer: < 1c 14 [fe quirk] < 1d =03 >
[    7.080036] saa7130[0]: i2c xfer: < 1c 14 40 >
[    7.100091] saa7130[0]: i2c xfer: < c0 0f [fe quirk] < c1 =81 >
[    7.120106] saa7130[0]: i2c xfer: < 1c 14 [fe quirk] < 1d =43 >
[    7.140098] saa7130[0]: i2c xfer: < 1c 14 00 >
[    7.160100] DVB: registering new adapter (saa7130[0])
[    7.160104] DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
[    7.160414] saa7130[0]: i2c xfer: < 1c 7f 8c >
[    7.180183] saa7130[0]: i2c xfer: < 1c 15 80 >
[    7.200073] saa7130[0]: i2c xfer: < 1c 56 14 12 03 02 01 00 00 00 >
[    7.220073] saa7130[0]: i2c xfer: < 1c 14 80 >
[    7.240073] saa7130[0]: i2c xfer: < 1c 54 80 b0 >
[    7.260095] saa7130[0]: i2c xfer: < 1c 54 00 >
[    7.280043] saa7130[0]: i2c xfer: < 1c 55 00 >
[    7.300094] saa7130[0]: i2c xfer: < 1c 22 b6 73 >
[    7.320085] saa7130[0]: i2c xfer: < 1c 31 32 >
[    7.341911] saa7130[0]: i2c xfer: < 1c 60 33 >
[    7.360076] saa7130[0]: i2c xfer: < 1c 33 8c 98 >
[    7.380044] saa7130[0]: i2c xfer: < 1c 39 69 >
[    7.400076] saa7130[0]: i2c xfer: < 1c 15 80 >
[    7.420097] saa7130[0]: i2c xfer: < 1c 14 00 >
[    7.440160] saa7130[0]: i2c xfer: < 1c 54 0d >
[    7.460055] saa7130[0]: i2c xfer: < 1c 7f [fe quirk] < 1d =8c >
[    7.480115] saa7130[0]: i2c xfer: < 1c 7f 0c >
[    7.500122] saa7130[0]: i2c xfer: < 1c 14 [fe quirk] < 1d =03 >
[    7.520115] saa7130[0]: i2c xfer: < 1c 14 40 >
[    7.540153] saa7130[0]: i2c xfer: < c0 0f 80 >
[    7.560074] saa7130[0]: i2c xfer: < 1c 14 [fe quirk] < 1d =43 >
[    7.580117] saa7130[0]: i2c xfer: < 1c 14 00 >


--=-WMOHxS0tdUgmj/ssKWW0--

