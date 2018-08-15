Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40250 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbeHOQWU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:22:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15-v6so1135597wrs.7
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:30:06 -0700 (PDT)
From: petrcvekcz@gmail.com
To: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of soc_camera
Date: Wed, 15 Aug 2018 15:30:24 +0200
Message-Id: <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1534339750.git.petrcvekcz@gmail.com>
References: <cover.1534339750.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

Initial part of ov9640 transition from soc_camera subsystem to a standalone
v4l2 subdevice. The soc_camera version seems to be used only in Palm Zire72
and in (the future) HTC Magician. On these two devices the support is
broken as pxa_camera driver doesn't use soc_camera anymore. The other
mentions from git grep are "TODOs" (in board-osk.c) or chip names for
unsupported sensors on HW which doesn't use soc_camera at all (irelevant).

Copy the driver files from soc_camera and mark the original ones in the
Kconfig description as obsoleted.

Add config option VIDEO_OV9640 to the build files in drivers/media/i2c.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/Kconfig            |   7 +
 drivers/media/i2c/Makefile           |   1 +
 drivers/media/i2c/ov9640.c           | 739 +++++++++++++++++++++++++++
 drivers/media/i2c/ov9640.h           | 208 ++++++++
 drivers/media/i2c/soc_camera/Kconfig |   6 +-
 5 files changed, 959 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/i2c/ov9640.c
 create mode 100644 drivers/media/i2c/ov9640.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 439f6be08b95..c948b163a567 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -771,6 +771,13 @@ config VIDEO_OV7740
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7740 VGA camera sensor.
 
+config VIDEO_OV9640
+	tristate "OmniVision OV9640 sensor support"
+	depends on I2C && VIDEO_V4L2
+	help
+	  This is a Video4Linux2 sensor driver for the OmniVision
+	  OV9640 camera sensor.
+
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 837c428339df..9cc951f9c041 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
 obj-$(CONFIG_VIDEO_OV7740) += ov7740.o
+obj-$(CONFIG_VIDEO_OV9640) += ov9640.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
 obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
new file mode 100644
index 000000000000..c63948989688
--- /dev/null
+++ b/drivers/media/i2c/ov9640.c
@@ -0,0 +1,739 @@
+/*
+ * OmniVision OV96xx Camera Driver
+ *
+ * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * Based on ov772x camera driver:
+ *
+ * Copyright (C) 2008 Renesas Solutions Corp.
+ * Kuninori Morimoto <morimoto.kuninori@renesas.com>
+ *
+ * Based on ov7670 and soc_camera_platform driver,
+ *
+ * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
+ * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/videodev2.h>
+
+#include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+
+#include "ov9640.h"
+
+#define to_ov9640_sensor(sd)	container_of(sd, struct ov9640_priv, subdev)
+
+/* default register setup */
+static const struct ov9640_reg ov9640_regs_dflt[] = {
+	{ OV9640_COM5,	OV9640_COM5_SYSCLK | OV9640_COM5_LONGEXP },
+	{ OV9640_COM6,	OV9640_COM6_OPT_BLC | OV9640_COM6_ADBLC_BIAS |
+			OV9640_COM6_FMT_RST | OV9640_COM6_ADBLC_OPTEN },
+	{ OV9640_PSHFT,	OV9640_PSHFT_VAL(0x01) },
+	{ OV9640_ACOM,	OV9640_ACOM_2X_ANALOG | OV9640_ACOM_RSVD },
+	{ OV9640_TSLB,	OV9640_TSLB_YUYV_UYVY },
+	{ OV9640_COM16,	OV9640_COM16_RB_AVG },
+
+	/* Gamma curve P */
+	{ 0x6c, 0x40 },	{ 0x6d, 0x30 },	{ 0x6e, 0x4b },	{ 0x6f, 0x60 },
+	{ 0x70, 0x70 },	{ 0x71, 0x70 },	{ 0x72, 0x70 },	{ 0x73, 0x70 },
+	{ 0x74, 0x60 },	{ 0x75, 0x60 },	{ 0x76, 0x50 },	{ 0x77, 0x48 },
+	{ 0x78, 0x3a },	{ 0x79, 0x2e },	{ 0x7a, 0x28 },	{ 0x7b, 0x22 },
+
+	/* Gamma curve T */
+	{ 0x7c, 0x04 },	{ 0x7d, 0x07 },	{ 0x7e, 0x10 },	{ 0x7f, 0x28 },
+	{ 0x80, 0x36 },	{ 0x81, 0x44 },	{ 0x82, 0x52 },	{ 0x83, 0x60 },
+	{ 0x84, 0x6c },	{ 0x85, 0x78 },	{ 0x86, 0x8c },	{ 0x87, 0x9e },
+	{ 0x88, 0xbb },	{ 0x89, 0xd2 },	{ 0x8a, 0xe6 },
+};
+
+/* Configurations
+ * NOTE: for YUV, alter the following registers:
+ *		COM12 |= OV9640_COM12_YUV_AVG
+ *
+ *	 for RGB, alter the following registers:
+ *		COM7  |= OV9640_COM7_RGB
+ *		COM13 |= OV9640_COM13_RGB_AVG
+ *		COM15 |= proper RGB color encoding mode
+ */
+static const struct ov9640_reg ov9640_regs_qqcif[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x0f) },
+	{ OV9640_COM1,	OV9640_COM1_QQFMT | OV9640_COM1_HREF_2SKIP },
+	{ OV9640_COM4,	OV9640_COM4_QQ_VP | OV9640_COM4_RSVD },
+	{ OV9640_COM7,	OV9640_COM7_QCIF },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_qqvga[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x07) },
+	{ OV9640_COM1,	OV9640_COM1_QQFMT | OV9640_COM1_HREF_2SKIP },
+	{ OV9640_COM4,	OV9640_COM4_QQ_VP | OV9640_COM4_RSVD },
+	{ OV9640_COM7,	OV9640_COM7_QVGA },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_qcif[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x07) },
+	{ OV9640_COM4,	OV9640_COM4_QQ_VP | OV9640_COM4_RSVD },
+	{ OV9640_COM7,	OV9640_COM7_QCIF },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_qvga[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x03) },
+	{ OV9640_COM4,	OV9640_COM4_QQ_VP | OV9640_COM4_RSVD },
+	{ OV9640_COM7,	OV9640_COM7_QVGA },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_cif[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x03) },
+	{ OV9640_COM3,	OV9640_COM3_VP },
+	{ OV9640_COM7,	OV9640_COM7_CIF },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_vga[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x01) },
+	{ OV9640_COM3,	OV9640_COM3_VP },
+	{ OV9640_COM7,	OV9640_COM7_VGA },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_sxga[] = {
+	{ OV9640_CLKRC,	OV9640_CLKRC_DPLL_EN | OV9640_CLKRC_DIV(0x01) },
+	{ OV9640_COM3,	OV9640_COM3_VP },
+	{ OV9640_COM7,	0 },
+	{ OV9640_COM12,	OV9640_COM12_RSVD },
+	{ OV9640_COM13,	OV9640_COM13_GAMMA_RAW | OV9640_COM13_MATRIX_EN },
+	{ OV9640_COM15,	OV9640_COM15_OR_10F0 },
+};
+
+static const struct ov9640_reg ov9640_regs_yuv[] = {
+	{ OV9640_MTX1,	0x58 },
+	{ OV9640_MTX2,	0x48 },
+	{ OV9640_MTX3,	0x10 },
+	{ OV9640_MTX4,	0x28 },
+	{ OV9640_MTX5,	0x48 },
+	{ OV9640_MTX6,	0x70 },
+	{ OV9640_MTX7,	0x40 },
+	{ OV9640_MTX8,	0x40 },
+	{ OV9640_MTX9,	0x40 },
+	{ OV9640_MTXS,	0x0f },
+};
+
+static const struct ov9640_reg ov9640_regs_rgb[] = {
+	{ OV9640_MTX1,	0x71 },
+	{ OV9640_MTX2,	0x3e },
+	{ OV9640_MTX3,	0x0c },
+	{ OV9640_MTX4,	0x33 },
+	{ OV9640_MTX5,	0x72 },
+	{ OV9640_MTX6,	0x00 },
+	{ OV9640_MTX7,	0x2b },
+	{ OV9640_MTX8,	0x66 },
+	{ OV9640_MTX9,	0xd2 },
+	{ OV9640_MTXS,	0x65 },
+};
+
+static u32 ov9640_codes[] = {
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
+	MEDIA_BUS_FMT_RGB565_2X8_LE,
+};
+
+/* read a register */
+static int ov9640_reg_read(struct i2c_client *client, u8 reg, u8 *val)
+{
+	int ret;
+	u8 data = reg;
+	struct i2c_msg msg = {
+		.addr	= client->addr,
+		.flags	= 0,
+		.len	= 1,
+		.buf	= &data,
+	};
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		goto err;
+
+	msg.flags = I2C_M_RD;
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		goto err;
+
+	*val = data;
+	return 0;
+
+err:
+	dev_err(&client->dev, "Failed reading register 0x%02x!\n", reg);
+	return ret;
+}
+
+/* write a register */
+static int ov9640_reg_write(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret;
+	u8 _val;
+	unsigned char data[2] = { reg, val };
+	struct i2c_msg msg = {
+		.addr	= client->addr,
+		.flags	= 0,
+		.len	= 2,
+		.buf	= data,
+	};
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
+		return ret;
+	}
+
+	/* we have to read the register back ... no idea why, maybe HW bug */
+	ret = ov9640_reg_read(client, reg, &_val);
+	if (ret)
+		dev_err(&client->dev,
+			"Failed reading back register 0x%02x!\n", reg);
+
+	return 0;
+}
+
+
+/* Read a register, alter its bits, write it back */
+static int ov9640_reg_rmw(struct i2c_client *client, u8 reg, u8 set, u8 unset)
+{
+	u8 val;
+	int ret;
+
+	ret = ov9640_reg_read(client, reg, &val);
+	if (ret) {
+		dev_err(&client->dev,
+			"[Read]-Modify-Write of register %02x failed!\n", reg);
+		return ret;
+	}
+
+	val |= set;
+	val &= ~unset;
+
+	ret = ov9640_reg_write(client, reg, val);
+	if (ret)
+		dev_err(&client->dev,
+			"Read-Modify-[Write] of register %02x failed!\n", reg);
+
+	return ret;
+}
+
+/* Soft reset the camera. This has nothing to do with the RESET pin! */
+static int ov9640_reset(struct i2c_client *client)
+{
+	int ret;
+
+	ret = ov9640_reg_write(client, OV9640_COM7, OV9640_COM7_SCCB_RESET);
+	if (ret)
+		dev_err(&client->dev,
+			"An error occurred while entering soft reset!\n");
+
+	return ret;
+}
+
+/* Start/Stop streaming from the device */
+static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	return 0;
+}
+
+/* Set status of additional camera capabilities */
+static int ov9640_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov9640_priv *priv = container_of(ctrl->handler, struct ov9640_priv, hdl);
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		if (ctrl->val)
+			return ov9640_reg_rmw(client, OV9640_MVFP,
+							OV9640_MVFP_V, 0);
+		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_V);
+	case V4L2_CID_HFLIP:
+		if (ctrl->val)
+			return ov9640_reg_rmw(client, OV9640_MVFP,
+							OV9640_MVFP_H, 0);
+		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_H);
+	}
+	return -EINVAL;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov9640_get_register(struct v4l2_subdev *sd,
+				struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	u8 val;
+
+	if (reg->reg & ~0xff)
+		return -EINVAL;
+
+	reg->size = 1;
+
+	ret = ov9640_reg_read(client, reg->reg, &val);
+	if (ret)
+		return ret;
+
+	reg->val = (__u64)val;
+
+	return 0;
+}
+
+static int ov9640_set_register(struct v4l2_subdev *sd,
+				const struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (reg->reg & ~0xff || reg->val & ~0xff)
+		return -EINVAL;
+
+	return ov9640_reg_write(client, reg->reg, reg->val);
+}
+#endif
+
+static int ov9640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov9640_priv *priv = to_ov9640_sensor(sd);
+
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+}
+
+/* select nearest higher resolution for capture */
+static void ov9640_res_roundup(u32 *width, u32 *height)
+{
+	int i;
+	enum { QQCIF, QQVGA, QCIF, QVGA, CIF, VGA, SXGA };
+	static const int res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
+	static const int res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
+
+	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
+		if (res_x[i] >= *width && res_y[i] >= *height) {
+			*width = res_x[i];
+			*height = res_y[i];
+			return;
+		}
+	}
+
+	*width = res_x[SXGA];
+	*height = res_y[SXGA];
+}
+
+/* Prepare necessary register changes depending on color encoding */
+static void ov9640_alter_regs(u32 code,
+			      struct ov9640_reg_alt *alt)
+{
+	switch (code) {
+	default:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+		alt->com12	= OV9640_COM12_YUV_AVG;
+		alt->com13	= OV9640_COM13_Y_DELAY_EN |
+					OV9640_COM13_YUV_DLY(0x01);
+		break;
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+		alt->com7	= OV9640_COM7_RGB;
+		alt->com13	= OV9640_COM13_RGB_AVG;
+		alt->com15	= OV9640_COM15_RGB_555;
+		break;
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+		alt->com7	= OV9640_COM7_RGB;
+		alt->com13	= OV9640_COM13_RGB_AVG;
+		alt->com15	= OV9640_COM15_RGB_565;
+		break;
+	}
+}
+
+/* Setup registers according to resolution and color encoding */
+static int ov9640_write_regs(struct i2c_client *client, u32 width,
+		u32 code, struct ov9640_reg_alt *alts)
+{
+	const struct ov9640_reg	*ov9640_regs, *matrix_regs;
+	int			ov9640_regs_len, matrix_regs_len;
+	int			i, ret;
+	u8			val;
+
+	/* select register configuration for given resolution */
+	switch (width) {
+	case W_QQCIF:
+		ov9640_regs	= ov9640_regs_qqcif;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_qqcif);
+		break;
+	case W_QQVGA:
+		ov9640_regs	= ov9640_regs_qqvga;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_qqvga);
+		break;
+	case W_QCIF:
+		ov9640_regs	= ov9640_regs_qcif;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_qcif);
+		break;
+	case W_QVGA:
+		ov9640_regs	= ov9640_regs_qvga;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_qvga);
+		break;
+	case W_CIF:
+		ov9640_regs	= ov9640_regs_cif;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_cif);
+		break;
+	case W_VGA:
+		ov9640_regs	= ov9640_regs_vga;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_vga);
+		break;
+	case W_SXGA:
+		ov9640_regs	= ov9640_regs_sxga;
+		ov9640_regs_len	= ARRAY_SIZE(ov9640_regs_sxga);
+		break;
+	default:
+		dev_err(&client->dev, "Failed to select resolution!\n");
+		return -EINVAL;
+	}
+
+	/* select color matrix configuration for given color encoding */
+	if (code == MEDIA_BUS_FMT_UYVY8_2X8) {
+		matrix_regs	= ov9640_regs_yuv;
+		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_yuv);
+	} else {
+		matrix_regs	= ov9640_regs_rgb;
+		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_rgb);
+	}
+
+	/* write register settings into the module */
+	for (i = 0; i < ov9640_regs_len; i++) {
+		val = ov9640_regs[i].val;
+
+		switch (ov9640_regs[i].reg) {
+		case OV9640_COM7:
+			val |= alts->com7;
+			break;
+		case OV9640_COM12:
+			val |= alts->com12;
+			break;
+		case OV9640_COM13:
+			val |= alts->com13;
+			break;
+		case OV9640_COM15:
+			val |= alts->com15;
+			break;
+		}
+
+		ret = ov9640_reg_write(client, ov9640_regs[i].reg, val);
+		if (ret)
+			return ret;
+	}
+
+	/* write color matrix configuration into the module */
+	for (i = 0; i < matrix_regs_len; i++) {
+		ret = ov9640_reg_write(client, matrix_regs[i].reg,
+						matrix_regs[i].val);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* program default register values */
+static int ov9640_prog_dflt(struct i2c_client *client)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(ov9640_regs_dflt); i++) {
+		ret = ov9640_reg_write(client, ov9640_regs_dflt[i].reg,
+						ov9640_regs_dflt[i].val);
+		if (ret)
+			return ret;
+	}
+
+	/* wait for the changes to actually happen, 140ms are not enough yet */
+	mdelay(150);
+
+	return 0;
+}
+
+/* set the format we will capture in */
+static int ov9640_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov9640_reg_alt alts = {0};
+	int ret;
+
+	ov9640_alter_regs(mf->code, &alts);
+
+	ov9640_reset(client);
+
+	ret = ov9640_prog_dflt(client);
+	if (ret)
+		return ret;
+
+	return ov9640_write_regs(client, mf->width, mf->code, &alts);
+}
+
+static int ov9640_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct v4l2_mbus_framefmt *mf = &format->format;
+
+	if (format->pad)
+		return -EINVAL;
+
+	ov9640_res_roundup(&mf->width, &mf->height);
+
+	mf->field = V4L2_FIELD_NONE;
+
+	switch (mf->code) {
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+		mf->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	default:
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
+		/* fall through */
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+		mf->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	}
+
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return ov9640_s_fmt(sd, mf);
+
+	cfg->try_fmt = *mf;
+	return 0;
+}
+
+static int ov9640_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->pad || code->index >= ARRAY_SIZE(ov9640_codes))
+		return -EINVAL;
+
+	code->code = ov9640_codes[code->index];
+	return 0;
+}
+
+static int ov9640_get_selection(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_selection *sel)
+{
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+
+	sel->r.left = 0;
+	sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP:
+		sel->r.width = W_SXGA;
+		sel->r.height = H_SXGA;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int ov9640_video_probe(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov9640_priv *priv = to_ov9640_sensor(sd);
+	u8		pid, ver, midh, midl;
+	const char	*devname;
+	int		ret;
+
+	ret = ov9640_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * check and show product ID and manufacturer ID
+	 */
+
+	ret = ov9640_reg_read(client, OV9640_PID, &pid);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_VER, &ver);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_MIDH, &midh);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
+	if (ret)
+		goto done;
+
+	switch (VERSION(pid, ver)) {
+	case OV9640_V2:
+		devname		= "ov9640";
+		priv->revision	= 2;
+		break;
+	case OV9640_V3:
+		devname		= "ov9640";
+		priv->revision	= 3;
+		break;
+	default:
+		dev_err(&client->dev, "Product ID error %x:%x\n", pid, ver);
+		ret = -ENODEV;
+		goto done;
+	}
+
+	dev_info(&client->dev, "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 devname, pid, ver, midh, midl);
+
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+
+done:
+	ov9640_s_power(&priv->subdev, 0);
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops ov9640_ctrl_ops = {
+	.s_ctrl = ov9640_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops ov9640_core_ops = {
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register		= ov9640_get_register,
+	.s_register		= ov9640_set_register,
+#endif
+	.s_power		= ov9640_s_power,
+};
+
+/* Request bus settings on camera side */
+static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops ov9640_video_ops = {
+	.s_stream	= ov9640_s_stream,
+	.g_mbus_config	= ov9640_g_mbus_config,
+};
+
+static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
+	.enum_mbus_code = ov9640_enum_mbus_code,
+	.get_selection	= ov9640_get_selection,
+	.set_fmt	= ov9640_set_fmt,
+};
+
+static const struct v4l2_subdev_ops ov9640_subdev_ops = {
+	.core	= &ov9640_core_ops,
+	.video	= &ov9640_video_ops,
+	.pad	= &ov9640_pad_ops,
+};
+
+/*
+ * i2c_driver function
+ */
+static int ov9640_probe(struct i2c_client *client,
+			const struct i2c_device_id *did)
+{
+	struct ov9640_priv *priv;
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	int ret;
+
+	if (!ssdd) {
+		dev_err(&client->dev, "Missing platform_data for driver\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
+
+	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error)
+		return priv->hdl.error;
+
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
+
+	ret = ov9640_video_probe(client);
+	if (ret) {
+		v4l2_clk_put(priv->clk);
+eclkget:
+		v4l2_ctrl_handler_free(&priv->hdl);
+	}
+
+	return ret;
+}
+
+static int ov9640_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov9640_priv *priv = to_ov9640_sensor(sd);
+
+	v4l2_clk_put(priv->clk);
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
+	return 0;
+}
+
+static const struct i2c_device_id ov9640_id[] = {
+	{ "ov9640", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ov9640_id);
+
+static struct i2c_driver ov9640_i2c_driver = {
+	.driver = {
+		.name = "ov9640",
+	},
+	.probe    = ov9640_probe,
+	.remove   = ov9640_remove,
+	.id_table = ov9640_id,
+};
+
+module_i2c_driver(ov9640_i2c_driver);
+
+MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV96xx");
+MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
new file mode 100644
index 000000000000..65d13ff17536
--- /dev/null
+++ b/drivers/media/i2c/ov9640.h
@@ -0,0 +1,208 @@
+/*
+ * OmniVision OV96xx Camera Header File
+ *
+ * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef	__DRIVERS_MEDIA_VIDEO_OV9640_H__
+#define	__DRIVERS_MEDIA_VIDEO_OV9640_H__
+
+/* Register definitions */
+#define	OV9640_GAIN	0x00
+#define	OV9640_BLUE	0x01
+#define	OV9640_RED	0x02
+#define	OV9640_VFER	0x03
+#define	OV9640_COM1	0x04
+#define	OV9640_BAVE	0x05
+#define	OV9640_GEAVE	0x06
+#define	OV9640_RSID	0x07
+#define	OV9640_RAVE	0x08
+#define	OV9640_COM2	0x09
+#define	OV9640_PID	0x0a
+#define	OV9640_VER	0x0b
+#define	OV9640_COM3	0x0c
+#define	OV9640_COM4	0x0d
+#define	OV9640_COM5	0x0e
+#define	OV9640_COM6	0x0f
+#define	OV9640_AECH	0x10
+#define	OV9640_CLKRC	0x11
+#define	OV9640_COM7	0x12
+#define	OV9640_COM8	0x13
+#define	OV9640_COM9	0x14
+#define	OV9640_COM10	0x15
+/* 0x16 - RESERVED */
+#define	OV9640_HSTART	0x17
+#define	OV9640_HSTOP	0x18
+#define	OV9640_VSTART	0x19
+#define	OV9640_VSTOP	0x1a
+#define	OV9640_PSHFT	0x1b
+#define	OV9640_MIDH	0x1c
+#define	OV9640_MIDL	0x1d
+#define	OV9640_MVFP	0x1e
+#define	OV9640_LAEC	0x1f
+#define	OV9640_BOS	0x20
+#define	OV9640_GBOS	0x21
+#define	OV9640_GROS	0x22
+#define	OV9640_ROS	0x23
+#define	OV9640_AEW	0x24
+#define	OV9640_AEB	0x25
+#define	OV9640_VPT	0x26
+#define	OV9640_BBIAS	0x27
+#define	OV9640_GBBIAS	0x28
+/* 0x29 - RESERVED */
+#define	OV9640_EXHCH	0x2a
+#define	OV9640_EXHCL	0x2b
+#define	OV9640_RBIAS	0x2c
+#define	OV9640_ADVFL	0x2d
+#define	OV9640_ADVFH	0x2e
+#define	OV9640_YAVE	0x2f
+#define	OV9640_HSYST	0x30
+#define	OV9640_HSYEN	0x31
+#define	OV9640_HREF	0x32
+#define	OV9640_CHLF	0x33
+#define	OV9640_ARBLM	0x34
+/* 0x35..0x36 - RESERVED */
+#define	OV9640_ADC	0x37
+#define	OV9640_ACOM	0x38
+#define	OV9640_OFON	0x39
+#define	OV9640_TSLB	0x3a
+#define	OV9640_COM11	0x3b
+#define	OV9640_COM12	0x3c
+#define	OV9640_COM13	0x3d
+#define	OV9640_COM14	0x3e
+#define	OV9640_EDGE	0x3f
+#define	OV9640_COM15	0x40
+#define	OV9640_COM16	0x41
+#define	OV9640_COM17	0x42
+/* 0x43..0x4e - RESERVED */
+#define	OV9640_MTX1	0x4f
+#define	OV9640_MTX2	0x50
+#define	OV9640_MTX3	0x51
+#define	OV9640_MTX4	0x52
+#define	OV9640_MTX5	0x53
+#define	OV9640_MTX6	0x54
+#define	OV9640_MTX7	0x55
+#define	OV9640_MTX8	0x56
+#define	OV9640_MTX9	0x57
+#define	OV9640_MTXS	0x58
+/* 0x59..0x61 - RESERVED */
+#define	OV9640_LCC1	0x62
+#define	OV9640_LCC2	0x63
+#define	OV9640_LCC3	0x64
+#define	OV9640_LCC4	0x65
+#define	OV9640_LCC5	0x66
+#define	OV9640_MANU	0x67
+#define	OV9640_MANV	0x68
+#define	OV9640_HV	0x69
+#define	OV9640_MBD	0x6a
+#define	OV9640_DBLV	0x6b
+#define	OV9640_GSP	0x6c	/* ... till 0x7b */
+#define	OV9640_GST	0x7c	/* ... till 0x8a */
+
+#define	OV9640_CLKRC_DPLL_EN	0x80
+#define	OV9640_CLKRC_DIRECT	0x40
+#define	OV9640_CLKRC_DIV(x)	((x) & 0x3f)
+
+#define	OV9640_PSHFT_VAL(x)	((x) & 0xff)
+
+#define	OV9640_ACOM_2X_ANALOG	0x80
+#define	OV9640_ACOM_RSVD	0x12
+
+#define	OV9640_MVFP_V		0x10
+#define	OV9640_MVFP_H		0x20
+
+#define	OV9640_COM1_HREF_NOSKIP	0x00
+#define	OV9640_COM1_HREF_2SKIP	0x04
+#define	OV9640_COM1_HREF_3SKIP	0x08
+#define	OV9640_COM1_QQFMT	0x20
+
+#define	OV9640_COM2_SSM		0x10
+
+#define	OV9640_COM3_VP		0x04
+
+#define	OV9640_COM4_QQ_VP	0x80
+#define	OV9640_COM4_RSVD	0x40
+
+#define	OV9640_COM5_SYSCLK	0x80
+#define	OV9640_COM5_LONGEXP	0x01
+
+#define	OV9640_COM6_OPT_BLC	0x40
+#define	OV9640_COM6_ADBLC_BIAS	0x08
+#define	OV9640_COM6_FMT_RST	0x82
+#define	OV9640_COM6_ADBLC_OPTEN	0x01
+
+#define	OV9640_COM7_RAW_RGB	0x01
+#define	OV9640_COM7_RGB		0x04
+#define	OV9640_COM7_QCIF	0x08
+#define	OV9640_COM7_QVGA	0x10
+#define	OV9640_COM7_CIF		0x20
+#define	OV9640_COM7_VGA		0x40
+#define	OV9640_COM7_SCCB_RESET	0x80
+
+#define	OV9640_TSLB_YVYU_YUYV	0x04
+#define	OV9640_TSLB_YUYV_UYVY	0x08
+
+#define	OV9640_COM12_YUV_AVG	0x04
+#define	OV9640_COM12_RSVD	0x40
+
+#define	OV9640_COM13_GAMMA_NONE	0x00
+#define	OV9640_COM13_GAMMA_Y	0x40
+#define	OV9640_COM13_GAMMA_RAW	0x80
+#define	OV9640_COM13_RGB_AVG	0x20
+#define	OV9640_COM13_MATRIX_EN	0x10
+#define	OV9640_COM13_Y_DELAY_EN	0x08
+#define	OV9640_COM13_YUV_DLY(x)	((x) & 0x07)
+
+#define	OV9640_COM15_OR_00FF	0x00
+#define	OV9640_COM15_OR_01FE	0x40
+#define	OV9640_COM15_OR_10F0	0xc0
+#define	OV9640_COM15_RGB_NORM	0x00
+#define	OV9640_COM15_RGB_565	0x10
+#define	OV9640_COM15_RGB_555	0x30
+
+#define	OV9640_COM16_RB_AVG	0x01
+
+/* IDs */
+#define	OV9640_V2		0x9648
+#define	OV9640_V3		0x9649
+#define	VERSION(pid, ver)	(((pid) << 8) | ((ver) & 0xFF))
+
+/* supported resolutions */
+enum {
+	W_QQCIF	= 88,
+	W_QQVGA	= 160,
+	W_QCIF	= 176,
+	W_QVGA	= 320,
+	W_CIF	= 352,
+	W_VGA	= 640,
+	W_SXGA	= 1280
+};
+#define	H_SXGA	960
+
+/* Misc. structures */
+struct ov9640_reg_alt {
+	u8	com7;
+	u8	com12;
+	u8	com13;
+	u8	com15;
+};
+
+struct ov9640_reg {
+	u8	reg;
+	u8	val;
+};
+
+struct ov9640_priv {
+	struct v4l2_subdev		subdev;
+	struct v4l2_ctrl_handler	hdl;
+	struct v4l2_clk			*clk;
+
+	int				model;
+	int				revision;
+};
+
+#endif	/* __DRIVERS_MEDIA_VIDEO_OV9640_H__ */
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 7c2aabc8a3f6..7d7b801ab2ce 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -42,10 +42,12 @@ config SOC_CAMERA_OV772X
 	  This is a ov772x camera driver
 
 config SOC_CAMERA_OV9640
-	tristate "ov9640 camera support"
+	tristate "ov9640 camera support (OBSOLETE)"
+	default n
 	depends on SOC_CAMERA && I2C
 	help
-	  This is a ov9640 camera driver
+	  This is an obsoleted version of ov9640 camera driver. Please use
+	  the v4l2 standalone one (VIDEO_OV9640).
 
 config SOC_CAMERA_OV9740
 	tristate "ov9740 camera support"
-- 
2.18.0
