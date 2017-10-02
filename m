Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:43870 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdJBLt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 07:49:57 -0400
Received: by mail-oi0-f54.google.com with SMTP id c77so6510681oig.0
        for <linux-media@vger.kernel.org>; Mon, 02 Oct 2017 04:49:57 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 2 Oct 2017 13:49:55 +0200
Message-ID: <CAAeHK+waG3b5CYxxMwnXAJKPhx4TE_CppzS-kECMur3j7NTBGg@mail.gmail.com>
Subject: usb/media/uvc: BUG in uvc_mc_create_links/media_create_pad_link
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

On commit 9e66317d3c92ddaab330c125dfe9d06eee268aff (4.14-rc3).

uvcvideo: Found UVC 0.00 device a (2833:0201)
uvcvideo 1-1:3.92: Entity type for entity Output 2 was not initialized!
------------[ cut here ]------------
kernel BUG at drivers/media/media-entity.c:686!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 1 PID: 40 Comm: kworker/1:1 Not tainted 4.14.0-rc3-42944-g2de0634c9ea5 #347
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006b8698c0 task.stack: ffff88006b810000
RIP: 0010:media_create_pad_link+0x427/0x5b0 drivers/media/media-entity.c:686
RSP: 0018:ffff88006b815e40 EFLAGS: 00010297
RAX: ffff88006b8698c0 RBX: ffff8800699b56f0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88006a1676a8
RBP: ffff88006b815e88 R08: 0000000000000003 R09: 1ffff1000d702b6a
R10: ffff88006b8698c0 R11: 0000000000000005 R12: ffff88006a167670
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003000 CR3: 000000006765b000 CR4: 00000000000006e0
Call Trace:
 uvc_mc_create_links drivers/media/usb/uvc/uvc_entity.c:55
 uvc_mc_register_entities+0x3df/0x770 drivers/media/usb/uvc/uvc_entity.c:119
 uvc_register_chains drivers/media/usb/uvc/uvc_driver.c:1989
 uvc_probe+0x848f/0x8f00 drivers/media/usb/uvc/uvc_driver.c:2108
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
Code: 66 41 83 44 24 3a 01 31 db e8 d6 73 6b fd 89 d8 48 83 c4 20 5b
41 5c 41 5d 41 5e 41 5f 5d c3 e8 c0 73 6b fd 0f 0b e8 b9 73 6b fd <0f>
0b e8 b2 73 6b fd 0f 0b e8 5b 9e 9d fd e9 35 fc ff ff e8 51
RIP: media_create_pad_link+0x427/0x5b0 RSP: ffff88006b815e40
---[ end trace 803624f49c213c15 ]---
