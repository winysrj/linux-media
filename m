Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:44974 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932747AbdKCOpo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 10:45:44 -0400
Received: by mail-oi0-f68.google.com with SMTP id v132so2231053oie.1
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 07:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAeHK+x_V05KHcLaa0+-ghj7GuzFGuybARat7KO0-4GEFzS9Nw@mail.gmail.com>
References: <CAAeHK+x_V05KHcLaa0+-ghj7GuzFGuybARat7KO0-4GEFzS9Nw@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 3 Nov 2017 15:45:43 +0100
Message-ID: <CAAeHK+xNemb9-+pqifrXd5qsnEvbS8h+cgAgy0FhzL1A7FRfJA@mail.gmail.com>
Subject: Re: usb/media/em28xx: use-after-free in em28xx_dvb_fini
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 3, 2017 at 3:44 PM, Andrey Konovalov <andreyknvl@google.com> wrote:
> Hi!
>
> I've got the following report while fuzzing the kernel with syzkaller.
>
> On commit 3a99df9a3d14cd866b5516f8cba515a3bfd554ab (4.14-rc7+).
>
> em28xx 1-1:2.0: New device a  @ 480 Mbps (eb1a:2801, interface 0, class 0)
> em28xx 1-1:2.0: Audio interface 0 found (Vendor Class)
> em28xx 1-1:2.0: chip ID is em2860
> em28xx 1-1:2.0: Config register raw data: 0x22
> em28xx 1-1:2.0: I2S Audio (3 sample rate(s))
> em28xx 1-1:2.0: No AC97 audio processor
> em28xx 1-1:2.0: Binding audio extension
> em28xx 1-1:2.0: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> em28xx 1-1:2.0: em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab
> em28xx 1-1:2.0: alt 0 doesn't exist on interface 7
> usb 1-1: USB disconnect, device number 2
> em28xx 1-1:2.0: Disconnecting
> em28xx 1-1:2.0: Closing audio extension
> em28xx 1-1:2.0: Freeing device
> ==================================================================
> BUG: KASAN: use-after-free in em28xx_dvb_fini+0x74b/0x8e0
> Read of size 1 at addr ffff880069d2c12c by task kworker/0:1/24
>
> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
> 4.14.0-rc7-44290-gf28444df2601-dirty #52
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:16
>  dump_stack+0xe1/0x157 lib/dump_stack.c:52
>  print_address_description+0x71/0x234 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351
>  kasan_report+0x173/0x270 mm/kasan/report.c:409
>  __asan_report_load1_noabort+0x19/0x20 mm/kasan/report.c:427
>  em28xx_dvb_fini+0x74b/0x8e0 drivers/media/usb/em28xx/em28xx-dvb.c:2076
>  em28xx_close_extension+0x71/0x220 drivers/media/usb/em28xx/em28xx-core.c:1122
>  em28xx_usb_disconnect+0xd7/0x140 drivers/media/usb/em28xx/em28xx-cards.c:3763
>  usb_unbind_interface+0x1b6/0x950 drivers/usb/core/driver.c:423
>  __device_release_driver drivers/base/dd.c:861
>  device_release_driver_internal+0x529/0x5f0 drivers/base/dd.c:893
>  device_release_driver+0x1e/0x30 drivers/base/dd.c:918
>  bus_remove_device+0x2fc/0x4b0 drivers/base/bus.c:565
>  device_del+0x591/0xa70 drivers/base/core.c:1985
>  usb_disable_device+0x223/0x710 drivers/usb/core/message.c:1170
>  usb_disconnect+0x285/0x7f0 drivers/usb/core/hub.c:2205
>  hub_port_connect drivers/usb/core/hub.c:4838
>  hub_port_connect_change drivers/usb/core/hub.c:5093
>  port_event drivers/usb/core/hub.c:5199
>  hub_event_impl+0x10ec/0x3440 drivers/usb/core/hub.c:5311
>  hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
>  process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
>  worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
>  kthread+0x346/0x410 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
>
> The buggy address belongs to the page:
> page:ffffea0001a74b00 count:0 mapcount:-127 mapping:          (null) index:0x0
> flags: 0x100000000000000()
> raw: 0100000000000000 0000000000000000 0000000000000000 00000000ffffff80
> raw: ffffea00019f0320 ffff88007fffa690 0000000000000002 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff880069d2c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff880069d2c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>ffff880069d2c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                   ^
>  ffff880069d2c180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff880069d2c200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================

-linux-kernel@vger.kernel.or
+linux-kernel@vger.kernel.org
