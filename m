Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:58501 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaCGRiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 12:38:10 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N22005FZUBK0N50@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Mar 2014 12:38:08 -0500 (EST)
Date: Fri, 07 Mar 2014 14:38:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] em28xx: Only deallocate struct em28xx after finishing
 all extensions
Message-id: <20140307143803.61543333@samsung.com>
In-reply-to: <5319FC34.5000602@googlemail.com>
References: <52FBB6BC.7030102@googlemail.com>
 <1394029372-5322-1-git-send-email-m.chehab@samsung.com>
 <5319FC34.5000602@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 07 Mar 2014 18:04:52 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> 
> Am 05.03.2014 15:22, schrieb Mauro Carvalho Chehab:
> > We can't free struct em28xx while one of the extensions is still
> > using it.
> >
> > So, add a kref() to control it, freeing it only after the
> > extensions fini calls.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-audio.c |  7 ++++++-
> >  drivers/media/usb/em28xx/em28xx-cards.c | 31 ++++++++++++++++++++++++-------
> >  drivers/media/usb/em28xx/em28xx-dvb.c   |  6 +++++-
> >  drivers/media/usb/em28xx/em28xx-input.c |  8 +++++++-
> >  drivers/media/usb/em28xx/em28xx-video.c | 15 ++++++++-------
> >  drivers/media/usb/em28xx/em28xx.h       |  8 ++++++--
> >  6 files changed, 56 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > index 0f5b6f3e7a3f..f75c0a5494d6 100644
> > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > @@ -301,6 +301,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >  			goto err;
> >  	}
> >  
> > +	kref_get(&dev->ref);
> >  	dev->adev.users++;
> >  	mutex_unlock(&dev->lock);
> >  
> > @@ -341,6 +342,7 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
> >  		substream->runtime->dma_area = NULL;
> >  	}
> >  	mutex_unlock(&dev->lock);
> > +	kref_put(&dev->ref, em28xx_free_device);
> >  
> >  	return 0;
> >  }
> > @@ -895,6 +897,8 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  
> >  	em28xx_info("Binding audio extension\n");
> >  
> > +	kref_get(&dev->ref);
> > +
> >  	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
> >  			 "Rechberger\n");
> >  	printk(KERN_INFO
> > @@ -967,7 +971,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
> >  	if (dev == NULL)
> >  		return 0;
> >  
> > -	if (dev->has_alsa_audio != 1) {
> > +	if (!dev->has_alsa_audio) {
> >  		/* This device does not support the extension (in this case
> >  		   the device is expecting the snd-usb-audio module or
> >  		   doesn't have analog audio support at all) */
> > @@ -986,6 +990,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
> >  		dev->adev.sndcard = NULL;
> >  	}
> >  
> > +	kref_put(&dev->ref, em28xx_free_device);
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 2fb300e882f0..512448b757c9 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2939,7 +2939,7 @@ static void flush_request_modules(struct em28xx *dev)
> >   * unregisters the v4l2,i2c and usb devices
> >   * called when the device gets disconnected or at module unload
> >  */
> > -void em28xx_release_resources(struct em28xx *dev)
> > +static void em28xx_release_resources(struct em28xx *dev)
> >  {
> >  	/*FIXME: I2C IR should be disconnected */
> >  
> > @@ -2956,7 +2956,26 @@ void em28xx_release_resources(struct em28xx *dev)
> >  
> >  	mutex_unlock(&dev->lock);
> >  };
> > -EXPORT_SYMBOL_GPL(em28xx_release_resources);
> > +
> > +/**
> > + * em28xx_free_defice() - Free em28xx device
> > + *
> > + * @ref: struct kref for em28xx device
> > + *
> > + * This is called when all extensions and em28xx core unregisters a device
> > + */
> > +void em28xx_free_device(struct kref *ref)
> > +{
> > +	struct em28xx *dev = kref_to_dev(ref);
> > +
> > +	em28xx_info("Freeing device\n");
> > +
> > +	if (!dev->disconnected)
> > +		em28xx_release_resources(dev);
> Hmm... good catch !
> 
> > +
> > +	kfree(dev->alt_max_pkt_size_isoc);
> > +	kfree(dev);
> > +}
> >  
> >  /*
> >   * em28xx_init_dev()
> > @@ -3409,6 +3428,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
> >  	}
> >  
> > +	kref_init(&dev->ref);
> > +
> >  	request_modules(dev);
> >  
> >  	/* Should be the last thing to do, to avoid newer udev's to
> > @@ -3453,11 +3474,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
> >  	em28xx_close_extension(dev);
> >  
> >  	em28xx_release_resources(dev);
> > -
> > -	if (!dev->users) {
> > -		kfree(dev->alt_max_pkt_size_isoc);
> > -		kfree(dev);
> > -	}
> > +	kref_put(&dev->ref, em28xx_free_device);
> >  }
> >  
> >  static int em28xx_usb_suspend(struct usb_interface *interface,
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > index d4986bdfbdc3..6dbc71ba2820 100644
> > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -1043,7 +1043,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  	em28xx_info("Binding DVB extension\n");
> >  
> >  	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
> > -
> >  	if (dvb == NULL) {
> >  		em28xx_info("em28xx_dvb: memory allocation failed\n");
> >  		return -ENOMEM;
> > @@ -1521,6 +1520,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  	dvb->adapter.mfe_shared = mfe_shared;
> >  
> >  	em28xx_info("DVB extension successfully initialized\n");
> > +
> > +	kref_get(&dev->ref);
> > +
> 
> The fini() functions are always called, even if an error occured in init().
> So (in opposition to the open()/close() functions) kref_get() needs to
> be called at the beginning of the init() methods.
> 
> "dev->is_audio_only" and "!dev->board.has_dvb" is checked in both
> functions (init+fini), so the right place here is one line before or after
> 
>     em28xx_info("Binding DVB extension\n");
> 
> 
> Everything else looks good.

I actually prefer to fix it the other way, at the code for kref_put()...
see below

> 
> Regards,
> Frank
> 
> >  ret:
> >  	em28xx_set_mode(dev, EM28XX_SUSPEND);
> >  	mutex_unlock(&dev->lock);
> > @@ -1579,6 +1581,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
> >  		dev->dvb = NULL;

Putting the kref_put() here. This part of the code is only called if
dev->dvb it not NULL, and this is only possible to happen if the
DVB is properly initialized.

> >  	}
> >  
> > +	kref_put(&dev->ref, em28xx_free_device);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > index 47a2c1dcccbf..2a9bf667f208 100644
> > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > @@ -676,6 +676,8 @@ static int em28xx_ir_init(struct em28xx *dev)
> >  		return 0;
> >  	}
> >  
> > +	kref_get(&dev->ref);
> > +
> >  	if (dev->board.buttons)
> >  		em28xx_init_buttons(dev);
> >  
> > @@ -816,7 +818,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >  
> >  	/* skip detach on non attached boards */
> >  	if (!ir)
> > -		return 0;
> > +		goto ref_put;
> >  
> >  	if (ir->rc)
> >  		rc_unregister_device(ir->rc);
> > @@ -824,6 +826,10 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >  	/* done */
> >  	kfree(ir);
> >  	dev->ir = NULL;
> > +
> > +ref_put:
> > +	kref_put(&dev->ref, em28xx_free_device);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index 19af6b3e9e2b..32aa55f033fc 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -1837,7 +1837,6 @@ static int em28xx_v4l2_open(struct file *filp)
> >  			video_device_node_name(vdev), v4l2_type_names[fh_type],
> >  			dev->users);
> >  
> > -
> >  	if (mutex_lock_interruptible(&dev->lock))
> >  		return -ERESTARTSYS;
> >  	fh = kzalloc(sizeof(struct em28xx_fh), GFP_KERNEL);
> > @@ -1869,6 +1868,7 @@ static int em28xx_v4l2_open(struct file *filp)
> >  		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
> >  	}
> >  
> > +	kref_get(&dev->ref);
> >  	dev->users++;
> >  
> >  	mutex_unlock(&dev->lock);
> > @@ -1926,9 +1926,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
> >  		dev->clk = NULL;
> >  	}
> >  
> > -	if (dev->users)
> > -		em28xx_warn("Device is open ! Memory deallocation is deferred on last close.\n");
> >  	mutex_unlock(&dev->lock);
> > +	kref_put(&dev->ref, em28xx_free_device);
> >  
> >  	return 0;
> >  }
> > @@ -1976,11 +1975,9 @@ static int em28xx_v4l2_close(struct file *filp)
> >  	mutex_lock(&dev->lock);
> >  
> >  	if (dev->users == 1) {
> > -		/* free the remaining resources if device is disconnected */
> > -		if (dev->disconnected) {
> > -			kfree(dev->alt_max_pkt_size_isoc);
> > +		/* No sense to try to write to the device */
> > +		if (dev->disconnected)
> >  			goto exit;
> > -		}
> >  
> >  		/* Save some power by putting tuner to sleep */
> >  		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> > @@ -2001,6 +1998,8 @@ static int em28xx_v4l2_close(struct file *filp)
> >  exit:
> >  	dev->users--;
> >  	mutex_unlock(&dev->lock);
> > +	kref_put(&dev->ref, em28xx_free_device);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -2515,6 +2514,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  
> >  	em28xx_info("V4L2 extension successfully initialized\n");
> >  
> > +	kref_get(&dev->ref);
> > +
> >  	mutex_unlock(&dev->lock);
> >  	return 0;
> >  
> > diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> > index 9e44f5bfc48b..2051fc9fb932 100644
> > --- a/drivers/media/usb/em28xx/em28xx.h
> > +++ b/drivers/media/usb/em28xx/em28xx.h
> > @@ -32,6 +32,7 @@
> >  #include <linux/workqueue.h>
> >  #include <linux/i2c.h>
> >  #include <linux/mutex.h>
> > +#include <linux/kref.h>
> >  #include <linux/videodev2.h>
> >  
> >  #include <media/videobuf2-vmalloc.h>
> > @@ -536,9 +537,10 @@ struct em28xx_i2c_bus {
> >  	enum em28xx_i2c_algo_type algo_type;
> >  };
> >  
> > -
> >  /* main device struct */
> >  struct em28xx {
> > +	struct kref ref;
> > +
> >  	/* generic device properties */
> >  	char name[30];		/* name (including minor) of the device */
> >  	int model;		/* index in the device_data struct */
> > @@ -710,6 +712,8 @@ struct em28xx {
> >  	struct em28xx_dvb *dvb;
> >  };
> >  
> > +#define kref_to_dev(d) container_of(d, struct em28xx, ref)
> > +
> >  struct em28xx_ops {
> >  	struct list_head next;
> >  	char *name;
> > @@ -771,7 +775,7 @@ extern struct em28xx_board em28xx_boards[];
> >  extern struct usb_device_id em28xx_id_table[];
> >  int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
> >  void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
> > -void em28xx_release_resources(struct em28xx *dev);
> > +void em28xx_free_device(struct kref *ref);
> >  
> >  /* Provided by em28xx-camera.c */
> >  int em28xx_detect_sensor(struct em28xx *dev);
> 


-- 

Cheers,
Mauro
