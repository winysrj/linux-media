Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:38168 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdKUNvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 08:51:53 -0500
Received: by mail-ot0-f171.google.com with SMTP id b49so10558586otj.5
        for <linux-media@vger.kernel.org>; Tue, 21 Nov 2017 05:51:52 -0800 (PST)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 21 Nov 2017 14:51:51 +0100
Message-ID: <CAAeHK+ymo-iNX82-Ff9xdhf-jyTqAKxgvRAz_FYcNdHVCmqLgw@mail.gmail.com>
Subject: usb/media/em28xx: use-after-free in dvb_unregister_frontend
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Scheller <d.scheller@gmx.net>,
        Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit e1d1ea549b57790a3d8cf6300e6ef86118d692a3 (4.15-rc1).

em28xx 1-1:9.0: Disconnecting
tc90522 1-0015: Toshiba TC90522 attached.
qm1d1c0042 2-0061: Sharp QM1D1C0042 attached.
dvbdev: DVB: registering new adapter (1-1:9.0)
em28xx 1-1:9.0: DVB: registering adapter 0 frontend 0 (Toshiba TC90522
ISDB-S module)...
dvbdev: dvb_create_media_entity: media entity 'Toshiba TC90522 ISDB-S
module' registered.
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
em28xx 1-1:9.0: DVB extension successfully initialized
em28xx 1-1:9.0: Remote control support is not available for this card.
em28xx 1-1:9.0: Closing DVB extension
==================================================================
BUG: KASAN: use-after-free in dvb_unregister_frontend+0x8f/0xa0
Read of size 8 at addr ffff880067853628 by task kworker/0:3/3182

CPU: 0 PID: 3182 Comm: kworker/0:3 Not tainted 4.14.0-57501-g9284d204d604 #119
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 dvb_unregister_frontend+0x8f/0xa0 drivers/media/dvb-core/dvb_frontend.c:2768
 em28xx_unregister_dvb drivers/media/usb/em28xx/em28xx-dvb.c:1122
 em28xx_dvb_fini+0x62d/0x8e0 drivers/media/usb/em28xx/em28xx-dvb.c:2129
 em28xx_close_extension+0x71/0x220 drivers/media/usb/em28xx/em28xx-core.c:1122
 em28xx_usb_disconnect+0xd7/0x130 drivers/media/usb/em28xx/em28xx-cards.c:3763
 usb_unbind_interface+0x1b6/0x950 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:870
 device_release_driver_internal+0x563/0x630 drivers/base/dd.c:903
 device_release_driver+0x1e/0x30 drivers/base/dd.c:928
 bus_remove_device+0x2fc/0x4b0 drivers/base/bus.c:565
 device_del+0x39f/0xa70 drivers/base/core.c:1984
 usb_disable_device+0x223/0x710 drivers/usb/core/message.c:1205
 usb_disconnect+0x285/0x7f0 drivers/usb/core/hub.c:2205
 hub_port_connect drivers/usb/core/hub.c:4851
 hub_port_connect_change drivers/usb/core/hub.c:5106
 port_event drivers/usb/core/hub.c:5212
 hub_event_impl+0x10f0/0x3440 drivers/usb/core/hub.c:5324
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5222
 process_one_work+0x944/0x15f0 kernel/workqueue.c:2112
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2246
 kthread+0x367/0x420 kernel/kthread.c:238
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437

Allocated by task 25:
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11a/0x290 mm/slub.c:2752
 kmalloc ./include/linux/slab.h:499
 kzalloc ./include/linux/slab.h:688
 tc90522_probe+0x3b/0x440 drivers/media/dvb-frontends/tc90522.c:777
 i2c_device_probe+0x5bf/0x7e0 drivers/i2c/i2c-core-base.c:408
 really_probe drivers/base/dd.c:424
 driver_probe_device+0x564/0x820 drivers/base/dd.c:566
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:662
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1ab/0x2a0 drivers/base/dd.c:719
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:766
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 device_register+0x22/0x30 drivers/base/core.c:1905
 i2c_new_device+0x5dd/0xdc0 drivers/i2c/i2c-core-base.c:792
 em28xx_dvb_init.part.4+0x49f4/0x91d0 drivers/media/usb/em28xx/em28xx-dvb.c:1860
 em28xx_dvb_init+0xb8/0xe0 drivers/media/usb/em28xx/em28xx-dvb.c:2062
 em28xx_init_extension+0x11a/0x190 drivers/media/usb/em28xx/em28xx-core.c:1110
 request_module_async+0x6a/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3161
 process_one_work+0x944/0x15f0 kernel/workqueue.c:2112
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2246
 kthread+0x367/0x420 kernel/kthread.c:238
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437

Freed by task 3182:
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1391
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2968
 kfree+0xf2/0x2e0 mm/slub.c:3899
 tc90522_remove+0x4b/0x60 drivers/media/dvb-frontends/tc90522.c:814
 i2c_device_remove+0xc8/0x120 drivers/i2c/i2c-core-base.c:438
 __device_release_driver drivers/base/dd.c:868
 device_release_driver_internal+0x34e/0x630 drivers/base/dd.c:903
 device_release_driver+0x1e/0x30 drivers/base/dd.c:928
 bus_remove_device+0x2fc/0x4b0 drivers/base/bus.c:565
 device_del+0x39f/0xa70 drivers/base/core.c:1984
 device_unregister+0x1a/0x40 drivers/base/core.c:2020
 i2c_unregister_device.part.41+0xfd/0x130 drivers/i2c/i2c-core-base.c:828
 i2c_unregister_device+0x24/0x30 drivers/i2c/i2c-core-base.c:822
 em28xx_dvb_fini+0x543/0x8e0 drivers/media/usb/em28xx/em28xx-dvb.c:2126
 em28xx_close_extension+0x71/0x220 drivers/media/usb/em28xx/em28xx-core.c:1122
 em28xx_usb_disconnect+0xd7/0x130 drivers/media/usb/em28xx/em28xx-cards.c:3763
 usb_unbind_interface+0x1b6/0x950 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:870
 device_release_driver_internal+0x563/0x630 drivers/base/dd.c:903
 device_release_driver+0x1e/0x30 drivers/base/dd.c:928
 bus_remove_device+0x2fc/0x4b0 drivers/base/bus.c:565
 device_del+0x39f/0xa70 drivers/base/core.c:1984
 usb_disable_device+0x223/0x710 drivers/usb/core/message.c:1205
 usb_disconnect+0x285/0x7f0 drivers/usb/core/hub.c:2205
 hub_port_connect drivers/usb/core/hub.c:4851
 hub_port_connect_change drivers/usb/core/hub.c:5106
 port_event drivers/usb/core/hub.c:5212
 hub_event_impl+0x10f0/0x3440 drivers/usb/core/hub.c:5324
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5222
 process_one_work+0x944/0x15f0 kernel/workqueue.c:2112
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2246
 kthread+0x367/0x420 kernel/kthread.c:238
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437

The buggy address belongs to the object at ffff880067853300
 which belongs to the cache kmalloc-4096 of size 4096
The buggy address is located 808 bytes inside of
 4096-byte region [ffff880067853300, ffff880067854300)
The buggy address belongs to the page:
page:ffffea00019e1400 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000100070007
raw: dead000000000100 dead000000000200 ffff88006c802c00 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880067853500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880067853580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff880067853600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff880067853680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880067853700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
