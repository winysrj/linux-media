Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:47565 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3HUIaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:30:03 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: eduardo.valentin@nokia.com, Dinesh Ram <dinram@cisco.com>
Subject: [RFC PATCH 1/5] si4713 : Reorganized drivers/media/radio directory
Date: Wed, 21 Aug 2013 10:19:47 +0200
Message-Id: <714c16de2d45c2ccfc2fc94b2770bbd00bfeb977.1377073025.git.dinram@cisco.com>
In-Reply-To: <1377073191-29197-1-git-send-email-dinram@cisco.com>
References: <1377073191-29197-1-git-send-email-dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added a new si4713 directory which will contain all si4713 related files.
Also updated Makefile and Kconfig

Signed-off-by: Dinesh Ram <dinram@cisco.com>
---
 drivers/media/radio/Kconfig                   |   29 +-
 drivers/media/radio/Makefile                  |    3 +-
 drivers/media/radio/radio-si4713.c            |  246 ----
 drivers/media/radio/si4713-i2c.c              | 1532 -------------------------
 drivers/media/radio/si4713-i2c.h              |  238 ----
 drivers/media/radio/si4713/Kconfig            |   25 +
 drivers/media/radio/si4713/Makefile           |    7 +
 drivers/media/radio/si4713/radio-i2c-si4713.c |  246 ++++
 drivers/media/radio/si4713/si4713.c           | 1532 +++++++++++++++++++++++++
 drivers/media/radio/si4713/si4713.h           |  238 ++++
 10 files changed, 2055 insertions(+), 2041 deletions(-)
 delete mode 100644 drivers/media/radio/radio-si4713.c
 delete mode 100644 drivers/media/radio/si4713-i2c.c
 delete mode 100644 drivers/media/radio/si4713-i2c.h
 create mode 100644 drivers/media/radio/si4713/Kconfig
 create mode 100644 drivers/media/radio/si4713/Makefile
 create mode 100644 drivers/media/radio/si4713/radio-i2c-si4713.c
 create mode 100644 drivers/media/radio/si4713/si4713.c
 create mode 100644 drivers/media/radio/si4713/si4713.h

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 39882dd..c92d654 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -15,6 +15,12 @@ if RADIO_ADAPTERS && VIDEO_V4L2
 config RADIO_TEA575X
 	tristate
 
+config RADIO_SI4713
+	tristate "Silicon Labs Si4713 FM Radio with RDS Transmitter support"
+	depends on VIDEO_V4L2
+
+source "drivers/media/radio/si4713/Kconfig"
+
 config RADIO_SI470X
 	bool "Silicon Labs Si470x FM Radio Receiver support"
 	depends on VIDEO_V4L2
@@ -113,29 +119,6 @@ config RADIO_SHARK2
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-shark2.
 
-config I2C_SI4713
-	tristate "I2C driver for Silicon Labs Si4713 device"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  Say Y here if you want support to Si4713 I2C device.
-	  This device driver supports only i2c bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called si4713.
-
-config RADIO_SI4713
-	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
-	depends on I2C && VIDEO_V4L2
-	select I2C_SI4713
-	---help---
-	  Say Y here if you want support to Si4713 FM Radio Transmitter.
-	  This device can transmit audio through FM. It can transmit
-	  RDS and RBDS signals as well. This module is the v4l2 radio
-	  interface for the i2c driver of this device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called radio-si4713.
-
 config USB_KEENE
 	tristate "Keene FM Transmitter USB support"
 	depends on USB && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 3b64560..eb1a3a0 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -17,12 +17,11 @@ obj-$(CONFIG_RADIO_RTRACK) += radio-aimslab.o
 obj-$(CONFIG_RADIO_ZOLTRIX) += radio-zoltrix.o
 obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
-obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
-obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
 obj-$(CONFIG_RADIO_SI476X) += radio-si476x.o
 obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) += si470x/
+obj-$(CONFIG_RADIO_SI4713) += si4713/
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
 obj-$(CONFIG_USB_KEENE) += radio-keene.o
 obj-$(CONFIG_USB_MA901) += radio-ma901.o
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
deleted file mode 100644
index ba4cfc9..0000000
--- a/drivers/media/radio/radio-si4713.c
+++ /dev/null
@@ -1,246 +0,0 @@
-/*
- * drivers/media/radio/radio-si4713.c
- *
- * Platform Driver for Silicon Labs Si4713 FM Radio Transmitter:
- *
- * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
- * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/i2c.h>
-#include <linux/videodev2.h>
-#include <linux/slab.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-event.h>
-#include <media/radio-si4713.h>
-
-/* module parameters */
-static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
-module_param(radio_nr, int, 0);
-MODULE_PARM_DESC(radio_nr,
-		 "Minor number for radio device (-1 ==> auto assign)");
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
-MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
-MODULE_VERSION("0.0.1");
-MODULE_ALIAS("platform:radio-si4713");
-
-/* Driver state struct */
-struct radio_si4713_device {
-	struct v4l2_device		v4l2_dev;
-	struct video_device		radio_dev;
-	struct mutex lock;
-};
-
-/* radio_si4713_fops - file operations interface */
-static const struct v4l2_file_operations radio_si4713_fops = {
-	.owner		= THIS_MODULE,
-	.open = v4l2_fh_open,
-	.release = v4l2_fh_release,
-	.poll = v4l2_ctrl_poll,
-	/* Note: locking is done at the subdev level in the i2c driver. */
-	.unlocked_ioctl	= video_ioctl2,
-};
-
-/* Video4Linux Interface */
-
-/* radio_si4713_querycap - query device capabilities */
-static int radio_si4713_querycap(struct file *file, void *priv,
-					struct v4l2_capability *capability)
-{
-	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
-	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
-		sizeof(capability->card));
-	strlcpy(capability->bus_info, "platform:radio-si4713",
-		sizeof(capability->bus_info));
-	capability->device_caps = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
-	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
-
-	return 0;
-}
-
-/*
- * v4l2 ioctl call backs.
- * we are just a wrapper for v4l2_sub_devs.
- */
-static inline struct v4l2_device *get_v4l2_dev(struct file *file)
-{
-	return &((struct radio_si4713_device *)video_drvdata(file))->v4l2_dev;
-}
-
-static int radio_si4713_g_modulator(struct file *file, void *p,
-				    struct v4l2_modulator *vm)
-{
-	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-					  g_modulator, vm);
-}
-
-static int radio_si4713_s_modulator(struct file *file, void *p,
-				    const struct v4l2_modulator *vm)
-{
-	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-					  s_modulator, vm);
-}
-
-static int radio_si4713_g_frequency(struct file *file, void *p,
-				    struct v4l2_frequency *vf)
-{
-	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-					  g_frequency, vf);
-}
-
-static int radio_si4713_s_frequency(struct file *file, void *p,
-				    const struct v4l2_frequency *vf)
-{
-	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-					  s_frequency, vf);
-}
-
-static long radio_si4713_default(struct file *file, void *p,
-				 bool valid_prio, unsigned int cmd, void *arg)
-{
-	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-					  ioctl, cmd, arg);
-}
-
-static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
-	.vidioc_querycap	= radio_si4713_querycap,
-	.vidioc_g_modulator	= radio_si4713_g_modulator,
-	.vidioc_s_modulator	= radio_si4713_s_modulator,
-	.vidioc_g_frequency	= radio_si4713_g_frequency,
-	.vidioc_s_frequency	= radio_si4713_s_frequency,
-	.vidioc_log_status      = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-	.vidioc_default		= radio_si4713_default,
-};
-
-/* radio_si4713_vdev_template - video device interface */
-static struct video_device radio_si4713_vdev_template = {
-	.fops			= &radio_si4713_fops,
-	.name			= "radio-si4713",
-	.release		= video_device_release_empty,
-	.ioctl_ops		= &radio_si4713_ioctl_ops,
-	.vfl_dir		= VFL_DIR_TX,
-};
-
-/* Platform driver interface */
-/* radio_si4713_pdriver_probe - probe for the device */
-static int radio_si4713_pdriver_probe(struct platform_device *pdev)
-{
-	struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
-	struct radio_si4713_device *rsdev;
-	struct i2c_adapter *adapter;
-	struct v4l2_subdev *sd;
-	int rval = 0;
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "Cannot proceed without platform data.\n");
-		rval = -EINVAL;
-		goto exit;
-	}
-
-	rsdev = devm_kzalloc(&pdev->dev, sizeof(*rsdev), GFP_KERNEL);
-	if (!rsdev) {
-		dev_err(&pdev->dev, "Failed to alloc video device.\n");
-		rval = -ENOMEM;
-		goto exit;
-	}
-	mutex_init(&rsdev->lock);
-
-	rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
-	if (rval) {
-		dev_err(&pdev->dev, "Failed to register v4l2 device.\n");
-		goto exit;
-	}
-
-	adapter = i2c_get_adapter(pdata->i2c_bus);
-	if (!adapter) {
-		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
-			pdata->i2c_bus);
-		rval = -ENODEV;
-		goto unregister_v4l2_dev;
-	}
-
-	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
-				       pdata->subdev_board_info, NULL);
-	if (!sd) {
-		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
-		rval = -ENODEV;
-		goto put_adapter;
-	}
-
-	rsdev->radio_dev = radio_si4713_vdev_template;
-	rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
-	rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
-	set_bit(V4L2_FL_USE_FH_PRIO, &rsdev->radio_dev.flags);
-	/* Serialize all access to the si4713 */
-	rsdev->radio_dev.lock = &rsdev->lock;
-	video_set_drvdata(&rsdev->radio_dev, rsdev);
-	if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
-		dev_err(&pdev->dev, "Could not register video device.\n");
-		rval = -EIO;
-		goto put_adapter;
-	}
-	dev_info(&pdev->dev, "New device successfully probed\n");
-
-	goto exit;
-
-put_adapter:
-	i2c_put_adapter(adapter);
-unregister_v4l2_dev:
-	v4l2_device_unregister(&rsdev->v4l2_dev);
-exit:
-	return rval;
-}
-
-/* radio_si4713_pdriver_remove - remove the device */
-static int radio_si4713_pdriver_remove(struct platform_device *pdev)
-{
-	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
-	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
-					    struct v4l2_subdev, list);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct radio_si4713_device *rsdev;
-
-	rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
-	video_unregister_device(&rsdev->radio_dev);
-	i2c_put_adapter(client->adapter);
-	v4l2_device_unregister(&rsdev->v4l2_dev);
-
-	return 0;
-}
-
-static struct platform_driver radio_si4713_pdriver = {
-	.driver		= {
-		.name	= "radio-si4713",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= radio_si4713_pdriver_probe,
-	.remove         = radio_si4713_pdriver_remove,
-};
-
-module_platform_driver(radio_si4713_pdriver);
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
deleted file mode 100644
index fe16088..0000000
--- a/drivers/media/radio/si4713-i2c.c
+++ /dev/null
@@ -1,1532 +0,0 @@
-/*
- * drivers/media/radio/si4713-i2c.c
- *
- * Silicon Labs Si4713 FM Radio Transmitter I2C commands.
- *
- * Copyright (c) 2009 Nokia Corporation
- * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#include <linux/completion.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/i2c.h>
-#include <linux/slab.h>
-#include <linux/gpio.h>
-#include <linux/regulator/consumer.h>
-#include <linux/module.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-common.h>
-
-#include "si4713-i2c.h"
-
-/* module parameters */
-static int debug;
-module_param(debug, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Debug level (0 - 2)");
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
-MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
-MODULE_VERSION("0.0.1");
-
-static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
-	"vio",
-	"vdd",
-};
-
-#define DEFAULT_RDS_PI			0x00
-#define DEFAULT_RDS_PTY			0x00
-#define DEFAULT_RDS_DEVIATION		0x00C8
-#define DEFAULT_RDS_PS_REPEAT_COUNT	0x0003
-#define DEFAULT_LIMITER_RTIME		0x1392
-#define DEFAULT_LIMITER_DEV		0x102CA
-#define DEFAULT_PILOT_FREQUENCY 	0x4A38
-#define DEFAULT_PILOT_DEVIATION		0x1A5E
-#define DEFAULT_ACOMP_ATIME		0x0000
-#define DEFAULT_ACOMP_RTIME		0xF4240L
-#define DEFAULT_ACOMP_GAIN		0x0F
-#define DEFAULT_ACOMP_THRESHOLD 	(-0x28)
-#define DEFAULT_MUTE			0x01
-#define DEFAULT_POWER_LEVEL		88
-#define DEFAULT_FREQUENCY		8800
-#define DEFAULT_PREEMPHASIS		FMPE_EU
-#define DEFAULT_TUNE_RNL		0xFF
-
-#define to_si4713_device(sd)	container_of(sd, struct si4713_device, sd)
-
-/* frequency domain transformation (using times 10 to avoid floats) */
-#define FREQDEV_UNIT	100000
-#define FREQV4L2_MULTI	625
-#define si4713_to_v4l2(f)	((f * FREQDEV_UNIT) / FREQV4L2_MULTI)
-#define v4l2_to_si4713(f)	((f * FREQV4L2_MULTI) / FREQDEV_UNIT)
-#define FREQ_RANGE_LOW			7600
-#define FREQ_RANGE_HIGH			10800
-
-#define MAX_ARGS 7
-
-#define RDS_BLOCK			8
-#define RDS_BLOCK_CLEAR			0x03
-#define RDS_BLOCK_LOAD			0x04
-#define RDS_RADIOTEXT_2A		0x20
-#define RDS_RADIOTEXT_BLK_SIZE		4
-#define RDS_RADIOTEXT_INDEX_MAX		0x0F
-#define RDS_CARRIAGE_RETURN		0x0D
-
-#define rds_ps_nblocks(len)	((len / RDS_BLOCK) + (len % RDS_BLOCK ? 1 : 0))
-
-#define get_status_bit(p, b, m)	(((p) & (m)) >> (b))
-#define set_bits(p, v, b, m)	(((p) & ~(m)) | ((v) << (b)))
-
-#define ATTACK_TIME_UNIT	500
-
-#define POWER_OFF			0x00
-#define POWER_ON			0x01
-
-#define msb(x)                  ((u8)((u16) x >> 8))
-#define lsb(x)                  ((u8)((u16) x &  0x00FF))
-#define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
-#define check_command_failed(status)	(!(status & SI4713_CTS) || \
-					(status & SI4713_ERR))
-/* mute definition */
-#define set_mute(p)	((p & 1) | ((p & 1) << 1));
-
-#ifdef DEBUG
-#define DBG_BUFFER(device, message, buffer, size)			\
-	{								\
-		int i;							\
-		char str[(size)*5];					\
-		for (i = 0; i < size; i++)				\
-			sprintf(str + i * 5, " 0x%02x", buffer[i]);	\
-		v4l2_dbg(2, debug, device, "%s:%s\n", message, str);	\
-	}
-#else
-#define DBG_BUFFER(device, message, buffer, size)
-#endif
-
-/*
- * Values for limiter release time (sorted by second column)
- *	device	release
- *	value	time (us)
- */
-static long limiter_times[] = {
-	2000,	250,
-	1000,	500,
-	510,	1000,
-	255,	2000,
-	170,	3000,
-	127,	4020,
-	102,	5010,
-	85,	6020,
-	73,	7010,
-	64,	7990,
-	57,	8970,
-	51,	10030,
-	25,	20470,
-	17,	30110,
-	13,	39380,
-	10,	51190,
-	8,	63690,
-	7,	73140,
-	6,	85330,
-	5,	102390,
-};
-
-/*
- * Values for audio compression release time (sorted by second column)
- *	device	release
- *	value	time (us)
- */
-static unsigned long acomp_rtimes[] = {
-	0,	100000,
-	1,	200000,
-	2,	350000,
-	3,	525000,
-	4,	1000000,
-};
-
-/*
- * Values for preemphasis (sorted by second column)
- *	device	preemphasis
- *	value	value (v4l2)
- */
-static unsigned long preemphasis_values[] = {
-	FMPE_DISABLED,	V4L2_PREEMPHASIS_DISABLED,
-	FMPE_EU,	V4L2_PREEMPHASIS_50_uS,
-	FMPE_USA,	V4L2_PREEMPHASIS_75_uS,
-};
-
-static int usecs_to_dev(unsigned long usecs, unsigned long const array[],
-			int size)
-{
-	int i;
-	int rval = -EINVAL;
-
-	for (i = 0; i < size / 2; i++)
-		if (array[(i * 2) + 1] >= usecs) {
-			rval = array[i * 2];
-			break;
-		}
-
-	return rval;
-}
-
-/* si4713_handler: IRQ handler, just complete work */
-static irqreturn_t si4713_handler(int irq, void *dev)
-{
-	struct si4713_device *sdev = dev;
-
-	v4l2_dbg(2, debug, &sdev->sd,
-			"%s: sending signal to completion work.\n", __func__);
-	complete(&sdev->work);
-
-	return IRQ_HANDLED;
-}
-
-/*
- * si4713_send_command - sends a command to si4713 and waits its response
- * @sdev: si4713_device structure for the device we are communicating
- * @command: command id
- * @args: command arguments we are sending (up to 7)
- * @argn: actual size of @args
- * @response: buffer to place the expected response from the device (up to 15)
- * @respn: actual size of @response
- * @usecs: amount of time to wait before reading the response (in usecs)
- */
-static int si4713_send_command(struct si4713_device *sdev, const u8 command,
-				const u8 args[], const int argn,
-				u8 response[], const int respn, const int usecs)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
-	u8 data1[MAX_ARGS + 1];
-	int err;
-
-	if (!client->adapter)
-		return -ENODEV;
-
-	/* First send the command and its arguments */
-	data1[0] = command;
-	memcpy(data1 + 1, args, argn);
-	DBG_BUFFER(&sdev->sd, "Parameters", data1, argn + 1);
-
-	err = i2c_master_send(client, data1, argn + 1);
-	if (err != argn + 1) {
-		v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
-			command);
-		return (err > 0) ? -EIO : err;
-	}
-
-	/* Wait response from interrupt */
-	if (!wait_for_completion_timeout(&sdev->work,
-				usecs_to_jiffies(usecs) + 1))
-		v4l2_warn(&sdev->sd,
-				"(%s) Device took too much time to answer.\n",
-				__func__);
-
-	/* Then get the response */
-	err = i2c_master_recv(client, response, respn);
-	if (err != respn) {
-		v4l2_err(&sdev->sd,
-			"Error while reading response for command 0x%02x\n",
-			command);
-		return (err > 0) ? -EIO : err;
-	}
-
-	DBG_BUFFER(&sdev->sd, "Response", response, respn);
-	if (check_command_failed(response[0]))
-		return -EBUSY;
-
-	return 0;
-}
-
-/*
- * si4713_read_property - reads a si4713 property
- * @sdev: si4713_device structure for the device we are communicating
- * @prop: property identification number
- * @pv: property value to be returned on success
- */
-static int si4713_read_property(struct si4713_device *sdev, u16 prop, u32 *pv)
-{
-	int err;
-	u8 val[SI4713_GET_PROP_NRESP];
-	/*
-	 * 	.First byte = 0
-	 * 	.Second byte = property's MSB
-	 * 	.Third byte = property's LSB
-	 */
-	const u8 args[SI4713_GET_PROP_NARGS] = {
-		0x00,
-		msb(prop),
-		lsb(prop),
-	};
-
-	err = si4713_send_command(sdev, SI4713_CMD_GET_PROPERTY,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		return err;
-
-	*pv = compose_u16(val[2], val[3]);
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: property=0x%02x value=0x%02x status=0x%02x\n",
-			__func__, prop, *pv, val[0]);
-
-	return err;
-}
-
-/*
- * si4713_write_property - modifies a si4713 property
- * @sdev: si4713_device structure for the device we are communicating
- * @prop: property identification number
- * @val: new value for that property
- */
-static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
-{
-	int rval;
-	u8 resp[SI4713_SET_PROP_NRESP];
-	/*
-	 * 	.First byte = 0
-	 * 	.Second byte = property's MSB
-	 * 	.Third byte = property's LSB
-	 * 	.Fourth byte = value's MSB
-	 * 	.Fifth byte = value's LSB
-	 */
-	const u8 args[SI4713_SET_PROP_NARGS] = {
-		0x00,
-		msb(prop),
-		lsb(prop),
-		msb(val),
-		lsb(val),
-	};
-
-	rval = si4713_send_command(sdev, SI4713_CMD_SET_PROPERTY,
-					args, ARRAY_SIZE(args),
-					resp, ARRAY_SIZE(resp),
-					DEFAULT_TIMEOUT);
-
-	if (rval < 0)
-		return rval;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: property=0x%02x value=0x%02x status=0x%02x\n",
-			__func__, prop, val, resp[0]);
-
-	/*
-	 * As there is no command response for SET_PROPERTY,
-	 * wait Tcomp time to finish before proceed, in order
-	 * to have property properly set.
-	 */
-	msleep(TIMEOUT_SET_PROPERTY);
-
-	return rval;
-}
-
-/*
- * si4713_powerup - Powers the device up
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_powerup(struct si4713_device *sdev)
-{
-	int err;
-	u8 resp[SI4713_PWUP_NRESP];
-	/*
-	 * 	.First byte = Enabled interrupts and boot function
-	 * 	.Second byte = Input operation mode
-	 */
-	const u8 args[SI4713_PWUP_NARGS] = {
-		SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
-		SI4713_PWUP_OPMOD_ANALOG,
-	};
-
-	if (sdev->power_state)
-		return 0;
-
-	err = regulator_bulk_enable(ARRAY_SIZE(sdev->supplies),
-				    sdev->supplies);
-	if (err) {
-		v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
-		return err;
-	}
-	if (gpio_is_valid(sdev->gpio_reset)) {
-		udelay(50);
-		gpio_set_value(sdev->gpio_reset, 1);
-	}
-
-	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
-					args, ARRAY_SIZE(args),
-					resp, ARRAY_SIZE(resp),
-					TIMEOUT_POWER_UP);
-
-	if (!err) {
-		v4l2_dbg(1, debug, &sdev->sd, "Powerup response: 0x%02x\n",
-				resp[0]);
-		v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
-		sdev->power_state = POWER_ON;
-
-		err = si4713_write_property(sdev, SI4713_GPO_IEN,
-						SI4713_STC_INT | SI4713_CTS);
-	} else {
-		if (gpio_is_valid(sdev->gpio_reset))
-			gpio_set_value(sdev->gpio_reset, 0);
-		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
-					     sdev->supplies);
-		if (err)
-			v4l2_err(&sdev->sd,
-				 "Failed to disable supplies: %d\n", err);
-	}
-
-	return err;
-}
-
-/*
- * si4713_powerdown - Powers the device down
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_powerdown(struct si4713_device *sdev)
-{
-	int err;
-	u8 resp[SI4713_PWDN_NRESP];
-
-	if (!sdev->power_state)
-		return 0;
-
-	err = si4713_send_command(sdev, SI4713_CMD_POWER_DOWN,
-					NULL, 0,
-					resp, ARRAY_SIZE(resp),
-					DEFAULT_TIMEOUT);
-
-	if (!err) {
-		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
-				resp[0]);
-		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		if (gpio_is_valid(sdev->gpio_reset))
-			gpio_set_value(sdev->gpio_reset, 0);
-		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
-					     sdev->supplies);
-		if (err)
-			v4l2_err(&sdev->sd,
-				 "Failed to disable supplies: %d\n", err);
-		sdev->power_state = POWER_OFF;
-	}
-
-	return err;
-}
-
-/*
- * si4713_checkrev - Checks if we are treating a device with the correct rev.
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_checkrev(struct si4713_device *sdev)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
-	int rval;
-	u8 resp[SI4713_GETREV_NRESP];
-
-	rval = si4713_send_command(sdev, SI4713_CMD_GET_REV,
-					NULL, 0,
-					resp, ARRAY_SIZE(resp),
-					DEFAULT_TIMEOUT);
-
-	if (rval < 0)
-		return rval;
-
-	if (resp[1] == SI4713_PRODUCT_NUMBER) {
-		v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
-				client->addr << 1, client->adapter->name);
-	} else {
-		v4l2_err(&sdev->sd, "Invalid product number\n");
-		rval = -EINVAL;
-	}
-	return rval;
-}
-
-/*
- * si4713_wait_stc - Waits STC interrupt and clears status bits. Useful
- *		     for TX_TUNE_POWER, TX_TUNE_FREQ and TX_TUNE_MEAS
- * @sdev: si4713_device structure for the device we are communicating
- * @usecs: timeout to wait for STC interrupt signal
- */
-static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
-{
-	int err;
-	u8 resp[SI4713_GET_STATUS_NRESP];
-
-	/* Wait response from STC interrupt */
-	if (!wait_for_completion_timeout(&sdev->work,
-			usecs_to_jiffies(usecs) + 1))
-		v4l2_warn(&sdev->sd,
-			"%s: device took too much time to answer (%d usec).\n",
-				__func__, usecs);
-
-	/* Clear status bits */
-	err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
-					NULL, 0,
-					resp, ARRAY_SIZE(resp),
-					DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		goto exit;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: status bits: 0x%02x\n", __func__, resp[0]);
-
-	if (!(resp[0] & SI4713_STC_INT))
-		err = -EIO;
-
-exit:
-	return err;
-}
-
-/*
- * si4713_tx_tune_freq - Sets the state of the RF carrier and sets the tuning
- * 			frequency between 76 and 108 MHz in 10 kHz units and
- * 			steps of 50 kHz.
- * @sdev: si4713_device structure for the device we are communicating
- * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
- */
-static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
-{
-	int err;
-	u8 val[SI4713_TXFREQ_NRESP];
-	/*
-	 * 	.First byte = 0
-	 * 	.Second byte = frequency's MSB
-	 * 	.Third byte = frequency's LSB
-	 */
-	const u8 args[SI4713_TXFREQ_NARGS] = {
-		0x00,
-		msb(frequency),
-		lsb(frequency),
-	};
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_FREQ,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		return err;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: frequency=0x%02x status=0x%02x\n", __func__,
-			frequency, val[0]);
-
-	err = si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
-	if (err < 0)
-		return err;
-
-	return compose_u16(args[1], args[2]);
-}
-
-/*
- * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
- * 			1 dB units. A value of 0x00 indicates off. The command
- * 			also sets the antenna tuning capacitance. A value of 0
- * 			indicates autotuning, and a value of 1 - 191 indicates
- * 			a manual override, which results in a tuning
- * 			capacitance of 0.25 pF x @antcap.
- * @sdev: si4713_device structure for the device we are communicating
- * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
- * @antcap: value of antenna tuning capacitor (0 - 191)
- */
-static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
-				u8 antcap)
-{
-	int err;
-	u8 val[SI4713_TXPWR_NRESP];
-	/*
-	 * 	.First byte = 0
-	 * 	.Second byte = 0
-	 * 	.Third byte = power
-	 * 	.Fourth byte = antcap
-	 */
-	const u8 args[SI4713_TXPWR_NARGS] = {
-		0x00,
-		0x00,
-		power,
-		antcap,
-	};
-
-	if (((power > 0) && (power < SI4713_MIN_POWER)) ||
-		power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
-		return -EDOM;
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_POWER,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		return err;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: power=0x%02x antcap=0x%02x status=0x%02x\n",
-			__func__, power, antcap, val[0]);
-
-	return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE_POWER);
-}
-
-/*
- * si4713_tx_tune_measure - Enters receive mode and measures the received noise
- * 			level in units of dBuV on the selected frequency.
- * 			The Frequency must be between 76 and 108 MHz in 10 kHz
- * 			units and steps of 50 kHz. The command also sets the
- * 			antenna	tuning capacitance. A value of 0 means
- * 			autotuning, and a value of 1 to 191 indicates manual
- * 			override.
- * @sdev: si4713_device structure for the device we are communicating
- * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
- * @antcap: value of antenna tuning capacitor (0 - 191)
- */
-static int si4713_tx_tune_measure(struct si4713_device *sdev, u16 frequency,
-					u8 antcap)
-{
-	int err;
-	u8 val[SI4713_TXMEA_NRESP];
-	/*
-	 * 	.First byte = 0
-	 * 	.Second byte = frequency's MSB
-	 * 	.Third byte = frequency's LSB
-	 * 	.Fourth byte = antcap
-	 */
-	const u8 args[SI4713_TXMEA_NARGS] = {
-		0x00,
-		msb(frequency),
-		lsb(frequency),
-		antcap,
-	};
-
-	sdev->tune_rnl = DEFAULT_TUNE_RNL;
-
-	if (antcap > SI4713_MAX_ANTCAP)
-		return -EDOM;
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_MEASURE,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		return err;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: frequency=0x%02x antcap=0x%02x status=0x%02x\n",
-			__func__, frequency, antcap, val[0]);
-
-	return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
-}
-
-/*
- * si4713_tx_tune_status- Returns the status of the tx_tune_freq, tx_tune_mea or
- * 			tx_tune_power commands. This command return the current
- * 			frequency, output voltage in dBuV, the antenna tunning
- * 			capacitance value and the received noise level. The
- * 			command also clears the stcint interrupt bit when the
- * 			first bit of its arguments is high.
- * @sdev: si4713_device structure for the device we are communicating
- * @intack: 0x01 to clear the seek/tune complete interrupt status indicator.
- * @frequency: returned frequency
- * @power: returned power
- * @antcap: returned antenna capacitance
- * @noise: returned noise level
- */
-static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
-					u16 *frequency,	u8 *power,
-					u8 *antcap, u8 *noise)
-{
-	int err;
-	u8 val[SI4713_TXSTATUS_NRESP];
-	/*
-	 * 	.First byte = intack bit
-	 */
-	const u8 args[SI4713_TXSTATUS_NARGS] = {
-		intack & SI4713_INTACK_MASK,
-	};
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_STATUS,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (!err) {
-		v4l2_dbg(1, debug, &sdev->sd,
-			"%s: status=0x%02x\n", __func__, val[0]);
-		*frequency = compose_u16(val[2], val[3]);
-		sdev->frequency = *frequency;
-		*power = val[5];
-		*antcap = val[6];
-		*noise = val[7];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
-				"(power %d, antcap %d, rnl %d)\n", __func__,
-				*frequency, *power, *antcap, *noise);
-	}
-
-	return err;
-}
-
-/*
- * si4713_tx_rds_buff - Loads the RDS group buffer FIFO or circular buffer.
- * @sdev: si4713_device structure for the device we are communicating
- * @mode: the buffer operation mode.
- * @rdsb: RDS Block B
- * @rdsc: RDS Block C
- * @rdsd: RDS Block D
- * @cbleft: returns the number of available circular buffer blocks minus the
- *          number of used circular buffer blocks.
- */
-static int si4713_tx_rds_buff(struct si4713_device *sdev, u8 mode, u16 rdsb,
-				u16 rdsc, u16 rdsd, s8 *cbleft)
-{
-	int err;
-	u8 val[SI4713_RDSBUFF_NRESP];
-
-	const u8 args[SI4713_RDSBUFF_NARGS] = {
-		mode & SI4713_RDSBUFF_MODE_MASK,
-		msb(rdsb),
-		lsb(rdsb),
-		msb(rdsc),
-		lsb(rdsc),
-		msb(rdsd),
-		lsb(rdsd),
-	};
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_BUFF,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (!err) {
-		v4l2_dbg(1, debug, &sdev->sd,
-			"%s: status=0x%02x\n", __func__, val[0]);
-		*cbleft = (s8)val[2] - val[3];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
-				" 0x%02x cb avail: %d cb used %d fifo avail"
-				" %d fifo used %d\n", __func__, val[1],
-				val[2], val[3], val[4], val[5]);
-	}
-
-	return err;
-}
-
-/*
- * si4713_tx_rds_ps - Loads the program service buffer.
- * @sdev: si4713_device structure for the device we are communicating
- * @psid: program service id to be loaded.
- * @pschar: assumed 4 size char array to be loaded into the program service
- */
-static int si4713_tx_rds_ps(struct si4713_device *sdev, u8 psid,
-				unsigned char *pschar)
-{
-	int err;
-	u8 val[SI4713_RDSPS_NRESP];
-
-	const u8 args[SI4713_RDSPS_NARGS] = {
-		psid & SI4713_RDSPS_PSID_MASK,
-		pschar[0],
-		pschar[1],
-		pschar[2],
-		pschar[3],
-	};
-
-	err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_PS,
-				  args, ARRAY_SIZE(args), val,
-				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		return err;
-
-	v4l2_dbg(1, debug, &sdev->sd, "%s: status=0x%02x\n", __func__, val[0]);
-
-	return err;
-}
-
-static int si4713_set_power_state(struct si4713_device *sdev, u8 value)
-{
-	if (value)
-		return si4713_powerup(sdev);
-	return si4713_powerdown(sdev);
-}
-
-static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
-{
-	int rval = 0;
-
-	mute = set_mute(mute);
-
-	if (sdev->power_state)
-		rval = si4713_write_property(sdev,
-				SI4713_TX_LINE_INPUT_MUTE, mute);
-
-	return rval;
-}
-
-static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
-{
-	int rval = 0, i;
-	u8 len = 0;
-
-	/* We want to clear the whole thing */
-	if (!strlen(ps_name))
-		memset(ps_name, 0, MAX_RDS_PS_NAME + 1);
-
-	if (sdev->power_state) {
-		/* Write the new ps name and clear the padding */
-		for (i = 0; i < MAX_RDS_PS_NAME; i += (RDS_BLOCK / 2)) {
-			rval = si4713_tx_rds_ps(sdev, (i / (RDS_BLOCK / 2)),
-						ps_name + i);
-			if (rval < 0)
-				return rval;
-		}
-
-		/* Setup the size to be sent */
-		if (strlen(ps_name))
-			len = strlen(ps_name) - 1;
-		else
-			len = 1;
-
-		rval = si4713_write_property(sdev,
-				SI4713_TX_RDS_PS_MESSAGE_COUNT,
-				rds_ps_nblocks(len));
-		if (rval < 0)
-			return rval;
-
-		rval = si4713_write_property(sdev,
-				SI4713_TX_RDS_PS_REPEAT_COUNT,
-				DEFAULT_RDS_PS_REPEAT_COUNT * 2);
-		if (rval < 0)
-			return rval;
-	}
-
-	return rval;
-}
-
-static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
-{
-	int rval = 0, i;
-	u16 t_index = 0;
-	u8 b_index = 0, cr_inserted = 0;
-	s8 left;
-
-	if (!sdev->power_state)
-		return rval;
-
-	rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_CLEAR, 0, 0, 0, &left);
-	if (rval < 0)
-		return rval;
-
-	if (!strlen(rt))
-		return rval;
-
-	do {
-		/* RDS spec says that if the last block isn't used,
-		 * then apply a carriage return
-		 */
-		if (t_index < (RDS_RADIOTEXT_INDEX_MAX * RDS_RADIOTEXT_BLK_SIZE)) {
-			for (i = 0; i < RDS_RADIOTEXT_BLK_SIZE; i++) {
-				if (!rt[t_index + i] ||
-				    rt[t_index + i] == RDS_CARRIAGE_RETURN) {
-					rt[t_index + i] = RDS_CARRIAGE_RETURN;
-					cr_inserted = 1;
-					break;
-				}
-			}
-		}
-
-		rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_LOAD,
-				compose_u16(RDS_RADIOTEXT_2A, b_index++),
-				compose_u16(rt[t_index], rt[t_index + 1]),
-				compose_u16(rt[t_index + 2], rt[t_index + 3]),
-				&left);
-		if (rval < 0)
-			return rval;
-
-		t_index += RDS_RADIOTEXT_BLK_SIZE;
-
-		if (cr_inserted)
-			break;
-	} while (left > 0);
-
-	return rval;
-}
-
-/*
- * si4713_update_tune_status - update properties from tx_tune_status
- * command. Must be called with sdev->mutex held.
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_update_tune_status(struct si4713_device *sdev)
-{
-	int rval;
-	u16 f = 0;
-	u8 p = 0, a = 0, n = 0;
-
-	rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
-
-	if (rval < 0)
-		goto exit;
-
-/*	TODO: check that power_level and antenna_capacitor really are not
-	changed by the hardware. If they are, then these controls should become
-	volatiles.
-	sdev->power_level = p;
-	sdev->antenna_capacitor = a;*/
-	sdev->tune_rnl = n;
-
-exit:
-	return rval;
-}
-
-static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
-		s32 *bit, s32 *mask, u16 *property, int *mul,
-		unsigned long **table, int *size)
-{
-	s32 rval = 0;
-
-	switch (id) {
-	/* FM_TX class controls */
-	case V4L2_CID_RDS_TX_PI:
-		*property = SI4713_TX_RDS_PI;
-		*mul = 1;
-		break;
-	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
-		*property = SI4713_TX_ACOMP_THRESHOLD;
-		*mul = 1;
-		break;
-	case V4L2_CID_AUDIO_COMPRESSION_GAIN:
-		*property = SI4713_TX_ACOMP_GAIN;
-		*mul = 1;
-		break;
-	case V4L2_CID_PILOT_TONE_FREQUENCY:
-		*property = SI4713_TX_PILOT_FREQUENCY;
-		*mul = 1;
-		break;
-	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
-		*property = SI4713_TX_ACOMP_ATTACK_TIME;
-		*mul = ATTACK_TIME_UNIT;
-		break;
-	case V4L2_CID_PILOT_TONE_DEVIATION:
-		*property = SI4713_TX_PILOT_DEVIATION;
-		*mul = 10;
-		break;
-	case V4L2_CID_AUDIO_LIMITER_DEVIATION:
-		*property = SI4713_TX_AUDIO_DEVIATION;
-		*mul = 10;
-		break;
-	case V4L2_CID_RDS_TX_DEVIATION:
-		*property = SI4713_TX_RDS_DEVIATION;
-		*mul = 1;
-		break;
-
-	case V4L2_CID_RDS_TX_PTY:
-		*property = SI4713_TX_RDS_PS_MISC;
-		*bit = 5;
-		*mask = 0x1F << 5;
-		break;
-	case V4L2_CID_AUDIO_LIMITER_ENABLED:
-		*property = SI4713_TX_ACOMP_ENABLE;
-		*bit = 1;
-		*mask = 1 << 1;
-		break;
-	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
-		*property = SI4713_TX_ACOMP_ENABLE;
-		*bit = 0;
-		*mask = 1 << 0;
-		break;
-	case V4L2_CID_PILOT_TONE_ENABLED:
-		*property = SI4713_TX_COMPONENT_ENABLE;
-		*bit = 0;
-		*mask = 1 << 0;
-		break;
-
-	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
-		*property = SI4713_TX_LIMITER_RELEASE_TIME;
-		*table = limiter_times;
-		*size = ARRAY_SIZE(limiter_times);
-		break;
-	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
-		*property = SI4713_TX_ACOMP_RELEASE_TIME;
-		*table = acomp_rtimes;
-		*size = ARRAY_SIZE(acomp_rtimes);
-		break;
-	case V4L2_CID_TUNE_PREEMPHASIS:
-		*property = SI4713_TX_PREEMPHASIS;
-		*table = preemphasis_values;
-		*size = ARRAY_SIZE(preemphasis_values);
-		break;
-
-	default:
-		rval = -EINVAL;
-		break;
-	}
-
-	return rval;
-}
-
-static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f);
-static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *);
-/*
- * si4713_setup - Sets the device up with current configuration.
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_setup(struct si4713_device *sdev)
-{
-	struct v4l2_frequency f;
-	struct v4l2_modulator vm;
-	int rval;
-
-	/* Device procedure needs to set frequency first */
-	f.tuner = 0;
-	f.frequency = sdev->frequency ? sdev->frequency : DEFAULT_FREQUENCY;
-	f.frequency = si4713_to_v4l2(f.frequency);
-	rval = si4713_s_frequency(&sdev->sd, &f);
-
-	vm.index = 0;
-	if (sdev->stereo)
-		vm.txsubchans = V4L2_TUNER_SUB_STEREO;
-	else
-		vm.txsubchans = V4L2_TUNER_SUB_MONO;
-	if (sdev->rds_enabled)
-		vm.txsubchans |= V4L2_TUNER_SUB_RDS;
-	si4713_s_modulator(&sdev->sd, &vm);
-
-	return rval;
-}
-
-/*
- * si4713_initialize - Sets the device up with default configuration.
- * @sdev: si4713_device structure for the device we are communicating
- */
-static int si4713_initialize(struct si4713_device *sdev)
-{
-	int rval;
-
-	rval = si4713_set_power_state(sdev, POWER_ON);
-	if (rval < 0)
-		return rval;
-
-	rval = si4713_checkrev(sdev);
-	if (rval < 0)
-		return rval;
-
-	rval = si4713_set_power_state(sdev, POWER_OFF);
-	if (rval < 0)
-		return rval;
-
-
-	sdev->frequency = DEFAULT_FREQUENCY;
-	sdev->stereo = 1;
-	sdev->tune_rnl = DEFAULT_TUNE_RNL;
-	return 0;
-}
-
-/* si4713_s_ctrl - set the value of a control */
-static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct si4713_device *sdev =
-		container_of(ctrl->handler, struct si4713_device, ctrl_handler);
-	u32 val = 0;
-	s32 bit = 0, mask = 0;
-	u16 property = 0;
-	int mul = 0;
-	unsigned long *table = NULL;
-	int size = 0;
-	bool force = false;
-	int c;
-	int ret = 0;
-
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	if (ctrl->is_new) {
-		if (ctrl->val) {
-			ret = si4713_set_mute(sdev, ctrl->val);
-			if (!ret)
-				ret = si4713_set_power_state(sdev, POWER_DOWN);
-			return ret;
-		}
-		ret = si4713_set_power_state(sdev, POWER_UP);
-		if (!ret)
-			ret = si4713_set_mute(sdev, ctrl->val);
-		if (!ret)
-			ret = si4713_setup(sdev);
-		if (ret)
-			return ret;
-		force = true;
-	}
-
-	if (!sdev->power_state)
-		return 0;
-
-	for (c = 1; !ret && c < ctrl->ncontrols; c++) {
-		ctrl = ctrl->cluster[c];
-
-		if (!force && !ctrl->is_new)
-			continue;
-
-		switch (ctrl->id) {
-		case V4L2_CID_RDS_TX_PS_NAME:
-			ret = si4713_set_rds_ps_name(sdev, ctrl->string);
-			break;
-
-		case V4L2_CID_RDS_TX_RADIO_TEXT:
-			ret = si4713_set_rds_radio_text(sdev, ctrl->string);
-			break;
-
-		case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
-			/* don't handle this control if we force setting all
-			 * controls since in that case it will be handled by
-			 * V4L2_CID_TUNE_POWER_LEVEL. */
-			if (force)
-				break;
-			/* fall through */
-		case V4L2_CID_TUNE_POWER_LEVEL:
-			ret = si4713_tx_tune_power(sdev,
-				sdev->tune_pwr_level->val, sdev->tune_ant_cap->val);
-			if (!ret) {
-				/* Make sure we don't set this twice */
-				sdev->tune_ant_cap->is_new = false;
-				sdev->tune_pwr_level->is_new = false;
-			}
-			break;
-
-		default:
-			ret = si4713_choose_econtrol_action(sdev, ctrl->id, &bit,
-					&mask, &property, &mul, &table, &size);
-			if (ret < 0)
-				break;
-
-			val = ctrl->val;
-			if (mul) {
-				val = val / mul;
-			} else if (table) {
-				ret = usecs_to_dev(val, table, size);
-				if (ret < 0)
-					break;
-				val = ret;
-				ret = 0;
-			}
-
-			if (mask) {
-				ret = si4713_read_property(sdev, property, &val);
-				if (ret < 0)
-					break;
-				val = set_bits(val, ctrl->val, bit, mask);
-			}
-
-			ret = si4713_write_property(sdev, property, val);
-			if (ret < 0)
-				break;
-			if (mask)
-				val = ctrl->val;
-			break;
-		}
-	}
-
-	return ret;
-}
-
-/* si4713_ioctl - deal with private ioctls (only rnl for now) */
-static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
-{
-	struct si4713_device *sdev = to_si4713_device(sd);
-	struct si4713_rnl *rnl = arg;
-	u16 frequency;
-	int rval = 0;
-
-	if (!arg)
-		return -EINVAL;
-
-	switch (cmd) {
-	case SI4713_IOC_MEASURE_RNL:
-		frequency = v4l2_to_si4713(rnl->frequency);
-
-		if (sdev->power_state) {
-			/* Set desired measurement frequency */
-			rval = si4713_tx_tune_measure(sdev, frequency, 0);
-			if (rval < 0)
-				return rval;
-			/* get results from tune status */
-			rval = si4713_update_tune_status(sdev);
-			if (rval < 0)
-				return rval;
-		}
-		rnl->rnl = sdev->tune_rnl;
-		break;
-
-	default:
-		/* nothing */
-		rval = -ENOIOCTLCMD;
-	}
-
-	return rval;
-}
-
-/* si4713_g_modulator - get modulator attributes */
-static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
-{
-	struct si4713_device *sdev = to_si4713_device(sd);
-	int rval = 0;
-
-	if (!sdev)
-		return -ENODEV;
-
-	if (vm->index > 0)
-		return -EINVAL;
-
-	strncpy(vm->name, "FM Modulator", 32);
-	vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
-		V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
-
-	/* Report current frequency range limits */
-	vm->rangelow = si4713_to_v4l2(FREQ_RANGE_LOW);
-	vm->rangehigh = si4713_to_v4l2(FREQ_RANGE_HIGH);
-
-	if (sdev->power_state) {
-		u32 comp_en = 0;
-
-		rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE,
-						&comp_en);
-		if (rval < 0)
-			return rval;
-
-		sdev->stereo = get_status_bit(comp_en, 1, 1 << 1);
-	}
-
-	/* Report current audio mode: mono or stereo */
-	if (sdev->stereo)
-		vm->txsubchans = V4L2_TUNER_SUB_STEREO;
-	else
-		vm->txsubchans = V4L2_TUNER_SUB_MONO;
-
-	/* Report rds feature status */
-	if (sdev->rds_enabled)
-		vm->txsubchans |= V4L2_TUNER_SUB_RDS;
-	else
-		vm->txsubchans &= ~V4L2_TUNER_SUB_RDS;
-
-	return rval;
-}
-
-/* si4713_s_modulator - set modulator attributes */
-static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *vm)
-{
-	struct si4713_device *sdev = to_si4713_device(sd);
-	int rval = 0;
-	u16 stereo, rds;
-	u32 p;
-
-	if (!sdev)
-		return -ENODEV;
-
-	if (vm->index > 0)
-		return -EINVAL;
-
-	/* Set audio mode: mono or stereo */
-	if (vm->txsubchans & V4L2_TUNER_SUB_STEREO)
-		stereo = 1;
-	else if (vm->txsubchans & V4L2_TUNER_SUB_MONO)
-		stereo = 0;
-	else
-		return -EINVAL;
-
-	rds = !!(vm->txsubchans & V4L2_TUNER_SUB_RDS);
-
-	if (sdev->power_state) {
-		rval = si4713_read_property(sdev,
-						SI4713_TX_COMPONENT_ENABLE, &p);
-		if (rval < 0)
-			return rval;
-
-		p = set_bits(p, stereo, 1, 1 << 1);
-		p = set_bits(p, rds, 2, 1 << 2);
-
-		rval = si4713_write_property(sdev,
-						SI4713_TX_COMPONENT_ENABLE, p);
-		if (rval < 0)
-			return rval;
-	}
-
-	sdev->stereo = stereo;
-	sdev->rds_enabled = rds;
-
-	return rval;
-}
-
-/* si4713_g_frequency - get tuner or modulator radio frequency */
-static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
-{
-	struct si4713_device *sdev = to_si4713_device(sd);
-	int rval = 0;
-
-	if (f->tuner)
-		return -EINVAL;
-
-	if (sdev->power_state) {
-		u16 freq;
-		u8 p, a, n;
-
-		rval = si4713_tx_tune_status(sdev, 0x00, &freq, &p, &a, &n);
-		if (rval < 0)
-			return rval;
-
-		sdev->frequency = freq;
-	}
-
-	f->frequency = si4713_to_v4l2(sdev->frequency);
-
-	return rval;
-}
-
-/* si4713_s_frequency - set tuner or modulator radio frequency */
-static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)
-{
-	struct si4713_device *sdev = to_si4713_device(sd);
-	int rval = 0;
-	u16 frequency = v4l2_to_si4713(f->frequency);
-
-	if (f->tuner)
-		return -EINVAL;
-
-	/* Check frequency range */
-	frequency = clamp_t(u16, frequency, FREQ_RANGE_LOW, FREQ_RANGE_HIGH);
-
-	if (sdev->power_state) {
-		rval = si4713_tx_tune_freq(sdev, frequency);
-		if (rval < 0)
-			return rval;
-		frequency = rval;
-		rval = 0;
-	}
-	sdev->frequency = frequency;
-
-	return rval;
-}
-
-static const struct v4l2_ctrl_ops si4713_ctrl_ops = {
-	.s_ctrl = si4713_s_ctrl,
-};
-
-static const struct v4l2_subdev_core_ops si4713_subdev_core_ops = {
-	.ioctl		= si4713_ioctl,
-};
-
-static const struct v4l2_subdev_tuner_ops si4713_subdev_tuner_ops = {
-	.g_frequency	= si4713_g_frequency,
-	.s_frequency	= si4713_s_frequency,
-	.g_modulator	= si4713_g_modulator,
-	.s_modulator	= si4713_s_modulator,
-};
-
-static const struct v4l2_subdev_ops si4713_subdev_ops = {
-	.core		= &si4713_subdev_core_ops,
-	.tuner		= &si4713_subdev_tuner_ops,
-};
-
-/*
- * I2C driver interface
- */
-/* si4713_probe - probe for the device */
-static int si4713_probe(struct i2c_client *client,
-					const struct i2c_device_id *id)
-{
-	struct si4713_device *sdev;
-	struct si4713_platform_data *pdata = client->dev.platform_data;
-	struct v4l2_ctrl_handler *hdl;
-	int rval, i;
-
-	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
-	if (!sdev) {
-		dev_err(&client->dev, "Failed to alloc video device.\n");
-		rval = -ENOMEM;
-		goto exit;
-	}
-
-	sdev->gpio_reset = -1;
-	if (pdata && gpio_is_valid(pdata->gpio_reset)) {
-		rval = gpio_request(pdata->gpio_reset, "si4713 reset");
-		if (rval) {
-			dev_err(&client->dev,
-				"Failed to request gpio: %d\n", rval);
-			goto free_sdev;
-		}
-		sdev->gpio_reset = pdata->gpio_reset;
-		gpio_direction_output(sdev->gpio_reset, 0);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(sdev->supplies); i++)
-		sdev->supplies[i].supply = si4713_supply_names[i];
-
-	rval = regulator_bulk_get(&client->dev, ARRAY_SIZE(sdev->supplies),
-				  sdev->supplies);
-	if (rval) {
-		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
-		goto free_gpio;
-	}
-
-	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
-
-	init_completion(&sdev->work);
-
-	hdl = &sdev->ctrl_handler;
-	v4l2_ctrl_handler_init(hdl, 20);
-	sdev->mute = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, DEFAULT_MUTE);
-
-	sdev->rds_pi = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_RDS_TX_PI, 0, 0xffff, 1, DEFAULT_RDS_PI);
-	sdev->rds_pty = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_RDS_TX_PTY, 0, 31, 1, DEFAULT_RDS_PTY);
-	sdev->rds_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_RDS_TX_DEVIATION, 0, MAX_RDS_DEVIATION,
-			10, DEFAULT_RDS_DEVIATION);
-	/*
-	 * Report step as 8. From RDS spec, psname
-	 * should be 8. But there are receivers which scroll strings
-	 * sized as 8xN.
-	 */
-	sdev->rds_ps_name = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_RDS_TX_PS_NAME, 0, MAX_RDS_PS_NAME, 8, 0);
-	/*
-	 * Report step as 32 (2A block). From RDS spec,
-	 * radio text should be 32 for 2A block. But there are receivers
-	 * which scroll strings sized as 32xN. Setting default to 32.
-	 */
-	sdev->rds_radio_text = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_RDS_TX_RADIO_TEXT, 0, MAX_RDS_RADIO_TEXT, 32, 0);
-
-	sdev->limiter_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_LIMITER_ENABLED, 0, 1, 1, 1);
-	sdev->limiter_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_LIMITER_RELEASE_TIME, 250,
-			MAX_LIMITER_RELEASE_TIME, 10, DEFAULT_LIMITER_RTIME);
-	sdev->limiter_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_LIMITER_DEVIATION, 0,
-			MAX_LIMITER_DEVIATION, 10, DEFAULT_LIMITER_DEV);
-
-	sdev->compression_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_COMPRESSION_ENABLED, 0, 1, 1, 1);
-	sdev->compression_gain = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_COMPRESSION_GAIN, 0, MAX_ACOMP_GAIN, 1,
-			DEFAULT_ACOMP_GAIN);
-	sdev->compression_threshold = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THRESHOLD,
-			MAX_ACOMP_THRESHOLD, 1,
-			DEFAULT_ACOMP_THRESHOLD);
-	sdev->compression_attack_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME, 0,
-			MAX_ACOMP_ATTACK_TIME, 500, DEFAULT_ACOMP_ATIME);
-	sdev->compression_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME, 100000,
-			MAX_ACOMP_RELEASE_TIME, 100000, DEFAULT_ACOMP_RTIME);
-
-	sdev->pilot_tone_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_PILOT_TONE_ENABLED, 0, 1, 1, 1);
-	sdev->pilot_tone_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_PILOT_TONE_DEVIATION, 0, MAX_PILOT_DEVIATION,
-			10, DEFAULT_PILOT_DEVIATION);
-	sdev->pilot_tone_freq = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_PILOT_TONE_FREQUENCY, 0, MAX_PILOT_FREQUENCY,
-			1, DEFAULT_PILOT_FREQUENCY);
-
-	sdev->tune_preemphasis = v4l2_ctrl_new_std_menu(hdl, &si4713_ctrl_ops,
-			V4L2_CID_TUNE_PREEMPHASIS,
-			V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
-	sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);
-	sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
-			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, 191, 1, 0);
-
-	if (hdl->error) {
-		rval = hdl->error;
-		goto free_ctrls;
-	}
-	v4l2_ctrl_cluster(20, &sdev->mute);
-	sdev->sd.ctrl_handler = hdl;
-
-	if (client->irq) {
-		rval = request_irq(client->irq,
-			si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
-			client->name, sdev);
-		if (rval < 0) {
-			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-			goto put_reg;
-		}
-		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
-	} else {
-		v4l2_warn(&sdev->sd, "IRQ not configured. Using timeouts.\n");
-	}
-
-	rval = si4713_initialize(sdev);
-	if (rval < 0) {
-		v4l2_err(&sdev->sd, "Failed to probe device information.\n");
-		goto free_irq;
-	}
-
-	return 0;
-
-free_irq:
-	if (client->irq)
-		free_irq(client->irq, sdev);
-free_ctrls:
-	v4l2_ctrl_handler_free(hdl);
-put_reg:
-	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
-free_gpio:
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
-free_sdev:
-	kfree(sdev);
-exit:
-	return rval;
-}
-
-/* si4713_remove - remove the device */
-static int si4713_remove(struct i2c_client *client)
-{
-	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct si4713_device *sdev = to_si4713_device(sd);
-
-	if (sdev->power_state)
-		si4713_set_power_state(sdev, POWER_DOWN);
-
-	if (client->irq > 0)
-		free_irq(client->irq, sdev);
-
-	v4l2_device_unregister_subdev(sd);
-	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
-	kfree(sdev);
-
-	return 0;
-}
-
-/* si4713_i2c_driver - i2c driver interface */
-static const struct i2c_device_id si4713_id[] = {
-	{ "si4713" , 0 },
-	{ },
-};
-MODULE_DEVICE_TABLE(i2c, si4713_id);
-
-static struct i2c_driver si4713_i2c_driver = {
-	.driver		= {
-		.name	= "si4713",
-	},
-	.probe		= si4713_probe,
-	.remove         = si4713_remove,
-	.id_table       = si4713_id,
-};
-
-module_i2c_driver(si4713_i2c_driver);
diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
deleted file mode 100644
index 25cdea2..0000000
--- a/drivers/media/radio/si4713-i2c.h
+++ /dev/null
@@ -1,238 +0,0 @@
-/*
- * drivers/media/radio/si4713-i2c.h
- *
- * Property and commands definitions for Si4713 radio transmitter chip.
- *
- * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
- * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- *
- */
-
-#ifndef SI4713_I2C_H
-#define SI4713_I2C_H
-
-#include <media/v4l2-subdev.h>
-#include <media/v4l2-ctrls.h>
-#include <media/si4713.h>
-
-#define SI4713_PRODUCT_NUMBER		0x0D
-
-/* Command Timeouts */
-#define DEFAULT_TIMEOUT			500
-#define TIMEOUT_SET_PROPERTY		20
-#define TIMEOUT_TX_TUNE_POWER		30000
-#define TIMEOUT_TX_TUNE			110000
-#define TIMEOUT_POWER_UP		200000
-
-/*
- * Command and its arguments definitions
- */
-#define SI4713_PWUP_CTSIEN		(1<<7)
-#define SI4713_PWUP_GPO2OEN		(1<<6)
-#define SI4713_PWUP_PATCH		(1<<5)
-#define SI4713_PWUP_XOSCEN		(1<<4)
-#define SI4713_PWUP_FUNC_TX		0x02
-#define SI4713_PWUP_FUNC_PATCH		0x0F
-#define SI4713_PWUP_OPMOD_ANALOG	0x50
-#define SI4713_PWUP_OPMOD_DIGITAL	0x0F
-#define SI4713_PWUP_NARGS		2
-#define SI4713_PWUP_NRESP		1
-#define SI4713_CMD_POWER_UP		0x01
-
-#define SI4713_GETREV_NRESP		9
-#define SI4713_CMD_GET_REV		0x10
-
-#define SI4713_PWDN_NRESP		1
-#define SI4713_CMD_POWER_DOWN		0x11
-
-#define SI4713_SET_PROP_NARGS		5
-#define SI4713_SET_PROP_NRESP		1
-#define SI4713_CMD_SET_PROPERTY		0x12
-
-#define SI4713_GET_PROP_NARGS		3
-#define SI4713_GET_PROP_NRESP		4
-#define SI4713_CMD_GET_PROPERTY		0x13
-
-#define SI4713_GET_STATUS_NRESP		1
-#define SI4713_CMD_GET_INT_STATUS	0x14
-
-#define SI4713_CMD_PATCH_ARGS		0x15
-#define SI4713_CMD_PATCH_DATA		0x16
-
-#define SI4713_MAX_FREQ			10800
-#define SI4713_MIN_FREQ			7600
-#define SI4713_TXFREQ_NARGS		3
-#define SI4713_TXFREQ_NRESP		1
-#define SI4713_CMD_TX_TUNE_FREQ		0x30
-
-#define SI4713_MAX_POWER		120
-#define SI4713_MIN_POWER		88
-#define SI4713_MAX_ANTCAP		191
-#define SI4713_MIN_ANTCAP		0
-#define SI4713_TXPWR_NARGS		4
-#define SI4713_TXPWR_NRESP		1
-#define SI4713_CMD_TX_TUNE_POWER	0x31
-
-#define SI4713_TXMEA_NARGS		4
-#define SI4713_TXMEA_NRESP		1
-#define SI4713_CMD_TX_TUNE_MEASURE	0x32
-
-#define SI4713_INTACK_MASK		0x01
-#define SI4713_TXSTATUS_NARGS		1
-#define SI4713_TXSTATUS_NRESP		8
-#define SI4713_CMD_TX_TUNE_STATUS	0x33
-
-#define SI4713_OVERMOD_BIT		(1 << 2)
-#define SI4713_IALH_BIT			(1 << 1)
-#define SI4713_IALL_BIT			(1 << 0)
-#define SI4713_ASQSTATUS_NARGS		1
-#define SI4713_ASQSTATUS_NRESP		5
-#define SI4713_CMD_TX_ASQ_STATUS	0x34
-
-#define SI4713_RDSBUFF_MODE_MASK	0x87
-#define SI4713_RDSBUFF_NARGS		7
-#define SI4713_RDSBUFF_NRESP		6
-#define SI4713_CMD_TX_RDS_BUFF		0x35
-
-#define SI4713_RDSPS_PSID_MASK		0x1F
-#define SI4713_RDSPS_NARGS		5
-#define SI4713_RDSPS_NRESP		1
-#define SI4713_CMD_TX_RDS_PS		0x36
-
-#define SI4713_CMD_GPO_CTL		0x80
-#define SI4713_CMD_GPO_SET		0x81
-
-/*
- * Bits from status response
- */
-#define SI4713_CTS			(1<<7)
-#define SI4713_ERR			(1<<6)
-#define SI4713_RDS_INT			(1<<2)
-#define SI4713_ASQ_INT			(1<<1)
-#define SI4713_STC_INT			(1<<0)
-
-/*
- * Property definitions
- */
-#define SI4713_GPO_IEN			0x0001
-#define SI4713_DIG_INPUT_FORMAT		0x0101
-#define SI4713_DIG_INPUT_SAMPLE_RATE	0x0103
-#define SI4713_REFCLK_FREQ		0x0201
-#define SI4713_REFCLK_PRESCALE		0x0202
-#define SI4713_TX_COMPONENT_ENABLE	0x2100
-#define SI4713_TX_AUDIO_DEVIATION	0x2101
-#define SI4713_TX_PILOT_DEVIATION	0x2102
-#define SI4713_TX_RDS_DEVIATION		0x2103
-#define SI4713_TX_LINE_INPUT_LEVEL	0x2104
-#define SI4713_TX_LINE_INPUT_MUTE	0x2105
-#define SI4713_TX_PREEMPHASIS		0x2106
-#define SI4713_TX_PILOT_FREQUENCY	0x2107
-#define SI4713_TX_ACOMP_ENABLE		0x2200
-#define SI4713_TX_ACOMP_THRESHOLD	0x2201
-#define SI4713_TX_ACOMP_ATTACK_TIME	0x2202
-#define SI4713_TX_ACOMP_RELEASE_TIME	0x2203
-#define SI4713_TX_ACOMP_GAIN		0x2204
-#define SI4713_TX_LIMITER_RELEASE_TIME	0x2205
-#define SI4713_TX_ASQ_INTERRUPT_SOURCE	0x2300
-#define SI4713_TX_ASQ_LEVEL_LOW		0x2301
-#define SI4713_TX_ASQ_DURATION_LOW	0x2302
-#define SI4713_TX_ASQ_LEVEL_HIGH	0x2303
-#define SI4713_TX_ASQ_DURATION_HIGH	0x2304
-#define SI4713_TX_RDS_INTERRUPT_SOURCE	0x2C00
-#define SI4713_TX_RDS_PI		0x2C01
-#define SI4713_TX_RDS_PS_MIX		0x2C02
-#define SI4713_TX_RDS_PS_MISC		0x2C03
-#define SI4713_TX_RDS_PS_REPEAT_COUNT	0x2C04
-#define SI4713_TX_RDS_PS_MESSAGE_COUNT	0x2C05
-#define SI4713_TX_RDS_PS_AF		0x2C06
-#define SI4713_TX_RDS_FIFO_SIZE		0x2C07
-
-#define PREEMPHASIS_USA			75
-#define PREEMPHASIS_EU			50
-#define PREEMPHASIS_DISABLED		0
-#define FMPE_USA			0x00
-#define FMPE_EU				0x01
-#define FMPE_DISABLED			0x02
-
-#define POWER_UP			0x01
-#define POWER_DOWN			0x00
-
-#define MAX_RDS_PTY			31
-#define MAX_RDS_DEVIATION		90000
-
-/*
- * PSNAME is known to be defined as 8 character sized (RDS Spec).
- * However, there is receivers which scroll PSNAME 8xN sized.
- */
-#define MAX_RDS_PS_NAME			96
-
-/*
- * MAX_RDS_RADIO_TEXT is known to be defined as 32 (2A group) or 64 (2B group)
- * character sized (RDS Spec).
- * However, there is receivers which scroll them as well.
- */
-#define MAX_RDS_RADIO_TEXT		384
-
-#define MAX_LIMITER_RELEASE_TIME	102390
-#define MAX_LIMITER_DEVIATION		90000
-
-#define MAX_PILOT_DEVIATION		90000
-#define MAX_PILOT_FREQUENCY		19000
-
-#define MAX_ACOMP_RELEASE_TIME		1000000
-#define MAX_ACOMP_ATTACK_TIME		5000
-#define MAX_ACOMP_THRESHOLD		0
-#define MIN_ACOMP_THRESHOLD		(-40)
-#define MAX_ACOMP_GAIN			20
-
-#define SI4713_NUM_SUPPLIES		2
-
-/*
- * si4713_device - private data
- */
-struct si4713_device {
-	/* v4l2_subdev and i2c reference (v4l2_subdev priv data) */
-	struct v4l2_subdev sd;
-	struct v4l2_ctrl_handler ctrl_handler;
-	/* private data structures */
-	struct { /* si4713 control cluster */
-		/* This is one big cluster since the mute control
-		 * powers off the device and after unmuting again all
-		 * controls need to be set at once. The only way of doing
-		 * that is by making it one big cluster. */
-		struct v4l2_ctrl *mute;
-		struct v4l2_ctrl *rds_ps_name;
-		struct v4l2_ctrl *rds_radio_text;
-		struct v4l2_ctrl *rds_pi;
-		struct v4l2_ctrl *rds_deviation;
-		struct v4l2_ctrl *rds_pty;
-		struct v4l2_ctrl *compression_enabled;
-		struct v4l2_ctrl *compression_threshold;
-		struct v4l2_ctrl *compression_gain;
-		struct v4l2_ctrl *compression_attack_time;
-		struct v4l2_ctrl *compression_release_time;
-		struct v4l2_ctrl *pilot_tone_enabled;
-		struct v4l2_ctrl *pilot_tone_freq;
-		struct v4l2_ctrl *pilot_tone_deviation;
-		struct v4l2_ctrl *limiter_enabled;
-		struct v4l2_ctrl *limiter_deviation;
-		struct v4l2_ctrl *limiter_release_time;
-		struct v4l2_ctrl *tune_preemphasis;
-		struct v4l2_ctrl *tune_pwr_level;
-		struct v4l2_ctrl *tune_ant_cap;
-	};
-	struct completion work;
-	struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
-	int gpio_reset;
-	u32 power_state;
-	u32 rds_enabled;
-	u32 frequency;
-	u32 preemphasis;
-	u32 stereo;
-	u32 tune_rnl;
-};
-#endif /* ifndef SI4713_I2C_H */
diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
new file mode 100644
index 0000000..22f002b
--- /dev/null
+++ b/drivers/media/radio/si4713/Kconfig
@@ -0,0 +1,25 @@
+config I2C_SI4713
+	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
+	depends on I2C && RADIO_SI4713
+	select SI4713
+	---help---
+	  This is a driver for I2C devices with the Silicon Labs SI4713
+	  chip.
+
+	  Say Y here if you want to connect this type of radio to your
+	  computer's I2C port.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-i2c-si4713.
+	 
+config SI4713
+	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
+	depends on I2C && RADIO_SI4713
+	---help---
+	  Say Y here if you want support to Si4713 FM Radio Transmitter.
+	  This device can transmit audio through FM. It can transmit
+	  RDS and RBDS signals as well. This module is the v4l2 radio
+	  interface for the i2c driver of this device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called si4713.
diff --git a/drivers/media/radio/si4713/Makefile b/drivers/media/radio/si4713/Makefile
new file mode 100644
index 0000000..27dd810
--- /dev/null
+++ b/drivers/media/radio/si4713/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for radios with Silicon Labs Si4713 FM Radio Transmitters
+#
+
+obj-$(CONFIG_SI4713) += si4713.o
+obj-$(CONFIG_I2C_SI4713) += radio-i2c-si4713.o
+
diff --git a/drivers/media/radio/si4713/radio-i2c-si4713.c b/drivers/media/radio/si4713/radio-i2c-si4713.c
new file mode 100644
index 0000000..ba4cfc9
--- /dev/null
+++ b/drivers/media/radio/si4713/radio-i2c-si4713.c
@@ -0,0 +1,246 @@
+/*
+ * drivers/media/radio/radio-si4713.c
+ *
+ * Platform Driver for Silicon Labs Si4713 FM Radio Transmitter:
+ *
+ * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
+ * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/radio-si4713.h>
+
+/* module parameters */
+static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
+module_param(radio_nr, int, 0);
+MODULE_PARM_DESC(radio_nr,
+		 "Minor number for radio device (-1 ==> auto assign)");
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
+MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
+MODULE_VERSION("0.0.1");
+MODULE_ALIAS("platform:radio-si4713");
+
+/* Driver state struct */
+struct radio_si4713_device {
+	struct v4l2_device		v4l2_dev;
+	struct video_device		radio_dev;
+	struct mutex lock;
+};
+
+/* radio_si4713_fops - file operations interface */
+static const struct v4l2_file_operations radio_si4713_fops = {
+	.owner		= THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = v4l2_fh_release,
+	.poll = v4l2_ctrl_poll,
+	/* Note: locking is done at the subdev level in the i2c driver. */
+	.unlocked_ioctl	= video_ioctl2,
+};
+
+/* Video4Linux Interface */
+
+/* radio_si4713_querycap - query device capabilities */
+static int radio_si4713_querycap(struct file *file, void *priv,
+					struct v4l2_capability *capability)
+{
+	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
+	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
+		sizeof(capability->card));
+	strlcpy(capability->bus_info, "platform:radio-si4713",
+		sizeof(capability->bus_info));
+	capability->device_caps = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
+	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+/*
+ * v4l2 ioctl call backs.
+ * we are just a wrapper for v4l2_sub_devs.
+ */
+static inline struct v4l2_device *get_v4l2_dev(struct file *file)
+{
+	return &((struct radio_si4713_device *)video_drvdata(file))->v4l2_dev;
+}
+
+static int radio_si4713_g_modulator(struct file *file, void *p,
+				    struct v4l2_modulator *vm)
+{
+	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
+					  g_modulator, vm);
+}
+
+static int radio_si4713_s_modulator(struct file *file, void *p,
+				    const struct v4l2_modulator *vm)
+{
+	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
+					  s_modulator, vm);
+}
+
+static int radio_si4713_g_frequency(struct file *file, void *p,
+				    struct v4l2_frequency *vf)
+{
+	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
+					  g_frequency, vf);
+}
+
+static int radio_si4713_s_frequency(struct file *file, void *p,
+				    const struct v4l2_frequency *vf)
+{
+	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
+					  s_frequency, vf);
+}
+
+static long radio_si4713_default(struct file *file, void *p,
+				 bool valid_prio, unsigned int cmd, void *arg)
+{
+	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
+					  ioctl, cmd, arg);
+}
+
+static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
+	.vidioc_querycap	= radio_si4713_querycap,
+	.vidioc_g_modulator	= radio_si4713_g_modulator,
+	.vidioc_s_modulator	= radio_si4713_s_modulator,
+	.vidioc_g_frequency	= radio_si4713_g_frequency,
+	.vidioc_s_frequency	= radio_si4713_s_frequency,
+	.vidioc_log_status      = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_default		= radio_si4713_default,
+};
+
+/* radio_si4713_vdev_template - video device interface */
+static struct video_device radio_si4713_vdev_template = {
+	.fops			= &radio_si4713_fops,
+	.name			= "radio-si4713",
+	.release		= video_device_release_empty,
+	.ioctl_ops		= &radio_si4713_ioctl_ops,
+	.vfl_dir		= VFL_DIR_TX,
+};
+
+/* Platform driver interface */
+/* radio_si4713_pdriver_probe - probe for the device */
+static int radio_si4713_pdriver_probe(struct platform_device *pdev)
+{
+	struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
+	struct radio_si4713_device *rsdev;
+	struct i2c_adapter *adapter;
+	struct v4l2_subdev *sd;
+	int rval = 0;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Cannot proceed without platform data.\n");
+		rval = -EINVAL;
+		goto exit;
+	}
+
+	rsdev = devm_kzalloc(&pdev->dev, sizeof(*rsdev), GFP_KERNEL);
+	if (!rsdev) {
+		dev_err(&pdev->dev, "Failed to alloc video device.\n");
+		rval = -ENOMEM;
+		goto exit;
+	}
+	mutex_init(&rsdev->lock);
+
+	rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
+	if (rval) {
+		dev_err(&pdev->dev, "Failed to register v4l2 device.\n");
+		goto exit;
+	}
+
+	adapter = i2c_get_adapter(pdata->i2c_bus);
+	if (!adapter) {
+		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
+			pdata->i2c_bus);
+		rval = -ENODEV;
+		goto unregister_v4l2_dev;
+	}
+
+	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
+				       pdata->subdev_board_info, NULL);
+	if (!sd) {
+		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
+		rval = -ENODEV;
+		goto put_adapter;
+	}
+
+	rsdev->radio_dev = radio_si4713_vdev_template;
+	rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
+	rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
+	set_bit(V4L2_FL_USE_FH_PRIO, &rsdev->radio_dev.flags);
+	/* Serialize all access to the si4713 */
+	rsdev->radio_dev.lock = &rsdev->lock;
+	video_set_drvdata(&rsdev->radio_dev, rsdev);
+	if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
+		dev_err(&pdev->dev, "Could not register video device.\n");
+		rval = -EIO;
+		goto put_adapter;
+	}
+	dev_info(&pdev->dev, "New device successfully probed\n");
+
+	goto exit;
+
+put_adapter:
+	i2c_put_adapter(adapter);
+unregister_v4l2_dev:
+	v4l2_device_unregister(&rsdev->v4l2_dev);
+exit:
+	return rval;
+}
+
+/* radio_si4713_pdriver_remove - remove the device */
+static int radio_si4713_pdriver_remove(struct platform_device *pdev)
+{
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
+					    struct v4l2_subdev, list);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct radio_si4713_device *rsdev;
+
+	rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
+	video_unregister_device(&rsdev->radio_dev);
+	i2c_put_adapter(client->adapter);
+	v4l2_device_unregister(&rsdev->v4l2_dev);
+
+	return 0;
+}
+
+static struct platform_driver radio_si4713_pdriver = {
+	.driver		= {
+		.name	= "radio-si4713",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= radio_si4713_pdriver_probe,
+	.remove         = radio_si4713_pdriver_remove,
+};
+
+module_platform_driver(radio_si4713_pdriver);
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
new file mode 100644
index 0000000..14bc8a3
--- /dev/null
+++ b/drivers/media/radio/si4713/si4713.c
@@ -0,0 +1,1532 @@
+/*
+ * drivers/media/radio/si4713-i2c.c
+ *
+ * Silicon Labs Si4713 FM Radio Transmitter I2C commands.
+ *
+ * Copyright (c) 2009 Nokia Corporation
+ * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/module.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-common.h>
+
+#include "si4713.h"
+
+/* module parameters */
+static int debug;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug level (0 - 2)");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
+MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
+MODULE_VERSION("0.0.1");
+
+static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
+	"vio",
+	"vdd",
+};
+
+#define DEFAULT_RDS_PI			0x00
+#define DEFAULT_RDS_PTY			0x00
+#define DEFAULT_RDS_DEVIATION		0x00C8
+#define DEFAULT_RDS_PS_REPEAT_COUNT	0x0003
+#define DEFAULT_LIMITER_RTIME		0x1392
+#define DEFAULT_LIMITER_DEV		0x102CA
+#define DEFAULT_PILOT_FREQUENCY 	0x4A38
+#define DEFAULT_PILOT_DEVIATION		0x1A5E
+#define DEFAULT_ACOMP_ATIME		0x0000
+#define DEFAULT_ACOMP_RTIME		0xF4240L
+#define DEFAULT_ACOMP_GAIN		0x0F
+#define DEFAULT_ACOMP_THRESHOLD 	(-0x28)
+#define DEFAULT_MUTE			0x01
+#define DEFAULT_POWER_LEVEL		88
+#define DEFAULT_FREQUENCY		8800
+#define DEFAULT_PREEMPHASIS		FMPE_EU
+#define DEFAULT_TUNE_RNL		0xFF
+
+#define to_si4713_device(sd)	container_of(sd, struct si4713_device, sd)
+
+/* frequency domain transformation (using times 10 to avoid floats) */
+#define FREQDEV_UNIT	100000
+#define FREQV4L2_MULTI	625
+#define si4713_to_v4l2(f)	((f * FREQDEV_UNIT) / FREQV4L2_MULTI)
+#define v4l2_to_si4713(f)	((f * FREQV4L2_MULTI) / FREQDEV_UNIT)
+#define FREQ_RANGE_LOW			7600
+#define FREQ_RANGE_HIGH			10800
+
+#define MAX_ARGS 7
+
+#define RDS_BLOCK			8
+#define RDS_BLOCK_CLEAR			0x03
+#define RDS_BLOCK_LOAD			0x04
+#define RDS_RADIOTEXT_2A		0x20
+#define RDS_RADIOTEXT_BLK_SIZE		4
+#define RDS_RADIOTEXT_INDEX_MAX		0x0F
+#define RDS_CARRIAGE_RETURN		0x0D
+
+#define rds_ps_nblocks(len)	((len / RDS_BLOCK) + (len % RDS_BLOCK ? 1 : 0))
+
+#define get_status_bit(p, b, m)	(((p) & (m)) >> (b))
+#define set_bits(p, v, b, m)	(((p) & ~(m)) | ((v) << (b)))
+
+#define ATTACK_TIME_UNIT	500
+
+#define POWER_OFF			0x00
+#define POWER_ON			0x01
+
+#define msb(x)                  ((u8)((u16) x >> 8))
+#define lsb(x)                  ((u8)((u16) x &  0x00FF))
+#define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
+#define check_command_failed(status)	(!(status & SI4713_CTS) || \
+					(status & SI4713_ERR))
+/* mute definition */
+#define set_mute(p)	((p & 1) | ((p & 1) << 1));
+
+#ifdef DEBUG
+#define DBG_BUFFER(device, message, buffer, size)			\
+	{								\
+		int i;							\
+		char str[(size)*5];					\
+		for (i = 0; i < size; i++)				\
+			sprintf(str + i * 5, " 0x%02x", buffer[i]);	\
+		v4l2_dbg(2, debug, device, "%s:%s\n", message, str);	\
+	}
+#else
+#define DBG_BUFFER(device, message, buffer, size)
+#endif
+
+/*
+ * Values for limiter release time (sorted by second column)
+ *	device	release
+ *	value	time (us)
+ */
+static long limiter_times[] = {
+	2000,	250,
+	1000,	500,
+	510,	1000,
+	255,	2000,
+	170,	3000,
+	127,	4020,
+	102,	5010,
+	85,	6020,
+	73,	7010,
+	64,	7990,
+	57,	8970,
+	51,	10030,
+	25,	20470,
+	17,	30110,
+	13,	39380,
+	10,	51190,
+	8,	63690,
+	7,	73140,
+	6,	85330,
+	5,	102390,
+};
+
+/*
+ * Values for audio compression release time (sorted by second column)
+ *	device	release
+ *	value	time (us)
+ */
+static unsigned long acomp_rtimes[] = {
+	0,	100000,
+	1,	200000,
+	2,	350000,
+	3,	525000,
+	4,	1000000,
+};
+
+/*
+ * Values for preemphasis (sorted by second column)
+ *	device	preemphasis
+ *	value	value (v4l2)
+ */
+static unsigned long preemphasis_values[] = {
+	FMPE_DISABLED,	V4L2_PREEMPHASIS_DISABLED,
+	FMPE_EU,	V4L2_PREEMPHASIS_50_uS,
+	FMPE_USA,	V4L2_PREEMPHASIS_75_uS,
+};
+
+static int usecs_to_dev(unsigned long usecs, unsigned long const array[],
+			int size)
+{
+	int i;
+	int rval = -EINVAL;
+
+	for (i = 0; i < size / 2; i++)
+		if (array[(i * 2) + 1] >= usecs) {
+			rval = array[i * 2];
+			break;
+		}
+
+	return rval;
+}
+
+/* si4713_handler: IRQ handler, just complete work */
+static irqreturn_t si4713_handler(int irq, void *dev)
+{
+	struct si4713_device *sdev = dev;
+
+	v4l2_dbg(2, debug, &sdev->sd,
+			"%s: sending signal to completion work.\n", __func__);
+	complete(&sdev->work);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * si4713_send_command - sends a command to si4713 and waits its response
+ * @sdev: si4713_device structure for the device we are communicating
+ * @command: command id
+ * @args: command arguments we are sending (up to 7)
+ * @argn: actual size of @args
+ * @response: buffer to place the expected response from the device (up to 15)
+ * @respn: actual size of @response
+ * @usecs: amount of time to wait before reading the response (in usecs)
+ */
+static int si4713_send_command(struct si4713_device *sdev, const u8 command,
+				const u8 args[], const int argn,
+				u8 response[], const int respn, const int usecs)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
+	u8 data1[MAX_ARGS + 1];
+	int err;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	/* First send the command and its arguments */
+	data1[0] = command;
+	memcpy(data1 + 1, args, argn);
+	DBG_BUFFER(&sdev->sd, "Parameters", data1, argn + 1);
+
+	err = i2c_master_send(client, data1, argn + 1);
+	if (err != argn + 1) {
+		v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
+			command);
+		return (err > 0) ? -EIO : err;
+	}
+
+	/* Wait response from interrupt */
+	if (!wait_for_completion_timeout(&sdev->work,
+				usecs_to_jiffies(usecs) + 1))
+		v4l2_warn(&sdev->sd,
+				"(%s) Device took too much time to answer.\n",
+				__func__);
+
+	/* Then get the response */
+	err = i2c_master_recv(client, response, respn);
+	if (err != respn) {
+		v4l2_err(&sdev->sd,
+			"Error while reading response for command 0x%02x\n",
+			command);
+		return (err > 0) ? -EIO : err;
+	}
+
+	DBG_BUFFER(&sdev->sd, "Response", response, respn);
+	if (check_command_failed(response[0]))
+		return -EBUSY;
+
+	return 0;
+}
+
+/*
+ * si4713_read_property - reads a si4713 property
+ * @sdev: si4713_device structure for the device we are communicating
+ * @prop: property identification number
+ * @pv: property value to be returned on success
+ */
+static int si4713_read_property(struct si4713_device *sdev, u16 prop, u32 *pv)
+{
+	int err;
+	u8 val[SI4713_GET_PROP_NRESP];
+	/*
+	 * 	.First byte = 0
+	 * 	.Second byte = property's MSB
+	 * 	.Third byte = property's LSB
+	 */
+	const u8 args[SI4713_GET_PROP_NARGS] = {
+		0x00,
+		msb(prop),
+		lsb(prop),
+	};
+
+	err = si4713_send_command(sdev, SI4713_CMD_GET_PROPERTY,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		return err;
+
+	*pv = compose_u16(val[2], val[3]);
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: property=0x%02x value=0x%02x status=0x%02x\n",
+			__func__, prop, *pv, val[0]);
+
+	return err;
+}
+
+/*
+ * si4713_write_property - modifies a si4713 property
+ * @sdev: si4713_device structure for the device we are communicating
+ * @prop: property identification number
+ * @val: new value for that property
+ */
+static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
+{
+	int rval;
+	u8 resp[SI4713_SET_PROP_NRESP];
+	/*
+	 * 	.First byte = 0
+	 * 	.Second byte = property's MSB
+	 * 	.Third byte = property's LSB
+	 * 	.Fourth byte = value's MSB
+	 * 	.Fifth byte = value's LSB
+	 */
+	const u8 args[SI4713_SET_PROP_NARGS] = {
+		0x00,
+		msb(prop),
+		lsb(prop),
+		msb(val),
+		lsb(val),
+	};
+
+	rval = si4713_send_command(sdev, SI4713_CMD_SET_PROPERTY,
+					args, ARRAY_SIZE(args),
+					resp, ARRAY_SIZE(resp),
+					DEFAULT_TIMEOUT);
+
+	if (rval < 0)
+		return rval;
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: property=0x%02x value=0x%02x status=0x%02x\n",
+			__func__, prop, val, resp[0]);
+
+	/*
+	 * As there is no command response for SET_PROPERTY,
+	 * wait Tcomp time to finish before proceed, in order
+	 * to have property properly set.
+	 */
+	msleep(TIMEOUT_SET_PROPERTY);
+
+	return rval;
+}
+
+/*
+ * si4713_powerup - Powers the device up
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_powerup(struct si4713_device *sdev)
+{
+	int err;
+	u8 resp[SI4713_PWUP_NRESP];
+	/*
+	 * 	.First byte = Enabled interrupts and boot function
+	 * 	.Second byte = Input operation mode
+	 */
+	const u8 args[SI4713_PWUP_NARGS] = {
+		SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
+		SI4713_PWUP_OPMOD_ANALOG,
+	};
+
+	if (sdev->power_state)
+		return 0;
+
+	err = regulator_bulk_enable(ARRAY_SIZE(sdev->supplies),
+				    sdev->supplies);
+	if (err) {
+		v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
+		return err;
+	}
+	if (gpio_is_valid(sdev->gpio_reset)) {
+		udelay(50);
+		gpio_set_value(sdev->gpio_reset, 1);
+	}
+
+	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
+					args, ARRAY_SIZE(args),
+					resp, ARRAY_SIZE(resp),
+					TIMEOUT_POWER_UP);
+
+	if (!err) {
+		v4l2_dbg(1, debug, &sdev->sd, "Powerup response: 0x%02x\n",
+				resp[0]);
+		v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
+		sdev->power_state = POWER_ON;
+
+		err = si4713_write_property(sdev, SI4713_GPO_IEN,
+						SI4713_STC_INT | SI4713_CTS);
+	} else {
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
+					     sdev->supplies);
+		if (err)
+			v4l2_err(&sdev->sd,
+				 "Failed to disable supplies: %d\n", err);
+	}
+
+	return err;
+}
+
+/*
+ * si4713_powerdown - Powers the device down
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_powerdown(struct si4713_device *sdev)
+{
+	int err;
+	u8 resp[SI4713_PWDN_NRESP];
+
+	if (!sdev->power_state)
+		return 0;
+
+	err = si4713_send_command(sdev, SI4713_CMD_POWER_DOWN,
+					NULL, 0,
+					resp, ARRAY_SIZE(resp),
+					DEFAULT_TIMEOUT);
+
+	if (!err) {
+		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
+				resp[0]);
+		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
+					     sdev->supplies);
+		if (err)
+			v4l2_err(&sdev->sd,
+				 "Failed to disable supplies: %d\n", err);
+		sdev->power_state = POWER_OFF;
+	}
+
+	return err;
+}
+
+/*
+ * si4713_checkrev - Checks if we are treating a device with the correct rev.
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_checkrev(struct si4713_device *sdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
+	int rval;
+	u8 resp[SI4713_GETREV_NRESP];
+
+	rval = si4713_send_command(sdev, SI4713_CMD_GET_REV,
+					NULL, 0,
+					resp, ARRAY_SIZE(resp),
+					DEFAULT_TIMEOUT);
+
+	if (rval < 0)
+		return rval;
+
+	if (resp[1] == SI4713_PRODUCT_NUMBER) {
+		v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
+				client->addr << 1, client->adapter->name);
+	} else {
+		v4l2_err(&sdev->sd, "Invalid product number\n");
+		rval = -EINVAL;
+	}
+	return rval;
+}
+
+/*
+ * si4713_wait_stc - Waits STC interrupt and clears status bits. Useful
+ *		     for TX_TUNE_POWER, TX_TUNE_FREQ and TX_TUNE_MEAS
+ * @sdev: si4713_device structure for the device we are communicating
+ * @usecs: timeout to wait for STC interrupt signal
+ */
+static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
+{
+	int err;
+	u8 resp[SI4713_GET_STATUS_NRESP];
+
+	/* Wait response from STC interrupt */
+	if (!wait_for_completion_timeout(&sdev->work,
+			usecs_to_jiffies(usecs) + 1))
+		v4l2_warn(&sdev->sd,
+			"%s: device took too much time to answer (%d usec).\n",
+				__func__, usecs);
+
+	/* Clear status bits */
+	err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
+					NULL, 0,
+					resp, ARRAY_SIZE(resp),
+					DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		goto exit;
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: status bits: 0x%02x\n", __func__, resp[0]);
+
+	if (!(resp[0] & SI4713_STC_INT))
+		err = -EIO;
+
+exit:
+	return err;
+}
+
+/*
+ * si4713_tx_tune_freq - Sets the state of the RF carrier and sets the tuning
+ * 			frequency between 76 and 108 MHz in 10 kHz units and
+ * 			steps of 50 kHz.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
+ */
+static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
+{
+	int err;
+	u8 val[SI4713_TXFREQ_NRESP];
+	/*
+	 * 	.First byte = 0
+	 * 	.Second byte = frequency's MSB
+	 * 	.Third byte = frequency's LSB
+	 */
+	const u8 args[SI4713_TXFREQ_NARGS] = {
+		0x00,
+		msb(frequency),
+		lsb(frequency),
+	};
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_FREQ,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		return err;
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: frequency=0x%02x status=0x%02x\n", __func__,
+			frequency, val[0]);
+
+	err = si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
+	if (err < 0)
+		return err;
+
+	return compose_u16(args[1], args[2]);
+}
+
+/*
+ * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
+ * 			1 dB units. A value of 0x00 indicates off. The command
+ * 			also sets the antenna tuning capacitance. A value of 0
+ * 			indicates autotuning, and a value of 1 - 191 indicates
+ * 			a manual override, which results in a tuning
+ * 			capacitance of 0.25 pF x @antcap.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
+ * @antcap: value of antenna tuning capacitor (0 - 191)
+ */
+static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
+				u8 antcap)
+{
+	int err;
+	u8 val[SI4713_TXPWR_NRESP];
+	/*
+	 * 	.First byte = 0
+	 * 	.Second byte = 0
+	 * 	.Third byte = power
+	 * 	.Fourth byte = antcap
+	 */
+	const u8 args[SI4713_TXPWR_NARGS] = {
+		0x00,
+		0x00,
+		power,
+		antcap,
+	};
+
+	if (((power > 0) && (power < SI4713_MIN_POWER)) ||
+		power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
+		return -EDOM;
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_POWER,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		return err;
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: power=0x%02x antcap=0x%02x status=0x%02x\n",
+			__func__, power, antcap, val[0]);
+
+	return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE_POWER);
+}
+
+/*
+ * si4713_tx_tune_measure - Enters receive mode and measures the received noise
+ * 			level in units of dBuV on the selected frequency.
+ * 			The Frequency must be between 76 and 108 MHz in 10 kHz
+ * 			units and steps of 50 kHz. The command also sets the
+ * 			antenna	tuning capacitance. A value of 0 means
+ * 			autotuning, and a value of 1 to 191 indicates manual
+ * 			override.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
+ * @antcap: value of antenna tuning capacitor (0 - 191)
+ */
+static int si4713_tx_tune_measure(struct si4713_device *sdev, u16 frequency,
+					u8 antcap)
+{
+	int err;
+	u8 val[SI4713_TXMEA_NRESP];
+	/*
+	 * 	.First byte = 0
+	 * 	.Second byte = frequency's MSB
+	 * 	.Third byte = frequency's LSB
+	 * 	.Fourth byte = antcap
+	 */
+	const u8 args[SI4713_TXMEA_NARGS] = {
+		0x00,
+		msb(frequency),
+		lsb(frequency),
+		antcap,
+	};
+
+	sdev->tune_rnl = DEFAULT_TUNE_RNL;
+
+	if (antcap > SI4713_MAX_ANTCAP)
+		return -EDOM;
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_MEASURE,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		return err;
+
+	v4l2_dbg(1, debug, &sdev->sd,
+			"%s: frequency=0x%02x antcap=0x%02x status=0x%02x\n",
+			__func__, frequency, antcap, val[0]);
+
+	return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
+}
+
+/*
+ * si4713_tx_tune_status- Returns the status of the tx_tune_freq, tx_tune_mea or
+ * 			tx_tune_power commands. This command return the current
+ * 			frequency, output voltage in dBuV, the antenna tunning
+ * 			capacitance value and the received noise level. The
+ * 			command also clears the stcint interrupt bit when the
+ * 			first bit of its arguments is high.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @intack: 0x01 to clear the seek/tune complete interrupt status indicator.
+ * @frequency: returned frequency
+ * @power: returned power
+ * @antcap: returned antenna capacitance
+ * @noise: returned noise level
+ */
+static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
+					u16 *frequency,	u8 *power,
+					u8 *antcap, u8 *noise)
+{
+	int err;
+	u8 val[SI4713_TXSTATUS_NRESP];
+	/*
+	 * 	.First byte = intack bit
+	 */
+	const u8 args[SI4713_TXSTATUS_NARGS] = {
+		intack & SI4713_INTACK_MASK,
+	};
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_STATUS,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (!err) {
+		v4l2_dbg(1, debug, &sdev->sd,
+			"%s: status=0x%02x\n", __func__, val[0]);
+		*frequency = compose_u16(val[2], val[3]);
+		sdev->frequency = *frequency;
+		*power = val[5];
+		*antcap = val[6];
+		*noise = val[7];
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
+				"(power %d, antcap %d, rnl %d)\n", __func__,
+				*frequency, *power, *antcap, *noise);
+	}
+
+	return err;
+}
+
+/*
+ * si4713_tx_rds_buff - Loads the RDS group buffer FIFO or circular buffer.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @mode: the buffer operation mode.
+ * @rdsb: RDS Block B
+ * @rdsc: RDS Block C
+ * @rdsd: RDS Block D
+ * @cbleft: returns the number of available circular buffer blocks minus the
+ *          number of used circular buffer blocks.
+ */
+static int si4713_tx_rds_buff(struct si4713_device *sdev, u8 mode, u16 rdsb,
+				u16 rdsc, u16 rdsd, s8 *cbleft)
+{
+	int err;
+	u8 val[SI4713_RDSBUFF_NRESP];
+
+	const u8 args[SI4713_RDSBUFF_NARGS] = {
+		mode & SI4713_RDSBUFF_MODE_MASK,
+		msb(rdsb),
+		lsb(rdsb),
+		msb(rdsc),
+		lsb(rdsc),
+		msb(rdsd),
+		lsb(rdsd),
+	};
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_BUFF,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (!err) {
+		v4l2_dbg(1, debug, &sdev->sd,
+			"%s: status=0x%02x\n", __func__, val[0]);
+		*cbleft = (s8)val[2] - val[3];
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
+				" 0x%02x cb avail: %d cb used %d fifo avail"
+				" %d fifo used %d\n", __func__, val[1],
+				val[2], val[3], val[4], val[5]);
+	}
+
+	return err;
+}
+
+/*
+ * si4713_tx_rds_ps - Loads the program service buffer.
+ * @sdev: si4713_device structure for the device we are communicating
+ * @psid: program service id to be loaded.
+ * @pschar: assumed 4 size char array to be loaded into the program service
+ */
+static int si4713_tx_rds_ps(struct si4713_device *sdev, u8 psid,
+				unsigned char *pschar)
+{
+	int err;
+	u8 val[SI4713_RDSPS_NRESP];
+
+	const u8 args[SI4713_RDSPS_NARGS] = {
+		psid & SI4713_RDSPS_PSID_MASK,
+		pschar[0],
+		pschar[1],
+		pschar[2],
+		pschar[3],
+	};
+
+	err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_PS,
+				  args, ARRAY_SIZE(args), val,
+				  ARRAY_SIZE(val), DEFAULT_TIMEOUT);
+
+	if (err < 0)
+		return err;
+
+	v4l2_dbg(1, debug, &sdev->sd, "%s: status=0x%02x\n", __func__, val[0]);
+
+	return err;
+}
+
+static int si4713_set_power_state(struct si4713_device *sdev, u8 value)
+{
+	if (value)
+		return si4713_powerup(sdev);
+	return si4713_powerdown(sdev);
+}
+
+static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
+{
+	int rval = 0;
+
+	mute = set_mute(mute);
+
+	if (sdev->power_state)
+		rval = si4713_write_property(sdev,
+				SI4713_TX_LINE_INPUT_MUTE, mute);
+
+	return rval;
+}
+
+static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
+{
+	int rval = 0, i;
+	u8 len = 0;
+
+	/* We want to clear the whole thing */
+	if (!strlen(ps_name))
+		memset(ps_name, 0, MAX_RDS_PS_NAME + 1);
+
+	if (sdev->power_state) {
+		/* Write the new ps name and clear the padding */
+		for (i = 0; i < MAX_RDS_PS_NAME; i += (RDS_BLOCK / 2)) {
+			rval = si4713_tx_rds_ps(sdev, (i / (RDS_BLOCK / 2)),
+						ps_name + i);
+			if (rval < 0)
+				return rval;
+		}
+
+		/* Setup the size to be sent */
+		if (strlen(ps_name))
+			len = strlen(ps_name) - 1;
+		else
+			len = 1;
+
+		rval = si4713_write_property(sdev,
+				SI4713_TX_RDS_PS_MESSAGE_COUNT,
+				rds_ps_nblocks(len));
+		if (rval < 0)
+			return rval;
+
+		rval = si4713_write_property(sdev,
+				SI4713_TX_RDS_PS_REPEAT_COUNT,
+				DEFAULT_RDS_PS_REPEAT_COUNT * 2);
+		if (rval < 0)
+			return rval;
+	}
+
+	return rval;
+}
+
+static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
+{
+	int rval = 0, i;
+	u16 t_index = 0;
+	u8 b_index = 0, cr_inserted = 0;
+	s8 left;
+
+	if (!sdev->power_state)
+		return rval;
+
+	rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_CLEAR, 0, 0, 0, &left);
+	if (rval < 0)
+		return rval;
+
+	if (!strlen(rt))
+		return rval;
+
+	do {
+		/* RDS spec says that if the last block isn't used,
+		 * then apply a carriage return
+		 */
+		if (t_index < (RDS_RADIOTEXT_INDEX_MAX * RDS_RADIOTEXT_BLK_SIZE)) {
+			for (i = 0; i < RDS_RADIOTEXT_BLK_SIZE; i++) {
+				if (!rt[t_index + i] ||
+				    rt[t_index + i] == RDS_CARRIAGE_RETURN) {
+					rt[t_index + i] = RDS_CARRIAGE_RETURN;
+					cr_inserted = 1;
+					break;
+				}
+			}
+		}
+
+		rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_LOAD,
+				compose_u16(RDS_RADIOTEXT_2A, b_index++),
+				compose_u16(rt[t_index], rt[t_index + 1]),
+				compose_u16(rt[t_index + 2], rt[t_index + 3]),
+				&left);
+		if (rval < 0)
+			return rval;
+
+		t_index += RDS_RADIOTEXT_BLK_SIZE;
+
+		if (cr_inserted)
+			break;
+	} while (left > 0);
+
+	return rval;
+}
+
+/*
+ * si4713_update_tune_status - update properties from tx_tune_status
+ * command. Must be called with sdev->mutex held.
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_update_tune_status(struct si4713_device *sdev)
+{
+	int rval;
+	u16 f = 0;
+	u8 p = 0, a = 0, n = 0;
+
+	rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
+
+	if (rval < 0)
+		goto exit;
+
+/*	TODO: check that power_level and antenna_capacitor really are not
+	changed by the hardware. If they are, then these controls should become
+	volatiles.
+	sdev->power_level = p;
+	sdev->antenna_capacitor = a;*/
+	sdev->tune_rnl = n;
+
+exit:
+	return rval;
+}
+
+static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
+		s32 *bit, s32 *mask, u16 *property, int *mul,
+		unsigned long **table, int *size)
+{
+	s32 rval = 0;
+
+	switch (id) {
+	/* FM_TX class controls */
+	case V4L2_CID_RDS_TX_PI:
+		*property = SI4713_TX_RDS_PI;
+		*mul = 1;
+		break;
+	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
+		*property = SI4713_TX_ACOMP_THRESHOLD;
+		*mul = 1;
+		break;
+	case V4L2_CID_AUDIO_COMPRESSION_GAIN:
+		*property = SI4713_TX_ACOMP_GAIN;
+		*mul = 1;
+		break;
+	case V4L2_CID_PILOT_TONE_FREQUENCY:
+		*property = SI4713_TX_PILOT_FREQUENCY;
+		*mul = 1;
+		break;
+	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
+		*property = SI4713_TX_ACOMP_ATTACK_TIME;
+		*mul = ATTACK_TIME_UNIT;
+		break;
+	case V4L2_CID_PILOT_TONE_DEVIATION:
+		*property = SI4713_TX_PILOT_DEVIATION;
+		*mul = 10;
+		break;
+	case V4L2_CID_AUDIO_LIMITER_DEVIATION:
+		*property = SI4713_TX_AUDIO_DEVIATION;
+		*mul = 10;
+		break;
+	case V4L2_CID_RDS_TX_DEVIATION:
+		*property = SI4713_TX_RDS_DEVIATION;
+		*mul = 1;
+		break;
+
+	case V4L2_CID_RDS_TX_PTY:
+		*property = SI4713_TX_RDS_PS_MISC;
+		*bit = 5;
+		*mask = 0x1F << 5;
+		break;
+	case V4L2_CID_AUDIO_LIMITER_ENABLED:
+		*property = SI4713_TX_ACOMP_ENABLE;
+		*bit = 1;
+		*mask = 1 << 1;
+		break;
+	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
+		*property = SI4713_TX_ACOMP_ENABLE;
+		*bit = 0;
+		*mask = 1 << 0;
+		break;
+	case V4L2_CID_PILOT_TONE_ENABLED:
+		*property = SI4713_TX_COMPONENT_ENABLE;
+		*bit = 0;
+		*mask = 1 << 0;
+		break;
+
+	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
+		*property = SI4713_TX_LIMITER_RELEASE_TIME;
+		*table = limiter_times;
+		*size = ARRAY_SIZE(limiter_times);
+		break;
+	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
+		*property = SI4713_TX_ACOMP_RELEASE_TIME;
+		*table = acomp_rtimes;
+		*size = ARRAY_SIZE(acomp_rtimes);
+		break;
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		*property = SI4713_TX_PREEMPHASIS;
+		*table = preemphasis_values;
+		*size = ARRAY_SIZE(preemphasis_values);
+		break;
+
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f);
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *);
+/*
+ * si4713_setup - Sets the device up with current configuration.
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_setup(struct si4713_device *sdev)
+{
+	struct v4l2_frequency f;
+	struct v4l2_modulator vm;
+	int rval;
+
+	/* Device procedure needs to set frequency first */
+	f.tuner = 0;
+	f.frequency = sdev->frequency ? sdev->frequency : DEFAULT_FREQUENCY;
+	f.frequency = si4713_to_v4l2(f.frequency);
+	rval = si4713_s_frequency(&sdev->sd, &f);
+
+	vm.index = 0;
+	if (sdev->stereo)
+		vm.txsubchans = V4L2_TUNER_SUB_STEREO;
+	else
+		vm.txsubchans = V4L2_TUNER_SUB_MONO;
+	if (sdev->rds_enabled)
+		vm.txsubchans |= V4L2_TUNER_SUB_RDS;
+	si4713_s_modulator(&sdev->sd, &vm);
+
+	return rval;
+}
+
+/*
+ * si4713_initialize - Sets the device up with default configuration.
+ * @sdev: si4713_device structure for the device we are communicating
+ */
+static int si4713_initialize(struct si4713_device *sdev)
+{
+	int rval;
+
+	rval = si4713_set_power_state(sdev, POWER_ON);
+	if (rval < 0)
+		return rval;
+
+	rval = si4713_checkrev(sdev);
+	if (rval < 0)
+		return rval;
+
+	rval = si4713_set_power_state(sdev, POWER_OFF);
+	if (rval < 0)
+		return rval;
+
+
+	sdev->frequency = DEFAULT_FREQUENCY;
+	sdev->stereo = 1;
+	sdev->tune_rnl = DEFAULT_TUNE_RNL;
+	return 0;
+}
+
+/* si4713_s_ctrl - set the value of a control */
+static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct si4713_device *sdev =
+		container_of(ctrl->handler, struct si4713_device, ctrl_handler);
+	u32 val = 0;
+	s32 bit = 0, mask = 0;
+	u16 property = 0;
+	int mul = 0;
+	unsigned long *table = NULL;
+	int size = 0;
+	bool force = false;
+	int c;
+	int ret = 0;
+
+	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
+		return -EINVAL;
+	if (ctrl->is_new) {
+		if (ctrl->val) {
+			ret = si4713_set_mute(sdev, ctrl->val);
+			if (!ret)
+				ret = si4713_set_power_state(sdev, POWER_DOWN);
+			return ret;
+		}
+		ret = si4713_set_power_state(sdev, POWER_UP);
+		if (!ret)
+			ret = si4713_set_mute(sdev, ctrl->val);
+		if (!ret)
+			ret = si4713_setup(sdev);
+		if (ret)
+			return ret;
+		force = true;
+	}
+
+	if (!sdev->power_state)
+		return 0;
+
+	for (c = 1; !ret && c < ctrl->ncontrols; c++) {
+		ctrl = ctrl->cluster[c];
+
+		if (!force && !ctrl->is_new)
+			continue;
+
+		switch (ctrl->id) {
+		case V4L2_CID_RDS_TX_PS_NAME:
+			ret = si4713_set_rds_ps_name(sdev, ctrl->string);
+			break;
+
+		case V4L2_CID_RDS_TX_RADIO_TEXT:
+			ret = si4713_set_rds_radio_text(sdev, ctrl->string);
+			break;
+
+		case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+			/* don't handle this control if we force setting all
+			 * controls since in that case it will be handled by
+			 * V4L2_CID_TUNE_POWER_LEVEL. */
+			if (force)
+				break;
+			/* fall through */
+		case V4L2_CID_TUNE_POWER_LEVEL:
+			ret = si4713_tx_tune_power(sdev,
+				sdev->tune_pwr_level->val, sdev->tune_ant_cap->val);
+			if (!ret) {
+				/* Make sure we don't set this twice */
+				sdev->tune_ant_cap->is_new = false;
+				sdev->tune_pwr_level->is_new = false;
+			}
+			break;
+
+		default:
+			ret = si4713_choose_econtrol_action(sdev, ctrl->id, &bit,
+					&mask, &property, &mul, &table, &size);
+			if (ret < 0)
+				break;
+
+			val = ctrl->val;
+			if (mul) {
+				val = val / mul;
+			} else if (table) {
+				ret = usecs_to_dev(val, table, size);
+				if (ret < 0)
+					break;
+				val = ret;
+				ret = 0;
+			}
+
+			if (mask) {
+				ret = si4713_read_property(sdev, property, &val);
+				if (ret < 0)
+					break;
+				val = set_bits(val, ctrl->val, bit, mask);
+			}
+
+			ret = si4713_write_property(sdev, property, val);
+			if (ret < 0)
+				break;
+			if (mask)
+				val = ctrl->val;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/* si4713_ioctl - deal with private ioctls (only rnl for now) */
+static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct si4713_device *sdev = to_si4713_device(sd);
+	struct si4713_rnl *rnl = arg;
+	u16 frequency;
+	int rval = 0;
+
+	if (!arg)
+		return -EINVAL;
+
+	switch (cmd) {
+	case SI4713_IOC_MEASURE_RNL:
+		frequency = v4l2_to_si4713(rnl->frequency);
+
+		if (sdev->power_state) {
+			/* Set desired measurement frequency */
+			rval = si4713_tx_tune_measure(sdev, frequency, 0);
+			if (rval < 0)
+				return rval;
+			/* get results from tune status */
+			rval = si4713_update_tune_status(sdev);
+			if (rval < 0)
+				return rval;
+		}
+		rnl->rnl = sdev->tune_rnl;
+		break;
+
+	default:
+		/* nothing */
+		rval = -ENOIOCTLCMD;
+	}
+
+	return rval;
+}
+
+/* si4713_g_modulator - get modulator attributes */
+static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
+{
+	struct si4713_device *sdev = to_si4713_device(sd);
+	int rval = 0;
+
+	if (!sdev)
+		return -ENODEV;
+
+	if (vm->index > 0)
+		return -EINVAL;
+
+	strncpy(vm->name, "FM Modulator", 32);
+	vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
+		V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
+
+	/* Report current frequency range limits */
+	vm->rangelow = si4713_to_v4l2(FREQ_RANGE_LOW);
+	vm->rangehigh = si4713_to_v4l2(FREQ_RANGE_HIGH);
+
+	if (sdev->power_state) {
+		u32 comp_en = 0;
+
+		rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE,
+						&comp_en);
+		if (rval < 0)
+			return rval;
+
+		sdev->stereo = get_status_bit(comp_en, 1, 1 << 1);
+	}
+
+	/* Report current audio mode: mono or stereo */
+	if (sdev->stereo)
+		vm->txsubchans = V4L2_TUNER_SUB_STEREO;
+	else
+		vm->txsubchans = V4L2_TUNER_SUB_MONO;
+
+	/* Report rds feature status */
+	if (sdev->rds_enabled)
+		vm->txsubchans |= V4L2_TUNER_SUB_RDS;
+	else
+		vm->txsubchans &= ~V4L2_TUNER_SUB_RDS;
+
+	return rval;
+}
+
+/* si4713_s_modulator - set modulator attributes */
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *vm)
+{
+	struct si4713_device *sdev = to_si4713_device(sd);
+	int rval = 0;
+	u16 stereo, rds;
+	u32 p;
+
+	if (!sdev)
+		return -ENODEV;
+
+	if (vm->index > 0)
+		return -EINVAL;
+
+	/* Set audio mode: mono or stereo */
+	if (vm->txsubchans & V4L2_TUNER_SUB_STEREO)
+		stereo = 1;
+	else if (vm->txsubchans & V4L2_TUNER_SUB_MONO)
+		stereo = 0;
+	else
+		return -EINVAL;
+
+	rds = !!(vm->txsubchans & V4L2_TUNER_SUB_RDS);
+
+	if (sdev->power_state) {
+		rval = si4713_read_property(sdev,
+						SI4713_TX_COMPONENT_ENABLE, &p);
+		if (rval < 0)
+			return rval;
+
+		p = set_bits(p, stereo, 1, 1 << 1);
+		p = set_bits(p, rds, 2, 1 << 2);
+
+		rval = si4713_write_property(sdev,
+						SI4713_TX_COMPONENT_ENABLE, p);
+		if (rval < 0)
+			return rval;
+	}
+
+	sdev->stereo = stereo;
+	sdev->rds_enabled = rds;
+
+	return rval;
+}
+
+/* si4713_g_frequency - get tuner or modulator radio frequency */
+static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+{
+	struct si4713_device *sdev = to_si4713_device(sd);
+	int rval = 0;
+
+	if (f->tuner)
+		return -EINVAL;
+
+	if (sdev->power_state) {
+		u16 freq;
+		u8 p, a, n;
+
+		rval = si4713_tx_tune_status(sdev, 0x00, &freq, &p, &a, &n);
+		if (rval < 0)
+			return rval;
+
+		sdev->frequency = freq;
+	}
+
+	f->frequency = si4713_to_v4l2(sdev->frequency);
+
+	return rval;
+}
+
+/* si4713_s_frequency - set tuner or modulator radio frequency */
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)
+{
+	struct si4713_device *sdev = to_si4713_device(sd);
+	int rval = 0;
+	u16 frequency = v4l2_to_si4713(f->frequency);
+
+	if (f->tuner)
+		return -EINVAL;
+
+	/* Check frequency range */
+	frequency = clamp_t(u16, frequency, FREQ_RANGE_LOW, FREQ_RANGE_HIGH);
+
+	if (sdev->power_state) {
+		rval = si4713_tx_tune_freq(sdev, frequency);
+		if (rval < 0)
+			return rval;
+		frequency = rval;
+		rval = 0;
+	}
+	sdev->frequency = frequency;
+
+	return rval;
+}
+
+static const struct v4l2_ctrl_ops si4713_ctrl_ops = {
+	.s_ctrl = si4713_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops si4713_subdev_core_ops = {
+	.ioctl		= si4713_ioctl,
+};
+
+static const struct v4l2_subdev_tuner_ops si4713_subdev_tuner_ops = {
+	.g_frequency	= si4713_g_frequency,
+	.s_frequency	= si4713_s_frequency,
+	.g_modulator	= si4713_g_modulator,
+	.s_modulator	= si4713_s_modulator,
+};
+
+static const struct v4l2_subdev_ops si4713_subdev_ops = {
+	.core		= &si4713_subdev_core_ops,
+	.tuner		= &si4713_subdev_tuner_ops,
+};
+
+/*
+ * I2C driver interface
+ */
+/* si4713_probe - probe for the device */
+static int si4713_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct si4713_device *sdev;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_ctrl_handler *hdl;
+	int rval, i;
+
+	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
+	if (!sdev) {
+		dev_err(&client->dev, "Failed to alloc video device.\n");
+		rval = -ENOMEM;
+		goto exit;
+	}
+
+	sdev->gpio_reset = -1;
+	if (pdata && gpio_is_valid(pdata->gpio_reset)) {
+		rval = gpio_request(pdata->gpio_reset, "si4713 reset");
+		if (rval) {
+			dev_err(&client->dev,
+				"Failed to request gpio: %d\n", rval);
+			goto free_sdev;
+		}
+		sdev->gpio_reset = pdata->gpio_reset;
+		gpio_direction_output(sdev->gpio_reset, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sdev->supplies); i++)
+		sdev->supplies[i].supply = si4713_supply_names[i];
+
+	rval = regulator_bulk_get(&client->dev, ARRAY_SIZE(sdev->supplies),
+				  sdev->supplies);
+	if (rval) {
+		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
+		goto free_gpio;
+	}
+
+	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
+
+	init_completion(&sdev->work);
+
+	hdl = &sdev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 20);
+	sdev->mute = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, DEFAULT_MUTE);
+
+	sdev->rds_pi = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_PI, 0, 0xffff, 1, DEFAULT_RDS_PI);
+	sdev->rds_pty = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_PTY, 0, 31, 1, DEFAULT_RDS_PTY);
+	sdev->rds_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_DEVIATION, 0, MAX_RDS_DEVIATION,
+			10, DEFAULT_RDS_DEVIATION);
+	/*
+	 * Report step as 8. From RDS spec, psname
+	 * should be 8. But there are receivers which scroll strings
+	 * sized as 8xN.
+	 */
+	sdev->rds_ps_name = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_PS_NAME, 0, MAX_RDS_PS_NAME, 8, 0);
+	/*
+	 * Report step as 32 (2A block). From RDS spec,
+	 * radio text should be 32 for 2A block. But there are receivers
+	 * which scroll strings sized as 32xN. Setting default to 32.
+	 */
+	sdev->rds_radio_text = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_RDS_TX_RADIO_TEXT, 0, MAX_RDS_RADIO_TEXT, 32, 0);
+
+	sdev->limiter_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_LIMITER_ENABLED, 0, 1, 1, 1);
+	sdev->limiter_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_LIMITER_RELEASE_TIME, 250,
+			MAX_LIMITER_RELEASE_TIME, 10, DEFAULT_LIMITER_RTIME);
+	sdev->limiter_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_LIMITER_DEVIATION, 0,
+			MAX_LIMITER_DEVIATION, 10, DEFAULT_LIMITER_DEV);
+
+	sdev->compression_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_COMPRESSION_ENABLED, 0, 1, 1, 1);
+	sdev->compression_gain = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_COMPRESSION_GAIN, 0, MAX_ACOMP_GAIN, 1,
+			DEFAULT_ACOMP_GAIN);
+	sdev->compression_threshold = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THRESHOLD,
+			MAX_ACOMP_THRESHOLD, 1,
+			DEFAULT_ACOMP_THRESHOLD);
+	sdev->compression_attack_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME, 0,
+			MAX_ACOMP_ATTACK_TIME, 500, DEFAULT_ACOMP_ATIME);
+	sdev->compression_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME, 100000,
+			MAX_ACOMP_RELEASE_TIME, 100000, DEFAULT_ACOMP_RTIME);
+
+	sdev->pilot_tone_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_PILOT_TONE_ENABLED, 0, 1, 1, 1);
+	sdev->pilot_tone_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_PILOT_TONE_DEVIATION, 0, MAX_PILOT_DEVIATION,
+			10, DEFAULT_PILOT_DEVIATION);
+	sdev->pilot_tone_freq = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_PILOT_TONE_FREQUENCY, 0, MAX_PILOT_FREQUENCY,
+			1, DEFAULT_PILOT_FREQUENCY);
+
+	sdev->tune_preemphasis = v4l2_ctrl_new_std_menu(hdl, &si4713_ctrl_ops,
+			V4L2_CID_TUNE_PREEMPHASIS,
+			V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
+	sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);
+	sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
+			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, 191, 1, 0);
+
+	if (hdl->error) {
+		rval = hdl->error;
+		goto free_ctrls;
+	}
+	v4l2_ctrl_cluster(20, &sdev->mute);
+	sdev->sd.ctrl_handler = hdl;
+
+	if (client->irq) {
+		rval = request_irq(client->irq,
+			si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			client->name, sdev);
+		if (rval < 0) {
+			v4l2_err(&sdev->sd, "Could not request IRQ\n");
+			goto put_reg;
+		}
+		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
+	} else {
+		v4l2_warn(&sdev->sd, "IRQ not configured. Using timeouts.\n");
+	}
+
+	rval = si4713_initialize(sdev);
+	if (rval < 0) {
+		v4l2_err(&sdev->sd, "Failed to probe device information.\n");
+		goto free_irq;
+	}
+
+	return 0;
+
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, sdev);
+free_ctrls:
+	v4l2_ctrl_handler_free(hdl);
+put_reg:
+	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+free_gpio:
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
+free_sdev:
+	kfree(sdev);
+exit:
+	return rval;
+}
+
+/* si4713_remove - remove the device */
+static int si4713_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct si4713_device *sdev = to_si4713_device(sd);
+
+	if (sdev->power_state)
+		si4713_set_power_state(sdev, POWER_DOWN);
+
+	if (client->irq > 0)
+		free_irq(client->irq, sdev);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
+	kfree(sdev);
+
+	return 0;
+}
+
+/* si4713_i2c_driver - i2c driver interface */
+static const struct i2c_device_id si4713_id[] = {
+	{ "si4713" , 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, si4713_id);
+
+static struct i2c_driver si4713_i2c_driver = {
+	.driver		= {
+		.name	= "si4713",
+	},
+	.probe		= si4713_probe,
+	.remove         = si4713_remove,
+	.id_table       = si4713_id,
+};
+
+module_i2c_driver(si4713_i2c_driver);
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
new file mode 100644
index 0000000..25cdea2
--- /dev/null
+++ b/drivers/media/radio/si4713/si4713.h
@@ -0,0 +1,238 @@
+/*
+ * drivers/media/radio/si4713-i2c.h
+ *
+ * Property and commands definitions for Si4713 radio transmitter chip.
+ *
+ * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
+ * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#ifndef SI4713_I2C_H
+#define SI4713_I2C_H
+
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
+#include <media/si4713.h>
+
+#define SI4713_PRODUCT_NUMBER		0x0D
+
+/* Command Timeouts */
+#define DEFAULT_TIMEOUT			500
+#define TIMEOUT_SET_PROPERTY		20
+#define TIMEOUT_TX_TUNE_POWER		30000
+#define TIMEOUT_TX_TUNE			110000
+#define TIMEOUT_POWER_UP		200000
+
+/*
+ * Command and its arguments definitions
+ */
+#define SI4713_PWUP_CTSIEN		(1<<7)
+#define SI4713_PWUP_GPO2OEN		(1<<6)
+#define SI4713_PWUP_PATCH		(1<<5)
+#define SI4713_PWUP_XOSCEN		(1<<4)
+#define SI4713_PWUP_FUNC_TX		0x02
+#define SI4713_PWUP_FUNC_PATCH		0x0F
+#define SI4713_PWUP_OPMOD_ANALOG	0x50
+#define SI4713_PWUP_OPMOD_DIGITAL	0x0F
+#define SI4713_PWUP_NARGS		2
+#define SI4713_PWUP_NRESP		1
+#define SI4713_CMD_POWER_UP		0x01
+
+#define SI4713_GETREV_NRESP		9
+#define SI4713_CMD_GET_REV		0x10
+
+#define SI4713_PWDN_NRESP		1
+#define SI4713_CMD_POWER_DOWN		0x11
+
+#define SI4713_SET_PROP_NARGS		5
+#define SI4713_SET_PROP_NRESP		1
+#define SI4713_CMD_SET_PROPERTY		0x12
+
+#define SI4713_GET_PROP_NARGS		3
+#define SI4713_GET_PROP_NRESP		4
+#define SI4713_CMD_GET_PROPERTY		0x13
+
+#define SI4713_GET_STATUS_NRESP		1
+#define SI4713_CMD_GET_INT_STATUS	0x14
+
+#define SI4713_CMD_PATCH_ARGS		0x15
+#define SI4713_CMD_PATCH_DATA		0x16
+
+#define SI4713_MAX_FREQ			10800
+#define SI4713_MIN_FREQ			7600
+#define SI4713_TXFREQ_NARGS		3
+#define SI4713_TXFREQ_NRESP		1
+#define SI4713_CMD_TX_TUNE_FREQ		0x30
+
+#define SI4713_MAX_POWER		120
+#define SI4713_MIN_POWER		88
+#define SI4713_MAX_ANTCAP		191
+#define SI4713_MIN_ANTCAP		0
+#define SI4713_TXPWR_NARGS		4
+#define SI4713_TXPWR_NRESP		1
+#define SI4713_CMD_TX_TUNE_POWER	0x31
+
+#define SI4713_TXMEA_NARGS		4
+#define SI4713_TXMEA_NRESP		1
+#define SI4713_CMD_TX_TUNE_MEASURE	0x32
+
+#define SI4713_INTACK_MASK		0x01
+#define SI4713_TXSTATUS_NARGS		1
+#define SI4713_TXSTATUS_NRESP		8
+#define SI4713_CMD_TX_TUNE_STATUS	0x33
+
+#define SI4713_OVERMOD_BIT		(1 << 2)
+#define SI4713_IALH_BIT			(1 << 1)
+#define SI4713_IALL_BIT			(1 << 0)
+#define SI4713_ASQSTATUS_NARGS		1
+#define SI4713_ASQSTATUS_NRESP		5
+#define SI4713_CMD_TX_ASQ_STATUS	0x34
+
+#define SI4713_RDSBUFF_MODE_MASK	0x87
+#define SI4713_RDSBUFF_NARGS		7
+#define SI4713_RDSBUFF_NRESP		6
+#define SI4713_CMD_TX_RDS_BUFF		0x35
+
+#define SI4713_RDSPS_PSID_MASK		0x1F
+#define SI4713_RDSPS_NARGS		5
+#define SI4713_RDSPS_NRESP		1
+#define SI4713_CMD_TX_RDS_PS		0x36
+
+#define SI4713_CMD_GPO_CTL		0x80
+#define SI4713_CMD_GPO_SET		0x81
+
+/*
+ * Bits from status response
+ */
+#define SI4713_CTS			(1<<7)
+#define SI4713_ERR			(1<<6)
+#define SI4713_RDS_INT			(1<<2)
+#define SI4713_ASQ_INT			(1<<1)
+#define SI4713_STC_INT			(1<<0)
+
+/*
+ * Property definitions
+ */
+#define SI4713_GPO_IEN			0x0001
+#define SI4713_DIG_INPUT_FORMAT		0x0101
+#define SI4713_DIG_INPUT_SAMPLE_RATE	0x0103
+#define SI4713_REFCLK_FREQ		0x0201
+#define SI4713_REFCLK_PRESCALE		0x0202
+#define SI4713_TX_COMPONENT_ENABLE	0x2100
+#define SI4713_TX_AUDIO_DEVIATION	0x2101
+#define SI4713_TX_PILOT_DEVIATION	0x2102
+#define SI4713_TX_RDS_DEVIATION		0x2103
+#define SI4713_TX_LINE_INPUT_LEVEL	0x2104
+#define SI4713_TX_LINE_INPUT_MUTE	0x2105
+#define SI4713_TX_PREEMPHASIS		0x2106
+#define SI4713_TX_PILOT_FREQUENCY	0x2107
+#define SI4713_TX_ACOMP_ENABLE		0x2200
+#define SI4713_TX_ACOMP_THRESHOLD	0x2201
+#define SI4713_TX_ACOMP_ATTACK_TIME	0x2202
+#define SI4713_TX_ACOMP_RELEASE_TIME	0x2203
+#define SI4713_TX_ACOMP_GAIN		0x2204
+#define SI4713_TX_LIMITER_RELEASE_TIME	0x2205
+#define SI4713_TX_ASQ_INTERRUPT_SOURCE	0x2300
+#define SI4713_TX_ASQ_LEVEL_LOW		0x2301
+#define SI4713_TX_ASQ_DURATION_LOW	0x2302
+#define SI4713_TX_ASQ_LEVEL_HIGH	0x2303
+#define SI4713_TX_ASQ_DURATION_HIGH	0x2304
+#define SI4713_TX_RDS_INTERRUPT_SOURCE	0x2C00
+#define SI4713_TX_RDS_PI		0x2C01
+#define SI4713_TX_RDS_PS_MIX		0x2C02
+#define SI4713_TX_RDS_PS_MISC		0x2C03
+#define SI4713_TX_RDS_PS_REPEAT_COUNT	0x2C04
+#define SI4713_TX_RDS_PS_MESSAGE_COUNT	0x2C05
+#define SI4713_TX_RDS_PS_AF		0x2C06
+#define SI4713_TX_RDS_FIFO_SIZE		0x2C07
+
+#define PREEMPHASIS_USA			75
+#define PREEMPHASIS_EU			50
+#define PREEMPHASIS_DISABLED		0
+#define FMPE_USA			0x00
+#define FMPE_EU				0x01
+#define FMPE_DISABLED			0x02
+
+#define POWER_UP			0x01
+#define POWER_DOWN			0x00
+
+#define MAX_RDS_PTY			31
+#define MAX_RDS_DEVIATION		90000
+
+/*
+ * PSNAME is known to be defined as 8 character sized (RDS Spec).
+ * However, there is receivers which scroll PSNAME 8xN sized.
+ */
+#define MAX_RDS_PS_NAME			96
+
+/*
+ * MAX_RDS_RADIO_TEXT is known to be defined as 32 (2A group) or 64 (2B group)
+ * character sized (RDS Spec).
+ * However, there is receivers which scroll them as well.
+ */
+#define MAX_RDS_RADIO_TEXT		384
+
+#define MAX_LIMITER_RELEASE_TIME	102390
+#define MAX_LIMITER_DEVIATION		90000
+
+#define MAX_PILOT_DEVIATION		90000
+#define MAX_PILOT_FREQUENCY		19000
+
+#define MAX_ACOMP_RELEASE_TIME		1000000
+#define MAX_ACOMP_ATTACK_TIME		5000
+#define MAX_ACOMP_THRESHOLD		0
+#define MIN_ACOMP_THRESHOLD		(-40)
+#define MAX_ACOMP_GAIN			20
+
+#define SI4713_NUM_SUPPLIES		2
+
+/*
+ * si4713_device - private data
+ */
+struct si4713_device {
+	/* v4l2_subdev and i2c reference (v4l2_subdev priv data) */
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* private data structures */
+	struct { /* si4713 control cluster */
+		/* This is one big cluster since the mute control
+		 * powers off the device and after unmuting again all
+		 * controls need to be set at once. The only way of doing
+		 * that is by making it one big cluster. */
+		struct v4l2_ctrl *mute;
+		struct v4l2_ctrl *rds_ps_name;
+		struct v4l2_ctrl *rds_radio_text;
+		struct v4l2_ctrl *rds_pi;
+		struct v4l2_ctrl *rds_deviation;
+		struct v4l2_ctrl *rds_pty;
+		struct v4l2_ctrl *compression_enabled;
+		struct v4l2_ctrl *compression_threshold;
+		struct v4l2_ctrl *compression_gain;
+		struct v4l2_ctrl *compression_attack_time;
+		struct v4l2_ctrl *compression_release_time;
+		struct v4l2_ctrl *pilot_tone_enabled;
+		struct v4l2_ctrl *pilot_tone_freq;
+		struct v4l2_ctrl *pilot_tone_deviation;
+		struct v4l2_ctrl *limiter_enabled;
+		struct v4l2_ctrl *limiter_deviation;
+		struct v4l2_ctrl *limiter_release_time;
+		struct v4l2_ctrl *tune_preemphasis;
+		struct v4l2_ctrl *tune_pwr_level;
+		struct v4l2_ctrl *tune_ant_cap;
+	};
+	struct completion work;
+	struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
+	int gpio_reset;
+	u32 power_state;
+	u32 rds_enabled;
+	u32 frequency;
+	u32 preemphasis;
+	u32 stereo;
+	u32 tune_rnl;
+};
+#endif /* ifndef SI4713_I2C_H */
-- 
1.8.4.rc2

