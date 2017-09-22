Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:55860 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbdIVM4V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 08:56:21 -0400
Received: by mail-io0-f178.google.com with SMTP id z187so2792631ioz.12
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 05:56:21 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 22 Sep 2017 14:56:20 +0200
Message-ID: <CAAeHK+w_at=5d_7c=sJaLun1d8cxYUpBFyAWJhbzCTADVEpoDA@mail.gmail.com>
Subject: usb/media/dib0700: BUG in stk7070p_frontend_attach/symbol_put_addr
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).

dib0700: stk7070p_frontend_attach: state->dib7000p_ops.i2c_enumeration
failed.  Cannot continue
------------[ cut here ]------------
kernel BUG at kernel/module.c:1081!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 1 PID: 1151 Comm: kworker/1:1 Tainted: G        W
4.14.0-rc1-42251-gebb2c2437d80 #224
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006a336300 task.stack: ffff88006a7c8000
RIP: 0010:symbol_put_addr+0x54/0x60 kernel/module.c:1083
RSP: 0018:ffff88006a7ce210 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880062a8d190 RCX: 0000000000000000
RDX: dffffc0000000020 RSI: ffffffff85876d60 RDI: ffff880062a8d190
RBP: ffff88006a7ce218 R08: 1ffff1000d4f9c12 R09: 1ffff1000d4f9ae4
R10: 1ffff1000d4f9bed R11: 0000000000000000 R12: ffff880062a8d180
R13: 00000000ffffffed R14: ffff880062a8d190 R15: ffff88006947c000
FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6416532000 CR3: 00000000632f5000 CR4: 00000000000006e0
Call Trace:
 stk7070p_frontend_attach+0x515/0x610
drivers/media/usb/dvb-usb/dib0700_devices.c:1013
 dvb_usb_adapter_frontend_init+0x32b/0x660
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:286
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:162
 dvb_usb_device_init+0xf70/0x17f0 drivers/media/usb/dvb-usb/dvb-usb-init.c:277
 dib0700_probe+0x171/0x5a0 drivers/media/usb/dvb-usb/dib0700_core.c:886
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
Code: ff ff 48 85 c0 74 24 48 89 c7 e8 48 ea ff ff bf 01 00 00 00 e8
de 20 e3 ff 65 8b 05 b7 2f c2 7e 85 c0 75 c9 e8 f9 0b c1 ff eb c2 <0f>
0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 b8 00 00
RIP: symbol_put_addr+0x54/0x60 RSP: ffff88006a7ce210
---[ end trace b75b357739e7e116 ]---
