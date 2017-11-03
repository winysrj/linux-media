Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:56718 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755863AbdKCOpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 10:45:08 -0400
Received: by mail-oi0-f68.google.com with SMTP id v9so2189474oif.13
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 07:45:08 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 3 Nov 2017 15:45:07 +0100
Message-ID: <CAAeHK+w+Bc_MTAQSTNhehtMc0A1bz94BgPcoJqL0n=tY7nde8A@mail.gmail.com>
Subject: net/media/em28xx: use-after-free in v4l2_fh_init
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

On commit 3a99df9a3d14cd866b5516f8cba515a3bfd554ab (4.14-rc7+).

em28xx 1-1:0.0: analog set to bulk mode.
em28xx 1-1:0.0: Registering V4L2 extension
usb 1-1: USB disconnect, device number 39
em28xx 1-1:0.0: Disconnecting
em28xx 1-1:0.0: reading from i2c device at 0x4a failed (error=-5)
em28xx 1-1:0.0: Config register raw data: 0xffffffed
em28xx 1-1:0.0: AC97 chip type couldn't be determined
em28xx 1-1:0.0: No AC97 audio processor
em28xx 1-1:0.0: failed to create media graph
em28xx 1-1:0.0: V4L2 device video0 deregistered
em28xx 1-1:0.0: Binding DVB extension
==================================================================
BUG: KASAN: use-after-free in v4l2_fh_init+0x239/0x280
Read of size 8 at addr ffff88006aea0798 by task v4l_id/5819

CPU: 0 PID: 5819 Comm: v4l_id Not tainted
4.14.0-rc7-44290-gf28444df2601-dirty #52
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0xe1/0x157 lib/dump_stack.c:52
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 v4l2_fh_init+0x239/0x280 drivers/media/v4l2-core/v4l2-fh.c:33
 v4l2_fh_open+0x76/0xa0 drivers/media/v4l2-core/v4l2-fh.c:70
 em28xx_v4l2_open+0x252/0x6f0 drivers/media/usb/em28xx/em28xx-video.c:2060
 v4l2_open+0x1b7/0x380 drivers/media/v4l2-core/v4l2-dev.c:425
 chrdev_open+0x1db/0x520 fs/char_dev.c:416
 do_dentry_open+0x735/0xe20 fs/open.c:752
 vfs_open+0x13e/0x230 fs/open.c:866
 do_last fs/namei.c:3387
 path_openat+0x722/0x2860 fs/namei.c:3527
 do_filp_open+0x13f/0x1d0 fs/namei.c:3562
 do_sys_open+0x362/0x4c0 fs/open.c:1059
 SYSC_open fs/open.c:1077
 SyS_open+0x32/0x40 fs/open.c:1072
 entry_SYSCALL_64_fastpath+0x23/0xc2 arch/x86/entry/entry_64.S:202
RIP: 0033:0x7f51f3ecb120
RSP: 002b:00007ffc0140cb68 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f51f3ecb120
RDX: 00007f51f4180138 RSI: 0000000000000000 RDI: 00007ffc0140df1e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000400884
R13: 00007ffc0140ccc0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 2263:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11a/0x290 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 em28xx_v4l2_init+0x10c/0x3660 drivers/media/usb/em28xx/em28xx-video.c:2438
 em28xx_init_extension+0x11a/0x190 drivers/media/usb/em28xx/em28xx-core.c:1110
 request_module_async+0x6a/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3161
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Freed by task 2263:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf2/0x2e0 mm/slub.c:3919
 em28xx_free_v4l2 drivers/media/usb/em28xx/em28xx-video.c:2025
 kref_put ./include/linux/kref.h:70
 em28xx_v4l2_init+0x237f/0x3660 drivers/media/usb/em28xx/em28xx-video.c:2789
 em28xx_init_extension+0x11a/0x190 drivers/media/usb/em28xx/em28xx-core.c:1110
 request_module_async+0x6a/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3161
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

The buggy address belongs to the object at ffff88006aea0000
 which belongs to the cache kmalloc-8192 of size 8192
The buggy address is located 1944 bytes inside of
 8192-byte region [ffff88006aea0000, ffff88006aea2000)
The buggy address belongs to the page:
page:ffffea0001aba800 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000180030003
raw: 0000000000000000 0000000100000001 ffff88006c402a80 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006aea0680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006aea0700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88006aea0780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88006aea0800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006aea0880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
