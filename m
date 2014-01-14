Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58207 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaANSLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 13:11:49 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so4149180eaj.4
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 10:11:47 -0800 (PST)
Message-ID: <52D57E2C.2070407@googlemail.com>
Date: Tue, 14 Jan 2014 19:13:00 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/7] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-4-git-send-email-m.chehab@samsung.com> <52D4383B.6030304@googlemail.com> <20140113172334.191862a7@samsung.com> <52D460D8.1000807@googlemail.com> <20140114111054.58ede4a3@samsung.com>
In-Reply-To: <20140114111054.58ede4a3@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.01.2014 14:10, Mauro Carvalho Chehab wrote:
> Em Mon, 13 Jan 2014 22:55:36 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 13.01.2014 20:23, schrieb Mauro Carvalho Chehab:
>>> Em Mon, 13 Jan 2014 20:02:19 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
>>>>> We can't free struct em28xx while one of the extensions is still
>>>>> using it.
>>>>>
>>>>> So, add a kref() to control it, freeing it only after the
>>>>> extensions fini calls.
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>>>> ---
>>>>>    drivers/media/usb/em28xx/em28xx-audio.c |  5 ++++-
>>>>>    drivers/media/usb/em28xx/em28xx-cards.c | 34 ++++++++++++++++-----------------
>>>>>    drivers/media/usb/em28xx/em28xx-dvb.c   |  5 ++++-
>>>>>    drivers/media/usb/em28xx/em28xx-input.c |  8 +++++++-
>>>>>    drivers/media/usb/em28xx/em28xx-video.c | 11 +++++------
>>>>>    drivers/media/usb/em28xx/em28xx.h       |  9 +++++++--
>>>>>    6 files changed, 44 insertions(+), 28 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
>>>>> index 97d9105e6830..8e959dae8358 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-audio.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
>>>>> @@ -878,6 +878,8 @@ static int em28xx_audio_init(struct em28xx *dev)
>>>>>    
>>>>>    	em28xx_info("Binding audio extension\n");
>>>>>    
>>>>> +	kref_get(&dev->ref);
>>>>> +
>>>>>    	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
>>>>>    			 "Rechberger\n");
>>>>>    	printk(KERN_INFO
>>>>> @@ -949,7 +951,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
>>>>>    	if (dev == NULL)
>>>>>    		return 0;
>>>>>    
>>>>> -	if (dev->has_alsa_audio != 1) {
>>>>> +	if (!dev->has_alsa_audio) {
>>>>>    		/* This device does not support the extension (in this case
>>>>>    		   the device is expecting the snd-usb-audio module or
>>>>>    		   doesn't have analog audio support at all) */
>>>>> @@ -963,6 +965,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
>>>>>    		dev->adev.sndcard = NULL;
>>>>>    	}
>>>>>    
>>>>> +	kref_put(&dev->ref, em28xx_free_device);
>>>>>    	return 0;
>>>>>    }
>>>>>    
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
>>>>> index 3b332d527ccb..df92f417634a 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-cards.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
>>>>> @@ -2867,16 +2867,18 @@ static void flush_request_modules(struct em28xx *dev)
>>>>>    	flush_work(&dev->request_module_wk);
>>>>>    }
>>>>>    
>>>>> -/*
>>>>> - * em28xx_release_resources()
>>>>> - * unregisters the v4l2,i2c and usb devices
>>>>> - * called when the device gets disconnected or at module unload
>>>>> -*/
>>>>> -void em28xx_release_resources(struct em28xx *dev)
>>>>> +/**
>>>>> + * em28xx_release_resources() -  unregisters the v4l2,i2c and usb devices
>>>>> + *
>>>>> + * @ref: struct kref for em28xx device
>>>>> + *
>>>>> + * This is called when all extensions and em28xx core unregisters a device
>>>>> + */
>>>>> +void em28xx_free_device(struct kref *ref)
>>>>>    {
>>>>> -	/*FIXME: I2C IR should be disconnected */
>>>>> +	struct em28xx *dev = kref_to_dev(ref);
>>>>>    
>>>>> -	mutex_lock(&dev->lock);
>>>>> +	em28xx_info("Freeing device\n");
>>>>>    
>>>>>    	if (dev->def_i2c_bus)
>>>>>    		em28xx_i2c_unregister(dev, 1);
>>>>> @@ -2887,9 +2889,10 @@ void em28xx_release_resources(struct em28xx *dev)
>>>>>    	/* Mark device as unused */
>>>>>    	clear_bit(dev->devno, &em28xx_devused);
>>>>>    
>>>>> -	mutex_unlock(&dev->lock);
>>>>> -};
>>>>> -EXPORT_SYMBOL_GPL(em28xx_release_resources);
>>>>> +	kfree(dev->alt_max_pkt_size_isoc);
>>>>> +	kfree(dev);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(em28xx_free_device);
>>>>>    
>>>>>    /*
>>>>>     * em28xx_init_dev()
>>>>> @@ -3342,6 +3345,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>>>>>    			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
>>>>>    	}
>>>>>    
>>>>> +	kref_init(&dev->ref);
>>>>> +
>>>>>    	request_modules(dev);
>>>>>    
>>>>>    	/* Should be the last thing to do, to avoid newer udev's to
>>>>> @@ -3390,12 +3395,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
>>>>>    
>>>>>    	em28xx_close_extension(dev);
>>>>>    
>>>>> -	em28xx_release_resources(dev);
>>>>> -
>>>>> -	if (!dev->users) {
>>>>> -		kfree(dev->alt_max_pkt_size_isoc);
>>>>> -		kfree(dev);
>>>>> -	}
>>>>> +	kref_put(&dev->ref, em28xx_free_device);
>>>>>    }
>>>>>    
>>>>>    static struct usb_driver em28xx_usb_driver = {
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
>>>>> index 5ea563e3f0e4..8674ae5fce06 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>>>>> @@ -1010,11 +1010,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>>>>    	em28xx_info("Binding DVB extension\n");
>>>>>    
>>>>>    	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
>>>>> -
>>>>>    	if (dvb == NULL) {
>>>>>    		em28xx_info("em28xx_dvb: memory allocation failed\n");
>>>>>    		return -ENOMEM;
>>>>>    	}
>>>>> +	kref_get(&dev->ref);
>>>>>    	dev->dvb = dvb;
>>>>>    	dvb->fe[0] = dvb->fe[1] = NULL;
>>>>>    
>>>>> @@ -1442,6 +1442,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>>>>    	dvb->adapter.mfe_shared = mfe_shared;
>>>>>    
>>>>>    	em28xx_info("DVB extension successfully initialized\n");
>>>>> +
>>>>>    ret:
>>>>>    	em28xx_set_mode(dev, EM28XX_SUSPEND);
>>>>>    	mutex_unlock(&dev->lock);
>>>>> @@ -1492,6 +1493,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
>>>>>    		dev->dvb = NULL;
>>>>>    	}
>>>>>    
>>>>> +	kref_put(&dev->ref, em28xx_free_device);
>>>>> +
>>>>>    	return 0;
>>>>>    }
>>>>>    
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
>>>>> index 61c061f3a476..33388b5922a0 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-input.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-input.c
>>>>> @@ -676,6 +676,8 @@ static int em28xx_ir_init(struct em28xx *dev)
>>>>>    		return 0;
>>>>>    	}
>>>>>    
>>>>> +	kref_get(&dev->ref);
>>>>> +
>>>>>    	if (dev->board.buttons)
>>>>>    		em28xx_init_buttons(dev);
>>>>>    
>>>>> @@ -814,7 +816,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
>>>>>    
>>>>>    	/* skip detach on non attached boards */
>>>>>    	if (!ir)
>>>>> -		return 0;
>>>>> +		goto ref_put;
>>>>>    
>>>>>    	if (ir->rc)
>>>>>    		rc_unregister_device(ir->rc);
>>>>> @@ -822,6 +824,10 @@ static int em28xx_ir_fini(struct em28xx *dev)
>>>>>    	/* done */
>>>>>    	kfree(ir);
>>>>>    	dev->ir = NULL;
>>>>> +
>>>>> +ref_put:
>>>>> +	kref_put(&dev->ref, em28xx_free_device);
>>>>> +
>>>>>    	return 0;
>>>>>    }
>>>>>    
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>>>>> index 587ff3fe9402..dc10cec772ba 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>>>>> @@ -1922,8 +1922,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
>>>>>    	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>>>>>    	v4l2_device_unregister(&dev->v4l2_dev);
>>>>>    
>>>>> -	if (dev->users)
>>>>> -		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
>>>>> +	kref_put(&dev->ref, em28xx_free_device);
>>>>>    
>>>>>    	return 0;
>>>>>    }
>>>>> @@ -1945,11 +1944,9 @@ static int em28xx_v4l2_close(struct file *filp)
>>>>>    	mutex_lock(&dev->lock);
>>>>>    
>>>>>    	if (dev->users == 1) {
>>>>> -		/* free the remaining resources if device is disconnected */
>>>>> -		if (dev->disconnected) {
>>>>> -			kfree(dev->alt_max_pkt_size_isoc);
>>>>> +		/* No sense to try to write to the device */
>>>>> +		if (dev->disconnected)
>>>>>    			goto exit;
>>>>> -		}
>>>>>    
>>>>>    		/* Save some power by putting tuner to sleep */
>>>>>    		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
>>>>> @@ -2201,6 +2198,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>>>>>    
>>>>>    	em28xx_info("Registering V4L2 extension\n");
>>>>>    
>>>>> +	kref_get(&dev->ref);
>>>>> +
>>>>>    	mutex_lock(&dev->lock);
>>>>>    
>>>>>    	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
>>>>> index 5d5d1b6f0294..d38c08e4da60 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx.h
>>>>> +++ b/drivers/media/usb/em28xx/em28xx.h
>>>>> @@ -32,6 +32,7 @@
>>>>>    #include <linux/workqueue.h>
>>>>>    #include <linux/i2c.h>
>>>>>    #include <linux/mutex.h>
>>>>> +#include <linux/kref.h>
>>>>>    #include <linux/videodev2.h>
>>>>>    
>>>>>    #include <media/videobuf2-vmalloc.h>
>>>>> @@ -531,9 +532,11 @@ struct em28xx_i2c_bus {
>>>>>    	enum em28xx_i2c_algo_type algo_type;
>>>>>    };
>>>>>    
>>>>> -
>>>>>    /* main device struct */
>>>>>    struct em28xx {
>>>>> +	struct kref ref;
>>>>> +
>>>>> +
>>>>>    	/* generic device properties */
>>>>>    	char name[30];		/* name (including minor) of the device */
>>>>>    	int model;		/* index in the device_data struct */
>>>>> @@ -706,6 +709,8 @@ struct em28xx {
>>>>>    	struct em28xx_dvb *dvb;
>>>>>    };
>>>>>    
>>>>> +#define kref_to_dev(d) container_of(d, struct em28xx, ref)
>>>>> +
>>>>>    struct em28xx_ops {
>>>>>    	struct list_head next;
>>>>>    	char *name;
>>>>> @@ -763,7 +768,7 @@ extern struct em28xx_board em28xx_boards[];
>>>>>    extern struct usb_device_id em28xx_id_table[];
>>>>>    int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
>>>>>    void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
>>>>> -void em28xx_release_resources(struct em28xx *dev);
>>>>> +void em28xx_free_device(struct kref *ref);
>>>>>    
>>>>>    /* Provided by em28xx-camera.c */
>>>>>    int em28xx_detect_sensor(struct em28xx *dev);
>>>> I welcome this patch and the general approach looks good.
>>>> I had started working on the same issue, but it's not that trivial.
>>>>
>>>> At first glance there seem to be several issues, but I will need to
>>>> review this patch in more detail and also make some tests.
>>>> Unfortunately, I don't have much time this evening, So could you please
>>>> hold it back another day ?
>>>> I hope I can review the other remaining patch of this series (patch 5/7)
>>>> later this evening.
>>> We're running out of time for 3.14. I think we should merge this patch
>>> series, and your patch series for 3.14, to be together with the em28xx-v4l
>>> split.
>>>
>>> My plan is to merge the remaining patches for 3.14 today or, in the worse
>>> case, tomorrow.
>>>
>>> If we slip on some bug, we'll still have the 3.14-rc cycle to fix, if the
>>> series gets merged, but, if we miss the bus, I'm afraid that we'll end
>>> by having more problems that will be hard to fix with trivial patches, due
>>> to em28xx-v4l split changes that also affected the driver removal and device
>>> close code.
>>>
>>> FYI, I tested this code and also Antti with our devices, randomly removing
>>> the devices while streaming, and this is now finally working.
>>>
>>> I won't doubt that there are some cases that require fixes (and
>>> it seems that em28xx-rc has one of such corner cases), but they'll likely
>>> can be solved with somewhat short and trivial patches.
>>>
>>> Cheers,
>>> Mauro
>> This is a very critical patch and exactly the kind of change that should
>> _never_ be hurried !
>> FAICS it has some severe issues and it's not clear how easy it will be
>> to fix it within the the 3.14-rc cycle.
>> As long as it's not ready, don't merge it for 3.14.
> What issues? So far, you didn't point any.
I already stated that I didn't have the time yet to review and test it 
in detail, but I'm going to do that as soon as possible.
If you can't wait, there's nothing I can do, sorry.

At first glance it seems there are at least 2 issues:
1.) use after freeing in v4l-extension (happens when the device is 
closed after the usb disconnect)
2.) error paths in the init() functions ?


> On both my tests and Antti's one,
> with this series, there were significant improvements on removing existing
> bugs with device removal.
I'm talking about this specific patch here, not the whole series.
I have no objections against the rest of the series (well, with the 
exception of patch 5 at the moment).

>
>> em28xx resources releasing is broken since ... well... at least 2 years.
>> 3.14 will already be much better and nobody will care if this remaining
>> issue is addressed a kernel release later.
> Although I think that we're properly releasing resources, I'm a way less
> concerned about keeping some leaked memory while releasing them than I am
> concerned that a device removal that would cause an OOPS, or a deadly
> crash at the USB or ALSA stack that prevents other devices to be probed.
>
> Due to em28xx-v4l calling em28xx_release_resources(), now both the
> USB and ALSA stacks crashes if you remove a device while ALSA is streaming.
>
> That happens because em28xx, I2C, etc will be freed by em28xx-v4l, but
> those resources are still needed by em28xx-alsa. That makes that the
> .fini code there to cause crash at ALSA stack, and, sometimes, at the
> USB stack.

That's not true anymore, em28xx_release_resources() is now only called 
by the usb disconnect handler in the core _after_ all fini() functions 
have been called.
Maybe you tested that without my patch series ? See patch 7/8.

> As nowadays lots of components depend on pulseaudio, the ALSA crash
> causes pulse to stop work, likely keeping it into some dead lock status.
> This makes the entire machine to become really slow, when it doesn't
> crash.
>
> This is a serious regression that should be fixed.
>
> This patch series for sure fixes it. As I said, there are two independent
> series of tests verifying that (both using several different em28xx
> devices).
>
>> Be warned !
>>
>>
>

