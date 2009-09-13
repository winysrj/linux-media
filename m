Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44000 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZIMQnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 12:43:43 -0400
Received: by fxm17 with SMTP id 17so391729fxm.37
        for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 09:43:45 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
Date: Sun, 13 Sep 2009 18:43:17 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200908220850.07435.marek.vasut@gmail.com> <200909042225.59000.marek.vasut@gmail.com> <Pine.LNX.4.64.0909102330070.4458@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909102330070.4458@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909131843.18007.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Pá 11. září 2009 23:51:44 Guennadi Liakhovetski napsal(a):
> On Fri, 4 Sep 2009, Marek Vasut wrote:
> > Dne Po 24. srpna 2009 20:06:29 Guennadi Liakhovetski napsal(a):
> > > Hi Marek
> > >
> > > On Sat, 22 Aug 2009, Marek Vasut wrote:
> > > > From 479aafc9a6540efec8a691a84aff166eb0218a72 Mon Sep 17 00:00:00
> > > > 2001 From: Marek Vasut <marek.vasut@gmail.com>
> > > > Date: Sat, 22 Aug 2009 05:14:23 +0200
> > > > Subject: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
> > > >
> > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > >
> > > Ok, I see, you rebased your patches on my soc-camera patch-stack, this
> > > is good, thanks. But you missed a couple of my comments - you still
> > > have a few static functions in the ov9640.c marked inline:
> > > ov9640_set_crop() is not used at all, ov9640_set_bus_param() gets
> > > assigned to a struct member, so, cannot be inline. ov9640_alter_regs()
> > > is indeed only called at one location, but see Chapter 15 in
> > > Documentation/CodingStyle. You left at least one multi-line comment
> > > wrongly formatted. You left some broken printk format lines, etc. You
> > > moved your header under drivers/... - that's good. But, please, address
> > > all my comments that I provided in a private review, or explain why you
> > > do not agree. Otherwise I feel like I wasted my time. Besides, your
> > > mailer has wrapped lines. Please, read
> > > Documentation/email-clients.txt on how to configure your email client
> > > to send patches properly. In the worst case, you can inline your
> > > patches while reviewing, and then attach them for a final submission.
> > > This is, however, discouraged, because it makes review and test of your
> > > intermediate patches with wrapped lines more difficult. Also, please
> > > check your patches with scripts/checkpatch.pl.
> >
> > Fixed patch follows, my mailer is fixed as much as possible (working on
> > getting git-email to work, but that's still to be done). Please consider
> > applying, thanks.
> 
> Ok, a couple more simple questions / remarks, In principle, there's just
> one principle objection - if we agree, that the correct format is BGR565
> and RGB565X, then we should change that. There's no BGR565 format
> currently in the kernel, so, we'd have to add it (and the documentation
> for the mercurial tree).

I dont think I understand you at all.
> 
> Thanks
> Guennadi

Inlined is a new version of the patch (I did some lookup through the datasheet). 
I might not need the BGR formats for now.

btw. weren't you planning to merge the ov96xx drivers into .31? I havent seen 
any of them there.

Cheers!

From: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 22 Aug 2009 05:14:23 +0200
Subject: [PATCH] Add driver for OmniVision OV9640 sensor

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/media/video/Kconfig     |    6 +
 drivers/media/video/Makefile    |    1 +
 drivers/media/video/ov9640.c    |  818 +++++++++++++++++++++++++++++++++++++++
 drivers/media/video/ov9640.h    |  209 ++++++++++
 include/media/v4l2-chip-ident.h |    1 +
 5 files changed, 1035 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ov9640.c
 create mode 100644 drivers/media/video/ov9640.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 84b6fc1..fddd654 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -772,6 +772,12 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
+config SOC_CAMERA_OV9640
+	tristate "ov9640 camera support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a ov9640 camera driver
+
 config MX1_VIDEO
 	bool
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9f2e321..e18efd5 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
+obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
new file mode 100644
index 0000000..0701247
--- /dev/null
+++ b/drivers/media/video/ov9640.c
@@ -0,0 +1,818 @@
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
+#include <linux/videodev2.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-common.h>
+#include <media/soc_camera.h>
+
+#include "ov9640.h"
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
+ * 		COM12 |= OV9640_COM12_YUV_AVG
+ *
+ *	 for RGB, alter the following registers:
+ *	 	COM7  |= OV9640_COM7_RGB
+ *	 	COM13 |= OV9640_COM13_RGB_AVG
+ *	 	COM15 |= proper RGB color encoding mode
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
+/* NOTE: The RGB formats can still have issues */
+static const struct soc_camera_data_format ov9640_fmt_lists[] = {
+	{
+		.name		= "UYVY",
+		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+	{
+		.name		= "RGB555",
+		.fourcc		= V4L2_PIX_FMT_RGB555,
+		.depth		= 15,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+	},
+	{
+		.name		= "RGB565",
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.depth		= 16,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+	}
+};
+
+static const struct v4l2_queryctrl ov9640_controls[] = {
+	{
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Vertically",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Horizontally",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
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
+		return val;
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
+			"An error occured while entering soft reset!\n");
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
+/* Alter bus settings on camera side */
+static int ov9640_set_bus_param(struct soc_camera_device *icd,
+					unsigned long flags)
+{
+	return 0;
+}
+
+/* Request bus settings on camera side */
+static unsigned long ov9640_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	/*
+	 * REVISIT: the camera probably can do 10 bit transfers, but I don't
+	 *          have those pins connected on my hardware.
+	 */
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+/* Get status of additional camera capabilities */
+static int ov9640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
+					struct ov9640_priv, subdev);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		ctrl->value = priv->flag_vflip;
+		break;
+	case V4L2_CID_HFLIP:
+		ctrl->value = priv->flag_hflip;
+		break;
+	}
+	return 0;
+}
+
+/* Set status of additional camera capabilities */
+static int ov9640_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
+					struct ov9640_priv, subdev);
+
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		priv->flag_vflip = ctrl->value;
+		if (ctrl->value)
+			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+							OV9640_MVFP_V, 0);
+		else
+			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+							0, OV9640_MVFP_V);
+		break;
+	case V4L2_CID_HFLIP:
+		priv->flag_hflip = ctrl->value;
+		if (ctrl->value)
+			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+							OV9640_MVFP_H, 0);
+		else
+			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+							0, OV9640_MVFP_H);
+		break;
+	}
+
+	return ret;
+}
+
+/* Get chip identification */
+static int ov9640_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
+					struct ov9640_priv, subdev);
+
+	id->ident	= priv->model;
+	id->revision	= priv->revision;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov9640_get_register(struct soc_camera_device *icd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov9640_priv *priv = i2c_get_clientdata(client);
+
+	int ret;
+	u8 val;
+
+	if (reg->reg & ~0xff)
+		return -EINVAL;
+
+	reg->size = 1;
+
+	ret = ov9640_read_reg(priv->client, reg->reg, &val);
+	if (ret)
+		return ret;
+
+	reg->val = (__u64)val;
+
+	return 0;
+}
+
+static int ov9640_set_register(struct soc_camera_device *icd,
+			       struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov9640_priv *priv = i2c_get_clientdata(client);
+
+	if (reg->reg & ~0xff || reg->val & ~0xff)
+		return -EINVAL;
+
+	return ov9640_write_reg(priv->client, reg->reg, reg->val);
+}
+#endif
+
+/* select nearest higher resolution for capture */
+static void ov9640_res_roundup(u32 *width, u32 *height)
+{
+	int i;
+	enum { QQCIF, QQVGA, QCIF, QVGA, CIF, VGA, SXGA };
+	int res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
+	int res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
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
+static void ov9640_alter_regs(u32 pixfmt, struct ov9640_reg_alt *alt)
+{
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_UYVY:
+		alt->com12	= OV9640_COM12_YUV_AVG;
+		alt->com13	= OV9640_COM13_Y_DELAY_EN |
+					OV9640_COM13_YUV_DLY(0x01);
+		break;
+	case V4L2_PIX_FMT_RGB555:
+		alt->com7	= OV9640_COM7_RGB;
+		alt->com13	= OV9640_COM13_RGB_AVG;
+		alt->com15	= OV9640_COM15_RGB_555;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		alt->com7	= OV9640_COM7_RGB;
+		alt->com13	= OV9640_COM13_RGB_AVG;
+		alt->com15	= OV9640_COM15_RGB_565;
+		break;
+	};
+}
+
+/* Setup registers according to resolution and color encoding */
+static int ov9640_write_regs(struct i2c_client *client,
+		u32 width, u32 pixfmt, struct ov9640_reg_alt *alts)
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
+	if (pixfmt == V4L2_PIX_FMT_UYVY) {
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
+	/* wait for the changes to actually happen */
+	mdelay(150);
+
+	return 0;
+}
+
+/* set the format we will capture in */
+static int ov9640_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct ov9640_reg_alt alts = {0};
+	int ret;
+
+	ov9640_res_roundup(&pix->width, &pix->height);
+	ov9640_alter_regs(pix->pixelformat, &alts);
+
+	ov9640_reset(client);
+
+	ret = ov9640_prog_dflt(client);
+	if (ret)
+		return ret;
+
+	return ov9640_write_regs(client, pix->width, pix->pixelformat, &alts);
+}
+
+static int ov9640_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	ov9640_res_roundup(&pix->width, &pix->height);
+	pix->field  = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int ov9640_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	a->c.left	= 0;
+	a->c.top	= 0;
+	a->c.width	= W_SXGA;
+	a->c.height	= H_SXGA;
+	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int ov9640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= W_SXGA;
+	a->bounds.height		= H_SXGA;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+
+
+static int ov9640_video_probe(struct soc_camera_device *icd,
+				struct i2c_client *client)
+{
+	struct ov9640_priv *priv = i2c_get_clientdata(client);
+	u8		pid, ver, midh, midl;
+	const char	*devname;
+	int		ret = 0;
+
+	/*
+	 * We must have a parent by now. And it cannot be a wrong one.
+	 * So this entire test is completely redundant.
+	 */
+	if (!icd->dev.parent ||
+	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
+		dev_err(&icd->dev, "Parent missing or invalid!\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	icd->formats		= ov9640_fmt_lists;
+	icd->num_formats	= ARRAY_SIZE(ov9640_fmt_lists);
+
+	/*
+	 * check and show product ID and manufacturer ID
+	 */
+
+	ret = ov9640_reg_read(client, OV9640_PID, &pid);
+	if (ret)
+		goto err;
+
+	ret = ov9640_reg_read(client, OV9640_VER, &ver);
+	if (ret)
+		goto err;
+
+	ret = ov9640_reg_read(client, OV9640_MIDH, &midh);
+	if (ret)
+		goto err;
+
+	ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
+	if (ret)
+		goto err;
+
+	switch (VERSION(pid, ver)) {
+	case OV9640_V2:
+		devname		= "ov9640";
+		priv->model	= V4L2_IDENT_OV9640;
+		priv->revision	= 2;
+	case OV9640_V3:
+		devname		= "ov9640";
+		priv->model	= V4L2_IDENT_OV9640;
+		priv->revision	= 3;
+		break;
+	default:
+		dev_err(&icd->dev, "Product ID error %x:%x\n", pid, ver);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_info(&icd->dev, "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 devname, pid, ver, midh, midl);
+
+err:
+	return ret;
+}
+
+static struct soc_camera_ops ov9640_ops = {
+	.set_bus_param		= ov9640_set_bus_param,
+	.query_bus_param	= ov9640_query_bus_param,
+	.controls		= ov9640_controls,
+	.num_controls		= ARRAY_SIZE(ov9640_controls),
+};
+
+static struct v4l2_subdev_core_ops ov9640_core_ops = {
+	.g_ctrl			= ov9640_g_ctrl,
+	.s_ctrl			= ov9640_s_ctrl,
+	.g_chip_ident		= ov9640_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register		= ov9640_get_register,
+	.s_register		= ov9640_set_register,
+#endif
+
+};
+
+static struct v4l2_subdev_video_ops ov9640_video_ops = {
+	.s_stream		= ov9640_s_stream,
+	.s_fmt			= ov9640_s_fmt,
+	.try_fmt		= ov9640_try_fmt,
+	.cropcap		= ov9640_cropcap,
+	.g_crop			= ov9640_g_crop,
+
+};
+
+static struct v4l2_subdev_ops ov9640_subdev_ops = {
+	.core	= &ov9640_core_ops,
+	.video	= &ov9640_video_ops,
+};
+
+/*
+ * i2c_driver function
+ */
+static int ov9640_probe(struct i2c_client *client,
+			 const struct i2c_device_id *did)
+{
+	struct ov9640_priv *priv;
+	struct i2c_adapter *adapter	= to_i2c_adapter(client->dev.parent);
+	struct soc_camera_device *icd	= client->dev.platform_data;
+	struct soc_camera_link *icl;
+	int ret;
+
+	if (!icd) {
+		dev_err(&client->dev, "Missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
+	if (!icl) {
+		dev_err(&client->dev, "Missing platform_data for driver\n");
+		return -EINVAL;
+	}
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&adapter->dev,
+			"I2C adapter doesn't support I2C_FUNC_SMBUS_BYTE\n");
+		return -EIO;
+	}
+
+	priv = kzalloc(sizeof(struct ov9640_priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&client->dev,
+			"Failed to allocate memory for private data!\n");
+		return -ENOMEM;
+	}
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
+
+	icd->ops	= &ov9640_ops;
+
+	ret = ov9640_video_probe(icd, client);
+
+	if (ret) {
+		icd->ops = NULL;
+		i2c_set_clientdata(client, NULL);
+		kfree(priv);
+	}
+
+	return ret;
+}
+
+static int ov9640_remove(struct i2c_client *client)
+{
+	struct ov9640_priv *priv = i2c_get_clientdata(client);
+
+	i2c_set_clientdata(client, NULL);
+	kfree(priv);
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
+static int __init ov9640_module_init(void)
+{
+	return i2c_add_driver(&ov9640_i2c_driver);
+}
+
+static void __exit ov9640_module_exit(void)
+{
+	i2c_del_driver(&ov9640_i2c_driver);
+}
+
+module_init(ov9640_module_init);
+module_exit(ov9640_module_exit);
+
+MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV96xx");
+MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/ov9640.h b/drivers/media/video/ov9640.h
new file mode 100644
index 0000000..c36b1e2
--- /dev/null
+++ b/drivers/media/video/ov9640.h
@@ -0,0 +1,209 @@
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
+#define OV9640_TSLB_YVYU_YUYV	0x04
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
+
+	int				model;
+	int				revision;
+
+	bool				flag_vflip;
+	bool				flag_hflip;
+};
+
+#endif	/* __DRIVERS_MEDIA_VIDEO_OV9640_H__ */
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 11a4a2d..0892e52 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -60,6 +60,7 @@ enum {
 	V4L2_IDENT_OV7670 = 250,
 	V4L2_IDENT_OV7720 = 251,
 	V4L2_IDENT_OV7725 = 252,
+	V4L2_IDENT_OV9640 = 253,
 
 	/* module saa7146: reserved range 300-309 */
 	V4L2_IDENT_SAA7146 = 300,
-- 
1.6.3.3
