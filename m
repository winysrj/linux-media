Return-path: <linux-media-owner@vger.kernel.org>
Received: from colmail.vol.cz ([195.250.128.80]:56197 "EHLO colmail.vol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab0AUIaw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 03:30:52 -0500
Received: from [127.0.0.1] (nat-nop-noc.b1.lan.prg.vol.cz [195.122.204.158])
	by colmail.vol.cz (8.14.3/8.14.3) with ESMTP id o0L856xS055749
	for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 09:05:06 +0100 (CET)
	(envelope-from lim@brdo.cz)
Message-ID: <4B580AB2.6030005@brdo.cz>
Date: Thu, 21 Jan 2010 09:05:06 +0100
From: LiM <lim@brdo.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: bt878 card: no sound and only xvideo support in 2.6.31 bttv 0.9.18
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

i have the same problem as http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11441 also with Hercules Smart TV Stereo ..
works OK audio+video on ..2.6.29-gentoo-r5 + bttv 0.9.17
but NO AUDIO on linux-2.6.31-gentoo-r6 + bttv 0.9.18

cat /etc/modprobe.d/bttv.conf
options tvaudio tda9874a=1 tda9874a_STD=0
options bttv radio=0 card=100 tuner=29 gbuffers=14 i2c_udelay=128 pll=1
autoload=1

2.6.29-gentoo-r5 + bttv 0.9.17
bttv: driver version 0.9.17 loaded
bttv: using 14 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:04:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
bttv0: Bt878 (rev 17) at 0000:04:01.0, irq: 16, latency: 64, mmio:
0xf8ffe000
bttv0: using: Hercules Smart TV Stereo [card=100,insmod option]
IRQ 16/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
tvaudio' 6-0058: found tda9874a.
tvaudio' 6-0058: tda9874h/a found @ 0xb0 (bt878 #0 [sw])
tvaudio' 6-004b: pic16c54 (PV951) found @ 0x96 (bt878 #0 [sw])
bttv0: tuner type=29
bttv0: i2c: checking for TDA9875 @ 0xb0... found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
All bytes are equal. It is not a TEA5767
tuner' 6-0060: chip found @ 0xc0 (bt878 #0 [sw])
tuner-simple 6-0060: creating new instance
tuner-simple 6-0060: type set to 29 (LG PAL_BG (TPI8PSB11D))
bttv0: registered device video1
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok

linux-2.6.31-gentoo-r6 + bttv 0.9.18
bttv: driver version 0.9.18 loaded
bttv: using 14 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:04:01.0, irq: 16, latency: 64, mmio:
0xf8ffe000
bttv0: using: Hercules Smart TV Stereo [card=100,insmod option]
IRQ 16/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: tuner type=29
tvaudio 0-0058: found tda9874a.
tvaudio 0-0058: tda9874h/a found @ 0xb0 (bt878 #0 [sw])
All bytes are equal. It is not a TEA5767
tuner 0-0060: chip found @ 0xc0 (bt878 #0 [sw])
tuner-simple 0-0060: creating new instance
tuner-simple 0-0060: type set to 29 (LG PAL_BG (TPI8PSB11D))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .
bttv0: PLL: 28636363 => 35468950 .
bttv0: PLL: 28636363 => 35468950 . ok


I think problem is in new bttv driver, in modules is new options
audiodev and tvaudio is loading with bttv? and this line:
"tvaudio' 6-004b: pic16c54 (PV951) found @ 0x96 (bt878 #0 [sw])"
is only with older bttv.

modinfo -k 2.6.31-gentoo-r6 bttv
---cut--
parm:           autoload:obsolete option, please do not use anymore (int)
parm:           audiodev:specify audio device:
        -1 = no audio
         0 = autodetect (default)
         1 = msp3400
         2 = tda7432
         3 = tvaudio (array of int)
---cut--

How can i load module with new bttv to get sound working?

rdgs

Michal Vesely

