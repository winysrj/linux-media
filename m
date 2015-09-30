Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:41959 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbbI3I6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2015 04:58:22 -0400
From: Javier Martin <javiermartin@by.com.es>
To: linux-media@vger.kernel.org
Cc: antonioperez@by.com.es, manuel@by.com.es, german@by.com.es,
	g.liakhovetski@gmx.de, Javier Martin <javiermartin@by.com.es>
Subject: [PATCH v2] media: Add a driver for the ov5640 sensor.
Date: Wed, 30 Sep 2015 10:57:54 +0200
Message-Id: <1443603474-31352-1-git-send-email-javiermartin@by.com.es>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov5640 sensor from Omnivision supports up to 2592x1944
and both CSI and MIPI interfaces.

The following driver adds support for the CSI interface only
and VGA, 720p resolutions at 30fps.

Signed-off-by: Javier Martin <javiermartin@by.com.es>
---
 .../devicetree/bindings/media/i2c/ov5640.txt       |   47 +
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5640.c                         | 1403 ++++++++++++++++++++
 4 files changed, 1462 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
 create mode 100644 drivers/media/i2c/ov5640.c

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
new file mode 100644
index 0000000..2e93e97
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -0,0 +1,47 @@
+* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
+
+The Omnivision OV5640 is a 1/4-Inch CMOS active pixel digital image sensor with
+an active array size of 2592H x 1932V. It is programmable through a simple
+two-wire serial interface.
+
+Required Properties:
+- compatible: value should be "ovti,ov5640"
+- clocks: reference to the xclk clock
+- clock-names: should be "xclk"
+- clock-rates: the xclk clock frequency
+
+Optional Properties:
+- reset-gpio: Chip reset GPIO
+- pwdn-gpio: Chip power down GPIO
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	&i2c1 {
+		...
+
+		ov5640: ov5640@3c {
+			compatible = "ovti,ov5640";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_ov5640 &pinctrl_csi0>;
+			reg = <0x3c>;
+
+			clocks = <&clks 200>;
+			clock-names = "xclk";
+			clock-rates = <24000000>;
+
+			reset-gpio = <&gpio5 20 GPIO_ACTIVE_LOW>;
+			pwdn-gpio = <&gpio1 6 GPIO_ACTIVE_HIGH>;
+
+			port {
+				ov5640_to_csi0: endpoint {
+					remote-endpoint = <&csi0_from_ov5640>;
+					hsync-active = <1>;
+					vsync-active = <1>;
+				};
+			};
+		};
+	};
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6f30ea7..8c6689b 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -488,6 +488,17 @@ config VIDEO_OV7640
 	  To compile this driver as a module, choose M here: the
 	  module will be called ov7640.
 
+config VIDEO_OV5640
+	tristate "OmniVision OV5640 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV5640 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov5640.
+
 config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 34e7da2..65b224f 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
 obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
 obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
new file mode 100644
index 0000000..e06b812
--- /dev/null
+++ b/drivers/media/i2c/ov5640.c
@@ -0,0 +1,1403 @@
+/*
+ * Driver for the OV5640 sensor from Omnivision CSI interface only.
+ *
+ * Copyright (C) 2015 By Tech Design S.L. All Rights Reserved.
+ * Copyright (C) 2012-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * Based on the MT9P031 driver and an out of tree ov5640 driver by Freescale:
+ * https://github.com/varigit/linux-2.6-imx/blob/imx_3.14.38_6qp_beta-var02/
+ *		drivers/media/platform/mxc/capture/ov5640.c
+ *
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
+#include <linux/types.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+
+#define OV5640_VOLTAGE_ANALOG               2800000
+#define OV5640_VOLTAGE_DIGITAL_CORE         1500000
+#define OV5640_VOLTAGE_DIGITAL_IO           1800000
+
+#define OV5640_XCLK_MIN 6000000
+#define OV5640_XCLK_MAX 24000000
+
+#define OV5640_SYSTEM_CTRL0		0x3008
+#define		OV5640_SOFT_RESET		(1 << 7)
+#define OV5640_CHIP_ID_HIGH_REG		0x300A
+#define		OV5640_CHIP_ID_HIGH		0x56
+#define OV5640_CHIP_ID_LOW_REG		0x300B
+#define		OV5640_CHIP_ID_LOW		0x40
+#define OV5640_PAD_OUTPUT_ENABLE_01	0x3017
+#define OV5640_PAD_OUTPUT_ENABLE_02	0x3018
+#define		OV5640_PAD_DISABLE_ALL		0x00
+#define		OV5640_PAD_ENABLE_ALL		0xff
+#define OV5640_PAD_CONTROL		0x302c
+#define		OV5640_SET_PAD_STRENGTH(x)	((x) << 6)
+#define		OV5640_PAD_STRENGTH_MASK	((3) << 6)
+#define OV5640_AEC_PK_MANUAL		0x3503
+#define		OV5640_AEC_MANUAL_ENABLE	(1 << 0)
+#define		OV5640_AGC_MANUAL_ENABLE	(1 << 1)
+#define OV5640_AEC_PK_REAL_GAIN_LOW	0x350b
+#define OV5640_AEC_PK_REAL_GAIN_HIGH	0x350a
+#define OV5640_AEC_CTRL0F_WPT		0x3a0f
+#define OV5640_AEC_CTRL10_BPT		0x3a10
+#define OV5640_AEC_CTRL1B_WPT2		0x3a1b
+#define OV5640_AEC_CTRL1E_BPT2		0x3a1e
+#define OV5640_AEC_CTRL11_VPTH		0x3a11
+#define OV5640_AEC_CTRL1f_VPTL		0x3a1f
+#define OV5640_AEC_GAIN_CEILING_LOW	0x3a19
+#define OV5640_AEC_GAIN_CEILING_HIGH	0x3a18
+#define OV5640_GAIN_FULL_MASK			0x3ff
+#define OV5640_TIMING_TC_REG20		0x3820
+#define		OV5640_SENSOR_VFLIP		(1 << 1)
+#define		OV5640_ISP_VFLIP		(1 << 2)
+#define OV5640_TIMING_TC_REG21		0x3821
+#define		OV5640_H_BINNING_ENABLE		(1 << 0)
+#define		OV5640_SENSOR_MIRROR		(1 << 1)
+#define		OV5640_ISP_MIRROR		(1 << 2)
+#define OV5640_ISP_CONTROL1			0x5001
+#define		OV5640_AWB_ENABLE		(1 << 0)
+#define OV5640_PRE_ISP_TEST_SETTING_1	0x503d
+#define		OV5640_TEST_PATTERN_MASK	0x3
+#define		OV5640_SET_TEST_PATTERN(x)	((x) & OV5640_TEST_PATTERN_MASK)
+#define		OV5640_TEST_PATTERN_ENABLE	(1 << 7)
+#define OV5640_SDE_SAT_U		0x5583
+#define OV5640_SDE_SAT_V		0x5584
+#define OV5640_SDE_CTRL1_HUE_COS	0x5581
+#define OV5640_SDE_CTRL2_HUE_SIN	0x5582
+#define OV5640_SDE_CTRL5		0x5585
+#define OV5640_SDE_CTRL6		0x5586
+#define OV5640_SDE_BRIGHT_Y		0x5587
+#define OV5640_SDE_CTRL8		0x5588
+#define		OV5640_U_HUE_SIN_SIGN		(1 << 0)
+#define		OV5640_V_HUE_SIN_SIGN		(1 << 1)
+#define		OV5640_U_HUE_COS_SIGN		(1 << 4)
+#define		OV5640_V_HUE_COS_SIGN		(1 << 5)
+#define OV5640_BRIGHT_Y_SIGN_MASK		0x1
+#define OV5640_BRIGHT_Y_SET_SIGN(x)		(((x) & OV5640_BRIGHT_Y_SIGN_MASK) << 3)
+
+enum ov5640_mode {
+	ov5640_mode_min = 0,
+	ov5640_mode_vga_640_480 = 0,
+	ov5640_mode_720p_1280_720 = 1,
+	ov5640_mode_max = 1,
+};
+
+
+struct reg_value {
+	u16 reg;
+	u8 val;
+};
+
+struct ov5640_mode_info {
+	enum ov5640_mode mode;
+	u32 width;
+	u32 height;
+	struct reg_value *init_data_ptr;
+	u32 init_data_size;
+};
+
+struct ov5640 {
+	struct i2c_client *i2c_client;
+	struct device *dev;
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_of_endpoint ep;
+	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_rect crop;
+	struct clk *xclk;
+	int xclk_freq;
+
+	struct regulator *io_regulator;
+	struct regulator *core_regulator;
+	struct regulator *analog_regulator;
+
+	enum ov5640_mode current_mode;
+
+	/* Cached control values */
+	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *contrast;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *autogain;
+	struct v4l2_ctrl *gain;
+	struct v4l2_ctrl *autoexposure;
+	struct v4l2_ctrl *exposure;
+	struct v4l2_ctrl *awb;
+	struct v4l2_ctrl *pattern;
+
+	struct mutex power_lock; /* lock to protect power_count */
+	int power_count;
+
+	int pwdn_gpio;
+	int rst_gpio;
+};
+
+static inline struct ov5640 *to_ov5640(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ov5640, sd);
+}
+
+static struct reg_value ov5640_global_init_setting[] = {
+	{0x3008, 0x42},
+	{0x3103, 0x03},
+	{0x3034, 0x1a}, {0x3037, 0x13}, {0x3108, 0x01},
+	{0x3630, 0x36}, {0x3631, 0x0e}, {0x3632, 0xe2},
+	{0x3633, 0x12}, {0x3621, 0xe0}, {0x3704, 0xa0},
+	{0x3703, 0x5a}, {0x3715, 0x78}, {0x3717, 0x01},
+	{0x370b, 0x60}, {0x3705, 0x1a}, {0x3905, 0x02},
+	{0x3906, 0x10}, {0x3901, 0x0a}, {0x3731, 0x12},
+	{0x3600, 0x08}, {0x3601, 0x33}, {0x302d, 0x60},
+	{0x3620, 0x52}, {0x371b, 0x20}, {0x471c, 0x50},
+	{0x3a13, 0x43}, {0x3a18, 0x00}, {0x3a19, 0x7c},
+	{0x3635, 0x13}, {0x3636, 0x03}, {0x3634, 0x40},
+	{0x3622, 0x01}, {0x3c01, 0x34}, {0x3c04, 0x28},
+	{0x3c05, 0x98}, {0x3c06, 0x00}, {0x3c07, 0x07},
+	{0x3c08, 0x00}, {0x3c09, 0x1c}, {0x3c0a, 0x9c},
+	{0x3c0b, 0x40}, {0x3810, 0x00}, {0x3811, 0x10},
+	{0x3812, 0x00}, {0x3708, 0x64}, {0x4001, 0x02},
+	{0x4005, 0x1a}, {0x3000, 0x00}, {0x3004, 0xff},
+	{0x300e, 0x58}, {0x302e, 0x00}, {0x4300, 0x30},
+	{0x501f, 0x00}, {0x440e, 0x00}, {0x5000, 0xa7},
+	{0x3008, 0x02},
+};
+
+static struct reg_value ov5640_init_setting_30fps_VGA[] = {
+	{0x3008, 0x42},
+	{0x3103, 0x03},
+	{0x3034, 0x1a}, {0x3035, 0x11}, {0x3036, 0x46},
+	{0x3037, 0x13}, {0x3108, 0x01}, {0x3630, 0x36},
+	{0x3631, 0x0e}, {0x3632, 0xe2}, {0x3633, 0x12},
+	{0x3621, 0xe0}, {0x3704, 0xa0}, {0x3703, 0x5a},
+	{0x3715, 0x78}, {0x3717, 0x01}, {0x370b, 0x60},
+	{0x3705, 0x1a}, {0x3905, 0x02}, {0x3906, 0x10},
+	{0x3901, 0x0a}, {0x3731, 0x12}, {0x3600, 0x08},
+	{0x3601, 0x33}, {0x302d, 0x60}, {0x3620, 0x52},
+	{0x371b, 0x20}, {0x471c, 0x50}, {0x3a13, 0x43},
+	{0x3a18, 0x00}, {0x3a19, 0xf8}, {0x3635, 0x13},
+	{0x3636, 0x03}, {0x3634, 0x40}, {0x3622, 0x01},
+	{0x3c01, 0x34}, {0x3c04, 0x28}, {0x3c05, 0x98},
+	{0x3c06, 0x00}, {0x3c07, 0x08}, {0x3c08, 0x00},
+	{0x3c09, 0x1c}, {0x3c0a, 0x9c}, {0x3c0b, 0x40},
+	{0x3820, 0x41}, {0x3821, 0x07}, {0x3814, 0x31},
+	{0x3815, 0x31}, {0x3800, 0x00}, {0x3801, 0x00},
+	{0x3802, 0x00}, {0x3803, 0x04}, {0x3804, 0x0a},
+	{0x3805, 0x3f}, {0x3806, 0x07}, {0x3807, 0x9b},
+	{0x3808, 0x02}, {0x3809, 0x80}, {0x380a, 0x01},
+	{0x380b, 0xe0}, {0x380c, 0x07}, {0x380d, 0x68},
+	{0x380e, 0x03}, {0x380f, 0xd8}, {0x3810, 0x00},
+	{0x3811, 0x10}, {0x3812, 0x00}, {0x3813, 0x06},
+	{0x3618, 0x00}, {0x3612, 0x29}, {0x3708, 0x64},
+	{0x3709, 0x52}, {0x370c, 0x03}, {0x3a02, 0x03},
+	{0x3a03, 0xd8}, {0x3a08, 0x01}, {0x3a09, 0x27},
+	{0x3a0a, 0x00}, {0x3a0b, 0xf6}, {0x3a0e, 0x03},
+	{0x3a0d, 0x04}, {0x3a14, 0x03}, {0x3a15, 0xd8},
+	{0x4001, 0x02}, {0x4004, 0x02}, {0x3000, 0x00},
+	{0x3002, 0x1c}, {0x3004, 0xff}, {0x3006, 0xc3},
+	{0x300e, 0x58}, {0x302e, 0x00}, {0x4300, 0x30},
+	{0x501f, 0x00}, {0x4713, 0x03}, {0x4407, 0x04},
+	{0x440e, 0x00}, {0x460b, 0x35}, {0x460c, 0x22},
+	{0x4837, 0x22}, {0x3824, 0x02}, {0x5000, 0xa7},
+	{0x5001, 0xa3}, {0x5180, 0xff}, {0x5181, 0xf2},
+	{0x5182, 0x00}, {0x5183, 0x14}, {0x5184, 0x25},
+	{0x5185, 0x24}, {0x5186, 0x09}, {0x5187, 0x09},
+	{0x5188, 0x09}, {0x5189, 0x88}, {0x518a, 0x54},
+	{0x518b, 0xee}, {0x518c, 0xb2}, {0x518d, 0x50},
+	{0x518e, 0x34}, {0x518f, 0x6b}, {0x5190, 0x46},
+	{0x5191, 0xf8}, {0x5192, 0x04}, {0x5193, 0x70},
+	{0x5194, 0xf0}, {0x5195, 0xf0}, {0x5196, 0x03},
+	{0x5197, 0x01}, {0x5198, 0x04}, {0x5199, 0x6c},
+	{0x519a, 0x04}, {0x519b, 0x00}, {0x519c, 0x09},
+	{0x519d, 0x2b}, {0x519e, 0x38}, {0x5381, 0x1e},
+	{0x5382, 0x5b}, {0x5383, 0x08}, {0x5384, 0x0a},
+	{0x5385, 0x7e}, {0x5386, 0x88}, {0x5387, 0x7c},
+	{0x5388, 0x6c}, {0x5389, 0x10}, {0x538a, 0x01},
+	{0x538b, 0x98}, {0x5300, 0x08}, {0x5301, 0x30},
+	{0x5302, 0x10}, {0x5303, 0x00}, {0x5304, 0x08},
+	{0x5305, 0x30}, {0x5306, 0x08}, {0x5307, 0x16},
+	{0x5309, 0x08}, {0x530a, 0x30}, {0x530b, 0x04},
+	{0x530c, 0x06}, {0x5480, 0x01}, {0x5481, 0x08},
+	{0x5482, 0x14}, {0x5483, 0x28}, {0x5484, 0x51},
+	{0x5485, 0x65}, {0x5486, 0x71}, {0x5487, 0x7d},
+	{0x5488, 0x87}, {0x5489, 0x91}, {0x548a, 0x9a},
+	{0x548b, 0xaa}, {0x548c, 0xb8}, {0x548d, 0xcd},
+	{0x548e, 0xdd}, {0x548f, 0xea}, {0x5490, 0x1d},
+	{0x5580, 0x07}, {0x5583, 0x40}, {0x5584, 0x10},
+	{0x5589, 0x10}, {0x558a, 0x00}, {0x558b, 0xf8},
+	{0x5800, 0x23}, {0x5801, 0x14}, {0x5802, 0x0f},
+	{0x5803, 0x0f}, {0x5804, 0x12}, {0x5805, 0x26},
+	{0x5806, 0x0c}, {0x5807, 0x08}, {0x5808, 0x05},
+	{0x5809, 0x05}, {0x580a, 0x08}, {0x580b, 0x0d},
+	{0x580c, 0x08}, {0x580d, 0x03}, {0x580e, 0x00},
+	{0x580f, 0x00}, {0x5810, 0x03}, {0x5811, 0x09},
+	{0x5812, 0x07}, {0x5813, 0x03}, {0x5814, 0x00},
+	{0x5815, 0x01}, {0x5816, 0x03}, {0x5817, 0x08},
+	{0x5818, 0x0d}, {0x5819, 0x08}, {0x581a, 0x05},
+	{0x581b, 0x06}, {0x581c, 0x08}, {0x581d, 0x0e},
+	{0x581e, 0x29}, {0x581f, 0x17}, {0x5820, 0x11},
+	{0x5821, 0x11}, {0x5822, 0x15}, {0x5823, 0x28},
+	{0x5824, 0x46}, {0x5825, 0x26}, {0x5826, 0x08},
+	{0x5827, 0x26}, {0x5828, 0x64}, {0x5829, 0x26},
+	{0x582a, 0x24}, {0x582b, 0x22}, {0x582c, 0x24},
+	{0x582d, 0x24}, {0x582e, 0x06}, {0x582f, 0x22},
+	{0x5830, 0x40}, {0x5831, 0x42}, {0x5832, 0x24},
+	{0x5833, 0x26}, {0x5834, 0x24}, {0x5835, 0x22},
+	{0x5836, 0x22}, {0x5837, 0x26}, {0x5838, 0x44},
+	{0x5839, 0x24}, {0x583a, 0x26}, {0x583b, 0x28},
+	{0x583c, 0x42}, {0x583d, 0xce}, {0x5025, 0x00},
+	{0x3a0f, 0x30}, {0x3a10, 0x28}, {0x3a1b, 0x30},
+	{0x3a1e, 0x26}, {0x3a11, 0x60}, {0x3a1f, 0x14},
+	{0x3008, 0x02}, {0x3034, 0x1a}, {0x3035, 0x11},
+	{0x3036, 0x46}, {0x3037, 0x13},
+};
+
+static struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
+	{0x3c07, 0x08}, {0x3820, 0x41}, {0x3821, 0x07},
+	{0x3814, 0x31}, {0x3815, 0x31}, {0x3800, 0x00},
+	{0x3801, 0x00}, {0x3802, 0x00}, {0x3803, 0x04},
+	{0x3804, 0x0a}, {0x3805, 0x3f}, {0x3806, 0x07},
+	{0x3807, 0x9b}, {0x3808, 0x02}, {0x3809, 0x80},
+	{0x380a, 0x01}, {0x380b, 0xe0}, {0x380c, 0x07},
+	{0x380d, 0x68}, {0x380e, 0x03}, {0x380f, 0xd8},
+	{0x3813, 0x06}, {0x3618, 0x00}, {0x3612, 0x29},
+	{0x3709, 0x52}, {0x370c, 0x03}, {0x3a02, 0x0b},
+	{0x3a03, 0x88}, {0x3a14, 0x0b}, {0x3a15, 0x88},
+	{0x4004, 0x02}, {0x3002, 0x1c}, {0x3006, 0xc3},
+	{0x4713, 0x03}, {0x4407, 0x04}, {0x460b, 0x35},
+	{0x460c, 0x22}, {0x4837, 0x22}, {0x3824, 0x02},
+	{0x5001, 0xa3}, {0x3034, 0x1a}, {0x3035, 0x11},
+	{0x3036, 0x46}, {0x3037, 0x13}, {0x3503, 0x00},
+};
+
+static struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
+	{0x3035, 0x21}, {0x3036, 0x69}, {0x3c07, 0x07},
+	{0x3820, 0x41}, {0x3821, 0x07}, {0x3814, 0x31},
+	{0x3815, 0x31}, {0x3800, 0x00}, {0x3801, 0x00},
+	{0x3802, 0x00}, {0x3803, 0xfa}, {0x3804, 0x0a},
+	{0x3805, 0x3f}, {0x3806, 0x06}, {0x3807, 0xa9},
+	{0x3808, 0x05}, {0x3809, 0x00}, {0x380a, 0x02},
+	{0x380b, 0xd0}, {0x380c, 0x07}, {0x380d, 0x64},
+	{0x380e, 0x02}, {0x380f, 0xe4}, {0x3813, 0x04},
+	{0x3618, 0x00}, {0x3612, 0x29}, {0x3709, 0x52},
+	{0x370c, 0x03}, {0x3a02, 0x02}, {0x3a03, 0xe0},
+	{0x3a14, 0x02}, {0x3a15, 0xe0}, {0x4004, 0x02},
+	{0x3002, 0x1c}, {0x3006, 0xc3}, {0x4713, 0x03},
+	{0x4407, 0x04}, {0x460b, 0x37}, {0x460c, 0x20},
+	{0x4837, 0x16}, {0x3824, 0x04}, {0x5001, 0x83},
+	{0x3503, 0x00},
+};
+
+
+
+static struct ov5640_mode_info ov5640_mode_info_data[ov5640_mode_max + 1] = {
+	{ov5640_mode_vga_640_480,      640,  480,
+	ov5640_setting_30fps_VGA_640_480,
+	ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
+	{ov5640_mode_720p_1280_720,   1280,  720,
+	ov5640_setting_30fps_720P_1280_720,
+	ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
+};
+
+static int ov5640_probe(struct i2c_client *adapter,
+				const struct i2c_device_id *device_id);
+static int ov5640_remove(struct i2c_client *client);
+
+static s32 ov5640_read_reg(struct ov5640 *ov5640, u16 reg, u8 *val);
+static s32 ov5640_write_reg(struct ov5640 *ov5640, u16 reg, u8 val);
+static int ov5640_set_exposure(struct ov5640 *ov5640, s32 value);
+
+static void ov5640_regulators_get(struct ov5640 *ov5640)
+{
+	ov5640->io_regulator = devm_regulator_get(ov5640->dev, "DOVDD");
+	if (IS_ERR(ov5640->io_regulator)) {
+		ov5640->io_regulator = NULL;
+		dev_warn(ov5640->dev, "cannot get io voltage\n");
+	} else {
+		regulator_set_voltage(ov5640->io_regulator,
+				OV5640_VOLTAGE_DIGITAL_IO,
+				OV5640_VOLTAGE_DIGITAL_IO);
+	}
+
+	ov5640->core_regulator = devm_regulator_get(ov5640->dev, "DVDD");
+	if (IS_ERR(ov5640->core_regulator)) {
+		ov5640->core_regulator = NULL;
+		dev_warn(ov5640->dev, "cannot get core voltage\n");
+	} else {
+		regulator_set_voltage(ov5640->core_regulator,
+				OV5640_VOLTAGE_DIGITAL_CORE,
+				OV5640_VOLTAGE_DIGITAL_CORE);
+	}
+
+	ov5640->analog_regulator = devm_regulator_get(ov5640->dev, "AVDD");
+	if (IS_ERR(ov5640->analog_regulator)) {
+		ov5640->analog_regulator = NULL;
+		dev_warn(ov5640->dev, "cannot get analog voltage\n");
+	} else {
+		regulator_set_voltage(ov5640->analog_regulator,
+				OV5640_VOLTAGE_ANALOG,
+				OV5640_VOLTAGE_ANALOG);
+	}
+}
+
+static int ov5640_regulators_enable(struct ov5640 *ov5640)
+{
+	int ret = 0;
+
+	dev_dbg(ov5640->dev, "%s\n", __func__);
+
+	if (ov5640->io_regulator) {
+		ret = regulator_enable(ov5640->io_regulator);
+		if (ret < 0) {
+			dev_err(ov5640->dev, "set io voltage failed\n");
+			return ret;
+		}
+	}
+
+	if (ov5640->core_regulator) {
+		ret = regulator_enable(ov5640->core_regulator);
+		if (ret) {
+			dev_err(ov5640->dev, "set core voltage failed\n");
+			goto err_disable_io;
+		}
+	}
+
+	if (ov5640->analog_regulator) {
+		ret = regulator_enable(ov5640->analog_regulator);
+		if (ret) {
+			dev_err(ov5640->dev, "set analog voltage failed\n");
+			goto err_disable_core;
+		}
+	}
+
+	return 0;
+
+err_disable_core:
+	if (ov5640->core_regulator)
+		regulator_disable(ov5640->core_regulator);
+err_disable_io:
+	if (ov5640->io_regulator)
+		regulator_disable(ov5640->io_regulator);
+
+	return ret;
+}
+
+static void ov5640_regulators_disable(struct ov5640 *ov5640)
+{
+	if (ov5640->analog_regulator)
+		regulator_disable(ov5640->analog_regulator);
+	if (ov5640->core_regulator)
+		regulator_disable(ov5640->core_regulator);
+	if (ov5640->io_regulator)
+		regulator_disable(ov5640->io_regulator);
+}
+
+static s32 ov5640_write_reg(struct ov5640 *ov5640, u16 reg, u8 val)
+{
+	u8 regbuf[3] = {0};
+
+	regbuf[0] = reg >> 8;
+	regbuf[1] = reg & 0xff;
+	regbuf[2] = val;
+
+	if (i2c_master_send(ov5640->i2c_client, regbuf, 3) < 0) {
+		pr_err("%s:write reg error:reg=%x,val=%x\n",
+			__func__, reg, val);
+		return -1;
+	}
+
+	return 0;
+}
+
+static s32 ov5640_read_reg(struct ov5640 *ov5640, u16 reg, u8 *val)
+{
+	u8 regbuf[2] = {0};
+	u8 tmpval = 0;
+
+	regbuf[0] = reg >> 8;
+	regbuf[1] = reg & 0xff;
+
+	if (2 != i2c_master_send(ov5640->i2c_client, regbuf, 2)) {
+		dev_err(ov5640->dev, "%s:write reg error:reg=%x\n",
+				__func__, reg);
+		return -1;
+	}
+
+	if (1 != i2c_master_recv(ov5640->i2c_client, &tmpval, 1)) {
+		dev_err(ov5640->dev, "%s:read reg error:reg=%x,val=%x\n",
+				__func__, reg, tmpval);
+		return -1;
+	}
+
+	*val = tmpval;
+
+	return tmpval;
+}
+
+static void ov5640_soft_reset(struct ov5640 *ov5640)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_SYSTEM_CTRL0, &val);
+	val |= OV5640_SOFT_RESET;
+	ov5640_write_reg(ov5640, OV5640_SYSTEM_CTRL0, val);
+
+	/* We need to wait at least 10ms for the soft reset to have effect */
+	msleep(20);
+}
+
+static void ov5640_set_driver_strength(struct ov5640 *ov5640, int strength)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_PAD_CONTROL, &val);
+	val &= ~OV5640_PAD_STRENGTH_MASK;
+	val |= OV5640_SET_PAD_STRENGTH(strength - 1);
+	ov5640_write_reg(ov5640, OV5640_PAD_CONTROL, val);
+}
+
+/* calculate sysclk */
+static int ov5640_get_sysclk(struct ov5640 *ov5640)
+{
+	int xvclk = ov5640->xclk_freq / 10000;
+	int sysclk;
+	int temp1, temp2;
+	int multiplier, prediv, vco, sysdiv, pll_rdiv, bit_div2x, sclk_rdiv;
+	int sclk_rdiv_map[] = {1, 2, 4, 8};
+	u8 regval = 0;
+
+	temp1 = ov5640_read_reg(ov5640, 0x3034, &regval);
+	temp2 = temp1 & 0x0f;
+	if (temp2 == 8 || temp2 == 10) {
+		bit_div2x = temp2 / 2;
+	} else {
+		pr_err("ov5640: unsupported bit mode %d\n", temp2);
+		return -1;
+	}
+
+	temp1 = ov5640_read_reg(ov5640, 0x3035, &regval);
+	sysdiv = temp1 >> 4;
+	if (sysdiv == 0)
+		sysdiv = 16;
+
+	temp1 = ov5640_read_reg(ov5640, 0x3036, &regval);
+	multiplier = temp1;
+	temp1 = ov5640_read_reg(ov5640, 0x3037, &regval);
+	prediv = temp1 & 0x0f;
+	pll_rdiv = ((temp1 >> 4) & 0x01) + 1;
+
+	temp1 = ov5640_read_reg(ov5640, 0x3108, &regval);
+	temp2 = temp1 & 0x03;
+
+	sclk_rdiv = sclk_rdiv_map[temp2];
+	vco = xvclk * multiplier / prediv;
+	sysclk = vco / sysdiv / pll_rdiv * 2 / bit_div2x / sclk_rdiv;
+
+	return sysclk;
+}
+
+static int ov5640_get_hts(struct ov5640 *ov5640)
+{
+	int hts;
+	u8 temp = 0;
+
+	hts = ov5640_read_reg(ov5640, 0x380c, &temp);
+	hts = (hts<<8) + ov5640_read_reg(ov5640, 0x380d, &temp);
+	return hts;
+}
+
+static int ov5640_get_vts(struct ov5640 *ov5640)
+{
+	int vts;
+	u8 temp = 0;
+
+	vts = ov5640_read_reg(ov5640, 0x380e, &temp);
+	vts = (vts<<8) + ov5640_read_reg(ov5640, 0x380f, &temp);
+
+	return vts;
+}
+
+/*
+ * The banding filter configuration depends on hts and vts, so it needs to be
+ * configured after every mode change.
+ */
+static void ov5640_set_bandingfilter(struct ov5640 *ov5640)
+{
+	int prev_vts, prev_hts;
+	int band_step60, max_band60, band_step50, max_band50;
+	int prev_sysclk;
+
+	/* read preview PCLK */
+	prev_sysclk = ov5640_get_sysclk(ov5640);
+
+	/* read preview hts */
+	prev_hts = ov5640_get_hts(ov5640);
+
+	/* read preview vts */
+	prev_vts = ov5640_get_vts(ov5640);
+
+	/* calculate banding filter */
+	/* 60Hz */
+	band_step60 = prev_sysclk * 100/prev_hts * 100/120;
+	ov5640_write_reg(ov5640, 0x3a0a, (band_step60 >> 8));
+	ov5640_write_reg(ov5640, 0x3a0b, (band_step60 & 0xff));
+
+	max_band60 = (int)((prev_vts-4)/band_step60);
+	ov5640_write_reg(ov5640, 0x3a0d, max_band60);
+
+	/* 50Hz */
+	band_step50 = prev_sysclk * 100/prev_hts;
+	ov5640_write_reg(ov5640, 0x3a08, (band_step50 >> 8));
+	ov5640_write_reg(ov5640, 0x3a09, (band_step50 & 0xff));
+
+	max_band50 = (int)((prev_vts-4)/band_step50);
+	ov5640_write_reg(ov5640, 0x3a0e, max_band50);
+}
+
+static int ov5640_set_aec_mode(struct ov5640 *ov5640, u32 mode)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_AEC_PK_MANUAL, &val);
+	if (mode == V4L2_EXPOSURE_AUTO) {
+		val |= OV5640_AEC_MANUAL_ENABLE;
+	} else { /* V4L2_EXPOSURE_MANUAL */
+		val &= ~OV5640_AEC_MANUAL_ENABLE;
+	}
+
+	dev_dbg(ov5640->dev, "%s: mode = %d\n", __func__, mode);
+
+	return ov5640_write_reg(ov5640, OV5640_AEC_PK_MANUAL, val);
+}
+
+static int ov5640_set_agc_mode(struct ov5640 *ov5640, u32 enable)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_AEC_PK_MANUAL, &val);
+	if (!enable)
+		val |= OV5640_AGC_MANUAL_ENABLE;
+	else
+		val &= ~OV5640_AGC_MANUAL_ENABLE;
+
+	dev_dbg(ov5640->dev, "%s: enable = %d\n", __func__, enable);
+
+	return ov5640_write_reg(ov5640, OV5640_AEC_PK_MANUAL, val);
+}
+
+static int ov5640_set_register_array(struct ov5640 *ov5640,
+				     struct reg_value *settings,
+				     s32 num_settings)
+{
+	register u16 reg = 0;
+	register u8 val = 0;
+	int i, ret = 0;
+
+	for (i = 0; i < num_settings; ++i, ++settings) {
+		reg = settings->reg;
+		val = settings->val;
+
+		ret = ov5640_write_reg(ov5640, reg, val);
+		if (ret < 0)
+			goto err;
+	}
+err:
+	return ret;
+}
+
+static int ov5640_init(struct ov5640 *ov5640)
+{
+	struct reg_value *settings = NULL;
+	int num_settings = 0;
+	int ret;
+
+	ov5640_soft_reset(ov5640);
+
+	settings = ov5640_global_init_setting;
+	num_settings = ARRAY_SIZE(ov5640_global_init_setting);
+	ret = ov5640_set_register_array(ov5640, settings, num_settings);
+	if (ret < 0)
+		return ret;
+
+	settings = ov5640_init_setting_30fps_VGA;
+	num_settings = ARRAY_SIZE(ov5640_init_setting_30fps_VGA);
+	ret = ov5640_set_register_array(ov5640, settings, num_settings);
+	if (ret < 0)
+		return ret;
+
+	ov5640_set_driver_strength(ov5640, 2);
+
+	ov5640_set_bandingfilter(ov5640);
+	ov5640_set_exposure(ov5640, 52);
+
+	return 0;
+}
+
+static int ov5640_change_mode(struct ov5640 *ov5640,
+			    enum ov5640_mode mode)
+{
+	struct reg_value *settings = NULL;
+	s32 num_settings = 0;
+	int ret = 0;
+
+	settings = ov5640_mode_info_data[mode].init_data_ptr;
+	num_settings = ov5640_mode_info_data[mode].init_data_size;
+	ret = ov5640_set_register_array(ov5640, settings, num_settings);
+
+	/* calculate banding filter */
+	ov5640_set_bandingfilter(ov5640);
+
+	/* set AE target */
+	ov5640_set_exposure(ov5640, 52);
+
+	return ret;
+}
+
+static void __ov5640_set_power(struct ov5640 *ov5640, bool on)
+{
+	dev_dbg(ov5640->dev, "%s: on = %d\n", __func__, on);
+
+	if (on) {
+		clk_prepare_enable(ov5640->xclk);
+		ov5640_regulators_enable(ov5640);
+		msleep(10);
+		if (ov5640->pwdn_gpio)
+			gpio_set_value(ov5640->pwdn_gpio, 0);
+		msleep(1);
+		if (ov5640->rst_gpio)
+			gpio_set_value(ov5640->rst_gpio, 1);
+		msleep(20);
+	} else {
+		if (ov5640->rst_gpio)
+			gpio_set_value(ov5640->rst_gpio, 0);
+		if (ov5640->pwdn_gpio)
+			gpio_set_value(ov5640->pwdn_gpio, 1);
+		ov5640_regulators_disable(ov5640);
+		clk_disable_unprepare(ov5640->xclk);
+	}
+}
+
+static int ov5640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov5640 *ov5640 = to_ov5640(sd);
+
+	dev_dbg(ov5640->dev, "%s: on = %d\n", __func__, on);
+
+	mutex_lock(&ov5640->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (ov5640->power_count == !on)
+		__ov5640_set_power(ov5640, !!on);
+
+	/* Update the power count. */
+	ov5640->power_count += on ? 1 : -1;
+	WARN_ON(ov5640->power_count < 0);
+
+	mutex_unlock(&ov5640->power_lock);
+
+	return 0;
+}
+
+
+static int ov5640_set_saturation(struct ov5640 *ov5640, s32 value)
+{
+	u32 reg_value = (value * 0x10) + 0x40;
+	int ret = 0;
+
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_SAT_U, reg_value);
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_SAT_V, reg_value);
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ret;
+}
+
+static int ov5640_set_brightness(struct ov5640 *ov5640, s32 value)
+{
+	int ret = 0;
+	u8 sign, val;
+
+	if (value < 0)
+		sign = 1;
+	else
+		sign = 0;
+
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_BRIGHT_Y, abs(value));
+
+	ret |= ov5640_read_reg(ov5640, OV5640_SDE_CTRL8, &val);
+	val &= ~OV5640_BRIGHT_Y_SET_SIGN(OV5640_BRIGHT_Y_SIGN_MASK);
+	val |= OV5640_BRIGHT_Y_SET_SIGN(sign);
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_CTRL8, val);
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ret;
+}
+
+static int ov5640_set_contrast(struct ov5640 *ov5640, s32 value)
+{
+	u32 reg_value = 0x04 * value + 0x20;
+	int ret = 0;
+
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_CTRL6, reg_value);
+	ret |= ov5640_write_reg(ov5640, OV5640_SDE_CTRL5, reg_value);
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ret;
+}
+
+static int ov5640_set_hflip(struct ov5640 *ov5640, s32 value)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_TIMING_TC_REG21, &val);
+	if (value == 0)
+		val &= ~(OV5640_SENSOR_MIRROR | OV5640_ISP_MIRROR);
+	else
+		val |= (OV5640_SENSOR_MIRROR | OV5640_ISP_MIRROR);
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5640_write_reg(ov5640, OV5640_TIMING_TC_REG21, val);
+}
+
+static int ov5640_set_vflip(struct ov5640 *ov5640, s32 value)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_TIMING_TC_REG20, &val);
+	if (value == 0)
+		val &= ~(OV5640_SENSOR_VFLIP | OV5640_ISP_VFLIP);
+	else
+		val |= (OV5640_SENSOR_VFLIP | OV5640_ISP_VFLIP);
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5640_write_reg(ov5640, OV5640_TIMING_TC_REG20, val);
+}
+
+static int ov5640_set_test_pattern(struct ov5640 *ov5640, s32 value)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_PRE_ISP_TEST_SETTING_1, &val);
+
+	if (value) {
+		val &= ~OV5640_SET_TEST_PATTERN(OV5640_TEST_PATTERN_MASK);
+		val |= OV5640_SET_TEST_PATTERN(value - 1);
+		val |= OV5640_TEST_PATTERN_ENABLE;
+	} else {
+		val &= ~OV5640_TEST_PATTERN_ENABLE;
+	}
+
+	dev_dbg(ov5640->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5640_write_reg(ov5640, OV5640_PRE_ISP_TEST_SETTING_1, val);
+}
+
+static const char * const ov5640_test_pattern_menu[] = {
+	"Disabled",
+	"Vertical Color Bars",
+	"Random Data",
+	"Color Square",
+	"Black Image",
+};
+
+static int ov5640_set_exposure(struct ov5640 *ov5640, s32 target)
+{
+	int fast_high, fast_low;
+	int ae_low, ae_high;
+
+	ae_low = target * 23 / 25; /* 0.92 */
+	ae_high = target * 27 / 25; /* 1.08 */
+	fast_high = ae_high << 1;
+
+	if (fast_high > 255)
+		fast_high = 255;
+	fast_low = ae_low >> 1;
+
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL0F_WPT, ae_high);
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL10_BPT, ae_low);
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL1B_WPT2, ae_high);
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL1E_BPT2, ae_low);
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL11_VPTH, fast_high);
+	ov5640_write_reg(ov5640, OV5640_AEC_CTRL1f_VPTL, fast_low);
+
+	dev_dbg(ov5640->dev, "%s: target = %d\n", __func__, target);
+
+	return 0;
+}
+
+static int ov5640_set_gain(struct ov5640 *ov5640, s32 gain)
+{
+	u8 val;
+
+	val = gain & 0xff;
+
+	ov5640_write_reg(ov5640, OV5640_AEC_PK_REAL_GAIN_LOW, val);
+	ov5640_write_reg(ov5640, OV5640_AEC_GAIN_CEILING_LOW, val);
+
+	val = (gain & OV5640_GAIN_FULL_MASK) >> 8;
+
+	ov5640_write_reg(ov5640, OV5640_AEC_PK_REAL_GAIN_HIGH, val);
+	ov5640_write_reg(ov5640, OV5640_AEC_GAIN_CEILING_HIGH, val);
+
+	dev_dbg(ov5640->dev, "%s: gain = %d\n", __func__, gain);
+
+	return 0;
+}
+
+static int ov5640_set_awb(struct ov5640 *ov5640, s32 enable)
+{
+	u8 val;
+
+	ov5640_read_reg(ov5640, OV5640_ISP_CONTROL1, &val);
+	if (enable)
+		val |= OV5640_AWB_ENABLE;
+	else
+		val &= ~OV5640_AWB_ENABLE;
+
+	dev_dbg(ov5640->dev, "%s: enable = %d\n", __func__, enable);
+
+	return ov5640_write_reg(ov5640, OV5640_ISP_CONTROL1, val);
+}
+
+static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov5640 *ov5640 =
+		container_of(ctrl->handler, struct ov5640, ctrls);
+	int ret = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ret = ov5640_set_brightness(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = ov5640_set_contrast(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		ret = ov5640_set_saturation(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = ov5640_set_awb(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		ret = ov5640_set_agc_mode(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_GAIN:
+		ret = ov5640_set_gain(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = ov5640_set_aec_mode(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		ret = ov5640_set_exposure(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		ret = ov5640_set_test_pattern(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		ret = ov5640_set_hflip(ov5640, ctrl->val);
+		break;
+	case V4L2_CID_VFLIP:
+		ret = ov5640_set_vflip(ov5640, ctrl->val);
+		break;
+	}
+
+	return ret;
+}
+
+static struct v4l2_ctrl_ops ov5640_ctrl_ops = {
+	.s_ctrl = ov5640_s_ctrl,
+};
+
+static int ov5640_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct ov5640 *ov5640 = to_ov5640(sd);
+
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = ov5640->fmt.code;
+
+	return 0;
+}
+
+static int ov5640_enum_frame_size(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->index >= ov5640_mode_max)
+		return -EINVAL;
+
+	fse->min_width = ov5640_mode_info_data[fse->index].width;
+	fse->max_width = ov5640_mode_info_data[fse->index].width;
+	fse->min_height = ov5640_mode_info_data[fse->index].height;
+	fse->max_height = ov5640_mode_info_data[fse->index].height;
+
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *
+__ov5640_get_pad_format(struct ov5640 *ov5640,
+			struct v4l2_subdev_pad_config *cfg,
+			unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(&ov5640->sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &ov5640->fmt;
+	default:
+		return NULL;
+	}
+}
+
+static int ov5640_get_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *format)
+{
+	struct ov5640 *ov5640 = to_ov5640(sd);
+
+	format->format = *__ov5640_get_pad_format(ov5640, cfg, format->pad,
+						  format->which);
+	return 0;
+}
+
+static struct v4l2_rect *
+__ov5640_get_pad_crop(struct ov5640 *ov5640, struct v4l2_subdev_pad_config *cfg,
+		      unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(&ov5640->sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &ov5640->crop;
+	default:
+		return NULL;
+	}
+}
+
+static enum ov5640_mode ov5640_find_nearest_mode(struct ov5640 *ov5640,
+			 int width, int height)
+{
+	int i;
+
+	for (i = ov5640_mode_max; i >= 0; i--) {
+		if (ov5640_mode_info_data[i].width <= width &&
+		    ov5640_mode_info_data[i].height <= height)
+			break;
+	}
+
+	if (i < 0)
+		i = 0;
+
+	return (enum ov5640_mode)i;
+}
+
+static int ov5640_set_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *format)
+{
+	struct ov5640 *ov5640 = to_ov5640(sd);
+	struct v4l2_mbus_framefmt *__format;
+	struct v4l2_rect *__crop;
+	enum ov5640_mode new_mode;
+
+	__crop = __ov5640_get_pad_crop(ov5640, cfg, format->pad,
+			format->which);
+
+	new_mode = ov5640_find_nearest_mode(ov5640,
+			format->format.width, format->format.height);
+	__crop->width = ov5640_mode_info_data[new_mode].width;
+	__crop->height = ov5640_mode_info_data[new_mode].height;
+
+	ov5640->current_mode = new_mode;
+
+	__format = __ov5640_get_pad_format(ov5640, cfg, format->pad,
+			format->which);
+	__format->width = __crop->width;
+	__format->height = __crop->height;
+
+	return 0;
+}
+
+static int ov5640_get_selection(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_selection *sel)
+{
+	struct ov5640 *ov5640 = to_ov5640(sd);
+
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sel->r = *__ov5640_get_pad_crop(ov5640, cfg, sel->pad,
+					    sel->which);
+	return 0;
+}
+
+static int ov5640_registered(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct ov5640 *ov5640 = to_ov5640(subdev);
+	u8 chip_id_high, chip_id_low;
+	int ret;
+
+	ov5640_s_power(&ov5640->sd, true);
+
+	ret = ov5640_read_reg(ov5640, OV5640_CHIP_ID_HIGH_REG, &chip_id_high);
+	if (ret < 0 || chip_id_high != OV5640_CHIP_ID_HIGH) {
+		dev_err(ov5640->dev, "could not read ID high\n");
+		ret = -ENODEV;
+		goto reg_power_off;
+	}
+	ret = ov5640_read_reg(ov5640, OV5640_CHIP_ID_LOW_REG, &chip_id_low);
+	if (ret < 0 || chip_id_low != OV5640_CHIP_ID_LOW) {
+		dev_err(ov5640->dev, "could not read ID low\n");
+		ret = -ENODEV;
+		goto reg_power_off;
+	}
+
+	ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_01, OV5640_PAD_DISABLE_ALL);
+	ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_02, OV5640_PAD_DISABLE_ALL);
+
+	dev_info(&client->dev, "OV5640 detected at address 0x%02x\n",
+		 client->addr);
+
+	ov5640_s_power(&ov5640->sd, false);
+
+	return 0;
+
+reg_power_off:
+	ov5640_s_power(&ov5640->sd, false);
+	return ret;
+}
+
+static int ov5640_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return ov5640_s_power(subdev, true);
+}
+
+static int ov5640_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return ov5640_s_power(subdev, false);
+}
+
+static int ov5640_restore_controls(struct ov5640 *ov5640)
+{
+	int ret = 0;
+
+	ret |= ov5640_set_brightness(ov5640, ov5640->brightness->cur.val);
+	ret |= ov5640_set_contrast(ov5640, ov5640->contrast->cur.val);
+	ret |= ov5640_set_saturation(ov5640, ov5640->saturation->cur.val);
+	ret |= ov5640_set_hflip(ov5640, ov5640->hflip->cur.val);
+	ret |= ov5640_set_vflip(ov5640, ov5640->vflip->cur.val);
+	ret |= ov5640_set_agc_mode(ov5640, ov5640->autogain->cur.val);
+	ret |= ov5640_set_aec_mode(ov5640, ov5640->autoexposure->cur.val);
+	ret |= ov5640_set_awb(ov5640, ov5640->awb->cur.val);
+	ret |= ov5640_set_test_pattern(ov5640, ov5640->pattern->cur.val);
+
+	return ret;
+}
+
+static int ov5640_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct ov5640 *ov5640 = to_ov5640(subdev);
+	int ret;
+
+	dev_dbg(ov5640->dev, "%s: enable = %d\n", __func__, enable);
+
+	if (enable) {
+		ret = ov5640_init(ov5640);
+		if (ret < 0) {
+			dev_err(ov5640->dev, "could not set init registers\n");
+			return ret;
+		}
+		ret = ov5640_change_mode(ov5640, ov5640->current_mode);
+		if (ret < 0) {
+			dev_err(ov5640->dev, "could not set mode %d\n", ov5640->current_mode);
+			return ret;
+		}
+		ret = v4l2_ctrl_handler_setup(&ov5640->ctrls);
+		if (ret < 0) {
+			dev_err(ov5640->dev, "could not sync v4l2 controls\n");
+			return ret;
+		}
+		ret = ov5640_restore_controls(ov5640);
+		if (ret < 0) {
+			dev_err(ov5640->dev, "could not restore v4l2 controls\n");
+			return ret;
+		}
+		ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_01, OV5640_PAD_ENABLE_ALL);
+		ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_02, OV5640_PAD_ENABLE_ALL);
+	} else {
+		ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_01, OV5640_PAD_DISABLE_ALL);
+		ov5640_write_reg(ov5640, OV5640_PAD_OUTPUT_ENABLE_02, OV5640_PAD_DISABLE_ALL);
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops ov5640_core_ops = {
+	.s_power = ov5640_s_power,
+};
+
+static struct v4l2_subdev_video_ops ov5640_video_ops = {
+	.s_stream       = ov5640_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops ov5640_subdev_pad_ops = {
+	.enum_mbus_code = ov5640_enum_mbus_code,
+	.enum_frame_size = ov5640_enum_frame_size,
+	.get_fmt = ov5640_get_format,
+	.set_fmt = ov5640_set_format,
+	.get_selection = ov5640_get_selection,
+};
+
+static struct v4l2_subdev_ops ov5640_subdev_ops = {
+	.core = &ov5640_core_ops,
+	.video = &ov5640_video_ops,
+	.pad = &ov5640_subdev_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops ov5640_subdev_internal_ops = {
+	.registered = ov5640_registered,
+	.open = ov5640_open,
+	.close = ov5640_close,
+};
+
+static int ov5640_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct device_node *endpoint;
+	struct ov5640 *ov5640;
+	int ret = 0;
+
+	ov5640 = devm_kzalloc(dev, sizeof(struct ov5640), GFP_KERNEL);
+	if (!ov5640)
+		return -ENOMEM;
+
+	ov5640->i2c_client = client;
+	ov5640->dev = dev;
+	ov5640->fmt.code = MEDIA_BUS_FMT_YUYV8_2X8;
+	ov5640->fmt.width = 640;
+	ov5640->fmt.height = 480;
+	ov5640->fmt.field = V4L2_FIELD_NONE;
+
+	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!endpoint) {
+		dev_err(dev, "endpoint node not found\n");
+		return -EINVAL;
+	}
+
+	v4l2_of_parse_endpoint(endpoint, &ov5640->ep);
+	if (ov5640->ep.bus_type != V4L2_MBUS_PARALLEL) {
+		dev_err(dev, "invalid bus type, must be parallel\n");
+		of_node_put(endpoint);
+		return -EINVAL;
+	}
+	of_node_put(endpoint);
+
+	/* get system clock (xclk) frequency */
+	ret = of_property_read_u32(dev->of_node, "clock-rates",
+				   &ov5640->xclk_freq);
+	if (!ret) {
+		if (ov5640->xclk_freq < OV5640_XCLK_MIN ||
+		    ov5640->xclk_freq > OV5640_XCLK_MAX) {
+			dev_err(dev, "invalid xclk frequency: %d\n",
+				ov5640->xclk_freq);
+			return -EINVAL;
+		}
+	}
+
+	/* get system clock (xclk) */
+	ov5640->xclk = devm_clk_get(dev, "xclk");
+	if (IS_ERR(ov5640->xclk)) {
+		dev_err(dev, "could not get xclk");
+		return -EINVAL;
+	}
+	clk_set_rate(ov5640->xclk, ov5640->xclk_freq);
+
+	ov5640_regulators_get(ov5640);
+
+	ret = of_get_named_gpio(dev->of_node, "reset-gpio", 0);
+	if (!gpio_is_valid(ret)) {
+		dev_warn(dev, "no reset pin available\n");
+		ov5640->rst_gpio = 0;
+	} else {
+		ov5640->rst_gpio = ret;
+	}
+
+	if (ov5640->rst_gpio) {
+		ret = devm_gpio_request_one(dev, ov5640->rst_gpio,
+			GPIOF_OUT_INIT_LOW, "ov5640-reset");
+		if (ret < 0) {
+			dev_err(dev, "could not request reset gpio\n");
+			return ret;
+		}
+	}
+
+	ret = of_get_named_gpio(dev->of_node, "pwdn-gpio", 0);
+	if (!gpio_is_valid(ret)) {
+		dev_warn(dev, "no powerdown pin available\n");
+		ov5640->pwdn_gpio = 0;
+	} else {
+		ov5640->pwdn_gpio = ret;
+	}
+
+	if (ov5640->pwdn_gpio) {
+		ret = devm_gpio_request_one(dev, ov5640->pwdn_gpio,
+			 GPIOF_OUT_INIT_HIGH, "ov5640-pwdn");
+		if (ret < 0) {
+			dev_err(dev, "could not request powerdown gpio\n");
+			return ret;
+		}
+	}
+
+	mutex_init(&ov5640->power_lock);
+
+	v4l2_ctrl_handler_init(&ov5640->ctrls, 11);
+	ov5640->brightness = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, -4, 4, 1, 0);
+	ov5640->contrast = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_CONTRAST, -4, 4, 1, 0);
+	ov5640->saturation = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_SATURATION, -4, 4, 1, 0);
+	ov5640->hflip = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ov5640->vflip = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ov5640->autogain = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	ov5640->gain = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_GAIN, 0, 1023, 1, 1);
+	ov5640->autoexposure = v4l2_ctrl_new_std_menu(&ov5640->ctrls, &ov5640_ctrl_ops,
+			       V4L2_CID_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL,
+			       0, V4L2_EXPOSURE_AUTO);
+	ov5640->exposure = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_EXPOSURE, 13, 237, 1, 52);
+	ov5640->awb = v4l2_ctrl_new_std(&ov5640->ctrls, &ov5640_ctrl_ops,
+			  V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	ov5640->pattern = v4l2_ctrl_new_std_menu_items(&ov5640->ctrls, &ov5640_ctrl_ops,
+		V4L2_CID_TEST_PATTERN,
+		ARRAY_SIZE(ov5640_test_pattern_menu) - 1, 0, 0,
+		ov5640_test_pattern_menu);
+
+	ov5640->sd.ctrl_handler = &ov5640->ctrls;
+
+	if (ov5640->ctrls.error) {
+		dev_err(dev, "%s: control initializacion error %d\n",
+		       __func__, ov5640->ctrls.error);
+		ret = ov5640->ctrls.error;
+		goto free_ctrl;
+	}
+
+	v4l2_i2c_subdev_init(&ov5640->sd, client, &ov5640_subdev_ops);
+	ov5640->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ov5640->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ov5640->sd.internal_ops = &ov5640_subdev_internal_ops;
+
+	ret = media_entity_init(&ov5640->sd.entity, 1, &ov5640->pad, 0);
+	if (ret < 0) {
+		dev_err(dev, "could not register media entity\n");
+		goto free_ctrl;
+	}
+
+	ov5640->sd.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&ov5640->sd);
+	if (ret < 0) {
+		dev_err(dev, "could not register v4l2 device\n");
+		goto free_entity;
+	}
+
+	return 0;
+
+free_entity:
+	media_entity_cleanup(&ov5640->sd.entity);
+free_ctrl:
+	v4l2_ctrl_handler_free(&ov5640->ctrls);
+
+	return ret;
+}
+
+
+static int ov5640_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov5640 *ov5640 = to_ov5640(sd);
+
+	v4l2_async_unregister_subdev(&ov5640->sd);
+	media_entity_cleanup(&ov5640->sd.entity);
+	v4l2_ctrl_handler_free(&ov5640->ctrls);
+
+	return 0;
+}
+
+
+static const struct i2c_device_id ov5640_id[] = {
+	{ "ov5640", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, ov5640_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov5640_of_match[] = {
+	{ .compatible = "ovti,ov5640" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ov5640_of_match);
+#endif
+
+static struct i2c_driver ov5640_i2c_driver = {
+	.driver = {
+		.of_match_table = of_match_ptr(ov5640_of_match),
+		.name  = "ov5640",
+	},
+	.probe  = ov5640_probe,
+	.remove = ov5640_remove,
+	.id_table = ov5640_id,
+};
+
+module_i2c_driver(ov5640_i2c_driver);
+
+MODULE_DESCRIPTION("Omnivision OV5640 Camera Driver");
+MODULE_AUTHOR("Javier Martin <javiermartin@by.com.es>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

