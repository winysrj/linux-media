Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44043 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754650Ab0C2HpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 03:45:20 -0400
Date: Mon, 29 Mar 2010 09:45:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 2/3 v3] V4L: v4l2-subdev driver for AK8813 and AK8814
 TV-encoders from AKM
In-Reply-To: <Pine.LNX.4.64.1003290936280.4417@axis700.grange>
Message-ID: <Pine.LNX.4.64.1003290939560.4417@axis700.grange>
References: <Pine.LNX.4.64.1003290936280.4417@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AK8814 only differs from AK8813 by included Macrovision Copy Protection
function. This patch adds a driver for AK8813 and AK8814 I2C PAL/NTSC TV
encoders.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2 -> v3:

1. changed .s_std() method to also support multi-bit standards (thanks, 
   Hans)

 drivers/media/video/Kconfig     |    6 +
 drivers/media/video/Makefile    |    2 +
 drivers/media/video/ak881x.c    |  368 +++++++++++++++++++++++++++++++++++++++
 include/media/ak881x.h          |   25 +++
 include/media/v4l2-chip-ident.h |    4 +
 5 files changed, 405 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ak881x.c
 create mode 100644 include/media/ak881x.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 503dffa..09cdd57 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -480,6 +480,12 @@ config VIDEO_ADV7343
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7343.
 
+config VIDEO_AK881X
+	tristate "AK8813/AK8814 video encoders"
+	depends on I2C
+	help
+	  Video output driver for AKM AK8813 and AK8814 TV encoders
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ed52b6b..4555f5f 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -151,6 +151,8 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
+
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
new file mode 100644
index 0000000..35390d4
--- /dev/null
+++ b/drivers/media/video/ak881x.c
@@ -0,0 +1,368 @@
+/*
+ * Driver for AK8813 / AK8814 TV-ecoders from Asahi Kasei Microsystems Co., Ltd. (AKM)
+ *
+ * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+
+#include <media/ak881x.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+
+#define AK881X_INTERFACE_MODE	0
+#define AK881X_VIDEO_PROCESS1	1
+#define AK881X_VIDEO_PROCESS2	2
+#define AK881X_VIDEO_PROCESS3	3
+#define AK881X_DAC_MODE		5
+#define AK881X_STATUS		0x24
+#define AK881X_DEVICE_ID	0x25
+#define AK881X_DEVICE_REVISION	0x26
+
+struct ak881x {
+	struct v4l2_subdev subdev;
+	struct ak881x_pdata *pdata;
+	unsigned int lines;
+	int id;	/* DEVICE_ID code V4L2_IDENT_AK881X code from v4l2-chip-ident.h */
+	char revision;	/* DEVICE_REVISION content */
+};
+
+static int reg_read(struct i2c_client *client, const u8 reg)
+{
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int reg_write(struct i2c_client *client, const u8 reg,
+		     const u8 data)
+{
+	return i2c_smbus_write_byte_data(client, reg, data);
+}
+
+static int reg_set(struct i2c_client *client, const u8 reg,
+		   const u8 data, u8 mask)
+{
+	int ret = reg_read(client, reg);
+	if (ret < 0)
+		return ret;
+	return reg_write(client, reg, (ret & ~mask) | (data & mask));
+}
+
+static struct ak881x *to_ak881x(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct ak881x, subdev);
+}
+
+static int ak881x_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ak881x *ak881x = to_ak881x(client);
+
+	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
+
+	if (id->match.addr != client->addr)
+		return -ENODEV;
+
+	id->ident	= ak881x->id;
+	id->revision	= ak881x->revision;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ak881x_g_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
+		return -EINVAL;
+
+	if (reg->match.addr != client->addr)
+		return -ENODEV;
+
+	reg->val = reg_read(client, reg->reg);
+
+	if (reg->val > 0xffff)
+		return -EIO;
+
+	return 0;
+}
+
+static int ak881x_s_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
+		return -EINVAL;
+
+	if (reg->match.addr != client->addr)
+		return -ENODEV;
+
+	if (reg_write(client, reg->reg, reg->val) < 0)
+		return -EIO;
+
+	return 0;
+}
+#endif
+
+static int ak881x_try_g_mbus_fmt(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ak881x *ak881x = to_ak881x(client);
+
+	v4l_bound_align_image(&mf->width, 0, 720, 2,
+			      &mf->height, 0, ak881x->lines, 1, 0);
+	mf->field	= V4L2_FIELD_INTERLACED;
+	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8_LE;
+	mf->colorspace	= V4L2_COLORSPACE_SMPTE170M;
+
+	return 0;
+}
+
+static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_framefmt *mf)
+{
+	if (mf->field != V4L2_FIELD_INTERLACED ||
+	    mf->code != V4L2_MBUS_FMT_YUYV8_2X8_LE)
+		return -EINVAL;
+
+	return ak881x_try_g_mbus_fmt(sd, mf);
+}
+
+static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, int index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_YUYV8_2X8_LE;
+	return 0;
+}
+
+static int ak881x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ak881x *ak881x = to_ak881x(client);
+
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= 720;
+	a->bounds.height		= ak881x->lines;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ak881x *ak881x = to_ak881x(client);
+	u8 vp1;
+
+	if (std == V4L2_STD_NTSC_443) {
+		vp1 = 3;
+		ak881x->lines = 480;
+	} else if (std == V4L2_STD_PAL_M) {
+		vp1 = 5;
+		ak881x->lines = 480;
+	} else if (std == V4L2_STD_PAL_60) {
+		vp1 = 7;
+		ak881x->lines = 480;
+	} else if (std && !(std & ~V4L2_STD_PAL)) {
+		vp1 = 0xf;
+		ak881x->lines = 576;
+	} else if (std && !(std & ~V4L2_STD_NTSC)) {
+		vp1 = 0;
+		ak881x->lines = 480;
+	} else {
+		/* No SECAM or PAL_N/Nc supported */
+		return -EINVAL;
+	}
+
+	reg_set(client, AK881X_VIDEO_PROCESS1, vp1, 0xf);
+
+	return 0;
+}
+
+static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ak881x *ak881x = to_ak881x(client);
+
+	if (enable) {
+		u8 dac;
+		/* For colour-bar testing set bit 6 of AK881X_VIDEO_PROCESS1 */
+		/* Default: composite output */
+		if (ak881x->pdata->flags & AK881X_COMPONENT)
+			dac = 3;
+		else
+			dac = 4;
+		/* Turn on the DAC(s) */
+		reg_write(client, AK881X_DAC_MODE, dac);
+		dev_dbg(&client->dev, "chip status 0x%x\n",
+			reg_read(client, AK881X_STATUS));
+	} else {
+		/* ...and clear bit 6 of AK881X_VIDEO_PROCESS1 here */
+		reg_write(client, AK881X_DAC_MODE, 0);
+		dev_dbg(&client->dev, "chip status 0x%x\n",
+			reg_read(client, AK881X_STATUS));
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
+	.g_chip_ident	= ak881x_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= ak881x_g_register,
+	.s_register	= ak881x_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
+	.s_mbus_fmt	= ak881x_s_mbus_fmt,
+	.g_mbus_fmt	= ak881x_try_g_mbus_fmt,
+	.try_mbus_fmt	= ak881x_try_g_mbus_fmt,
+	.cropcap	= ak881x_cropcap,
+	.enum_mbus_fmt	= ak881x_enum_mbus_fmt,
+	.s_std_output	= ak881x_s_std_output,
+	.s_stream	= ak881x_s_stream,
+};
+
+static struct v4l2_subdev_ops ak881x_subdev_ops = {
+	.core	= &ak881x_subdev_core_ops,
+	.video	= &ak881x_subdev_video_ops,
+};
+
+static int ak881x_probe(struct i2c_client *client,
+			const struct i2c_device_id *did)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct ak881x *ak881x;
+	u8 ifmode, data;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_warn(&adapter->dev,
+			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
+		return -EIO;
+	}
+
+	ak881x = kzalloc(sizeof(struct ak881x), GFP_KERNEL);
+	if (!ak881x)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&ak881x->subdev, client, &ak881x_subdev_ops);
+
+	data = reg_read(client, AK881X_DEVICE_ID);
+
+	switch (data) {
+	case 0x13:
+		ak881x->id = V4L2_IDENT_AK8813;
+		break;
+	case 0x14:
+		ak881x->id = V4L2_IDENT_AK8814;
+		break;
+	default:
+		dev_err(&client->dev,
+			"No ak881x chip detected, register read %x\n", data);
+		kfree(ak881x);
+		return -ENODEV;
+	}
+
+	ak881x->revision = reg_read(client, AK881X_DEVICE_REVISION);
+	ak881x->pdata = client->dev.platform_data;
+
+	if (ak881x->pdata) {
+		if (ak881x->pdata->flags & AK881X_FIELD)
+			ifmode = 4;
+		else
+			ifmode = 0;
+
+		switch (ak881x->pdata->flags & AK881X_IF_MODE_MASK) {
+		case AK881X_IF_MODE_BT656:
+			ifmode |= 1;
+			break;
+		case AK881X_IF_MODE_MASTER:
+			ifmode |= 2;
+			break;
+		case AK881X_IF_MODE_SLAVE:
+		default:
+			break;
+		}
+
+		dev_dbg(&client->dev, "IF mode %x\n", ifmode);
+
+		/*
+		 * "Line Blanking No." seems to be the same as the number of
+		 * "black" lines on, e.g., SuperH VOU, whose default value of 20
+		 * "incidentally" matches ak881x' default
+		 */
+		reg_write(client, AK881X_INTERFACE_MODE, ifmode | (20 << 3));
+	}
+
+	/* Hardware default: NTSC-M */
+	ak881x->lines = 480;
+
+	dev_info(&client->dev, "Detected an ak881x chip ID %x, revision %x\n",
+		 data, ak881x->revision);
+
+	return 0;
+}
+
+static int ak881x_remove(struct i2c_client *client)
+{
+	struct ak881x *ak881x = to_ak881x(client);
+
+	v4l2_device_unregister_subdev(&ak881x->subdev);
+	kfree(ak881x);
+
+	return 0;
+}
+
+static const struct i2c_device_id ak881x_id[] = {
+	{ "ak8813", 0 },
+	{ "ak8814", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ak881x_id);
+
+static struct i2c_driver ak881x_i2c_driver = {
+	.driver = {
+		.name = "ak881x",
+	},
+	.probe		= ak881x_probe,
+	.remove		= ak881x_remove,
+	.id_table	= ak881x_id,
+};
+
+static int __init ak881x_module_init(void)
+{
+	return i2c_add_driver(&ak881x_i2c_driver);
+}
+
+static void __exit ak881x_module_exit(void)
+{
+	i2c_del_driver(&ak881x_i2c_driver);
+}
+
+module_init(ak881x_module_init);
+module_exit(ak881x_module_exit);
+
+MODULE_DESCRIPTION("TV-output driver for ak8813/ak8814");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/ak881x.h b/include/media/ak881x.h
new file mode 100644
index 0000000..b7f2add
--- /dev/null
+++ b/include/media/ak881x.h
@@ -0,0 +1,25 @@
+/*
+ * Header for AK8813 / AK8814 TV-ecoders from Asahi Kasei Microsystems Co., Ltd. (AKM)
+ *
+ * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AK881X_H
+#define AK881X_H
+
+#define AK881X_IF_MODE_MASK	(3 << 0)
+#define AK881X_IF_MODE_BT656	(0 << 0)
+#define AK881X_IF_MODE_MASTER	(1 << 0)
+#define AK881X_IF_MODE_SLAVE	(2 << 0)
+#define AK881X_FIELD		(1 << 2)
+#define AK881X_COMPONENT	(1 << 3)
+
+struct ak881x_pdata {
+	unsigned long flags;
+};
+
+#endif
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index bf937d3..2b70523 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -178,6 +178,10 @@ enum {
 	/* module cafe_ccic, just ident 8801 */
 	V4L2_IDENT_CAFE = 8801,
 
+	/* AKM AK8813/AK8814 */
+	V4L2_IDENT_AK8813 = 8813,
+	V4L2_IDENT_AK8814 = 8814,
+
 	/* module cx23885 and cx25840 */
 	V4L2_IDENT_CX23885    = 8850,
 	V4L2_IDENT_CX23885_AV = 8851, /* Integrated A/V decoder */
-- 
1.6.2.4

