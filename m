Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3L1MQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 03/24] em28xx: move analog-specific init to em28xx-video
Date: Sat, 28 Dec 2013 10:15:55 -0200
Message-Id: <1388232976-20061-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

There are several init code inside em28xx-cards that are actually
part of analog initialization. Move the code to em28x-video, in
order to remove part of the mess.

In thesis, no functional changes so far.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 77 ---------------------------
 drivers/media/usb/em28xx/em28xx-video.c | 94 ++++++++++++++++++++++++++++++---
 2 files changed, 87 insertions(+), 84 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 551cbc294190..4a439e5031e6 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2907,7 +2907,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			   struct usb_interface *interface,
 			   int minor)
 {
-	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	int retval;
 	static const char *default_chip_name = "em28xx";
 	const char *chip_name = default_chip_name;
@@ -3034,15 +3033,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
@@ -3071,75 +3061,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
-	retval = em28xx_register_analog_devices(dev);
-	if (retval < 0) {
-		goto fail;
-	}
-
-	/* Save some power by putting tuner to sleep */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
-
 	return 0;
 
-fail:
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
@@ -3388,9 +3314,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	/* initialize videobuf2 stuff */
-	em28xx_vb2_setup(dev);
-
 	/* allocate device struct */
 	mutex_init(&dev->lock);
 	mutex_lock(&dev->lock);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8b8a4eb96875..63f09b62d546 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2186,10 +2186,80 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	u8 val;
 	int ret;
 	unsigned int maxw;
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+
+	if (!dev->has_video) {
+		/* This device does not support the v4l2 extension */
+		return 0;
+	}
 
 	printk(KERN_INFO "%s: v4l2 driver version %s\n",
 		dev->name, EM28XX_VERSION);
 
+	mutex_lock(&dev->lock);
+
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
+	/* Configure audio */
+	ret = em28xx_audio_setup(dev);
+	if (ret < 0) {
+		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
+			__func__, ret);
+		goto err;
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
+			goto err;
+		}
+		msleep(3);
+
+		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
+		if (ret < 0) {
+			em28xx_errdev("%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
+				      __func__, ret);
+			goto err;
+		}
+		msleep(3);
+	}
+
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -2252,14 +2322,16 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	/* Reset image controls */
 	em28xx_colorlevels_set_default(dev);
 	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
-	if (dev->ctrl_handler.error)
-		return dev->ctrl_handler.error;
+	ret = dev->ctrl_handler.error;
+	if (ret)
+		goto err;
 
 	/* allocate and fill video video_device struct */
 	dev->vdev = em28xx_vdev_init(dev, &em28xx_video_template, "video");
 	if (!dev->vdev) {
 		em28xx_errdev("cannot allocate video_device.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 	dev->vdev->queue = &dev->vb_vidq;
 	dev->vdev->queue->lock = &dev->vb_queue_lock;
@@ -2289,7 +2361,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	if (ret) {
 		em28xx_errdev("unable to register video device (error=%i).\n",
 			      ret);
-		return ret;
+		goto err;
 	}
 
 	/* Allocate and fill vbi video_device struct */
@@ -2318,7 +2390,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("unable to register vbi device\n");
-			return ret;
+			goto err;
 		}
 	}
 
@@ -2327,13 +2399,14 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 						  "radio");
 		if (!dev->radio_dev) {
 			em28xx_errdev("cannot allocate video_device.\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err;
 		}
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			em28xx_errdev("can't register radio device\n");
-			return ret;
+			goto err;
 		}
 		em28xx_info("Registered radio device as %s\n",
 			    video_device_node_name(dev->radio_dev));
@@ -2346,5 +2419,12 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		em28xx_info("V4L2 VBI device registered as %s\n",
 			    video_device_node_name(dev->vbi_dev));
 
+	/* Save some power by putting tuner to sleep */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+
+	/* initialize videobuf2 stuff */
+	em28xx_vb2_setup(dev);
 	return 0;
+
+err:
 }
-- 
1.8.3.1

