Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:52718 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbdKFN1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 08:27:31 -0500
Received: by mail-ot0-f194.google.com with SMTP id v105so8469253ota.9
        for <linux-media@vger.kernel.org>; Mon, 06 Nov 2017 05:27:31 -0800 (PST)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 6 Nov 2017 14:27:29 +0100
Message-ID: <CAAeHK+x6mg8uO7mT8Ot--+u55iJFaa__NhbvM-YK2qDQ91HKpw@mail.gmail.com>
Subject: usb/media/tm6000: use-after-free in tm6000_read_write_usb
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
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

usb 1-1: USB disconnect, device number 11
tm6000: disconnecting tm6000 #0
xc2028 0-0061: destroying instance
==================================================================
BUG: KASAN: use-after-free in tm6000_read_write_usb+0x3cd/0x3f0
Read of size 4 at addr ffff8800697c4c80 by task v4l_id/5544

CPU: 1 PID: 5544 Comm: v4l_id Not tainted 4.14.0-rc8-44453-g1fdc1a82c34f #56
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load4_noabort+0x19/0x20 mm/kasan/report.c:429
 tm6000_read_write_usb+0x3cd/0x3f0 drivers/media/usb/tm6000/tm6000-core.c:48
 tm6000_set_reg+0x3d/0x50 drivers/media/usb/tm6000/tm6000-core.c:113
 tm6000_set_standard+0x7f1/0x13dc drivers/media/usb/tm6000/tm6000-stds.c:574
 tm6000_init_analog_mode+0x232/0x990 drivers/media/usb/tm6000/tm6000-core.c:340
 __tm6000_open drivers/media/usb/tm6000/tm6000-video.c:1373
 tm6000_open+0x409/0x830 drivers/media/usb/tm6000/tm6000-video.c:1406
 v4l2_open+0x1b7/0x380 drivers/media/v4l2-core/v4l2-dev.c:425
 chrdev_open+0x1db/0x520 fs/char_dev.c:417
 do_dentry_open+0x735/0xe20 fs/open.c:752
 vfs_open+0x13e/0x230 fs/open.c:866
 do_last fs/namei.c:3388
 path_openat+0x722/0x2860 fs/namei.c:3528
 do_filp_open+0x13f/0x1d0 fs/namei.c:3563
 do_sys_open+0x362/0x4c0 fs/open.c:1059
 SYSC_open fs/open.c:1077
 SyS_open+0x32/0x40 fs/open.c:1072
 entry_SYSCALL_64_fastpath+0x23/0xc2 arch/x86/entry/entry_64.S:203
RIP: 0033:0x7f10089a9120
RSP: 002b:00007ffd20f92098 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f10089a9120
RDX: 00007f1008c5e138 RSI: 0000000000000000 RDI: 00007ffd20f93f27
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000400884
R13: 00007ffd20f921f0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 2263:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11a/0x290 mm/slub.c:2773
 kmalloc ./include/linux/slab.h:494
 kzalloc ./include/linux/slab.h:667
 usb_alloc_dev+0x3a/0xd86 drivers/usb/core/usb.c:561
 hub_port_connect drivers/usb/core/hub.c:4893
 hub_port_connect_change drivers/usb/core/hub.c:5093
 port_event drivers/usb/core/hub.c:5199
 hub_event_impl+0x124b/0x3440 drivers/usb/core/hub.c:5311
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

Freed by task 2263:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1391
 slab_free_freelist_hook mm/slub.c:1413
 slab_free mm/slub.c:2989
 kfree+0xf2/0x2e0 mm/slub.c:3920
 usb_release_dev+0xe3/0x110 drivers/usb/core/usb.c:424
 device_release+0xfc/0x1b0 drivers/base/core.c:812
 kobject_cleanup lib/kobject.c:648
 kobject_release lib/kobject.c:677
 kref_put ./include/linux/kref.h:70
 kobject_put+0x18f/0x240 lib/kobject.c:694
 put_device+0x25/0x30 drivers/base/core.c:1931
 usb_disconnect+0x5de/0x7f0 drivers/usb/core/hub.c:2248
 hub_port_connect drivers/usb/core/hub.c:4838
 hub_port_connect_change drivers/usb/core/hub.c:5093
 port_event drivers/usb/core/hub.c:5199
 hub_event_impl+0x10ec/0x3440 drivers/usb/core/hub.c:5311
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

The buggy address belongs to the object at ffff8800697c4c80
 which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 0 bytes inside of
 2048-byte region [ffff8800697c4c80, ffff8800697c5480)
The buggy address belongs to the page:
page:ffffea0001a5f000 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 00000001000f000f
raw: dead000000000100 dead000000000200 ffff88006c402d80 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8800697c4b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8800697c4c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8800697c4c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8800697c4d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8800697c4d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
