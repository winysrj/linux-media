Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54161 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933842AbdIZInT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:43:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: usb/media/uvc: warning in uvc_scan_chain_forward/__list_add
Date: Tue, 26 Sep 2017 11:43:17 +0300
Message-ID: <2018643.XCel7AsVXx@avalon>
In-Reply-To: <CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com>
References: <CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On Monday, 25 September 2017 15:40:13 EEST Andrey Konovalov wrote:
> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.

Thank you for the report.

> On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).
> 
> list_add double add: new=ffff880069084010, prev=ffff880069084010,
> next=ffff880067d22298.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1846 at lib/list_debug.c:31 __list_add_valid+0xbd/0xf0
> Modules linked in:
> CPU: 1 PID: 1846 Comm: kworker/1:2 Not tainted
> 4.14.0-rc2-42613-g1488251d1a98 #238
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: usb_hub_wq hub_event
> task: ffff88006b01ca40 task.stack: ffff880064358000
> RIP: 0010:__list_add_valid+0xbd/0xf0 lib/list_debug.c:29
> RSP: 0018:ffff88006435ddd0 EFLAGS: 00010286
> RAX: 0000000000000058 RBX: ffff880067d22298 RCX: 0000000000000000
> RDX: 0000000000000058 RSI: ffffffff85a58800 RDI: ffffed000c86bbac
> RBP: ffff88006435dde8 R08: 1ffff1000c86ba52 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000000 R12: ffff880069084010
> R13: ffff880067d22298 R14: ffff880069084010 R15: ffff880067d222a0
> FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020004ff2 CR3: 000000006b447000 CR4: 00000000000006e0
> Call Trace:
>  __list_add ./include/linux/list.h:59
>  list_add_tail+0x8c/0x1b0 ./include/linux/list.h:92
>  uvc_scan_chain_forward.isra.8+0x373/0x416
> drivers/media/usb/uvc/uvc_driver.c:1471
>  uvc_scan_chain drivers/media/usb/uvc/uvc_driver.c:1585
>  uvc_scan_device drivers/media/usb/uvc/uvc_driver.c:1769
>  uvc_probe+0x77f2/0x8f00 drivers/media/usb/uvc/uvc_driver.c:2104

So the issue happens at probe time, before the driver registers the V4L2 
device nodes that allow userspace access to the device. I wonder how fuzzing 
caused this. Do you have a more detailed log ?

Could you also tell me what webcam you're using to test this out ? The output 
of lsusb -v would be useful.

>  usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
>  really_probe drivers/base/dd.c:413
>  driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>  __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>  bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>  __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>  device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>  bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>  device_add+0xd0b/0x1660 drivers/base/core.c:1835
>  usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
>  generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
>  usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
>  really_probe drivers/base/dd.c:413
>  driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>  __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>  bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>  __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>  device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>  bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>  device_add+0xd0b/0x1660 drivers/base/core.c:1835
>  usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
>  hub_port_connect drivers/usb/core/hub.c:4903
>  hub_port_connect_change drivers/usb/core/hub.c:5009
>  port_event drivers/usb/core/hub.c:5115
>  hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
>  process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
>  worker_thread+0x221/0x1850 kernel/workqueue.c:2253
>  kthread+0x3a1/0x470 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
> Code: f1 48 c7 c7 c0 89 a5 85 48 89 de e8 38 34 e1 fe 0f ff 31 c0 eb
> c3 48 89 f2 48 89 d9 4c 89 e6 48 c7 c7 40 8a a5 85 e8 1d 34 e1 fe <0f>
> ff 31 c0 eb a8 48 89 75 e8 e8 e4 b3 2a ff 48 8b 75 e8 e9 5b
> ---[ end trace 23181469b7a6915e ]---

-- 
Regards,

Laurent Pinchart
