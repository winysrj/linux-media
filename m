Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab1DVVzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 17:55:21 -0400
Received: by iwn34 with SMTP id 34so718253iwn.19
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2011 14:55:20 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 Apr 2011 15:55:20 -0600
Message-ID: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
Subject: Regression with suspend from "msp3400: convert to the new control framework"
From: Jesse Allen <the3dfxdude@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello All,

I have finally spent time to figure out what happened to suspending
with my bttv card. I have traced it to this patch:

msp3400: convert to the new control framework
ebc3bba5833e7021336f09767347a52448a60bc5

This was done by reverting the patch at the head for v2.6.39-git.

The patch seems to cause intermittent suspend issues. When I suspend
and come back, I will typically see this message:
tuner-simple 0-0061: i2c i/o error B: rc == -6 (should be 4)

Roughly means that while trying to set the tuner frequency, the device
was not found. The radio will not work after this happens.

I could not bisect to this patch. It did not seem to be a problem with
2.6.36, but for whatever reason after 2.6.36 it happens more. Between
2.6.36 and 2.6.37rc1 is an oops nightmare. Overall it is intermittent,
requiring multiple suspends to check for it. Roughly, the best way to
reproduce is:
fm on
fm <select frequency>
# Leave on for a while
fm off

Another patch of interest is:
0310871d8f71da4ad8643687fbc40f219a0dac4d

I have reverted both patches on 2.6.38 and will continue to monitor.
But I will need help to debug the problem as I do not know what the
new control framework is supposed to do, nor do I know how this tuner
actually works.

03:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 02)
        Subsystem: Avermedia Technologies Inc Device 0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: bttv
        Kernel modules: bttv

03:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 02)
        Subsystem: Avermedia Technologies Inc Device 0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at fdcfe000 (32-bit, prefetchable) [size=4K]


tuner_simple           12197  1
tuner_types             7925  1 tuner_simple
tuner                  18612  1
tvaudio                21521  0
tda7432                 3288  0
msp3400                24324  0
bttv                   99134  0
i2c_algo_bit            4216  2 radeon,bttv
rtc_cmos                8450  0
v4l2_common             4823  5 tuner,tvaudio,tda7432,msp3400,bttv
rtc_core               12257  1 rtc_cmos
videodev               55859  6 tuner,tvaudio,tda7432,msp3400,bttv,v4l2_common
i2c_piix4               8436  0
rtc_lib                 1710  1 rtc_core
videobuf_dma_sg         6696  1 bttv
videobuf_core          13063  2 bttv,videobuf_dma_sg
btcx_risc               2655  1 bttv
rc_core                12201  1 bttv
parport                24443  2 ppdev,parport_pc
tveeprom               10497  1 bttv



Jesse
