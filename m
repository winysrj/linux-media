Return-path: <linux-media-owner@vger.kernel.org>
Received: from [147.213.65.210] ([147.213.65.210]:60246 "EHLO magor.savba.sk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752416Ab1IUJzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 05:55:23 -0400
Date: Wed, 21 Sep 2011 11:32:42 +0200
From: Pavel Andris <utrrandr@savba.sk>
To: linux-media@vger.kernel.org
Subject: frame grabber INT-1461 under Linux
Message-ID: <20110921093242.GA6210@magor.savba.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

dmesg has asked me to mail you. Here's the essential part of the message:

[    1.806495] Linux video capture interface: v2.00
[    1.806607] bttv: driver version 0.9.18 loaded
[    1.806613] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    1.806669] bttv: Bt8xx card found (0).
[    1.806692] bttv 0000:01:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.806710] bttv0: Bt878 (rev 17) at 0000:01:01.0, irq: 17, latency: 64, mmio: 0xfdfff000
[    1.806753] bttv0: subsystem: 1766:ffff (UNKNOWN)
[    1.806758] please mail id, board name and the correct card= insmod option to linux-media@vger.kernel.org
[    1.806766] bttv0: using: GrandTec Multi Capture Card (Bt878) [card=77,insmod option]
[    1.806839] bttv0: gpio: en=00000000, out=00000000 in=00e31fff [init]
[    1.807003] bttv0: tuner absent
[    1.807086] bttv0: registered device video0
[    1.807179] bttv0: registered device vbi0
[    1.807204] bttv0: PLL: 28636363 => 35468950 .. ok
[    1.847974] bt878: AUDIO driver version 0.0.0 loaded

I use bttv.card=77 kernel parameter. With no parameter, the frame
grabber works, but in a strange way.

Info about my frame grabber:

INT-1461
PC/104-Plus Frame Grabber w/ 4 CVBS Inputs & 24 DIO

The INT-1461 video frame grabber is a low-cost, high-performance
solution for capturing analog broadcast signals across the PCI
bus. Based around the Conexant FusionTM 878A video decoder, this
compact PC/104-Plus form factor board supports NTSC, PAL, and SECAM
video formats at capture resolutions of up to 768 x 576 pixels and 30
frames per second. It can also sub-sample, scale, crop, and clip
images at various resolutions and frame rates.

You can easily find more info on the net.

Thank you for writing and supporting media drivers.

Regards,
 
-- 
..........................................................................
Pavel Andris                               | tel: +421 2 5941 1167
Institute of Informatics                   | fax: +421 2 5477 3271
Slovak Academy of Sciences                 | 
Dubravska cesta 9                          | e-mail: utrrandr@savba.sk
SK - 845 07 Bratislava                     |
Slovak republic                            |
..........................................................................

"One hundred thousand lemmings cannot be wrong." 
                                                       Graffiti
..........................................................................
