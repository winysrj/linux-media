Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:49028 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750779AbeEQEAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 00:00:25 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: [PATCH] media: imx355: Add imx355 camera sensor driver
Date: Thu, 17 May 2018 12:02:50 +0800
Message-Id: <1526529770-25512-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Add a V4L2 sub-device driver for the Sony IMX355 image sensor.
This is a camera sensor using the I2C bus for control and the
CSI-2 bus for data.

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
 MAINTAINERS                |    7 +
 drivers/media/i2c/Kconfig  |   11 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/imx355.c | 1741 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1760 insertions(+)
 create mode 100644 drivers/media/i2c/imx355.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e73a55a6a855..0921e9ae744e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13084,6 +13084,13 @@ S:	Maintained
 F:	drivers/media/i2c/imx274.c
 F:	Documentation/devicetree/bindings/media/i2c/imx274.txt
 
+SONY IMX355 SENSOR DRIVER
+M:	Tianshu Qiu <tian.shu.qiu@intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/imx355.c
+
 SONY MEMORYSTICK CARD SUPPORT
 M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 1f9d7c6aa31a..505e7aa30b8d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -604,6 +604,17 @@ config VIDEO_IMX274
 	  This is a V4L2 sensor-level driver for the Sony IMX274
 	  CMOS image sensor.
 
+config VIDEO_IMX355
+	tristate "Sony IMX355 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	help
+	  This is a Video4Linux2 sensor driver for the Sony
+	  IMX355 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called imx355.
+
 config VIDEO_OV2640
 	tristate "OmniVision OV2640 sensor support"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 16fc34eda5cc..dff2fb0dc3fa 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -104,5 +104,6 @@ obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
 obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
 obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
 obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
+obj-$(CONFIG_VIDEO_IMX355)	+= imx355.o
 
 obj-$(CONFIG_SDR_MAX2175) += max2175.o
diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
new file mode 100644
index 000000000000..6b936055acde
--- /dev/null
+++ b/drivers/media/i2c/imx355.c
@@ -0,0 +1,1741 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2017 - 2018 Intel Corporation
+
+#include <asm/unaligned.h>
+#include <linux/acpi.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#define IMX355_REG_MODE_SELECT		0x0100
+#define IMX355_MODE_STANDBY		0x00
+#define IMX355_MODE_STREAMING		0x01
+
+/* Chip ID */
+#define IMX355_REG_CHIP_ID		0x0016
+#define IMX355_CHIP_ID			0x0355
+
+/* V_TIMING internal */
+#define IMX355_REG_FLL			0x0340
+#define IMX355_FLL_MAX			0xffff
+
+/* Exposure control */
+#define IMX355_REG_EXPOSURE		0x0202
+#define IMX355_EXPOSURE_MIN		1
+#define IMX355_EXPOSURE_STEP		1
+#define IMX355_EXPOSURE_DEFAULT		0x0282
+
+/* Analog gain control */
+#define IMX355_REG_ANALOG_GAIN		0x0204
+#define IMX355_ANA_GAIN_MIN		0
+#define IMX355_ANA_GAIN_MAX		960
+#define IMX355_ANA_GAIN_STEP		1
+#define IMX355_ANA_GAIN_DEFAULT		0
+
+/* Digital gain control */
+#define IMX355_REG_DPGA_USE_GLOBAL_GAIN	0x3070
+#define IMX355_REG_DIG_GAIN_GLOBAL	0x020e
+#define IMX355_DGTL_GAIN_MIN		256
+#define IMX355_DGTL_GAIN_MAX		4095
+#define IMX355_DGTL_GAIN_STEP		1
+#define IMX355_DGTL_GAIN_DEFAULT	256
+
+/* Test Pattern Control */
+#define IMX355_REG_TEST_PATTERN		0x0600
+#define IMX355_TEST_PATTERN_DISABLED		0
+#define IMX355_TEST_PATTERN_SOLID_COLOR		1
+#define IMX355_TEST_PATTERN_COLOR_BARS		2
+#define IMX355_TEST_PATTERN_GRAY_COLOR_BARS	3
+#define IMX355_TEST_PATTERN_PN9			4
+
+/* Flip Control */
+#define IMX355_REG_ORIENTATION		0x0101
+
+struct imx355_reg {
+	u16 address;
+	u8 val;
+};
+
+struct imx355_reg_list {
+	u32 num_of_regs;
+	const struct imx355_reg *regs;
+};
+
+/* Mode : resolution and related config&values */
+struct imx355_mode {
+	/* Frame width */
+	u32 width;
+	/* Frame height */
+	u32 height;
+
+	/* V-timing */
+	u32 fll_def;
+	u32 fll_min;
+
+	/* H-timing */
+	u32 llp;
+
+	/* Default register values */
+	struct imx355_reg_list reg_list;
+};
+
+struct imx355 {
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
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *hflip;
+
+	/* Current mode */
+	const struct imx355_mode *cur_mode;
+
+	/*
+	 * Mutex for serialized access:
+	 * Protect sensor set pad format and start/stop streaming safely.
+	 * Protect access to sensor v4l2 controls.
+	 */
+	struct mutex mutex;
+
+	/* Streaming on/off */
+	bool streaming;
+};
+
+static const struct imx355_reg imx355_global_regs[] = {
+	{ 0x0136, 0x13 },
+	{ 0x0137, 0x33 },
+	{ 0x304e, 0x03 },
+	{ 0x4348, 0x16 },
+	{ 0x4350, 0x19 },
+	{ 0x4408, 0x0a },
+	{ 0x440c, 0x0b },
+	{ 0x4411, 0x5f },
+	{ 0x4412, 0x2c },
+	{ 0x4623, 0x00 },
+	{ 0x462c, 0x0f },
+	{ 0x462d, 0x00 },
+	{ 0x462e, 0x00 },
+	{ 0x4684, 0x54 },
+	{ 0x480a, 0x07 },
+	{ 0x4908, 0x07 },
+	{ 0x4909, 0x07 },
+	{ 0x490d, 0x0a },
+	{ 0x491e, 0x0f },
+	{ 0x4921, 0x06 },
+	{ 0x4923, 0x28 },
+	{ 0x4924, 0x28 },
+	{ 0x4925, 0x29 },
+	{ 0x4926, 0x29 },
+	{ 0x4927, 0x1f },
+	{ 0x4928, 0x20 },
+	{ 0x4929, 0x20 },
+	{ 0x492a, 0x20 },
+	{ 0x492c, 0x05 },
+	{ 0x492d, 0x06 },
+	{ 0x492e, 0x06 },
+	{ 0x492f, 0x06 },
+	{ 0x4930, 0x03 },
+	{ 0x4931, 0x04 },
+	{ 0x4932, 0x04 },
+	{ 0x4933, 0x05 },
+	{ 0x595e, 0x01 },
+	{ 0x5963, 0x01 },
+	{ 0x3030, 0x01 },
+	{ 0x3031, 0x01 },
+	{ 0x3045, 0x01 },
+	{ 0x4010, 0x00 },
+	{ 0x4011, 0x00 },
+	{ 0x4012, 0x00 },
+	{ 0x4013, 0x01 },
+	{ 0x68a8, 0xfe },
+	{ 0x68a9, 0xff },
+	{ 0x6888, 0x00 },
+	{ 0x6889, 0x00 },
+	{ 0x68b0, 0x00 },
+	{ 0x3058, 0x00 },
+	{ 0x305a, 0x00 },
+};
+
+static const struct imx355_reg_list imx355_global_setting = {
+	.num_of_regs = ARRAY_SIZE(imx355_global_regs),
+	.regs = imx355_global_regs,
+};
+
+static const struct imx355_reg mode_3268x2448_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x0a },
+	{ 0x0341, 0x36 },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x08 },
+	{ 0x0346, 0x00 },
+	{ 0x0347, 0x08 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xcb },
+	{ 0x034a, 0x09 },
+	{ 0x034b, 0x97 },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x0c },
+	{ 0x034d, 0xc4 },
+	{ 0x034e, 0x09 },
+	{ 0x034f, 0x90 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_3264x2448_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x0a },
+	{ 0x0341, 0x36 },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x08 },
+	{ 0x0346, 0x00 },
+	{ 0x0347, 0x08 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xc7 },
+	{ 0x034a, 0x09 },
+	{ 0x034b, 0x97 },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x0c },
+	{ 0x034d, 0xc0 },
+	{ 0x034e, 0x09 },
+	{ 0x034f, 0x90 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_3280x2464_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x0a },
+	{ 0x0341, 0x36 },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x00 },
+	{ 0x0346, 0x00 },
+	{ 0x0347, 0x00 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xcf },
+	{ 0x034a, 0x09 },
+	{ 0x034b, 0x9f },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x0c },
+	{ 0x034d, 0xd0 },
+	{ 0x034e, 0x09 },
+	{ 0x034f, 0xa0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1940x1096_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x02 },
+	{ 0x0345, 0xa0 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0xac },
+	{ 0x0348, 0x0a },
+	{ 0x0349, 0x33 },
+	{ 0x034a, 0x06 },
+	{ 0x034b, 0xf3 },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x07 },
+	{ 0x034d, 0x94 },
+	{ 0x034e, 0x04 },
+	{ 0x034f, 0x48 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1936x1096_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x02 },
+	{ 0x0345, 0xa0 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0xac },
+	{ 0x0348, 0x0a },
+	{ 0x0349, 0x2f },
+	{ 0x034a, 0x06 },
+	{ 0x034b, 0xf3 },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x07 },
+	{ 0x034d, 0x90 },
+	{ 0x034e, 0x04 },
+	{ 0x034f, 0x48 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1924x1080_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x02 },
+	{ 0x0345, 0xa8 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0xb4 },
+	{ 0x0348, 0x0a },
+	{ 0x0349, 0x2b },
+	{ 0x034a, 0x06 },
+	{ 0x034b, 0xeb },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x07 },
+	{ 0x034d, 0x84 },
+	{ 0x034e, 0x04 },
+	{ 0x034f, 0x38 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1920x1080_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x02 },
+	{ 0x0345, 0xa8 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0xb4 },
+	{ 0x0348, 0x0a },
+	{ 0x0349, 0x27 },
+	{ 0x034a, 0x06 },
+	{ 0x034b, 0xeb },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x00 },
+	{ 0x0901, 0x11 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x07 },
+	{ 0x034d, 0x80 },
+	{ 0x034e, 0x04 },
+	{ 0x034f, 0x38 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1640x1232_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x00 },
+	{ 0x0346, 0x00 },
+	{ 0x0347, 0x00 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xcf },
+	{ 0x034a, 0x09 },
+	{ 0x034b, 0x9f },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x06 },
+	{ 0x034d, 0x68 },
+	{ 0x034e, 0x04 },
+	{ 0x034f, 0xd0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1640x922_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x00 },
+	{ 0x0346, 0x01 },
+	{ 0x0347, 0x30 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xcf },
+	{ 0x034a, 0x08 },
+	{ 0x034b, 0x63 },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x06 },
+	{ 0x034d, 0x68 },
+	{ 0x034e, 0x03 },
+	{ 0x034f, 0x9a },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1300x736_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x01 },
+	{ 0x0345, 0x58 },
+	{ 0x0346, 0x01 },
+	{ 0x0347, 0xf0 },
+	{ 0x0348, 0x0b },
+	{ 0x0349, 0x7f },
+	{ 0x034a, 0x07 },
+	{ 0x034b, 0xaf },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x05 },
+	{ 0x034d, 0x14 },
+	{ 0x034e, 0x02 },
+	{ 0x034f, 0xe0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1296x736_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x01 },
+	{ 0x0345, 0x58 },
+	{ 0x0346, 0x01 },
+	{ 0x0347, 0xf0 },
+	{ 0x0348, 0x0b },
+	{ 0x0349, 0x77 },
+	{ 0x034a, 0x07 },
+	{ 0x034b, 0xaf },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x05 },
+	{ 0x034d, 0x10 },
+	{ 0x034e, 0x02 },
+	{ 0x034f, 0xe0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1284x720_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x01 },
+	{ 0x0345, 0x68 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0x00 },
+	{ 0x0348, 0x0b },
+	{ 0x0349, 0x6f },
+	{ 0x034a, 0x07 },
+	{ 0x034b, 0x9f },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x05 },
+	{ 0x034d, 0x04 },
+	{ 0x034e, 0x02 },
+	{ 0x034f, 0xd0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_1280x720_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x07 },
+	{ 0x0343, 0x2c },
+	{ 0x0340, 0x05 },
+	{ 0x0341, 0x1a },
+	{ 0x0344, 0x01 },
+	{ 0x0345, 0x68 },
+	{ 0x0346, 0x02 },
+	{ 0x0347, 0x00 },
+	{ 0x0348, 0x0b },
+	{ 0x0349, 0x67 },
+	{ 0x034a, 0x07 },
+	{ 0x034b, 0x9f },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x22 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x05 },
+	{ 0x034d, 0x00 },
+	{ 0x034e, 0x02 },
+	{ 0x034f, 0xd0 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x00 },
+	{ 0x0701, 0x10 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const struct imx355_reg mode_820x616_regs[] = {
+	{ 0x0112, 0x0a },
+	{ 0x0113, 0x0a },
+	{ 0x0114, 0x03 },
+	{ 0x0342, 0x0e },
+	{ 0x0343, 0x58 },
+	{ 0x0340, 0x02 },
+	{ 0x0341, 0x8c },
+	{ 0x0344, 0x00 },
+	{ 0x0345, 0x00 },
+	{ 0x0346, 0x00 },
+	{ 0x0347, 0x00 },
+	{ 0x0348, 0x0c },
+	{ 0x0349, 0xcf },
+	{ 0x034a, 0x09 },
+	{ 0x034b, 0x9f },
+	{ 0x0220, 0x00 },
+	{ 0x0222, 0x01 },
+	{ 0x0900, 0x01 },
+	{ 0x0901, 0x44 },
+	{ 0x0902, 0x00 },
+	{ 0x034c, 0x03 },
+	{ 0x034d, 0x34 },
+	{ 0x034e, 0x02 },
+	{ 0x034f, 0x68 },
+	{ 0x0301, 0x05 },
+	{ 0x0303, 0x01 },
+	{ 0x0305, 0x02 },
+	{ 0x0306, 0x00 },
+	{ 0x0307, 0x78 },
+	{ 0x030b, 0x01 },
+	{ 0x030d, 0x02 },
+	{ 0x030e, 0x00 },
+	{ 0x030f, 0x4b },
+	{ 0x0310, 0x00 },
+	{ 0x0700, 0x02 },
+	{ 0x0701, 0x78 },
+	{ 0x0820, 0x0b },
+	{ 0x0821, 0x40 },
+	{ 0x3088, 0x04 },
+	{ 0x6813, 0x02 },
+	{ 0x6835, 0x07 },
+	{ 0x6836, 0x01 },
+	{ 0x6837, 0x04 },
+	{ 0x684d, 0x07 },
+	{ 0x684e, 0x01 },
+	{ 0x684f, 0x04 },
+};
+
+static const char * const imx355_test_pattern_menu[] = {
+	"Disabled",
+	"100% color bars",
+	"Solid color",
+	"Fade to gray color bars",
+	"PN9"
+};
+
+static const int imx355_test_pattern_val[] = {
+	IMX355_TEST_PATTERN_DISABLED,
+	IMX355_TEST_PATTERN_COLOR_BARS,
+	IMX355_TEST_PATTERN_SOLID_COLOR,
+	IMX355_TEST_PATTERN_GRAY_COLOR_BARS,
+	IMX355_TEST_PATTERN_PN9,
+};
+
+/* Configurations for supported link frequencies */
+/* Menu items for LINK_FREQ V4L2 control */
+static const s64 link_freq_menu_items[] = {
+	300800000,
+};
+
+/* Mode configs */
+static const struct imx355_mode supported_modes[] = {
+	{
+		.width = 3280,
+		.height = 2464,
+		.fll_def = 0xa36,
+		.fll_min = 0xa36,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
+			.regs = mode_3280x2464_regs,
+		},
+	},
+	{
+		.width = 3268,
+		.height = 2448,
+		.fll_def = 0xa36,
+		.fll_min = 0xa36,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_3268x2448_regs),
+			.regs = mode_3268x2448_regs,
+		},
+	},
+	{
+		.width = 3264,
+		.height = 2448,
+		.fll_def = 0xa36,
+		.fll_min = 0xa36,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_3264x2448_regs),
+			.regs = mode_3264x2448_regs,
+		},
+	},
+	{
+		.width = 1940,
+		.height = 1096,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1940x1096_regs),
+			.regs = mode_1940x1096_regs,
+		},
+	},
+	{
+		.width = 1936,
+		.height = 1096,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1936x1096_regs),
+			.regs = mode_1936x1096_regs,
+		},
+	},
+	{
+		.width = 1924,
+		.height = 1080,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1924x1080_regs),
+			.regs = mode_1924x1080_regs,
+		},
+	},
+	{
+		.width = 1920,
+		.height = 1080,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1920x1080_regs),
+			.regs = mode_1920x1080_regs,
+		},
+	},
+	{
+		.width = 1640,
+		.height = 1232,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1640x1232_regs),
+			.regs = mode_1640x1232_regs,
+		},
+	},
+	{
+		.width = 1640,
+		.height = 922,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1640x922_regs),
+			.regs = mode_1640x922_regs,
+		},
+	},
+	{
+		.width = 1300,
+		.height = 736,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1300x736_regs),
+			.regs = mode_1300x736_regs,
+		},
+	},
+	{
+		.width = 1296,
+		.height = 736,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1296x736_regs),
+			.regs = mode_1296x736_regs,
+		},
+	},
+	{
+		.width = 1284,
+		.height = 720,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1284x720_regs),
+			.regs = mode_1284x720_regs,
+		},
+	},
+	{
+		.width = 1280,
+		.height = 720,
+		.fll_def = 0x51a,
+		.fll_min = 0x51a,
+		.llp = 0x72c,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1280x720_regs),
+			.regs = mode_1280x720_regs,
+		},
+	},
+	{
+		.width = 820,
+		.height = 616,
+		.fll_def = 0x28c,
+		.fll_min = 0x28c,
+		.llp = 0xe58,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_820x616_regs),
+			.regs = mode_820x616_regs,
+		},
+	},
+};
+
+static inline struct imx355 *to_imx355(struct v4l2_subdev *_sd)
+{
+	return container_of(_sd, struct imx355, sd);
+}
+
+/* Get bayer order based on flip setting. */
+static __u32 imx355_get_format_code(struct imx355 *imx355)
+{
+	/*
+	 * Only one bayer order is supported.
+	 * It depends on the flip settings.
+	 */
+	static const __u32 codes[2][2] = {
+		{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
+		{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
+	};
+
+	return codes[imx355->vflip->val][imx355->hflip->val];
+}
+
+/* Read registers up to 4 at a time */
+static int imx355_read_reg(struct imx355 *imx355, u16 reg, u32 len, u32 *val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	struct i2c_msg msgs[2];
+	u8 addr_buf[2];
+	u8 data_buf[4] = { 0 };
+	int ret;
+
+	if (len > 4)
+		return -EINVAL;
+
+	put_unaligned_be16(reg, addr_buf);
+	/* Write register address */
+	msgs[0].addr = client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = ARRAY_SIZE(addr_buf);
+	msgs[0].buf = addr_buf;
+
+	/* Read data from register */
+	msgs[1].addr = client->addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = &data_buf[4 - len];
+
+	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (ret != ARRAY_SIZE(msgs))
+		return -EIO;
+
+	*val = get_unaligned_be32(data_buf);
+
+	return 0;
+}
+
+/* Write registers up to 4 at a time */
+static int imx355_write_reg(struct imx355 *imx355, u16 reg, u32 len, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	u8 buf[6];
+
+	if (len > 4)
+		return -EINVAL;
+
+	put_unaligned_be16(reg, buf);
+	put_unaligned_be32(val << (8 * (4 - len)), buf + 2);
+	if (i2c_master_send(client, buf, len + 2) != len + 2)
+		return -EIO;
+
+	return 0;
+}
+
+/* Write a list of registers */
+static int imx355_write_regs(struct imx355 *imx355,
+			      const struct imx355_reg *regs, u32 len)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	int ret;
+	u32 i;
+
+	for (i = 0; i < len; i++) {
+		ret = imx355_write_reg(imx355, regs[i].address, 1,
+				       regs[i].val);
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
+/* Open sub-device */
+static int imx355_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+	struct v4l2_mbus_framefmt *try_fmt =
+		v4l2_subdev_get_try_format(sd, fh->pad, 0);
+
+	mutex_lock(&imx355->mutex);
+
+	/* Initialize try_fmt */
+	try_fmt->width = imx355->cur_mode->width;
+	try_fmt->height = imx355->cur_mode->height;
+	try_fmt->code = imx355_get_format_code(imx355);
+	try_fmt->field = V4L2_FIELD_NONE;
+
+	mutex_unlock(&imx355->mutex);
+
+	return 0;
+}
+
+static int imx355_update_digital_gain(struct imx355 *imx355, u32 d_gain)
+{
+	int ret;
+
+	ret = imx355_write_reg(imx355, IMX355_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
+	if (ret)
+		return ret;
+
+	/* Digital gain = (d_gain & 0xFF00) + (d_gain & 0xFF)/256 times */
+	return imx355_write_reg(imx355, IMX355_REG_DIG_GAIN_GLOBAL, 2, d_gain);
+}
+
+static int imx355_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct imx355 *imx355 = container_of(ctrl->handler,
+					     struct imx355, ctrl_handler);
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	s64 max;
+	int ret;
+
+	/* Propagate change of current control to all related controls */
+	switch (ctrl->id) {
+	case V4L2_CID_VBLANK:
+		/* Update max exposure while meeting expected vblanking */
+		max = imx355->cur_mode->height + ctrl->val - 10;
+		__v4l2_ctrl_modify_range(imx355->exposure,
+					 imx355->exposure->minimum,
+					 max, imx355->exposure->step, max);
+		break;
+	};
+
+	/*
+	 * Applying V4L2 control value only happens
+	 * when power is up for streaming
+	 */
+	if (pm_runtime_get_if_in_use(&client->dev) == 0)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ANALOGUE_GAIN:
+		/* Analog gain = 1024/(1024 - ctrl->val) times */
+		ret = imx355_write_reg(imx355, IMX355_REG_ANALOG_GAIN,
+				       2, ctrl->val);
+		break;
+	case V4L2_CID_DIGITAL_GAIN:
+		ret = imx355_update_digital_gain(imx355, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		ret = imx355_write_reg(imx355, IMX355_REG_EXPOSURE,
+				       2, ctrl->val);
+		break;
+	case V4L2_CID_VBLANK:
+		/* Update FLL that meets expected vertical blanking */
+		ret = imx355_write_reg(imx355, IMX355_REG_FLL, 2,
+				       imx355->cur_mode->height + ctrl->val);
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		ret = imx355_write_reg(imx355, IMX355_REG_TEST_PATTERN,
+				       2, imx355_test_pattern_val[ctrl->val]);
+		break;
+	case V4L2_CID_HFLIP:
+	case V4L2_CID_VFLIP:
+		ret = imx355_write_reg(imx355, IMX355_REG_ORIENTATION, 1,
+				       imx355->hflip->val |
+				       imx355->vflip->val << 1);
+		break;
+	default:
+		ret = -EINVAL;
+		dev_info(&client->dev,
+			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
+			 ctrl->id, ctrl->val);
+		break;
+	};
+
+	pm_runtime_put(&client->dev);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops imx355_ctrl_ops = {
+	.s_ctrl = imx355_set_ctrl,
+};
+
+static int imx355_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = imx355_get_format_code(imx355);
+
+	return 0;
+}
+
+static int imx355_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+
+	if (fse->index >= ARRAY_SIZE(supported_modes))
+		return -EINVAL;
+
+	if (fse->code != imx355_get_format_code(imx355))
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
+static void imx355_update_pad_format(struct imx355 *imx355,
+				     const struct imx355_mode *mode,
+				     struct v4l2_subdev_format *fmt)
+{
+	fmt->format.width = mode->width;
+	fmt->format.height = mode->height;
+	fmt->format.code = imx355_get_format_code(imx355);
+	fmt->format.field = V4L2_FIELD_NONE;
+}
+
+static int imx355_do_get_pad_format(struct imx355 *imx355,
+				     struct v4l2_subdev_pad_config *cfg,
+				     struct v4l2_subdev_format *fmt)
+{
+	struct v4l2_mbus_framefmt *framefmt;
+	struct v4l2_subdev *sd = &imx355->sd;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		fmt->format = *framefmt;
+	} else {
+		imx355_update_pad_format(imx355, imx355->cur_mode, fmt);
+	}
+
+	return 0;
+}
+
+static int imx355_get_pad_format(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_format *fmt)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+	int ret;
+
+	mutex_lock(&imx355->mutex);
+	ret = imx355_do_get_pad_format(imx355, cfg, fmt);
+	mutex_unlock(&imx355->mutex);
+
+	return ret;
+}
+
+static int
+imx355_set_pad_format(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *fmt)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+	const struct imx355_mode *mode;
+	struct v4l2_mbus_framefmt *framefmt;
+	s32 vblank_def;
+	s32 vblank_min;
+	s64 h_blank;
+	s64 pixel_rate;
+
+	mutex_lock(&imx355->mutex);
+
+	/*
+	 * Only one bayer order is supported.
+	 * It depends on the flip settings.
+	 */
+	fmt->format.code = imx355_get_format_code(imx355);
+
+	mode = v4l2_find_nearest_size(supported_modes,
+		ARRAY_SIZE(supported_modes), width, height,
+		fmt->format.width, fmt->format.height);
+	imx355_update_pad_format(imx355, mode, fmt);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		*framefmt = fmt->format;
+	} else {
+		imx355->cur_mode = mode;
+		pixel_rate =
+		(link_freq_menu_items[0] * 2 * 4) / 10;
+		__v4l2_ctrl_s_ctrl_int64(imx355->pixel_rate, pixel_rate);
+		/* Update limits and set FPS to default */
+		vblank_def = imx355->cur_mode->fll_def -
+			     imx355->cur_mode->height;
+		vblank_min = imx355->cur_mode->fll_min -
+			     imx355->cur_mode->height;
+		__v4l2_ctrl_modify_range(
+			imx355->vblank, vblank_min,
+			IMX355_FLL_MAX - imx355->cur_mode->height, 1,
+			vblank_def);
+		__v4l2_ctrl_s_ctrl(imx355->vblank, vblank_def);
+		h_blank = mode->llp - imx355->cur_mode->width;
+		/*
+		 * Currently hblank is not changeable.
+		 * So FPS control is done only by vblank.
+		 */
+		__v4l2_ctrl_modify_range(imx355->hblank, h_blank,
+					 h_blank, 1, h_blank);
+	}
+
+	mutex_unlock(&imx355->mutex);
+
+	return 0;
+}
+
+/* Start streaming */
+static int imx355_start_streaming(struct imx355 *imx355)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	const struct imx355_reg_list *reg_list;
+	int ret;
+
+	/* Global Setting */
+	reg_list = &imx355_global_setting;
+	ret = imx355_write_regs(imx355, reg_list->regs, reg_list->num_of_regs);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set global settings\n",
+			__func__);
+		return ret;
+	}
+
+	/* Apply default values of current mode */
+	reg_list = &imx355->cur_mode->reg_list;
+	ret = imx355_write_regs(imx355, reg_list->regs, reg_list->num_of_regs);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set mode\n", __func__);
+		return ret;
+	}
+
+	/* Apply customized values from user */
+	ret =  __v4l2_ctrl_handler_setup(imx355->sd.ctrl_handler);
+	if (ret)
+		return ret;
+
+	return imx355_write_reg(imx355, IMX355_REG_MODE_SELECT,
+				1, IMX355_MODE_STREAMING);
+}
+
+/* Stop streaming */
+static int imx355_stop_streaming(struct imx355 *imx355)
+{
+	return imx355_write_reg(imx355, IMX355_REG_MODE_SELECT,
+				1, IMX355_MODE_STANDBY);
+}
+
+static int imx355_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct imx355 *imx355 = to_imx355(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&imx355->mutex);
+	if (imx355->streaming == enable) {
+		mutex_unlock(&imx355->mutex);
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
+		ret = imx355_start_streaming(imx355);
+		if (ret)
+			goto err_rpm_put;
+	} else {
+		imx355_stop_streaming(imx355);
+		pm_runtime_put(&client->dev);
+	}
+
+	imx355->streaming = enable;
+	mutex_unlock(&imx355->mutex);
+
+	return ret;
+
+err_rpm_put:
+	pm_runtime_put(&client->dev);
+err_unlock:
+	mutex_unlock(&imx355->mutex);
+
+	return ret;
+}
+
+static int __maybe_unused imx355_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx355 *imx355 = to_imx355(sd);
+
+	if (imx355->streaming)
+		imx355_stop_streaming(imx355);
+
+	return 0;
+}
+
+static int __maybe_unused imx355_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx355 *imx355 = to_imx355(sd);
+	int ret;
+
+	if (imx355->streaming) {
+		ret = imx355_start_streaming(imx355);
+		if (ret)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	imx355_stop_streaming(imx355);
+	imx355->streaming = 0;
+	return ret;
+}
+
+/* Verify chip ID */
+static int imx355_identify_module(struct imx355 *imx355)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	int ret;
+	u32 val;
+
+	ret = imx355_read_reg(imx355, IMX355_REG_CHIP_ID, 2, &val);
+	if (ret)
+		return ret;
+
+	if (val != IMX355_CHIP_ID) {
+		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
+			IMX355_CHIP_ID, val);
+		return -EIO;
+	}
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops imx355_video_ops = {
+	.s_stream = imx355_set_stream,
+};
+
+static const struct v4l2_subdev_pad_ops imx355_pad_ops = {
+	.enum_mbus_code = imx355_enum_mbus_code,
+	.get_fmt = imx355_get_pad_format,
+	.set_fmt = imx355_set_pad_format,
+	.enum_frame_size = imx355_enum_frame_size,
+};
+
+static const struct v4l2_subdev_ops imx355_subdev_ops = {
+	.video = &imx355_video_ops,
+	.pad = &imx355_pad_ops,
+};
+
+static const struct media_entity_operations imx355_subdev_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static const struct v4l2_subdev_internal_ops imx355_internal_ops = {
+	.open = imx355_open,
+};
+
+/* Initialize control handlers */
+static int imx355_init_controls(struct imx355 *imx355)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
+	struct v4l2_ctrl_handler *ctrl_hdlr;
+	s64 exposure_max;
+	s64 vblank_def;
+	s64 vblank_min;
+	s64 hblank;
+	s64 pixel_rate;
+	const struct imx355_mode *mode;
+	int ret;
+
+	ctrl_hdlr = &imx355->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 10);
+	if (ret)
+		return ret;
+
+	ctrl_hdlr->lock = &imx355->mutex;
+	imx355->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
+				&imx355_ctrl_ops,
+				V4L2_CID_LINK_FREQ,
+				0,
+				0,
+				link_freq_menu_items);
+	if (imx355->link_freq)
+		imx355->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
+	pixel_rate = (link_freq_menu_items[0] * 2 * 4) / 10;
+	/* By default, PIXEL_RATE is read only */
+	imx355->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx355_ctrl_ops,
+						V4L2_CID_PIXEL_RATE,
+						pixel_rate, pixel_rate,
+						1, pixel_rate);
+
+	/* Initialze vblank/hblank/exposure parameters based on current mode */
+	mode = imx355->cur_mode;
+	vblank_def = mode->fll_def - mode->height;
+	vblank_min = mode->fll_min - mode->height;
+	imx355->vblank = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx355_ctrl_ops, V4L2_CID_VBLANK,
+				vblank_min, IMX355_FLL_MAX - mode->height, 1,
+				vblank_def);
+
+	hblank = mode->llp - mode->width;
+	imx355->hblank = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx355_ctrl_ops, V4L2_CID_HBLANK,
+				hblank, hblank, 1, hblank);
+	if (imx355->hblank)
+		imx355->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	exposure_max = mode->fll_def - 10;
+	imx355->exposure = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx355_ctrl_ops,
+				V4L2_CID_EXPOSURE, IMX355_EXPOSURE_MIN,
+				exposure_max, IMX355_EXPOSURE_STEP,
+				IMX355_EXPOSURE_DEFAULT);
+
+	imx355->hflip = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx355_ctrl_ops,
+				V4L2_CID_HFLIP, 0, 1, 1, 0);
+	imx355->vflip = v4l2_ctrl_new_std(
+				ctrl_hdlr, &imx355_ctrl_ops,
+				V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx355_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
+			  IMX355_ANA_GAIN_MIN, IMX355_ANA_GAIN_MAX,
+			  IMX355_ANA_GAIN_STEP, IMX355_ANA_GAIN_DEFAULT);
+
+	/* Digital gain */
+	v4l2_ctrl_new_std(ctrl_hdlr, &imx355_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
+			  IMX355_DGTL_GAIN_MIN, IMX355_DGTL_GAIN_MAX,
+			  IMX355_DGTL_GAIN_STEP, IMX355_DGTL_GAIN_DEFAULT);
+
+	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx355_ctrl_ops,
+				     V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(imx355_test_pattern_menu) - 1,
+				     0, 0, imx355_test_pattern_menu);
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		dev_err(&client->dev, "%s control init failed (%d)\n",
+			__func__, ret);
+		goto error;
+	}
+
+	imx355->sd.ctrl_handler = ctrl_hdlr;
+
+	return 0;
+
+error:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
+
+	return ret;
+}
+
+static void imx355_free_controls(struct imx355 *imx355)
+{
+	v4l2_ctrl_handler_free(imx355->sd.ctrl_handler);
+}
+
+static int imx355_probe(struct i2c_client *client)
+{
+	struct imx355 *imx355;
+	int ret;
+
+	imx355 = devm_kzalloc(&client->dev, sizeof(*imx355), GFP_KERNEL);
+	if (!imx355)
+		return -ENOMEM;
+
+	mutex_init(&imx355->mutex);
+
+	/* Initialize subdev */
+	v4l2_i2c_subdev_init(&imx355->sd, client, &imx355_subdev_ops);
+
+	/* Check module identity */
+	ret = imx355_identify_module(imx355);
+	if (ret) {
+		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
+		goto error_probe;
+	}
+
+	/* Set default mode to max resolution */
+	imx355->cur_mode = &supported_modes[0];
+
+	ret = imx355_init_controls(imx355);
+	if (ret) {
+		dev_err(&client->dev, "failed to init controls: %d\n", ret);
+		goto error_probe;
+	}
+
+	/* Initialize subdev */
+	imx355->sd.internal_ops = &imx355_internal_ops;
+	imx355->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	imx355->sd.entity.ops = &imx355_subdev_entity_ops;
+	imx355->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+
+	/* Initialize source pad */
+	imx355->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&imx355->sd.entity, 1, &imx355->pad);
+	if (ret) {
+		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
+		goto error_handler_free;
+	}
+
+	ret = v4l2_async_register_subdev_sensor_common(&imx355->sd);
+	if (ret < 0)
+		goto error_media_entity;
+
+	/*
+	 * Device is already turned on by i2c-core with ACPI domain PM.
+	 * Enable runtime PM and turn off the device.
+	 */
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+error_media_entity:
+	media_entity_cleanup(&imx355->sd.entity);
+
+error_handler_free:
+	imx355_free_controls(imx355);
+
+error_probe:
+	mutex_destroy(&imx355->mutex);
+
+	return ret;
+}
+
+static int imx355_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct imx355 *imx355 = to_imx355(sd);
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	imx355_free_controls(imx355);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	mutex_destroy(&imx355->mutex);
+
+	return 0;
+}
+
+static const struct dev_pm_ops imx355_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(imx355_suspend, imx355_resume)
+};
+
+static const struct acpi_device_id imx355_acpi_ids[] = {
+	{"SONY355A"},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(acpi, imx355_acpi_ids);
+
+static struct i2c_driver imx355_i2c_driver = {
+	.driver = {
+		.name = "imx355",
+		.pm = &imx355_pm_ops,
+		.acpi_match_table = ACPI_PTR(imx355_acpi_ids),
+	},
+	.probe_new = imx355_probe,
+	.remove = imx355_remove,
+};
+module_i2c_driver(imx355_i2c_driver);
+
+MODULE_AUTHOR("Qiu, Tianshu <tian.shu.qiu@intel.com>");
+MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>");
+MODULE_AUTHOR("Bingbu Cao <bingbu.cao@intel.com>");
+MODULE_DESCRIPTION("Sony imx355 sensor driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
