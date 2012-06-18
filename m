Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta15.web4all.fr ([176.31.217.11]:37861 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2FRT2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:28:05 -0400
Date: Mon, 18 Jun 2012 21:32:17 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Message-ID: <204715047.2885246.1340047937566.JavaMail.root@advansee.com>
Subject: [PATCH] media: add Analog Devices ADV7393 video encoder driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ADV7393 I²C-based video encoder driver. This driver has been tested on
custom hardware. It has been tested for composite output. It is derived from the
ADV7343 driver.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/media/video/Kconfig                    |    9 +
 .../drivers/media/video/Makefile                   |    1 +
 .../drivers/media/video/adv7393.c                  |  487 ++++++++++++++++++++
 .../drivers/media/video/adv7393_regs.h             |  188 ++++++++
 .../include/media/adv7393.h                        |   28 ++
 .../include/media/v4l2-chip-ident.h                |    3 +
 6 files changed, 716 insertions(+)
 create mode 100644 linux-next-HEAD-6c86b58/drivers/media/video/adv7393.c
 create mode 100644 linux-next-HEAD-6c86b58/drivers/media/video/adv7393_regs.h
 create mode 100644 linux-next-HEAD-6c86b58/include/media/adv7393.h

diff --git linux-next-HEAD-6c86b58.orig/drivers/media/video/Kconfig linux-next-HEAD-6c86b58/drivers/media/video/Kconfig
index 99937c9..d00dee9 100644
--- linux-next-HEAD-6c86b58.orig/drivers/media/video/Kconfig
+++ linux-next-HEAD-6c86b58/drivers/media/video/Kconfig
@@ -461,6 +461,15 @@ config VIDEO_ADV7343
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7343.
 
+config VIDEO_ADV7393
+	tristate "ADV7393 video encoder"
+	depends on I2C
+	help
+	  Support for Analog Devices I2C bus based ADV7393 encoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7393.
+
 config VIDEO_AK881X
 	tristate "AK8813/AK8814 video encoders"
 	depends on I2C
diff --git linux-next-HEAD-6c86b58.orig/drivers/media/video/Makefile linux-next-HEAD-6c86b58/drivers/media/video/Makefile
index d209de0..b7da9fa 100644
--- linux-next-HEAD-6c86b58.orig/drivers/media/video/Makefile
+++ linux-next-HEAD-6c86b58/drivers/media/video/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
 obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
 obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
+obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
 obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
diff --git linux-next-HEAD-6c86b58/drivers/media/video/adv7393.c linux-next-HEAD-6c86b58/drivers/media/video/adv7393.c
new file mode 100644
index 0000000..ca72486
--- /dev/null
+++ linux-next-HEAD-6c86b58/drivers/media/video/adv7393.c
@@ -0,0 +1,487 @@
+/*
+ * adv7393 - ADV7393 Video Encoder Driver
+ *
+ * The encoder hardware does not support SECAM.
+ *
+ * Copyright (C) 2010-2012 ADVANSEE - http://www.advansee.com/
+ * Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
+ *
+ * Based on ADV7343 driver,
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/videodev2.h>
+#include <linux/uaccess.h>
+
+#include <media/adv7393.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
+
+#include "adv7393_regs.h"
+
+MODULE_DESCRIPTION("ADV7393 video encoder driver");
+MODULE_LICENSE("GPL");
+
+static bool debug;
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Debug level 0-1");
+
+struct adv7393_state {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	u8 reg00;
+	u8 reg01;
+	u8 reg02;
+	u8 reg35;
+	u8 reg80;
+	u8 reg82;
+	u32 output;
+	v4l2_std_id std;
+};
+
+static inline struct adv7393_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct adv7393_state, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct adv7393_state, hdl)->sd;
+}
+
+static inline int adv7393_write(struct v4l2_subdev *sd, u8 reg, u8 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static const u8 adv7393_init_reg_val[] = {
+	ADV7393_SOFT_RESET, ADV7393_SOFT_RESET_DEFAULT,
+	ADV7393_POWER_MODE_REG, ADV7393_POWER_MODE_REG_DEFAULT,
+
+	ADV7393_HD_MODE_REG1, ADV7393_HD_MODE_REG1_DEFAULT,
+	ADV7393_HD_MODE_REG2, ADV7393_HD_MODE_REG2_DEFAULT,
+	ADV7393_HD_MODE_REG3, ADV7393_HD_MODE_REG3_DEFAULT,
+	ADV7393_HD_MODE_REG4, ADV7393_HD_MODE_REG4_DEFAULT,
+	ADV7393_HD_MODE_REG5, ADV7393_HD_MODE_REG5_DEFAULT,
+	ADV7393_HD_MODE_REG6, ADV7393_HD_MODE_REG6_DEFAULT,
+	ADV7393_HD_MODE_REG7, ADV7393_HD_MODE_REG7_DEFAULT,
+
+	ADV7393_SD_MODE_REG1, ADV7393_SD_MODE_REG1_DEFAULT,
+	ADV7393_SD_MODE_REG2, ADV7393_SD_MODE_REG2_DEFAULT,
+	ADV7393_SD_MODE_REG3, ADV7393_SD_MODE_REG3_DEFAULT,
+	ADV7393_SD_MODE_REG4, ADV7393_SD_MODE_REG4_DEFAULT,
+	ADV7393_SD_MODE_REG5, ADV7393_SD_MODE_REG5_DEFAULT,
+	ADV7393_SD_MODE_REG6, ADV7393_SD_MODE_REG6_DEFAULT,
+	ADV7393_SD_MODE_REG7, ADV7393_SD_MODE_REG7_DEFAULT,
+	ADV7393_SD_MODE_REG8, ADV7393_SD_MODE_REG8_DEFAULT,
+
+	ADV7393_SD_TIMING_REG0, ADV7393_SD_TIMING_REG0_DEFAULT,
+
+	ADV7393_SD_HUE_ADJUST, ADV7393_SD_HUE_ADJUST_DEFAULT,
+	ADV7393_SD_CGMS_WSS0, ADV7393_SD_CGMS_WSS0_DEFAULT,
+	ADV7393_SD_BRIGHTNESS_WSS, ADV7393_SD_BRIGHTNESS_WSS_DEFAULT,
+};
+
+/*
+ * 			    2^32
+ * FSC(reg) =  FSC (HZ) * --------
+ *			  27000000
+ */
+static const struct adv7393_std_info stdinfo[] = {
+	{
+		/* FSC(Hz) = 3,579,545.45 Hz */
+		SD_STD_NTSC, 569408542, V4L2_STD_NTSC,
+	}, {
+		/* FSC(Hz) = 3,575,611.00 Hz */
+		SD_STD_PAL_M, 568782678, V4L2_STD_PAL_M,
+	}, {
+		/* FSC(Hz) = 3,582,056.00 Hz */
+		SD_STD_PAL_N, 569807903, V4L2_STD_PAL_Nc,
+	}, {
+		/* FSC(Hz) = 4,433,618.75 Hz */
+		SD_STD_PAL_N, 705268427, V4L2_STD_PAL_N,
+	}, {
+		/* FSC(Hz) = 4,433,618.75 Hz */
+		SD_STD_PAL_BDGHI, 705268427, V4L2_STD_PAL,
+	}, {
+		/* FSC(Hz) = 4,433,618.75 Hz */
+		SD_STD_NTSC, 705268427, V4L2_STD_NTSC_443,
+	}, {
+		/* FSC(Hz) = 4,433,618.75 Hz */
+		SD_STD_PAL_M, 705268427, V4L2_STD_PAL_60,
+	},
+};
+
+static int adv7393_setstd(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7393_state *state = to_state(sd);
+	const struct adv7393_std_info *std_info;
+	int num_std;
+	u8 reg;
+	u32 val;
+	int err = 0;
+	int i;
+
+	num_std = ARRAY_SIZE(stdinfo);
+
+	for (i = 0; i < num_std; i++) {
+		if (stdinfo[i].stdid & std)
+			break;
+	}
+
+	if (i == num_std) {
+		v4l2_dbg(1, debug, sd,
+				"Invalid std or std is not supported: %llx\n",
+						(unsigned long long)std);
+		return -EINVAL;
+	}
+
+	std_info = &stdinfo[i];
+
+	/* Set the standard */
+	val = state->reg80 & ~SD_STD_MASK;
+	val |= std_info->standard_val3;
+	err = adv7393_write(sd, ADV7393_SD_MODE_REG1, val);
+	if (err < 0)
+		goto setstd_exit;
+
+	state->reg80 = val;
+
+	/* Configure the input mode register */
+	val = state->reg01 & ~INPUT_MODE_MASK;
+	val |= SD_INPUT_MODE;
+	err = adv7393_write(sd, ADV7393_MODE_SELECT_REG, val);
+	if (err < 0)
+		goto setstd_exit;
+
+	state->reg01 = val;
+
+	/* Program the sub carrier frequency registers */
+	val = std_info->fsc_val;
+	for (reg = ADV7393_FSC_REG0; reg <= ADV7393_FSC_REG3; reg++) {
+		err = adv7393_write(sd, reg, val);
+		if (err < 0)
+			goto setstd_exit;
+		val >>= 8;
+	}
+
+	val = state->reg82;
+
+	/* Pedestal settings */
+	if (std & (V4L2_STD_NTSC | V4L2_STD_NTSC_443))
+		val |= SD_PEDESTAL_EN;
+	else if (std & ~V4L2_STD_SECAM)
+		val &= SD_PEDESTAL_DI;
+
+	err = adv7393_write(sd, ADV7393_SD_MODE_REG2, val);
+	if (err < 0)
+		goto setstd_exit;
+
+	state->reg82 = val;
+
+setstd_exit:
+	if (err != 0)
+		v4l2_err(sd, "Error setting std, write failed\n");
+
+	return err;
+}
+
+static int adv7393_setoutput(struct v4l2_subdev *sd, u32 output_type)
+{
+	struct adv7393_state *state = to_state(sd);
+	u8 val;
+	int err = 0;
+
+	if (output_type > ADV7393_SVIDEO_ID) {
+		v4l2_dbg(1, debug, sd,
+			"Invalid output type or output type not supported:%d\n",
+								output_type);
+		return -EINVAL;
+	}
+
+	/* Enable Appropriate DAC */
+	val = state->reg00 & 0x03;
+
+	if (output_type == ADV7393_COMPOSITE_ID)
+		val |= ADV7393_COMPOSITE_POWER_VALUE;
+	else if (output_type == ADV7393_COMPONENT_ID)
+		val |= ADV7393_COMPONENT_POWER_VALUE;
+	else
+		val |= ADV7393_SVIDEO_POWER_VALUE;
+
+	err = adv7393_write(sd, ADV7393_POWER_MODE_REG, val);
+	if (err < 0)
+		goto setoutput_exit;
+
+	state->reg00 = val;
+
+	/* Enable YUV output */
+	val = state->reg02 | YUV_OUTPUT_SELECT;
+	err = adv7393_write(sd, ADV7393_MODE_REG0, val);
+	if (err < 0)
+		goto setoutput_exit;
+
+	state->reg02 = val;
+
+	/* configure SD DAC Output 1 bit */
+	val = state->reg82;
+	if (output_type == ADV7393_COMPONENT_ID)
+		val &= SD_DAC_OUT1_DI;
+	else
+		val |= SD_DAC_OUT1_EN;
+	err = adv7393_write(sd, ADV7393_SD_MODE_REG2, val);
+	if (err < 0)
+		goto setoutput_exit;
+
+	state->reg82 = val;
+
+	/* configure ED/HD Color DAC Swap bit to zero */
+	val = state->reg35 & HD_DAC_SWAP_DI;
+	err = adv7393_write(sd, ADV7393_HD_MODE_REG6, val);
+	if (err < 0)
+		goto setoutput_exit;
+
+	state->reg35 = val;
+
+setoutput_exit:
+	if (err != 0)
+		v4l2_err(sd, "Error setting output, write failed\n");
+
+	return err;
+}
+
+static int adv7393_log_status(struct v4l2_subdev *sd)
+{
+	struct adv7393_state *state = to_state(sd);
+
+	v4l2_info(sd, "Standard: %llx\n", (unsigned long long)state->std);
+	v4l2_info(sd, "Output: %s\n", (state->output == 0) ? "Composite" :
+			((state->output == 1) ? "Component" : "S-Video"));
+	return 0;
+}
+
+static int adv7393_s_ctrl(struct v4l2_control *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		return adv7393_write(sd, ADV7393_SD_BRIGHTNESS_WSS,
+					ctrl->val & SD_BRIGHTNESS_VALUE_MASK);
+
+	case V4L2_CID_HUE:
+		return adv7393_write(sd, ADV7393_SD_HUE_ADJUST,
+					ctrl->val - ADV7393_HUE_MIN);
+
+	case V4L2_CID_GAIN:
+		return adv7393_write(sd, ADV7393_DAC123_OUTPUT_LEVEL,
+					ctrl->val);
+	}
+	return -EINVAL;
+}
+
+static int adv7393_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7393, 0);
+}
+
+static const struct v4l2_ctrl_ops adv7393_ctrl_ops = {
+	.s_ctrl = adv7393_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops adv7393_core_ops = {
+	.log_status = adv7393_log_status,
+	.g_chip_ident = adv7393_g_chip_ident,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
+static int adv7393_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7393_state *state = to_state(sd);
+	int err = 0;
+
+	if (state->std == std)
+		return 0;
+
+	err = adv7393_setstd(sd, std);
+	if (!err)
+		state->std = std;
+
+	return err;
+}
+
+static int adv7393_s_routing(struct v4l2_subdev *sd,
+		u32 input, u32 output, u32 config)
+{
+	struct adv7393_state *state = to_state(sd);
+	int err = 0;
+
+	if (state->output == output)
+		return 0;
+
+	err = adv7393_setoutput(sd, output);
+	if (!err)
+		state->output = output;
+
+	return err;
+}
+
+static const struct v4l2_subdev_video_ops adv7393_video_ops = {
+	.s_std_output	= adv7393_s_std_output,
+	.s_routing	= adv7393_s_routing,
+};
+
+static const struct v4l2_subdev_ops adv7393_ops = {
+	.core	= &adv7393_core_ops,
+	.video	= &adv7393_video_ops,
+};
+
+static int adv7393_initialize(struct v4l2_subdev *sd)
+{
+	struct adv7393_state *state = to_state(sd);
+	int err = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adv7393_init_reg_val); i += 2) {
+
+		err = adv7393_write(sd, adv7393_init_reg_val[i],
+					adv7393_init_reg_val[i+1]);
+		if (err) {
+			v4l2_err(sd, "Error initializing\n");
+			return err;
+		}
+	}
+
+	/* Configure for default video standard */
+	err = adv7393_setoutput(sd, state->output);
+	if (err < 0) {
+		v4l2_err(sd, "Error setting output during init\n");
+		return -EINVAL;
+	}
+
+	err = adv7393_setstd(sd, state->std);
+	if (err < 0) {
+		v4l2_err(sd, "Error setting std during init\n");
+		return -EINVAL;
+	}
+
+	return err;
+}
+
+static int adv7393_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct adv7393_state *state;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	v4l_info(client, "chip found @ 0x%x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state = kzalloc(sizeof(struct adv7393_state), GFP_KERNEL);
+	if (state == NULL)
+		return -ENOMEM;
+
+	state->reg00	= ADV7393_POWER_MODE_REG_DEFAULT;
+	state->reg01	= 0x00;
+	state->reg02	= 0x20;
+	state->reg35	= ADV7393_HD_MODE_REG6_DEFAULT;
+	state->reg80	= ADV7393_SD_MODE_REG1_DEFAULT;
+	state->reg82	= ADV7393_SD_MODE_REG2_DEFAULT;
+
+	state->output = ADV7393_COMPOSITE_ID;
+	state->std = V4L2_STD_NTSC;
+
+	v4l2_i2c_subdev_init(&state->sd, client, &adv7393_ops);
+
+	v4l2_ctrl_handler_init(&state->hdl, 3);
+	v4l2_ctrl_new_std(&state->hdl, &adv7393_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, ADV7393_BRIGHTNESS_MIN,
+					     ADV7393_BRIGHTNESS_MAX, 1,
+					     ADV7393_BRIGHTNESS_DEF);
+	v4l2_ctrl_new_std(&state->hdl, &adv7393_ctrl_ops,
+			V4L2_CID_HUE, ADV7393_HUE_MIN,
+				      ADV7393_HUE_MAX, 1,
+				      ADV7393_HUE_DEF);
+	v4l2_ctrl_new_std(&state->hdl, &adv7393_ctrl_ops,
+			V4L2_CID_GAIN, ADV7393_GAIN_MIN,
+				       ADV7393_GAIN_MAX, 1,
+				       ADV7393_GAIN_DEF);
+	state->sd.ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&state->hdl);
+
+	err = adv7393_initialize(&state->sd);
+	if (err) {
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+	}
+	return err;
+}
+
+static int adv7393_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7393_state *state = to_state(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id adv7393_id[] = {
+	{"adv7393", 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, adv7393_id);
+
+static struct i2c_driver adv7393_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "adv7393",
+	},
+	.probe		= adv7393_probe,
+	.remove		= adv7393_remove,
+	.id_table	= adv7393_id,
+};
+module_i2c_driver(adv7393_driver);
diff --git linux-next-HEAD-6c86b58/drivers/media/video/adv7393_regs.h linux-next-HEAD-6c86b58/drivers/media/video/adv7393_regs.h
new file mode 100644
index 0000000..7896833
--- /dev/null
+++ linux-next-HEAD-6c86b58/drivers/media/video/adv7393_regs.h
@@ -0,0 +1,188 @@
+/*
+ * ADV7393 encoder related structure and register definitions
+ *
+ * Copyright (C) 2010-2012 ADVANSEE - http://www.advansee.com/
+ * Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
+ *
+ * Based on ADV7343 driver,
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef ADV7393_REGS_H
+#define ADV7393_REGS_H
+
+struct adv7393_std_info {
+	u32 standard_val3;
+	u32 fsc_val;
+	v4l2_std_id stdid;
+};
+
+/* Register offset macros */
+#define ADV7393_POWER_MODE_REG		(0x00)
+#define ADV7393_MODE_SELECT_REG		(0x01)
+#define ADV7393_MODE_REG0		(0x02)
+
+#define ADV7393_DAC123_OUTPUT_LEVEL	(0x0B)
+
+#define ADV7393_SOFT_RESET		(0x17)
+
+#define ADV7393_HD_MODE_REG1		(0x30)
+#define ADV7393_HD_MODE_REG2		(0x31)
+#define ADV7393_HD_MODE_REG3		(0x32)
+#define ADV7393_HD_MODE_REG4		(0x33)
+#define ADV7393_HD_MODE_REG5		(0x34)
+#define ADV7393_HD_MODE_REG6		(0x35)
+
+#define ADV7393_HD_MODE_REG7		(0x39)
+
+#define ADV7393_SD_MODE_REG1		(0x80)
+#define ADV7393_SD_MODE_REG2		(0x82)
+#define ADV7393_SD_MODE_REG3		(0x83)
+#define ADV7393_SD_MODE_REG4		(0x84)
+#define ADV7393_SD_MODE_REG5		(0x86)
+#define ADV7393_SD_MODE_REG6		(0x87)
+#define ADV7393_SD_MODE_REG7		(0x88)
+#define ADV7393_SD_MODE_REG8		(0x89)
+
+#define ADV7393_SD_TIMING_REG0		(0x8A)
+
+#define ADV7393_FSC_REG0		(0x8C)
+#define ADV7393_FSC_REG1		(0x8D)
+#define ADV7393_FSC_REG2		(0x8E)
+#define ADV7393_FSC_REG3		(0x8F)
+
+#define ADV7393_SD_CGMS_WSS0		(0x99)
+
+#define ADV7393_SD_HUE_ADJUST		(0xA0)
+#define ADV7393_SD_BRIGHTNESS_WSS	(0xA1)
+
+/* Default values for the registers */
+#define ADV7393_POWER_MODE_REG_DEFAULT		(0x10)
+#define ADV7393_HD_MODE_REG1_DEFAULT		(0x3C)	/* Changed Default
+							   720p EAV/SAV code*/
+#define ADV7393_HD_MODE_REG2_DEFAULT		(0x01)	/* Changed Pixel data
+							   valid */
+#define ADV7393_HD_MODE_REG3_DEFAULT		(0x00)	/* Color delay 0 clks */
+#define ADV7393_HD_MODE_REG4_DEFAULT		(0xEC)	/* Changed */
+#define ADV7393_HD_MODE_REG5_DEFAULT		(0x08)
+#define ADV7393_HD_MODE_REG6_DEFAULT		(0x00)
+#define ADV7393_HD_MODE_REG7_DEFAULT		(0x00)
+#define ADV7393_SOFT_RESET_DEFAULT		(0x02)
+#define ADV7393_COMPOSITE_POWER_VALUE		(0x10)
+#define ADV7393_COMPONENT_POWER_VALUE		(0x1C)
+#define ADV7393_SVIDEO_POWER_VALUE		(0x0C)
+#define ADV7393_SD_HUE_ADJUST_DEFAULT		(0x80)
+#define ADV7393_SD_BRIGHTNESS_WSS_DEFAULT	(0x00)
+
+#define ADV7393_SD_CGMS_WSS0_DEFAULT		(0x10)
+
+#define ADV7393_SD_MODE_REG1_DEFAULT		(0x10)
+#define ADV7393_SD_MODE_REG2_DEFAULT		(0xC9)
+#define ADV7393_SD_MODE_REG3_DEFAULT		(0x00)
+#define ADV7393_SD_MODE_REG4_DEFAULT		(0x00)
+#define ADV7393_SD_MODE_REG5_DEFAULT		(0x02)
+#define ADV7393_SD_MODE_REG6_DEFAULT		(0x8C)
+#define ADV7393_SD_MODE_REG7_DEFAULT		(0x14)
+#define ADV7393_SD_MODE_REG8_DEFAULT		(0x00)
+
+#define ADV7393_SD_TIMING_REG0_DEFAULT		(0x0C)
+
+/* Bit masks for Mode Select Register */
+#define INPUT_MODE_MASK			(0x70)
+#define SD_INPUT_MODE			(0x00)
+#define HD_720P_INPUT_MODE		(0x10)
+#define HD_1080I_INPUT_MODE		(0x10)
+
+/* Bit masks for Mode Register 0 */
+#define TEST_PATTERN_BLACK_BAR_EN	(0x04)
+#define YUV_OUTPUT_SELECT		(0x20)
+#define RGB_OUTPUT_SELECT		(0xDF)
+
+/* Bit masks for SD brightness/WSS */
+#define SD_BRIGHTNESS_VALUE_MASK	(0x7F)
+#define SD_BLANK_WSS_DATA_MASK		(0x80)
+
+/* Bit masks for soft reset register */
+#define SOFT_RESET			(0x02)
+
+/* Bit masks for HD Mode Register 1 */
+#define OUTPUT_STD_MASK		(0x03)
+#define OUTPUT_STD_SHIFT	(0)
+#define OUTPUT_STD_EIA0_2	(0x00)
+#define OUTPUT_STD_EIA0_1	(0x01)
+#define OUTPUT_STD_FULL		(0x02)
+#define EMBEDDED_SYNC		(0x04)
+#define EXTERNAL_SYNC		(0xFB)
+#define STD_MODE_MASK		(0x1F)
+#define STD_MODE_SHIFT		(3)
+#define STD_MODE_720P		(0x05)
+#define STD_MODE_720P_25	(0x08)
+#define STD_MODE_720P_30	(0x07)
+#define STD_MODE_720P_50	(0x06)
+#define STD_MODE_1080I		(0x0D)
+#define STD_MODE_1080I_25	(0x0E)
+#define STD_MODE_1080P_24	(0x11)
+#define STD_MODE_1080P_25	(0x10)
+#define STD_MODE_1080P_30	(0x0F)
+#define STD_MODE_525P		(0x00)
+#define STD_MODE_625P		(0x03)
+
+/* Bit masks for SD Mode Register 1 */
+#define SD_STD_MASK		(0x03)
+#define SD_STD_NTSC		(0x00)
+#define SD_STD_PAL_BDGHI	(0x01)
+#define SD_STD_PAL_M		(0x02)
+#define SD_STD_PAL_N		(0x03)
+#define SD_LUMA_FLTR_MASK	(0x07)
+#define SD_LUMA_FLTR_SHIFT	(2)
+#define SD_CHROMA_FLTR_MASK	(0x07)
+#define SD_CHROMA_FLTR_SHIFT	(5)
+
+/* Bit masks for SD Mode Register 2 */
+#define SD_PRPB_SSAF_EN		(0x01)
+#define SD_PRPB_SSAF_DI		(0xFE)
+#define SD_DAC_OUT1_EN		(0x02)
+#define SD_DAC_OUT1_DI		(0xFD)
+#define SD_PEDESTAL_EN		(0x08)
+#define SD_PEDESTAL_DI		(0xF7)
+#define SD_SQUARE_PIXEL_EN	(0x10)
+#define SD_SQUARE_PIXEL_DI	(0xEF)
+#define SD_PIXEL_DATA_VALID	(0x40)
+#define SD_ACTIVE_EDGE_EN	(0x80)
+#define SD_ACTIVE_EDGE_DI	(0x7F)
+
+/* Bit masks for HD Mode Register 6 */
+#define HD_PRPB_SYNC_EN		(0x04)
+#define HD_PRPB_SYNC_DI		(0xFB)
+#define HD_DAC_SWAP_EN		(0x08)
+#define HD_DAC_SWAP_DI		(0xF7)
+#define HD_GAMMA_CURVE_A	(0xEF)
+#define HD_GAMMA_CURVE_B	(0x10)
+#define HD_GAMMA_EN		(0x20)
+#define HD_GAMMA_DI		(0xDF)
+#define HD_ADPT_FLTR_MODEA	(0xBF)
+#define HD_ADPT_FLTR_MODEB	(0x40)
+#define HD_ADPT_FLTR_EN		(0x80)
+#define HD_ADPT_FLTR_DI		(0x7F)
+
+#define ADV7393_BRIGHTNESS_MAX	(63)
+#define ADV7393_BRIGHTNESS_MIN	(-64)
+#define ADV7393_BRIGHTNESS_DEF	(0)
+#define ADV7393_HUE_MAX		(127)
+#define ADV7393_HUE_MIN		(-128)
+#define ADV7393_HUE_DEF		(0)
+#define ADV7393_GAIN_MAX	(64)
+#define ADV7393_GAIN_MIN	(-64)
+#define ADV7393_GAIN_DEF	(0)
+
+#endif
diff --git linux-next-HEAD-6c86b58/include/media/adv7393.h linux-next-HEAD-6c86b58/include/media/adv7393.h
new file mode 100644
index 0000000..b28edf3
--- /dev/null
+++ linux-next-HEAD-6c86b58/include/media/adv7393.h
@@ -0,0 +1,28 @@
+/*
+ * ADV7393 header file
+ *
+ * Copyright (C) 2010-2012 ADVANSEE - http://www.advansee.com/
+ * Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
+ *
+ * Based on ADV7343 driver,
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef ADV7393_H
+#define ADV7393_H
+
+#define ADV7393_COMPOSITE_ID	(0)
+#define ADV7393_COMPONENT_ID	(1)
+#define ADV7393_SVIDEO_ID	(2)
+
+#endif				/* End of #ifndef ADV7393_H */
diff --git linux-next-HEAD-6c86b58.orig/include/media/v4l2-chip-ident.h linux-next-HEAD-6c86b58/include/media/v4l2-chip-ident.h
index 7395c81..58f914a 100644
--- linux-next-HEAD-6c86b58.orig/include/media/v4l2-chip-ident.h
+++ linux-next-HEAD-6c86b58/include/media/v4l2-chip-ident.h
@@ -180,6 +180,9 @@ enum {
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,
 
+	/* module adv7393: just ident 7393 */
+	V4L2_IDENT_ADV7393 = 7393,
+
 	/* module saa7706h: just ident 7706 */
 	V4L2_IDENT_SAA7706H = 7706,
 
