Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:33618 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032217AbeCAP3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 10:29:48 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        tfiga@chromium.org, Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Subject: [PATCH v6] media: imx258: Add imx258 camera sensor driver
Date: Thu,  1 Mar 2018 23:34:29 +0800
Message-Id: <1519918469-32528-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
This is a camera sensor using the I2C bus for control and the
CSI-2 bus for data.

Signed-off-by: Andy Yeh <andy.yeh@intel.com>
Signed-off-by: Jason Chen <jasonx.z.chen@intel.com>
Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
---
since v2:
-- Update the streaming function to remove SW_STANDBY in the beginning.
-- Adjust the delay time from 1ms to 12ms before set stream-on register.
since v3:
-- fix the sd.entity to make code be compiled on the mainline kernel.
since v4:
-- Enabled AG, DG, and Exposure time control correctly.
since v5:
-- Sensor vendor provided a new setting to fix different CLK issue
-- Add i2c seq write function for writing 2 registers in 1 write command.

 MAINTAINERS                |    7 +
 drivers/media/i2c/Kconfig  |   11 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/imx258.c | 1214 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1233 insertions(+)
 create mode 100644 drivers/media/i2c/imx258.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a339bb5..9f75510 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12646,6 +12646,13 @@ S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/
 
+SONY IMX258 SENSOR DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/imx258.c
+
 SONY IMX274 SENSOR DRIVER
 M:	Leon Luo <leonl@leopardimaging.com>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index fd01842..bcd4bf1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -565,6 +565,17 @@ config VIDEO_APTINA_PLL
 config VIDEO_SMIAPP_PLL
 	tristate
 
+config VIDEO_IMX258
+	tristate "Sony IMX258 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Sony
+	  IMX258 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called imx258.
+
 config VIDEO_IMX274
 	tristate "Sony IMX274 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 1b62639..4bf7d00 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
 obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
 obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
+obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
 obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
 
 obj-$(CONFIG_SDR_MAX2175) += max2175.o
diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
new file mode 100644
index 0000000..0d0830d
--- /dev/null
+++ b/drivers/media/i2c/imx258.c
@@ -0,0 +1,1214 @@
+// Copyright (C) 2018 Intel Corporation
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/acpi.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#define IMX258_REG_VALUE_08BIT		1
+#define IMX258_REG_VALUE_16BIT		2
+#define IMX258_REG_VALUE_24BIT		3
+
+#define IMX258_REG_MODE_SELECT		0x0100
+#define IMX258_MODE_STANDBY		0x00
+#define IMX258_MODE_STREAMING		0x01
+
+/* Chip ID */
+#define IMX258_REG_CHIP_ID		0x0016
+#define IMX258_CHIP_ID			0x0258
+
+/* V_TIMING internal */
+#define IMX258_REG_VTS			0x0340
+#define IMX258_VTS_30FPS		0x0c98
+#define IMX258_VTS_MAX			0xffff
+
+/*Frame Length Line*/
+#define IMX258_FLL_MIN			0x08a6
+#define IMX258_FLL_MAX			0xffff
+#define IMX258_FLL_STEP			1
+#define IMX258_FLL_DEFAULT		0x0c98
+
+/* HBLANK control - read only */
+#define IMX258_PPL_650MHZ		5352
+#define IMX258_PPL_325MHZ		2676
+
+/* Exposure control */
+#define IMX258_REG_EXPOSURE		0x0202
+#define IMX258_EXPOSURE_MIN		4
+#define IMX258_EXPOSURE_STEP		1
+#define IMX258_EXPOSURE_DEFAULT		0x640
+#define IMX258_EXPOSURE_MAX		65535
+
+/* Analog gain control */
+#define IMX258_REG_ANALOG_GAIN		0x0204
+#define IMX258_ANA_GAIN_MIN		0
+#define IMX258_ANA_GAIN_MAX		0x1fff
+#define IMX258_ANA_GAIN_STEP		1
+#define IMX258_ANA_GAIN_DEFAULT		0x0
+
+/* Digital gain control */
+#define IMX258_REG_GR_DIGITAL_GAIN	0x020e
+#define IMX258_REG_R_DIGITAL_GAIN	0x0210
+#define IMX258_REG_B_DIGITAL_GAIN	0x0212
+#define IMX258_REG_GB_DIGITAL_GAIN	0x0214
+#define IMX258_DGTL_GAIN_MIN		0
+#define IMX258_DGTL_GAIN_MAX		4096   /* Max = 0xFFF */
+#define IMX258_DGTL_GAIN_DEFAULT	1024
+#define IMX258_DGTL_GAIN_STEP           1
+
+/* Orientation */
+#define REG_MIRROR_FLIP_CONTROL	0x0101
+#define REG_CONFIG_MIRROR_FLIP		0x03
+
+struct imx258_reg {
+	u16 address;
+	u8 val;
+};
+
+struct imx258_reg_list {
+	u32 num_of_regs;
+	const struct imx258_reg *regs;
+};
+
+/* Link frequency config */
+struct imx258_link_freq_config {
+	u32 pixels_per_line;
+
+	/* PLL registers for this link frequency */
+	struct imx258_reg_list reg_list;
+};
+
+/* Mode : resolution and related config&values */
+struct imx258_mode {
+	/* Frame width */
+	u32 width;
+	/* Frame height */
+	u32 height;
+
+	/* V-timing */
+	u32 vts_def;
+	u32 vts_min;
+
+	/* Index of Link frequency config to be used */
+	u32 link_freq_index;
+	/* Default register values */
+	struct imx258_reg_list reg_list;
+};
+
+/* 4208x3118 needs 1300Mbps/lane, 4 lanes */
+static const struct imx258_reg mipi_data_rate_1300mbps[] = {
+	{0x0301, 0x05},
+	{0x0303, 0x02},
+	{0x0305, 0x03},
+	{0x0306, 0x00},
+	{0x0307, 0xC6},
+	{0x0309, 0x0A},
+	{0x030B, 0x01},
+	{0x030D, 0x02},
+	{0x030E, 0x00},
+	{0x030F, 0xD8},
+	{0x0310, 0x00},
+	{0x0820, 0x13},
+	{0x0821, 0x4C},
+	{0x0822, 0xCC},
+	{0x0823, 0xCC},
+};
+
+static const struct imx258_reg mipi_data_rate_650mbps[] = {
+	{0x0301, 0x05},
+	{0x0303, 0x02},
+	{0x0305, 0x03},
+	{0x0306, 0x00},
+	{0x0307, 0xC6},
+	{0x0309, 0x0A},
+	{0x030B, 0x01},
+	{0x030D, 0x02},
+	{0x030E, 0x00},
+	{0x030F, 0xD8},
+	{0x0310, 0x00},
+	{0x0820, 0x0A},
+	{0x0821, 0x00},
+	{0x0822, 0x00},
+	{0x0823, 0x00},
+};
+
+static const struct imx258_reg mode_4208x3118_regs[] = {
+	{0x0136, 0x13},
+	{0x0137, 0x33},
+	{0x3051, 0x00},
+	{0x3052, 0x00},
+	{0x4E21, 0x14},
+	{0x6B11, 0xCF},
+	{0x7FF0, 0x08},
+	{0x7FF1, 0x0F},
+	{0x7FF2, 0x08},
+	{0x7FF3, 0x1B},
+	{0x7FF4, 0x23},
+	{0x7FF5, 0x60},
+	{0x7FF6, 0x00},
+	{0x7FF7, 0x01},
+	{0x7FF8, 0x00},
+	{0x7FF9, 0x78},
+	{0x7FFA, 0x00},
+	{0x7FFB, 0x00},
+	{0x7FFC, 0x00},
+	{0x7FFD, 0x00},
+	{0x7FFE, 0x00},
+	{0x7FFF, 0x03},
+	{0x7F76, 0x03},
+	{0x7F77, 0xFE},
+	{0x7FA8, 0x03},
+	{0x7FA9, 0xFE},
+	{0x7B24, 0x81},
+	{0x7B25, 0x00},
+	{0x6564, 0x07},
+	{0x6B0D, 0x41},
+	{0x653D, 0x04},
+	{0x6B05, 0x8C},
+	{0x6B06, 0xF9},
+	{0x6B08, 0x65},
+	{0x6B09, 0xFC},
+	{0x6B0A, 0xCF},
+	{0x6B0B, 0xD2},
+	{0x6700, 0x0E},
+	{0x6707, 0x0E},
+	{0x9104, 0x00},
+	{0x4648, 0x7F},
+	{0x7420, 0x00},
+	{0x7421, 0x1C},
+	{0x7422, 0x00},
+	{0x7423, 0xD7},
+	{0x5F04, 0x00},
+	{0x5F05, 0xED},
+	{0x0112, 0x0A},
+	{0x0113, 0x0A},
+	{0x0114, 0x03},
+	{0x0342, 0x14},
+	{0x0343, 0xE8},
+	{0x0340, 0x0C},
+	{0x0341, 0x50},
+	{0x0344, 0x00},
+	{0x0345, 0x00},
+	{0x0346, 0x00},
+	{0x0347, 0x00},
+	{0x0348, 0x10},
+	{0x0349, 0x6F},
+	{0x034A, 0x0C},
+	{0x034B, 0x2E},
+	{0x0381, 0x01},
+	{0x0383, 0x01},
+	{0x0385, 0x01},
+	{0x0387, 0x01},
+	{0x0900, 0x00},
+	{0x0901, 0x11},
+	{0x0401, 0x00},
+	{0x0404, 0x00},
+	{0x0405, 0x10},
+	{0x0408, 0x00},
+	{0x0409, 0x00},
+	{0x040A, 0x00},
+	{0x040B, 0x00},
+	{0x040C, 0x10},
+	{0x040D, 0x70},
+	{0x040E, 0x0C},
+	{0x040F, 0x30},
+	{0x3038, 0x00},
+	{0x303A, 0x00},
+	{0x303B, 0x10},
+	{0x300D, 0x00},
+	{0x034C, 0x10},
+	{0x034D, 0x70},
+	{0x034E, 0x0C},
+	{0x034F, 0x30},
+	{0x0202, 0x0C},
+	{0x0203, 0x46},
+	{0x0204, 0x00},
+	{0x0205, 0x00},
+	{0x020E, 0x01},
+	{0x020F, 0x00},
+	{0x0210, 0x01},
+	{0x0211, 0x00},
+	{0x0212, 0x01},
+	{0x0213, 0x00},
+	{0x0214, 0x01},
+	{0x0215, 0x00},
+	{0x7BCD, 0x00},
+	{0x94DC, 0x20},
+	{0x94DD, 0x20},
+	{0x94DE, 0x20},
+	{0x95DC, 0x20},
+	{0x95DD, 0x20},
+	{0x95DE, 0x20},
+	{0x7FB0, 0x00},
+	{0x9010, 0x3E},
+	{0x9419, 0x50},
+	{0x941B, 0x50},
+	{0x9519, 0x50},
+	{0x951B, 0x50},
+	{0x3030, 0x00},
+	{0x3032, 0x00},
+	{0x0220, 0x00},
+};
+
+static const struct imx258_reg mode_2104_1560_regs[] = {
+	{0x0136, 0x13},
+	{0x0137, 0x33},
+	{0x3051, 0x00},
+	{0x3052, 0x00},
+	{0x4E21, 0x14},
+	{0x6B11, 0xCF},
+	{0x7FF0, 0x08},
+	{0x7FF1, 0x0F},
+	{0x7FF2, 0x08},
+	{0x7FF3, 0x1B},
+	{0x7FF4, 0x23},
+	{0x7FF5, 0x60},
+	{0x7FF6, 0x00},
+	{0x7FF7, 0x01},
+	{0x7FF8, 0x00},
+	{0x7FF9, 0x78},
+	{0x7FFA, 0x00},
+	{0x7FFB, 0x00},
+	{0x7FFC, 0x00},
+	{0x7FFD, 0x00},
+	{0x7FFE, 0x00},
+	{0x7FFF, 0x03},
+	{0x7F76, 0x03},
+	{0x7F77, 0xFE},
+	{0x7FA8, 0x03},
+	{0x7FA9, 0xFE},
+	{0x7B24, 0x81},
+	{0x7B25, 0x00},
+	{0x6564, 0x07},
+	{0x6B0D, 0x41},
+	{0x653D, 0x04},
+	{0x6B05, 0x8C},
+	{0x6B06, 0xF9},
+	{0x6B08, 0x65},
+	{0x6B09, 0xFC},
+	{0x6B0A, 0xCF},
+	{0x6B0B, 0xD2},
+	{0x6700, 0x0E},
+	{0x6707, 0x0E},
+	{0x9104, 0x00},
+	{0x4648, 0x7F},
+	{0x7420, 0x00},
+	{0x7421, 0x1C},
+	{0x7422, 0x00},
+	{0x7423, 0xD7},
+	{0x5F04, 0x00},
+	{0x5F05, 0xED},
+	{0x0112, 0x0A},
+	{0x0113, 0x0A},
+	{0x0114, 0x03},
+	{0x0342, 0x14},
+	{0x0343, 0xE8},
+	{0x0340, 0x06},
+	{0x0341, 0x38},
+	{0x0344, 0x00},
+	{0x0345, 0x00},
+	{0x0346, 0x00},
+	{0x0347, 0x00},
+	{0x0348, 0x10},
+	{0x0349, 0x6F},
+	{0x034A, 0x0C},
+	{0x034B, 0x2E},
+	{0x0381, 0x01},
+	{0x0383, 0x01},
+	{0x0385, 0x01},
+	{0x0387, 0x01},
+	{0x0900, 0x01},
+	{0x0901, 0x12},
+	{0x0401, 0x01},
+	{0x0404, 0x00},
+	{0x0405, 0x20},
+	{0x0408, 0x00},
+	{0x0409, 0x02},
+	{0x040A, 0x00},
+	{0x040B, 0x00},
+	{0x040C, 0x10},
+	{0x040D, 0x6A},
+	{0x040E, 0x06},
+	{0x040F, 0x18},
+	{0x3038, 0x00},
+	{0x303A, 0x00},
+	{0x303B, 0x10},
+	{0x300D, 0x00},
+	{0x034C, 0x08},
+	{0x034D, 0x38},
+	{0x034E, 0x06},
+	{0x034F, 0x18},
+	{0x0202, 0x06},
+	{0x0203, 0x2E},
+	{0x0204, 0x00},
+	{0x0205, 0x00},
+	{0x020E, 0x01},
+	{0x020F, 0x00},
+	{0x0210, 0x01},
+	{0x0211, 0x00},
+	{0x0212, 0x01},
+	{0x0213, 0x00},
+	{0x0214, 0x01},
+	{0x0215, 0x00},
+	{0x7BCD, 0x01},
+	{0x94DC, 0x20},
+	{0x94DD, 0x20},
+	{0x94DE, 0x20},
+	{0x95DC, 0x20},
+	{0x95DD, 0x20},
+	{0x95DE, 0x20},
+	{0x7FB0, 0x00},
+	{0x9010, 0x3E},
+	{0x9419, 0x50},
+	{0x941B, 0x50},
+	{0x9519, 0x50},
+	{0x951B, 0x50},
+	{0x3030, 0x00},
+	{0x3032, 0x00},
+	{0x0220, 0x00},
+};
+
+static const char * const imx258_test_pattern_menu[] = {
+	"Disabled",
+	"Vertical Color Bar Type 1",
+	"Vertical Color Bar Type 2",
+	"Vertical Color Bar Type 3",
+	"Vertical Color Bar Type 4"
+};
+
+/* Configurations for supported link frequencies */
+#define IMX258_LINK_FREQ_650MHZ	649600000ULL
+#define IMX258_LINK_FREQ_325MHZ	324800000ULL
+
+/*
+ * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
+ * data rate => double data rate; number of lanes => 4; bits per pixel => 10
+ */
+static u64 link_freq_to_pixel_rate(u64 f)
+{
+	f *= 2 * 4;
+	do_div(f, 10);
+
+	return f;
+}
+
+/* Menu items for LINK_FREQ V4L2 control */
+static const s64 link_freq_menu_items[] = {
+	IMX258_LINK_FREQ_650MHZ,
+	IMX258_LINK_FREQ_325MHZ,
+};
+
+/* Link frequency configs */
+static const struct imx258_link_freq_config link_freq_configs[] = {
+	{
+		.pixels_per_line = IMX258_PPL_650MHZ,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1300mbps),
+			.regs = mipi_data_rate_1300mbps,
+		}
+	},
+	{
+		.pixels_per_line = IMX258_PPL_325MHZ,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mipi_data_rate_650mbps),
+			.regs = mipi_data_rate_650mbps,
+		}
+	},
+};
+
+/* Mode configs */
+static const struct imx258_mode supported_modes[] = {
+	{
+		.width = 4208,
+		.height = 3118,
+		.vts_def = IMX258_VTS_30FPS,
+		.vts_min = IMX258_VTS_30FPS,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_4208x3118_regs),
+			.regs = mode_4208x3118_regs,
+		},
+		.link_freq_index = 0,
+	},
+	{
+		.width = 2104,
+		.height = 1560,
+		.vts_def = IMX258_VTS_30FPS,
+		.vts_min = 1608,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_2104_1560_regs),
+			.regs = mode_2104_1560_regs,
+		},
+		.link_freq_index = 1,
+	},
+};
+
+struct imx258 {
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* V4L2 Controls */
+	struct v4l2_ctrl *link_freq;
+	struct v4l2_ctrl *pixel_rate;
+	struct v4l2_ctrl *vblank;
+	struct v4l2_ctrl *hblank;
+	struct v4l2_ctrl *exposure;
+
+	/* Current mode */
+	const struct imx258_mode *cur_mode;
+
+	/* Mutex for serialized access */
+	struct mutex mutex;
+
+	/* Streaming on/off */
+	bool streaming;
+};
+
+#define to_imx258(_sd)	container_of(_sd, struct imx258, sd)
+
+/* Read registers up to 4 at a time */
+static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	struct i2c_msg msgs[2];
+	u8 *data_be_p;
+	int ret;
+	u32 data_be = 0;
+	u16 reg_addr_be = cpu_to_be16(reg);
+
+	if (len > 4)
+		return -EINVAL;
+
+	data_be_p = (u8 *)&data_be;
+	/* Write register address */
+	msgs[0].addr = client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 2;
+	msgs[0].buf = (u8 *)&reg_addr_be;
+
+	/* Read data from register */
+	msgs[1].addr = client->addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = &data_be_p[4 - len];
+
+	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (ret != ARRAY_SIZE(msgs))
+		return -EIO;
+
+	*val = be32_to_cpu(data_be);
+
+	return 0;
+}
+
+static int imx258_i2c_write_reg_seq(struct imx258 *imx258, u16 reg,
+					u32 len, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	u32 val_len = 2;
+	u32 data_len = len + val_len;
+	unsigned char data[data_len];
+	u32 mask = 0xff;
+
+	data[0] = reg >> 8;
+	data[1] = reg & mask;
+	data[2] = (u8)((val & ~mask)>>8);
+	data[3] = (u8)(val & mask);
+
+	if (i2c_master_send(client, data, data_len) != data_len)
+		return -EIO;
+	return 0;
+}
+
+/* Write registers up to 4 at a time */
+static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	int buf_i, val_i;
+	u8 buf[6], *val_p;
+
+	if (len > 4)
+		return -EINVAL;
+
+	buf[0] = reg >> 8;
+	buf[1] = reg & 0xff;
+
+	val = cpu_to_be32(val);
+	val_p = (u8 *)&val;
+	buf_i = 2;
+	val_i = 4 - len;
+
+	while (val_i < 4)
+		buf[buf_i++] = val_p[val_i++];
+
+	if (i2c_master_send(client, buf, len + 2) != len + 2)
+		return -EIO;
+
+	return 0;
+}
+
+/* Write a list of registers */
+static int imx258_write_regs(struct imx258 *imx258,
+			      const struct imx258_reg *regs, u32 len)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	int ret;
+	u32 i;
+
+	for (i = 0; i < len; i++) {
+		ret = imx258_write_reg(imx258, regs[i].address, 1,
+					regs[i].val);
+		if (ret) {
+			dev_err_ratelimited(
+				&client->dev,
+				"Failed to write reg 0x%4.4x. error = %d\n",
+				regs[i].address, ret);
+
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int imx258_write_reg_list(struct imx258 *imx258,
+				  const struct imx258_reg_list *r_list)
+{
+	return imx258_write_regs(imx258, r_list->regs, r_list->num_of_regs);
+}
+
+/* Open sub-device */
+static int imx258_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *try_fmt =
+		v4l2_subdev_get_try_format(sd, fh->pad, 0);
+
+	/* Initialize try_fmt */
+	try_fmt->width = supported_modes[0].width;
+	try_fmt->height = supported_modes[0].height;
+	try_fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	try_fmt->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int imx258_update_digital_gain(struct imx258 *imx258, u32 len, u32 val)
+{
+	int ret;
+
+	ret = imx258_i2c_write_reg_seq(imx258, IMX258_REG_GR_DIGITAL_GAIN,
+				IMX258_REG_VALUE_16BIT,
+				val);
+	ret |= imx258_i2c_write_reg_seq(imx258, IMX258_REG_GB_DIGITAL_GAIN,
+				IMX258_REG_VALUE_16BIT,
+				val);
+	ret |= imx258_i2c_write_reg_seq(imx258, IMX258_REG_R_DIGITAL_GAIN,
+				IMX258_REG_VALUE_16BIT,
+				val);
+	ret |= imx258_i2c_write_reg_seq(imx258, IMX258_REG_B_DIGITAL_GAIN,
+				IMX258_REG_VALUE_16BIT,
+				val);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct imx258 *imx258 =
+		container_of(ctrl->handler, struct imx258, ctrl_handler);
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	int ret = 0;
+	/*
+	 * Applying V4L2 control value only happens
+	 * when power is up for streaming
+	 */
+	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ANALOGUE_GAIN:
+		ret = imx258_i2c_write_reg_seq(imx258, IMX258_REG_ANALOG_GAIN,
+				IMX258_REG_VALUE_16BIT,
+				ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		ret = imx258_i2c_write_reg_seq(imx258, IMX258_REG_EXPOSURE,
+				IMX258_REG_VALUE_16BIT,
+				ctrl->val);
+		break;
+	case V4L2_CID_DIGITAL_GAIN:
+		ret = imx258_update_digital_gain(imx258, IMX258_REG_VALUE_16BIT,
+				ctrl->val);
+		break;
+	default:
+		dev_info(&client->dev,
+			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
+			 ctrl->id, ctrl->val);
+		break;
+	}
+
+	pm_runtime_put(&client->dev);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops imx258_ctrl_ops = {
+	.s_ctrl = imx258_set_ctrl,
+};
+
+static int imx258_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	/* Only one bayer order(GRBG) is supported */
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+
+	return 0;
+}
+
+static int imx258_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->index >= ARRAY_SIZE(supported_modes))
+		return -EINVAL;
+
+	if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+		return -EINVAL;
+
+	fse->min_width = supported_modes[fse->index].width;
+	fse->max_width = fse->min_width;
+	fse->min_height = supported_modes[fse->index].height;
+	fse->max_height = fse->min_height;
+
+	return 0;
+}
+
+static void imx258_update_pad_format(const struct imx258_mode *mode,
+				      struct v4l2_subdev_format *fmt)
+{
+	fmt->format.width = mode->width;
+	fmt->format.height = mode->height;
+	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->format.field = V4L2_FIELD_NONE;
+}
+
+static int __imx258_get_pad_format(struct imx258 *imx258,
+				     struct v4l2_subdev_pad_config *cfg,
+				     struct v4l2_subdev_format *fmt)
+{
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		fmt->format = *v4l2_subdev_get_try_format(&imx258->sd, cfg,
+							  fmt->pad);
+	else
+		imx258_update_pad_format(imx258->cur_mode, fmt);
+
+	return 0;
+}
+
+static int imx258_get_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct imx258 *imx258 = to_imx258(sd);
+	int ret;
+
+	mutex_lock(&imx258->mutex);
+	ret = __imx258_get_pad_format(imx258, cfg, fmt);
+	mutex_unlock(&imx258->mutex);
+
+	return ret;
+}
+
+/*
+ * Calculate resolution distance
+ */
+static int imx258_get_resolution_dist(const struct imx258_mode *mode,
+		       struct v4l2_mbus_framefmt *framefmt)
+{
+	return abs(mode->width - framefmt->width) +
+	       abs(mode->height - framefmt->height);
+}
+
+/*
+ * Find the closest supported resolution to the requested resolution
+ */
+static const struct imx258_mode *
+imx258_find_best_fit(struct imx258 *imx258,
+		      struct v4l2_subdev_format *fmt)
+{
+	int i, dist, cur_best_fit = 0, cur_best_fit_dist = -1;
+	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
+
+	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
+		dist = imx258_get_resolution_dist(&supported_modes[i],
+						   framefmt);
+		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
+			cur_best_fit_dist = dist;
+			cur_best_fit = i;
+		}
+	}
+
+	return &supported_modes[cur_best_fit];
+}
+
+static int imx258_set_pad_format(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *fmt)
+{
+	struct imx258 *imx258 = to_imx258(sd);
+	const struct imx258_mode *mode;
+	struct v4l2_mbus_framefmt *framefmt;
+	s32 vblank_def;
+	s32 vblank_min;
+	s64 h_blank;
+	s64 pixel_rate;
+	s64 link_freq;
+
+	mutex_lock(&imx258->mutex);
+
+	/* Only one raw bayer(GBRG) order is supported */
+	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
+
+	mode = imx258_find_best_fit(imx258, fmt);
+	imx258_update_pad_format(mode, fmt);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		*framefmt = fmt->format;
+	} else {
+		imx258->cur_mode = mode;
+		__v4l2_ctrl_s_ctrl(imx258->link_freq, mode->link_freq_index);
+
+		link_freq = link_freq_menu_items[mode->link_freq_index];
+		pixel_rate = link_freq_to_pixel_rate(link_freq);
+		__v4l2_ctrl_s_ctrl_int64(imx258->pixel_rate, pixel_rate);
+		/* Update limits and set FPS to default */
+		vblank_def = imx258->cur_mode->vts_def -
+			     imx258->cur_mode->height;
+		vblank_min = imx258->cur_mode->vts_min -
+			     imx258->cur_mode->height;
+		__v4l2_ctrl_modify_range(
+			imx258->vblank, vblank_min,
+			IMX258_VTS_MAX - imx258->cur_mode->height, 1,
+			vblank_def);
+		__v4l2_ctrl_s_ctrl(imx258->vblank, vblank_def);
+		h_blank =
+			link_freq_configs[mode->link_freq_index].pixels_per_line
+			 - imx258->cur_mode->width;
+		__v4l2_ctrl_modify_range(imx258->hblank, h_blank,
+					 h_blank, 1, h_blank);
+	}
+
+	mutex_unlock(&imx258->mutex);
+
+	return 0;
+}
+
+/* Start streaming */
+static int imx258_start_streaming(struct imx258 *imx258)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	const struct imx258_reg_list *reg_list;
+	int ret, link_freq_index;
+
+	/* Setup PLL */
+	link_freq_index = imx258->cur_mode->link_freq_index;
+	reg_list = &link_freq_configs[link_freq_index].reg_list;
+	ret = imx258_write_reg_list(imx258, reg_list);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set plls\n", __func__);
+		return ret;
+	}
+
+	/* Apply default values of current mode */
+	reg_list = &imx258->cur_mode->reg_list;
+	ret = imx258_write_reg_list(imx258, reg_list);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set mode\n", __func__);
+		return ret;
+	}
+
+	/* Set Orientation be 180 degree */
+	ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
+				IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set orientation\n",
+			__func__);
+		return ret;
+	}
+
+	/* Apply customized values from user */
+	ret =  __v4l2_ctrl_handler_setup(imx258->sd.ctrl_handler);
+	if (ret)
+		return ret;
+
+	usleep_range(12000, 13000);
+
+	/* set stream on register */
+	return imx258_write_reg(imx258, IMX258_REG_MODE_SELECT,
+				 IMX258_REG_VALUE_08BIT,
+				 IMX258_MODE_STREAMING);
+}
+
+/* Stop streaming */
+static int imx258_stop_streaming(struct imx258 *imx258)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	int ret;
+
+	/* set stream off register */
+	ret = imx258_write_reg(imx258, IMX258_REG_MODE_SELECT,
+		IMX258_REG_VALUE_08BIT, IMX258_MODE_STANDBY);
+	if (ret)
+		dev_err(&client->dev, "%s failed to set stream\n", __func__);
+
+	/* Return success even if it was an error, as there is nothing the
+	 * caller can do about it.
+	 */
+	return 0;
+}
+
+static int imx258_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct imx258 *imx258 = to_imx258(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&imx258->mutex);
+	if (imx258->streaming == enable) {
+		mutex_unlock(&imx258->mutex);
+		return 0;
+	}
+
+	if (enable) {
+		ret = pm_runtime_get_sync(&client->dev);
+		if (ret < 0) {
+			pm_runtime_put_noidle(&client->dev);
+			goto err_unlock;
+		}
+
+		/*
+		 * Apply default & customized values
+		 * and then start streaming.
+		 */
+		ret = imx258_start_streaming(imx258);
+		if (ret)
+			goto err_rpm_put;
+	} else {
+		imx258_stop_streaming(imx258);
+		pm_runtime_put(&client->dev);
+	}
+
+	imx258->streaming = enable;
+	mutex_unlock(&imx258->mutex);
+
+	return ret;
+
+err_rpm_put:
+	pm_runtime_put(&client->dev);
+err_unlock:
+	mutex_unlock(&imx258->mutex);
+
+	return ret;
+}
+
+static int __maybe_unused imx258_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx258 *imx258 = to_imx258(sd);
+
+	if (imx258->streaming)
+		imx258_stop_streaming(imx258);
+
+	return 0;
+}
+
+static int __maybe_unused imx258_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx258 *imx258 = to_imx258(sd);
+	int ret;
+
+	if (imx258->streaming) {
+		ret = imx258_start_streaming(imx258);
+		if (ret)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	imx258_stop_streaming(imx258);
+	imx258->streaming = 0;
+	return ret;
+}
+
+/* Verify chip ID */
+static int imx258_identify_module(struct imx258 *imx258)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	int ret;
+	u32 val;
+
+	ret = imx258_read_reg(imx258, IMX258_REG_CHIP_ID,
+			       IMX258_REG_VALUE_16BIT, &val);
+	if (ret) {
+		dev_err(&client->dev, "failed to read chip id %x\n",
+			IMX258_CHIP_ID);
+		return ret;
+	}
+
+	if (val != IMX258_CHIP_ID) {
+		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
+			IMX258_CHIP_ID, val);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops imx258_video_ops = {
+	.s_stream = imx258_set_stream,
+};
+
+static const struct v4l2_subdev_pad_ops imx258_pad_ops = {
+	.enum_mbus_code = imx258_enum_mbus_code,
+	.get_fmt = imx258_get_pad_format,
+	.set_fmt = imx258_set_pad_format,
+	.enum_frame_size = imx258_enum_frame_size,
+};
+
+static const struct v4l2_subdev_ops imx258_subdev_ops = {
+	.video = &imx258_video_ops,
+	.pad = &imx258_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops imx258_internal_ops = {
+	.open = imx258_open,
+};
+
+/* Initialize control handlers */
+static int imx258_init_controls(struct imx258 *imx258)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
+	struct v4l2_ctrl_handler *ctrl_hdlr;
+	s64 exposure_max;
+	s64 vblank_def;
+	s64 vblank_min;
+	s64 pixel_rate_min;
+	s64 pixel_rate_max;
+	int ret;
+
+	ctrl_hdlr = &imx258->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
+	if (ret)
+		return ret;
+
+	mutex_init(&imx258->mutex);
+	ctrl_hdlr->lock = &imx258->mutex;
+	imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
+				&imx258_ctrl_ops,
+				V4L2_CID_LINK_FREQ,
+				ARRAY_SIZE(link_freq_menu_items) - 1,
+				0,
+				link_freq_menu_items);
+
+	if (!imx258->link_freq) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
+	pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
+	/* By default, PIXEL_RATE is read only */
+	imx258->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops,
+					V4L2_CID_PIXEL_RATE,
+					pixel_rate_min, pixel_rate_max,
+					1, pixel_rate_max);
+
+
+	vblank_def = imx258->cur_mode->vts_def - imx258->cur_mode->height;
+	vblank_min = imx258->cur_mode->vts_min - imx258->cur_mode->height;
+	imx258->vblank = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_VBLANK,
+				vblank_min,
+				IMX258_VTS_MAX - imx258->cur_mode->height, 1,
+				vblank_def);
+
+	imx258->hblank = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_HBLANK,
+				IMX258_PPL_650MHZ - imx258->cur_mode->width,
+				IMX258_PPL_650MHZ - imx258->cur_mode->width,
+				1,
+				IMX258_PPL_650MHZ - imx258->cur_mode->width);
+
+	if (!imx258->hblank) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	imx258->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	exposure_max = imx258->cur_mode->vts_def - 8;
+	imx258->exposure = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx258_ctrl_ops,
+				V4L2_CID_EXPOSURE, IMX258_EXPOSURE_MIN,
+				IMX258_EXPOSURE_MAX, IMX258_EXPOSURE_STEP,
+				IMX258_EXPOSURE_DEFAULT);
+
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
+			  IMX258_ANA_GAIN_MIN, IMX258_ANA_GAIN_MAX,
+			  IMX258_ANA_GAIN_STEP, IMX258_ANA_GAIN_DEFAULT);
+
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
+				IMX258_DGTL_GAIN_MIN, IMX258_DGTL_GAIN_MAX,
+				IMX258_DGTL_GAIN_STEP, IMX258_DGTL_GAIN_DEFAULT);
+
+	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
+				     V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(imx258_test_pattern_menu) - 1,
+				     0, 0, imx258_test_pattern_menu);
+
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		dev_err(&client->dev, "%s control init failed (%d)\n",
+			__func__, ret);
+		goto error;
+	}
+
+	imx258->sd.ctrl_handler = ctrl_hdlr;
+
+	return 0;
+
+error:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
+	mutex_destroy(&imx258->mutex);
+
+	return ret;
+}
+
+static void imx258_free_controls(struct imx258 *imx258)
+{
+	v4l2_ctrl_handler_free(imx258->sd.ctrl_handler);
+	mutex_destroy(&imx258->mutex);
+}
+
+static int imx258_probe(struct i2c_client *client)
+{
+	struct imx258 *imx258;
+	int ret;
+	u32 val = 0;
+
+	device_property_read_u32(&client->dev, "clock-frequency", &val);
+	if (val != 19200000)
+		return -EINVAL;
+
+	imx258 = devm_kzalloc(&client->dev, sizeof(*imx258), GFP_KERNEL);
+	if (!imx258)
+		return -ENOMEM;
+
+	/* Initialize subdev */
+	v4l2_i2c_subdev_init(&imx258->sd, client, &imx258_subdev_ops);
+
+	/* Check module identity */
+	ret = imx258_identify_module(imx258);
+	if (ret)
+		return ret;
+
+	/* Set default mode to max resolution */
+	imx258->cur_mode = &supported_modes[0];
+
+	ret = imx258_init_controls(imx258);
+	if (ret)
+		return ret;
+
+	/* Initialize subdev */
+	imx258->sd.internal_ops = &imx258_internal_ops;
+	imx258->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+
+	/* Initialize source pad */
+	imx258->pad.flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&imx258->sd.entity, 1, &imx258->pad);
+	if (ret) {
+		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
+		goto error_handler_free;
+	}
+
+	ret = v4l2_async_register_subdev_sensor_common(&imx258->sd);
+	if (ret < 0)
+		goto error_media_entity;
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+error_media_entity:
+	media_entity_cleanup(&imx258->sd.entity);
+
+error_handler_free:
+	imx258_free_controls(imx258);
+
+	return ret;
+}
+
+static int imx258_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx258 *imx258 = to_imx258(sd);
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	imx258_free_controls(imx258);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops imx258_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(imx258_suspend, imx258_resume)
+};
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id imx258_acpi_ids[] = {
+	{ "SONY258A" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(acpi, imx258_acpi_ids);
+#endif
+
+static struct i2c_driver imx258_i2c_driver = {
+	.driver = {
+		.name = "imx258",
+		.pm = &imx258_pm_ops,
+		.acpi_match_table = ACPI_PTR(imx258_acpi_ids),
+	},
+	.probe_new = imx258_probe,
+	.remove = imx258_remove,
+};
+
+module_i2c_driver(imx258_i2c_driver);
+
+MODULE_AUTHOR("Yeh, Andy <andy.yeh@intel.com>");
+MODULE_AUTHOR("Chiang, Alan <alanx.chiang@intel.com>");
+MODULE_AUTHOR("Chen, Jason <jasonx.z.chen@intel.com>");
+MODULE_DESCRIPTION("Sony IMX258 sensor driver");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
