Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.107]:30139 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751525AbdKWB4Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 20:56:24 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8077C7D77
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 19:32:00 -0600 (CST)
Date: Wed, 22 Nov 2017 19:31:59 -0600
Message-ID: <20171122193159.Horde.FRo8B41DAeyjHhZnK47VCGn@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH] au0828: fix use-after-free at USB probing
References: <CAAeHK+wZXZMxqQn9QbAd3xWt00_bKir4-La2QKtzk8nFb0FQmw@mail.gmail.com>
 <20171110002134.GA32019@embeddedor.com>
 <CAAeHK+zC2-7cP+oJbKPOUs+5Un5+TUkMY2FNs=z+GxLZa4kQug@mail.gmail.com>
 <20171110113552.Horde.eGcnMRStkxzNDhQOqlhnkI5@gator4166.hostgator.com>
 <CAAeHK+y_DA=jf=zThqmO5OE1DJ5u8yJngM=pEUi1_ySLMVpYDg@mail.gmail.com>
In-Reply-To: <CAAeHK+y_DA=jf=zThqmO5OE1DJ5u8yJngM=pEUi1_ySLMVpYDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

I have successfully installed and tested syzkaller with QEMU. Can you  
please tell me how to reproduce this bug or share with me the full  
crash report?

Also, can you point me out to the PoC file?

Much appreciated
Thank you!
--
Gustavo A. R. Silva

Quoting Andrey Konovalov <andreyknvl@google.com>:

> On Fri, Nov 10, 2017 at 6:35 PM, Gustavo A. R. Silva
> <garsilva@embeddedor.com> wrote:
>>
>> Quoting Andrey Konovalov <andreyknvl@google.com>:
>>
>>> On Fri, Nov 10, 2017 at 1:21 AM, Gustavo A. R. Silva
>>> <garsilva@embeddedor.com> wrote:
>>>>
>>>> Hi Andrey,
>>>>
>>>> Could you please try this patch?
>>>>
>>>> Thank you
>
> Hi!
>
> Sorry for the delay.
>
> With this patch I still see the same report:
>
> au0828: recv_control_msg() Failed receiving control message, error -71.
> au0828: recv_control_msg() Failed receiving control message, error -71.
> au0828: recv_control_msg() Failed receiving control message, error -71.
> au8522_writereg: writereg error (reg == 0x106, val == 0x0001, ret == -5)
> usb 1-1: selecting invalid altsetting 5
> au0828: Failure setting usb interface0 to as5
> au0828: au0828_usb_probe() au0282_dev_register failed to register on V4L2
> au0828: probe of 1-1:0.0 failed with error -22
> usb 1-1: USB disconnect, device number 3
> ==================================================================
> BUG: KASAN: use-after-free in __list_del_entry_valid+0xda/0xf3
> Read of size 8 at addr ffff880062a74410 by task kworker/0:1/24
>
> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
> 4.14.0-rc8-44455-ge2105594a876-dirty #111
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:17
>  dump_stack+0xe1/0x157 lib/dump_stack.c:53
>  print_address_description+0x71/0x234 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351
>  kasan_report+0x173/0x270 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
>  __list_del_entry_valid+0xda/0xf3 lib/list_debug.c:54
>  __list_del_entry ./include/linux/list.h:117
>  list_del_init ./include/linux/list.h:159
>  device_pm_remove+0x4a/0x1e7 drivers/base/power/main.c:149
>  device_del+0x599/0xa70 drivers/base/core.c:1986
>  usb_disable_device+0x223/0x710 drivers/usb/core/message.c:1170
>  usb_disconnect+0x285/0x7f0 drivers/usb/core/hub.c:2205
>  hub_port_connect drivers/usb/core/hub.c:4838
>  hub_port_connect_change drivers/usb/core/hub.c:5093
>  port_event drivers/usb/core/hub.c:5199
>  hub_event_impl+0x10ec/0x3440 drivers/usb/core/hub.c:5311
>  hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
>  process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
>  process_scheduled_works kernel/workqueue.c:2173
>  worker_thread+0x72e/0x10d0 kernel/workqueue.c:2249
>  kthread+0x346/0x410 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:432
>
> The buggy address belongs to the page:
> page:ffffea00018a9d00 count:0 mapcount:-127 mapping:          (null)  
> index:0x0
> flags: 0x100000000000000()
> raw: 0100000000000000 0000000000000000 0000000000000000 00000000ffffff80
> raw: ffff88007fffa690 ffffea00018e6120 0000000000000002 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff880062a74300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff880062a74380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ffff880062a74400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                          ^
>  ffff880062a74480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff880062a74500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> =================================================================
>
> Thanks!
>
>>>
>>>
>>> Hi Gustavo,
>>>
>>> With your patch I get a different crash. Not sure if it's another bug
>>> or the same one manifesting differently.
>>>
>>
>> That's the same one. It seems that the best solution is to remove the kfree
>> after the mutex_unlock and let the device resources be freed in
>> au0828_usb_disconnect.
>>
>> Please try the following patch instead.
>>
>> I appreciate your help.
>>
>> Thank you, Andrey.
>>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c
>> b/drivers/media/usb/au0828/au0828-core.c
>> index cd363a2..257ae0d 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -629,7 +629,6 @@ static int au0828_usb_probe(struct usb_interface
>> *interface,
>>                 pr_err("%s() au0282_dev_register failed to register on
>> V4L2\n",
>>                         __func__);
>>                 mutex_unlock(&dev->lock);
>> -               kfree(dev);
>>                 goto done;
>>         }
>>
>> --
>> 2.7.4
>>
>>
>>> au0828: recv_control_msg() Failed receiving control message, error -71.
>>> au0828: recv_control_msg() Failed receiving control message, error -71.
>>> au8522_writereg: writereg error (reg == 0x106, val == 0x0001, ret == -5)
>>> usb 1-1: selecting invalid altsetting 5
>>> au0828: Failure setting usb interface0 to as5
>>> au0828: au0828_usb_probe() au0282_dev_register failed to register on V4L2
>>> au0828: probe of 1-1:0.0 failed with error -22
>>> usb 1-1: USB disconnect, device number 2
>>> ==================================================================
>>> BUG: KASAN: use-after-free in __list_del_entry_valid+0xda/0xf3
>>> Read of size 8 at addr ffff8800641d0410 by task kworker/0:1/24
>>>
>>> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
>>> 4.14.0-rc5-43687-g72e555fa3d2e-dirty #105
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
>>> 01/01/2011
>>> Workqueue: usb_hub_wq hub_event
>>> Call Trace:
>>>  __dump_stack lib/dump_stack.c:16
>>>  dump_stack+0xc1/0x11f lib/dump_stack.c:52
>>>  print_address_description+0x71/0x234 mm/kasan/report.c:252
>>>  kasan_report_error mm/kasan/report.c:351
>>>  kasan_report+0x173/0x270 mm/kasan/report.c:409
>>>  __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
>>>  __list_del_entry_valid+0xda/0xf3 lib/list_debug.c:54
>>>  __list_del_entry ./include/linux/list.h:116
>>>  list_del_init ./include/linux/list.h:158
>>>  device_pm_remove+0x4a/0x1da drivers/base/power/main.c:149
>>>  device_del+0x55f/0xa30 drivers/base/core.c:1986
>>>  usb_disable_device+0x1df/0x670 drivers/usb/core/message.c:1170
>>>  usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
>>>  hub_port_connect drivers/usb/core/hub.c:4754
>>>  hub_port_connect_change drivers/usb/core/hub.c:5009
>>>  port_event drivers/usb/core/hub.c:5115
>>>  hub_event+0xe09/0x2eb0 drivers/usb/core/hub.c:5195
>>>  process_one_work+0x86d/0x13e0 kernel/workqueue.c:2119
>>>  process_scheduled_works kernel/workqueue.c:2179
>>>  worker_thread+0x689/0xea0 kernel/workqueue.c:2255
>>>  kthread+0x334/0x400 kernel/kthread.c:231
>>>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
>>>
>>> The buggy address belongs to the page:
>>> page:ffffea0001907400 count:0 mapcount:-127 mapping:          (null)
>>> index:0x0
>>> flags: 0x100000000000000()
>>> raw: 0100000000000000 0000000000000000 0000000000000000 00000000ffffff80
>>> raw: ffffea00018a8f20 ffff88007fffa690 0000000000000002 0000000000000000
>>> page dumped because: kasan: bad access detected
>>>
>>> Memory state around the buggy address:
>>>  ffff8800641d0300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  ffff8800641d0380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>
>>>> ffff8800641d0400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>
>>>                          ^
>>>  ffff8800641d0480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  ffff8800641d0500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> ==================================================================
>>>
>>> Thanks!
>>>
>>>>
>>>>
>>>> The device is typically freed on failure after trying to set
>>>> USB interface0 to as5 in function au0828_analog_register.
>>>>
>>>> Fix use-after-free by returning the error value inmediately
>>>> after failure, instead of jumping to au0828_usb_disconnect
>>>> where _dev_ is also freed.
>>>>
>>>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>>>> ---
>>>>  drivers/media/usb/au0828/au0828-core.c | 3 +--
>>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/au0828/au0828-core.c
>>>> b/drivers/media/usb/au0828/au0828-core.c
>>>> index cd363a2..b4abd90 100644
>>>> --- a/drivers/media/usb/au0828/au0828-core.c
>>>> +++ b/drivers/media/usb/au0828/au0828-core.c
>>>> @@ -630,7 +630,7 @@ static int au0828_usb_probe(struct usb_interface
>>>> *interface,
>>>>                         __func__);
>>>>                 mutex_unlock(&dev->lock);
>>>>                 kfree(dev);
>>>> -               goto done;
>>>> +               return retval;
>>>>         }
>>>>
>>>>         /* Digital TV */
>>>> @@ -655,7 +655,6 @@ static int au0828_usb_probe(struct usb_interface
>>>> *interface,
>>>>
>>>>         retval = au0828_media_device_register(dev, usbdev);
>>>>
>>>> -done:
>>>>         if (retval < 0)
>>>>                 au0828_usb_disconnect(interface);
>>>>
>>>> --
>>>> 2.7.4
>>>>
>>
>>
>>
>>
>>
>>
