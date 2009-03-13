Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35008 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbZCMKaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:30:05 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2DATu6g022182
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 05:30:01 -0500
From: chaithrika@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [RFC 2/7] ARM: DaVinci: DM646x Video: ADV7343 video encoder driver
Date: Fri, 13 Mar 2009 14:38:39 +0530
Message-Id: <1236935319-32730-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chaithrika U S <chaithrika@ti.com>

ADV7343 video encoder driver

Add ADV7473 I2C based video encoder driver. This follows the v4l2-subdev
framework.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb repository located at
http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde

 drivers/media/video/Kconfig   |    9 +
 drivers/media/video/Makefile  |    1 +
 drivers/media/video/adv7343.c |  730 +++++++++++++++++++++++++++++++++++++++++
 include/media/adv7343.h       |  373 +++++++++++++++++++++
 4 files changed, 1113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/adv7343.c
 create mode 100644 include/media/adv7343.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 27f6397..16019e9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -426,6 +426,15 @@ config VIDEO_ADV7175
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7175.
 
+config VIDEO_ADV7343
+        tristate "ADV7343 video encoder"
+        depends on I2C
+        help
+          Support for Analog Devices I2C bus based ADV7343 encoder.
+
+          To compile this driver as a module, choose M here: the
+          module will be called adv7473.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 99b448e..7f9fc62 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
+obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
 obj-$(CONFIG_VIDEO_BT856) += bt856.o
diff --git a/drivers/media/video/adv7343.c b/drivers/media/video/adv7343.c
new file mode 100644
index 0000000..c912f1d
--- /dev/null
+++ b/drivers/media/video/adv7343.c
@@ -0,0 +1,730 @@
+/*
+ * adv7343 - ADV7343 Video Encoder Driver
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
+#include <linux/i2c.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/videodev2.h>
+#include <linux/uaccess.h>
+#include <linux/version.h>
+
+#include <media/adv7343.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+
+static int debug = 2;
+static unsigned char reg00 = 0x80;	/* Power Mode register */
+static unsigned char reg01 = 0x00;	/* MODE_SELECT_REG */
+static unsigned char reg02 = 0x20;	/* MODE_REG0 */
+static unsigned char reg30 = 0x3C;	/* HD_MODE_REG1 */
+static unsigned char reg35 = 0x00;	/* HD_MODE_REG6 */
+static unsigned char reg80 = ADV7343_SD_MODE_REG1_DEFAULT; /* SD_MODE_REG1 */
+static unsigned char reg82 = ADV7343_SD_MODE_REG2_DEFAULT; /* SD_MODE_REG2 */
+
+struct adv7343_state {
+	struct i2c_client *client;
+	u32 ident;
+	struct v4l2_subdev sd;
+	v4l2_std_id std;
+	int output;
+	int enable;
+	int bright;
+	int hue;
+	int gain;
+	int initialized;
+	int video_enable;
+	int ch_id;
+};
+
+static inline struct adv7343_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct adv7343_state, sd);
+}
+
+static inline int adv7343_write(struct v4l2_subdev *sd, u8 reg, u8 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+struct adv7343_std_info
+	adv7343_composite_std_info[ADV7343_COMPOSITE_NUM_STD] = {
+	{
+		ADV7343_SD_MODE_REG1, &reg80, SD_INPUT_MODE, (~(SD_STD_MASK)),
+		SD_STD_NTSC, 0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_NTSC,
+	},
+	{
+		ADV7343_SD_MODE_REG1, &reg80, SD_INPUT_MODE, (~(SD_STD_MASK)),
+		SD_STD_PAL_BDGHI, 0x8C, 0xCB, 0x8D, 0x8A, 0x8E, 0x09, 0x8F,
+		0x2A, V4L2_STD_PAL,
+	},
+};
+
+struct adv7343_std_info
+	adv7343_component_std_info[ADV7343_COMPONENT_NUM_STD] = {
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_720P << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_720P_60,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_720P_25 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_720P_25,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_720P_30 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_720P_30,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_720P_50 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_720P_50,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_1080I_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_1080I << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_1080I_30,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_1080I_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_1080I_25fps << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_1080I_25,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_525P << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_480P_60,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_720P_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_625P << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_576P_50,
+	},
+	{
+		ADV7343_SD_MODE_REG1, &reg80, SD_INPUT_MODE, (~(SD_STD_MASK)),
+		SD_STD_NTSC, 0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_NTSC,
+	},
+	{
+		ADV7343_SD_MODE_REG1, &reg80, SD_INPUT_MODE, (~(SD_STD_MASK)),
+		SD_STD_PAL_BDGHI, 0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F,
+		0x21, V4L2_STD_PAL,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_1080I_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_1080P_24 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_1080P_24,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_1080I_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_1080P_25 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_1080I_25,
+	},
+	{
+		ADV7343_HD_MODE_REG1, &reg30, HD_1080I_INPUT_MODE,
+		(~(STD_MODE_MASK << STD_MODE_SHIFT)),
+		(STD_MODE_1080P_30 << STD_MODE_SHIFT),
+		0x8C, 0x1F, 0x8D, 0x7C, 0x8E, 0xF0, 0x8F, 0x21,
+		V4L2_STD_1080P_30,
+	},
+};
+
+static struct adv7343_config adv7343_configuration[ADV7343_NUM_CHANNELS] = {
+	{
+		.no_of_outputs = ADV7343_MAX_NO_OUTPUTS,
+		.output[0] = {
+			.output_type	= ADV7343_COMPOSITE_ID,
+			.output_name	= VID_ENC_OUTPUT_COMPOSITE,
+			.no_of_standard	= ADV7343_COMPOSITE_NUM_STD,
+			.def_std	= V4L2_STD_NTSC,
+			.std_info	= (struct adv7343_std_info *)
+						&adv7343_composite_std_info,
+			.power_val	= ADV7343_COMPOSITE_POWER_VALUE,
+		},
+		.output[1] = {
+			.output_type	= ADV7343_COMPONENT_ID,
+			.output_name	= VID_ENC_OUTPUT_COMPONENT,
+			.no_of_standard	= ADV7343_COMPONENT_NUM_STD,
+			.def_std	= V4L2_STD_720P_60,
+			.std_info	= (struct adv7343_std_info *)
+						&adv7343_component_std_info,
+			.power_val	= ADV7343_COMPONENT_POWER_VALUE,
+		},
+		.output[2] = {
+			.output_type	= ADV7343_SVIDEO_ID,
+			.output_name	= VID_ENC_OUTPUT_SVIDEO,
+			.no_of_standard	= ADV7343_SVIDEO_NUM_STD,
+			.def_std	= V4L2_STD_NTSC,
+			.std_info	= (struct adv7343_std_info *)
+						&adv7343_composite_std_info,
+			.power_val	= ADV7343_SVIDEO_POWER_VALUE
+		},
+	},
+};
+
+static struct adv7343_channel adv7343_channel_info[ADV7343_NUM_CHANNELS] = {
+	{
+		.current_output	= ADV7343_COMPOSITE_ID,
+		.mode_info	= V4L2_STD_NTSC,
+	}
+};
+
+static int adv7343_setstd(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	int err = 0;
+	int i = 0;
+	struct adv7343_std_info *std_info;
+	int output_idx;
+	u8 reg, val;
+
+	int ch_id = (to_state(sd))->ch_id;
+	struct adv7343_config *config = &adv7343_configuration[ch_id];
+
+	v4l2_dbg(1, debug, sd, "Start of adv7343_setstd..\n");
+	output_idx = adv7343_channel_info[ch_id].current_output;
+	v4l2_dbg(1, debug, sd, "the output index is %d\n", output_idx);
+
+	for (i = 0; i < config->output[output_idx].no_of_standard; i++) {
+		std_info = &config->output[output_idx].std_info[i];
+		if (std_info->stdid ==  std)
+			break;
+	}
+
+	if (i == config->output[output_idx].no_of_standard) {
+		v4l2_err(sd, "Invalid id...\n");
+		return -EINVAL;
+	}
+
+	val = *(config->output[output_idx].std_info[i].value);
+	val &= config->output[output_idx].std_info[i].standard_val2;
+	val |= config->output[output_idx].std_info[i].standard_val3;
+	err |= adv7343_write(sd,
+		config->output[output_idx].std_info[i].set_std_register, val);
+	if (err < 0) {
+		v4l2_err(sd, "Set standard failed\n");
+		return err;
+	}
+	*(config->output[output_idx].std_info[i].value) = val;
+
+	val = reg01;
+	val &= (~((u8) INPUT_MODE_MASK));
+	val |= config->output[output_idx].std_info[i].outputmode_val1;
+	err |= adv7343_write(sd, ADV7343_MODE_SELECT_REG, val);
+	if (err < 0) {
+		v4l2_err(sd, "Set standard failed\n");
+		return err;
+	}
+	reg01 = val;
+
+	/* Store the standard in global object of adv7343 */
+	adv7343_channel_info[ch_id].mode_info =
+				config->output[output_idx].std_info[i].stdid;
+
+	reg = config->output[output_idx].std_info[i].fsc0_reg;
+	val = config->output[output_idx].std_info[i].fsc0_val;
+	err |= adv7343_write(sd, reg, val);
+
+	reg = config->output[output_idx].std_info[i].fsc1_reg;
+	val = config->output[output_idx].std_info[i].fsc1_val;
+	err |= adv7343_write(sd, reg, val);
+
+	reg = config->output[output_idx].std_info[i].fsc2_reg;
+	val = config->output[output_idx].std_info[i].fsc2_val;
+	err |= adv7343_write(sd, reg, val);
+
+	reg = config->output[output_idx].std_info[i].fsc3_reg;
+	val = config->output[output_idx].std_info[i].fsc3_val;
+	err |= adv7343_write(sd, reg, val);
+
+	val = reg80;
+
+	if (std == V4L2_STD_NTSC)
+		val &= 0x03;
+	else if (std ==  V4L2_STD_PAL)
+		val |= 0x04;
+
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG1, val);
+
+	reg80 = val;
+
+	v4l2_dbg(1, debug, sd, "</adv7343_setstd>\n");
+
+	return err;
+}
+
+/* Following function is used to set output format in ADV7343 device. The index
+   of the output format is  passed as the argument to this function. */
+static int adv7343_setoutput(struct v4l2_subdev *sd, int output_type)
+{
+	unsigned char val;
+	int i;
+	int index;
+	int err = 0;
+	int ch_id = (to_state(sd))->ch_id;
+	struct adv7343_config *config = &adv7343_configuration[ch_id];
+
+	v4l2_dbg(1, debug, sd, "Start of set output function.\n");
+
+	for (i = 0; i < config->no_of_outputs; i++) {
+		if (output_type == config->output[i].output_type)
+			break;
+	}
+
+	if (i == config->no_of_outputs) {
+		v4l2_err(sd, "Invalid output\n");
+		return -EINVAL;
+	}
+	index = i;
+
+	/* Enable Appropriate DAC */
+	val = reg00;
+	val &= 0x03;
+	val |= config->output[index].power_val;
+	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
+
+	reg00 = val;
+
+	/* Enable YUV output */
+	val = reg02;
+	val |= YUV_OUTPUT_SELECT;
+	err |= adv7343_write(sd, ADV7343_MODE_REG0, val);
+
+	reg02 = val;
+
+	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
+	val = reg82;
+	val &= (SD_DAC_1_DI & SD_DAC_2_DI);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
+	if (err < 0)
+		return err;
+	reg82 = val;
+
+	/* configure ED/HD Color DAC Swap and ED/HD RGB Input Enable bit to
+	 * zero */
+	val = reg35;
+	val &= (HD_RGB_INPUT_DI & HD_DAC_SWAP_DI);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG6, val);
+	if (err < 0)
+		return err;
+	reg35 = val;
+
+	adv7343_channel_info[ch_id].current_output = index;
+	adv7343_channel_info[ch_id].mode_info = config->output[index].def_std;
+
+	err |= adv7343_setstd(sd, adv7343_channel_info[ch_id].mode_info);
+
+	if (err < 0)
+		return err;
+
+	v4l2_dbg(1, debug, sd, "</adv7343_setoutput>\n");
+
+	return err;
+}
+
+static int adv7343_getstd(struct v4l2_subdev *sd,
+				v4l2_std_id *stdid)
+{
+	int err = 0;
+	int ch_id =  (to_state(sd))->ch_id;
+	int output_idx;
+
+	v4l2_dbg(1, debug, sd, "In getstd function.\n");
+	output_idx = adv7343_channel_info[ch_id].current_output;
+
+	*stdid = adv7343_channel_info[ch_id].mode_info;
+
+	return err;
+}
+
+static int adv7343_log_status(struct v4l2_subdev *sd)
+{
+	struct adv7343_state *state = to_state(sd);
+
+	v4l2_info(sd, "Standard: %llu\n", state->std);
+	v4l2_info(sd, "Output: %s\n", (state->output) ? "COMPOSITE" :
+							"COMPONENT");
+	v4l2_info(sd, "Channel: %d\n", state->ch_id);
+
+	return 0;
+}
+
+static int adv7343_initialize(struct v4l2_subdev *sd)
+{
+	int err = 0;
+	int ch_id = (to_state(sd))->ch_id; /* for now */
+	err |= adv7343_write(sd, ADV7343_SOFT_RESET,
+				ADV7343_SOFT_RESET_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_POWER_MODE_REG,
+				ADV7343_POWER_MODE_REG_DEFAULT);
+
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG1,
+				ADV7343_HD_MODE_REG1_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG2,
+				 ADV7343_HD_MODE_REG2_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG3,
+				ADV7343_HD_MODE_REG3_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG4,
+				ADV7343_HD_MODE_REG4_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG5,
+				ADV7343_HD_MODE_REG5_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG6,
+				ADV7343_HD_MODE_REG6_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_HD_MODE_REG7,
+				ADV7343_HD_MODE_REG7_DEFAULT);
+
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG1,
+				ADV7343_SD_MODE_REG1_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG2,
+				ADV7343_SD_MODE_REG2_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG3,
+				ADV7343_SD_MODE_REG3_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG4,
+				ADV7343_SD_MODE_REG4_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG5,
+				ADV7343_SD_MODE_REG5_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG6,
+				ADV7343_SD_MODE_REG6_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG7,
+				ADV7343_SD_MODE_REG7_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_MODE_REG8,
+				ADV7343_SD_MODE_REG8_DEFAULT);
+
+	err |= adv7343_write(sd, ADV7343_SD_HUE_REG,
+				ADV7343_SD_HUE_REG_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_CGMS_WSS0,
+				ADV7343_SD_CGMS_WSS0_DEFAULT);
+	err |= adv7343_write(sd, ADV7343_SD_BRIGHTNESS_WSS,
+				ADV7343_SD_BRIGHTNESS_WSS_DEFAULT);
+
+	if (err < 0) {
+		v4l2_err(sd, "Error in initializing!\n");
+		err = -EINVAL;
+		goto adv7343_init_exit;
+	}
+
+	adv7343_channel_info[ch_id].current_output = 0;
+	adv7343_channel_info[ch_id].mode_info =
+		    adv7343_composite_std_info[0].stdid;
+
+	/* Configure for default video standard */
+	err |= adv7343_setoutput(sd, adv7343_configuration[ch_id].
+					output[0].output_type);
+	err |= adv7343_setstd(sd, adv7343_configuration[ch_id].
+					output[0].def_std);
+
+	if (err < 0) {
+		err = -EINVAL;
+		goto adv7343_init_exit;
+	}
+
+	v4l2_dbg(1, debug, sd, "</adv7343_initialize>\n");
+
+adv7343_init_exit:
+	return err;
+}
+
+static int adv7343_reset(struct v4l2_subdev *sd, u32 val)
+{
+	v4l2_dbg(1, debug, sd, "Reset\n");
+	return adv7343_initialize(sd);
+}
+
+static int adv7343_init(struct v4l2_subdev *sd, u32 val)
+{
+	struct adv7343_state *state = to_state(sd);
+	if (!state->initialized) {
+		state->initialized = 1;
+		v4l2_dbg(1, debug, sd, "Initializing Encoder\n");
+		return adv7343_initialize(sd);
+	}
+
+	return 0;
+}
+
+static int adv7343_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+{
+	switch (qc->id) {
+	case V4L2_CID_BRIGHTNESS:
+	case V4L2_CID_HUE:
+		return v4l2_ctrl_query_fill_std(qc);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int adv7343_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct adv7343_state *state = to_state(sd);
+	int err = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (ctrl->value < 0 || ctrl->value > 127) {
+			v4l2_err(sd, "invalid brightness setting %d\n",
+					ctrl->value);
+			return -ERANGE;
+		}
+
+		state->bright = ctrl->value;
+		err = adv7343_write(sd, ADV7343_SD_BRIGHTNESS_WSS,
+					state->bright);
+		break;
+
+	case V4L2_CID_HUE:
+		if (ctrl->value < 0 || ctrl->value > 255) {
+			v4l2_err(sd, "invalid hue settings %d\n", ctrl->value);
+			return -ERANGE;
+		}
+
+		state->hue = ctrl->value;
+		err = adv7343_write(sd, ADV7343_SD_HUE_REG, state->hue);
+		break;
+
+	case V4L2_CID_GAIN:
+		if (ctrl->value < 0 || ctrl->value > 255) {
+			v4l2_err(sd, "invalid gain settings %d\n", ctrl->value);
+			return -ERANGE;
+		}
+
+		if ((ctrl->value > POSITIVE_GAIN_MAX) &&
+			(ctrl->value < NEGATIVE_GAIN_MIN)) {
+			v4l2_err(sd, "gain settings not within \
+					the specified range\n");
+			return -ERANGE;
+		} else {
+			state->gain = ctrl->value;
+			err = adv7343_write(sd, ADV7343_DAC2_OUTPUT_LEVEL,
+					state->gain);
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		v4l2_err(sd, "Failed tp set the encoder controls\n");
+
+	return 0;
+}
+
+static int adv7343_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct adv7343_state *state = to_state(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = state->bright;
+		break;
+
+	case V4L2_CID_HUE:
+		ctrl->value = state->hue;
+		break;
+
+	case V4L2_CID_GAIN:
+		ctrl->value = state->gain;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int adv7343_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *chip)
+{
+	struct adv7343_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, state->ident, 0);
+}
+
+static long adv7343_ioctl(struct v4l2_subdev *sd, unsigned cmd, void *arg)
+{
+	int err = 0;
+	v4l2_dbg(1, debug, sd, "ioctl\n");
+	switch (cmd) {
+	case ENCODER_GET_MODE:
+		err = adv7343_getstd(sd, (v4l2_std_id *)arg);
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static const struct v4l2_subdev_core_ops adv7343_core_ops = {
+	.log_status	= adv7343_log_status,
+	.g_chip_ident	= adv7343_g_chip_ident,
+	.g_ctrl		= adv7343_g_ctrl,
+	.s_ctrl		= adv7343_s_ctrl,
+	.queryctrl	= adv7343_queryctrl,
+	.reset		= adv7343_reset,
+	.init		= adv7343_init,
+	.ioctl		= adv7343_ioctl,
+};
+
+static int adv7343_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7343_state *state = to_state(sd);
+	int err = 0;
+
+	if (state->std == std)
+		return 0;
+
+	err = adv7343_setstd(sd, std);
+
+	if (!err)
+		state->std = std;
+	else
+		v4l2_err(sd, "s_std failed\n");
+
+	return err;
+}
+
+static int adv7343_s_routing(struct v4l2_subdev *sd,
+				const struct v4l2_routing *route)
+{
+	struct adv7343_state *state = to_state(sd);
+
+	int err = 0;
+
+	if (state->output == route->output)
+		return 0;
+
+	err = adv7343_setoutput(sd, route->output);
+	if (err)
+		v4l2_err(sd, "Error setting output\n");
+	else
+		state->output = route->output;
+
+	return err;
+}
+
+static const struct v4l2_subdev_video_ops adv7343_video_ops = {
+	.s_std_output	= adv7343_s_std_output,
+	.s_routing	= adv7343_s_routing,
+};
+
+static const struct v4l2_subdev_ops adv7343_ops = {
+	.core	= &adv7343_core_ops,
+	.video	= &adv7343_video_ops,
+};
+
+static int adv7343_command(struct i2c_client *client, unsigned cmd, void *arg)
+{
+	return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
+}
+
+static int adv7343_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct adv7343_state *state;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	v4l2_info(client, "chip found @ 0x%x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state = kzalloc(sizeof(struct adv7343_state), GFP_KERNEL);
+	if (state == NULL)
+		return -ENOMEM;
+
+	state->client	= client;
+	state->enable	= 1;
+	state->ch_id	= 0;
+	state->output	= -1;
+	state->initialized = 0;
+	state->ident = 0;
+	v4l2_i2c_subdev_init(&state->sd, client, &adv7343_ops);
+	v4l2_dbg(1, debug, client, "Registered the encoder\n");
+
+	return 0;
+}
+
+static int adv7343_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+
+	return 0;
+}
+
+static const struct i2c_device_id adv7343_id[] = {
+	{ADV7343_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, adv7343_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+	.name		= ADV7343_NAME,
+	.command	= adv7343_command,
+	.probe		= adv7343_probe,
+	.remove		= adv7343_remove,
+	.legacy_class	= I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
+	.id_table	= adv7343_id,
+};
+
+static __init int init_adv7343(void)
+{
+	return 0;
+}
+
+static __exit void exit_adv7343(void)
+{
+
+}
+
+module_init(init_adv7343);
+module_exit(exit_adv7343);
+MODULE_LICENSE("GPL");
diff --git a/include/media/adv7343.h b/include/media/adv7343.h
new file mode 100644
index 0000000..b7da4a6
--- /dev/null
+++ b/include/media/adv7343.h
@@ -0,0 +1,373 @@
+/*
+ * ADV7343 header file
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
+#ifndef ADV7343_H
+#define ADV7343_H
+
+#ifdef __KERNEL__
+
+/* Kernel Header files */
+#include <linux/i2c.h>
+#include <linux/device.h>
+#include <linux/videodev2.h>
+
+#endif				/* __KERNEL__ */
+
+#define ADV7343_NAME	"adv7343"
+
+/** VID_ENC_NAME_MAX_CHARS
+ *
+ * Description:
+ * MAX characters in the name.
+ */
+#define VID_ENC_NAME_MAX_CHARS	30
+
+/*
+ * constant strings for output names.
+ */
+#define VID_ENC_OUTPUT_COMPOSITE	"COMPOSITE"
+#define VID_ENC_OUTPUT_SVIDEO		"SVIDEO"
+#define	VID_ENC_OUTPUT_COMPONENT	"COMPONENT"
+
+/* Internal IOCTL defines */
+#define ENCODER_GET_MODE	_IOR('e', BASE_VIDIOC_PRIVATE + 1, v4l2_std_id*)
+
+/* Macros */
+#define ADV7343_MAX_GAMMA_COEFFS	(10)	/* Maximum Gamma Coefficients */
+
+#ifdef __KERNEL__
+
+#define ADV7343_COMPOSITE_OUTPUT_NAME	"COMPOSITE"
+#define ADV7343_COMPONENT_OUTPUT_NAME	"COMPONENT"
+#define ADV7343_SVIDEO_OUTPUT_NAME	"SVIDEO"
+
+#define ADV7343_COMPOSITE_ID	(0)
+#define ADV7343_COMPONENT_ID	(1)
+#define ADV7343_SVIDEO_ID	(2)
+
+#define ADV7343_COMPOSITE_NO_CONTROLS	(3)
+#define ADV7343_COMPONENT_NO_CONTROLS	(1)
+#define ADV7343_SVIDEO_NO_CONTROLS	(3)
+
+#define ADV7343_NUM_CHANNELS		(1)
+
+/* encoder standard related strctures */
+#define ADV7343_MAX_NO_OUTPUTS		(3)
+#define ADV7343_COMPOSITE_NUM_STD	(2)
+#define ADV7343_COMPONENT_NUM_STD	(7+3+3)
+#define ADV7343_SVIDEO_NUM_STD		(2)
+#define ADV7343_MAX_NO_CONTROLS		(3)
+#define ADV7343_VBI_NUM_SERVICES	(3)
+
+struct adv7343_std_info {
+	unsigned char set_std_register;
+	unsigned char *value;
+	u32 outputmode_val1;
+	u32 standard_val2;
+	u32 standard_val3;
+	u8 fsc0_reg, fsc0_val;
+	u8 fsc1_reg, fsc1_val;
+	u8 fsc2_reg, fsc2_val;
+	u8 fsc3_reg, fsc3_val;
+	v4l2_std_id stdid;
+};
+
+struct adv7343_config {
+	int no_of_outputs;
+	struct {
+		unsigned char power_val;
+		int output_type;
+		char output_name[VID_ENC_NAME_MAX_CHARS];
+		int no_of_standard;
+		v4l2_std_id def_std;
+		struct adv7343_std_info *std_info;
+	} output[ADV7343_MAX_NO_OUTPUTS];
+	unsigned short services_set;
+	u8 num_services;
+};
+
+struct adv7343_channel {
+	u8 current_output;
+	v4l2_std_id mode_info;
+	unsigned short services_set;
+};
+
+#define ADV7343_VALID_FEATURE_VAL(val)	((ADV7343_DISABLE == (val)) || \
+					(ADV7343_ENABLE == (val)))
+#define ADV7343_VALID_GAMMA_CURVE(val)	((ADV7343_GAMMA_CURVE_A == (val)) || \
+					(ADV7343_GAMMA_CURVE_B == (val)))
+
+/* Register offset macros */
+#define ADV7343_POWER_MODE_REG		(0x00)
+#define ADV7343_MODE_SELECT_REG		(0x01)
+#define ADV7343_MODE_REG0		(0x02)
+#define ADV7343_CSC_MATRIX0		(0x03)
+#define ADV7343_CSC_MATRIX1		(0x04)
+#define ADV7343_CSC_MATRIX2		(0x05)
+#define ADV7343_CSC_MATRIX3		(0x06)
+#define ADV7343_CSC_MATRIX4		(0x07)
+#define ADV7343_CSC_MATRIX5		(0x08)
+#define ADV7343_CSC_MATRIX6		(0x09)
+#define ADV7343_DAC1_OUTPUT_LEVEL	(0x0a)
+#define ADV7343_DAC2_OUTPUT_LEVEL	(0x0b)
+#define ADV7343_DAC_POWER_MODE		(0x0d)
+#define ADV7343_CABLE_DETECTION		(0x10)
+#define ADV7343_SBUS_READ		(0x12)
+#define ADV7343_YBUS_READ		(0x13)
+#define ADV7343_CBUS_READ		(0x14)
+#define ADV7343_CONTROL_READ		(0x16)
+#define ADV7343_SOFT_RESET		(0x17)
+#define ADV7343_HD_MODE_REG1		(0x30)
+#define ADV7343_HD_MODE_REG2		(0x31)
+#define ADV7343_HD_MODE_REG3		(0x32)
+#define ADV7343_HD_MODE_REG4		(0x33)
+#define ADV7343_HD_MODE_REG5		(0x34)
+#define ADV7343_HD_MODE_REG6		(0x35)
+#define ADV7343_HD_Y_LEVEL		(0x36)
+#define ADV7343_HD_CR_LEVEL		(0x37)
+#define ADV7343_HD_CB_LEVEL		(0x38)
+#define ADV7343_HD_MODE_REG7		(0x39)
+#define ADV7343_HD_SHARPNESS_FLTR_GAIN	(0x40)
+#define ADV7343_HD_CGMS_DATA_0		(0x41)
+#define ADV7343_HD_CGMS_DATA_1		(0x42)
+#define ADV7343_HD_CGMS_DATA_2		(0x43)
+#define ADV7343_HD_GAMMA_A0		(0x44)
+#define ADV7343_HD_GAMMA_A1		(0x45)
+#define ADV7343_HD_GAMMA_A2		(0x46)
+#define ADV7343_HD_GAMMA_A3		(0x47)
+#define ADV7343_HD_GAMMA_A4		(0x48)
+#define ADV7343_HD_GAMMA_A5		(0x49)
+#define ADV7343_HD_GAMMA_A6		(0x4a)
+#define ADV7343_HD_GAMMA_A7		(0x4b)
+#define ADV7343_HD_GAMMA_A8		(0x4c)
+#define ADV7343_HD_GAMMA_A9		(0x4d)
+#define ADV7343_HD_GAMMA_B0		(0x4E)
+#define ADV7343_HD_GAMMA_B1		(0x4F)
+#define ADV7343_HD_GAMMA_B2		(0x50)
+#define ADV7343_HD_GAMMA_B3		(0x51)
+#define ADV7343_HD_GAMMA_B4		(0x52)
+#define ADV7343_HD_GAMMA_B5		(0x53)
+#define ADV7343_HD_GAMMA_B6		(0x54)
+#define ADV7343_HD_GAMMA_B7		(0x55)
+#define ADV7343_HD_GAMMA_B8		(0x56)
+#define ADV7343_HD_GAMMA_B9		(0x57)
+#define ADV7343_HD_ADPT_FLTR_GAIN1	(0x58)
+#define ADV7343_HD_ADPT_FLTR_GAIN2	(0x59)
+#define ADV7343_HD_ADPT_FLTR_GAIN3	(0x5a)
+#define ADV7343_HD_ADPT_FLTR_THRLDA	(0x5b)
+#define ADV7343_HD_ADPT_FLTR_THRLDB	(0x5c)
+#define ADV7343_HD_ADPT_FLTR_THRLDC	(0x5d)
+#define ADV7343_HD_CGMS_B0		(0x5E)
+#define ADV7343_HD_CGMS_B1		(0x5F)
+#define ADV7343_HD_CGMS_B2		(0x60)
+#define ADV7343_HD_CGMS_B3		(0x61)
+#define ADV7343_HD_CGMS_B4		(0x62)
+#define ADV7343_HD_CGMS_B5		(0x63)
+#define ADV7343_HD_CGMS_B6		(0x64)
+#define ADV7343_HD_CGMS_B7		(0x65)
+#define ADV7343_HD_CGMS_B8		(0x66)
+#define ADV7343_HD_CGMS_B9		(0x67)
+#define ADV7343_HD_CGMS_B10		(0x68)
+#define ADV7343_HD_CGMS_B11		(0x69)
+#define ADV7343_HD_CGMS_B12		(0x6A)
+#define ADV7343_HD_CGMS_B13		(0x6B)
+#define ADV7343_HD_CGMS_B14		(0x6C)
+#define ADV7343_HD_CGMS_B15		(0x6D)
+#define ADV7343_HD_CGMS_B16		(0x6E)
+
+#define ADV7343_SD_MODE_REG1		(0x80)
+#define ADV7343_SD_MODE_REG2		(0x82)
+#define ADV7343_SD_MODE_REG3		(0x83)
+#define ADV7343_SD_MODE_REG4		(0x84)
+#define ADV7343_SD_MODE_REG5		(0x86)
+#define ADV7343_SD_MODE_REG6		(0x87)
+#define ADV7343_SD_MODE_REG7		(0x88)
+#define ADV7343_SD_MODE_REG8		(0x89)
+#define ADV7343_SD_TIMING_REG0		(0x8A)
+#define ADV7343_SD_TIMING_REG1		(0x8B)
+#define ADV7343_SD_FSC_REG0		(0x8C)
+#define ADV7343_SD_FSC_REG1		(0x8D)
+#define ADV7343_SD_FSC_REG2		(0x8E)
+#define ADV7343_SD_FSC_REG3		(0x8F)
+#define ADV7343_SD_FSC_PHASE		(0x90)
+#define ADV7343_SD_CLOSE_CAPTION_EVEN0	(0x91)
+#define ADV7343_SD_CLOSE_CAPTION_EVEN1	(0x92)
+#define ADV7343_SD_CLOSE_CAPTION_ODD0	(0x93)
+#define ADV7343_SD_CLOSE_CAPTION_ODD1	(0x94)
+#define ADV7343_SD_PEDESTAL_REG0	(0x95)
+#define ADV7343_SD_PEDESTAL_REG1	(0x96)
+#define ADV7343_SD_PEDESTAL_REG2	(0x97)
+#define ADV7343_SD_PEDESTAL_REG3	(0x98)
+#define ADV7343_SD_CGMS_WSS0		(0x99)
+#define ADV7343_SD_CGMS_WSS1		(0x9A)
+#define ADV7343_SD_CGMS_WSS2		(0x9B)
+
+#define ADV7343_SD_SCALE_LSB		(0x9C)
+#define ADV7343_SD_Y_SCALE		(0x9D)
+#define ADV7343_SD_CB_SCALE		(0x9E)
+#define ADV7343_SD_CR_SCALE		(0x9F)
+
+#define ADV7343_SD_HUE_REG		(0xA0)
+#define ADV7343_SD_BRIGHTNESS_WSS	(0xA1)
+#define ADV7343_SD_LUMA_SSAF		(0xA2)
+#define ADV7343_SD_DNR0			(0xA3)
+#define ADV7343_SD_DNR1			(0xA4)
+#define ADV7343_SD_DNR2			(0xA5)
+
+#define ADV7343_SD_GAMMA_A0		(0xA6)
+#define ADV7343_SD_GAMMA_A1		(0xA7)
+#define ADV7343_SD_GAMMA_A2		(0xA8)
+#define ADV7343_SD_GAMMA_A3		(0xA9)
+#define ADV7343_SD_GAMMA_A4		(0xAA)
+#define ADV7343_SD_GAMMA_A5		(0xAB)
+#define ADV7343_SD_GAMMA_A6		(0xAC)
+#define ADV7343_SD_GAMMA_A7		(0xAD)
+#define ADV7343_SD_GAMMA_A8		(0xAE)
+#define ADV7343_SD_GAMMA_A9		(0xAF)
+#define ADV7343_SD_GAMMA_B0		(0xB0)
+#define ADV7343_SD_GAMMA_B1		(0xB1)
+#define ADV7343_SD_GAMMA_B2		(0xB2)
+#define ADV7343_SD_GAMMA_B3		(0xB3)
+#define ADV7343_SD_GAMMA_B4		(0xB4)
+#define ADV7343_SD_GAMMA_B5		(0xB5)
+#define ADV7343_SD_GAMMA_B6		(0xB6)
+#define ADV7343_SD_GAMMA_B7		(0xB7)
+#define ADV7343_SD_GAMMA_B8		(0xB8)
+#define ADV7343_SD_GAMMA_B9		(0xB9)
+#define ADV7343_SD_BRIGHTNESS_DETECT	(0xBA)
+#define ADV7343_FIELD_COUNT_REG		(0xBB)
+#define ADV7343_10_BIT_INPUT		(0x7C)
+
+/* Default values for the registers */
+#define ADV7343_POWER_MODE_REG_DEFAULT		(0x10)
+#define ADV7343_HD_MODE_REG1_DEFAULT		(0x3C)	/* Changed Default
+							   720p EAVSAV code*/
+#define ADV7343_HD_MODE_REG2_DEFAULT		(0x01)	/* Changed Pixel data
+							   valid */
+#define ADV7343_HD_MODE_REG3_DEFAULT		(0x00)	/* Color delay 0 clks */
+#define ADV7343_HD_MODE_REG4_DEFAULT		(0xE8)	/* Changed */
+#define ADV7343_HD_MODE_REG5_DEFAULT		(0x08)
+#define ADV7343_HD_MODE_REG6_DEFAULT		(0x00)
+#define ADV7343_HD_MODE_REG7_DEFAULT		(0x00)
+
+#define ADV7343_SD_MODE_REG1_DEFAULT		(0x00)
+#define ADV7343_SD_MODE_REG2_DEFAULT		(0xC9)
+#define ADV7343_SD_MODE_REG3_DEFAULT		(0x10)
+#define ADV7343_SD_MODE_REG4_DEFAULT		(0x01)
+#define ADV7343_SD_MODE_REG5_DEFAULT		(0x02)
+#define ADV7343_SD_MODE_REG6_DEFAULT		(0x0C)
+#define ADV7343_SD_MODE_REG7_DEFAULT		(0x04)
+#define ADV7343_SD_MODE_REG8_DEFAULT		(0x00)
+#define ADV7343_SOFT_RESET_DEFAULT		(0x02)
+#define ADV7343_COMPOSITE_POWER_VALUE		(0x80)
+#define ADV7343_COMPONENT_POWER_VALUE		(0x1C)
+#define ADV7343_SVIDEO_POWER_VALUE		(0x60)
+#define ADV7343_SD_HUE_REG_DEFAULT		(127)
+#define ADV7343_SD_BRIGHTNESS_WSS_DEFAULT	(0x03)
+#define ADV7343_SD_CGMS_WSS0_DEFAULT		(0x10)
+
+/* Macros for the Mode Select Register */
+#ifdef GENERATE_MASK
+#undef GENERATE_MASK
+#endif
+#define GENERATE_MASK(bits, pos)	((((0xFF) << (8 - bits)) >> \
+					(8 - bits)) << pos)
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
+/* Bit masks for DAC output levels */
+#define DAC_OUTPUT_LEVEL_MASK		(0xFF)
+#define POSITIVE_GAIN_MAX		(0x40)
+#define POSITIVE_GAIN_MIN		(0x00)
+#define NEGATIVE_GAIN_MAX		(0xFF)
+#define NEGATIVE_GAIN_MIN		(0xC0)
+
+/* Bit masks for soft reset register */
+#define SOFT_RESET			(0x02)
+
+/* Bit masks for HD Mode Register 1 */
+#define OUTPUT_STD_MASK			(0x03)
+#define OUTPUT_STD_SHIFT		(0)
+#define OUTPUT_STD_EIA0_2		(0x00)
+#define OUTPUT_STD_EIA0_1		(0x01)
+#define OUTPUT_STD_FULL			(0x02)
+#define EMBEDDED_SYNC			(0x04)
+#define EXTERNAL_SYNC			(0xFB)
+#define STD_MODE_SHIFT			(3)
+#define STD_MODE_MASK			(0x1F)
+#define STD_MODE_720P			(0x05)
+#define STD_MODE_720P_25		(0x08)
+#define STD_MODE_720P_30		(0x07)
+#define STD_MODE_720P_50		(0x06)
+#define STD_MODE_1080I			(0x0D)
+#define STD_MODE_1080I_25fps		(0x0E)
+#define STD_MODE_1080P_24		(0x12)
+#define STD_MODE_1080P_25		(0x10)
+#define STD_MODE_1080P_30		(0x0F)
+#define STD_MODE_525P			(0x00)
+#define STD_MODE_625P			(0x03)
+
+/* Bit masks for SD Mode Register 1 */
+#define SD_STD_MASK			(0x03)
+#define SD_STD_NTSC			(0x00)
+#define SD_STD_PAL_BDGHI		(0x01)
+#define SD_STD_PAL_M			(0x02)
+#define SD_STD_PAL_N			(0x03)
+#define SD_LUMA_FLTR_MASK		(0x7)
+#define SD_LUMA_FLTR_SHIFT		(0x2)
+#define SD_CHROMA_FLTR_MASK		(0x7)
+#define SD_CHROMA_FLTR_SHIFT		(0x5)
+
+/* Bit masks for SD Mode Register 2 */
+#define SD_PBPR_SSAF_EN			(0x01)
+#define SD_PBPR_SSAF_DI			(0xFE)
+#define SD_DAC_1_DI			(0xFD)
+#define SD_DAC_2_DI			(0xFB)
+#define SD_PEDESTAL_EN			(0x08)
+#define SD_PEDESTAL_DI			(0xF7)
+#define SD_SQUARE_PIXEL_EN		(0x10)
+#define SD_SQUARE_PIXEL_DI		(0xEF)
+#define SD_PIXEL_DATA_VALID		(0x40)
+#define SD_ACTIVE_EDGE_EN		(0x80)
+#define SD_ACTIVE_EDGE_DI		(0x7F)
+
+/* Bit masks for HD Mode Register 6 */
+#define HD_RGB_INPUT_EN			(0x02)
+#define HD_RGB_INPUT_DI			(0xFD)
+#define HD_PBPR_SYNC_EN			(0x04)
+#define HD_PBPR_SYNC_DI			(0xFB)
+#define HD_DAC_SWAP_EN			(0x08)
+#define HD_DAC_SWAP_DI			(0xF7)
+#define HD_GAMMA_CURVE_A		(0xEF)
+#define HD_GAMMA_CURVE_B		(0x10)
+#define HD_GAMMA_EN			(0x20)
+#define HD_GAMMA_DI			(0xDF)
+#define HD_ADPT_FLTR_MODEB		(0x40)
+#define HD_ADPT_FLTR_MODEA		(0xBF)
+#define HD_ADPT_FLTR_EN			(0x80)
+#define HD_ADPT_FLTR_DI			(0x7F)
+
+#endif				/* End of #ifdef __KERNEL__ */
+
+#endif				/* End of #ifndef ADV7343_H */
-- 
1.5.6

