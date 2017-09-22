Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:51950 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbdIVM43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 08:56:29 -0400
Received: by mail-io0-f169.google.com with SMTP id l15so2796943iol.8
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 05:56:29 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 22 Sep 2017 14:56:27 +0200
Message-ID: <CAAeHK+yQshGzduWP-hpGbbnYh9uHbeODDsEX_K3KmgaNXHNFNQ@mail.gmail.com>
Subject: usb/media/stkwebcam: use-after-free in v4l2_ctrl_handler_free
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Isely <isely@pobox.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
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

==================================================================
BUG: KASAN: use-after-free in v4l2_ctrl_handler_free+0x9e1/0x9f0
Read of size 8 at addr ffff88006a189278 by task kworker/0:1/24

CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc1-42251-gebb2c2437d80 #224
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x22f/0x340 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 v4l2_ctrl_handler_free+0x9e1/0x9f0 drivers/media/v4l2-core/v4l2-ctrls.c:1765
 stk_camera_disconnect+0xf5/0x160 drivers/media/usb/stkwebcam/stk-webcam.c:1392
 usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:861
 device_release_driver_internal+0x4f4/0x5c0 drivers/base/dd.c:893
 device_release_driver+0x1e/0x30 drivers/base/dd.c:918
 bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
 device_del+0x5c4/0xab0 drivers/base/core.c:1985
 usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
 usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
 hub_port_connect drivers/usb/core/hub.c:4754
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Allocated by task 1844:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 stk_camera_probe+0xcf/0xdd0 drivers/media/usb/stkwebcam/stk-webcam.c:1287
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

Freed by task 24:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 stk_v4l_dev_release+0xab/0xe0 drivers/media/usb/stkwebcam/stk-webcam.c:1244
 v4l2_device_release+0x2dc/0x390 drivers/media/v4l2-core/v4l2-dev.c:218
 device_release+0x13f/0x210 drivers/base/core.c:814
 kobject_cleanup lib/kobject.c:648
 kobject_release lib/kobject.c:677
 kref_put ./include/linux/kref.h:70
 kobject_put+0x145/0x240 lib/kobject.c:694
 put_device drivers/base/core.c:1931
 device_unregister+0x2d/0x40 drivers/base/core.c:2021
 video_unregister_device+0x80/0x90 drivers/media/v4l2-core/v4l2-dev.c:1028
 stk_camera_disconnect+0xe9/0x160 drivers/media/usb/stkwebcam/stk-webcam.c:1391
 usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:861
 device_release_driver_internal+0x4f4/0x5c0 drivers/base/dd.c:893
 device_release_driver+0x1e/0x30 drivers/base/dd.c:918
 bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
 device_del+0x5c4/0xab0 drivers/base/core.c:1985
 usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
 usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
 hub_port_connect drivers/usb/core/hub.c:4754
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

The buggy address belongs to the object at ffff88006a189100
 which belongs to the cache kmalloc-4096 of size 4096
The buggy address is located 376 bytes inside of
 4096-byte region [ffff88006a189100, ffff88006a18a100)
The buggy address belongs to the page:
page:ffffea0001a86200 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000100070007
raw: dead000000000100 dead000000000200 ffff88006c402c00 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006a189100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006a189180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88006a189200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88006a189280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006a189300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
