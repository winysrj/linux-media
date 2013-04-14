Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59129 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3DNUlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 16:41:13 -0400
Received: by mail-ea0-f179.google.com with SMTP id f15so1880284eak.24
        for <linux-media@vger.kernel.org>; Sun, 14 Apr 2013 13:41:12 -0700 (PDT)
Message-ID: <516B14AD.8000301@googlemail.com>
Date: Sun, 14 Apr 2013 22:42:21 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFC] em28xx: split analog part into a separate module
References: <1365964340-15337-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365964340-15337-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.04.2013 20:32, schrieb Mauro Carvalho Chehab:
> Now that dvb-only devices start to happen, it makes sense
> to split the analog part on a separate module.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>
> This was compiled-tested only, and it is not ready yet for merging.

Yes, please let's test this _carefully_ before merging it !

This is a very big and dangerous change.
I've spent some time looking at parts of the code you are touching here
(with regards
to the insane registering of an analog device node for DVB-only-devices
we are
currently doing) and this is really dangerous territory ! Be warned !

I'm going to review it but don't have time for that at the moment, so
please be patient.

>
> I'm just pusing it as RFC right now to avoid the risk of losing it,
> as we'll be soon entering in the media merge window for 3.11.
>
> I hope that splitting the analog part into a different module will
> help to avoid locking issues between DVB, but locks need to be
> reviewed as well.

Well, never give up hope, but it's clearly better to understand the
problem _before_ suggesting a solution... ;)

Regards,
Frank

>
>  drivers/media/usb/em28xx/Kconfig        |   6 +-
>  drivers/media/usb/em28xx/Makefile       |   5 +-
>  drivers/media/usb/em28xx/em28xx-cards.c |  91 +-------------------
>  drivers/media/usb/em28xx/em28xx-core.c  |  15 ++++
>  drivers/media/usb/em28xx/em28xx-video.c | 143 ++++++++++++++++++++++++++++----
>  drivers/media/usb/em28xx/em28xx.h       |   5 +-
>  6 files changed, 156 insertions(+), 109 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
> index ca5ee6a..3ade852 100644
> --- a/drivers/media/usb/em28xx/Kconfig
> +++ b/drivers/media/usb/em28xx/Kconfig
> @@ -1,8 +1,12 @@
>  config VIDEO_EM28XX
> -	tristate "Empia EM28xx USB video capture support"
> +	tristate "Empia EM28xx USB devices support"
>  	depends on VIDEO_DEV && I2C
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
> +
> +config VIDEO_EM28XX_V4L2
> +	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
> +	depends on VIDEO_EM28XX && I2C
>  	select VIDEOBUF2_VMALLOC
>  	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
>  	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
> diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
> index ad6d485..3e2b6b5 100644
> --- a/drivers/media/usb/em28xx/Makefile
> +++ b/drivers/media/usb/em28xx/Makefile
> @@ -1,10 +1,11 @@
> -em28xx-y +=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
> -em28xx-y +=	em28xx-core.o  em28xx-vbi.o em28xx-camera.o
> +em28xx-y +=	em28xx-core.o em28xx-i2c.o em28xx-cards.o
>  
> +em28xx-v4l-objs := em28xx-video.o em28xx-vbi.o em28xx-camera.o
>  em28xx-alsa-objs := em28xx-audio.o
>  em28xx-rc-objs := em28xx-input.o
>  
>  obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
> +obj-$(CONFIG_VIDEO_EM28XX_V4L2) += em28xx-v4l.o
>  obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
>  obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
>  obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 1d3866f..8d2a899 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2803,11 +2803,12 @@ static void request_module_async(struct work_struct *work)
>  	em28xx_init_extension(dev);
>  
>  #if defined(CONFIG_MODULES) && defined(MODULE)
> +	if (!dev->is_audio_only)
> +		request_module("em28xx-v4l2");
>  	if (dev->has_audio_class)
>  		request_module("snd-usb-audio");
>  	else if (dev->has_alsa_audio)
>  		request_module("em28xx-alsa");
> -
>  	if (dev->board.has_dvb)
>  		request_module("em28xx-dvb");
>  	if ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir)
> @@ -2835,8 +2836,6 @@ void em28xx_release_resources(struct em28xx *dev)
>  {
>  	/*FIXME: I2C IR should be disconnected */
>  
> -	em28xx_release_analog_resources(dev);
> -
>  	if (dev->def_i2c_bus)
>  		em28xx_i2c_unregister(dev, 1);
>  	em28xx_i2c_unregister(dev, 0);
> @@ -2859,7 +2858,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  			   struct usb_interface *interface,
>  			   int minor)
>  {
> -	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
>  	int retval;
>  	static const char *default_chip_name = "em28xx";
>  	const char *chip_name = default_chip_name;
> @@ -2992,15 +2990,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  		}
>  	}
>  
> -	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
> -	if (retval < 0) {
> -		em28xx_errdev("Call to v4l2_device_register() failed!\n");
> -		return retval;
> -	}
> -
> -	v4l2_ctrl_handler_init(hdl, 8);
> -	dev->v4l2_dev.ctrl_handler = hdl;
> -
>  	rt_mutex_init(&dev->i2c_bus_lock);
>  
>  	/* register i2c bus 0 */
> @@ -3029,75 +3018,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  		}
>  	}
>  
> -	/*
> -	 * Default format, used for tvp5150 or saa711x output formats
> -	 */
> -	dev->vinmode = 0x10;
> -	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
> -		       EM28XX_VINCTRL_CCIR656_ENABLE;
> -
>  	/* Do board specific init and eeprom reading */
>  	em28xx_card_setup(dev);
>  
> -	/* Configure audio */
> -	retval = em28xx_audio_setup(dev);
> -	if (retval < 0) {
> -		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> -			__func__, retval);
> -		goto fail;
> -	}
> -	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> -			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> -			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> -	} else {
> -		/* install the em28xx notify callback */
> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> -				em28xx_ctrl_notify, dev);
> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> -				em28xx_ctrl_notify, dev);
> -	}
> -
> -	/* wake i2c devices */
> -	em28xx_wake_i2c(dev);
> -
> -	/* init video dma queues */
> -	INIT_LIST_HEAD(&dev->vidq.active);
> -	INIT_LIST_HEAD(&dev->vbiq.active);
> -
> -	if (dev->board.has_msp34xx) {
> -		/* Send a reset to other chips via gpio */
> -		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
> -		if (retval < 0) {
> -			em28xx_errdev("%s: em28xx_write_reg - "
> -				      "msp34xx(1) failed! error [%d]\n",
> -				      __func__, retval);
> -			goto fail;
> -		}
> -		msleep(3);
> -
> -		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
> -		if (retval < 0) {
> -			em28xx_errdev("%s: em28xx_write_reg - "
> -				      "msp34xx(2) failed! error [%d]\n",
> -				      __func__, retval);
> -			goto fail;
> -		}
> -		msleep(3);
> -	}
> -
> -	retval = em28xx_register_analog_devices(dev);
> -	if (retval < 0) {
> -		goto fail;
> -	}
> -
> -	/* Save some power by putting tuner to sleep */
> -	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> -
>  	return 0;
>  
> -fail:
>  	if (dev->def_i2c_bus)
>  		em28xx_i2c_unregister(dev, 1);
>  	em28xx_i2c_unregister(dev, 0);
> @@ -3346,15 +3271,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  	/* save our data pointer in this interface device */
>  	usb_set_intfdata(interface, dev);
>  
> -	/* initialize videobuf2 stuff */
> -	em28xx_vb2_setup(dev);
> -
>  	/* allocate device struct */
>  	mutex_init(&dev->lock);
> -	mutex_lock(&dev->lock);
>  	retval = em28xx_init_dev(dev, udev, interface, nr);
>  	if (retval) {
> -		goto unlock_and_free;
> +		goto err_free;
>  	}
>  
>  	if (usb_xfer_mode < 0) {
> @@ -3397,7 +3318,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  		if (retval) {
>  			printk(DRIVER_NAME
>  			       ": Failed to pre-allocate USB transfer buffers for DVB.\n");
> -			goto unlock_and_free;
> +			goto err_free;
>  		}
>  	}
>  
> @@ -3406,13 +3327,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  	/* Should be the last thing to do, to avoid newer udev's to
>  	   open the device before fully initializing it
>  	 */
> -	mutex_unlock(&dev->lock);
>  
>  	return 0;
>  
> -unlock_and_free:
> -	mutex_unlock(&dev->lock);
> -
>  err_free:
>  	kfree(dev->alt_max_pkt_size_isoc);
>  	kfree(dev);
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index a802128..0993728 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -33,6 +33,21 @@
>  
>  #include "em28xx.h"
>  
> +#define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
> +                      "Markus Rechberger <mrechberger@gmail.com>, " \
> +                      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
> +                      "Sascha Sommer <saschasommer@freenet.de>"
> +
> +#define DRIVER_DESC         "Empia em28xx based USB core driver"
> +
> +#define EM28XX_VERSION "0.2.0"
> +
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(EM28XX_VERSION);
> +
>  /* #define ENABLE_DEBUG_ISOC_FRAMES */
>  
>  static unsigned int core_debug;
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 792ead1..205d45b 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -763,7 +763,7 @@ static struct vb2_ops em28xx_video_qops = {
>  	.wait_finish    = vb2_ops_wait_finish,
>  };
>  
> -int em28xx_vb2_setup(struct em28xx *dev)
> +static int em28xx_vb2_setup(struct em28xx *dev)
>  {
>  	int rc;
>  	struct vb2_queue *q;
> @@ -831,7 +831,7 @@ static void video_mux(struct em28xx *dev, int index)
>  	em28xx_audio_analog_set(dev);
>  }
>  
> -void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
> +static void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv)
>  {
>  	struct em28xx *dev = priv;
>  
> @@ -1665,15 +1665,16 @@ static int em28xx_v4l2_open(struct file *filp)
>  }
>  
>  /*
> - * em28xx_realease_resources()
> + * em28xx_v4l2_fini()
>   * unregisters the v4l2,i2c and usb devices
>   * called when the device gets disconected or at module unload
>  */
> -void em28xx_release_analog_resources(struct em28xx *dev)
> +static int em28xx_v4l2_fini(struct em28xx *dev)
>  {
>  
>  	/*FIXME: I2C IR should be disconnected */
>  
> +	mutex_lock(&dev->lock);
>  	if (dev->radio_dev) {
>  		if (video_is_registered(dev->radio_dev))
>  			video_unregister_device(dev->radio_dev);
> @@ -1699,6 +1700,9 @@ void em28xx_release_analog_resources(struct em28xx *dev)
>  			video_device_release(dev->vdev);
>  		dev->vdev = NULL;
>  	}
> +	mutex_unlock(&dev->lock);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -1842,8 +1846,6 @@ static struct video_device em28xx_radio_template = {
>  
>  /******************************** usb interface ******************************/
>  
> -
> -
>  static struct video_device *em28xx_vdev_init(struct em28xx *dev,
>  					const struct video_device *template,
>  					const char *type_name)
> @@ -1869,15 +1871,98 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
>  	return vfd;
>  }
>  
> -int em28xx_register_analog_devices(struct em28xx *dev)
> +static int em28xx_v4l2_init(struct em28xx *dev)
>  {
>  	u8 val;
>  	int ret;
>  	unsigned int maxw;
> +        struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
>  
>  	printk(KERN_INFO "%s: v4l2 driver version %s\n",
>  		dev->name, EM28XX_VERSION);
>  
> +	mutex_lock(&dev->lock);
> +
> +	/* initialize videobuf2 stuff */
> +	em28xx_vb2_setup(dev);
> +
> +	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
> +	if (ret < 0) {
> +		em28xx_errdev("Call to v4l2_device_register() failed!\n");
> +		goto err;
> +	}
> +
> +	v4l2_ctrl_handler_init(hdl, 8);
> +	dev->v4l2_dev.ctrl_handler = hdl;
> +
> +	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> +	} else {
> +		/* install the em28xx notify callback */
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> +				em28xx_ctrl_notify, dev);
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> +				em28xx_ctrl_notify, dev);
> +	}
> +
> +	/*
> +	 * Default format, used for tvp5150 or saa711x output formats
> +	 */
> +	dev->vinmode = 0x10;
> +	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
> +		       EM28XX_VINCTRL_CCIR656_ENABLE;
> +
> +	/* Configure audio */
> +	ret = em28xx_audio_setup(dev);
> +	if (ret < 0) {
> +		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> +			__func__, ret);
> +		goto err;
> +	}
> +	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> +	} else {
> +		/* install the em28xx notify callback */
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> +				em28xx_ctrl_notify, dev);
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> +				em28xx_ctrl_notify, dev);
> +	}
> +
> +	/* wake i2c devices */
> +	em28xx_wake_i2c(dev);
> +
> +	/* init video dma queues */
> +	INIT_LIST_HEAD(&dev->vidq.active);
> +	INIT_LIST_HEAD(&dev->vbiq.active);
> +
> +	if (dev->board.has_msp34xx) {
> +		/* Send a reset to other chips via gpio */
> +		ret = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
> +		if (ret < 0) {
> +			em28xx_errdev("%s: em28xx_write_reg - "
> +				      "msp34xx(1) failed! error [%d]\n",
> +				      __func__, ret);
> +			goto err;
> +		}
> +		msleep(3);
> +
> +		ret = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
> +		if (ret < 0) {
> +			em28xx_errdev("%s: em28xx_write_reg - "
> +				      "msp34xx(2) failed! error [%d]\n",
> +				      __func__, ret);
> +			goto err;
> +		}
> +		msleep(3);
> +	}
> +
>  	/* set default norm */
>  	dev->norm = V4L2_STD_PAL;
>  	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> @@ -1940,14 +2025,16 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  	/* Reset image controls */
>  	em28xx_colorlevels_set_default(dev);
>  	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
> -	if (dev->ctrl_handler.error)
> -		return dev->ctrl_handler.error;
> +	ret = dev->ctrl_handler.error;
> +	if (ret)
> +		goto err;
>  
>  	/* allocate and fill video video_device struct */
>  	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
>  	if (!dev->vdev) {
>  		em28xx_errdev("cannot allocate video_device.\n");
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto err;
>  	}
>  	dev->vdev->queue = &dev->vb_vidq;
>  	dev->vdev->queue->lock = &dev->vb_queue_lock;
> @@ -1977,7 +2064,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  	if (ret) {
>  		em28xx_errdev("unable to register video device (error=%i).\n",
>  			      ret);
> -		return ret;
> +		goto err;
>  	}
>  
>  	/* Allocate and fill vbi video_device struct */
> @@ -2006,7 +2093,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  					    vbi_nr[dev->devno]);
>  		if (ret < 0) {
>  			em28xx_errdev("unable to register vbi device\n");
> -			return ret;
> +			goto err;
>  		}
>  	}
>  
> @@ -2015,13 +2102,14 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  						  "radio");
>  		if (!dev->radio_dev) {
>  			em28xx_errdev("cannot allocate video_device.\n");
> -			return -ENODEV;
> +			ret = -ENODEV;
> +			goto err;
>  		}
>  		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
>  					    radio_nr[dev->devno]);
>  		if (ret < 0) {
>  			em28xx_errdev("can't register radio device\n");
> -			return ret;
> +			goto err;
>  		}
>  		em28xx_info("Registered radio device as %s\n",
>  			    video_device_node_name(dev->radio_dev));
> @@ -2034,5 +2122,30 @@ int em28xx_register_analog_devices(struct em28xx *dev)
>  		em28xx_info("V4L2 VBI device registered as %s\n",
>  			    video_device_node_name(dev->vbi_dev));
>  
> -	return 0;
> +	/* Save some power by putting tuner to sleep */
> +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> +
> +err:
> +	mutex_unlock(&dev->lock);
> +	return ret;
>  }
> +
> +static struct em28xx_ops v4l2_ops = {
> +	.id   = EM28XX_V4L2,
> +	.name = "Em28xx v4l2 Extension",
> +	.init = em28xx_v4l2_init,
> +	.fini = em28xx_v4l2_fini,
> +};
> +
> +static int __init em28xx_dvb_register(void)
> +{
> +	return em28xx_register_extension(&v4l2_ops);
> +}
> +
> +static void __exit em28xx_dvb_unregister(void)
> +{
> +	em28xx_unregister_extension(&v4l2_ops);
> +}
> +
> +module_init(em28xx_dvb_register);
> +module_exit(em28xx_dvb_unregister);
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index a9323b6..9830bdf 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -433,6 +433,7 @@ struct em28xx_eeprom {
>  #define EM28XX_AUDIO   0x10
>  #define EM28XX_DVB     0x20
>  #define EM28XX_RC      0x30
> +#define EM28XX_V4L2    0x40
>  
>  /* em28xx resource types (used for res_get/res_lock etc */
>  #define EM28XX_RESOURCE_VIDEO 0x01
> @@ -706,10 +707,6 @@ void em28xx_init_extension(struct em28xx *dev);
>  void em28xx_close_extension(struct em28xx *dev);
>  
>  /* Provided by em28xx-video.c */
> -int em28xx_vb2_setup(struct em28xx *dev);
> -int em28xx_register_analog_devices(struct em28xx *dev);
> -void em28xx_release_analog_resources(struct em28xx *dev);
> -void em28xx_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv);
>  int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
>  int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
>  extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;

