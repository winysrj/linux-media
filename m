Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:36541 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdKWQQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 11:16:57 -0500
Received: by mail-ot0-f182.google.com with SMTP id t79so16690316ota.3
        for <linux-media@vger.kernel.org>; Thu, 23 Nov 2017 08:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f0af1285-f941-4e7b-c626-ea82d4917dd4@gentoo.org>
References: <CAAeHK+ymo-iNX82-Ff9xdhf-jyTqAKxgvRAz_FYcNdHVCmqLgw@mail.gmail.com>
 <f0af1285-f941-4e7b-c626-ea82d4917dd4@gentoo.org>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Thu, 23 Nov 2017 17:16:55 +0100
Message-ID: <CAAeHK+xNmK=y735DLVQWJyfdudgtw08pEKK-Z5pASOVSMEJiuQ@mail.gmail.com>
Subject: Re: usb/media/em28xx: use-after-free in dvb_unregister_frontend
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Scheller <d.scheller@gmx.net>,
        Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 23, 2017 at 8:25 AM, Matthias Schwarzott <zzam@gentoo.org> wrote:
> Am 21.11.2017 um 14:51 schrieb Andrey Konovalov:
>> Hi!
>>
> Hi Andrey,
>
>> I've got the following report while fuzzing the kernel with syzkaller.
>>
>> On commit e1d1ea549b57790a3d8cf6300e6ef86118d692a3 (4.15-rc1).
>>
>> em28xx 1-1:9.0: Disconnecting
>> tc90522 1-0015: Toshiba TC90522 attached.
>> qm1d1c0042 2-0061: Sharp QM1D1C0042 attached.
>> dvbdev: DVB: registering new adapter (1-1:9.0)
>> em28xx 1-1:9.0: DVB: registering adapter 0 frontend 0 (Toshiba TC90522
>> ISDB-S module)...
>> dvbdev: dvb_create_media_entity: media entity 'Toshiba TC90522 ISDB-S
>> module' registered.
>> dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
>> em28xx 1-1:9.0: DVB extension successfully initialized
>> em28xx 1-1:9.0: Remote control support is not available for this card.
>> em28xx 1-1:9.0: Closing DVB extension
>> ==================================================================
>> BUG: KASAN: use-after-free in dvb_unregister_frontend+0x8f/0xa0
>> Read of size 8 at addr ffff880067853628 by task kworker/0:3/3182
>>
>> CPU: 0 PID: 3182 Comm: kworker/0:3 Not tainted 4.14.0-57501-g9284d204d604 #119
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:17
>>  dump_stack+0xe1/0x157 lib/dump_stack.c:53
>>  print_address_description+0x71/0x234 mm/kasan/report.c:252
>>  kasan_report_error mm/kasan/report.c:351
>>  kasan_report+0x173/0x270 mm/kasan/report.c:409
>>  __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
>>  dvb_unregister_frontend+0x8f/0xa0 drivers/media/dvb-core/dvb_frontend.c:2768
>>  em28xx_unregister_dvb drivers/media/usb/em28xx/em28xx-dvb.c:1122
>>  em28xx_dvb_fini+0x62d/0x8e0 drivers/media/usb/em28xx/em28xx-dvb.c:2129
>>  em28xx_close_extension+0x71/0x220 drivers/media/usb/em28xx/em28xx-core.c:1122
>>  em28xx_usb_disconnect+0xd7/0x130 drivers/media/usb/em28xx/em28xx-cards.c:3763
>>  usb_unbind_interface+0x1b6/0x950 drivers/usb/core/driver.c:423
>>  __device_release_driver drivers/base/dd.c:870
>>  device_release_driver_internal+0x563/0x630 drivers/base/dd.c:903
>>  device_release_driver+0x1e/0x30 drivers/base/dd.c:928
>>  bus_remove_device+0x2fc/0x4b0 drivers/base/bus.c:565
>>  device_del+0x39f/0xa70 drivers/base/core.c:1984
>>  usb_disable_device+0x223/0x710 drivers/usb/core/message.c:1205
>>  usb_disconnect+0x285/0x7f0 drivers/usb/core/hub.c:2205
>>  hub_port_connect drivers/usb/core/hub.c:4851
>>  hub_port_connect_change drivers/usb/core/hub.c:5106
>>  port_event drivers/usb/core/hub.c:5212
>>  hub_event_impl+0x10f0/0x3440 drivers/usb/core/hub.c:5324
>>  hub_event+0x38/0x50 drivers/usb/core/hub.c:5222
>>  process_one_work+0x944/0x15f0 kernel/workqueue.c:2112
>>  worker_thread+0xef/0x10d0 kernel/workqueue.c:2246
>>  kthread+0x367/0x420 kernel/kthread.c:238
>>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437
>>
>
> this looks similar to the oops fixed by this patch:
>
> https://patchwork.linuxtv.org/patch/45219/
>
> Could you try if it fixes your case also?

Hi Matthias!

Yes, it does fixes the crash for me.

Thanks!

>
> Regards
> Matthias
