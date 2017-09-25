Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:53902 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934808AbdIYMj6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 08:39:58 -0400
Received: by mail-oi0-f42.google.com with SMTP id j126so6640902oia.10
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 05:39:58 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 25 Sep 2017 14:39:57 +0200
Message-ID: <CAAeHK+xrQtsE8vSoxXRidXhXk+Dj-tF0cQ9jEDwH_E+fX0mP0A@mail.gmail.com>
Subject: usb/media/lmedm04: GPF in lme2510_int_read/usb_pipe_endpoint
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).

usb 1-1: new full-speed USB device number 2 using dummy_hcd
gadgetfs: connected
gadgetfs: disconnected
gadgetfs: connected
usb 1-1: config 63 interface 0 altsetting 32 endpoint 0x7 has invalid
maxpacket 476, setting to 64
usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
with address 0x0, skipping
usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
with address 0xE7, skipping
usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
with address 0x7F, skipping
usb 1-1: config 63 interface 0 has no altsetting 0
usb 1-1: New USB device found, idVendor=3344, idProduct=22f0
usb 1-1: New USB device strings: Mfr=255, Product=0, SerialNumber=8
usb 1-1: Manufacturer: a
usb 1-1: SerialNumber: a
gadgetfs: configuration #63
gadgetfs: configuration #63
usb 1-1: selecting invalid altsetting 1
LME2510(C): Firmware Status: 4 (61)
usb 1-1: dvb_usb_v2: found a 'DM04_LME2510C_DVB-S RS2000' in warm state
usb 1-1: dvb_usb_v2: will use the device's hardware PID filter (table count: 15)
dvbdev: DVB: registering new adapter (DM04_LME2510C_DVB-S RS2000)
usb 1-1: media controller created
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
LME2510(C): FE Found M88RS2000
ts2020: probe of 0-0060 failed with error -11
usb 1-1: DVB: registering adapter 0 frontend 0 (DM04_LME2510C_DVB-S
RS2000 RS2000)...
dvbdev: dvb_create_media_entity: media entity 'DM04_LME2510C_DVB-S
RS2000 RS2000' registered.
LME2510(C): TUN Found RS2000 tuner
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 0 PID: 1845 Comm: kworker/0:2 Not tainted
4.14.0-rc2-42613-g1488251d1a98 #238
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006b9e18c0 task.stack: ffff880064368000
RIP: 0010:usb_pipe_endpoint ./include/linux/usb.h:1913
RIP: 0010:lme2510_int_read drivers/media/usb/dvb-usb-v2/lmedm04.c:436
RIP: 0010:dm04_lme2510_tuner+0xa38/0xe60
drivers/media/usb/dvb-usb-v2/lmedm04.c:1156
RSP: 0018:ffff88006436e2d0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff1000c86dc5f RCX: 1ffff1000d4b136d
RDX: 0000000000000000 RSI: ffff88006a589b00 RDI: 0000000000000003
RBP: ffff88006436e440 R08: 1ffff1000c86db41 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88006a589b00
R13: ffff880069829f00 R14: ffff8800686d6600 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88006c800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb711d159b8 CR3: 0000000062b33000 CR4: 00000000000006f0
Call Trace:
 dvb_usbv2_adapter_frontend_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:689
 dvb_usbv2_adapter_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:818
 dvb_usbv2_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:881
 dvb_usbv2_probe+0x15b1/0x3310 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:992
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code: ff df 4c 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 51 02 00 00 48 b8
00 00 00 00 00 fc ff df 4d 8b 3f 49 8d 7f 03 48 89 fa 48 c1 ea 03 <0f>
b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 19 02 00
RIP: dm04_lme2510_tuner+0xa38/0xe60 RSP: ffff88006436e2d0
---[ end trace 8adf929c013d2744 ]---
