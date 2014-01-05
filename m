Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:27993 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAEOkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 09:40:07 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYX003DSNEUZK50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 05 Jan 2014 09:40:06 -0500 (EST)
Date: Sun, 05 Jan 2014 12:40:01 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 03/22] [media] em28xx: move analog-specific init to
 em28xx-video
Message-id: <20140105124001.5a90df8a@samsung.com>
In-reply-to: <52C93346.8070507@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-4-git-send-email-m.chehab@samsung.com>
 <52C93346.8070507@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 11:26:14 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > There are several init code inside em28xx-cards that are actually
> > part of analog initialization. Move the code to em28x-video, in
> > order to remove part of the mess.
> >
> > In thesis, no functional changes so far.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-cards.c | 71 -------------------------
> >  drivers/media/usb/em28xx/em28xx-video.c | 91 ++++++++++++++++++++++++++++++---
> >  2 files changed, 84 insertions(+), 78 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 551cbc294190..175cd776e0a1 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2907,7 +2907,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  			   struct usb_interface *interface,
> >  			   int minor)
> >  {
> > -	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
> >  	int retval;
> >  	static const char *default_chip_name = "em28xx";
> >  	const char *chip_name = default_chip_name;
> > @@ -3034,15 +3033,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
> > @@ -3071,72 +3061,14 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
> em28xx_card_setup() initializes some v4l2 subdevices, but now the v4l2
> device (dev->v4l2_dev) isn't ready at this point, because
> v4l2_device_register() isn't called yet.
> This introduces oopses.
> You are fixing this with patch 5/22 later, but patches should never
> introduce any oopses.
> The simplest soultion is to move patch 5/22 before this patch.

After thinking for a while, the better to just fold patch 5 into patch 3,
and do the necessary changes at the error handling logic.

This makes it simpler to review and test. 

New patch enclosed.

Btw, I tested here with HVR-950, without any noticeable changes.

Cheers,
Mauro

-

[PATCH] [media] em28xx: move analog-specific init to em28xx-video

There are several init code inside em28xx-cards that are actually
part of analog initialization. Move the code to em28x-video, in
order to remove part of the mess.

In thesis, no functional changes so far.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 154e6f028fd2..541de6df127b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2360,24 +2360,6 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 };
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
 
-/* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
-static unsigned short saa711x_addrs[] = {
-	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
-	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
-	I2C_CLIENT_END };
-
-static unsigned short tvp5150_addrs[] = {
-	0xb8 >> 1,
-	0xba >> 1,
-	I2C_CLIENT_END
-};
-
-static unsigned short msp3400_addrs[] = {
-	0x80 >> 1,
-	0x88 >> 1,
-	I2C_CLIENT_END
-};
-
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 {
 	struct em28xx_i2c_bus *i2c_bus = ptr;
@@ -2782,58 +2764,8 @@ static void em28xx_card_setup(struct em28xx *dev)
 	/* Allow override tuner type by a module parameter */
 	if (tuner >= 0)
 		dev->tuner_type = tuner;
-
-	/* request some modules */
-	if (dev->board.has_msp34xx)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"msp3400", 0, msp3400_addrs);
-
-	if (dev->board.decoder == EM28XX_SAA711X)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"saa7115_auto", 0, saa711x_addrs);
-
-	if (dev->board.decoder == EM28XX_TVP5150)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvp5150", 0, tvp5150_addrs);
-
-	if (dev->board.adecoder == EM28XX_TVAUDIO)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvaudio", dev->board.tvaudio_addr, NULL);
-
-	if (dev->board.tuner_type != TUNER_ABSENT) {
-		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
-
-		if (dev->board.radio.type)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->board.radio_addr, NULL);
-
-		if (has_demod)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
-				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
-		if (dev->tuner_addr == 0) {
-			enum v4l2_i2c_tuner_type type =
-				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
-			struct v4l2_subdev *sd;
-
-			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
-				0, v4l2_i2c_tuner_addrs(type));
-
-			if (sd)
-				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
-		} else {
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->tuner_addr, NULL);
-		}
-	}
-
-	em28xx_tuner_setup(dev);
-
-	em28xx_init_camera(dev);
 }
 
-
 static void request_module_async(struct work_struct *work)
 {
 	struct em28xx *dev = container_of(work,
@@ -2907,7 +2839,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			   struct usb_interface *interface,
 			   int minor)
 {
-	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	int retval;
 	static const char *default_chip_name = "em28xx";
 	const char *chip_name = default_chip_name;
@@ -3034,15 +2965,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		}
 	}
 
-	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
-	if (retval < 0) {
-		em28xx_errdev("Call to v4l2_device_register() failed!\n");
-		return retval;
-	}
-
-	v4l2_ctrl_handler_init(hdl, 8);
-	dev->v4l2_dev.ctrl_handler = hdl;
-
 	rt_mutex_init(&dev->i2c_bus_lock);
 
 	/* register i2c bus 0 */
@@ -3053,7 +2975,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	if (retval < 0) {
 		em28xx_errdev("%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 			__func__, retval);
-		goto unregister_dev;
+		return retval;
 	}
 
 	/* register i2c bus 1 */
@@ -3067,75 +2989,16 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
-			goto unregister_dev;
+			return retval;
 		}
 	}
 
-	/*
-	 * Default format, used for tvp5150 or saa711x output formats
-	 */
-	dev->vinmode = 0x10;
-	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
-		       EM28XX_VINCTRL_CCIR656_ENABLE;
-
 	/* Do board specific init and eeprom reading */
 	em28xx_card_setup(dev);
 
-	/* Configure audio */
-	retval = em28xx_audio_setup(dev);
-	if (retval < 0) {
-		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
-			__func__, retval);
-		goto fail;
-	}
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
-		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
-			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
-	} else {
-		/* install the em28xx notify callback */
-		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
-				em28xx_ctrl_notify, dev);
-		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
-				em28xx_ctrl_notify, dev);
-	}
-
-	/* wake i2c devices */
-	em28xx_wake_i2c(dev);
-
-	/* init video dma queues */
-	INIT_LIST_HEAD(&dev->vidq.active);
-	INIT_LIST_HEAD(&dev->vbiq.active);
-
-	if (dev->board.has_msp34xx) {
-		/* Send a reset to other chips via gpio */
-		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
-		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_write_reg - "
-				      "msp34xx(1) failed! error [%d]\n",
-				      __func__, retval);
-			goto fail;
-		}
-		msleep(3);
-
-		retval = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
-		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_write_reg - "
-				      "msp34xx(2) failed! error [%d]\n",
-				      __func__, retval);
-			goto fail;
-		}
-		msleep(3);
-	}
-
 	retval = em28xx_register_analog_devices(dev);
-	if (retval < 0) {
+	if (retval < 0)
 		goto fail;
-	}
-
-	/* Save some power by putting tuner to sleep */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 	return 0;
 
@@ -3143,10 +3006,6 @@ fail:
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
-	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-
-unregister_dev:
-	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return retval;
 }
@@ -3388,9 +3247,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	/* initialize videobuf2 stuff */
-	em28xx_vb2_setup(dev);
-
 	/* allocate device struct */
 	mutex_init(&dev->lock);
 	mutex_lock(&dev->lock);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b3ede856c32e..3726af134f39 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2045,6 +2045,24 @@ static struct video_device em28xx_radio_template = {
 	.ioctl_ops 	      = &radio_ioctl_ops,
 };
 
+/* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
+static unsigned short saa711x_addrs[] = {
+	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
+	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
+	I2C_CLIENT_END };
+
+static unsigned short tvp5150_addrs[] = {
+	0xb8 >> 1,
+	0xba >> 1,
+	I2C_CLIENT_END
+};
+
+static unsigned short msp3400_addrs[] = {
+	0x80 >> 1,
+	0x88 >> 1,
+	I2C_CLIENT_END
+};
+
 /******************************** usb interface ******************************/
 
 
@@ -2186,10 +2204,129 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	u8 val;
 	int ret;
 	unsigned int maxw;
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+
+	if (dev->is_audio_only) {
+		/* This device does not support the v4l2 extension */
+		return 0;
+	}
 
 	printk(KERN_INFO "%s: v4l2 driver version %s\n",
 		dev->name, EM28XX_VERSION);
 
+	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
+	if (ret < 0) {
+		em28xx_errdev("Call to v4l2_device_register() failed!\n");
+		goto err;
+	}
+
+	v4l2_ctrl_handler_init(hdl, 8);
+	dev->v4l2_dev.ctrl_handler = hdl;
+
+	/*
+	 * Default format, used for tvp5150 or saa711x output formats
+	 */
+	dev->vinmode = 0x10;
+	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
+		       EM28XX_VINCTRL_CCIR656_ENABLE;
+
+	/* request some modules */
+
+	if (dev->board.has_msp34xx)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"msp3400", 0, msp3400_addrs);
+
+	if (dev->board.decoder == EM28XX_SAA711X)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"saa7115_auto", 0, saa711x_addrs);
+
+	if (dev->board.decoder == EM28XX_TVP5150)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"tvp5150", 0, tvp5150_addrs);
+
+	if (dev->board.adecoder == EM28XX_TVAUDIO)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"tvaudio", dev->board.tvaudio_addr, NULL);
+
+	/* Initialize tuner and camera */
+
+	if (dev->board.tuner_type != TUNER_ABSENT) {
+		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
+
+		if (dev->board.radio.type)
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+				"tuner", dev->board.radio_addr, NULL);
+
+		if (has_demod)
+			v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
+		if (dev->tuner_addr == 0) {
+			enum v4l2_i2c_tuner_type type =
+				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
+			struct v4l2_subdev *sd;
+
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+				0, v4l2_i2c_tuner_addrs(type));
+
+			if (sd)
+				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
+		} else {
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+				"tuner", dev->tuner_addr, NULL);
+		}
+	}
+
+	em28xx_tuner_setup(dev);
+	em28xx_init_camera(dev);
+
+	/* Configure audio */
+	ret = em28xx_audio_setup(dev);
+	if (ret < 0) {
+		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
+			__func__, ret);
+		goto unregister_dev;
+	}
+	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
+	} else {
+		/* install the em28xx notify callback */
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
+				em28xx_ctrl_notify, dev);
+		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
+				em28xx_ctrl_notify, dev);
+	}
+
+	/* wake i2c devices */
+	em28xx_wake_i2c(dev);
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&dev->vidq.active);
+	INIT_LIST_HEAD(&dev->vbiq.active);
+
+	if (dev->board.has_msp34xx) {
+		/* Send a reset to other chips via gpio */
+		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
+		if (ret < 0) {
+			em28xx_errdev("%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
+				      __func__, ret);
+			goto unregister_dev;
+		}
+		msleep(3);
+
+		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
+		if (ret < 0) {
+			em28xx_errdev("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
+				      __func__, ret);
+			goto unregister_dev;
+		}
+		msleep(3);
+	}
+
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -2252,14 +2389,16 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	/* Reset image controls */
 	em28xx_colorlevels_set_default(dev);
 	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
-	if (dev->ctrl_handler.error)
-		return dev->ctrl_handler.error;
+	ret = dev->ctrl_handler.error;
+	if (ret)
+		goto unregister_dev;
 
 	/* allocate and fill video video_device struct */
 	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
 	if (!dev->vdev) {
 		em28xx_errdev("cannot allocate video_device.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unregister_dev;
 	}
 	dev->vdev->queue = &dev->vb_vidq;
 	dev->vdev->queue->lock = &dev->vb_queue_lock;
@@ -2289,7 +2428,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	if (ret) {
 		em28xx_errdev("unable to register video device (error=%i).\n",
 			      ret);
-		return ret;
+		goto unregister_dev;
 	}
 
 	/* Allocate and fill vbi video_device struct */
@@ -2318,7 +2457,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("unable to register vbi device\n");
-			return ret;
+			goto unregister_dev;
 		}
 	}
 
@@ -2327,13 +2466,14 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 						  "radio");
 		if (!dev->radio_dev) {
 			em28xx_errdev("cannot allocate video_device.\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto unregister_dev;
 		}
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("can't register radio device\n");
-			return ret;
+			goto unregister_dev;
 		}
 		em28xx_info("Registered radio device as %s\n",
 			    video_device_node_name(dev->radio_dev));
@@ -2346,5 +2486,17 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		em28xx_info("V4L2 VBI device registered as %s\n",
 			    video_device_node_name(dev->vbi_dev));
 
+	/* Save some power by putting tuner to sleep */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+
+	/* initialize videobuf2 stuff */
+	em28xx_vb2_setup(dev);
+
 	return 0;
+
+unregister_dev:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+err:
+	return ret;
 }

