Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:42453 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbcELO7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 10:59:50 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] media: Add a driver for the ov5645 camera sensor.
Date: Thu, 12 May 2016 17:59:15 +0300
Message-Id: <1463065155-26337-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov5645 sensor from Omnivision supports up to 2592x1944
and CSI2 interface.

The driver adds support for the following modes:
- 1280x960
- 1920x1080
- 2592x1944

Output format is packed 8bit UYVY.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5645.c                         | 1344 ++++++++++++++++++++
 4 files changed, 1410 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 drivers/media/i2c/ov5645.c

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
new file mode 100644
index 0000000..1d65fa8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
@@ -0,0 +1,54 @@
+* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
+
+The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor with
+an active array size of 2592H x 1944V. It is programmable through a serial SCCB
+interface.
+
+Required Properties:
+- compatible: value should be "ovti,ov5645"
+- clocks: reference to the xclk clock
+- clock-names: should be "xclk"
+- clock-rates: the xclk clock frequency
+
+Optional Properties:
+- reset-gpio: Chip reset GPIO
+- pwdn-gpio: Chip power down GPIO
+- DOVDD-supply: Chip IO regulator
+- DVDD-supply: Chip core regulator
+- AVDD-supply: Chip analog regulator
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
+		ov5645: ov5645@78 {
+			compatible = "ovti,ov5645";
+			reg = <0x78>;
+
+			pwdn-gpio = <&gpio1 6 GPIO_ACTIVE_LOW>;
+			reset-gpio = <&gpio5 20 GPIO_ACTIVE_LOW>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&camera_rear_default>;
+
+			clocks = <&clks 200>;
+			clock-names = "xclk";
+			clock-rates = <23880000>;
+
+			DOVDD-supply = <&camera_dovdd_1v8>;
+			AVDD-supply = <&camera_avdd_2v8>;
+			DVDD-supply = <&camera_dvdd_1v2>;
+
+			port {
+				ov5645_ep: endpoint {
+					clock-lanes = <1>;
+					data-lanes = <0 2>;
+					remote-endpoint = <&csi0_ep>;
+				};
+			};
+		};
+	};
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 521bbf1..aa17eba 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -490,6 +490,17 @@ config VIDEO_OV2659
 	  To compile this driver as a module, choose M here: the
 	  module will be called ov2659.
 
+config VIDEO_OV5645
+	tristate "OmniVision OV5645 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV5645 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov5645.
+
 config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 07db257..29003df 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
 obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
 obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
new file mode 100644
index 0000000..bae07e4
--- /dev/null
+++ b/drivers/media/i2c/ov5645.c
@@ -0,0 +1,1344 @@
+/*
+ * Driver for the OV5645 camera sensor.
+ *
+ * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2015 By Tech Design S.L. All Rights Reserved.
+ * Copyright (C) 2012-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * Based on:
+ * - the OV5645 driver from QC msm-3.10 kernel on codeaurora.org:
+ *   https://us.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/
+ *       media/platform/msm/camera_v2/sensor/ov5645.c?h=LA.BR.1.2.4_rb1.41
+ * - the OV5640 driver posted on linux-media:
+ *   https://www.mail-archive.com/linux-media%40vger.kernel.org/msg92671.html
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
+ */
+
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
+#define OV5645_VOLTAGE_ANALOG               2800000
+#define OV5645_VOLTAGE_DIGITAL_CORE         1500000
+#define OV5645_VOLTAGE_DIGITAL_IO           1800000
+
+#define OV5645_XCLK_MIN 6000000
+#define OV5645_XCLK_MAX 24000000
+
+#define OV5645_SYSTEM_CTRL0		0x3008
+#define		OV5645_SYSTEM_CTRL0_START	0x02
+#define		OV5645_SYSTEM_CTRL0_STOP	0x42
+#define OV5645_CHIP_ID_HIGH_REG		0x300A
+#define		OV5645_CHIP_ID_HIGH		0x56
+#define OV5645_CHIP_ID_LOW_REG		0x300B
+#define		OV5645_CHIP_ID_LOW		0x45
+#define OV5645_AWB_MANUAL_CONTROL	0x3406
+#define		OV5645_AWB_MANUAL_ENABLE	(1 << 0)
+#define OV5645_AEC_PK_MANUAL		0x3503
+#define		OV5645_AEC_MANUAL_ENABLE	(1 << 0)
+#define		OV5645_AGC_MANUAL_ENABLE	(1 << 1)
+#define OV5645_TIMING_TC_REG20		0x3820
+#define		OV5645_SENSOR_VFLIP		(1 << 1)
+#define		OV5645_ISP_VFLIP		(1 << 2)
+#define OV5645_TIMING_TC_REG21		0x3821
+#define		OV5645_SENSOR_MIRROR		(1 << 1)
+#define OV5645_PRE_ISP_TEST_SETTING_1	0x503d
+#define		OV5645_TEST_PATTERN_MASK	0x3
+#define		OV5645_SET_TEST_PATTERN(x)	((x) & OV5645_TEST_PATTERN_MASK)
+#define		OV5645_TEST_PATTERN_ENABLE	(1 << 7)
+#define OV5645_SDE_SAT_U		0x5583
+#define OV5645_SDE_SAT_V		0x5584
+
+enum ov5645_mode {
+	ov5645_mode_min = 0,
+	ov5645_mode_sxga_1280_960 = 0,
+	ov5645_mode_1080p_1920_1080 = 1,
+	ov5645_mode_full_2592_1944 = 2,
+	ov5645_mode_max = 2,
+};
+
+struct reg_value {
+	u16 reg;
+	u8 val;
+};
+
+struct ov5645_mode_info {
+	enum ov5645_mode mode;
+	u32 width;
+	u32 height;
+	struct reg_value *init_data_ptr;
+	u32 init_data_size;
+};
+
+struct ov5645 {
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
+	enum ov5645_mode current_mode;
+
+	/* Cached control values */
+	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *autogain;
+	struct v4l2_ctrl *autoexposure;
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
+static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ov5645, sd);
+}
+
+static struct reg_value ov5645_global_init_setting[] = {
+	{0x3103, 0x11,},
+	{0x3008, 0x82,},
+	{0x3008, 0x42,},
+	{0x3103, 0x03,},
+	{0x3503, 0x07,},
+	{0x3002, 0x1c,},
+	{0x3006, 0xc3,},
+	{0x300e, 0x45,},
+	{0x3017, 0x00,},
+	{0x3018, 0x00,},
+	{0x302e, 0x0b,},
+	{0x3037, 0x13,},
+	{0x3108, 0x01,},
+	{0x3611, 0x06,},
+	{0x3500, 0x00,},
+	{0x3501, 0x01,},
+	{0x3502, 0x00,},
+	{0x350a, 0x00,},
+	{0x350b, 0x3f,},
+	{0x3620, 0x33,},
+	{0x3621, 0xe0,},
+	{0x3622, 0x01,},
+	{0x3630, 0x2e,},
+	{0x3631, 0x00,},
+	{0x3632, 0x32,},
+	{0x3633, 0x52,},
+	{0x3634, 0x70,},
+	{0x3635, 0x13,},
+	{0x3636, 0x03,},
+	{0x3703, 0x5a,},
+	{0x3704, 0xa0,},
+	{0x3705, 0x1a,},
+	{0x3709, 0x12,},
+	{0x370b, 0x61,},
+	{0x370f, 0x10,},
+	{0x3715, 0x78,},
+	{0x3717, 0x01,},
+	{0x371b, 0x20,},
+	{0x3731, 0x12,},
+	{0x3901, 0x0a,},
+	{0x3905, 0x02,},
+	{0x3906, 0x10,},
+	{0x3719, 0x86,},
+	{0x3810, 0x00,},
+	{0x3811, 0x10,},
+	{0x3812, 0x00,},
+	{0x3821, 0x01,},
+	{0x3824, 0x01,},
+	{0x3826, 0x03,},
+	{0x3828, 0x08,},
+	{0x3a19, 0xf8,},
+	{0x3c01, 0x34,},
+	{0x3c04, 0x28,},
+	{0x3c05, 0x98,},
+	{0x3c07, 0x07,},
+	{0x3c09, 0xc2,},
+	{0x3c0a, 0x9c,},
+	{0x3c0b, 0x40,},
+	{0x3c01, 0x34,},
+	{0x4001, 0x02,},
+	{0x4514, 0x00,},
+	{0x4520, 0xb0,},
+	{0x460b, 0x37,},
+	{0x460c, 0x20,},
+	{0x4818, 0x01,},
+	{0x481d, 0xf0,},
+	{0x481f, 0x50,},
+	{0x4823, 0x70,},
+	{0x4831, 0x14,},
+	{0x5000, 0xa7,},
+	{0x5001, 0x83,},
+	{0x501d, 0x00,},
+	{0x501f, 0x00,},
+	{0x503d, 0x00,},
+	{0x505c, 0x30,},
+	{0x5181, 0x59,},
+	{0x5183, 0x00,},
+	{0x5191, 0xf0,},
+	{0x5192, 0x03,},
+	{0x5684, 0x10,},
+	{0x5685, 0xa0,},
+	{0x5686, 0x0c,},
+	{0x5687, 0x78,},
+	{0x5a00, 0x08,},
+	{0x5a21, 0x00,},
+	{0x5a24, 0x00,},
+	{0x3008, 0x02,},
+	{0x3503, 0x00,},
+	{0x5180, 0xff,},
+	{0x5181, 0xf2,},
+	{0x5182, 0x00,},
+	{0x5183, 0x14,},
+	{0x5184, 0x25,},
+	{0x5185, 0x24,},
+	{0x5186, 0x09,},
+	{0x5187, 0x09,},
+	{0x5188, 0x0a,},
+	{0x5189, 0x75,},
+	{0x518a, 0x52,},
+	{0x518b, 0xea,},
+	{0x518c, 0xa8,},
+	{0x518d, 0x42,},
+	{0x518e, 0x38,},
+	{0x518f, 0x56,},
+	{0x5190, 0x42,},
+	{0x5191, 0xf8,},
+	{0x5192, 0x04,},
+	{0x5193, 0x70,},
+	{0x5194, 0xf0,},
+	{0x5195, 0xf0,},
+	{0x5196, 0x03,},
+	{0x5197, 0x01,},
+	{0x5198, 0x04,},
+	{0x5199, 0x12,},
+	{0x519a, 0x04,},
+	{0x519b, 0x00,},
+	{0x519c, 0x06,},
+	{0x519d, 0x82,},
+	{0x519e, 0x38,},
+	{0x5381, 0x1e,},
+	{0x5382, 0x5b,},
+	{0x5383, 0x08,},
+	{0x5384, 0x0a,},
+	{0x5385, 0x7e,},
+	{0x5386, 0x88,},
+	{0x5387, 0x7c,},
+	{0x5388, 0x6c,},
+	{0x5389, 0x10,},
+	{0x538a, 0x01,},
+	{0x538b, 0x98,},
+	{0x5300, 0x08,},
+	{0x5301, 0x30,},
+	{0x5302, 0x10,},
+	{0x5303, 0x00,},
+	{0x5304, 0x08,},
+	{0x5305, 0x30,},
+	{0x5306, 0x08,},
+	{0x5307, 0x16,},
+	{0x5309, 0x08,},
+	{0x530a, 0x30,},
+	{0x530b, 0x04,},
+	{0x530c, 0x06,},
+	{0x5480, 0x01,},
+	{0x5481, 0x08,},
+	{0x5482, 0x14,},
+	{0x5483, 0x28,},
+	{0x5484, 0x51,},
+	{0x5485, 0x65,},
+	{0x5486, 0x71,},
+	{0x5487, 0x7d,},
+	{0x5488, 0x87,},
+	{0x5489, 0x91,},
+	{0x548a, 0x9a,},
+	{0x548b, 0xaa,},
+	{0x548c, 0xb8,},
+	{0x548d, 0xcd,},
+	{0x548e, 0xdd,},
+	{0x548f, 0xea,},
+	{0x5490, 0x1d,},
+	{0x5580, 0x02,},
+	{0x5583, 0x40,},
+	{0x5584, 0x10,},
+	{0x5589, 0x10,},
+	{0x558a, 0x00,},
+	{0x558b, 0xf8,},
+	{0x5800, 0x3f,},
+	{0x5801, 0x16,},
+	{0x5802, 0x0e,},
+	{0x5803, 0x0d,},
+	{0x5804, 0x17,},
+	{0x5805, 0x3f,},
+	{0x5806, 0x0b,},
+	{0x5807, 0x06,},
+	{0x5808, 0x04,},
+	{0x5809, 0x04,},
+	{0x580a, 0x06,},
+	{0x580b, 0x0b,},
+	{0x580c, 0x09,},
+	{0x580d, 0x03,},
+	{0x580e, 0x00,},
+	{0x580f, 0x00,},
+	{0x5810, 0x03,},
+	{0x5811, 0x08,},
+	{0x5812, 0x0a,},
+	{0x5813, 0x03,},
+	{0x5814, 0x00,},
+	{0x5815, 0x00,},
+	{0x5816, 0x04,},
+	{0x5817, 0x09,},
+	{0x5818, 0x0f,},
+	{0x5819, 0x08,},
+	{0x581a, 0x06,},
+	{0x581b, 0x06,},
+	{0x581c, 0x08,},
+	{0x581d, 0x0c,},
+	{0x581e, 0x3f,},
+	{0x581f, 0x1e,},
+	{0x5820, 0x12,},
+	{0x5821, 0x13,},
+	{0x5822, 0x21,},
+	{0x5823, 0x3f,},
+	{0x5824, 0x68,},
+	{0x5825, 0x28,},
+	{0x5826, 0x2c,},
+	{0x5827, 0x28,},
+	{0x5828, 0x08,},
+	{0x5829, 0x48,},
+	{0x582a, 0x64,},
+	{0x582b, 0x62,},
+	{0x582c, 0x64,},
+	{0x582d, 0x28,},
+	{0x582e, 0x46,},
+	{0x582f, 0x62,},
+	{0x5830, 0x60,},
+	{0x5831, 0x62,},
+	{0x5832, 0x26,},
+	{0x5833, 0x48,},
+	{0x5834, 0x66,},
+	{0x5835, 0x44,},
+	{0x5836, 0x64,},
+	{0x5837, 0x28,},
+	{0x5838, 0x66,},
+	{0x5839, 0x48,},
+	{0x583a, 0x2c,},
+	{0x583b, 0x28,},
+	{0x583c, 0x26,},
+	{0x583d, 0xae,},
+	{0x5025, 0x00,},
+	{0x3a0f, 0x30,},
+	{0x3a10, 0x28,},
+	{0x3a1b, 0x30,},
+	{0x3a1e, 0x26,},
+	{0x3a11, 0x60,},
+	{0x3a1f, 0x14,},
+	{0x0601, 0x02,},
+	{0x3008, 0x42,},
+	{0x3008, 0x02},
+};
+
+static struct reg_value ov5645_setting_sxga[] = {
+	{0x3612, 0xa9,},
+	{0x3614, 0x50,},
+	{0x3618, 0x00,},
+	{0x3034, 0x18,},
+	{0x3035, 0x21,},
+	{0x3036, 0x70,},
+	{0x3600, 0x09,},
+	{0x3601, 0x43,},
+	{0x3708, 0x66,},
+	{0x370c, 0xc3,},
+	{0x3800, 0x00,},
+	{0x3801, 0x00,},
+	{0x3802, 0x00,},
+	{0x3803, 0x06,},
+	{0x3804, 0x0a,},
+	{0x3805, 0x3f,},
+	{0x3806, 0x07,},
+	{0x3807, 0x9d,},
+	{0x3808, 0x05,},
+	{0x3809, 0x00,},
+	{0x380a, 0x03,},
+	{0x380b, 0xc0,},
+	{0x380c, 0x07,},
+	{0x380d, 0x68,},
+	{0x380e, 0x03,},
+	{0x380f, 0xd8,},
+	{0x3813, 0x06,},
+	{0x3814, 0x31,},
+	{0x3815, 0x31,},
+	{0x3820, 0x47,},
+	{0x3a02, 0x03,},
+	{0x3a03, 0xd8,},
+	{0x3a08, 0x01,},
+	{0x3a09, 0xf8,},
+	{0x3a0a, 0x01,},
+	{0x3a0b, 0xa4,},
+	{0x3a0e, 0x02,},
+	{0x3a0d, 0x02,},
+	{0x3a14, 0x03,},
+	{0x3a15, 0xd8,},
+	{0x3a18, 0x00,},
+	{0x4004, 0x02,},
+	{0x4005, 0x18,},
+	{0x4300, 0x32,},
+	{0x4202, 0x00,},
+};
+
+static struct reg_value ov5645_setting_1080P[] = {
+	{0x3612, 0xab,},
+	{0x3614, 0x50,},
+	{0x3618, 0x04,},
+	{0x3034, 0x18,},
+	{0x3035, 0x11,},
+	{0x3036, 0x54,},
+	{0x3600, 0x08,},
+	{0x3601, 0x33,},
+	{0x3708, 0x63,},
+	{0x370c, 0xc0,},
+	{0x3800, 0x01,},
+	{0x3801, 0x50,},
+	{0x3802, 0x01,},
+	{0x3803, 0xb2,},
+	{0x3804, 0x08,},
+	{0x3805, 0xef,},
+	{0x3806, 0x05,},
+	{0x3807, 0xf1,},
+	{0x3808, 0x07,},
+	{0x3809, 0x80,},
+	{0x380a, 0x04,},
+	{0x380b, 0x38,},
+	{0x380c, 0x09,},
+	{0x380d, 0xc4,},
+	{0x380e, 0x04,},
+	{0x380f, 0x60,},
+	{0x3813, 0x04,},
+	{0x3814, 0x11,},
+	{0x3815, 0x11,},
+	{0x3820, 0x47,},
+	{0x4514, 0x88,},
+	{0x3a02, 0x04,},
+	{0x3a03, 0x60,},
+	{0x3a08, 0x01,},
+	{0x3a09, 0x50,},
+	{0x3a0a, 0x01,},
+	{0x3a0b, 0x18,},
+	{0x3a0e, 0x03,},
+	{0x3a0d, 0x04,},
+	{0x3a14, 0x04,},
+	{0x3a15, 0x60,},
+	{0x3a18, 0x00,},
+	{0x4004, 0x06,},
+	{0x4005, 0x18,},
+	{0x4300, 0x32,},
+	{0x4202, 0x00,},
+	{0x4837, 0x0b,},
+};
+
+static struct reg_value ov5645_setting_full[] = {
+	{0x3612, 0xab,},
+	{0x3614, 0x50,},
+	{0x3618, 0x04,},
+	{0x3034, 0x18,},
+	{0x3035, 0x11,},
+	{0x3036, 0x54,},
+	{0x3600, 0x08,},
+	{0x3601, 0x33,},
+	{0x3708, 0x63,},
+	{0x370c, 0xc0,},
+	{0x3800, 0x00,},
+	{0x3801, 0x00,},
+	{0x3802, 0x00,},
+	{0x3803, 0x00,},
+	{0x3804, 0x0a,},
+	{0x3805, 0x3f,},
+	{0x3806, 0x07,},
+	{0x3807, 0x9f,},
+	{0x3808, 0x0a,},
+	{0x3809, 0x20,},
+	{0x380a, 0x07,},
+	{0x380b, 0x98,},
+	{0x380c, 0x0b,},
+	{0x380d, 0x1c,},
+	{0x380e, 0x07,},
+	{0x380f, 0xb0,},
+	{0x3813, 0x06,},
+	{0x3814, 0x11,},
+	{0x3815, 0x11,},
+	{0x3820, 0x47,},
+	{0x4514, 0x88,},
+	{0x3a02, 0x07,},
+	{0x3a03, 0xb0,},
+	{0x3a08, 0x01,},
+	{0x3a09, 0x27,},
+	{0x3a0a, 0x00,},
+	{0x3a0b, 0xf6,},
+	{0x3a0e, 0x06,},
+	{0x3a0d, 0x08,},
+	{0x3a14, 0x07,},
+	{0x3a15, 0xb0,},
+	{0x3a18, 0x01,},
+	{0x4004, 0x06,},
+	{0x4005, 0x18,},
+	{0x4300, 0x32,},
+	{0x4837, 0x0b,},
+	{0x4202, 0x00,},
+};
+
+static struct ov5645_mode_info ov5645_mode_info_data[ov5645_mode_max + 1] = {
+	{ov5645_mode_sxga_1280_960, 1280, 960,
+	 ov5645_setting_sxga,
+	 ARRAY_SIZE(ov5645_setting_sxga)},
+	{ov5645_mode_1080p_1920_1080, 1920, 1080,
+	 ov5645_setting_1080P,
+	 ARRAY_SIZE(ov5645_setting_1080P)},
+	{ov5645_mode_full_2592_1944, 2592, 1944,
+	 ov5645_setting_full,
+	 ARRAY_SIZE(ov5645_setting_full)},
+};
+
+static void ov5645_regulators_get(struct ov5645 *ov5645)
+{
+	ov5645->io_regulator = devm_regulator_get(ov5645->dev, "DOVDD");
+	if (IS_ERR(ov5645->io_regulator)) {
+		ov5645->io_regulator = NULL;
+		dev_dbg(ov5645->dev, "cannot get io voltage\n");
+	} else {
+		regulator_set_voltage(ov5645->io_regulator,
+				OV5645_VOLTAGE_DIGITAL_IO,
+				OV5645_VOLTAGE_DIGITAL_IO);
+	}
+
+	ov5645->core_regulator = devm_regulator_get(ov5645->dev, "DVDD");
+	if (IS_ERR(ov5645->core_regulator)) {
+		ov5645->core_regulator = NULL;
+		dev_dbg(ov5645->dev, "cannot get core voltage\n");
+	} else {
+		regulator_set_voltage(ov5645->core_regulator,
+				OV5645_VOLTAGE_DIGITAL_CORE,
+				OV5645_VOLTAGE_DIGITAL_CORE);
+	}
+
+	ov5645->analog_regulator = devm_regulator_get(ov5645->dev, "AVDD");
+	if (IS_ERR(ov5645->analog_regulator)) {
+		ov5645->analog_regulator = NULL;
+		dev_dbg(ov5645->dev, "cannot get analog voltage\n");
+	} else {
+		regulator_set_voltage(ov5645->analog_regulator,
+				OV5645_VOLTAGE_ANALOG,
+				OV5645_VOLTAGE_ANALOG);
+	}
+}
+
+static int ov5645_regulators_enable(struct ov5645 *ov5645)
+{
+	int ret = 0;
+
+	if (ov5645->io_regulator) {
+		ret = regulator_enable(ov5645->io_regulator);
+		if (ret < 0) {
+			dev_err(ov5645->dev, "set io voltage failed\n");
+			return ret;
+		}
+	}
+
+	if (ov5645->core_regulator) {
+		ret = regulator_enable(ov5645->core_regulator);
+		if (ret) {
+			dev_err(ov5645->dev, "set core voltage failed\n");
+			goto err_disable_io;
+		}
+	}
+
+	if (ov5645->analog_regulator) {
+		ret = regulator_enable(ov5645->analog_regulator);
+		if (ret) {
+			dev_err(ov5645->dev, "set analog voltage failed\n");
+			goto err_disable_core;
+		}
+	}
+
+	return 0;
+
+err_disable_core:
+	if (ov5645->core_regulator)
+		regulator_disable(ov5645->core_regulator);
+err_disable_io:
+	if (ov5645->io_regulator)
+		regulator_disable(ov5645->io_regulator);
+
+	return ret;
+}
+
+static void ov5645_regulators_disable(struct ov5645 *ov5645)
+{
+	if (ov5645->analog_regulator)
+		regulator_disable(ov5645->analog_regulator);
+	if (ov5645->core_regulator)
+		regulator_disable(ov5645->core_regulator);
+	if (ov5645->io_regulator)
+		regulator_disable(ov5645->io_regulator);
+}
+
+static s32 ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
+{
+	u8 regbuf[3] = {0};
+
+	regbuf[0] = reg >> 8;
+	regbuf[1] = reg & 0xff;
+	regbuf[2] = val;
+
+	if (i2c_master_send(ov5645->i2c_client, regbuf, 3) < 0) {
+		dev_err(ov5645->dev, "%s:write reg error:reg=%x,val=%x\n",
+			__func__, reg, val);
+		return -1;
+	}
+
+	return 0;
+}
+
+static s32 ov5645_read_reg(struct ov5645 *ov5645, u16 reg, u8 *val)
+{
+	u8 regbuf[2] = {0};
+	u8 tmpval = 0;
+
+	regbuf[0] = reg >> 8;
+	regbuf[1] = reg & 0xff;
+
+	if (i2c_master_send(ov5645->i2c_client, regbuf, 2) != 2) {
+		dev_err(ov5645->dev, "%s:write reg error:reg=%x\n",
+			__func__, reg);
+		return -1;
+	}
+
+	if (i2c_master_recv(ov5645->i2c_client, &tmpval, 1) != 1) {
+		dev_err(ov5645->dev, "%s:read reg error:reg=%x,val=%x\n",
+			__func__, reg, tmpval);
+		return -1;
+	}
+
+	*val = tmpval;
+
+	return tmpval;
+}
+
+static int ov5645_set_aec_mode(struct ov5645 *ov5645, u32 mode)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
+	if (mode == V4L2_EXPOSURE_AUTO) {
+		val |= OV5645_AEC_MANUAL_ENABLE;
+	} else { /* V4L2_EXPOSURE_MANUAL */
+		val &= ~OV5645_AEC_MANUAL_ENABLE;
+	}
+
+	dev_dbg(ov5645->dev, "%s: mode = %d\n", __func__, mode);
+
+	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);
+}
+
+static int ov5645_set_agc_mode(struct ov5645 *ov5645, u32 enable)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
+	if (!enable)
+		val |= OV5645_AGC_MANUAL_ENABLE;
+	else
+		val &= ~OV5645_AGC_MANUAL_ENABLE;
+
+	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
+
+	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);
+}
+
+static int ov5645_set_register_array(struct ov5645 *ov5645,
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
+		ret = ov5645_write_reg(ov5645, reg, val);
+		if (ret < 0)
+			goto err;
+	}
+err:
+	return ret;
+}
+
+static int ov5645_init(struct ov5645 *ov5645)
+{
+	struct reg_value *settings = NULL;
+	int num_settings = 0;
+	int ret;
+
+	settings = ov5645_global_init_setting;
+	num_settings = ARRAY_SIZE(ov5645_global_init_setting);
+	ret = ov5645_set_register_array(ov5645, settings, num_settings);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int ov5645_change_mode(struct ov5645 *ov5645, enum ov5645_mode mode)
+{
+	struct reg_value *settings = NULL;
+	s32 num_settings = 0;
+	int ret = 0;
+
+	settings = ov5645_mode_info_data[mode].init_data_ptr;
+	num_settings = ov5645_mode_info_data[mode].init_data_size;
+	ret = ov5645_set_register_array(ov5645, settings, num_settings);
+
+	return ret;
+}
+
+static void __ov5645_set_power(struct ov5645 *ov5645, bool on)
+{
+	dev_dbg(ov5645->dev, "%s: on = %d\n", __func__, on);
+
+	if (on) {
+		clk_prepare_enable(ov5645->xclk);
+		ov5645_regulators_enable(ov5645);
+		usleep_range(5000, 15000);
+		if (ov5645->pwdn_gpio)
+			gpio_set_value(ov5645->pwdn_gpio, 1);
+		usleep_range(1000, 2000);
+		if (ov5645->rst_gpio)
+			gpio_set_value(ov5645->rst_gpio, 1);
+		msleep(20);
+	} else {
+		if (ov5645->rst_gpio)
+			gpio_set_value(ov5645->rst_gpio, 0);
+		if (ov5645->pwdn_gpio)
+			gpio_set_value(ov5645->pwdn_gpio, 0);
+		ov5645_regulators_disable(ov5645);
+		clk_disable_unprepare(ov5645->xclk);
+	}
+}
+
+static int ov5645_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov5645 *ov5645 = to_ov5645(sd);
+	int ret = 0;
+
+	dev_dbg(ov5645->dev, "%s: on = %d\n", __func__, on);
+
+	mutex_lock(&ov5645->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (ov5645->power_count == !on)
+		__ov5645_set_power(ov5645, !!on);
+
+	if (on && ov5645->power_count == 0) {
+		ret = ov5645_init(ov5645);
+		if (ret < 0) {
+			dev_err(ov5645->dev, "could not set init registers\n");
+			goto exit;
+		}
+
+		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
+				 OV5645_SYSTEM_CTRL0_STOP);
+	}
+
+	/* Update the power count. */
+	ov5645->power_count += on ? 1 : -1;
+	WARN_ON(ov5645->power_count < 0);
+
+exit:
+	mutex_unlock(&ov5645->power_lock);
+
+	return ret;
+}
+
+
+static int ov5645_set_saturation(struct ov5645 *ov5645, s32 value)
+{
+	u32 reg_value = (value * 0x10) + 0x40;
+	int ret = 0;
+
+	ret |= ov5645_write_reg(ov5645, OV5645_SDE_SAT_U, reg_value);
+	ret |= ov5645_write_reg(ov5645, OV5645_SDE_SAT_V, reg_value);
+
+	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
+
+	return ret;
+}
+
+static int ov5645_set_hflip(struct ov5645 *ov5645, s32 value)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG21, &val);
+	if (value == 0)
+		val &= ~(OV5645_SENSOR_MIRROR);
+	else
+		val |= (OV5645_SENSOR_MIRROR);
+
+	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG21, val);
+}
+
+static int ov5645_set_vflip(struct ov5645 *ov5645, s32 value)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG20, &val);
+	if (value == 0)
+		val |= (OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
+	else
+		val &= ~(OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
+
+	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG20, val);
+}
+
+static int ov5645_set_test_pattern(struct ov5645 *ov5645, s32 value)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, &val);
+
+	if (value) {
+		val &= ~OV5645_SET_TEST_PATTERN(OV5645_TEST_PATTERN_MASK);
+		val |= OV5645_SET_TEST_PATTERN(value - 1);
+		val |= OV5645_TEST_PATTERN_ENABLE;
+	} else {
+		val &= ~OV5645_TEST_PATTERN_ENABLE;
+	}
+
+	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
+
+	return ov5645_write_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, val);
+}
+
+static const char * const ov5645_test_pattern_menu[] = {
+	"Disabled",
+	"Vertical Color Bars",
+	"Random Data",
+	"Color Square",
+	"Black Image",
+};
+
+static int ov5645_set_awb(struct ov5645 *ov5645, s32 enable_auto)
+{
+	u8 val;
+
+	ov5645_read_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, &val);
+	if (enable_auto)
+		val &= ~OV5645_AWB_MANUAL_ENABLE;
+	else
+		val |= OV5645_AWB_MANUAL_ENABLE;
+
+	dev_dbg(ov5645->dev, "%s: enable_auto = %d\n", __func__, enable_auto);
+
+	return ov5645_write_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, val);
+}
+
+static int ov5645_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov5645 *ov5645 = container_of(ctrl->handler,
+					     struct ov5645, ctrls);
+	int ret = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_SATURATION:
+		ret = ov5645_set_saturation(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = ov5645_set_awb(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_AUTOGAIN:
+		ret = ov5645_set_agc_mode(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = ov5645_set_aec_mode(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		ret = ov5645_set_test_pattern(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		ret = ov5645_set_hflip(ov5645, ctrl->val);
+		break;
+	case V4L2_CID_VFLIP:
+		ret = ov5645_set_vflip(ov5645, ctrl->val);
+		break;
+	}
+
+	return ret;
+}
+
+static struct v4l2_ctrl_ops ov5645_ctrl_ops = {
+	.s_ctrl = ov5645_s_ctrl,
+};
+
+static int ov5645_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct ov5645 *ov5645 = to_ov5645(sd);
+
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = ov5645->fmt.code;
+
+	return 0;
+}
+
+static int ov5645_enum_frame_size(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->index >= ov5645_mode_max)
+		return -EINVAL;
+
+	fse->min_width = ov5645_mode_info_data[fse->index].width;
+	fse->max_width = ov5645_mode_info_data[fse->index].width;
+	fse->min_height = ov5645_mode_info_data[fse->index].height;
+	fse->max_height = ov5645_mode_info_data[fse->index].height;
+
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *
+__ov5645_get_pad_format(struct ov5645 *ov5645,
+			struct v4l2_subdev_pad_config *cfg,
+			unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(&ov5645->sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &ov5645->fmt;
+	default:
+		return NULL;
+	}
+}
+
+static int ov5645_get_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *format)
+{
+	struct ov5645 *ov5645 = to_ov5645(sd);
+
+	format->format = *__ov5645_get_pad_format(ov5645, cfg, format->pad,
+						  format->which);
+	return 0;
+}
+
+static struct v4l2_rect *
+__ov5645_get_pad_crop(struct ov5645 *ov5645, struct v4l2_subdev_pad_config *cfg,
+		      unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(&ov5645->sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &ov5645->crop;
+	default:
+		return NULL;
+	}
+}
+
+static enum ov5645_mode ov5645_find_nearest_mode(struct ov5645 *ov5645,
+						 int width, int height)
+{
+	int i;
+
+	for (i = ov5645_mode_max; i >= 0; i--) {
+		if (ov5645_mode_info_data[i].width <= width &&
+		    ov5645_mode_info_data[i].height <= height)
+			break;
+	}
+
+	if (i < 0)
+		i = 0;
+
+	return (enum ov5645_mode)i;
+}
+
+static int ov5645_set_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *format)
+{
+	struct ov5645 *ov5645 = to_ov5645(sd);
+	struct v4l2_mbus_framefmt *__format;
+	struct v4l2_rect *__crop;
+	enum ov5645_mode new_mode;
+
+	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
+			format->which);
+
+	new_mode = ov5645_find_nearest_mode(ov5645,
+			format->format.width, format->format.height);
+	__crop->width = ov5645_mode_info_data[new_mode].width;
+	__crop->height = ov5645_mode_info_data[new_mode].height;
+
+	ov5645->current_mode = new_mode;
+
+	__format = __ov5645_get_pad_format(ov5645, cfg, format->pad,
+			format->which);
+	__format->width = __crop->width;
+	__format->height = __crop->height;
+
+	return 0;
+}
+
+static int ov5645_get_selection(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_selection *sel)
+{
+	struct ov5645 *ov5645 = to_ov5645(sd);
+
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sel->r = *__ov5645_get_pad_crop(ov5645, cfg, sel->pad,
+					    sel->which);
+	return 0;
+}
+
+static int ov5645_registered(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct ov5645 *ov5645 = to_ov5645(subdev);
+	u8 chip_id_high, chip_id_low;
+	int ret;
+
+	ov5645_s_power(&ov5645->sd, true);
+
+	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_HIGH_REG, &chip_id_high);
+	if (ret < 0 || chip_id_high != OV5645_CHIP_ID_HIGH) {
+		dev_err(ov5645->dev, "could not read ID high\n");
+		ret = -ENODEV;
+		goto reg_power_off;
+	}
+	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_LOW_REG, &chip_id_low);
+	if (ret < 0 || chip_id_low != OV5645_CHIP_ID_LOW) {
+		dev_err(ov5645->dev, "could not read ID low\n");
+		ret = -ENODEV;
+		goto reg_power_off;
+	}
+
+	dev_info(&client->dev, "OV5645 detected at address 0x%02x\n",
+		 client->addr);
+
+	ov5645_s_power(&ov5645->sd, false);
+
+	return 0;
+
+reg_power_off:
+	ov5645_s_power(&ov5645->sd, false);
+	return ret;
+}
+
+static int ov5645_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return ov5645_s_power(subdev, true);
+}
+
+static int ov5645_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return ov5645_s_power(subdev, false);
+}
+
+static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct ov5645 *ov5645 = to_ov5645(subdev);
+	int ret;
+
+	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
+
+	if (enable) {
+		ret = ov5645_change_mode(ov5645, ov5645->current_mode);
+		if (ret < 0) {
+			dev_err(ov5645->dev, "could not set mode %d\n",
+				ov5645->current_mode);
+			return ret;
+		}
+		ret = v4l2_ctrl_handler_setup(&ov5645->ctrls);
+		if (ret < 0) {
+			dev_err(ov5645->dev, "could not sync v4l2 controls\n");
+			return ret;
+		}
+		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
+				 OV5645_SYSTEM_CTRL0_START);
+	} else {
+		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
+				 OV5645_SYSTEM_CTRL0_STOP);
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops ov5645_core_ops = {
+	.s_power = ov5645_s_power,
+};
+
+static struct v4l2_subdev_video_ops ov5645_video_ops = {
+	.s_stream = ov5645_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
+	.enum_mbus_code = ov5645_enum_mbus_code,
+	.enum_frame_size = ov5645_enum_frame_size,
+	.get_fmt = ov5645_get_format,
+	.set_fmt = ov5645_set_format,
+	.get_selection = ov5645_get_selection,
+};
+
+static struct v4l2_subdev_ops ov5645_subdev_ops = {
+	.core = &ov5645_core_ops,
+	.video = &ov5645_video_ops,
+	.pad = &ov5645_subdev_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops ov5645_subdev_internal_ops = {
+	.registered = ov5645_registered,
+	.open = ov5645_open,
+	.close = ov5645_close,
+};
+
+static int ov5645_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct device_node *endpoint;
+	struct ov5645 *ov5645;
+	int ret = 0;
+
+	ov5645 = devm_kzalloc(dev, sizeof(struct ov5645), GFP_KERNEL);
+	if (!ov5645)
+		return -ENOMEM;
+
+	ov5645->i2c_client = client;
+	ov5645->dev = dev;
+	ov5645->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
+	ov5645->fmt.width = 1920;
+	ov5645->fmt.height = 1080;
+	ov5645->fmt.field = V4L2_FIELD_NONE;
+	ov5645->current_mode = ov5645_mode_1080p_1920_1080;
+
+	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!endpoint) {
+		dev_err(dev, "endpoint node not found\n");
+		return -EINVAL;
+	}
+
+	v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
+	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(dev, "invalid bus type, must be CSI2\n");
+		of_node_put(endpoint);
+		return -EINVAL;
+	}
+	of_node_put(endpoint);
+
+	/* get system clock (xclk) frequency */
+	ret = of_property_read_u32(dev->of_node, "clock-rates",
+				   &ov5645->xclk_freq);
+	if (!ret) {
+		if (ov5645->xclk_freq < OV5645_XCLK_MIN ||
+		    ov5645->xclk_freq > OV5645_XCLK_MAX) {
+			dev_err(dev, "invalid xclk frequency: %d\n",
+				ov5645->xclk_freq);
+			return -EINVAL;
+		}
+	}
+
+	/* get system clock (xclk) */
+	ov5645->xclk = devm_clk_get(dev, "xclk");
+	if (IS_ERR(ov5645->xclk)) {
+		dev_err(dev, "could not get xclk");
+		return -EINVAL;
+	}
+	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);
+
+	ov5645_regulators_get(ov5645);
+
+	ret = of_get_named_gpio(dev->of_node, "reset-gpio", 0);
+	if (!gpio_is_valid(ret)) {
+		dev_dbg(dev, "no reset pin available\n");
+		ov5645->rst_gpio = 0;
+	} else {
+		ov5645->rst_gpio = ret;
+	}
+
+	if (ov5645->rst_gpio) {
+		ret = devm_gpio_request_one(dev, ov5645->rst_gpio,
+			GPIOF_OUT_INIT_LOW, "ov5645-reset");
+		if (ret < 0) {
+			dev_err(dev, "could not request reset gpio\n");
+			return ret;
+		}
+	}
+
+	ret = of_get_named_gpio(dev->of_node, "pwdn-gpio", 0);
+	if (!gpio_is_valid(ret)) {
+		dev_dbg(dev, "no powerdown pin available\n");
+		ov5645->pwdn_gpio = 0;
+	} else {
+		ov5645->pwdn_gpio = ret;
+	}
+
+	if (ov5645->pwdn_gpio) {
+		ret = devm_gpio_request_one(dev, ov5645->pwdn_gpio,
+			 GPIOF_OUT_INIT_LOW, "ov5645-pwdn");
+		if (ret < 0) {
+			dev_err(dev, "could not request powerdown gpio\n");
+			return ret;
+		}
+	}
+
+	mutex_init(&ov5645->power_lock);
+
+	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
+	ov5645->saturation = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
+				V4L2_CID_SATURATION, -4, 4, 1, 0);
+	ov5645->hflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
+				V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ov5645->vflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
+				V4L2_CID_VFLIP, 0, 1, 1, 0);
+	ov5645->autogain = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
+				V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	ov5645->autoexposure = v4l2_ctrl_new_std_menu(&ov5645->ctrls,
+				&ov5645_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
+				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
+	ov5645->awb = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
+				V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	ov5645->pattern = v4l2_ctrl_new_std_menu_items(&ov5645->ctrls,
+				&ov5645_ctrl_ops, V4L2_CID_TEST_PATTERN,
+				ARRAY_SIZE(ov5645_test_pattern_menu) - 1, 0, 0,
+				ov5645_test_pattern_menu);
+
+	ov5645->sd.ctrl_handler = &ov5645->ctrls;
+
+	if (ov5645->ctrls.error) {
+		dev_err(dev, "%s: control initialization error %d\n",
+		       __func__, ov5645->ctrls.error);
+		ret = ov5645->ctrls.error;
+		goto free_ctrl;
+	}
+
+	v4l2_i2c_subdev_init(&ov5645->sd, client, &ov5645_subdev_ops);
+	ov5645->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ov5645->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ov5645->sd.internal_ops = &ov5645_subdev_internal_ops;
+
+	ret = media_entity_init(&ov5645->sd.entity, 1, &ov5645->pad, 0);
+	if (ret < 0) {
+		dev_err(dev, "could not register media entity\n");
+		goto free_ctrl;
+	}
+
+	ov5645->sd.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&ov5645->sd);
+	if (ret < 0) {
+		dev_err(dev, "could not register v4l2 device\n");
+		goto free_entity;
+	}
+
+	return 0;
+
+free_entity:
+	media_entity_cleanup(&ov5645->sd.entity);
+free_ctrl:
+	v4l2_ctrl_handler_free(&ov5645->ctrls);
+
+	return ret;
+}
+
+
+static int ov5645_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov5645 *ov5645 = to_ov5645(sd);
+
+	v4l2_async_unregister_subdev(&ov5645->sd);
+	media_entity_cleanup(&ov5645->sd.entity);
+	v4l2_ctrl_handler_free(&ov5645->ctrls);
+
+	return 0;
+}
+
+
+static const struct i2c_device_id ov5645_id[] = {
+	{ "ov5645", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, ov5645_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov5645_of_match[] = {
+	{ .compatible = "ovti,ov5645" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ov5645_of_match);
+#endif
+
+static struct i2c_driver ov5645_i2c_driver = {
+	.driver = {
+		.of_match_table = of_match_ptr(ov5645_of_match),
+		.name  = "ov5645",
+	},
+	.probe  = ov5645_probe,
+	.remove = ov5645_remove,
+	.id_table = ov5645_id,
+};
+
+module_i2c_driver(ov5645_i2c_driver);
+
+MODULE_DESCRIPTION("Omnivision OV5645 Camera Driver");
+MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

