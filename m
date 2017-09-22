Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:52673 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbdIVM4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 08:56:33 -0400
Received: by mail-io0-f171.google.com with SMTP id i197so2804021ioe.9
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 05:56:33 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 22 Sep 2017 14:56:32 +0200
Message-ID: <CAAeHK+y1Dw-jUB_nP=iwDYoPANQ54hjdYFrK9vNLH9xyJMiu5Q@mail.gmail.com>
Subject: usb/media/zr364xx: GPF in zr364xx_vidioc_querycap/strlcpy
To: Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
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

usb 1-1: new full-speed USB device number 2 using dummy_hcd
gadgetfs: connected
gadgetfs: disconnected
gadgetfs: connected
usb 1-1: config 225 has an invalid interface number: 1 but max is 0
usb 1-1: config 225 has no interface number 0
usb 1-1: config 225 interface 1 altsetting 0 endpoint 0x5 has invalid
maxpacket 2047, setting to 64
usb 1-1: config 225 interface 1 altsetting 0 has an invalid endpoint
with address 0xF5, skipping
usb 1-1: config 225 interface 1 altsetting 0 endpoint 0x8A has invalid
maxpacket 2047, setting to 64
usb 1-1: config 225 interface 1 altsetting 0 endpoint 0x81 has an
invalid bInterval 0, changing to 10
usb 1-1: config 225 interface 1 altsetting 0 endpoint 0x81 has invalid
maxpacket 1025, setting to 64
usb 1-1: config 225 interface 1 altsetting 0 has an invalid endpoint
with address 0xF7, skipping
usb 1-1: config 225 interface 1 altsetting 0 has an invalid endpoint
with address 0xB8, skipping
usb 1-1: New USB device found, idVendor=041e, idProduct=4024
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
usb 1-1: SerialNumber: a
gadgetfs: configuration #225
zr364xx 1-1:225.1: Zoran 364xx compatible webcam plugged
zr364xx 1-1:225.1: model 041e:4024 detected
usb 1-1: 320x240 mode selected
usb 1-1: Zoran 364xx controlling device video0
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 0 PID: 4306 Comm: v4l_id Not tainted 4.14.0-rc1-42261-ga67ef73a6f27 #225
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88006a27e300 task.stack: ffff880067f70000
RIP: 0010:strlcpy+0x21/0x120 lib/string.c:140
RSP: 0018:ffff880067f777a0 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: ffff880067f77c00 RCX: 0000000000000000
RDX: 0000000000000020 RSI: 0000000000000000 RDI: ffff880067f77c10
RBP: ffff880067f777c8 R08: ffffed000cfeef82 R09: ffffed000cfeef82
R10: 0000000000000002 R11: ffffed000cfeef81 R12: ffff880067f77c10
R13: ffff880063034400 R14: 0000000080000000 R15: ffff880063193180
FS:  00007f5561fe8700(0000) GS:ffff88006c800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5561b16110 CR3: 000000006b00c000 CR4: 00000000000006f0
Call Trace:
 zr364xx_vidioc_querycap+0xb8/0x220 drivers/media/usb/zr364xx/zr364xx.c:709
 v4l_querycap+0x134/0x370 drivers/media/v4l2-core/v4l2-ioctl.c:1008
 __video_do_ioctl+0x9c6/0xa80 drivers/media/v4l2-core/v4l2-ioctl.c:2750
 video_usercopy+0x4ea/0x1580 drivers/media/v4l2-core/v4l2-ioctl.c:2926
 video_ioctl2+0x31/0x40 drivers/media/v4l2-core/v4l2-ioctl.c:2968
 v4l2_ioctl+0x1c5/0x310 drivers/media/v4l2-core/v4l2-dev.c:360
 vfs_ioctl fs/ioctl.c:45
 do_vfs_ioctl+0x1c4/0x15c0 fs/ioctl.c:685
 SYSC_ioctl fs/ioctl.c:700
 SyS_ioctl+0x94/0xc0 fs/ioctl.c:691
 entry_SYSCALL_64_fastpath+0x23/0xc2 arch/x86/entry/entry_64.S:202
RIP: 0033:0x7f5561b1b347
RSP: 002b:00007ffd403d19a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd403d1b00 RCX: 00007f5561b1b347
RDX: 00007ffd403d19b0 RSI: 0000000080685600 RDI: 0000000000000003
RBP: 0000000000400884 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 00007ffd403d1b00 R14: 0000000000000000 R15: 0000000000000000
Code: 8b 45 f0 e9 64 ff ff ff 66 90 48 b8 00 00 00 00 00 fc ff df 55
48 89 f1 48 89 e5 48 c1 e9 03 41 55 41 54 49 89 fc 53 48 83 ec 10 <0f>
b6 04 01 48 89 f1 83 e1 07 38 c8 7f 08 84 c0 0f 85 9d 00 00
RIP: strlcpy+0x21/0x120 RSP: ffff880067f777a0
---[ end trace 23c9876972269088 ]---
