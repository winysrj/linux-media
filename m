Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:12467 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaBIUJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 15:09:25 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0Q006T9VZORF20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 09 Feb 2014 15:09:24 -0500 (EST)
Date: Mon, 10 Feb 2014 05:09:20 +0900
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] em28xx: Only deallocate struct em28xx after finishing
 all extensions
Message-id: <20140210050920.45b4c0c7.m.chehab@samsung.com>
In-reply-to: <52F7CBC5.4030207@googlemail.com>
References: <1389567649-26838-4-git-send-email-m.chehab@samsung.com>
 <1389721013-20231-1-git-send-email-m.chehab@samsung.com>
 <52D6F9E8.1010702@googlemail.com> <52F7CBC5.4030207@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 09 Feb 2014 19:41:09 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> 
> Am 15.01.2014 22:13, schrieb Frank Schäfer:
> > Am 14.01.2014 18:36, schrieb Mauro Carvalho Chehab:
> >> We can't free struct em28xx while one of the extensions is still
> >> using it.
> >>
> >> So, add a kref() to control it, freeing it only after the
> >> extensions fini calls.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >> ---
> >>
> >> v2:
> >> 	- patch was rebased;
> >> 	- as em28xx-audio close uses struct em28xx dev, add a kref in order
> >> 	  to track audio open/close.
> >>
> >>  drivers/media/usb/em28xx/em28xx-audio.c |  8 +++++++-
> >>  drivers/media/usb/em28xx/em28xx-cards.c | 34 ++++++++++++++++-----------------
> >>  drivers/media/usb/em28xx/em28xx-dvb.c   |  5 ++++-
> >>  drivers/media/usb/em28xx/em28xx-input.c |  8 +++++++-
> >>  drivers/media/usb/em28xx/em28xx-video.c | 14 ++++++++------
> >>  drivers/media/usb/em28xx/em28xx.h       |  9 +++++++--
> >>  6 files changed, 50 insertions(+), 28 deletions(-)
> >>
> >> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> >> index 45bea1adc11c..73eeeaf6551f 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> >> @@ -265,6 +265,8 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >>  
> >>  	dprintk("opening device and trying to acquire exclusive lock\n");
> >>  
> >> +	kref_get(&dev->ref);
> >> +
> > When snd_em28xx_capture_open() fails, there will never be a close()
> > call, right ?
> > So kref_get() needs to be called when we are sure that the function
> > succeeds.

Makes sense.

> >
> >>  	runtime->hw = snd_em28xx_hw_capture;
> >>  	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
> >>  		int nonblock = !!(substream->f_flags & O_NONBLOCK);
> >> @@ -330,6 +332,7 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
> >>  		substream->runtime->dma_area = NULL;
> >>  	}
> >>  	mutex_unlock(&dev->lock);
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >>  
> >>  	return 0;
> >>  }
> >> @@ -886,6 +889,8 @@ static int em28xx_audio_init(struct em28xx *dev)
> >>  
> >>  	em28xx_info("Binding audio extension\n");
> >>  
> >> +	kref_get(&dev->ref);
> >> +
> >>  	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
> >>  			 "Rechberger\n");
> >>  	printk(KERN_INFO
> >> @@ -958,7 +963,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
> >>  	if (dev == NULL)
> >>  		return 0;
> >>  
> >> -	if (dev->has_alsa_audio != 1) {
> >> +	if (!dev->has_alsa_audio) {
> >>  		/* This device does not support the extension (in this case
> >>  		   the device is expecting the snd-usb-audio module or
> >>  		   doesn't have analog audio support at all) */
> >> @@ -977,6 +982,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
> >>  		dev->adev.sndcard = NULL;
> >>  	}
> >>  
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >>  	return 0;
> >>  }
> >>  
> >> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> >> index e08d65b2e352..8fc0a437054e 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> >> @@ -2867,16 +2867,18 @@ static void flush_request_modules(struct em28xx *dev)
> >>  	flush_work(&dev->request_module_wk);
> >>  }
> >>  
> >> -/*
> >> - * em28xx_release_resources()
> >> - * unregisters the v4l2,i2c and usb devices
> >> - * called when the device gets disconnected or at module unload
> >> -*/
> >> -void em28xx_release_resources(struct em28xx *dev)
> >> +/**
> >> + * em28xx_release_resources() -  unregisters the v4l2,i2c and usb devices
> >> + *
> >> + * @ref: struct kref for em28xx device
> >> + *
> >> + * This is called when all extensions and em28xx core unregisters a device
> >> + */
> >> +void em28xx_free_device(struct kref *ref)
> >>  {
> >> -	/*FIXME: I2C IR should be disconnected */
> >> +	struct em28xx *dev = kref_to_dev(ref);
> >>  
> >> -	mutex_lock(&dev->lock);
> >> +	em28xx_info("Freeing device\n");
> >>  
> >>  	if (dev->def_i2c_bus)
> >>  		em28xx_i2c_unregister(dev, 1);
> >> @@ -2887,9 +2889,10 @@ void em28xx_release_resources(struct em28xx *dev)
> >>  	/* Mark device as unused */
> >>  	clear_bit(dev->devno, &em28xx_devused);
> >>  
> >> -	mutex_unlock(&dev->lock);
> >> -};
> >> -EXPORT_SYMBOL_GPL(em28xx_release_resources);
> >> +	kfree(dev->alt_max_pkt_size_isoc);
> >> +	kfree(dev);
> >> +}
> >> +EXPORT_SYMBOL_GPL(em28xx_free_device);
> > This reintroduces the sysfs group removal warnings.
> > Just keep em28xx_release_resources() as is and add let
> > em28xx_free_device() call the the two kfrees() only.

Calling em28xx_free_device from any subdriver seems wrong, as all subdevs
need it. We should drop it only at the last kref_put().

You should remind that subdrivers can be removed and reinserted any time,
without causing OOPS or other issues.

So, if this is still needed to avoid sysfs warnings, then there's
something else wrong.

> >
> >>  /*
> >>   * em28xx_init_dev()
> >> @@ -3342,6 +3345,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >>  			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
> >>  	}
> >>  
> >> +	kref_init(&dev->ref);
> >> +
> >>  	request_modules(dev);
> >>  
> >>  	/* Should be the last thing to do, to avoid newer udev's to
> >> @@ -3385,12 +3390,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
> >>  
> >>  	em28xx_close_extension(dev);
> >>  
> >> -	em28xx_release_resources(dev);
> > Keep this call (see above).
> >
> >> -
> >> -	if (!dev->users) {
> >> -		kfree(dev->alt_max_pkt_size_isoc);
> >> -		kfree(dev);
> >> -	}
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >>  }
> >>  
> >>  static struct usb_driver em28xx_usb_driver = {
> >> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> >> index 881a813836eb..7df21e33a923 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> >> @@ -1005,11 +1005,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >>  	em28xx_info("Binding DVB extension\n");
> >>  
> >>  	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
> >> -
> >>  	if (dvb == NULL) {
> >>  		em28xx_info("em28xx_dvb: memory allocation failed\n");
> >>  		return -ENOMEM;
> >>  	}
> >> +	kref_get(&dev->ref);
> > This one needs to be moved between the em28xx_infp() and the kzalloc()
> > call above.
> >
> >>  	dev->dvb = dvb;
> >>  	dvb->fe[0] = dvb->fe[1] = NULL;
> >>  
> >> @@ -1437,6 +1437,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >>  	dvb->adapter.mfe_shared = mfe_shared;
> >>  
> >>  	em28xx_info("DVB extension successfully initialized\n");
> >> +
> >>  ret:
> >>  	em28xx_set_mode(dev, EM28XX_SUSPEND);
> >>  	mutex_unlock(&dev->lock);
> >> @@ -1489,6 +1490,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
> >>  		dev->dvb = NULL;
> >>  	}
> >>  
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> >> index 3d54c04e5230..c98d784a2772 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-input.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> >> @@ -675,6 +675,8 @@ static int em28xx_ir_init(struct em28xx *dev)
> >>  		return 0;
> >>  	}
> >>  
> >> +	kref_get(&dev->ref);
> >> +
> >>  	if (dev->board.buttons)
> >>  		em28xx_init_buttons(dev);
> >>  
> >> @@ -817,7 +819,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >>  
> >>  	/* skip detach on non attached boards */
> >>  	if (!ir)
> >> -		return 0;
> >> +		goto ref_put;
> >>  
> >>  	if (ir->rc)
> >>  		rc_unregister_device(ir->rc);
> >> @@ -825,6 +827,10 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >>  	/* done */
> >>  	kfree(ir);
> >>  	dev->ir = NULL;
> >> +
> >> +ref_put:
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> >> index aabcafbdab46..f801af8d3f61 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-video.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> >> @@ -1837,6 +1837,7 @@ static int em28xx_v4l2_open(struct file *filp)
> >>  			video_device_node_name(vdev), v4l2_type_names[fh_type],
> >>  			dev->users);
> >>  
> >> +	kref_get(&dev->ref);
> > The same as with open() in em28xx-alsa:
> > kref_get() needs to be called when we are sure that the function succeeds.
> >
> >>  	if (mutex_lock_interruptible(&dev->lock))
> >>  		return -ERESTARTSYS;
> >> @@ -1926,9 +1927,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
> >>  	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> >>  	v4l2_device_unregister(&dev->v4l2_dev);
> >>  
> >> -	if (dev->users)
> >> -		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
> >>  	mutex_unlock(&dev->lock);
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >>  
> >>  	return 0;
> >>  }
> >> @@ -1950,11 +1950,9 @@ static int em28xx_v4l2_close(struct file *filp)
> >>  	mutex_lock(&dev->lock);
> >>  
> >>  	if (dev->users == 1) {
> >> -		/* free the remaining resources if device is disconnected */
> >> -		if (dev->disconnected) {
> >> -			kfree(dev->alt_max_pkt_size_isoc);
> >> +		/* No sense to try to write to the device */
> >> +		if (dev->disconnected)
> >>  			goto exit;
> >> -		}
> >>  
> >>  		/* Save some power by putting tuner to sleep */
> >>  		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> >> @@ -1975,6 +1973,8 @@ static int em28xx_v4l2_close(struct file *filp)
> >>  exit:
> >>  	dev->users--;
> >>  	mutex_unlock(&dev->lock);
> >> +	kref_put(&dev->ref, em28xx_free_device);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -2206,6 +2206,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >>  
> >>  	em28xx_info("Registering V4L2 extension\n");
> >>  
> >> +	kref_get(&dev->ref);
> >> +
> >>  	mutex_lock(&dev->lock);
> >>  
> >>  	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
> >> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> >> index 10b817245f7e..8b3438891bb3 100644
> >> --- a/drivers/media/usb/em28xx/em28xx.h
> >> +++ b/drivers/media/usb/em28xx/em28xx.h
> >> @@ -32,6 +32,7 @@
> >>  #include <linux/workqueue.h>
> >>  #include <linux/i2c.h>
> >>  #include <linux/mutex.h>
> >> +#include <linux/kref.h>
> >>  #include <linux/videodev2.h>
> >>  
> >>  #include <media/videobuf2-vmalloc.h>
> >> @@ -533,9 +534,11 @@ struct em28xx_i2c_bus {
> >>  	enum em28xx_i2c_algo_type algo_type;
> >>  };
> >>  
> >> -
> >>  /* main device struct */
> >>  struct em28xx {
> >> +	struct kref ref;
> >> +
> >> +
> > One empty line is enough.
> >
> >>  	/* generic device properties */
> >>  	char name[30];		/* name (including minor) of the device */
> >>  	int model;		/* index in the device_data struct */
> >> @@ -708,6 +711,8 @@ struct em28xx {
> >>  	struct em28xx_dvb *dvb;
> >>  };
> >>  
> >> +#define kref_to_dev(d) container_of(d, struct em28xx, ref)
> >> +
> > I wonder why this macro isn't provided by kref.h.
> >

Because kref doesn't know struct em28xx. 

> >>  struct em28xx_ops {
> >>  	struct list_head next;
> >>  	char *name;
> >> @@ -765,7 +770,7 @@ extern struct em28xx_board em28xx_boards[];
> >>  extern struct usb_device_id em28xx_id_table[];
> >>  int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
> >>  void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
> >> -void em28xx_release_resources(struct em28xx *dev);
> >> +void em28xx_free_device(struct kref *ref);
> >>  
> >>  /* Provided by em28xx-camera.c */
> >>  int em28xx_detect_sensor(struct em28xx *dev);
> > I've made several tests with my devices and I'm facing some issues with
> > the current media-tree (e.g. a kernel panic with a hard lockup when
> > reconnecting the laplace webcam).
> > But none of them seems to be related to this change.
> > Anyway, when we're finished with it, we need to stabilize things...
> Ping !
> Are you going to continue working on this patch ?
> I've planned to come up with some follow-up changes... ;-)

Yes, but I'm currently without time to do your proposal changes and
test, as I'm in a 2-week business trip. I didn't bring any test machine.

If you want, I can commit this one as-is, and you can do your
proposed changes on a separate patch.

> 
> Regards,
> Frank


-- 

Cheers,
Mauro
