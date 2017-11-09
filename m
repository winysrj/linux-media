Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:48832 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753227AbdKINH3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Nov 2017 08:07:29 -0500
Received: by mail-oi0-f67.google.com with SMTP id b189so3043554oia.5
        for <linux-media@vger.kernel.org>; Thu, 09 Nov 2017 05:07:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <47c1c53ffe47fbd34a3f1aae92391e7ff5a0aab8.1510205498.git.arvind.yadav.cs@gmail.com>
References: <47c1c53ffe47fbd34a3f1aae92391e7ff5a0aab8.1510205498.git.arvind.yadav.cs@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Thu, 9 Nov 2017 14:07:28 +0100
Message-ID: <CAAeHK+yvD0anMzwDin9+Yxnn0HqZoE40L8ou6QpbzA-7yghf7w@mail.gmail.com>
Subject: Re: [RFT] [media] em28xx: Fix use-after-free in v4l2_fh_init
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 9, 2017 at 6:49 AM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> Here, em28xx_free_v4l2 is release "v4l2->dev->v4l2"
> Which is allready release by em28xx_v4l2_init.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Hi Arvind,

I still see the crash with your patch.

Thanks!

em28xx 1-1:0.0: Disconnecting
em28xx 1-1:0.0: Registering V4L2 extension
em28xx 1-1:0.0: Config register raw data: 0xffffffed
em28xx 1-1:0.0: AC97 chip type couldn't be determined
em28xx 1-1:0.0: No AC97 audio processor
em28xx 1-1:0.0: failed to create media graph
em28xx 1-1:0.0: V4L2 device video0 deregistered
em28xx 1-1:0.0: Binding DVB extension
==================================================================
BUG: KASAN: use-after-free in v4l2_fh_init+0x239/0x280
Read of size 8 at addr ffff88006b40c998 by task v4l_id/5917

CPU: 0 PID: 5917 Comm: v4l_id Not tainted
4.14.0-rc8-44455-ge2105594a876-dirty #102
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 print_address_description+0x71/0x234 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x173/0x270 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 v4l2_fh_init+0x239/0x280 drivers/media/v4l2-core/v4l2-fh.c:33
 v4l2_fh_open+0x76/0xa0 drivers/media/v4l2-core/v4l2-fh.c:70
 em28xx_v4l2_open+0x252/0x6f0 drivers/media/usb/em28xx/em28xx-video.c:2060
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
RIP: 0033:0x7faff04be120
RSP: 002b:00007fff4d967aa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007faff04be120
RDX: 00007faff0773138 RSI: 0000000000000000 RDI: 00007fff4d967f1e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000400884
R13: 00007fff4d967c00 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 3170:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11a/0x290 mm/slub.c:2773
 kmalloc ./include/linux/slab.h:494
 kzalloc ./include/linux/slab.h:667
 em28xx_v4l2_init+0x10c/0x3660 drivers/media/usb/em28xx/em28xx-video.c:2438
 em28xx_init_extension+0x11a/0x190 drivers/media/usb/em28xx/em28xx-core.c:1110
 request_module_async+0x6a/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3161
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 process_scheduled_works kernel/workqueue.c:2173
 worker_thread+0x6c0/0x10d0 kernel/workqueue.c:2252
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

Freed by task 3170:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1391
 slab_free_freelist_hook mm/slub.c:1413
 slab_free mm/slub.c:2989
 kfree+0xf2/0x2e0 mm/slub.c:3920
 em28xx_free_v4l2 drivers/media/usb/em28xx/em28xx-video.c:2025
 kref_put ./include/linux/kref.h:70
 em28xx_v4l2_init+0x2382/0x3660 drivers/media/usb/em28xx/em28xx-video.c:2788
 em28xx_init_extension+0x11a/0x190 drivers/media/usb/em28xx/em28xx-core.c:1110
 request_module_async+0x6a/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3161
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 process_scheduled_works kernel/workqueue.c:2173
 worker_thread+0x6c0/0x10d0 kernel/workqueue.c:2252
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432

The buggy address belongs to the object at ffff88006b40c200
 which belongs to the cache kmalloc-8192 of size 8192
The buggy address is located 1944 bytes inside of
 8192-byte region [ffff88006b40c200, ffff88006b40e200)
The buggy address belongs to the page:
page:ffffea0001ad0200 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000180030003
raw: 0000000000000000 0000000100000001 ffff88006c402a80 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006b40c880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006b40c900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88006b40c980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88006b40ca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006b40ca80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

> ---
> This bug report by Andrey Konovalov "net/media/em28xx: use-after-free in v4l2_fh_init"
>
>  drivers/media/usb/em28xx/em28xx-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 8d253a5..f1ee53f 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -2785,8 +2785,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>         v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
>         v4l2_device_unregister(&v4l2->v4l2_dev);
>  err:
> -       dev->v4l2 = NULL;
>         kref_put(&v4l2->ref, em28xx_free_v4l2);
> +       dev->v4l2 = NULL;
>         mutex_unlock(&dev->lock);
>         return ret;
>  }
> --
> 1.9.1
>
