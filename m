Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:50762 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752802AbdKFN1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 08:27:38 -0500
Received: by mail-ot0-f196.google.com with SMTP id 15so8476525otj.7
        for <linux-media@vger.kernel.org>; Mon, 06 Nov 2017 05:27:37 -0800 (PST)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 6 Nov 2017 14:27:36 +0100
Message-ID: <CAAeHK+x_sSAVL2sT5dRgHATiFY4+skyG+ZuH+j_=SkAzstT=xw@mail.gmail.com>
Subject: usb/media/technisat: slab-out-of-bounds in technisat_usb2_rc_query
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
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

It seems that there's no check of the received buffer length in
technisat_usb2_get_ir().

==================================================================
BUG: KASAN: slab-out-of-bounds in technisat_usb2_rc_query+0x5a2/0x5c0
Read of size 1 at addr ffff880064457230 by task kworker/1:2/2650

CPU: 1 PID: 2650 Comm: kworker/1:2 Not tainted
4.14.0-rc8-44453-g1fdc1a82c34f #56
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: events dvb_usb_read_remote_control
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load1_noabort+0x19/0x20 mm/kasan/report.c:427
 technisat_usb2_get_ir drivers/media/usb/dvb-usb/technisat-usb2.c:663
 technisat_usb2_rc_query+0x5a2/0x5c0
drivers/media/usb/dvb-usb/technisat-usb2.c:678
 dvb_usb_read_remote_control+0xb6/0x150
drivers/media/usb/dvb-usb/dvb-usb-remote.c:261
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

Allocated by task 40:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 __kmalloc+0x1bc/0x300 mm/slub.c:3783
 kmalloc ./include/linux/slab.h:499
 kzalloc ./include/linux/slab.h:667
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:152
 dvb_usb_device_init.cold.7+0x2d7/0x1029
drivers/media/usb/dvb-usb/dvb-usb-init.c:277
 technisat_usb2_probe+0x36/0x270 drivers/media/usb/dvb-usb/technisat-usb2.c:762
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

Freed by task 5251:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1391
 slab_free_freelist_hook mm/slub.c:1413
 slab_free mm/slub.c:2989
 kfree+0xf2/0x2e0 mm/slub.c:3920
 seq_release fs/seq_file.c:366
 single_release+0x85/0xb0 fs/seq_file.c:602
 close_pdeo.part.1+0xe6/0x2e0 fs/proc/inode.c:165
 close_pdeo+0xd9/0x100 fs/proc/inode.c:173
 proc_reg_release+0x130/0x170 fs/proc/inode.c:376
 __fput+0x2b6/0x730 fs/file_table.c:210
 ____fput+0x1a/0x20 fs/file_table.c:244
 task_work_run+0x13d/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume ./include/linux/tracehook.h:191
 exit_to_usermode_loop+0xb9/0x190 arch/x86/entry/common.c:162
 prepare_exit_to_usermode arch/x86/entry/common.c:197
 syscall_return_slowpath+0x21a/0x260 arch/x86/entry/common.c:266
 entry_SYSCALL_64_fastpath+0xc0/0xc2 arch/x86/entry/entry_64.S:239

The buggy address belongs to the object at ffff880064457140
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 240 bytes inside of
 256-byte region [ffff880064457140, ffff880064457240)
The buggy address belongs to the page:
page:ffffea00019115c0 count:1 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000100(slab)
raw: 0100000000000100 0000000000000000 0000000000000000 00000001000c000c
raw: ffffea000187d640 0000000600000006 ffff88006c403200 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880064457100: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
 ffff880064457180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff880064457200: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
                                     ^
 ffff880064457280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880064457300: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================
