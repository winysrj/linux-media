Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39249 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0IPLaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 07:30:05 -0400
Received: by bwz11 with SMTP id 11so1457637bwz.19
        for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 04:30:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Sep 2010 21:30:03 +1000
Message-ID: <AANLkTi=UNa+aF3631jKSedsdbDNf1DZ2KnSPfyMhpfeZ@mail.gmail.com>
Subject: Dvico Dual Express 2
From: Mark Hetherington <mark@hethos.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've recently obtained a Dvico FusionHDTV DVB-T Dual Express2, and
found it is not the same card as the Dual Express. There is a chance
I've done something particularly silly, but I've tried specifying card
types etc, and so far had no luck. I believe this is a new hardware
revision and currently unsupported. I've made a quick note on the
wiki, but I wasn't sure if I should create a new page separate from
the existing info page in the Dual Express. From memory the card looks
identical to the pictures at
http://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express.

My dmesg looks like:
[   17.112114] cx23885 driver version 0.0.2 loaded
[   17.140399] cx23885 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16
(level, low) -> IRQ 16
[   17.140405] cx23885[0]: Your board isn't known (yet) to the driver.
[   17.140406] cx23885[0]: Try to pick one of the existing card configs via
[   17.140408] cx23885[0]: card=<n> insmod option.  Updating to the latest
[   17.140409] cx23885[0]: version might help as well.
[   17.140412] cx23885[0]: Here is a list of valid choices for the
card=<n> insmod option:
[   17.140414] cx23885[0]:    card=0 -> UNKNOWN/GENERIC
[   17.140416] cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
[   17.140419] cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
[   17.140421] cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
[   17.140423] cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
[   17.140426] cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
[   17.140428] cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
[   17.140430] cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
[   17.140432] cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
[   17.140435] cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
[   17.140437] cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
[   17.140439] cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
[   17.140442] cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
[   17.140444] cx23885[0]:    card=13 -> Compro VideoMate E650F
[   17.140446] cx23885[0]:    card=14 -> TurboSight TBS 6920
[   17.140448] cx23885[0]:    card=15 -> TeVii S470
[   17.140451] cx23885[0]:    card=16 -> DVBWorld DVB-S2 2005
[   17.140453] cx23885[0]:    card=17 -> NetUP Dual DVB-S2 CI
[   17.140455] cx23885[0]:    card=18 -> Hauppauge WinTV-HVR1270
[   17.140457] cx23885[0]:    card=19 -> Hauppauge WinTV-HVR1275
[   17.140460] cx23885[0]:    card=20 -> Hauppauge WinTV-HVR1255
[   17.140462] cx23885[0]:    card=21 -> Hauppauge WinTV-HVR1210
[   17.140464] cx23885[0]:    card=22 -> Mygica X8506 DMB-TH
[   17.140466] cx23885[0]:    card=23 -> Magic-Pro ProHDTV Extreme 2
[   17.140469] cx23885[0]:    card=24 -> Hauppauge WinTV-HVR1850
[   17.140471] cx23885[0]:    card=25 -> Compro VideoMate E800
[   17.140473] cx23885[0]:    card=26 -> Hauppauge WinTV-HVR1290
[   17.140476] cx23885[0]:    card=27 -> Mygica X8558 PRO DMB-TH
[   17.140478] cx23885[0]:    card=28 -> LEADTEK WinFast PxTV1200
[   17.140553] CORE cx23885[0]: subsystem: 18ac:db98, board:
UNKNOWN/GENERIC [card=0,autodetected]
[   17.355341] cx23885_dev_checkrevision() Hardware revision = 0xa5
[   17.355348] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 16,
latency: 0, mmio: 0xf9000000
[   17.355354] cx23885 0000:02:00.0: setting latency timer to 64
[   17.355359] IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  230.677212] cx23885 0000:02:00.0: PCI INT A disabled

Loading the module with card=11 (looks like the most obvious choice) shows:
[113131.257580] cx23885 driver version 0.0.2 loaded
[113131.276294] cx23885 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI
16 (level, low) -> IRQ 16
[113131.276517] CORE cx23885[0]: subsystem: 18ac:db98, board: DViCO
FusionHDTV DVB-T Dual Express [card=11,insmod option]
[113131.512250] cx23885_dvb_register() allocating 1 frontend(s)
[113131.512257] cx23885[0]: cx23885 based dvb card
[113131.569079] cx23885[0]: frontend initialization failed
[113131.569086] cx23885_dvb_register() dvb_register failed err = -1
[113131.569089] cx23885_dev_setup() Failed to register dvb adapters on VID_B
[113131.569091] cx23885_dvb_register() allocating 1 frontend(s)
[113131.569096] cx23885[0]: cx23885 based dvb card
[113131.569492] cx23885[0]: frontend initialization failed
[113131.569494] cx23885_dvb_register() dvb_register failed err = -1
[113131.569497] cx23885_dev_setup() Failed to register dvb on VID_C
[113131.569501] cx23885_dev_checkrevision() Hardware revision = 0xa5
[113131.569508] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 16,
latency: 0, mmio: 0xf9000000
[113131.569516] cx23885 0000:02:00.0: setting latency timer to 64
[113131.569521] IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on
shared IRQs

I've tried a few different card types to see the results, but nothing
much more promising than that.

Is anyone familiar with this board? Any chance anyone has been
tinkering with it?

#lspci -vnn
02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 04)
Subsystem: DViCO Corporation Device [18ac:db98]
Flags: fast devsel, IRQ 16
Memory at f9000000 (64-bit, non-prefetchable) [size=2M]
Capabilities: [40] Express Endpoint, MSI 00
Capabilities: [80] Power Management version 2
Capabilities: [90] Vital Product Data
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Capabilities: [100] Advanced Error Reporting
Capabilities: [200] Virtual Channel

It seems like the DVICO dual express cards being shipped now might all
be this new revision, so it might be worth spending a bit of time on.
I'm happy to assist with more information if anyone is interested,
otherwise I think I'm going to have to do a whole lot of reading (and
tinkering).

Mark
