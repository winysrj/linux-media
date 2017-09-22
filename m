Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:51914 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdIVNSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 09:18:12 -0400
Received: by mail-io0-f178.google.com with SMTP id l15so2939158iol.8
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 06:18:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6debff60-5f20-2ba2-3e71-cef367785559@gmail.com>
References: <CAAeHK+wFpoxhq-i5C5q_xWzc14gu=CpeC4vsVPNeaoJiD_mEpA@mail.gmail.com>
 <c5c9b10b-77e2-d5c0-3f46-e9dfcd356f5c@gmail.com> <CAAeHK+zp8mW_03KWdSDY5Z91ZRUJrXz9SKVSZb+cNHVNFhOjuQ@mail.gmail.com>
 <6debff60-5f20-2ba2-3e71-cef367785559@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 22 Sep 2017 15:18:10 +0200
Message-ID: <CAAeHK+xCwxLETg23xaEu9X6y_yM4MUu+g0MwN+5cLCNRzzZ-9Q@mail.gmail.com>
Subject: Re: usb/media/hdpvr: trying to register non-static key in hdpvr_probe
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 22, 2017 at 3:09 PM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> Hi Andrey,
>
>
> On Friday 22 September 2017 05:16 PM, Andrey Konovalov wrote:
>>
>> On Fri, Sep 22, 2017 at 9:41 AM, Arvind Yadav <arvind.yadav.cs@gmail.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> I have a doubt. Why we are calling flush_work in hdpvr_probe for every
>>> failure.
>>> We are flushing work which is not defined yet.
>>>
>>> Here, hdpvr_register_videodev() is responsible for setup and register a
>>> video device.
>>> Also defining and initializing a worker. we are calling
>>> hdpvr_register_videodev() at last.
>>> No need to flash any work here.
>>>
>>> Please correct me, if I am wrong.
>>
>> Hi Arvind,
>>
>> I believe you're right, no need to call flush_work() before
>> dev->worker is initialized.
>>
>> Could you send a fix?
>>
>> I'm able to reproduce the issue, so I can test your patches if needed.
>
> I have send a one patch to you. which will resolve this error. But my
> question is why
> hdpvr_probe() is failing. We need to find out. Could please share more
> information and logs.

The patch helps, thanks!

hdpvr_probe() is failing, because I'm attaching a malicious USB device
that pretends to be an hdpvr device, but doesn't have a bulk-in
endpoint.

[   27.722420] gadgetfs: bound to dummy_udc driver
[   27.990245] usb 1-1: new full-speed USB device number 2 using dummy_hcd
[   28.010242] gadgetfs: connected
[   28.011732] gadgetfs: disconnected
[   28.230142] gadgetfs: connected
[   28.330313] usb 1-1: config 8 has an invalid interface number: 217
but max is 0
[   28.331981] usb 1-1: config 8 has no interface number 0
[   28.410315] usb 1-1: New USB device found, idVendor=2040, idProduct=4903
[   28.411826] usb 1-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=127
[   28.413477] usb 1-1: SerialNumber: a
[   28.440134] gadgetfs: configuration #8
[   28.467705] hdpvr 1-1:8.217: Could not find bulk-in endpoint
[   28.469024] hdpvr: probe of 1-1:8.217 failed with error -12
[   29.446584] gadgetfs: disconnected
[   29.449634] usb 1-1: USB disconnect, device number 2

>
> ~arvind
>
>> Thanks!
>>
>>>
>>> On Thursday 21 September 2017 09:09 PM, Andrey Konovalov wrote:
>>>>
>>>> Hi!
>>>>
>>>> I've got the following report while fuzzing the kernel with syzkaller.
>>>>
>>>> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
>>>>
>>>> INFO: trying to register non-static key.
>>>> the code is fine but needs lockdep annotation.
>>>> turning off the locking correctness validator.
>>>> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
>>>> 4.14.0-rc1-42251-gebb2c2437d80 #215
>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
>>>> 01/01/2011
>>>> Workqueue: usb_hub_wq hub_event
>>>> Call Trace:
>>>>    __dump_stack lib/dump_stack.c:16
>>>>    dump_stack+0x292/0x395 lib/dump_stack.c:52
>>>>    register_lock_class+0x6c4/0x1a00 kernel/locking/lockdep.c:769
>>>>    __lock_acquire+0x27e/0x4550 kernel/locking/lockdep.c:3385
>>>>    lock_acquire+0x259/0x620 kernel/locking/lockdep.c:4002
>>>>    flush_work+0xf0/0x8c0 kernel/workqueue.c:2886
>>>>    hdpvr_probe+0x233/0x20d0 drivers/media/usb/hdpvr/hdpvr-core.c:400
>>>>    usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
>>>>    really_probe drivers/base/dd.c:413
>>>>    driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>>>>    __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>>>>    bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>>>>    __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>>>>    device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>>>>    bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>>>>    device_add+0xd0b/0x1660 drivers/base/core.c:1835
>>>>    usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
>>>>    generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
>>>>    usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
>>>>    really_probe drivers/base/dd.c:413
>>>>    driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>>>>    __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>>>>    bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>>>>    __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>>>>    device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>>>>    bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>>>>    device_add+0xd0b/0x1660 drivers/base/core.c:1835
>>>>    usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
>>>>    hub_port_connect drivers/usb/core/hub.c:4903
>>>>    hub_port_connect_change drivers/usb/core/hub.c:5009
>>>>    port_event drivers/usb/core/hub.c:5115
>>>>    hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
>>>>    process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
>>>>    worker_thread+0x221/0x1850 kernel/workqueue.c:2253
>>>>    kthread+0x3a1/0x470 kernel/kthread.c:231
>>>>    ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
>>>> hdpvr: probe of 1-1:8.217 failed with error -12
>>>
>>> ~arvind
>
>
