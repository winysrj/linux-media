Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:56349 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933472AbdIZL4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:56:45 -0400
Received: by mail-oi0-f43.google.com with SMTP id b184so11485772oii.13
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 04:56:45 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 26 Sep 2017 13:56:44 +0200
Message-ID: <CAAeHK+wgiCLmhaSWi8LkG2pBo_A_xQJhAS13c-eEdDstWhWLiQ@mail.gmail.com>
Subject: usb/media/b2c2: GPF in flexcop_usb_transfer_init
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).

It seems that there's no check on the actual number of endpoints.

usb 1-1: New USB device strings: Mfr=212, Product=0, SerialNumber=6
usb 1-1: Manufacturer: a
usb 1-1: SerialNumber: a
gadgetfs: configuration #3
flexcop_usb: running at FULL speed.
gadgetfs: disconnected
flexcop_usb: error while reading dword from 161 (516).
flexcop_usb: error while writing dword from 33 (516).
flexcop_usb: error while writing dword from 33 (516).
flexcop_usb: error while reading dword from 161 (516).
flexcop_usb: error while reading dword from 247 (1820).
flexcop_usb: error while writing dword from 119 (1820).
flexcop_usb: error while reading dword from 176 (768).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 48 (768).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 176 (768).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 48 (768).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 177 (772).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 49 (772).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 177 (772).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 49 (772).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 178 (776).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 50 (776).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 178 (776).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 50 (776).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while writing dword from 51 (780).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 178 (776).
flexcop_usb: error while writing dword from 50 (776).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 34 (520).
flexcop_usb: error while reading dword from 162 (520).
flexcop_usb: error while writing dword from 34 (520).
dvbdev: DVB: registering new adapter (FlexCop Digital TV device)
b2c2-flexcop: reading of MAC address failed.

CX24123: wrong demod revision: 0
nxt200x: Unknown/Unsupported NXT chip: 00 00 00 00 00
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 64 (LG TDVS-H06xF)
b2c2-flexcop: found 'LG Electronics LGDT3303 VSB/QAM Frontend' .
usb 1-1: DVB: registering adapter 0 frontend 0 (LG Electronics
LGDT3303 VSB/QAM Frontend)...
b2c2-flexcop: initialization of 'Air2PC/AirStar 2 ATSC 3rd generation
(HD5000)' at the 'USB' bus controlled by a 'FlexCopIII' complete
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc2-42613-g1488251d1a98 #254
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006befe300 task.stack: ffff88006bf78000
RIP: 0010:flexcop_usb_transfer_init drivers/media/usb/b2c2/flexcop-usb.c:429
RIP: 0010:flexcop_usb_probe+0x4c9/0xc00 drivers/media/usb/b2c2/flexcop-usb.c:574
RSP: 0018:ffff88006bf7e570 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff880069440000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88006befeca8 RDI: 0000000000000004
RBP: ffff88006bf7e5e8 R08: 1ffff1000d7efb34 R09: 0000000000000000
R10: ffff88006bf7e4d0 R11: 0000000000000000 R12: ffff88006bafa200
R13: 0000000000000000 R14: 0000000000000000 R15: ffff880062b51198
FS:  0000000000000000(0000) GS:ffff88006c800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000fb4 CR3: 00000000674bb000 CR4: 00000000000006f0
Call Trace:
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
Code: 18 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 fa 05 00 00 48 b8 00
00 00 00 00 fc ff df 4d 8b 6d 18 49 8d 7d 04 48 89 fa 48 c1 ea 03 <0f>
b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RIP: flexcop_usb_probe+0x4c9/0xc00 RSP: ffff88006bf7e570
---[ end trace 71daccc5f58e2db2 ]---
