Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:45531 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbdJIRup (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 13:50:45 -0400
Received: by mail-oi0-f47.google.com with SMTP id f3so41123745oia.2
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 10:50:45 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 9 Oct 2017 19:50:44 +0200
Message-ID: <CAAeHK+xr7EkAG6Ebr0epjBg9RAftx+Hi9BjVXjxqN6-uXp_fkg@mail.gmail.com>
Subject: usb/media/imon: global-out-of-bounds in imon_probe/imon_init_intf0
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f (4.14-rc4).

It seems that imon_ir_raw doesn't have the .key_table initializer,
which causes out-of-bounds access when iterating over the key table.

==================================================================
BUG: KASAN: global-out-of-bounds in imon_probe+0x3ade/0x3f00
Read of size 8 at addr ffffffff871c5468 by task kworker/1:1/1494

CPU: 1 PID: 1494 Comm: kworker/1:1 Not tainted
4.14.0-rc4-43418-g43a3f84d2109-dirty #391
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x1d9/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 imon_init_intf0 drivers/media/rc/imon.c:2142
 imon_probe+0x3ade/0x3f00 drivers/media/rc/imon.c:2523
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

The buggy address belongs to the variable:
 imon_ir_raw+0x8/0x40

Memory state around the buggy address:
 ffffffff871c5300: fa fa fa fa 00 03 fa fa fa fa fa fa 00 fa fa fa
 ffffffff871c5380: fa fa fa fa 06 fa fa fa fa fa fa fa 00 00 06 fa
>ffffffff871c5400: fa fa fa fa 00 04 fa fa fa fa fa fa 00 fa fa fa
                                                          ^
 ffffffff871c5480: fa fa fa fa 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff871c5500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
