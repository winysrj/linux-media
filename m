Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:10674 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbZKPUKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 15:10:20 -0500
Received: by gv-out-0910.google.com with SMTP id r4so726200gve.37
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 12:10:25 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Nov 2009 13:10:24 -0700
Message-ID: <2df568dc0911161210q563130d7qd133e3cd061a6cd1@mail.gmail.com>
Subject: saa7134 module load problem
From: Gordon Smith <spider.karma+linux-media@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello -

I'm unable to find a working environment for saa7134 based RTD
Technologies VFG7350 (two channel, no tuner) using vanilla kernel.

Last working environment was 2.6.25-gentoo-r7 with V4L changeset c7ca307cd4ac.

I'm currently using buildroot with glibc based busybox initramfs for
an x86 embedded system.
I can build 2.6.27, 2.6.30 or 2.6.31, but not yet 2.6.25.

2.6.27.35 "modprobe saa7134" with changeset c7ca307cd4ac:
    v4l2_common: Unknown symbol v4l2_device_register_subdev
    modprobe: failed to load module v4l2_common: unknown symbol in
module, or unknown parameter

2.6.30.2
Changeset c7ca307cd4ac made it to 2.6.30 mainline and to V4L changeset
e5e3c5df85be.
"modprobe saa7134" result is the same with mainline or either changeset modules:
	[   35.701719] IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
	...
	[   35.867599] IRQ 12/saa7133[1]: IRQF_DISABLED is not guaranteed on
shared IRQs
	...
	[   36.015256] saa7133[1]/core: hwinit2
	[   65.864162] saa7134_empress: gave up waiting for init of module saa7134.
	[   65.864244] saa7134_empress: Unknown symbol saa7134_devlist
	[   95.862494] saa7134_empress: gave up waiting for init of module saa7134.
	[   95.862569] saa7134_empress: Unknown symbol saa7134_s_std_internal
    ...

It appears second call to request_module("saa6752hs") in v4l2-common.c
v4ls_i2c_new_subdev() hangs for a few minutes.
The i2c address (0x42) for both channels is correct.

What could I look at next in either 2.6.30 or 2.6.27?

Note: v4l-dvb tip has much regression WRT this card, so I'm not using it yet.
I include 2.6.30 + e5e3c5df85be dmesg with some personal dprintk output below.

Thank for any help,
Gordon

[   25.189722] saa7130/34: v4l2 driver version 0.2.14 loaded
[   25.189939] saa7133[0]: found at 0000:02:08.0, rev: 17, irq: 11,
latency: 32, mmio: 0x80000000
[   25.190034] saa7133[0]: subsystem: 1435:7350, board: RTD Embedded
Technologies VFG7350 [card=72,autodetected]
[   25.190144] saa7133[0]: board init: gpio is 10000
[   25.190202] saa7133[0]/core: hwinit1
[   25.190282] IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   25.328758] saa7133[0]: i2c eeprom 00: 35 14 50 73 ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.329350] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.329947] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.330531] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.331124] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.331709] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.332303] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.332897] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.333481] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.334073] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.334656] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.335248] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.335845] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.336429] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.337022] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.337607] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.339428] saa7133[0]/core: initdev 2.1.0
[   25.339433] saa7133[0]/core: initdev 2.1.0.0
[   25.339440] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.0:
module=saa6752hs
[   25.347339] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.1
[   25.347350] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.3
[   25.347357] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.4
[   25.347487] saa6752hs 0-0021: chip found @ 0x42 (saa7133[0])
[   25.352754] saa6752hs 0-0021: support AC-3
[   25.352819] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.6
[   25.352826] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.7
[   25.352833] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.8
[   25.352839] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.9
[   25.352846] saa7134 0000:02:08.0/core: v4ls_i2c_new_subdev 1.10
[   25.352853] saa7133[0]/core: initdev 2.1.1
[   25.352859] saa7133[0]/core: request_submodules 1.0
[   25.352864] saa7133[0]/core: request_submodules 1.1
[   25.352873] saa7133[0]/core: initdev 2.1.2
[   25.352879] saa7133[0]/core: initdev 2.1.3
[   25.352885] saa7133[0]/core: initdev 2.1.4
[   25.352936] saa7133[0]/core: initdev 2.1.5
[   25.352941] saa7133[0]/core: initdev 2.1.6
[   25.352947] saa7133[0]/core: initdev 2.1.7
[   25.353419] saa7133[0]: registered device video0 [v4l2]
[   25.353482] saa7133[0]/core: initdev 2.1.8
[   25.360645] saa7133[0]: registered device vbi0
[   25.360725] saa7133[0]/core: initdev 2.1.9
[   25.360732] saa7133[0]/core: initdev 2.1.10
[   25.360737] saa7133[0]/core: initdev 2.1.11
[   25.360848] saa7133[1]: found at 0000:02:09.0, rev: 17, irq: 12,
latency: 32, mmio: 0x80001000
[   25.360945] saa7133[1]: subsystem: 1435:7350, board: RTD Embedded
Technologies VFG7350 [card=72,autodetected]
[   25.361083] saa7133[1]: board init: gpio is 10000
[   25.361142] saa7133[1]/core: hwinit1
[   25.361229] IRQ 12/saa7133[1]: IRQF_DISABLED is not guaranteed on shared IRQs
[   25.499741] saa7133[1]: i2c eeprom 00: 35 14 50 73 ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.500332] saa7133[1]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.500929] saa7133[1]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.501512] saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.502108] saa7133[1]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.502689] saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.503286] saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.503877] saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.504461] saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.505066] saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.505647] saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.506242] saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.506834] saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.507419] saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.508014] saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.508596] saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   25.509198] saa7133[1]/core: hwinit2
[   25.510421] saa7133[1]/core: initdev 2.1.0
[   25.510427] saa7133[1]/core: initdev 2.1.0.0
[   25.510435] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.0:
module=saa6752hs
[   55.357095] saa7134_empress: gave up waiting for init of module saa7134.
[   55.357179] saa7134_empress: Unknown symbol saa7134_devlist
[   85.355429] saa7134_empress: gave up waiting for init of module saa7134.
[   85.355503] saa7134_empress: Unknown symbol saa7134_s_std_internal
[  115.352759] saa7134_empress: gave up waiting for init of module saa7134.
[  115.352828] saa7134_empress: Unknown symbol saa7134_queryctrl
[  145.350097] saa7134_empress: gave up waiting for init of module saa7134.
[  145.350183] saa7134_empress: Unknown symbol saa7134_boards
[  175.347433] saa7134_empress: gave up waiting for init of module saa7134.
[  175.347503] saa7134_empress: Unknown symbol saa7134_ts_register
[  205.346766] saa7134_empress: gave up waiting for init of module saa7134.
[  205.346840] saa7134_empress: Unknown symbol saa7134_ts_qops
[  235.344101] saa7134_empress: gave up waiting for init of module saa7134.
[  235.344185] saa7134_empress: Unknown symbol saa7134_s_ctrl_internal
[  265.342434] saa7134_empress: gave up waiting for init of module saa7134.
[  265.342511] saa7134_empress: Unknown symbol saa7134_g_ctrl_internal
[  295.339772] saa7134_empress: gave up waiting for init of module saa7134.
[  295.339854] saa7134_empress: Unknown symbol saa7134_ts_unregister
[  295.341198] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.1
[  295.341206] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.3
[  295.341213] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.4
[  295.341952] saa6752hs 1-0021: chip found @ 0x42 (saa7133[1])
[  295.346772] saa6752hs 1-0021: support AC-3
[  295.346850] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.6
[  295.346858] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.7
[  295.346864] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.8
[  295.346871] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.9
[  295.346878] saa7134 0000:02:09.0/core: v4ls_i2c_new_subdev 1.10
[  295.346887] saa7133[1]/core: initdev 2.1.1
[  295.346892] saa7133[1]/core: request_submodules 1.0
[  295.346898] saa7133[1]/core: request_submodules 1.1
[  295.346905] saa7133[1]/core: initdev 2.1.2
[  295.346910] saa7133[1]/core: initdev 2.1.3
[  295.346917] saa7133[1]/core: initdev 2.1.4
[  295.347000] saa7133[1]/core: initdev 2.1.5
[  295.347005] saa7133[1]/core: initdev 2.1.6
[  295.347011] saa7133[1]/core: initdev 2.1.7
[  295.352895] saa7133[1]: registered device video1 [v4l2]
[  295.352968] saa7133[1]/core: initdev 2.1.8
[  295.354357] saa7133[1]: registered device vbi1
[  295.354423] saa7133[1]/core: initdev 2.1.9
[  295.354428] saa7133[1]/core: initdev 2.1.10
[  295.354434] saa7133[1]/core: initdev 2.1.11
[  295.413939] saa7134 ALSA driver for DMA sound loaded
[  295.414045] IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  295.414168] saa7133[0]/alsa: saa7133[0] at 0x80000000 irq 11
registered as card -1
[  295.415285] IRQ 12/saa7133[1]: IRQF_DISABLED is not guaranteed on shared IRQs
[  295.415412] saa7133[1]/alsa: saa7133[1] at 0x80001000 irq 12
registered as card -1
[  295.430426] saa7133[0]: registered device video2 [mpeg]
[  295.430672] saa7133[1]: registered device video3 [mpeg]
