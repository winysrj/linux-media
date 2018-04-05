Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40749 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbeDEUaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:30:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Douglas Fischer <fischerdouglasc@gmail.com>
Subject: [PATCH v2 18/19] media: si470x: allow build both USB and I2C at the same time
Date: Thu,  5 Apr 2018 16:29:45 -0400
Message-Id: <9e596fe9e1fd9d2c27ae9abaeb900b2e0cd49011.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, either USB or I2C is built. Change it to allow
having both enabled at the same time.

The main reason is that COMPILE_TEST all[yes/mod]builds will
now contain all drivers under drivers/media.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/Kconfig                      |  4 --
 drivers/media/radio/si470x/Kconfig               | 16 ++++++-
 drivers/media/radio/si470x/Makefile              |  8 ++--
 drivers/media/radio/si470x/radio-si470x-common.c | 61 +++++++++++++++++-------
 drivers/media/radio/si470x/radio-si470x-i2c.c    | 18 ++++---
 drivers/media/radio/si470x/radio-si470x-usb.c    | 18 ++++---
 drivers/media/radio/si470x/radio-si470x.h        | 15 +++---
 7 files changed, 95 insertions(+), 45 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 192f36f2f4aa..2ed539f9eb87 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -15,10 +15,6 @@ if RADIO_ADAPTERS && VIDEO_V4L2
 config RADIO_TEA575X
 	tristate
 
-config RADIO_SI470X
-	bool "Silicon Labs Si470x FM Radio Receiver support"
-	depends on VIDEO_V4L2
-
 source "drivers/media/radio/si470x/Kconfig"
 
 config RADIO_SI4713
diff --git a/drivers/media/radio/si470x/Kconfig b/drivers/media/radio/si470x/Kconfig
index a466654ee5c9..a21172e413a9 100644
--- a/drivers/media/radio/si470x/Kconfig
+++ b/drivers/media/radio/si470x/Kconfig
@@ -1,3 +1,17 @@
+config RADIO_SI470X
+        tristate "Silicon Labs Si470x FM Radio Receiver support"
+        depends on VIDEO_V4L2
+	---help---
+	  This is a driver for devices with the Silicon Labs SI470x
+	  chip (either via USB or I2C buses).
+
+	  Say Y here if you want to connect this type of radio to your
+	  computer's USB port or if it is used by some other driver
+	  via I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-si470x-common.
+
 config USB_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with USB"
 	depends on USB && RADIO_SI470X
@@ -25,7 +39,7 @@ config USB_SI470X
 
 config I2C_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with I2C"
-	depends on I2C && RADIO_SI470X && !USB_SI470X
+	depends on I2C && RADIO_SI470X
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI470x
 	  chip.
diff --git a/drivers/media/radio/si470x/Makefile b/drivers/media/radio/si470x/Makefile
index 06964816cfd6..563500823e04 100644
--- a/drivers/media/radio/si470x/Makefile
+++ b/drivers/media/radio/si470x/Makefile
@@ -2,8 +2,6 @@
 # Makefile for radios with Silicon Labs Si470x FM Radio Receivers
 #
 
-radio-usb-si470x-objs	:= radio-si470x-usb.o radio-si470x-common.o
-radio-i2c-si470x-objs	:= radio-si470x-i2c.o radio-si470x-common.o
-
-obj-$(CONFIG_USB_SI470X) += radio-usb-si470x.o
-obj-$(CONFIG_I2C_SI470X) += radio-i2c-si470x.o
+obj-$(CONFIG_RADIO_SI470X) := radio-si470x-common.o
+obj-$(CONFIG_USB_SI470X) += radio-si470x-usb.o
+obj-$(CONFIG_I2C_SI470X) += radio-si470x-i2c.o
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index b94d66e53d4e..23bc50260b85 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -195,7 +195,7 @@ static int si470x_set_band(struct si470x_device *radio, int band)
 	radio->band = band;
 	radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_BAND;
 	radio->registers[SYSCONFIG2] |= radio->band << 6;
-	return si470x_set_register(radio, SYSCONFIG2);
+	return radio->set_register(radio, SYSCONFIG2);
 }
 
 /*
@@ -207,7 +207,7 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 	unsigned long time_left;
 	bool timed_out = false;
 
-	retval = si470x_get_register(radio, POWERCFG);
+	retval = radio->get_register(radio, POWERCFG);
 	if (retval)
 		return retval;
 
@@ -219,7 +219,7 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 	/* start tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
 	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
-	retval = si470x_set_register(radio, CHANNEL);
+	retval = radio->set_register(radio, CHANNEL);
 	if (retval < 0)
 		goto done;
 
@@ -238,7 +238,7 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 
 	/* stop tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
-	retval = si470x_set_register(radio, CHANNEL);
+	retval = radio->set_register(radio, CHANNEL);
 
 done:
 	return retval;
@@ -272,7 +272,7 @@ static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
 	int chan, retval;
 
 	/* read channel */
-	retval = si470x_get_register(radio, READCHAN);
+	retval = radio->get_register(radio, READCHAN);
 	chan = radio->registers[READCHAN] & READCHAN_READCHAN;
 
 	/* Frequency (MHz) = Spacing (kHz) x Channel + Bottom of Band (MHz) */
@@ -343,7 +343,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 		radio->registers[POWERCFG] |= POWERCFG_SEEKUP;
 	else
 		radio->registers[POWERCFG] &= ~POWERCFG_SEEKUP;
-	retval = si470x_set_register(radio, POWERCFG);
+	retval = radio->set_register(radio, POWERCFG);
 	if (retval < 0)
 		return retval;
 
@@ -362,7 +362,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 
 	/* stop seeking */
 	radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
-	retval = si470x_set_register(radio, POWERCFG);
+	retval = radio->set_register(radio, POWERCFG);
 
 	/* try again, if timed out */
 	if (retval == 0 && timed_out)
@@ -381,7 +381,7 @@ int si470x_start(struct si470x_device *radio)
 	/* powercfg */
 	radio->registers[POWERCFG] =
 		POWERCFG_DMUTE | POWERCFG_ENABLE | POWERCFG_RDSM;
-	retval = si470x_set_register(radio, POWERCFG);
+	retval = radio->set_register(radio, POWERCFG);
 	if (retval < 0)
 		goto done;
 
@@ -392,7 +392,7 @@ int si470x_start(struct si470x_device *radio)
 	radio->registers[SYSCONFIG1] |= SYSCONFIG1_GPIO2_INT;
 	if (de)
 		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
-	retval = si470x_set_register(radio, SYSCONFIG1);
+	retval = radio->set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
 
@@ -402,7 +402,7 @@ int si470x_start(struct si470x_device *radio)
 		((radio->band << 6) & SYSCONFIG2_BAND) |/* BAND */
 		((space << 4) & SYSCONFIG2_SPACE) |	/* SPACE */
 		15;					/* VOLUME (max) */
-	retval = si470x_set_register(radio, SYSCONFIG2);
+	retval = radio->set_register(radio, SYSCONFIG2);
 	if (retval < 0)
 		goto done;
 
@@ -424,7 +424,7 @@ int si470x_stop(struct si470x_device *radio)
 
 	/* sysconfig 1 */
 	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
-	retval = si470x_set_register(radio, SYSCONFIG1);
+	retval = radio->set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
 
@@ -432,7 +432,7 @@ int si470x_stop(struct si470x_device *radio)
 	radio->registers[POWERCFG] &= ~POWERCFG_DMUTE;
 	/* POWERCFG_ENABLE has to automatically go low */
 	radio->registers[POWERCFG] |= POWERCFG_ENABLE |	POWERCFG_DISABLE;
-	retval = si470x_set_register(radio, POWERCFG);
+	retval = radio->set_register(radio, POWERCFG);
 
 done:
 	return retval;
@@ -448,7 +448,7 @@ static int si470x_rds_on(struct si470x_device *radio)
 
 	/* sysconfig 1 */
 	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDS;
-	retval = si470x_set_register(radio, SYSCONFIG1);
+	retval = radio->set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
 
@@ -542,6 +542,25 @@ static __poll_t si470x_fops_poll(struct file *file,
 }
 
 
+static int si470x_fops_open(struct file *file)
+{
+	struct si470x_device *radio = video_drvdata(file);
+
+	return radio->fops_open(file);
+}
+
+
+/*
+ * si470x_fops_release - file release
+ */
+static int si470x_fops_release(struct file *file)
+{
+	struct si470x_device *radio = video_drvdata(file);
+
+	return radio->fops_release(file);
+}
+
+
 /*
  * si470x_fops - file operations interface
  */
@@ -570,13 +589,13 @@ static int si470x_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_AUDIO_VOLUME:
 		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_VOLUME;
 		radio->registers[SYSCONFIG2] |= ctrl->val;
-		return si470x_set_register(radio, SYSCONFIG2);
+		return radio->set_register(radio, SYSCONFIG2);
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->val)
 			radio->registers[POWERCFG] &= ~POWERCFG_DMUTE;
 		else
 			radio->registers[POWERCFG] |= POWERCFG_DMUTE;
-		return si470x_set_register(radio, POWERCFG);
+		return radio->set_register(radio, POWERCFG);
 	default:
 		return -EINVAL;
 	}
@@ -596,7 +615,7 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (!radio->status_rssi_auto_update) {
-		retval = si470x_get_register(radio, STATUSRSSI);
+		retval = radio->get_register(radio, STATUSRSSI);
 		if (retval < 0)
 			return retval;
 	}
@@ -665,7 +684,7 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 		break;
 	}
 
-	return si470x_set_register(radio, POWERCFG);
+	return radio->set_register(radio, POWERCFG);
 }
 
 
@@ -743,6 +762,14 @@ const struct v4l2_ctrl_ops si470x_ctrl_ops = {
 	.s_ctrl = si470x_s_ctrl,
 };
 
+static int si470x_vidioc_querycap(struct file *file, void *priv,
+		struct v4l2_capability *capability)
+{
+	struct si470x_device *radio = video_drvdata(file);
+
+	return radio->vidioc_querycap(file, priv, capability);
+};
+
 /*
  * si470x_ioctl_ops - video device ioctl operations
  */
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 41709b24b28f..1b3720b1e737 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -89,7 +89,7 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 /*
  * si470x_get_register - read register
  */
-int si470x_get_register(struct si470x_device *radio, int regnr)
+static int si470x_get_register(struct si470x_device *radio, int regnr)
 {
 	u16 buf[READ_REG_NUM];
 	struct i2c_msg msgs[1] = {
@@ -113,7 +113,7 @@ int si470x_get_register(struct si470x_device *radio, int regnr)
 /*
  * si470x_set_register - write register
  */
-int si470x_set_register(struct si470x_device *radio, int regnr)
+static int si470x_set_register(struct si470x_device *radio, int regnr)
 {
 	int i;
 	u16 buf[WRITE_REG_NUM];
@@ -174,7 +174,7 @@ static int si470x_get_all_registers(struct si470x_device *radio)
 /*
  * si470x_fops_open - file open
  */
-int si470x_fops_open(struct file *file)
+static int si470x_fops_open(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = v4l2_fh_open(file);
@@ -206,7 +206,7 @@ int si470x_fops_open(struct file *file)
 /*
  * si470x_fops_release - file release
  */
-int si470x_fops_release(struct file *file)
+static int si470x_fops_release(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 
@@ -226,8 +226,8 @@ int si470x_fops_release(struct file *file)
 /*
  * si470x_vidioc_querycap - query device capabilities
  */
-int si470x_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *capability)
+static int si470x_vidioc_querycap(struct file *file, void *priv,
+				  struct v4l2_capability *capability)
 {
 	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
@@ -361,6 +361,12 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	mutex_init(&radio->lock);
 	init_completion(&radio->completion);
 
+	radio->get_register = si470x_get_register;
+	radio->set_register = si470x_set_register;
+	radio->fops_open = si470x_fops_open;
+	radio->fops_release = si470x_fops_release;
+	radio->vidioc_querycap = si470x_vidioc_querycap;
+
 	retval = v4l2_device_register(&client->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&client->dev, "couldn't register v4l2_device\n");
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 2277e850bb5e..313a95f195a2 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -250,7 +250,7 @@ static int si470x_set_report(struct si470x_device *radio, void *buf, int size)
 /*
  * si470x_get_register - read register
  */
-int si470x_get_register(struct si470x_device *radio, int regnr)
+static int si470x_get_register(struct si470x_device *radio, int regnr)
 {
 	int retval;
 
@@ -268,7 +268,7 @@ int si470x_get_register(struct si470x_device *radio, int regnr)
 /*
  * si470x_set_register - write register
  */
-int si470x_set_register(struct si470x_device *radio, int regnr)
+static int si470x_set_register(struct si470x_device *radio, int regnr)
 {
 	int retval;
 
@@ -482,12 +482,12 @@ static void si470x_int_in_callback(struct urb *urb)
 }
 
 
-int si470x_fops_open(struct file *file)
+static int si470x_fops_open(struct file *file)
 {
 	return v4l2_fh_open(file);
 }
 
-int si470x_fops_release(struct file *file)
+static int si470x_fops_release(struct file *file)
 {
 	return v4l2_fh_release(file);
 }
@@ -514,8 +514,8 @@ static void si470x_usb_release(struct v4l2_device *v4l2_dev)
 /*
  * si470x_vidioc_querycap - query device capabilities
  */
-int si470x_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *capability)
+static int si470x_vidioc_querycap(struct file *file, void *priv,
+				  struct v4l2_capability *capability)
 {
 	struct si470x_device *radio = video_drvdata(file);
 
@@ -598,6 +598,12 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	mutex_init(&radio->lock);
 	init_completion(&radio->completion);
 
+	radio->get_register = si470x_get_register;
+	radio->set_register = si470x_set_register;
+	radio->fops_open = si470x_fops_open;
+	radio->fops_release = si470x_fops_release;
+	radio->vidioc_querycap = si470x_vidioc_querycap;
+
 	iface_desc = intf->cur_altsetting;
 
 	/* Set up interrupt endpoint information. */
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 0202f8eb90c4..35fa0f3bbdd2 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -161,6 +161,15 @@ struct si470x_device {
 	struct completion completion;
 	bool status_rssi_auto_update;	/* Does RSSI get updated automatic? */
 
+	/* si470x ops */
+
+	int (*get_register)(struct si470x_device *radio, int regnr);
+	int (*set_register)(struct si470x_device *radio, int regnr);
+	int (*fops_open)(struct file *file);
+	int (*fops_release)(struct file *file);
+	int (*vidioc_querycap)(struct file *file, void *priv,
+			       struct v4l2_capability *capability);
+
 #if IS_ENABLED(CONFIG_USB_SI470X)
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
@@ -213,13 +222,7 @@ struct si470x_device {
  **************************************************************************/
 extern const struct video_device si470x_viddev_template;
 extern const struct v4l2_ctrl_ops si470x_ctrl_ops;
-int si470x_get_register(struct si470x_device *radio, int regnr);
-int si470x_set_register(struct si470x_device *radio, int regnr);
 int si470x_disconnect_check(struct si470x_device *radio);
 int si470x_set_freq(struct si470x_device *radio, unsigned int freq);
 int si470x_start(struct si470x_device *radio);
 int si470x_stop(struct si470x_device *radio);
-int si470x_fops_open(struct file *file);
-int si470x_fops_release(struct file *file);
-int si470x_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *capability);
-- 
2.14.3
