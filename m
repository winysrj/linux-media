Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:43289 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbdKFN1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 08:27:23 -0500
Received: by mail-oi0-f52.google.com with SMTP id c77so7129915oig.0
        for <linux-media@vger.kernel.org>; Mon, 06 Nov 2017 05:27:23 -0800 (PST)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 6 Nov 2017 14:27:21 +0100
Message-ID: <CAAeHK+yogMk_eSykQtq0MZB_C_0EyNtDvPUDB2oEb9zg1cx7iQ@mail.gmail.com>
Subject: usb/media/uvc: slab-out-of-bounds in uvc_probe
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

On commit 39dae59d66acd86d1de24294bd2f343fd5e7a625 (4.14-rc8).

It seems that type == UVC_ITT_CAMERA | 0x8000, that's why the (type ==
UVC_ITT_CAMERA) check fails and (UVC_ENTITY_TYPE(term) ==
UVC_ITT_CAMERA) passes, so len ends up being 8 instead of 15.

==================================================================
BUG: KASAN: slab-out-of-bounds in uvc_probe+0x6469/0x6dd0
Read of size 2 at addr ffff88006975864e by task kworker/1:1/33

CPU: 1 PID: 33 Comm: kworker/1:1 Not tainted 4.14.0-rc8-44453-g1fdc1a82c34f #56
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load2_noabort+0x19/0x20 mm/kasan/report.c:428
 __le16_to_cpup ./include/uapi/linux/byteorder/little_endian.h:66
 get_unaligned_le16 ./include/linux/unaligned/access_ok.h:10
 uvc_parse_standard_control drivers/media/usb/uvc/uvc_driver.c:1104
 uvc_parse_control drivers/media/usb/uvc/uvc_driver.c:1281
 uvc_probe+0x6469/0x6dd0 drivers/media/usb/uvc/uvc_driver.c:2064
 usb_probe_interface+0x324/0x940 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x522/0x740 drivers/base/dd.c:557
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:653
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1a8/0x2a0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_set_configuration+0xd4f/0x17a0 drivers/usb/core/message.c:1932
 generic_probe+0xbb/0x120 drivers/usb/core/generic.c:174
 usb_probe_device+0xab/0x100 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x522/0x740 drivers/base/dd.c:557
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:653
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1a8/0x2a0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_new_device+0x7fa/0x1090 drivers/usb/core/hub.c:2538
 hub_port_connect drivers/usb/core/hub.c:4987
 hub_port_connect_change drivers/usb/core/hub.c:5093
 port_event drivers/usb/core/hub.c:5199
 hub_event_impl+0x17b8/0x3440 drivers/usb/core/hub.c:5311
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

Allocated by task 33:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 __kmalloc+0x1bc/0x300 mm/slub.c:3783
 kmalloc ./include/linux/slab.h:499
 usb_get_configuration+0x299/0x4e60 drivers/usb/core/config.c:856
 usb_enumerate_device drivers/usb/core/hub.c:2371
 usb_new_device+0xab1/0x1090 drivers/usb/core/hub.c:2507
 hub_port_connect drivers/usb/core/hub.c:4987
 hub_port_connect_change drivers/usb/core/hub.c:5093
 port_event drivers/usb/core/hub.c:5199
 hub_event_impl+0x17b8/0x3440 drivers/usb/core/hub.c:5311
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

Freed by task 1:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1391
 slab_free_freelist_hook mm/slub.c:1413
 slab_free mm/slub.c:2989
 kfree+0xf2/0x2e0 mm/slub.c:3920
 kobject_uevent_env+0x249/0xd40 lib/kobject_uevent.c:533
 kobject_uevent+0x1f/0x30 lib/kobject_uevent.c:550
 tty_register_device_attr+0x505/0x650 drivers/tty/tty_io.c:2976
 tty_register_device drivers/tty/tty_io.c:2889
 tty_register_driver+0x3ed/0x770 drivers/tty/tty_io.c:3160
 vty_init+0x337/0x374 drivers/tty/vt/vt.c:3100
 tty_init+0x192/0x197 drivers/tty/tty_io.c:3318
 chr_dev_init+0x14b/0x15d drivers/char/mem.c:921
 do_one_initcall+0x6d/0x177 init/main.c:826
 do_initcall_level init/main.c:892
 do_initcalls init/main.c:900
 do_basic_setup init/main.c:918
 kernel_init_freeable+0x3b5/0x49e init/main.c:1066
 kernel_init+0x16/0x1b7 init/main.c:993
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

The buggy address belongs to the object at ffff880069758630
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 30 bytes inside of
 32-byte region [ffff880069758630, ffff880069758650)
The buggy address belongs to the page:
page:ffffea0001a5d600 count:1 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000100(slab)
raw: 0100000000000100 0000000000000000 0000000000000000 0000000180550055
raw: dead000000000100 dead000000000200 ffff88006c403980 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880069758500: fc fc fb fb fb fb fc fc fb fb fb fb fc fc fb fb
 ffff880069758580: fb fb fc fc fb fb fb fb fc fc fb fb fb fb fc fc
>ffff880069758600: fb fb fb fb fc fc 00 00 00 06 fc fc fb fb fb fb
                                              ^
 ffff880069758680: fc fc fb fb fb fb fc fc fb fb fb fb fc fc fb fb
 ffff880069758700: fb fb fc fc fb fb fb fb fc fc fb fb fb fb fc fc
==================================================================
