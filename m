Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout07.plus.net ([84.93.230.235]:38851 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3F1IUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 04:20:00 -0400
Date: Fri, 28 Jun 2013 09:13:53 +0100 (BST)
From: "P.J. Marsh" <pjmarsh@uhf-satcom.com>
To: linux-media@vger.kernel.org
Subject: BTTV card
Message-ID: <alpine.LNX.2.00.1306280911200.28072@sverjnyy.cwz.qlaqaf.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The card type is GeoVision GV800 which is made up of 1 master and 3 slave 
controllers, using BT878 capture chips.

02:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
02:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:04.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
02:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)


[    8.353747] bttv: Bt8xx card found (0).
[    8.362307] bttv 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    8.375254] bttv0: Bt878 (rev 17) at 0000:02:00.0, irq: 17, latency: 
32, mmio: 0xfddff000
[    8.399279] bttv0: subsystem: 800a:763c (UNKNOWN)
[    8.405904] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    8.405915] bttv0: using: Geovision GV-800(S) (master) [card=157,insmod 
option]
[    8.421118] bttv0: gpio: en=00000000, out=00000000 in=00ff28ff [init]
[    8.422718] bttv0: tuner absent
[    8.430398] bttv0: registered device video0
[    8.438438] bttv0: PLL: 28636363 => 35468950 .
[    8.443718] bttv0: registered device vbi0
[    8.455725] bttv0: PLL: 28636363 => 35468950 ..
[    8.457127] bttv0: PLL: 28636363 => 35468950 . ok
[    8.475673]  ok
[    8.500467]  ok
[    8.522681] bttv: Bt8xx card found (1).
[    8.528970] bttv 0000:02:04.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    8.536409] ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
[    8.542033] bttv1: Bt878 (rev 17) at 0000:02:04.0, irq: 17, latency: 
32, mmio: 0xfddfd000
[    8.553156] VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 
22 (level, low) -> IRQ 22
[    8.564883] bttv1: subsystem: 800b:763c (UNKNOWN)
[    8.570814] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    8.570823] bttv1: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    8.583834] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[    8.584063] bttv1: gpio: en=00000000, out=00000000 in=00ff7fff [init]
[    8.585057] bttv1: tuner absent
[    8.592312] bttv1: registered device video1
[    8.599443] bttv1: PLL: 28636363 => 35468950 .
[    8.601057] bttv1: registered device vbi1
[    8.612344] bttv1: PLL: 28636363 => 35468950 ..
[    8.613757] bttv1: PLL: 28636363 => 35468950 . ok
[    8.630062]  ok
[    8.644061]  ok
[    8.658120] bttv: Bt8xx card found (2).
[    8.663159] bttv 0000:02:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    8.668256] bttv2: Bt878 (rev 17) at 0000:02:08.0, irq: 17, latency: 
32, mmio: 0xfddfb000
[    8.678373] bttv2: subsystem: 800c:763c (UNKNOWN)
[    8.683571] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    8.683581] bttv2: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    8.695119] bttv2: gpio: en=00000000, out=00000000 in=00ffbdff [init]
[    8.696122] bttv2: tuner absent
[    8.702843] bttv2: registered device video2
[    8.709604] bttv2: PLL: 28636363 => 35468950 .
[    8.711207] bttv2: registered device vbi2
[    8.722183] bttv2: PLL: 28636363 => 35468950 ..
[    8.723598] bttv2: PLL: 28636363 => 35468950 . ok
[    8.740067]  ok
[    8.754277]  ok
[    8.768148] bttv: Bt8xx card found (3).
[    8.773117] bttv 0000:02:0c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    8.778113] bttv3: Bt878 (rev 17) at 0000:02:0c.0, irq: 17, latency: 
32, mmio: 0xfddf9000
[    8.787938] bttv3: subsystem: 800d:763c (UNKNOWN)
[    8.792821] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    8.792830] bttv3: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    8.803420] bttv3: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    8.803698] bttv3: tuner absent
[    8.809046] bttv3: registered device video3
[    8.814242] bttv3: registered device vbi3
[    8.819155] bttv3: PLL: 28636363 => 35468950 .. ok

regards,

Paul.
--------------------------------------------------------------------
Contributor to: www.uhf-satcom.com - http://twitter.com/UHF_Satcom

UHF Satcom Yahoo Group: http://groups.yahoo.com/group/UHF-Satcom/

IRC - pjm @ #hearsat on irc.starchat.net

Correspondents should note that all communications to this address
are automatically logged, monitored and/or recorded for lawful
or other purposes.

Telephone: 0044 (0)845 193 0050 Skype: M0EYT_Paul
--------------------------------------------------------------------
