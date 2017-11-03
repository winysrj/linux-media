Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:57111 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755841AbdKCOpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 10:45:05 -0400
Received: by mail-oi0-f51.google.com with SMTP id v9so2189343oif.13
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 07:45:05 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 3 Nov 2017 15:45:04 +0100
Message-ID: <CAAeHK+wtFsypF=YJFA3VFPcPTU+7Phcjgf7Tjnr00xrFSVm66Q@mail.gmail.com>
Subject: usb/media/pvrusb2: WARNING in pvr2_i2c_core_done/sysfs_remove_group
To: Mike Isely <isely@pobox.com>,
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

On commit 3a99df9a3d14cd866b5516f8cba515a3bfd554ab (4.14-rc7+).

pvrusb2: Hardware description: OnAir Creator Hybrid USB tuner
pvrusb2: Invalid write control endpoint
...
pvrusb2: Invalid write control endpoint
pvrusb2: Module ID 3 (saa7115) for device OnAir Creator Hybrid USB
tuner failed to load.  Possible missing sub-device kernel module or
initialization failure within module.
cs53l32a 0-0011: chip found @ 0x22 (pvrusb2_a)
pvrusb2: Invalid write control endpoint
...
pvrusb2: Invalid write control endpoint
pvrusb2: Attached sub-driver cs53l32a
pvrusb2: Invalid write control endpoint
...
pvrusb2: Invalid write control endpoint
pvrusb2: Module ID 4 (tuner) for device OnAir Creator Hybrid USB tuner
failed to load.  Possible missing sub-device kernel module or
initialization failure within module.
pvrusb2: Device being rendered inoperable
pvrusb2: ***WARNING*** pvrusb2 driver initialization failed due to the
failure of one or more sub-device kernel modules.
pvrusb2: You need to resolve the failing condition before this driver
can function.  There should be some earlier messages giving more
information about the problem.
usb 1-1: USB disconnect, device number 11
sysfs group 'power' not found for kobject '0-0011'
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2896 at fs/sysfs/group.c:237
sysfs_remove_group.cold.6+0x57/0x63
Modules linked in:
CPU: 0 PID: 2896 Comm: pvrusb2-context Not tainted
4.14.0-rc7-44290-gf28444df2601-dirty #52
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88006b752e00 task.stack: ffff88006b6c8000
RIP: 0010:sysfs_remove_group.cold.6+0x57/0x63 fs/sysfs/group.c:235
RSP: 0018:ffff88006b6cfc28 EFLAGS: 00010292
RAX: 0000000000000032 RBX: ffffffff85b7a480 RCX: ffffffff812495b5
RDX: 0000000000000000 RSI: ffffffff8124d76a RDI: 0000000000000005
RBP: ffff88006b6cfc48 R08: ffff88006b752e00 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880069a3e8a0
R13: ffff88006b9b5530 R14: ffffffff85b7a4c8 R15: ffffffff83c90160
FS:  0000000000000000(0000) GS:ffff88006ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001e8a908 CR3: 0000000063834000 CR4: 00000000000006f0
Call Trace:
 dpm_sysfs_remove+0x5d/0x70 drivers/base/power/sysfs.c:769
 device_del+0x2b5/0xa70 drivers/base/core.c:1962
 device_unregister+0x1a/0x40 drivers/base/core.c:2020
 i2c_unregister_device+0xfd/0x130 drivers/i2c/i2c-core-base.c:815
 __unregister_client+0x83/0x90 drivers/i2c/i2c-core-base.c:1413
 device_for_each_child+0xb2/0x110 drivers/base/core.c:2120
 i2c_del_adapter+0x2be/0x550 drivers/i2c/i2c-core-base.c:1477
 pvr2_i2c_core_done+0x79/0xcb drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c:671
 pvr2_hdw_destroy+0x157/0x350 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2671
 pvr2_context_destroy+0x64/0x200 drivers/media/usb/pvrusb2/pvrusb2-context.c:79
 pvr2_context_check drivers/media/usb/pvrusb2/pvrusb2-context.c:146
 pvr2_context_thread_func+0x420/0x670
drivers/media/usb/pvrusb2/pvrusb2-context.c:167
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code: 8b 65 00 48 c1 ea 03 48 c1 e0 2a 80 3c 02 00 74 08 48 89 df e8
9e 70 e1 ff 48 8b 33 4c 89 e2 48 c7 c7 68 63 11 86 e8 66 89 aa ff <0f>
ff e9 63 fc ff ff 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5
---[ end trace c49faec9cc373c2a ]---
sysfs group 'power' not found for kobject 'i2c-0'
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2896 at fs/sysfs/group.c:237
sysfs_remove_group.cold.6+0x57/0x63
Modules linked in:
CPU: 0 PID: 2896 Comm: pvrusb2-context Tainted: G        W
4.14.0-rc7-44290-gf28444df2601-dirty #52
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88006b752e00 task.stack: ffff88006b6c8000
RIP: 0010:sysfs_remove_group.cold.6+0x57/0x63 fs/sysfs/group.c:235
RSP: 0018:ffff88006b6cfcc0 EFLAGS: 00010282
RAX: 0000000000000031 RBX: ffffffff85b7a480 RCX: ffffffff812495b5
RDX: 0000000000000000 RSI: ffffffff8124d76a RDI: 0000000000000005
RBP: ffff88006b6cfce0 R08: ffff88006b752e00 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88006998b4e0
R13: ffff880062ba0348 R14: ffffffff85b7a4c8 R15: ffff880062ba0898
FS:  0000000000000000(0000) GS:ffff88006ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001e8a908 CR3: 0000000063834000 CR4: 00000000000006f0
Call Trace:
 dpm_sysfs_remove+0x5d/0x70 drivers/base/power/sysfs.c:769
 device_del+0x2b5/0xa70 drivers/base/core.c:1962
 device_unregister+0x1a/0x40 drivers/base/core.c:2020
 i2c_del_adapter+0x3f8/0x550 drivers/i2c/i2c-core-base.c:1500
 pvr2_i2c_core_done+0x79/0xcb drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c:671
 pvr2_hdw_destroy+0x157/0x350 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2671
 pvr2_context_destroy+0x64/0x200 drivers/media/usb/pvrusb2/pvrusb2-context.c:79
 pvr2_context_check drivers/media/usb/pvrusb2/pvrusb2-context.c:146
 pvr2_context_thread_func+0x420/0x670
drivers/media/usb/pvrusb2/pvrusb2-context.c:167
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code: 8b 65 00 48 c1 ea 03 48 c1 e0 2a 80 3c 02 00 74 08 48 89 df e8
9e 70 e1 ff 48 8b 33 4c 89 e2 48 c7 c7 68 63 11 86 e8 66 89 aa ff <0f>
ff e9 63 fc ff ff 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5
---[ end trace c49faec9cc373c2b ]---
