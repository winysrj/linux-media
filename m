Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:53949 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbdITTDX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:03:23 -0400
Received: by mail-io0-f181.google.com with SMTP id q11so5777420ioe.10
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 12:03:22 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 20 Sep 2017 21:03:21 +0200
Message-ID: <CAAeHK+zCsLTS=mce3DemMaCAxgcumgr-jvEsDUYFsuexEhZWSg@mail.gmail.com>
Subject: usb/media/smsusb: null-ptr-deref in smsusb_init_device
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).

The null-ptr-deref happens on
dev->udev->ep_in[1]->desc.wMaxPacketSize. There seems to be no check
on the number of endpoints.

usb 1-1: New USB device found, idVendor=2040, idProduct=5530
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
gadgetfs: configuration #4
smsusb:smsusb_probe: board id=8, interface number 0
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
4.14.0-rc1-42251-gebb2c2437d80-dirty #208
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006bb26300 task.stack: ffff88006bba0000
RIP: 0010:smsusb_init_device+0x2f0/0xd10 drivers/media/usb/siano/smsusb.c:431
RSP: 0018:ffff88006bba6340 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff880063e10000 RCX: 1ffffffff1003ab8
RDX: 0000000000000000 RSI: ffff880063e10bac RDI: 0000000000000004
RBP: ffff88006bba6478 R08: ffffed000d774c84 R09: ffff88006bba63b0
R10: 000000000000000e R11: ffffed000d774c83 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88006840d500
FS:  0000000000000000(0000) GS:ffff88006c600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff57742008 CR3: 0000000067444000 CR4: 00000000000006f0
Call Trace:
 smsusb_probe+0x4f5/0xdc0 drivers/media/usb/siano/smsusb.c:571
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
Code: 00 0f 85 d1 07 00 00 48 8b 85 f0 fe ff ff 4c 8b a0 a8 05 00 00
48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f>
b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RIP: smsusb_init_device+0x2f0/0xd10 RSP: ffff88006bba6340
---[ end trace 1e8f3aa7788a0764 ]---
