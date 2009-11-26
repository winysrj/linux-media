Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmtp14.tin.it ([212.216.176.118]:50277 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZKZLSz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 06:18:55 -0500
Received: from [192.168.1.4] (82.58.77.107) by vsmtp14.tin.it (8.5.113)
        id 4AC9C0AF03DAF8D1 for linux-media@vger.kernel.org; Thu, 26 Nov 2009 12:13:05 +0100
Message-ID: <4B0E62AB.9080008@tin.it>
Date: Thu, 26 Nov 2009 12:12:43 +0100
From: Alan Ferrero <alanf@tin.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Help needed with Hauppauge WinTV HVR-4000
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I posted yesterday the following message to the mythtv-users mailing
list, but they answered me it's more suitable to post it in your mailing
list.

Alan

Hi!

I REALLY need some help with the Hauppauge WinTV HVR-4000
(http://www.hauppauge.it/site/products/data_hvr4000.html).

Days ago I installed Mythbuntu 9.10 (64 bit) on my HTPC, but I soon
found out the tv card didn't work.
Later, I learned that both firmware and driver included in Karmic were
bugged and didn't work.
So I followed the instructions reported at
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000 to
install firmware 1.20.79.0 and instructions reported at
https://bugs.launchpad.net/mythbuntu/+bug/439163?comments=all to install
the patched driver (from: http://hg.kewl.org/v4l-dvb-20091103/).

The end result? Nothing!

Unfortunately, my HVR-4000 doesn't work yet!

Following, the kernel output I get:

[    6.679458] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    6.679901]   alloc irq_desc for 20 on node 0
[    6.679904]   alloc kstat_irqs on node 0
[    6.679910] cx8800 0000:04:05.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[    6.680357] cx88[0]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[    6.680359] cx88[0]: TV tuner type 63, Radio tuner type -1
[    6.744402] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    6.812134] cx88[0]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
[    6.914028] tuner 1-0063: chip found @ 0xc6 (cx88[0])
[    6.934826] cx2388x alsa driver version 0.0.7 loaded
[    6.958954] tveeprom 1-0050: Hauppauge model 69009, rev B2D3, serial#
6246101
[    6.958956] tveeprom 1-0050: MAC address is 00-0D-FE-5F-4E-D5
[    6.958958] tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx
133, type 78)
[    6.958961] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    6.958962] tveeprom 1-0050: audio processor is CX882 (idx 33)
[    6.958964] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[    6.958966] tveeprom 1-0050: has radio, has IR receiver, has no IR
transmitter
[    6.958967] cx88[0]: hauppauge eeprom: model=69009
[    7.089365] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.160819] tuner-simple 1-0063: creating new instance
[    7.160822] tuner-simple 1-0063: type set to 78 (Philips FMD1216MEX
MK3 Hybrid Tuner)
[    7.162725] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:14.4/0000:04:05.0/input/input6
[    7.162762] cx88[0]/0: found at 0000:04:05.0, rev: 5, irq: 20,
latency: 64, mmio: 0xfd000000
[    7.162772] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared
IRQs
[    7.183886] wm8775 1-001b: chip found @ 0x36 (cx88[0])
[    7.191282] cx88[0]/0: registered device video0 [v4l2]
[    7.191296] cx88[0]/0: registered device vbi0
[    7.191312] cx88[0]/0: registered device radio0
[    7.194932] cx88[0]/2: cx2388x 8802 Driver Manager
[    7.194944] cx88-mpeg driver manager 0000:04:05.2: PCI INT A -> GSI
20 (level, low) -> IRQ 20
[    7.194953] cx88[0]/2: found at 0000:04:05.2, rev: 5, irq: 20,
latency: 64, mmio: 0xfb000000
[    7.194957] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared
IRQs
[    7.196646] cx88_audio 0000:04:05.1: PCI INT A -> GSI 20 (level, low)
-> IRQ 20
[    7.196656] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared
IRQs
[    7.196672] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    7.304618] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    7.432244] hda_codec: Unknown model for ALC888, trying auto-probe
from BIOS...
[    7.432438] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:14.2/input/input7
[    7.436550] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    7.436588] HDA Intel 0000:01:05.1: setting latency timer to 64
[    7.484210] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[    7.484213] cx88/2: registering cx8802 driver, type: dvb access: shared
[    7.484216] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[    7.484218] cx88[0]/2: cx2388x based DVB/ATSC card
[    7.484220] cx8802_alloc_frontends() allocating 2 frontend(s)
[    8.195059] cx88[0]/2: dvb_register failed (err = -22)
[    8.195062] cx88[0]/2: cx8802 probe failed, err = -22

As you can see, it reports a problem but I don't know how to fix it.

Also, I strangely have no /dev/dvb/adapter0 in my system.

PLEASE HELP!

Many thanks,

Alan
