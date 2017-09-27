Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:57185 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbdI0SsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:48:17 -0400
Received: by mail-oi0-f54.google.com with SMTP id b184so18147172oii.13
        for <linux-media@vger.kernel.org>; Wed, 27 Sep 2017 11:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2b7b169ee0fb43b4447c8960cdfabcfe118d2a8b.1506536596.git.arvind.yadav.cs@gmail.com>
References: <2b7b169ee0fb43b4447c8960cdfabcfe118d2a8b.1506536596.git.arvind.yadav.cs@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 27 Sep 2017 20:48:16 +0200
Message-ID: <CAAeHK+xe12jEKeA_XDm-pBfOH0QmXNZKVGiAaGF_V-b+Ph3Scw@mail.gmail.com>
Subject: Re: [RFT v2] [media] siano: FIX use-after-free in worker_thread
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, mchehab@s-opensource.com,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 27, 2017 at 8:32 PM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> Call flush_work() on failure and disconnect. Work initialize and schedule
> in smsusb_onresponse(). it should be freed in smsusb_stop_streaming().
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Hi Arvind,

This patch fixes the issue with flush_work() missing, but exposes
another one. smsusb_init_device() initializes urbs and submits them in
smsusb_start_streaming(). However if smscore_start_device() fails,
smsusb_term_device() frees the urbs by freeing smsusb_device_t. The
urbs however still remain submitted, which causes another
use-after-free.

==================================================================
BUG: KASAN: use-after-free in dummy_timer+0x3076/0x3970
Read of size 4 at addr ffff88006b86b348 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted
4.14.0-rc2-42664-gaf7d1481b3cb-dirty #292
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_load4_noabort+0x19/0x20 mm/kasan/report.c:429
 dummy_timer+0x3076/0x3970 drivers/usb/gadget/udc/dummy_hcd.c:1791
 call_timer_fn+0x2a2/0x940 kernel/time/timer.c:1281
 expire_timers kernel/time/timer.c:1320
 __run_timers+0x87f/0xd40 kernel/time/timer.c:1620
 run_timer_softirq+0x83/0x140 kernel/time/timer.c:1646
 __do_softirq+0x2ee/0xc0f kernel/softirq.c:284
 invoke_softirq kernel/softirq.c:364
 irq_exit+0x171/0x1a0 kernel/softirq.c:405
 exiting_irq ./arch/x86/include/asm/apic.h:638
 smp_apic_timer_interrupt+0x2b9/0x8d0 arch/x86/kernel/apic/apic.c:1048
 apic_timer_interrupt+0x9d/0xb0
 </IRQ>
RIP: 0010:native_safe_halt+0x6/0x10 ./arch/x86/include/asm/irqflags.h:53
RSP: 0018:ffff88006be87b90 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff10
RAX: dffffc0000000020 RBX: 1ffff1000d7d0f76 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88006be6ba64
RBP: ffff88006be87b90 R08: ffffffff813d3301 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff1000d7d0f82
R13: ffff88006be87cd0 R14: ffffffff86fc59c8 R15: 0000000000000000
 arch_safe_halt ./arch/x86/include/asm/paravirt.h:93
 default_idle+0x127/0x690 arch/x86/kernel/process.c:341
 arch_cpu_idle+0xf/0x20 arch/x86/kernel/process.c:332
 default_idle_call+0x3b/0x60 kernel/sched/idle.c:98
 cpuidle_idle_call kernel/sched/idle.c:156
 do_idle+0x33a/0x410 kernel/sched/idle.c:246
 cpu_startup_entry+0x1d/0x20 kernel/sched/idle.c:351
 start_secondary+0x3de/0x500 arch/x86/kernel/smpboot.c:278
 secondary_startup_64+0xa5/0xa5 arch/x86/kernel/head_64.S:235

Allocated by task 40:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 smsusb_init_device+0xd5/0xd10 drivers/media/usb/siano/smsusb.c:409
 smsusb_probe+0x4f5/0xdc0 drivers/media/usb/siano/smsusb.c:573
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

Freed by task 40:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 smsusb_term_device+0xd2/0x130 drivers/media/usb/siano/smsusb.c:365
 smsusb_init_device+0xd03/0xd10 drivers/media/usb/siano/smsusb.c:494
 smsusb_probe+0x4f5/0xdc0 drivers/media/usb/siano/smsusb.c:573
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

The buggy address belongs to the object at ffff88006b86b300
 which belongs to the cache kmalloc-4096 of size 4096
The buggy address is located 72 bytes inside of
 4096-byte region [ffff88006b86b300, ffff88006b86c300)
The buggy address belongs to the page:
page:ffffea0001ae1a00 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 0000000180070007
raw: ffffea0001ae8c00 0000000300000003 ffff88006c402c00 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006b86b200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88006b86b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88006b86b300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88006b86b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88006b86b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Thanks!

> ---
> This bug report by Andrey Konovalov "usb/media/smsusb: use-after-free in
> worker_thread".
> changes in v2 :
>               call flush_work() in smsusb_stop_streaming().
>
>  drivers/media/usb/siano/smsusb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index 8c1f926..8142ba4 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -192,6 +192,8 @@ static void smsusb_stop_streaming(struct smsusb_device_t *dev)
>         for (i = 0; i < MAX_URBS; i++) {
>                 usb_kill_urb(&dev->surbs[i].urb);
>
> +               flush_work(&dev->surbs[i].wq);
> +
>                 if (dev->surbs[i].cb) {
>                         smscore_putbuffer(dev->coredev, dev->surbs[i].cb);
>                         dev->surbs[i].cb = NULL;
> --
> 2.7.4
>
