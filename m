Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.41.247.30]:51394 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753543Ab1IUSLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 14:11:07 -0400
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Pavel Andris'" <utrrandr@savba.sk>, <linux-media@vger.kernel.org>
References: <20110921093242.GA6210@magor.savba.sk>
In-Reply-To: <20110921093242.GA6210@magor.savba.sk>
Subject: RE: frame grabber INT-1461 under Linux
Date: Wed, 21 Sep 2011 11:02:42 -0700
Message-ID: <009401cc7888$a8ef1d30$facd5790$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What's strange? card=77 is for "GrandTec Multi Capture Card (Bt878)",
according to the
"http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/CARD
LIST.bttv". Sensoray has a Model 311
(http://www.sensoray.com/products/311.htm), with card=73. I knew that the
INT-1461 is very similar to Sensoray's Model 311. So, you may try card=73.


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Pavel Andris
Sent: Wednesday, September 21, 2011 2:33 AM
To: linux-media@vger.kernel.org
Subject: frame grabber INT-1461 under Linux

Hi,

dmesg has asked me to mail you. Here's the essential part of the message:

[    1.806495] Linux video capture interface: v2.00
[    1.806607] bttv: driver version 0.9.18 loaded
[    1.806613] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    1.806669] bttv: Bt8xx card found (0).
[    1.806692] bttv 0000:01:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.806710] bttv0: Bt878 (rev 17) at 0000:01:01.0, irq: 17, latency: 64,
mmio: 0xfdfff000
[    1.806753] bttv0: subsystem: 1766:ffff (UNKNOWN)
[    1.806758] please mail id, board name and the correct card= insmod
option to linux-media@vger.kernel.org
[    1.806766] bttv0: using: GrandTec Multi Capture Card (Bt878)
[card=77,insmod option]
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
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

