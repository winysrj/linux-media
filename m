Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34260 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdJIS1B (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 14:27:01 -0400
Subject: Re: usb/media/imon: null-ptr-deref in imon_probe
To: Andrey Konovalov <andreyknvl@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <CAAeHK+yoqszqq2Vo+sv4TWDnj9HJgPxeLBhEw6Qe3Cu-v81uOQ@mail.gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
From: arvindY <arvind.yadav.cs@gmail.com>
Message-ID: <59DBBF6C.3040506@gmail.com>
Date: Mon, 9 Oct 2017 23:56:52 +0530
MIME-Version: 1.0
In-Reply-To: <CAAeHK+yoqszqq2Vo+sv4TWDnj9HJgPxeLBhEw6Qe3Cu-v81uOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

I have added NULL check for usb_ifnum_to_if() and send a patch.
Please re-test it.

~arvind

On Monday 09 October 2017 11:20 PM, Andrey Konovalov wrote:
> Hi!
>
> I've got the following report while fuzzing the kernel with syzkaller.
>
> On commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f (4.14-rc4).
>
> It seems that the return value of usb_ifnum_to_if() can be NULL and
> needs to be checked.
>
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> Modules linked in:
> CPU: 1 PID: 1497 Comm: kworker/1:1 Not tainted
> 4.14.0-rc4-43418-g43a3f84d2109-dirty #380
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: usb_hub_wq hub_event
> task: ffff88006a5618c0 task.stack: ffff880068bc8000
> RIP: 0010:imon_probe+0x231/0x3f10 drivers/media/rc/imon.c:2519
> RSP: 0018:ffff880068bce2d8 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: ffff8800627dd500 RCX: 0000000000000027
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000138
> RBP: ffff880068bce5e8 R08: ffff88006a5618c0 R09: ffffffff84b380fc
> R10: ffff880068bce2c8 R11: 1ffff1000d4ac5b3 R12: ffff880061830000
> R13: ffff880061830008 R14: ffffffff883fa200 R15: ffffffff883fa080
> FS:  0000000000000000(0000) GS:ffff88006c500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000206cbffc CR3: 0000000061085000 CR4: 00000000000006e0
> Call Trace:
>   usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
>   really_probe drivers/base/dd.c:413
>   driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>   __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>   bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>   __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>   device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>   bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>   device_add+0xd0b/0x1660 drivers/base/core.c:1835
>   usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
>   generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
>   usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
>   really_probe drivers/base/dd.c:413
>   driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>   __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>   bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>   __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>   device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>   bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>   device_add+0xd0b/0x1660 drivers/base/core.c:1835
>   usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
>   hub_port_connect drivers/usb/core/hub.c:4903
>   hub_port_connect_change drivers/usb/core/hub.c:5009
>   port_event drivers/usb/core/hub.c:5115
>   hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
>   process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
>   worker_thread+0x221/0x1850 kernel/workqueue.c:2253
>   kthread+0x3a1/0x470 kernel/kthread.c:231
>   ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
> Code: ff e8 a4 81 cb 01 31 f6 48 89 df e8 2a cc 65 ff 0f ae f0 48 8d
> b8 38 01 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <80>
> 3c 11 00 0f 85 e8 31 00 00 48 8b 98 38 01 00 00 0f ae f0 44
> RIP: imon_probe+0x231/0x3f10 RSP: ffff880068bce2d8
> ---[ end trace 07febd2eebe02f84 ]---
