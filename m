Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:38406 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754346AbdLNXcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 18:32:31 -0500
Received: by mail-ot0-f193.google.com with SMTP id p3so6397954oti.5
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 15:32:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171214232533.GA26165@roeck-us.net>
References: <b5c06a8e071d38fc4b4df20b7f9c8fb25d5408fe.1506085151.git.arvind.yadav.cs@gmail.com>
 <20171214232533.GA26165@roeck-us.net>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 15 Dec 2017 00:32:29 +0100
Message-ID: <CAAeHK+yo8ZyC+zZV5E4nuQfXhCWym7o_+hO7epn=Z95S+TTGzw@mail.gmail.com>
Subject: Re: [media] hdpvr: Fix an error handling path in hdpvr_probe()
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 15, 2017 at 12:25 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Sep 22, 2017 at 06:37:06PM +0530, Arvind Yadav wrote:
>> Here, hdpvr_register_videodev() is responsible for setup and
>> register a video device. Also defining and initializing a worker.
>> hdpvr_register_videodev() is calling by hdpvr_probe at last.
>> So No need to flash any work here.
>> Unregister v4l2, free buffers and memory. If hdpvr_probe() will fail.
>>
>> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
>> Reported-by: Andrey Konovalov <andreyknvl@google.com>
>> Tested-by: Andrey Konovalov <andreyknvl@google.com>
>
> It looks like this patch was never applied upstream. It fixes
> CVE-2017-16644 [1].
>
> Did it get lost, or is there some reason for not applying it ?

Hi!

I got an email that It was queued to the media tree about a week ago.
I guess that means that it's going to be applied upstream eventually.
It took quite a lot of time for some reason though.

Thanks!

>
> Thanks,
> Guenter
>
> ---
> [1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-16644
>
>> ---
>>  drivers/media/usb/hdpvr/hdpvr-core.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
>> index dbe29c6..1e8cbaf 100644
>> --- a/drivers/media/usb/hdpvr/hdpvr-core.c
>> +++ b/drivers/media/usb/hdpvr/hdpvr-core.c
>> @@ -292,7 +292,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>>       /* register v4l2_device early so it can be used for printks */
>>       if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
>>               dev_err(&interface->dev, "v4l2_device_register failed\n");
>> -             goto error;
>> +             goto error_free_dev;
>>       }
>>
>>       mutex_init(&dev->io_mutex);
>> @@ -301,7 +301,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>>       dev->usbc_buf = kmalloc(64, GFP_KERNEL);
>>       if (!dev->usbc_buf) {
>>               v4l2_err(&dev->v4l2_dev, "Out of memory\n");
>> -             goto error;
>> +             goto error_v4l2_unregister;
>>       }
>>
>>       init_waitqueue_head(&dev->wait_buffer);
>> @@ -339,13 +339,13 @@ static int hdpvr_probe(struct usb_interface *interface,
>>       }
>>       if (!dev->bulk_in_endpointAddr) {
>>               v4l2_err(&dev->v4l2_dev, "Could not find bulk-in endpoint\n");
>> -             goto error;
>> +             goto error_put_usb;
>>       }
>>
>>       /* init the device */
>>       if (hdpvr_device_init(dev)) {
>>               v4l2_err(&dev->v4l2_dev, "device init failed\n");
>> -             goto error;
>> +             goto error_put_usb;
>>       }
>>
>>       mutex_lock(&dev->io_mutex);
>> @@ -353,7 +353,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>>               mutex_unlock(&dev->io_mutex);
>>               v4l2_err(&dev->v4l2_dev,
>>                        "allocating transfer buffers failed\n");
>> -             goto error;
>> +             goto error_put_usb;
>>       }
>>       mutex_unlock(&dev->io_mutex);
>>
>> @@ -361,7 +361,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>>       retval = hdpvr_register_i2c_adapter(dev);
>>       if (retval < 0) {
>>               v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
>> -             goto error;
>> +             goto error_free_buffers;
>>       }
>>
>>       client = hdpvr_register_ir_rx_i2c(dev);
>> @@ -394,13 +394,17 @@ static int hdpvr_probe(struct usb_interface *interface,
>>  reg_fail:
>>  #if IS_ENABLED(CONFIG_I2C)
>>       i2c_del_adapter(&dev->i2c_adapter);
>> +error_free_buffers:
>>  #endif
>> +     hdpvr_free_buffers(dev);
>> +error_put_usb:
>> +     usb_put_dev(dev->udev);
>> +     kfree(dev->usbc_buf);
>> +error_v4l2_unregister:
>> +     v4l2_device_unregister(&dev->v4l2_dev);
>> +error_free_dev:
>> +     kfree(dev);
>>  error:
>> -     if (dev) {
>> -             flush_work(&dev->worker);
>> -             /* this frees allocated memory */
>> -             hdpvr_delete(dev);
>> -     }
>>       return retval;
>>  }
>>
