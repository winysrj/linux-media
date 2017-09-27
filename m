Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:48709 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752909AbdI0MR3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 08:17:29 -0400
Received: by mail-oi0-f44.google.com with SMTP id v188so16350795oia.5
        for <linux-media@vger.kernel.org>; Wed, 27 Sep 2017 05:17:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAeHK+xFAYXxSnR1hbJRJ=qsPFR5NdwKJx5=CO0Arx5tuNXL0g@mail.gmail.com>
References: <eba212d6d5b631365c5881b0ef4e16a9a8ea8cf6.1506502997.git.arvind.yadav.cs@gmail.com>
 <CAAeHK+xFAYXxSnR1hbJRJ=qsPFR5NdwKJx5=CO0Arx5tuNXL0g@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Wed, 27 Sep 2017 14:17:27 +0200
Message-ID: <CAAeHK+yxQc-_trtKP7TSU1jmSgSDeHFnmjpODwGimODCsRi63g@mail.gmail.com>
Subject: Re: [RFT] [media] siano: FIX use-after-free in worker_thread
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, mchehab@s-opensource.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 27, 2017 at 2:00 PM, Andrey Konovalov <andreyknvl@google.com> wrote:
> On Wed, Sep 27, 2017 at 11:21 AM, Arvind Yadav
> <arvind.yadav.cs@gmail.com> wrote:
>> If CONFIG_MEDIA_CONTROLLER_DVB is enable, We are not releasing
>> media device and memory on any failure or disconnect a device.
>>
>> Adding structure media_device 'mdev' as part of 'smsusb_device_t'
>> structure to make proper handle for media device.
>> Now releasing a media device and memory on failure. It's allocate
>> first in siano_media_device_register() and it should be freed last
>> in smsusb_disconnect().
>>
>> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
>
> Hi Arvind,
>
> I've tried your patch and still see a crash.

My guess is that here the issue is similar to the one in lan78xx,
surb->wq work isn't shutdown properly.

>
> Thanks!
>
> gadgetfs: bound to dummy_udc driver
> usb 1-1: new full-speed USB device number 2 using dummy_hcd
> gadgetfs: connected
> gadgetfs: disconnected
> gadgetfs: connected
> usb 1-1: config 189 interface 0 altsetting 0 endpoint 0x9 has an
> invalid bInterval 0, changing to 4
> usb 1-1: New USB device found, idVendor=187f, idProduct=0100
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> gadgetfs: configuration #189
> smsusb:smsusb_probe: board id=1, interface number 0
> smsusb:siano_media_device_register: media controller created
> smsusb:smsusb1_detectmode: product string not found
> smsmdtv:smscore_set_device_mode: return error code -22.
> smsmdtv:smscore_start_device: set device mode failed , rc -22
> smsusb:smsusb_init_device: smscore_start_device(...) failed
> smsusb:smsusb_onresponse: error, urb status -2, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_onresponse: error, urb status -71, 0 bytes
> smsusb:smsusb_probe: Device initialized with return code -22
> ==================================================================
> BUG: KASAN: use-after-free in worker_thread+0x1468/0x1850
> Read of size 8 at addr ffff88006a2b80f0 by task kworker/0:1/24
>
> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
> 4.14.0-rc2-42660-g24b7bd59eec0-dirty #273
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:16
>  dump_stack+0x292/0x395 lib/dump_stack.c:52
>  print_address_description+0x78/0x280 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351
>  kasan_report+0x23d/0x350 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
>  worker_thread+0x1468/0x1850 kernel/workqueue.c:2251
>  kthread+0x3a1/0x470 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
>
> Allocated by task 1846:
>  save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
>  kmalloc ./include/linux/slab.h:493
>  kzalloc ./include/linux/slab.h:666
>  smsusb_init_device+0xd5/0xe40 drivers/media/usb/siano/smsusb.c:418
>  smsusb_probe+0x4f5/0xdc0 drivers/media/usb/siano/smsusb.c:580
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
>
> Freed by task 1846:
>  save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459
>  kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
>  slab_free_hook mm/slub.c:1390
>  slab_free_freelist_hook mm/slub.c:1412
>  slab_free mm/slub.c:2988
>  kfree+0xf6/0x2f0 mm/slub.c:3919
>  smsusb_term_device+0x166/0x1f0 drivers/media/usb/siano/smsusb.c:373
>  smsusb_init_device+0xcaa/0xe40 drivers/media/usb/siano/smsusb.c:505
>  smsusb_probe+0x4f5/0xdc0 drivers/media/usb/siano/smsusb.c:580
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
>
> The buggy address belongs to the object at ffff88006a2b8000
>  which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 240 bytes inside of
>  4096-byte region [ffff88006a2b8000, ffff88006a2b9000)
> The buggy address belongs to the page:
> page:ffffea0001a8ae00 count:1 mapcount:0 mapping:          (null)
> index:0x0 compound_mapcount: 0
> flags: 0x100000000008100(slab|head)
> raw: 0100000000008100 0000000000000000 0000000000000000 0000000180070007
> raw: dead000000000100 dead000000000200 ffff88006c402c00 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff88006a2b7f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88006a2b8000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff88006a2b8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff88006a2b8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88006a2b8180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>> ---
>> This bug report by Andrey Konovalov "usb/media/smsusb: use-after-free in
>> worker_thread".
>>
>>  drivers/media/usb/siano/smsusb.c | 45 ++++++++++++++++++++++++----------------
>>  1 file changed, 27 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
>> index 8c1f926..66936b3 100644
>> --- a/drivers/media/usb/siano/smsusb.c
>> +++ b/drivers/media/usb/siano/smsusb.c
>> @@ -69,6 +69,9 @@ struct smsusb_device_t {
>>         unsigned char in_ep;
>>         unsigned char out_ep;
>>         enum smsusb_state state;
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>> +       struct media_device *mdev;
>> +#endif
>>  };
>>
>>  static int smsusb_submit_urb(struct smsusb_device_t *dev,
>> @@ -359,6 +362,13 @@ static void smsusb_term_device(struct usb_interface *intf)
>>                 if (dev->coredev)
>>                         smscore_unregister_device(dev->coredev);
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>> +               if (dev->mdev) {
>> +                       media_device_unregister(dev->mdev);
>> +                       media_device_cleanup(dev->mdev);
>> +                       kfree(dev->mdev);
>> +               }
>> +#endif
>>                 pr_debug("device 0x%p destroyed\n", dev);
>>                 kfree(dev);
>>         }
>> @@ -370,27 +380,28 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
>>                                         int board_id)
>>  {
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>> -       struct media_device *mdev;
>>         struct usb_device *udev = dev->udev;
>>         struct sms_board *board = sms_get_board(board_id);
>>         int ret;
>>
>> -       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>> -       if (!mdev)
>> +       dev->mdev = kzalloc(sizeof(*dev->mdev), GFP_KERNEL);
>> +       if (!dev->mdev)
>>                 return NULL;
>>
>> -       media_device_usb_init(mdev, udev, board->name);
>>
>> -       ret = media_device_register(mdev);
>> +       media_device_usb_init(dev->mdev, udev, board->name);
>> +
>> +       ret = media_device_register(dev->mdev);
>>         if (ret) {
>> -               media_device_cleanup(mdev);
>> -               kfree(mdev);
>> +               media_device_cleanup(dev->mdev);
>> +               kfree(dev->mdev);
>> +               dev->mdev = NULL;
>>                 return NULL;
>>         }
>>
>>         pr_info("media controller created\n");
>>
>> -       return mdev;
>> +       return dev->mdev;
>>  #else
>>         return NULL;
>>  #endif
>> @@ -458,12 +469,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
>>         rc = smscore_register_device(&params, &dev->coredev, mdev);
>>         if (rc < 0) {
>>                 pr_err("smscore_register_device(...) failed, rc %d\n", rc);
>> -               smsusb_term_device(intf);
>> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>> -               media_device_unregister(mdev);
>> -#endif
>> -               kfree(mdev);
>> -               return rc;
>> +               goto err_smsusb_init;
>>         }
>>
>>         smscore_set_board_id(dev->coredev, board_id);
>> @@ -480,8 +486,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
>>         rc = smsusb_start_streaming(dev);
>>         if (rc < 0) {
>>                 pr_err("smsusb_start_streaming(...) failed\n");
>> -               smsusb_term_device(intf);
>> -               return rc;
>> +               goto err_smsusb_init;
>>         }
>>
>>         dev->state = SMSUSB_ACTIVE;
>> @@ -489,13 +494,17 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
>>         rc = smscore_start_device(dev->coredev);
>>         if (rc < 0) {
>>                 pr_err("smscore_start_device(...) failed\n");
>> -               smsusb_term_device(intf);
>> -               return rc;
>> +               goto err_smsusb_init;
>>         }
>>
>>         pr_debug("device 0x%p created\n", dev);
>>
>>         return rc;
>> +
>> +err_smsusb_init:
>> +       smsusb_term_device(intf);
>> +
>> +       return rc;
>>  }
>>
>>  static int smsusb_probe(struct usb_interface *intf,
>> --
>> 1.9.1
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
>> For more options, visit https://groups.google.com/d/optout.
