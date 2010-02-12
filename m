Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway13.websitewelcome.com ([67.18.22.80]:44233 "HELO
	gateway13.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307Ab0BLDUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 22:20:11 -0500
Received: from [66.15.212.169] (port=10321 helo=[10.140.5.12])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1NfjTN-0005mH-UA
	for linux-media@vger.kernel.org; Thu, 11 Feb 2010 18:33:30 -0600
Subject: [PATCH 3/5] tw2804: video decoder subdev conversion
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 16:33:12 -0800
Message-Id: <1265934792.4626.252.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

This is a subdev conversion of wis-tw2804 video decoder from the
staging go7007 directory.  This obsoletes the wis-tw2804 driver.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r f7edcbfeb63c -r 024987c00f06 linux/drivers/media/video/Kconfig
--- a/linux/drivers/media/video/Kconfig	Wed Feb 10 15:06:05 2010 -0800
+++ b/linux/drivers/media/video/Kconfig	Thu Feb 11 14:34:39 2010 -0800
@@ -368,6 +368,12 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7191.
 
+config VIDEO_TW2804
+	tristate "Techwell 2804 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Techwell 2804 video decoder.
+
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
diff -r f7edcbfeb63c -r 024987c00f06 linux/drivers/media/video/Makefile
--- a/linux/drivers/media/video/Makefile	Wed Feb 10 15:06:05 2010 -0800
+++ b/linux/drivers/media/video/Makefile	Thu Feb 11 14:34:39 2010 -0800
@@ -71,6 +71,7 @@
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
+obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
 
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
diff -r f7edcbfeb63c -r 024987c00f06 linux/drivers/media/video/tw2804.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/tw2804.c	Thu Feb 11 14:34:39 2010 -0800
@@ -0,0 +1,398 @@
+/*
+ * Copyright (C) 2005-2006 Micronas USA Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <linux/ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-i2c-drv.h>
+
+MODULE_DESCRIPTION("TW2804 I2C subdev driver");
+MODULE_LICENSE("GPL v2");
+
+struct tw2804 {
+	struct v4l2_subdev sd;
+	int channel;
+	v4l2_std_id norm;
+	int brightness;
+	int contrast;
+	int saturation;
+	int hue;
+};
+
+static inline struct tw2804 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tw2804, sd);
+}
+
+static u8 global_registers[] =
+{
+	0x39, 0x00,
+	0x3a, 0xff,
+	0x3b, 0x84,
+	0x3c, 0x80,
+	0x3d, 0x80,
+	0x3e, 0x82,
+	0x3f, 0x82,
+	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
+};
+
+static u8 channel_registers[] =
+{
+	0x01, 0xc4,
+	0x02, 0xa5,
+	0x03, 0x20,
+	0x04, 0xd0,
+	0x05, 0x20,
+	0x06, 0xd0,
+	0x07, 0x88,
+	0x08, 0x20,
+	0x09, 0x07,
+	0x0a, 0xf0,
+	0x0b, 0x07,
+	0x0c, 0xf0,
+	0x0d, 0x40,
+	0x0e, 0xd2,
+	0x0f, 0x80,
+	0x10, 0x80,
+	0x11, 0x80,
+	0x12, 0x80,
+	0x13, 0x1f,
+	0x14, 0x00,
+	0x15, 0x00,
+	0x16, 0x00,
+	0x17, 0x00,
+	0x18, 0xff,
+	0x19, 0xff,
+	0x1a, 0xff,
+	0x1b, 0xff,
+	0x1c, 0xff,
+	0x1d, 0xff,
+	0x1e, 0xff,
+	0x1f, 0xff,
+	0x20, 0x07,
+	0x21, 0x07,
+	0x22, 0x00,
+	0x23, 0x91,
+	0x24, 0x51,
+	0x25, 0x03,
+	0x26, 0x00,
+	0x27, 0x00,
+	0x28, 0x00,
+	0x29, 0x00,
+	0x2a, 0x00,
+	0x2b, 0x00,
+	0x2c, 0x00,
+	0x2d, 0x00,
+	0x2e, 0x00,
+	0x2f, 0x00,
+	0x30, 0x00,
+	0x31, 0x00,
+	0x32, 0x00,
+	0x33, 0x00,
+	0x34, 0x00,
+	0x35, 0x00,
+	0x36, 0x00,
+	0x37, 0x00,
+	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
+};
+
+static int write_reg(struct v4l2_subdev *sd, u8 reg, u8 value, int channel)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
+}
+
+static int write_regs(struct v4l2_subdev *sd, u8 *regs, int channel)
+{
+	int i;
+
+	for (i = 0; regs[i] != 0xff; i += 2)
+		if (write_reg(sd, regs[i], regs[i + 1], channel) < 0)
+			return -1;
+	return 0;
+}
+
+static int tw2804_s_config(struct v4l2_subdev *sd,
+			       const struct v4l2_priv_tun_config *config)
+{
+	struct tw2804 *dec = to_state(sd);
+	int channel;
+
+	if (config->tuner != 2804)
+		return 0;
+
+	channel = *(int*)config->priv;
+	if (channel < 0 || channel > 3) {
+		v4l2_err(sd, "channel %d is not between 0 and 3!\n", channel);
+		return 0;
+	}
+	dec->channel = channel;
+
+	v4l2_info(sd, "initializing TW2804 channel %d\n", dec->channel);
+	if (dec->channel == 0 && write_regs(sd, global_registers, 0) < 0) {
+		v4l2_err(sd, "error initializing TW2804 global registers\n");
+		return 0;
+	}
+	if (write_regs(sd, channel_registers, dec->channel) < 0) {
+		v4l2_err(sd, "error initializing TW2804 channel %d\n",
+			dec->channel);
+		return 0;
+	}
+	return 0;
+}
+
+
+static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct tw2804 *dec = to_state(sd);
+	u8 regs[] = {
+		0x01, norm & V4L2_STD_NTSC ? 0xc4 : 0x84,
+		0x09, norm & V4L2_STD_NTSC ? 0x07 : 0x04,
+		0x0a, norm & V4L2_STD_NTSC ? 0xf0 : 0x20,
+		0x0b, norm & V4L2_STD_NTSC ? 0x07 : 0x04,
+		0x0c, norm & V4L2_STD_NTSC ? 0xf0 : 0x20,
+		0x0d, norm & V4L2_STD_NTSC ? 0x40 : 0x4a,
+		0x16, norm & V4L2_STD_NTSC ? 0x00 : 0x40,
+		0x17, norm & V4L2_STD_NTSC ? 0x00 : 0x40,
+		0x20, norm & V4L2_STD_NTSC ? 0x07 : 0x0f,
+		0x21, norm & V4L2_STD_NTSC ? 0x07 : 0x0f,
+		0xff,	0xff,
+		};
+
+	if (dec->channel < 0) {
+		v4l2_err(sd, "ignoring command s_std until channel number "
+			"is set\n");
+		return 0;
+	}
+
+	write_regs(sd, regs, dec->channel);
+	dec->norm = norm;
+	return 0;
+}
+
+static int tw2804_queryctrl(struct v4l2_subdev *sd,
+				 struct v4l2_queryctrl *query)
+{
+	static const u32 user_ctrls[] = {
+		V4L2_CID_BRIGHTNESS,
+		V4L2_CID_CONTRAST,
+		V4L2_CID_SATURATION,
+		V4L2_CID_HUE,
+		0
+	};
+	static const u32 *ctrl_classes[] = {
+		user_ctrls,
+		NULL
+	};
+
+	query->id = v4l2_ctrl_next(ctrl_classes, query->id);
+	switch (query->id) {
+	case V4L2_CID_BRIGHTNESS:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_CONTRAST:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_SATURATION:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_HUE:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
+static int tw2804_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct tw2804 *dec = to_state(sd);
+
+	if (dec->channel < 0) {
+		v4l2_err(sd, "ignoring command s_ctrl until channel number "
+			"is set\n");
+		return 0;
+	}
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (ctrl->value > 255)
+			dec->brightness = 255;
+		else if (ctrl->value < 0)
+			dec->brightness = 0;
+		else
+			dec->brightness = ctrl->value;
+		write_reg(sd, 0x12, dec->brightness, dec->channel);
+		break;
+	case V4L2_CID_CONTRAST:
+		if (ctrl->value > 255)
+			dec->contrast = 255;
+		else if (ctrl->value < 0)
+			dec->contrast = 0;
+		else
+			dec->contrast = ctrl->value;
+		write_reg(sd, 0x11, dec->contrast, dec->channel);
+		break;
+	case V4L2_CID_SATURATION:
+		if (ctrl->value > 255)
+			dec->saturation = 255;
+		else if (ctrl->value < 0)
+			dec->saturation = 0;
+		else
+			dec->saturation = ctrl->value;
+		write_reg(sd, 0x10, dec->saturation, dec->channel);
+		break;
+	case V4L2_CID_HUE:
+		if (ctrl->value > 255)
+			dec->hue = 255;
+		else if (ctrl->value < 0)
+			dec->hue = 0;
+		else
+			dec->hue = ctrl->value;
+		write_reg(sd, 0x0f, dec->hue, dec->channel);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tw2804_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct tw2804 *dec = to_state(sd);
+
+	if (dec->channel < 0) {
+		v4l2_err(sd, "ignoring command g_ctrl until channel number "
+			"is set\n");
+		return 0;
+	}
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = dec->brightness;
+		break;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = dec->contrast;
+		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = dec->saturation;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = dec->hue;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd)
+{
+	struct tw2804 *dec = to_state(sd);
+
+	v4l2_info(sd, "Channel: %d\n", dec->channel);
+	v4l2_info(sd, "Standard: %s\n", dec->norm == V4L2_STD_NTSC ? "NTSC" :
+					dec->norm == V4L2_STD_PAL ? "PAL" :
+					dec->norm == V4L2_STD_SECAM ? "SECAM" :
+					"unknown");
+	v4l2_info(sd, "Brightness: %d\n", dec->brightness);
+	v4l2_info(sd, "Contrast: %d\n", dec->contrast);
+	v4l2_info(sd, "Saturation: %d\n", dec->saturation);
+	v4l2_info(sd, "Hue: %d\n", dec->hue);
+	return 0;
+}
+
+/* --------------------------------------------------------------------------*/
+
+static const struct v4l2_subdev_core_ops tw2804_core_ops = {
+	.log_status = tw2804_log_status,
+	.g_ctrl = tw2804_g_ctrl,
+	.s_ctrl = tw2804_s_ctrl,
+	.queryctrl = tw2804_queryctrl,
+	.s_std = tw2804_s_std,
+};
+
+static const struct v4l2_subdev_tuner_ops tw2804_tuner_ops = {
+	.s_config = tw2804_s_config,
+};
+
+static const struct v4l2_subdev_ops tw2804_ops = {
+	.core = &tw2804_core_ops,
+	.tuner = &tw2804_tuner_ops,
+};
+
+/* --------------------------------------------------------------------------*/
+
+static int tw2804_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	struct tw2804 *dec;
+	struct v4l2_subdev *sd;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	v4l2_info(client, "initializing TW2804 at address 0x%x on %s\n",
+		client->addr, client->adapter->name);
+
+	dec = kmalloc(sizeof(struct tw2804), GFP_KERNEL);
+	if (dec == NULL)
+		return -ENOMEM;
+	sd = &dec->sd;
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+
+	/* Initialize tw2804 */
+	dec->channel = -1;
+	dec->norm = V4L2_STD_NTSC;
+	dec->brightness = 128;
+	dec->contrast = 128;
+	dec->saturation = 128;
+	dec->hue = 128;
+
+	return 0;
+}
+
+static int tw2804_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+static const struct i2c_device_id tw2804_id[] = {
+	{ "tw2804", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tw2804_id);
+#endif
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+	.name = "tw2804",
+	.probe = tw2804_probe,
+	.remove = tw2804_remove,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+	.id_table = tw2804_id,
+#endif
+};
diff -r f7edcbfeb63c -r 024987c00f06 linux/drivers/staging/go7007/go7007-usb.c
--- a/linux/drivers/staging/go7007/go7007-usb.c	Wed Feb 10 15:06:05 2010 -0800
+++ b/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 14:34:39 2010 -0800
@@ -386,7 +386,7 @@
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_tw2804",
+				.type	= "tw2804",
 				.addr	= 0x00, /* yes, really */
 			},
 		},

