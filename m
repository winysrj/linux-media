Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51556 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0DGUPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 16:15:34 -0400
Received: by gyg13 with SMTP id 13so723980gyg.19
        for <linux-media@vger.kernel.org>; Wed, 07 Apr 2010 13:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BBCE61E.3090504@redhat.com>
References: <201004011001.10500.hverkuil@xs4all.nl>
	 <201004011411.02344.laurent.pinchart@ideasonboard.com>
	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>
	 <4BB4B569.3080608@redhat.com>
	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>
	 <4BBCE61E.3090504@redhat.com>
Date: Wed, 7 Apr 2010 16:15:33 -0400
Message-ID: <g2x829197381004071315o9000e858gd64d982a73d65809@mail.gmail.com>
Subject: Re: [PATCH] em28xx: fix locks during dvb init sequence - was: Re:
	V4L-DVB drivers and BKL
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 7, 2010 at 4:07 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Devin Heitmueller wrote:
>> On Thu, Apr 1, 2010 at 11:02 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> I remember I had to do it on em28xx:
>>>
>>> This is the init code for it:
>>>        ...
>>>        mutex_init(&dev->lock);
>>>        mutex_lock(&dev->lock);
>>>        em28xx_init_dev(&dev, udev, interface, nr);
>>>        ...
>>>        request_modules(dev);
>>>
>>>        /* Should be the last thing to do, to avoid newer udev's to
>>>           open the device before fully initializing it
>>>         */
>>>        mutex_unlock(&dev->lock);
>>>        ...
>>>
>>> And this is the open code:
>>>
>>> static int em28xx_v4l2_open(struct file *filp)
>>> {
>>>        ...
>>>        mutex_lock(&dev->lock);
>>>        ...
>>>        mutex_unlock(&dev->lock);
>>>
>>
>> It's probably worth noting that this change is actually pretty badly
>> broken.  Because the modules are loading asynchronously, there is a
>> high probability that the em28xx-dvb driver will still be loading when
>> hald connects in to the v4l device.  That's the big reason people
>> often see things like tvp5150 i2c errors when the driver is first
>> loaded up.
>>
>> It's a good idea in theory, but pretty fatally flawed due to the async
>> loading (as to make it work properly you would have to do something
>> like locking the mutex in em28xx and clearing it in em28xx-dvb at the
>> end of its initialization).
>
> Devin,
>
> I found some time to fix the above reported issue. Patch follows.
>
> ---
>
> V4L/DVB: em28xx: fix locks during dvb init sequence
>
> During em28xx init, em28xx-dvb needs to change to digital mode, in order to
> properly initialize. However, as soon as em28xx-video registers /dev/video0,
> udev will try to run v4l_id program, to retrieve some information that it is
> needed by udev device creation.
>
> So, while v4l_id is opening the /dev/video? device and setting the device in
> analog mode, the em28xx-dvb is putting the same device on digital mode, and
> trying to initialize the DVB demod.
>
> On devices that have a I2C bridge, this results on one of the devices to not
> being accessed, either resulting on I2C error or on wrong readings at devices
> like tvp5150.
>
> As the analog operations are protected by dev->lock, the fix is as simple as
> locking it also during em28xx-dvb initialization.
>
> While here, also simplifies the locking schema for the extension
> register/unregister functions.
>
> Tested on WinTV HVR-950 (2040:6513), doing several sequences of unload/reload.
> On all cases, the proper init happened:
>
> [ 1075.497596] tvp5150 2-005c: tvp5150am1 detected.
> [ 1075.647916] xc2028 2-0061: attaching existing instance
> [ 1075.653106] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [ 1075.659254] em28xx #0: em28xx #0/2: xc3028 attached
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index d4f4525..c8c4e8f 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -1177,21 +1177,18 @@ void em28xx_add_into_devlist(struct em28xx *dev)
>  */
>
>  static LIST_HEAD(em28xx_extension_devlist);
> -static DEFINE_MUTEX(em28xx_extension_devlist_lock);
>
>  int em28xx_register_extension(struct em28xx_ops *ops)
>  {
>        struct em28xx *dev = NULL;
>
>        mutex_lock(&em28xx_devlist_mutex);
> -       mutex_lock(&em28xx_extension_devlist_lock);
>        list_add_tail(&ops->next, &em28xx_extension_devlist);
>        list_for_each_entry(dev, &em28xx_devlist, devlist) {
>                if (dev)
>                        ops->init(dev);
>        }
>        printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
> -       mutex_unlock(&em28xx_extension_devlist_lock);
>        mutex_unlock(&em28xx_devlist_mutex);
>        return 0;
>  }
> @@ -1207,10 +1204,8 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
>                        ops->fini(dev);
>        }
>
> -       mutex_lock(&em28xx_extension_devlist_lock);
>        printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
>        list_del(&ops->next);
> -       mutex_unlock(&em28xx_extension_devlist_lock);
>        mutex_unlock(&em28xx_devlist_mutex);
>  }
>  EXPORT_SYMBOL(em28xx_unregister_extension);
> @@ -1219,26 +1214,26 @@ void em28xx_init_extension(struct em28xx *dev)
>  {
>        struct em28xx_ops *ops = NULL;
>
> -       mutex_lock(&em28xx_extension_devlist_lock);
> +       mutex_lock(&em28xx_devlist_mutex);
>        if (!list_empty(&em28xx_extension_devlist)) {
>                list_for_each_entry(ops, &em28xx_extension_devlist, next) {
>                        if (ops->init)
>                                ops->init(dev);
>                }
>        }
> -       mutex_unlock(&em28xx_extension_devlist_lock);
> +       mutex_unlock(&em28xx_devlist_mutex);
>  }
>
>  void em28xx_close_extension(struct em28xx *dev)
>  {
>        struct em28xx_ops *ops = NULL;
>
> -       mutex_lock(&em28xx_extension_devlist_lock);
> +       mutex_lock(&em28xx_devlist_mutex);
>        if (!list_empty(&em28xx_extension_devlist)) {
>                list_for_each_entry(ops, &em28xx_extension_devlist, next) {
>                        if (ops->fini)
>                                ops->fini(dev);
>                }
>        }
> -       mutex_unlock(&em28xx_extension_devlist_lock);
> +       mutex_unlock(&em28xx_devlist_mutex);
>  }
> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
> index 8f23aa1..f0de731 100644
> --- a/drivers/media/video/em28xx/em28xx-dvb.c
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
> @@ -466,6 +466,7 @@ static int dvb_init(struct em28xx *dev)
>        }
>        dev->dvb = dvb;
>
> +       mutex_lock(&dev->lock);
>        em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
>        /* init frontend */
>        switch (dev->model) {
> @@ -589,15 +590,16 @@ static int dvb_init(struct em28xx *dev)
>        if (result < 0)
>                goto out_free;
>
> -       em28xx_set_mode(dev, EM28XX_SUSPEND);
>        em28xx_info("Successfully loaded em28xx-dvb\n");
> -       return 0;
> +ret:
> +       em28xx_set_mode(dev, EM28XX_SUSPEND);
> +       mutex_unlock(&dev->lock);
> +       return result;
>
>  out_free:
> -       em28xx_set_mode(dev, EM28XX_SUSPEND);
>        kfree(dvb);
>        dev->dvb = NULL;
> -       return result;
> +       goto ret;
>  }
>
>  static int dvb_fini(struct em28xx *dev)
>

Hello Mauro,

At first glance, this looks really promising.  I will have to look at
this in more detail when I have access to the source code (I'm at the
office right now).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
