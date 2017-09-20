Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:49807 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdITSyJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 14:54:09 -0400
Received: by mail-io0-f179.google.com with SMTP id 21so5770265iof.6
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 11:54:09 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 20 Sep 2017 20:54:08 +0200
Message-ID: <CAAeHK+zQm2DJT-1POrnB+1OFGVdTCOg+rpZODW=UPyLM1Ysr=g@mail.gmail.com>
Subject: usb/media/cx231xx: null-ptr-deref in cx231xx_usb_probe
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).

The null-ptr-deref happens on assoc_desc->bFirstInterface, where
assoc_desc = udev->actconfig->intf_assoc[0]. There seems to be no
check that the device actually contains an Interface Association
Descriptor.

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc1-42251-gebb2c2437d80 #206
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006bb26300 task.stack: ffff88006bba0000
RIP: 0010:cx231xx_usb_probe+0x96a/0x32e0
drivers/media/usb/cx231xx/cx231xx-cards.c:1687
RSP: 0018:ffff88006bba63e0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 00000000fffff8f8
RDX: 0000000000000000 RSI: ffffffff86876d60 RDI: 0000000000000002
RBP: ffff88006bba65e8 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff870a62e0
R13: ffff88005ba70028 R14: ffff880062c9aa80 R15: ffff880062c9b018
FS:  0000000000000000(0000) GS:ffff88006c600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f83211b5518 CR3: 000000005b9dc000 CR4: 00000000000006f0
Call Trace:
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
Code: 18 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 aa 28 00 00 48 b8 00
00 00 00 00 fc ff df 48 8b 5b 18 48 8d 7b 02 48 89 fa 48 c1 ea 03 <0f>
b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 50 28 00
RIP: cx231xx_usb_probe+0x96a/0x32e0 RSP: ffff88006bba63e0
