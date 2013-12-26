Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:11643 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3LZOV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Dec 2013 09:21:57 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYF00A6P3WJ6C20@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Dec 2013 09:21:55 -0500 (EST)
Date: Thu, 26 Dec 2013 12:21:41 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: "unlisted-recipients: ;Linux Media Mailing List"
	<linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCHv2] em28xx: split analog part into a separate module
Message-id: <20131226122141.5b678ab2.m.chehab@samsung.com>
In-reply-to: <52BC191A.8070405@googlemail.com>
References: <1387716427-582-1-git-send-email-m.chehab@samsung.com>
 <52BC191A.8070405@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 26 Dec 2013 12:55:06 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi Mauro,
> 
> Am 22.12.2013 13:47, schrieb Mauro Carvalho Chehab:
> > Now that dvb-only devices start to happen, it makes sense
> > to split the analog part on a separate module.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >
> > -
> >
> > This is a respin of https://patchwork.linuxtv.org/patch/17967/
> >
> > v2: add a dev->has_video to signalize if the device has a video interface, and
> >     fix some locks
> >
> > Compile-tested only.
> >
> > ---
> >  drivers/media/usb/em28xx/Kconfig        |   6 +-
> >  drivers/media/usb/em28xx/Makefile       |   5 +-
> >  drivers/media/usb/em28xx/em28xx-cards.c |  94 ++--------------------
> >  drivers/media/usb/em28xx/em28xx-core.c  |  12 +++
> >  drivers/media/usb/em28xx/em28xx-video.c | 133 ++++++++++++++++++++++++++++----
> >  drivers/media/usb/em28xx/em28xx.h       |  17 ++--
> >  6 files changed, 150 insertions(+), 117 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
> > index d6ba514d31eb..838fc9dbb747 100644
> > --- a/drivers/media/usb/em28xx/Kconfig
> > +++ b/drivers/media/usb/em28xx/Kconfig
> > @@ -1,8 +1,12 @@
> >  config VIDEO_EM28XX
> > -	tristate "Empia EM28xx USB video capture support"
> > +	tristate "Empia EM28xx USB devices support"
> >  	depends on VIDEO_DEV && I2C
> >  	select VIDEO_TUNER
> >  	select VIDEO_TVEEPROM
> > +
> > +config VIDEO_EM28XX_V4L2
> > +	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
> > +	depends on VIDEO_EM28XX && I2C
> VIDEO_EM28XX already depends on I2C.
> 
> >  	select VIDEOBUF2_VMALLOC
> >  	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
> >  	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
> > diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
> > index ad6d48557940..3e2b6b54817d 100644
> > --- a/drivers/media/usb/em28xx/Makefile
> > +++ b/drivers/media/usb/em28xx/Makefile
> > @@ -1,10 +1,11 @@
> > -em28xx-y +=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
> > -em28xx-y +=	em28xx-core.o  em28xx-vbi.o em28xx-camera.o
> > +em28xx-y +=	em28xx-core.o em28xx-i2c.o em28xx-cards.o
> >  
> > +em28xx-v4l-objs := em28xx-video.o em28xx-vbi.o em28xx-camera.o
> >  em28xx-alsa-objs := em28xx-audio.o
> >  em28xx-rc-objs := em28xx-input.o
> >  
> >  obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
> > +obj-$(CONFIG_VIDEO_EM28XX_V4L2) += em28xx-v4l.o
> >  obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
> >  obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
> >  obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 36853f16bf97..e1ffd9c6e79d 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2106,7 +2106,7 @@ struct em28xx_board em28xx_boards[] = {
> >  	},
> >  	/* 1b80:e1cc Delock 61959
> >  	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2
> > -         * mostly the same as MaxMedia UB-425-TC but different remote */
> > +	 * mostly the same as MaxMedia UB-425-TC but different remote */
> >  	[EM2874_BOARD_DELOCK_61959] = {
> >  		.name          = "Delock 61959",
> >  		.tuner_type    = TUNER_ABSENT,
> > @@ -2955,11 +2955,12 @@ static void request_module_async(struct work_struct *work)
> >  	em28xx_init_extension(dev);
> >  
> >  #if defined(CONFIG_MODULES) && defined(MODULE)
> > +	if (!dev->has_video)
> > +		request_module("em28xx-v4l2");
> if (dev->has_video)
> What about audio devices ?

Audio only devices don't need em28xx-v4l2. With the current way,
em28xx-video.c doesn't initialize the v4l2 interfaces on those.

> >  	if (dev->has_audio_class)
> >  		request_module("snd-usb-audio");
> >  	else if (dev->has_alsa_audio)
> >  		request_module("em28xx-alsa");
> > -
> >  	if (dev->board.has_dvb)
> >  		request_module("em28xx-dvb");
> >  	if (dev->board.buttons ||
> > @@ -2988,8 +2989,6 @@ void em28xx_release_resources(struct em28xx *dev)
> >  {
> >  	/*FIXME: I2C IR should be disconnected */
> >  
> > -	em28xx_release_analog_resources(dev);
> > -
> >  	if (dev->def_i2c_bus)
> >  		em28xx_i2c_unregister(dev, 1);
> >  	em28xx_i2c_unregister(dev, 0);
> > @@ -3014,7 +3013,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  			   struct usb_interface *interface,
> >  			   int minor)
> >  {
> > -	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
> >  	int retval;
> >  	static const char *default_chip_name = "em28xx";
> >  	const char *chip_name = default_chip_name;
> > @@ -3141,15 +3139,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  		}
> >  	}
> >  
> > -	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
> > -	if (retval < 0) {
> > -		em28xx_errdev("Call to v4l2_device_register() failed!\n");
> > -		return retval;
> > -	}
> > -
> > -	v4l2_ctrl_handler_init(hdl, 8);
> > -	dev->v4l2_dev.ctrl_handler = hdl;
> > -
> >  	rt_mutex_init(&dev->i2c_bus_lock);
> >  
> >  	/* register i2c bus 0 */
> > @@ -3178,75 +3167,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  		}
> >  	}
> >  
> > -	/*
> > -	 * Default format, used for tvp5150 or saa711x output formats
> > -	 */
> > -	dev->vinmode = 0x10;
> > -	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
> > -		       EM28XX_VINCTRL_CCIR656_ENABLE;
> > -
> >  	/* Do board specific init and eeprom reading */
> >  	em28xx_card_setup(dev);
> >  
> > -	/* Configure audio */
> > -	retval = em28xx_audio_setup(dev);
> > -	if (retval < 0) {
> > -		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> > -			__func__, retval);
> > -		goto fail;
> > -	}
> > -	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> > -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> > -			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> > -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> > -			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> > -	} else {
> > -		/* install the em28xx notify callback */
> > -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> > -				em28xx_ctrl_notify, dev);
> > -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> > -				em28xx_ctrl_notify, dev);
> > -	}
> > -
> > -	/* wake i2c devices */
> > -	em28xx_wake_i2c(dev);
> > -
> > -	/* init video dma queues */
> > -	INIT_LIST_HEAD(&dev->vidq.active);
> > -	INIT_LIST_HEAD(&dev->vbiq.active);
> > -
> > -	if (dev->board.has_msp34xx) {
> > -		/* Send a reset to other chips via gpio */
> > -		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
> > -		if (retval < 0) {
> > -			em28xx_errdev("%s: em28xx_write_reg - "
> > -				      "msp34xx(1) failed! error [%d]\n",
> > -				      __func__, retval);
> > -			goto fail;
> > -		}
> > -		msleep(3);
> > -
> > -		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
> > -		if (retval < 0) {
> > -			em28xx_errdev("%s: em28xx_write_reg - "
> > -				      "msp34xx(2) failed! error [%d]\n",
> > -				      __func__, retval);
> > -			goto fail;
> > -		}
> > -		msleep(3);
> > -	}
> > -
> > -	retval = em28xx_register_analog_devices(dev);
> > -	if (retval < 0) {
> > -		goto fail;
> > -	}
> > -
> > -	/* Save some power by putting tuner to sleep */
> > -	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> > -
> >  	return 0;
> Now the following code is unrechable...
> > -fail:
> >  	if (dev->def_i2c_bus)
> >  		em28xx_i2c_unregister(dev, 1);
> >  	em28xx_i2c_unregister(dev, 0);
> ... up to the "unregister_dev" label.
> Either keep the "fail" label and check the success of
> em28xx_card_setup() or remove this dead code.

True. I'll just drop the code, as there's no reason why 
em28xx_card_setup() would fail.

I'll add it as a separate patch at the series.

> 
> > @@ -3458,6 +3383,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	dev->alt   = -1;
> >  	dev->is_audio_only = has_audio && !(has_video || has_dvb);
> >  	dev->has_alsa_audio = has_audio;
> > +	dev->has_video = has_video;
> >  	dev->audio_ifnum = ifnum;
> >  
> >  	/* Checks if audio is provided by some interface */
> > @@ -3495,15 +3421,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	/* save our data pointer in this interface device */
> >  	usb_set_intfdata(interface, dev);
> >  
> > -	/* initialize videobuf2 stuff */
> > -	em28xx_vb2_setup(dev);
> > -
> >  	/* allocate device struct */
> >  	mutex_init(&dev->lock);
> > -	mutex_lock(&dev->lock);
> >  	retval = em28xx_init_dev(dev, udev, interface, nr);
> >  	if (retval) {
> > -		goto unlock_and_free;
> > +		goto err_free;
> >  	}
> >  
> >  	if (usb_xfer_mode < 0) {
> > @@ -3546,7 +3468,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  		if (retval) {
> >  			printk(DRIVER_NAME
> >  			       ": Failed to pre-allocate USB transfer buffers for DVB.\n");
> > -			goto unlock_and_free;
> > +			goto err_free;
> >  		}
> >  	}
> >  
> > @@ -3555,13 +3477,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	/* Should be the last thing to do, to avoid newer udev's to
> >  	   open the device before fully initializing it
> >  	 */
> > -	mutex_unlock(&dev->lock);
> >  
> >  	return 0;
> >  
> > -unlock_and_free:
> > -	mutex_unlock(&dev->lock);
> > -
> >  err_free:
> >  	kfree(dev->alt_max_pkt_size_isoc);
> >  	kfree(dev);
> > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > index f6076a512e8f..0f61532d2612 100644
> > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > @@ -33,6 +33,18 @@
> >  
> >  #include "em28xx.h"
> >  
> > +#define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
> > +		      "Markus Rechberger <mrechberger@gmail.com>, " \
> > +		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
> > +		      "Sascha Sommer <saschasommer@freenet.de>"
> > +
> > +#define DRIVER_DESC         "Empia em28xx based USB core driver"

> You should update the driver description string for the new v4l2 module
> in em28xx-video.c.

True. I'll write a separate patch to improve the em28xx extension
descriptions.

> ...
> > +
> > +MODULE_AUTHOR(DRIVER_AUTHOR);
> > +MODULE_DESCRIPTION(DRIVER_DESC);
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION(EM28XX_VERSION);
> > +
> ...
> >  /* #define ENABLE_DEBUG_ISOC_FRAMES */
> >  
> >  static unsigned int core_debug;
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index dd19c9ff76e0..b20e4e7116d3 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -51,8 +51,6 @@
> >  
> >  #define DRIVER_DESC         "Empia em28xx based USB video device driver"
> >  
> > -#define EM28XX_VERSION "0.2.0"
> > -
> Some of these DRIVER_XYZ #defines are kept locally, this one is moved to
> the header file, other extension modules don't use ist all (strings
> hardcoded or corresponding MODULE macros unused)...
> Time for a clean-up / unification. :)

Yep. I'll do that on a separate patch, as I said above.

> >  #define em28xx_videodbg(fmt, arg...) do {\
> >  	if (video_debug) \
> >  		printk(KERN_INFO "%s %s :"fmt, \
> > @@ -763,7 +761,7 @@ static struct vb2_ops em28xx_video_qops = {
> >  	.wait_finish    = vb2_ops_wait_finish,
> >  };
> >  
> > -int em28xx_vb2_setup(struct em28xx *dev)
> > +static int em28xx_vb2_setup(struct em28xx *dev)
> >  {
> >  	int rc;
> >  	struct vb2_queue *q;
> > @@ -831,7 +829,7 @@ static void video_mux(struct em28xx *dev, int index)
> >  	em28xx_audio_analog_set(dev);
> >  }
> >  
> > -void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
> > +static void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
> >  {
> >  	struct em28xx *dev = priv;
> >  
> > @@ -1615,11 +1613,11 @@ static int em28xx_v4l2_open(struct file *filp)
> >  }
> >  
> >  /*
> > - * em28xx_realease_resources()
> > + * em28xx_v4l2_fini()
> >   * unregisters the v4l2,i2c and usb devices
> >   * called when the device gets disconected or at module unload
> >  */
> > -void em28xx_release_analog_resources(struct em28xx *dev)
> > +static int em28xx_v4l2_fini(struct em28xx *dev)
> >  {
> >  
> >  	/*FIXME: I2C IR should be disconnected */
> > @@ -1649,6 +1647,8 @@ void em28xx_release_analog_resources(struct em28xx *dev)
> >  			video_device_release(dev->vdev);
> >  		dev->vdev = NULL;
> >  	}
> > +
> > +	return 0;
> >  }
> >  
> >  /*
> > @@ -1790,8 +1790,6 @@ static struct video_device em28xx_radio_template = {
> >  
> >  /******************************** usb interface ******************************/
> >  
> > -
> > -
> >  static struct video_device *em28xx_vdev_init(struct em28xx *dev,
> >  					const struct video_device *template,
> >  					const char *type_name)
> > @@ -1817,15 +1815,85 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
> >  	return vfd;
> >  }
> >  
> > -int em28xx_register_analog_devices(struct em28xx *dev)
> > +static int em28xx_v4l2_init(struct em28xx *dev)
> >  {
> >  	u8 val;
> >  	int ret;
> >  	unsigned int maxw;
> > +	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
> > +
> > +	if (!dev->has_video) {
> Same as above, what about audio devices ?

The audio only devices don't register a V4L2 interface. They register
an alsa one.

> 
> > +		/* This device does not support the v4l2 extension */
> > +		return 0;
> -ENODEV

See the other extensions: they return 0 if the extension is not
supported by an specific device. The thing is that there's no error
there.

Suppose that there are two em28xx devices connected. One em28xx may
be analog TV only; another one may be DTV only.

Both em28xx-v4l and em28xx-dvb modules are loaded, but only the
proper ones will be initialized for a given device.

> 
> > +	}
> >  
> >  	printk(KERN_INFO "%s: v4l2 driver version %s\n",
> >  		dev->name, EM28XX_VERSION);
> >  
> > +	mutex_lock(&dev->lock);
> > +
> > +	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
> > +	if (ret < 0) {
> > +		em28xx_errdev("Call to v4l2_device_register() failed!\n");
> > +		goto err;
> > +	}
> > +
> > +	v4l2_ctrl_handler_init(hdl, 8);
> > +	dev->v4l2_dev.ctrl_handler = hdl;
> > +
> > +	/*
> > +	 * Default format, used for tvp5150 or saa711x output formats
> > +	 */
> > +	dev->vinmode = 0x10;
> > +	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
> > +		       EM28XX_VINCTRL_CCIR656_ENABLE;
> > +
> > +	/* Configure audio */
> > +	ret = em28xx_audio_setup(dev);
> > +	if (ret < 0) {
> > +		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> > +			__func__, ret);
> > +		goto err;
> > +	}
> > +	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> > +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> > +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> > +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> > +			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> > +	} else {
> > +		/* install the em28xx notify callback */
> > +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> > +				em28xx_ctrl_notify, dev);
> > +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> > +				em28xx_ctrl_notify, dev);
> > +	}
> > +
> > +	/* wake i2c devices */
> > +	em28xx_wake_i2c(dev);
> > +
> > +	/* init video dma queues */
> > +	INIT_LIST_HEAD(&dev->vidq.active);
> > +	INIT_LIST_HEAD(&dev->vbiq.active);
> > +
> > +	if (dev->board.has_msp34xx) {
> > +		/* Send a reset to other chips via gpio */
> > +		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
> > +		if (ret < 0) {
> > +			em28xx_errdev("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
> > +				      __func__, ret);
> > +			goto err;
> > +		}
> > +		msleep(3);
> > +
> > +		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
> > +		if (ret < 0) {
> > +			em28xx_errdev("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
> > +				      __func__, ret);
> > +			goto err;
> > +		}
> > +		msleep(3);
> > +	}
> > +
> >  	/* set default norm */
> >  	dev->norm = V4L2_STD_PAL;
> >  	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> > @@ -1888,14 +1956,16 @@ int em28xx_register_analog_devices(struct em28xx *dev)
> >  	/* Reset image controls */
> >  	em28xx_colorlevels_set_default(dev);
> >  	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
> > -	if (dev->ctrl_handler.error)
> > -		return dev->ctrl_handler.error;
> > +	ret = dev->ctrl_handler.error;
> > +	if (ret)
> > +		goto err;
> >  
> >  	/* allocate and fill video video_device struct */
> >  	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
> >  	if (!dev->vdev) {
> >  		em28xx_errdev("cannot allocate video_device.\n");
> > -		return -ENODEV;
> > +		ret = -ENODEV;
> > +		goto err;
> >  	}
> >  	dev->vdev->queue = &dev->vb_vidq;
> >  	dev->vdev->queue->lock = &dev->vb_queue_lock;
> > @@ -1925,7 +1995,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
> >  	if (ret) {
> >  		em28xx_errdev("unable to register video device (error=%i).\n",
> >  			      ret);
> > -		return ret;
> > +		goto err;
> >  	}
> >  
> >  	/* Allocate and fill vbi video_device struct */
> > @@ -1954,7 +2024,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
> >  					    vbi_nr[dev->devno]);
> >  		if (ret < 0) {
> >  			em28xx_errdev("unable to register vbi device\n");
> > -			return ret;
> > +			goto err;
> >  		}
> >  	}
> >  
> > @@ -1963,13 +2033,14 @@ int em28xx_register_analog_devices(struct em28xx *dev)
> >  						  "radio");
> >  		if (!dev->radio_dev) {
> >  			em28xx_errdev("cannot allocate video_device.\n");
> > -			return -ENODEV;
> > +			ret = -ENODEV;
> > +			goto err;
> >  		}
> >  		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
> >  					    radio_nr[dev->devno]);
> >  		if (ret < 0) {
> >  			em28xx_errdev("can't register radio device\n");
> > -			return ret;
> > +			goto err;
> >  		}
> >  		em28xx_info("Registered radio device as %s\n",
> >  			    video_device_node_name(dev->radio_dev));
> > @@ -1982,5 +2053,33 @@ int em28xx_register_analog_devices(struct em28xx *dev)
> >  		em28xx_info("V4L2 VBI device registered as %s\n",
> >  			    video_device_node_name(dev->vbi_dev));
> >  
> > -	return 0;
> > +	/* Save some power by putting tuner to sleep */
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> > +
> > +	/* initialize videobuf2 stuff */
> > +	em28xx_vb2_setup(dev);
> Are you 100% sure it is safe to do this that late now ?

Well, as dev->lock is locked, the ioctls that would start a stream
will lock waiting for the initialization to complete. So, it seems
safe for me.

Ok, if we ever use VB2 for DVB too, then we'll have a problem.

> 
> > +
> > +err:
> > +	mutex_unlock(&dev->lock);
> > +	return ret;
> >  }
> > +
> > +static struct em28xx_ops v4l2_ops = {
> > +	.id   = EM28XX_V4L2,
> > +	.name = "Em28xx v4l2 Extension",
> > +	.init = em28xx_v4l2_init,
> > +	.fini = em28xx_v4l2_fini,
> > +};
> > +
> > +static int __init em28xx_dvb_register(void)
> > +{
> > +	return em28xx_register_extension(&v4l2_ops);
> > +}
> > +
> > +static void __exit em28xx_dvb_unregister(void)
> > +{
> > +	em28xx_unregister_extension(&v4l2_ops);
> > +}
> > +
> > +module_init(em28xx_dvb_register);
> > +module_exit(em28xx_dvb_unregister);
> Should be em28xx_v4l2_register and em28xx_v4l2_unregister.

Nice catch.

> 
> > diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> > index 191ef3593891..bc37d4833dbe 100644
> > --- a/drivers/media/usb/em28xx/em28xx.h
> > +++ b/drivers/media/usb/em28xx/em28xx.h
> > @@ -26,6 +26,8 @@
> >  #ifndef _EM28XX_H
> >  #define _EM28XX_H
> >  
> > +#define EM28XX_VERSION "0.2.1"
> > +
> >  #include <linux/workqueue.h>
> >  #include <linux/i2c.h>
> >  #include <linux/mutex.h>
> > @@ -472,6 +474,7 @@ struct em28xx_eeprom {
> >  #define EM28XX_AUDIO   0x10
> >  #define EM28XX_DVB     0x20
> >  #define EM28XX_RC      0x30
> > +#define EM28XX_V4L2    0x40
> Reorder ?

Why? The initialization can happen on any order. Ok, it could be a good
idea to try force em28xx-v4l to be initialized first, to avoid troubles
with devices that might have some broken GPIO settings, but that would
require some extra logic at em28xx extension registration.

> >  /* em28xx resource types (used for res_get/res_lock etc */
> >  #define EM28XX_RESOURCE_VIDEO 0x01
> > @@ -522,9 +525,13 @@ struct em28xx {
> >  	int model;		/* index in the device_data struct */
> >  	int devno;		/* marks the number of this device */
> >  	enum em28xx_chip_id chip_id;
> > -	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
> >  
> > +	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
> >  	unsigned char disconnected:1;	/* device has been diconnected */
> > +	unsigned int has_video:1;
> > +	unsigned int has_audio_class:1;
> > +	unsigned int has_alsa_audio:1;
> > +	unsigned int is_audio_only:1;
> >  
> >  	int audio_ifnum;
> >  
> > @@ -544,10 +551,6 @@ struct em28xx {
> >  	/* Vinmode/Vinctl used at the driver */
> >  	int vinmode, vinctl;
> >  
> > -	unsigned int has_audio_class:1;
> > -	unsigned int has_alsa_audio:1;
> > -	unsigned int is_audio_only:1;
> > -
> >  	/* Controls audio streaming */
> >  	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
> >  	atomic_t       stream_started;	/* stream should be running if true */
> > @@ -748,10 +751,6 @@ void em28xx_init_extension(struct em28xx *dev);
> >  void em28xx_close_extension(struct em28xx *dev);
> >  
> >  /* Provided by em28xx-video.c */
> > -int em28xx_vb2_setup(struct em28xx *dev);
> > -int em28xx_register_analog_devices(struct em28xx *dev);
> > -void em28xx_release_analog_resources(struct em28xx *dev);
> > -void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv);
> >  int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
> >  int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
> >  extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
> 
> I'll be glad to test the changes with the hardware I have once the
> changed code compiles.

You can test them from my experimental tree:
	http://git.linuxtv.org/git/mchehab/experimental.git

The patches are at "em28xx-v4l2" branch.

On my tests here, the patches seem ok. However, HVR-950 support seems
to be somewhat broken on my testing hardware.

1) From time to time, I'm getting -ENODEV from an I2C device:

[ 1028.689822] em2882/3 #0: cannot change alternate number to 0 (error=-62)
[ 1029.892760] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1029.900277] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1029.962294] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1030.044491] xc2028 19-0061: i2c input error: rc = -19 (should be 2)
[ 1030.044686] xc2028 19-0061: i2c input error: rc = -19 (should be 2)
[ 1030.178150] xc2028 19-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 1031.143036] xc2028 19-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 1031.158715] xc2028 19-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1031.336408] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1031.345371] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1031.404663] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1031.405230] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1031.771366] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1107.832347] em2882/3 #0: submit of audio urb failed
[ 1111.178404] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1111.265427] xc2028 19-0061: i2c input error: rc = -19 (should be 2)
[ 1111.265602] xc2028 19-0061: i2c input error: rc = -19 (should be 2)
[ 1111.269485] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1111.270380] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1111.271262] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1111.336277] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1111.397035] xc2028 19-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 1112.362065] xc2028 19-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 1112.377913] xc2028 19-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1112.556001] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1112.937913] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
[ 1112.945046] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)

2) my test machine is experiencing some troubles:

[ 1285.065718] CPU5: Core temperature/speed normal
[ 1285.065720] CPU1: Core temperature/speed normal
[ 1285.065721] CPU2: Package temperature/speed normal
[ 1285.065723] CPU0: Package temperature/speed normal
[ 1285.065724] CPU6: Package temperature/speed normal
[ 1285.065726] CPU7: Package temperature/speed normal
[ 1285.065727] CPU4: Package temperature/speed normal
[ 1285.065728] CPU3: Package temperature/speed normal
[ 1285.065729] CPU1: Package temperature/speed normal
[ 1285.065739] CPU5: Package temperature/speed normal

This of course is not caused by em28xx driver, but it could be 
affecting the test results.

3) The em28xx device is connected into a USB3 port. Again, maybe
this could be the cause of the problem, as sometimes I'm seeing
some xHCI errors.

4) There's no audio (although the audio thread is running ok).

5) The AC97 is not properly detected:

[   24.382373] em2882/3 #0: 	AC97 audio (5 sample rates)
[   25.551230] em2882/3 #0: AC97 vendor ID = 0xffffffff
[   25.551349] em2882/3 #0: AC97 features = 0xffff
[   25.551351] em2882/3 #0: Unknown AC97 audio processor detected!

Sometimes, the vendor ID is different (the MSB bits), and sometimes
AC97 features is 0x6290.

I suspect that it is trying to read from AC97 too fast.

-

At this point, I'm not sure what it is a regression and what isn't.

I tested back to 3.7, and issues (1) and (3) still occur there.

The -ENODEV issue is worse on Kernel 3.9.

In any case, this patch series doesn't make is better or worse.

So, it seems that this series is ok, at least with the devices I have.

I don't have any DVB-only device here to test through, as only very
few em28xx chipsets don't have analog stream support.

> 
> Regards,
> Frank
> 


-- 

Cheers,
Mauro
