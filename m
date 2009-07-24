Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:25533 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZGXEJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 00:09:06 -0400
Received: by qw-out-2122.google.com with SMTP id 8so770592qwh.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 21:09:06 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 09:32:14 +0530
Message-ID: <1f8bbe3c0907232102t5c658d66o571571707ecdb1f4@mail.gmail.com>
Subject: Problem with My Tuner card
From: unni krishnan <unnikrishnan.a@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I have some problem in getting my tuner card working in Linux. The
dmesg look like

###########################################
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 804000
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input7
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Items MuchTV Plus / IT-005
[card=37,insmod option]
saa7130[0]: board init: gpio is 810000
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Pinnacle PCTV Stereo
(saa7134) [card=26,insmod option]
saa7130[0]: board init: gpio is 810000
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 810000
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input8
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Items MuchTV Plus / IT-005
[card=37,insmod option]
saa7130[0]: board init: gpio is 810000
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 810000
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input9
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 818000
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input10
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Items MuchTV Plus / IT-005
[card=37,insmod option]
saa7130[0]: board init: gpio is 810000
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Kworld/Tevion V-Stream Xpert
TV PVR7134 [card=59,insmod option]
saa7130[0]: board init: gpio is 810000
input: saa7134 IR (Kworld/Tevion V-Str as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input11
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Kworld/KuroutoShikou
SAA7130-TVPCI [card=10,insmod option]
saa7130[0]: board init: gpio is 804004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Kworld/KuroutoShikou
SAA7130-TVPCI [card=10,insmod option]
saa7130[0]: board init: gpio is 804004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Kworld/KuroutoShikou
SAA7130-TVPCI [card=10,insmod option]
saa7130[0]: board init: gpio is 804004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 804004
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input12
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 810004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input13
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 818004
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input14
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 810004
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input15
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Items MuchTV Plus / IT-005
[card=37,insmod option]
saa7130[0]: board init: gpio is 810004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 810004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input16
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 55 (TCL 2002MB)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input17
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tda8290: no gate control were provided!
tuner 2-0060: Tuner has no way to set tv freq
tuner 2-0060: Tuner has no way to set tv freq
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner 2-0060: Tuner has no way to set tv freq
tuner 2-0060: Tuner has no way to set tv freq
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input18
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input19
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
simple_tuner_attach: invalid tuner type: 79 (max: 78)
tuner 2-0060: Tuner has no way to set tv freq
tuner 2-0060: Tuner has no way to set tv freq
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner 2-0060: Tuner has no way to set tv freq
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input20
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input21
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 10 (Alps TSBE1)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: EMPRESS [card=4,insmod option]
saa7130[0]: board init: gpio is 818004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 10 (Alps TSBE1)
saa6752hs 2-0020: chip found @ 0x40 (saa7130[0])
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
saa7130[0]: registered device video1 [mpeg]
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView FlyTV Platinum FM /
Gold [card=54,insmod option]
saa7130[0]: board init: gpio is 818004
input: saa7134 IR (LifeView FlyTV Plat as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input22
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 10 (Alps TSBE1)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: Items MuchTV Plus / IT-005
[card=37,insmod option]
saa7130[0]: board init: gpio is 810004
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 10 (Alps TSBE1)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7130[0]/alsa: Items MuchTV Plus / IT-005 doesn't support digital audio
saa7134 ALSA driver for DMA sound unloaded
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 810004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input23
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 55 (TCL 2002MB)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input24
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 18, latency: 64, mmio:
0xdffff800
saa7130[0]: subsystem: 1131:0000, board: LifeView/Typhoon FlyVIDEO2000
[card=3,insmod option]
saa7130[0]: board init: gpio is 818004
saa7130[0]: there are different flyvideo cards with different tuners
saa7130[0]: out there, you might have to use the tuner=<nr> insmod
saa7130[0]: option to override the default value.
input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:04.0/0000:01:07.0/input/input25
IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7130[0]: Huh, no eeprom present (err=-5)?
All bytes are equal. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7130[0])
tuner-simple 2-0060: creating new instance
tuner-simple 2-0060: type set to 69 (Tena TNF 5335 and similar models)
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
tuner-simple 2-0060: destroying instance
###########################################

Other informations are :

###########################################
[root@arch ~]# lspci | grep -i saa
01:07.0 Multimedia controller: Philips Semiconductors SAA7130 Video
Broadcast Decoder (rev 01)
[root@arch ~]#
###########################################

I tried many options like

modprobe saa7134 card=54 tuner=5

But I am not able to get sound and video at same time. Some times I
will get video but no sound and in other times I amy get sound without
video. Please help.

-- 
---------------------
With regards,
Unni

"A candle loses nothing by lighting another candle"
