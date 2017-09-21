Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:56891 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdIUPjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:39:20 -0400
Received: by mail-io0-f181.google.com with SMTP id m103so11677872iod.13
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 08:39:19 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Thu, 21 Sep 2017 17:39:18 +0200
Message-ID: <CAAeHK+wAzr0L1qYZT4VQh5nGOOwSYVR8hQE8J+TtNf4Uko-E1g@mail.gmail.com>
Subject: usb/media/smsusb: use-after-free in worker_thread
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

smsusb:smsusb_probe: board id=1, interface number 0
smsusb:siano_media_device_register: media controller created
smsusb:smsusb1_detectmode: product string not found
smsmdtv:smscore_set_device_mode: return error code -22.
smsmdtv:smscore_start_device: set device mode failed , rc -22
smsusb:smsusb_init_device: smscore_start_device(...) failed
smsusb:smsusb_onresponse: error, urb status -2, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
smsusb:smsusb_probe: Device initialized with return code -22
==================================================================
BUG: KASAN: use-after-free in worker_thread+0x1468/0x1850
Read of size 8 at addr ffff880063be11f0 by task kworker/1:1/1152

CPU: 1 PID: 1152 Comm: kworker/1:1 Not tainted
4.14.0-rc1-42251-gebb2c2437d80 #215
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x22f/0x340 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 worker_thread+0x1468/0x1850 kernel/workqueue.c:2251
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Allocated by task 1848:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 smsusb_init_device+0xd5/0xd10 drivers/media/usb/siano/smsusb.c:407
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

Freed by task 1848:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 smsusb_term_device+0xd2/0x130 drivers/media/usb/siano/smsusb.c:363
 smsusb_init_device+0xd03/0xd10 drivers/media/usb/siano/smsusb.c:492
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

The buggy address belongs to the object at ffff880063be1100
 which belongs to the cache kmalloc-4096 of size 4096
The buggy address is located 240 bytes inside of
 4096-byte region [ffff880063be1100, ffff880063be2100)
The buggy address belongs to the page:
page:ffffea00018ef800 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000180070007
raw: 0000000000000000 0000000100000001 ffff88006c402c00 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880063be1080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff880063be1100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff880063be1180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff880063be1200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880063be1280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
