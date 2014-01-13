Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45819 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaAMTBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 14:01:12 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so893527eek.37
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 11:01:10 -0800 (PST)
Message-ID: <52D4383B.6030304@googlemail.com>
Date: Mon, 13 Jan 2014 20:02:19 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/7] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-4-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
> We can't free struct em28xx while one of the extensions is still
> using it.
>
> So, add a kref() to control it, freeing it only after the
> extensions fini calls.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-audio.c |  5 ++++-
>   drivers/media/usb/em28xx/em28xx-cards.c | 34 ++++++++++++++++-----------------
>   drivers/media/usb/em28xx/em28xx-dvb.c   |  5 ++++-
>   drivers/media/usb/em28xx/em28xx-input.c |  8 +++++++-
>   drivers/media/usb/em28xx/em28xx-video.c | 11 +++++------
>   drivers/media/usb/em28xx/em28xx.h       |  9 +++++++--
>   6 files changed, 44 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 97d9105e6830..8e959dae8358 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -878,6 +878,8 @@ static int em28xx_audio_init(struct em28xx *dev)
>   
>   	em28xx_info("Binding audio extension\n");
>   
> +	kref_get(&dev->ref);
> +
>   	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
>   			 "Rechberger\n");
>   	printk(KERN_INFO
> @@ -949,7 +951,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
>   	if (dev == NULL)
>   		return 0;
>   
> -	if (dev->has_alsa_audio != 1) {
> +	if (!dev->has_alsa_audio) {
>   		/* This device does not support the extension (in this case
>   		   the device is expecting the snd-usb-audio module or
>   		   doesn't have analog audio support at all) */
> @@ -963,6 +965,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
>   		dev->adev.sndcard = NULL;
>   	}
>   
> +	kref_put(&dev->ref, em28xx_free_device);
>   	return 0;
>   }
>   
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 3b332d527ccb..df92f417634a 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2867,16 +2867,18 @@ static void flush_request_modules(struct em28xx *dev)
>   	flush_work(&dev->request_module_wk);
>   }
>   
> -/*
> - * em28xx_release_resources()
> - * unregisters the v4l2,i2c and usb devices
> - * called when the device gets disconnected or at module unload
> -*/
> -void em28xx_release_resources(struct em28xx *dev)
> +/**
> + * em28xx_release_resources() -  unregisters the v4l2,i2c and usb devices
> + *
> + * @ref: struct kref for em28xx device
> + *
> + * This is called when all extensions and em28xx core unregisters a device
> + */
> +void em28xx_free_device(struct kref *ref)
>   {
> -	/*FIXME: I2C IR should be disconnected */
> +	struct em28xx *dev = kref_to_dev(ref);
>   
> -	mutex_lock(&dev->lock);
> +	em28xx_info("Freeing device\n");
>   
>   	if (dev->def_i2c_bus)
>   		em28xx_i2c_unregister(dev, 1);
> @@ -2887,9 +2889,10 @@ void em28xx_release_resources(struct em28xx *dev)
>   	/* Mark device as unused */
>   	clear_bit(dev->devno, &em28xx_devused);
>   
> -	mutex_unlock(&dev->lock);
> -};
> -EXPORT_SYMBOL_GPL(em28xx_release_resources);
> +	kfree(dev->alt_max_pkt_size_isoc);
> +	kfree(dev);
> +}
> +EXPORT_SYMBOL_GPL(em28xx_free_device);
>   
>   /*
>    * em28xx_init_dev()
> @@ -3342,6 +3345,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>   			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
>   	}
>   
> +	kref_init(&dev->ref);
> +
>   	request_modules(dev);
>   
>   	/* Should be the last thing to do, to avoid newer udev's to
> @@ -3390,12 +3395,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
>   
>   	em28xx_close_extension(dev);
>   
> -	em28xx_release_resources(dev);
> -
> -	if (!dev->users) {
> -		kfree(dev->alt_max_pkt_size_isoc);
> -		kfree(dev);
> -	}
> +	kref_put(&dev->ref, em28xx_free_device);
>   }
>   
>   static struct usb_driver em28xx_usb_driver = {
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 5ea563e3f0e4..8674ae5fce06 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1010,11 +1010,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   	em28xx_info("Binding DVB extension\n");
>   
>   	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
> -
>   	if (dvb == NULL) {
>   		em28xx_info("em28xx_dvb: memory allocation failed\n");
>   		return -ENOMEM;
>   	}
> +	kref_get(&dev->ref);
>   	dev->dvb = dvb;
>   	dvb->fe[0] = dvb->fe[1] = NULL;
>   
> @@ -1442,6 +1442,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   	dvb->adapter.mfe_shared = mfe_shared;
>   
>   	em28xx_info("DVB extension successfully initialized\n");
> +
>   ret:
>   	em28xx_set_mode(dev, EM28XX_SUSPEND);
>   	mutex_unlock(&dev->lock);
> @@ -1492,6 +1493,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
>   		dev->dvb = NULL;
>   	}
>   
> +	kref_put(&dev->ref, em28xx_free_device);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 61c061f3a476..33388b5922a0 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -676,6 +676,8 @@ static int em28xx_ir_init(struct em28xx *dev)
>   		return 0;
>   	}
>   
> +	kref_get(&dev->ref);
> +
>   	if (dev->board.buttons)
>   		em28xx_init_buttons(dev);
>   
> @@ -814,7 +816,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
>   
>   	/* skip detach on non attached boards */
>   	if (!ir)
> -		return 0;
> +		goto ref_put;
>   
>   	if (ir->rc)
>   		rc_unregister_device(ir->rc);
> @@ -822,6 +824,10 @@ static int em28xx_ir_fini(struct em28xx *dev)
>   	/* done */
>   	kfree(ir);
>   	dev->ir = NULL;
> +
> +ref_put:
> +	kref_put(&dev->ref, em28xx_free_device);
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 587ff3fe9402..dc10cec772ba 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1922,8 +1922,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
>   	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>   	v4l2_device_unregister(&dev->v4l2_dev);
>   
> -	if (dev->users)
> -		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
> +	kref_put(&dev->ref, em28xx_free_device);
>   
>   	return 0;
>   }
> @@ -1945,11 +1944,9 @@ static int em28xx_v4l2_close(struct file *filp)
>   	mutex_lock(&dev->lock);
>   
>   	if (dev->users == 1) {
> -		/* free the remaining resources if device is disconnected */
> -		if (dev->disconnected) {
> -			kfree(dev->alt_max_pkt_size_isoc);
> +		/* No sense to try to write to the device */
> +		if (dev->disconnected)
>   			goto exit;
> -		}
>   
>   		/* Save some power by putting tuner to sleep */
>   		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> @@ -2201,6 +2198,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>   
>   	em28xx_info("Registering V4L2 extension\n");
>   
> +	kref_get(&dev->ref);
> +
>   	mutex_lock(&dev->lock);
>   
>   	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 5d5d1b6f0294..d38c08e4da60 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -32,6 +32,7 @@
>   #include <linux/workqueue.h>
>   #include <linux/i2c.h>
>   #include <linux/mutex.h>
> +#include <linux/kref.h>
>   #include <linux/videodev2.h>
>   
>   #include <media/videobuf2-vmalloc.h>
> @@ -531,9 +532,11 @@ struct em28xx_i2c_bus {
>   	enum em28xx_i2c_algo_type algo_type;
>   };
>   
> -
>   /* main device struct */
>   struct em28xx {
> +	struct kref ref;
> +
> +
>   	/* generic device properties */
>   	char name[30];		/* name (including minor) of the device */
>   	int model;		/* index in the device_data struct */
> @@ -706,6 +709,8 @@ struct em28xx {
>   	struct em28xx_dvb *dvb;
>   };
>   
> +#define kref_to_dev(d) container_of(d, struct em28xx, ref)
> +
>   struct em28xx_ops {
>   	struct list_head next;
>   	char *name;
> @@ -763,7 +768,7 @@ extern struct em28xx_board em28xx_boards[];
>   extern struct usb_device_id em28xx_id_table[];
>   int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
>   void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
> -void em28xx_release_resources(struct em28xx *dev);
> +void em28xx_free_device(struct kref *ref);
>   
>   /* Provided by em28xx-camera.c */
>   int em28xx_detect_sensor(struct em28xx *dev);
I welcome this patch and the general approach looks good.
I had started working on the same issue, but it's not that trivial.

At first glance there seem to be several issues, but I will need to 
review this patch in more detail and also make some tests.
Unfortunately, I don't have much time this evening, So could you please 
hold it back another day ?
I hope I can review the other remaining patch of this series (patch 5/7) 
later this evening.

Regards,
Frank
