Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:49489 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932237AbdJWOl3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 10:41:29 -0400
Received: by mail-oi0-f54.google.com with SMTP id w197so31108805oif.6
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 07:41:29 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 23 Oct 2017 16:41:28 +0200
Message-ID: <CAAeHK+wZXZMxqQn9QbAd3xWt00_bKir4-La2QKtzk8nFb0FQmw@mail.gmail.com>
Subject: usb/media/au0828: use-after-free in au0828_rc_unregister
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Andi Shyti <andi.shyti@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 3e0cc09a3a2c40ec1ffb6b4e12da86e98feccb11 (4.14-rc5+).

au0828: recv_control_msg() Failed receiving control message, error -71.
au0828: recv_control_msg() Failed receiving control message, error -71.
au0828: recv_control_msg() Failed receiving control message, error -71.
au8522_writereg: writereg error (reg == 0x106, val == 0x0001, ret == -5)
usb 1-1: selecting invalid altsetting 5
au0828: Failure setting usb interface0 to as5
au0828: au0828_usb_probe() au0282_dev_register failed to register on V4L2
==================================================================
BUG: KASAN: use-after-free in au0828_rc_unregister+0xaa/0xc0
Read of size 8 at addr ffff8800626e2b90 by task kworker/1:1/1491

CPU: 1 PID: 1491 Comm: kworker/1:1 Not tainted
4.14.0-rc5-43687-g06ab8a23e0e6 #545
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 au0828_rc_unregister+0xaa/0xc0 drivers/media/usb/au0828/au0828-input.c:367
 au0828_usb_disconnect+0x63/0x130 drivers/media/usb/au0828/au0828-core.c:189
 au0828_usb_probe+0xb3e/0xf20 drivers/media/usb/au0828/au0828-core.c:660
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
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
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x363/0x440 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

The buggy address belongs to the page:
page:ffffea000189b880 count:0 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000000()
raw: 0100000000000000 0000000000000000 0000000000000000 00000000ffffffff
raw: 0000000000000000 dead000000000200 ffff88006c00d980 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8800626e2a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8800626e2b00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8800626e2b80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                         ^
 ffff8800626e2c00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8800626e2c80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
