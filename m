Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:31355 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZGML0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 07:26:08 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KMP00A62X00Z5@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jul 2009 20:24:00 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KMP00KZKX00FP@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jul 2009 20:24:00 +0900 (KST)
Date: Mon, 13 Jul 2009 20:24:00 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/2] radio-si470x: add i2c driver for si470x
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <4A5B1950.8000800@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch supports i2c interface of si470x. The i2c specific part
exists in radio-si470x-i2c.c file and the common part uses
radio-si470x-common.c file. The '#if defined' is inserted inevitably
because of parts used only si470x usb in the common file.

The current driver version doesn't support the RDS.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 linux/drivers/media/radio/si470x/Kconfig           |   13 +
 linux/drivers/media/radio/si470x/Makefile          |    2 +
 .../media/radio/si470x/radio-si470x-common.c       |   24 ++
 .../drivers/media/radio/si470x/radio-si470x-i2c.c  |  250 ++++++++++++++++++++
 linux/drivers/media/radio/si470x/radio-si470x.h    |    6 +
 5 files changed, 295 insertions(+), 0 deletions(-)
 create mode 100644 linux/drivers/media/radio/si470x/radio-si470x-i2c.c

diff --git a/linux/drivers/media/radio/si470x/Kconfig b/linux/drivers/media/radio/si470x/Kconfig
index 20d05c0..a466654 100644
--- a/linux/drivers/media/radio/si470x/Kconfig
+++ b/linux/drivers/media/radio/si470x/Kconfig
@@ -22,3 +22,16 @@ config USB_SI470X
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-usb-si470x.
+
+config I2C_SI470X
+	tristate "Silicon Labs Si470x FM Radio Receiver support with I2C"
+	depends on I2C && RADIO_SI470X && !USB_SI470X
+	---help---
+	  This is a driver for I2C devices with the Silicon Labs SI470x
+	  chip.
+
+	  Say Y here if you want to connect this type of radio to your
+	  computer's I2C port.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-i2c-si470x.
diff --git a/linux/drivers/media/radio/si470x/Makefile b/linux/drivers/media/radio/si470x/Makefile
index 3cb777f..0696481 100644
--- a/linux/drivers/media/radio/si470x/Makefile
+++ b/linux/drivers/media/radio/si470x/Makefile
@@ -3,5 +3,7 @@
 #
 
 radio-usb-si470x-objs	:= radio-si470x-usb.o radio-si470x-common.o
+radio-i2c-si470x-objs	:= radio-si470x-i2c.o radio-si470x-common.o
 
 obj-$(CONFIG_USB_SI470X) += radio-usb-si470x.o
+obj-$(CONFIG_I2C_SI470X) += radio-i2c-si470x.o
diff --git a/linux/drivers/media/radio/si470x/radio-si470x-common.c b/linux/drivers/media/radio/si470x/radio-si470x-common.c
index d2dc1ff..77f79e7 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c
@@ -473,11 +473,13 @@ static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* safety checks */
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -492,7 +494,9 @@ static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
 		retval = -EINVAL;
 	}
 
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 done:
+#endif
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": get control failed with %d\n", retval);
@@ -509,11 +513,13 @@ static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
 	struct si470x_device *radio = video_drvdata(file);
 	int retval = 0;
 
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* safety checks */
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -532,7 +538,9 @@ static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
 		retval = -EINVAL;
 	}
 
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 done:
+#endif
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set control failed with %d\n", retval);
@@ -566,10 +574,12 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 	if (tuner->index != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -582,8 +592,12 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	/* driver constants */
 	strcpy(tuner->name, "FM");
 	tuner->type = V4L2_TUNER_RADIO;
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			    V4L2_TUNER_CAP_RDS;
+#else
+	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
+#endif
 
 	/* range limits */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -609,10 +623,12 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
 	else
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* If there is a reliable method of detecting an RDS channel,
 	   then this code should check for that before setting this
 	   RDS subchannel. */
 	tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
+#endif
 
 	/* mono/stereo selector */
 	if ((radio->registers[POWERCFG] & POWERCFG_MONO) == 0)
@@ -648,10 +664,12 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 	int retval = -EINVAL;
 
 	/* safety checks */
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 	if (tuner->index != 0)
 		goto done;
 
@@ -687,10 +705,12 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -717,10 +737,12 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 	if (freq->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
@@ -746,10 +768,12 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	int retval = 0;
 
 	/* safety checks */
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	if (radio->disconnected) {
 		retval = -EIO;
 		goto done;
 	}
+#endif
 	if (seek->tuner != 0) {
 		retval = -EINVAL;
 		goto done;
diff --git a/linux/drivers/media/radio/si470x/radio-si470x-i2c.c b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
new file mode 100644
index 0000000..e7f3070
--- /dev/null
+++ b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -0,0 +1,250 @@
+/*
+ * drivers/media/radio/si470x/radio-si470x-i2c.c
+ *
+ * I2C driver for radios with Silicon Labs Si470x FM Radio Receivers
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *
+ * TODO:
+ * - RDS support
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+
+#include "radio-si470x.h"
+
+#define DRIVER_KERNEL_VERSION	KERNEL_VERSION(1, 0, 0)
+#define DRIVER_CARD		"Silicon Labs Si470x FM Radio Receiver"
+#define DRIVER_VERSION		"1.0.0"
+
+/* starting with the upper byte of register 0x0a */
+#define READ_REG_NUM		RADIO_REGISTER_NUM
+#define READ_INDEX(i)		((i + RADIO_REGISTER_NUM - 0x0a) % READ_REG_NUM)
+
+static int si470x_get_all_registers(struct si470x_device *radio)
+{
+	int i;
+	u16 buf[READ_REG_NUM];
+	struct i2c_msg msgs[1] = {
+		{ radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
+			(void *)buf },
+	};
+
+	if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
+		return -EIO;
+
+	for (i = 0; i < READ_REG_NUM; i++)
+		radio->registers[i] = __be16_to_cpu(buf[READ_INDEX(i)]);
+
+	return 0;
+}
+
+int si470x_get_register(struct si470x_device *radio, int regnr)
+{
+	u16 buf[READ_REG_NUM];
+	struct i2c_msg msgs[1] = {
+		{ radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
+			(void *)buf },
+	};
+
+	if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
+		return -EIO;
+
+	radio->registers[regnr] = __be16_to_cpu(buf[READ_INDEX(regnr)]);
+
+	return 0;
+}
+
+/* starting with the upper byte of register 0x02h */
+#define WRITE_REG_NUM		8
+#define WRITE_INDEX(i)		(i + 0x02)
+
+int si470x_set_register(struct si470x_device *radio, int regnr)
+{
+	int i;
+	u16 buf[WRITE_REG_NUM];
+	struct i2c_msg msgs[1] = {
+		{ radio->client->addr, 0, sizeof(u16) * WRITE_REG_NUM,
+			(void *)buf },
+	};
+
+	for (i = 0; i < WRITE_REG_NUM; i++)
+		buf[i] = __cpu_to_be16(radio->registers[WRITE_INDEX(i)]);
+
+	if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int si470x_fops_open(struct file *file)
+{
+	struct si470x_device *radio = video_drvdata(file);
+	int retval = 0;
+
+	mutex_lock(&radio->lock);
+	radio->users++;
+
+	if (radio->users == 1)
+		/* start radio */
+		retval = si470x_start(radio);
+	mutex_unlock(&radio->lock);
+
+	return retval;
+}
+
+static int si470x_fops_release(struct file *file)
+{
+	struct si470x_device *radio = video_drvdata(file);
+	int retval = 0;
+
+	/* safety check */
+	if (!radio)
+		return -ENODEV;
+
+	mutex_lock(&radio->lock);
+	radio->users--;
+	if (radio->users == 0)
+		/* stop radio */
+		retval = si470x_stop(radio);
+	mutex_unlock(&radio->lock);
+
+	return retval;
+}
+
+const struct v4l2_file_operations si470x_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= video_ioctl2,
+	.open		= si470x_fops_open,
+	.release	= si470x_fops_release,
+};
+
+int si470x_vidioc_querycap(struct file *file, void *priv,
+		struct v4l2_capability *capability)
+{
+	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
+	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
+	capability->version = DRIVER_KERNEL_VERSION;
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+
+	return 0;
+}
+
+static int __devinit si470x_i2c_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct si470x_device *radio;
+	int retval = 0;
+
+	/* private data allocation and initialization */
+	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
+	if (!radio) {
+		retval = -ENOMEM;
+		goto err_initial;
+	}
+	radio->client = client;
+	radio->users = 0;
+	mutex_init(&radio->lock);
+
+	/* video device allocation and initialization */
+	radio->videodev = video_device_alloc();
+	if (!radio->videodev) {
+		retval = -ENOMEM;
+		goto err_radio;
+	}
+	memcpy(radio->videodev, &si470x_viddev_template,
+			sizeof(si470x_viddev_template));
+	video_set_drvdata(radio->videodev, radio);
+
+	/* power up : need 110ms */
+	radio->registers[POWERCFG] = POWERCFG_ENABLE;
+	if (si470x_set_register(radio, POWERCFG) < 0) {
+		retval = -EIO;
+		goto err_all;
+	}
+	msleep(110);
+
+	/* show some infos about the specific si470x device */
+	if (si470x_get_all_registers(radio) < 0) {
+		retval = -EIO;
+		goto err_radio;
+	}
+	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
+			radio->registers[DEVICEID], radio->registers[CHIPID]);
+
+	/* set initial frequency */
+	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
+
+	/* register video device */
+	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO, -1);
+	if (retval) {
+		printk(KERN_WARNING DRIVER_NAME
+				": Could not register video device\n");
+		goto err_all;
+	}
+
+	i2c_set_clientdata(client, radio);
+
+	return 0;
+err_all:
+	video_device_release(radio->videodev);
+err_radio:
+	kfree(radio);
+err_initial:
+	return retval;
+}
+
+static __devexit int si470x_i2c_remove(struct i2c_client *client)
+{
+	struct si470x_device *radio = i2c_get_clientdata(client);
+
+	video_unregister_device(radio->videodev);
+	kfree(radio);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static const struct i2c_device_id si470x_i2c_id[] = {
+	{ "si470x", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, si470x_i2c_id);
+
+static struct i2c_driver si470x_i2c_driver = {
+	.driver = {
+		.name = "si470x",
+		.owner = THIS_MODULE,
+	},
+	.probe = si470x_i2c_probe,
+	.remove = __devexit_p(si470x_i2c_remove),
+	.id_table = si470x_i2c_id,
+};
+
+static int __init si470x_i2c_init(void)
+{
+	return i2c_add_driver(&si470x_i2c_driver);
+}
+module_init(si470x_i2c_init);
+
+static void __exit si470x_i2c_exit(void)
+{
+	i2c_del_driver(&si470x_i2c_driver);
+}
+module_exit(si470x_i2c_exit);
+
+MODULE_DESCRIPTION("i2c radio driver for si470x fm radio receivers");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/linux/drivers/media/radio/si470x/radio-si470x.h b/linux/drivers/media/radio/si470x/radio-si470x.h
index 6b85315..861c096 100644
--- a/linux/drivers/media/radio/si470x/radio-si470x.h
+++ b/linux/drivers/media/radio/si470x/radio-si470x.h
@@ -143,6 +143,11 @@
 struct si470x_device {
 	struct video_device *videodev;
 
+#if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
+	struct i2c_client *client;
+#endif
+
+#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
 	struct usb_interface *intf;
@@ -160,6 +165,7 @@ struct si470x_device {
 	/* driver management */
 	unsigned char disconnected;
 	struct mutex disconnect_lock;
+#endif
 	unsigned int users;
 
 	/* Silabs internal registers (0..15) */
-- 
1.6.0.4
