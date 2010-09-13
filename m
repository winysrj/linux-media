Return-path: <mchehab@pedra>
Received: from graze.net ([71.162.143.10]:38704 "HELO graze.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754853Ab0IMUHh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 16:07:37 -0400
Received: from graze.net (localhost.localdomain [127.0.0.1])
	by graze.net (8.13.1/8.13.1) with ESMTP id o8DK7ZTR010861
	for <linux-media@vger.kernel.org>; Mon, 13 Sep 2010 16:07:35 -0400
Date: Mon, 13 Sep 2010 16:07:34 -0400
From: "Brian C. Huffman" <bhuffman@graze.net>
To: linux-media@vger.kernel.org
Message-ID: <30870750.411284408454843.JavaMail.root@graze.net>
Subject: bt878 irq PABORT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have a DVICO Fusion 5 Lite DVB card and after switching to a new 
motherboard, I'm getting the following errors in my messages along with 
corrupted a/v output:

bt878(0): irq PABORT risc_pc=35660000
<...on and on...>

Here's the snippit of the config from messages:
Sep 12 20:02:28 baavo kernel: bttv: Bt8xx card found (0).
Sep 12 20:02:28 baavo kernel: ivtv: End initialization
Sep 12 20:02:28 baavo kernel: bttv 0000:08:03.0: enabling device (0000 -> 0002)
Sep 12 20:02:28 baavo kernel: bttv 0000:08:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Sep 12 20:02:28 baavo kernel: bttv0: Bt878 (rev 17) at 0000:08:03.0, irq: 19, latency: 32, mmio: 0xe8001000
Sep 12 20:02:28 baavo kernel: bttv0: detected: DViCO FusionHDTV 5 Lite [card=135], PCI subsystem ID is 18ac:d500
Sep 12 20:02:28 baavo kernel: bttv0: using: DViCO FusionHDTV 5 Lite [card=135,autodetected]
Sep 12 20:02:28 baavo kernel: IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
Sep 12 20:02:28 baavo kernel: bttv0: tuner type=64
Sep 12 20:02:28 baavo kernel: bttv0: audio absent, no audio device found!
Sep 12 20:02:28 baavo kernel: tuner 3-0043: chip found @ 0x86 (bt878 #0 [sw])
Sep 12 20:02:28 baavo kernel: tda9887 3-0043: creating new instance
Sep 12 20:02:28 baavo kernel: tda9887 3-0043: tda988[5/6/7] found
Sep 12 20:02:28 baavo kernel: tuner 3-0061: chip found @ 0xc2 (bt878 #0 [sw])
Sep 12 20:02:28 baavo kernel: tuner-simple 3-0061: creating new instance
Sep 12 20:02:28 baavo kernel: tuner-simple 3-0061: type set to 64 (LG TDVS-H06xF)
Sep 12 20:02:28 baavo kernel: bttv0: registered device video2
Sep 12 20:02:28 baavo kernel: bttv0: registered device vbi0
Sep 12 20:02:28 baavo kernel: bttv0: add subdevice "dvb0"
Sep 12 20:02:28 baavo kernel: ICE1712 0000:08:00.0: enabling device (0000 -> 0001)
Sep 12 20:02:28 baavo kernel: ICE1712 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep 12 20:02:28 baavo kernel: bt878: AUDIO driver version 0.0.0 loaded
Sep 12 20:02:28 baavo kernel: bt878: Bt878 AUDIO function found (0).
Sep 12 20:02:28 baavo kernel: bt878 0000:08:03.1: enabling device (0000 -> 0002)
Sep 12 20:02:28 baavo kernel: bt878 0000:08:03.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Sep 12 20:02:28 baavo kernel: bt878_probe: card id=[0xd50018ac],[ DViCO FusionHDTV 5 Lite ] has DVB functions.
Sep 12 20:02:28 baavo kernel: bt878(0): Bt878 (rev 17) at 08:03.1, irq: 19, latency: 32, memory: 0xe8000000
Sep 12 20:02:28 baavo kernel: IRQ 19/bt878: IRQF_DISABLED is not guaranteed on shared IRQs
Sep 12 20:02:28 baavo kernel: DVB: registering new adapter (bttv0)
Sep 12 20:02:28 baavo kernel: tuner-simple 3-0061: attaching existing instance
Sep 12 20:02:28 baavo kernel: tuner-simple 3-0061: type set to 64 (LG TDVS-H06xF)
Sep 12 20:02:28 baavo kernel: DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...

Any help / thoughts are appreciated.

Thanks,
Brian
