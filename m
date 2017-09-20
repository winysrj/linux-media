Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:43468 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbdITTSI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:18:08 -0400
Received: by mail-io0-f176.google.com with SMTP id k101so5974126iod.0
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 12:18:08 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 20 Sep 2017 21:18:07 +0200
Message-ID: <CAAeHK+yqz3dhY1wGQnvNEzY9k=roJToCdoPo_hjtqFGtDeA22g@mail.gmail.com>
Subject: usb/media/pvrusb2: warning in pvr2_send_request_ex/usb_submit_urb
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

On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).

There seems to be no check on endpoint type before submitting bulk urb
in pvr2_send_request_ex().

usb 1-1: New USB device found, idVendor=2040, idProduct=7500
usb 1-1: New USB device strings: Mfr=0, Product=255, SerialNumber=0
usb 1-1: Product: a
gadgetfs: configuration #6
pvrusb2: Hardware description: WinTV HVR-1950 Model 750xx
usb 1-1: BOGUS urb xfer, pipe 3 != type 1
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2713 at drivers/usb/core/urb.c:449
usb_submit_urb+0xf8a/0x11d0
Modules linked in:
CPU: 1 PID: 2713 Comm: pvrusb2-context Not tainted
4.14.0-rc1-42251-gebb2c2437d80 #210
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88006b7a18c0 task.stack: ffff880069978000
RIP: 0010:usb_submit_urb+0xf8a/0x11d0 drivers/usb/core/urb.c:448
RSP: 0018:ffff88006997f990 EFLAGS: 00010286
RAX: 0000000000000029 RBX: ffff880063661900 RCX: 0000000000000000
RDX: 0000000000000029 RSI: ffffffff86876d60 RDI: ffffed000d32ff24
RBP: ffff88006997fa90 R08: 1ffff1000d32fdca R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff1000d32ff39
R13: 0000000000000001 R14: 0000000000000003 R15: ffff880068bbed68
FS:  0000000000000000(0000) GS:ffff88006c600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001032000 CR3: 000000006a0ff000 CR4: 00000000000006f0
Call Trace:
 pvr2_send_request_ex+0xa57/0x1d80 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3645
 pvr2_hdw_check_firmware drivers/media/usb/pvrusb2/pvrusb2-hdw.c:1812
 pvr2_hdw_setup_low drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2107
 pvr2_hdw_setup drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2250
 pvr2_hdw_initialize+0x548/0x3c10 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2327
 pvr2_context_check drivers/media/usb/pvrusb2/pvrusb2-context.c:118
 pvr2_context_thread_func+0x361/0x8c0
drivers/media/usb/pvrusb2/pvrusb2-context.c:167
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code: 48 8b 85 30 ff ff ff 48 8d b8 98 00 00 00 e8 ee 82 89 fe 45 89
e8 44 89 f1 4c 89 fa 48 89 c6 48 c7 c7 40 c0 ea 86 e8 30 1b dc fc <0f>
ff e9 9b f7 ff ff e8 aa 95 25 fd e9 80 f7 ff ff e8 50 74 f3
---[ end trace 6919030503719da6 ]---
