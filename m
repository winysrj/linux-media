Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51958 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3EOWuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 18:50:25 -0400
Received: by mail-lb0-f175.google.com with SMTP id v10so2473859lbd.34
        for <linux-media@vger.kernel.org>; Wed, 15 May 2013 15:50:24 -0700 (PDT)
To: mchehab@redhat.com, linux-media@vger.kernel.org, matsu@igel.co.jp
Subject: [PATCH v4] V4L2: I2C: ML86V7667 video decoder driver
Cc: linux-sh@vger.kernel.org, vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Thu, 16 May 2013 02:50:23 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160250.23861.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add OKI Semiconductor ML86V7667 video decoder driver.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: added v4l2_device_unregister_subdev() call to the error cleanup path of
ml86v7667_probe(); some cleanup.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo.

Changes since version 3:
- set the field format depending on video standard in try_mbus_fmt() method;
- refreshed the patch.

Changes since version 2:
- removed now unused #include;
- fixed querystd() method to return currently detected video standard;
- switched from using V4L2_STD_[PAL|NTSC] to using V4L2_STD_[625_50|525_60].

Changes since the original posting:
- fixed ACCC_CHROMA_CB_MASK;
- got rid of the autodetection feature;
- removed querystd() method calls from other methods;
- removed deprecated g_chip_ident() method.

 drivers/media/i2c/Kconfig     |    9 
 drivers/media/i2c/Makefile    |    1 
 drivers/media/i2c/ml86v7667.c |  481 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 491 insertions(+)

Index: media_tree/drivers/media/i2c/Kconfig
===================================================================
--- media_tree.orig/drivers/media/i2c/Kconfig
+++ media_tree/drivers/media/i2c/Kconfig
@@ -245,6 +245,15 @@ config VIDEO_KS0127
 	  To compile this driver as a module, choose M here: the
 	  module will be called ks0127.
 
+config VIDEO_ML86V7667
+	tristate "OKI ML86V7667 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the OKI Semiconductor ML86V7667 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ml86v7667.
+
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
Index: media_tree/drivers/media/i2c/Makefile
===================================================================
--- media_tree.orig/drivers/media/i2c/Makefile
+++ media_tree/drivers/media/i2c/Makefile
@@ -70,3 +70,4 @@ obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
+obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
Index: media_tree/drivers/media/i2c/ml86v7667.c
===================================================================
--- /dev/null
+++ media_tree/drivers/media/i2c/ml86v7667.c
@@ -0,0 +1,481 @@
+/*
+ * OKI Semiconductor ML86V7667 video decoder driver
+ *
+ * Author: Vladimir Barinov <source@cogentembedded.com>
+ * Copyright (C) 2013 Cogent Embedded, Inc.
+ * Copyright (C) 2013 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+
+#define DRV_NAME "ml86v7667"
+
+/* Subaddresses */
+#define MRA_REG			0x00 /* Mode Register A */
+#define MRC_REG			0x02 /* Mode Register C */
+#define LUMC_REG		0x0C /* Luminance Control */
+#define CLC_REG			0x10 /* Contrast level control */
+#define SSEPL_REG		0x11 /* Sync separation level */
+#define CHRCA_REG		0x12 /* Chrominance Control A */
+#define ACCC_REG		0x14 /* ACC Loop filter & Chrominance control */
+#define ACCRC_REG		0x15 /* ACC Reference level control */
+#define HUE_REG			0x16 /* Hue control */
+#define ADC2_REG		0x1F /* ADC Register 2 */
+#define PLLR1_REG		0x20 /* PLL Register 1 */
+#define STATUS_REG		0x2C /* STATUS Register */
+
+/* Mode Register A register bits */
+#define MRA_OUTPUT_MODE_MASK	(3 << 6)
+#define MRA_ITUR_BT601		(1 << 6)
+#define MRA_ITUR_BT656		(0 << 6)
+#define MRA_INPUT_MODE_MASK	(7 << 3)
+#define MRA_PAL_BT601		(4 << 3)
+#define MRA_NTSC_BT601		(0 << 3)
+#define MRA_REGISTER_MODE	(1 << 0)
+
+/* Mode Register C register bits */
+#define MRC_AUTOSELECT		(1 << 7)
+
+/* Luminance Control register bits */
+#define LUMC_ONOFF_SHIFT	7
+#define LUMC_ONOFF_MASK		(1 << 7)
+
+/* Contrast level control register bits */
+#define CLC_CONTRAST_ONOFF	(1 << 7)
+#define CLC_CONTRAST_MASK	0x0F
+
+/* Sync separation level register bits */
+#define SSEPL_LUMINANCE_ONOFF	(1 << 7)
+#define SSEPL_LUMINANCE_MASK	0x7F
+
+/* Chrominance Control A register bits */
+#define CHRCA_MODE_SHIFT	6
+#define CHRCA_MODE_MASK		(1 << 6)
+
+/* ACC Loop filter & Chrominance control register bits */
+#define ACCC_CHROMA_CR_SHIFT	3
+#define ACCC_CHROMA_CR_MASK	(7 << 3)
+#define ACCC_CHROMA_CB_SHIFT	0
+#define ACCC_CHROMA_CB_MASK	(7 << 0)
+
+/* ACC Reference level control register bits */
+#define ACCRC_CHROMA_MASK	0xfc
+#define ACCRC_CHROMA_SHIFT	2
+
+/* ADC Register 2 register bits */
+#define ADC2_CLAMP_VOLTAGE_MASK	(7 << 1)
+#define ADC2_CLAMP_VOLTAGE(n)	((n & 7) << 1)
+
+/* PLL Register 1 register bits */
+#define PLLR1_FIXED_CLOCK	(1 << 7)
+
+/* STATUS Register register bits */
+#define STATUS_HLOCK_DETECT	(1 << 3)
+#define STATUS_NTSCPAL		(1 << 2)
+
+struct ml86v7667_priv {
+	struct v4l2_subdev		sd;
+	struct v4l2_ctrl_handler	hdl;
+	struct v4l2_mbus_framefmt	fmt;
+	v4l2_std_id			std;
+};
+
+static inline struct ml86v7667_priv *to_ml86v7667(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct ml86v7667_priv, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct ml86v7667_priv, hdl)->sd;
+}
+
+static int ml86v7667_mask_set(struct i2c_client *client, const u8 reg,
+			      const u8 mask, const u8 data)
+{
+	int val = i2c_smbus_read_byte_data(client, reg);
+	if (val < 0)
+		return val;
+
+	val = (val & ~mask) | (data & mask);
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static int ml86v7667_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ret = ml86v7667_mask_set(client, SSEPL_REG,
+					 SSEPL_LUMINANCE_MASK, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = ml86v7667_mask_set(client, CLC_REG,
+					 CLC_CONTRAST_MASK, ctrl->val);
+		break;
+	case V4L2_CID_CHROMA_GAIN:
+		ret = ml86v7667_mask_set(client, ACCRC_REG, ACCRC_CHROMA_MASK,
+					 ctrl->val << ACCRC_CHROMA_SHIFT);
+		break;
+	case V4L2_CID_HUE:
+		ret = ml86v7667_mask_set(client, HUE_REG, ~0, ctrl->val);
+		break;
+	case V4L2_CID_RED_BALANCE:
+		ret = ml86v7667_mask_set(client, ACCC_REG,
+					 ACCC_CHROMA_CR_MASK,
+					 ctrl->val << ACCC_CHROMA_CR_SHIFT);
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		ret = ml86v7667_mask_set(client, ACCC_REG,
+					 ACCC_CHROMA_CB_MASK,
+					 ctrl->val << ACCC_CHROMA_CB_SHIFT);
+		break;
+	case V4L2_CID_SHARPNESS:
+		ret = ml86v7667_mask_set(client, LUMC_REG,
+					 LUMC_ONOFF_MASK,
+					 ctrl->val << LUMC_ONOFF_SHIFT);
+		break;
+	case V4L2_CID_COLOR_KILLER:
+		ret = ml86v7667_mask_set(client, CHRCA_REG,
+					 CHRCA_MODE_MASK,
+					 ctrl->val << CHRCA_MODE_SHIFT);
+		break;
+	}
+
+	return 0;
+}
+
+static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int status;
+
+	status = i2c_smbus_read_byte_data(client, STATUS_REG);
+	if (status < 0)
+		return status;
+
+	if (!(status & STATUS_HLOCK_DETECT))
+		return V4L2_STD_UNKNOWN;
+
+	*std = status & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
+
+	return 0;
+}
+
+static int ml86v7667_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int status_reg;
+
+	status_reg = i2c_smbus_read_byte_data(client, STATUS_REG);
+	if (status_reg < 0)
+		return status_reg;
+
+	*status = status_reg & STATUS_HLOCK_DETECT ? 0 : V4L2_IN_ST_NO_SIGNAL;
+
+	return 0;
+}
+
+static int ml86v7667_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
+				   enum v4l2_mbus_pixelcode *code)
+{
+	if (index > 0)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+
+	return 0;
+}
+
+static int ml86v7667_try_mbus_fmt(struct v4l2_subdev *sd,
+				  struct v4l2_mbus_framefmt *fmt)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	fmt->field = priv->std & V4L2_STD_525_60 ?
+		     V4L2_FIELD_INTERLACED_BT : V4L2_FIELD_INTERLACED_TB;
+	fmt->width = 720;
+	fmt->height = priv->std & V4L2_STD_525_60 ? 480 : 576;
+
+	return 0;
+}
+
+static int ml86v7667_g_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	*fmt = priv->fmt;
+
+	return 0;
+}
+
+static int ml86v7667_s_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	ml86v7667_try_mbus_fmt(sd, fmt);
+	priv->fmt = *fmt;
+
+	return 0;
+}
+
+static int ml86v7667_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	a->bounds.left = 0;
+	a->bounds.top = 0;
+	a->bounds.width = 720;
+	a->bounds.height = priv->std & V4L2_STD_525_60 ? 480 : 576;
+	a->defrect = a->bounds;
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator = 1;
+	a->pixelaspect.denominator = 1;
+
+	return 0;
+}
+
+static int ml86v7667_g_mbus_config(struct v4l2_subdev *sd,
+				   struct v4l2_mbus_config *cfg)
+{
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
+		     V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_BT656;
+
+	return 0;
+}
+
+static int ml86v7667_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
+	int ret;
+	u8 mode;
+
+	/* PAL/NTSC ITU-R BT.601 input mode */
+	mode = std & V4L2_STD_525_60 ? MRA_NTSC_BT601 : MRA_PAL_BT601;
+	ret = ml86v7667_mask_set(client, MRA_REG, MRA_INPUT_MODE_MASK, mode);
+	if (ret < 0)
+		return ret;
+
+	priv->std = std;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ml86v7667_g_register(struct v4l2_subdev *sd,
+				struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = i2c_smbus_read_byte_data(client, (u8)reg->reg);
+	if (ret < 0)
+		return ret;
+
+	reg->val = ret;
+	reg->size = sizeof(u8);
+
+	return 0;
+}
+
+static int ml86v7667_s_register(struct v4l2_subdev *sd,
+				struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return i2c_smbus_write_byte_data(client, (u8)reg->reg, (u8)reg->val);
+}
+#endif
+
+static const struct v4l2_ctrl_ops ml86v7667_ctrl_ops = {
+	.s_ctrl = ml86v7667_s_ctrl,
+};
+
+static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
+	.querystd = ml86v7667_querystd,
+	.g_input_status = ml86v7667_g_input_status,
+	.enum_mbus_fmt = ml86v7667_enum_mbus_fmt,
+	.try_mbus_fmt = ml86v7667_try_mbus_fmt,
+	.g_mbus_fmt = ml86v7667_g_mbus_fmt,
+	.s_mbus_fmt = ml86v7667_s_mbus_fmt,
+	.cropcap = ml86v7667_cropcap,
+	.g_mbus_config = ml86v7667_g_mbus_config,
+};
+
+static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
+	.s_std = ml86v7667_s_std,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = ml86v7667_g_register,
+	.s_register = ml86v7667_s_register,
+#endif
+};
+
+static struct v4l2_subdev_ops ml86v7667_subdev_ops = {
+	.core = &ml86v7667_subdev_core_ops,
+	.video = &ml86v7667_subdev_video_ops,
+};
+
+static int ml86v7667_init(struct ml86v7667_priv *priv)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
+	int val;
+	int ret;
+
+	/* BT.656-4 output mode, register mode */
+	ret = ml86v7667_mask_set(client, MRA_REG,
+				 MRA_OUTPUT_MODE_MASK | MRA_REGISTER_MODE,
+				 MRA_ITUR_BT656 | MRA_REGISTER_MODE);
+
+	/* PLL circuit fixed clock, 32MHz */
+	ret |= ml86v7667_mask_set(client, PLLR1_REG, PLLR1_FIXED_CLOCK,
+				  PLLR1_FIXED_CLOCK);
+
+	/* ADC2 clamping voltage maximum  */
+	ret |= ml86v7667_mask_set(client, ADC2_REG, ADC2_CLAMP_VOLTAGE_MASK,
+				  ADC2_CLAMP_VOLTAGE(7));
+
+	/* enable luminance function */
+	ret |= ml86v7667_mask_set(client, SSEPL_REG, SSEPL_LUMINANCE_ONOFF,
+				  SSEPL_LUMINANCE_ONOFF);
+
+	/* enable contrast function */
+	ret |= ml86v7667_mask_set(client, CLC_REG, CLC_CONTRAST_ONOFF, 0);
+
+	/*
+	 * PAL/NTSC autodetection is enabled after reset,
+	 * set the autodetected std in manual std mode and
+	 * disable autodetection
+	 */
+	val = i2c_smbus_read_byte_data(client, STATUS_REG);
+	if (val < 0)
+		return val;
+
+	priv->std = val & STATUS_NTSCPAL ? V4L2_STD_625_50 : V4L2_STD_525_60;
+	ret |= ml86v7667_mask_set(client, MRC_REG, MRC_AUTOSELECT, 0);
+
+	val = priv->std & V4L2_STD_525_60 ? MRA_NTSC_BT601 : MRA_PAL_BT601;
+	ret |= ml86v7667_mask_set(client, MRA_REG, MRA_INPUT_MODE_MASK, val);
+
+	return ret;
+}
+
+static int ml86v7667_probe(struct i2c_client *client,
+			   const struct i2c_device_id *did)
+{
+	struct ml86v7667_priv *priv;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&priv->sd, client, &ml86v7667_subdev_ops);
+
+	v4l2_ctrl_handler_init(&priv->hdl, 8);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, -64, 63, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_CONTRAST, -8, 7, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_CHROMA_GAIN, -32, 31, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_RED_BALANCE, -4, 3, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_BLUE_BALANCE, -4, 3, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_SHARPNESS, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ml86v7667_ctrl_ops,
+			  V4L2_CID_COLOR_KILLER, 0, 1, 1, 0);
+	priv->sd.ctrl_handler = &priv->hdl;
+
+	ret = priv->hdl.error;
+	if (ret)
+		goto cleanup;
+
+	v4l2_ctrl_handler_setup(&priv->hdl);
+
+	ret = ml86v7667_init(priv);
+	if (ret)
+		goto cleanup;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+		 client->addr, client->adapter->name);
+	return 0;
+
+cleanup:
+	v4l2_ctrl_handler_free(&priv->hdl);
+	v4l2_device_unregister_subdev(&priv->sd);
+	v4l_err(client, "failed to probe @ 0x%02x (%s)\n",
+		client->addr, client->adapter->name);
+	return ret;
+}
+
+static int ml86v7667_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ml86v7667_priv *priv = to_ml86v7667(sd);
+
+	v4l2_ctrl_handler_free(&priv->hdl);
+	v4l2_device_unregister_subdev(&priv->sd);
+
+	return 0;
+}
+
+static const struct i2c_device_id ml86v7667_id[] = {
+	{DRV_NAME, 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ml86v7667_id);
+
+static struct i2c_driver ml86v7667_i2c_driver = {
+	.driver = {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ml86v7667_probe,
+	.remove		= ml86v7667_remove,
+	.id_table	= ml86v7667_id,
+};
+
+module_i2c_driver(ml86v7667_i2c_driver);
+
+MODULE_DESCRIPTION("OKI Semiconductor ML86V7667 video decoder driver");
+MODULE_AUTHOR("Vladimir Barinov");
+MODULE_LICENSE("GPL");
