Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33141 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753523AbdBPCVE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:04 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 24/36] [media] add Omnivision OV5640 sensor driver
Date: Wed, 15 Feb 2017 18:19:26 -0800
Message-Id: <1487211578-11360-25-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is based on ov5640_mipi.c from Freescale imx_3.10.17_1.0.0_beta
branch, modified heavily to bring forward to latest interfaces and code
cleanup.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 .../devicetree/bindings/media/i2c/ov5640.txt       |   43 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5640.c                         | 2109 ++++++++++++++++++++
 4 files changed, 2160 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
 create mode 100644 drivers/media/i2c/ov5640.c

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
new file mode 100644
index 0000000..4607bbe
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -0,0 +1,43 @@
+* Omnivision OV5640 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: should be "ovti,ov5640"
+- clocks: reference to the xclk input clock.
+- clock-names: should be "xclk".
+- DOVDD-supply: Digital I/O voltage supply, 1.8 volts
+- AVDD-supply: Analog voltage supply, 2.8 volts
+- DVDD-supply: Digital core voltage supply, 1.5 volts
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the reset pin, if any.
+- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+&i2c1 {
+	ov5640: camera@3c {
+		compatible = "ovti,ov5640";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		reg = <0x3c>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen3_reg>;  /* 2.8v */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v */
+		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
+
+		port {
+			ov5640_to_mipi_csi2: endpoint {
+				remote-endpoint = <&mipi_csi2_from_ov5640>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+			};
+		};
+	};
+};
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index cee1dae..bf67661 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -531,6 +531,13 @@ config VIDEO_OV2659
 	  To compile this driver as a module, choose M here: the
 	  module will be called ov2659.
 
+config VIDEO_OV5640
+	tristate "OmniVision OV5640 sensor support"
+	depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a V4L2 sensor-level driver for the Omnivision
+	  OV5640 camera sensor with a MIPI CSI-2 interface.
+
 config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 5bc7bbe..3a9d73a 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
 obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
 obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
new file mode 100644
index 0000000..b3535af
--- /dev/null
+++ b/drivers/media/i2c/ov5640.c
@@ -0,0 +1,2109 @@
+/*
+ * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright (C) 2014-2017 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/gpio/consumer.h>
+#include <linux/regulator/consumer.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+
+/* min/typical/max system clock (xclk) frequencies */
+#define OV5640_XCLK_MIN  6000000
+#define OV5640_XCLK_MAX 24000000
+
+/*
+ * FIXME: there is no subdev API to set the MIPI CSI-2
+ * virtual channel yet, so this is hardcoded for now.
+ */
+#define OV5640_MIPI_VC	1
+
+#define OV5640_DEFAULT_SLAVE_ID 0x3c
+
+#define OV5640_REG_CHIP_ID		0x300a
+#define OV5640_REG_PAD_OUTPUT00		0x3019
+#define OV5640_REG_SC_PLL_CTRL0		0x3034
+#define OV5640_REG_SC_PLL_CTRL1		0x3035
+#define OV5640_REG_SC_PLL_CTRL2		0x3036
+#define OV5640_REG_SC_PLL_CTRL3		0x3037
+#define OV5640_REG_SLAVE_ID		0x3100
+#define OV5640_REG_SYS_ROOT_DIVIDER	0x3108
+#define OV5640_REG_AWB_R_GAIN		0x3400
+#define OV5640_REG_AWB_G_GAIN		0x3402
+#define OV5640_REG_AWB_B_GAIN		0x3404
+#define OV5640_REG_AWB_MANUAL_CTRL	0x3406
+#define OV5640_REG_AEC_PK_EXPOSURE_HI	0x3500
+#define OV5640_REG_AEC_PK_EXPOSURE_MED	0x3501
+#define OV5640_REG_AEC_PK_EXPOSURE_LO	0x3502
+#define OV5640_REG_AEC_PK_MANUAL	0x3503
+#define OV5640_REG_AEC_PK_REAL_GAIN	0x350a
+#define OV5640_REG_AEC_PK_VTS		0x350c
+#define OV5640_REG_TIMING_HTS		0x380c
+#define OV5640_REG_TIMING_VTS		0x380e
+#define OV5640_REG_TIMING_TC_REG21	0x3821
+#define OV5640_REG_AEC_CTRL00		0x3a00
+#define OV5640_REG_AEC_B50_STEP		0x3a08
+#define OV5640_REG_AEC_B60_STEP		0x3a0a
+#define OV5640_REG_AEC_CTRL0D		0x3a0d
+#define OV5640_REG_AEC_CTRL0E		0x3a0e
+#define OV5640_REG_AEC_CTRL0F		0x3a0f
+#define OV5640_REG_AEC_CTRL10		0x3a10
+#define OV5640_REG_AEC_CTRL11		0x3a11
+#define OV5640_REG_AEC_CTRL1B		0x3a1b
+#define OV5640_REG_AEC_CTRL1E		0x3a1e
+#define OV5640_REG_AEC_CTRL1F		0x3a1f
+#define OV5640_REG_HZ5060_CTRL00	0x3c00
+#define OV5640_REG_HZ5060_CTRL01	0x3c01
+#define OV5640_REG_SIGMADELTA_CTRL0C	0x3c0c
+#define OV5640_REG_FRAME_CTRL01		0x4202
+#define OV5640_REG_MIPI_CTRL00		0x4800
+#define OV5640_REG_DEBUG_MODE		0x4814
+#define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
+#define OV5640_REG_SDE_CTRL0		0x5580
+#define OV5640_REG_SDE_CTRL1		0x5581
+#define OV5640_REG_SDE_CTRL3		0x5583
+#define OV5640_REG_SDE_CTRL4		0x5584
+#define OV5640_REG_SDE_CTRL5		0x5585
+#define OV5640_REG_AVG_READOUT		0x56a1
+
+enum ov5640_mode_id {
+	OV5640_MODE_QCIF_176_144 = 0,
+	OV5640_MODE_QVGA_320_240,
+	OV5640_MODE_VGA_640_480,
+	OV5640_MODE_NTSC_720_480,
+	OV5640_MODE_PAL_720_576,
+	OV5640_MODE_XGA_1024_768,
+	OV5640_MODE_720P_1280_720,
+	OV5640_MODE_1080P_1920_1080,
+	OV5640_MODE_QSXGA_2592_1944,
+	OV5640_NUM_MODES,
+};
+
+enum ov5640_frame_rate {
+	OV5640_15_FPS = 0,
+	OV5640_30_FPS,
+	OV5640_NUM_FRAMERATES,
+};
+
+static const int ov5640_framerates[] = {
+	[OV5640_15_FPS] = 15,
+	[OV5640_30_FPS] = 30,
+};
+
+/* regulator supplies */
+static const char * const ov5640_supply_name[] = {
+	"DOVDD", /* Digital I/O (1.8V) suppply */
+	"DVDD",  /* Digital Core (1.5V) supply */
+	"AVDD",  /* Analog (2.8V) supply */
+};
+
+#define OV5640_NUM_SUPPLIES ARRAY_SIZE(ov5640_supply_name)
+
+/*
+ * image size under 1280 * 960 are SUBSAMPLING
+ * image size upper 1280 * 960 are SCALING
+ */
+enum ov5640_downsize_mode {
+	SUBSAMPLING,
+	SCALING,
+};
+
+struct reg_value {
+	u16 reg_addr;
+	u8 val;
+	u8 mask;
+	u32 delay_ms;
+};
+
+struct ov5640_mode_info {
+	enum ov5640_mode_id id;
+	enum ov5640_downsize_mode dn_mode;
+	u32 width;
+	u32 height;
+	const struct reg_value *reg_data;
+	u32 reg_data_size;
+};
+
+struct ov5640_ctrls {
+	struct v4l2_ctrl_handler handler;
+	struct {
+		struct v4l2_ctrl *auto_exp;
+		struct v4l2_ctrl *exposure;
+	};
+	struct {
+		struct v4l2_ctrl *auto_wb;
+		struct v4l2_ctrl *blue_balance;
+		struct v4l2_ctrl *red_balance;
+	};
+	struct {
+		struct v4l2_ctrl *auto_gain;
+		struct v4l2_ctrl *gain;
+	};
+	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *contrast;
+	struct v4l2_ctrl *hue;
+	struct v4l2_ctrl *test_pattern;
+};
+
+struct ov5640_dev {
+	struct i2c_client *i2c_client;
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_of_endpoint ep; /* the parsed DT endpoint info */
+	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_captureparm streamcap;
+	struct clk *xclk; /* system clock to OV5640 */
+	u32 xclk_freq;
+
+	struct mutex power_lock; /* lock to protect power_count */
+	int power_count;
+
+	const struct ov5640_mode_info *current_mode;
+	enum ov5640_frame_rate current_fr;
+
+	struct ov5640_ctrls ctrls;
+
+	struct gpio_desc *reset_gpio;
+	struct gpio_desc *pwdn_gpio;
+
+	u32 prev_sysclk, prev_hts;
+	u32 ae_low, ae_high, ae_target;
+
+	struct regulator_bulk_data supplies[OV5640_NUM_SUPPLIES];
+};
+
+static inline struct ov5640_dev *to_ov5640_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ov5640_dev, sd);
+}
+
+static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct ov5640_dev,
+			     ctrls.handler)->sd;
+}
+
+/*
+ * FIXME: all of these register tables are likely filled with
+ * entries that set the register to their power-on default values,
+ * and which are otherwise not touched by this driver. Those entries
+ * should be identified and removed to speed register load time
+ * over i2c.
+ */
+
+static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
+
+	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
+	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
+	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
+	{0x3037, 0x13, 0, 0}, {0x3108, 0x01, 0, 0}, {0x3630, 0x36, 0, 0},
+	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
+	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
+	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
+	{0x3705, 0x1a, 0, 0}, {0x3905, 0x02, 0, 0}, {0x3906, 0x10, 0, 0},
+	{0x3901, 0x0a, 0, 0}, {0x3731, 0x12, 0, 0}, {0x3600, 0x08, 0, 0},
+	{0x3601, 0x33, 0, 0}, {0x302d, 0x60, 0, 0}, {0x3620, 0x52, 0, 0},
+	{0x371b, 0x20, 0, 0}, {0x471c, 0x50, 0, 0}, {0x3a13, 0x43, 0, 0},
+	{0x3a18, 0x00, 0, 0}, {0x3a19, 0xf8, 0, 0}, {0x3635, 0x13, 0, 0},
+	{0x3636, 0x03, 0, 0}, {0x3634, 0x40, 0, 0}, {0x3622, 0x01, 0, 0},
+	{0x3c01, 0xa4, 0, 0}, {0x3c04, 0x28, 0, 0}, {0x3c05, 0x98, 0, 0},
+	{0x3c06, 0x00, 0, 0}, {0x3c07, 0x08, 0, 0}, {0x3c08, 0x00, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
+	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
+	{0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
+	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
+	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x4837, 0x0a, 0, 0}, {0x4800, 0x04, 0, 0}, {0x3824, 0x02, 0, 0},
+	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
+	{0x5181, 0xf2, 0, 0}, {0x5182, 0x00, 0, 0}, {0x5183, 0x14, 0, 0},
+	{0x5184, 0x25, 0, 0}, {0x5185, 0x24, 0, 0}, {0x5186, 0x09, 0, 0},
+	{0x5187, 0x09, 0, 0}, {0x5188, 0x09, 0, 0}, {0x5189, 0x88, 0, 0},
+	{0x518a, 0x54, 0, 0}, {0x518b, 0xee, 0, 0}, {0x518c, 0xb2, 0, 0},
+	{0x518d, 0x50, 0, 0}, {0x518e, 0x34, 0, 0}, {0x518f, 0x6b, 0, 0},
+	{0x5190, 0x46, 0, 0}, {0x5191, 0xf8, 0, 0}, {0x5192, 0x04, 0, 0},
+	{0x5193, 0x70, 0, 0}, {0x5194, 0xf0, 0, 0}, {0x5195, 0xf0, 0, 0},
+	{0x5196, 0x03, 0, 0}, {0x5197, 0x01, 0, 0}, {0x5198, 0x04, 0, 0},
+	{0x5199, 0x6c, 0, 0}, {0x519a, 0x04, 0, 0}, {0x519b, 0x00, 0, 0},
+	{0x519c, 0x09, 0, 0}, {0x519d, 0x2b, 0, 0}, {0x519e, 0x38, 0, 0},
+	{0x5381, 0x1e, 0, 0}, {0x5382, 0x5b, 0, 0}, {0x5383, 0x08, 0, 0},
+	{0x5384, 0x0a, 0, 0}, {0x5385, 0x7e, 0, 0}, {0x5386, 0x88, 0, 0},
+	{0x5387, 0x7c, 0, 0}, {0x5388, 0x6c, 0, 0}, {0x5389, 0x10, 0, 0},
+	{0x538a, 0x01, 0, 0}, {0x538b, 0x98, 0, 0}, {0x5300, 0x08, 0, 0},
+	{0x5301, 0x30, 0, 0}, {0x5302, 0x10, 0, 0}, {0x5303, 0x00, 0, 0},
+	{0x5304, 0x08, 0, 0}, {0x5305, 0x30, 0, 0}, {0x5306, 0x08, 0, 0},
+	{0x5307, 0x16, 0, 0}, {0x5309, 0x08, 0, 0}, {0x530a, 0x30, 0, 0},
+	{0x530b, 0x04, 0, 0}, {0x530c, 0x06, 0, 0}, {0x5480, 0x01, 0, 0},
+	{0x5481, 0x08, 0, 0}, {0x5482, 0x14, 0, 0}, {0x5483, 0x28, 0, 0},
+	{0x5484, 0x51, 0, 0}, {0x5485, 0x65, 0, 0}, {0x5486, 0x71, 0, 0},
+	{0x5487, 0x7d, 0, 0}, {0x5488, 0x87, 0, 0}, {0x5489, 0x91, 0, 0},
+	{0x548a, 0x9a, 0, 0}, {0x548b, 0xaa, 0, 0}, {0x548c, 0xb8, 0, 0},
+	{0x548d, 0xcd, 0, 0}, {0x548e, 0xdd, 0, 0}, {0x548f, 0xea, 0, 0},
+	{0x5490, 0x1d, 0, 0}, {0x5580, 0x02, 0, 0}, {0x5583, 0x40, 0, 0},
+	{0x5584, 0x10, 0, 0}, {0x5589, 0x10, 0, 0}, {0x558a, 0x00, 0, 0},
+	{0x558b, 0xf8, 0, 0}, {0x5800, 0x23, 0, 0}, {0x5801, 0x14, 0, 0},
+	{0x5802, 0x0f, 0, 0}, {0x5803, 0x0f, 0, 0}, {0x5804, 0x12, 0, 0},
+	{0x5805, 0x26, 0, 0}, {0x5806, 0x0c, 0, 0}, {0x5807, 0x08, 0, 0},
+	{0x5808, 0x05, 0, 0}, {0x5809, 0x05, 0, 0}, {0x580a, 0x08, 0, 0},
+	{0x580b, 0x0d, 0, 0}, {0x580c, 0x08, 0, 0}, {0x580d, 0x03, 0, 0},
+	{0x580e, 0x00, 0, 0}, {0x580f, 0x00, 0, 0}, {0x5810, 0x03, 0, 0},
+	{0x5811, 0x09, 0, 0}, {0x5812, 0x07, 0, 0}, {0x5813, 0x03, 0, 0},
+	{0x5814, 0x00, 0, 0}, {0x5815, 0x01, 0, 0}, {0x5816, 0x03, 0, 0},
+	{0x5817, 0x08, 0, 0}, {0x5818, 0x0d, 0, 0}, {0x5819, 0x08, 0, 0},
+	{0x581a, 0x05, 0, 0}, {0x581b, 0x06, 0, 0}, {0x581c, 0x08, 0, 0},
+	{0x581d, 0x0e, 0, 0}, {0x581e, 0x29, 0, 0}, {0x581f, 0x17, 0, 0},
+	{0x5820, 0x11, 0, 0}, {0x5821, 0x11, 0, 0}, {0x5822, 0x15, 0, 0},
+	{0x5823, 0x28, 0, 0}, {0x5824, 0x46, 0, 0}, {0x5825, 0x26, 0, 0},
+	{0x5826, 0x08, 0, 0}, {0x5827, 0x26, 0, 0}, {0x5828, 0x64, 0, 0},
+	{0x5829, 0x26, 0, 0}, {0x582a, 0x24, 0, 0}, {0x582b, 0x22, 0, 0},
+	{0x582c, 0x24, 0, 0}, {0x582d, 0x24, 0, 0}, {0x582e, 0x06, 0, 0},
+	{0x582f, 0x22, 0, 0}, {0x5830, 0x40, 0, 0}, {0x5831, 0x42, 0, 0},
+	{0x5832, 0x24, 0, 0}, {0x5833, 0x26, 0, 0}, {0x5834, 0x24, 0, 0},
+	{0x5835, 0x22, 0, 0}, {0x5836, 0x22, 0, 0}, {0x5837, 0x26, 0, 0},
+	{0x5838, 0x44, 0, 0}, {0x5839, 0x24, 0, 0}, {0x583a, 0x26, 0, 0},
+	{0x583b, 0x28, 0, 0}, {0x583c, 0x42, 0, 0}, {0x583d, 0xce, 0, 0},
+	{0x5025, 0x00, 0, 0}, {0x3a0f, 0x30, 0, 0}, {0x3a10, 0x28, 0, 0},
+	{0x3a1b, 0x30, 0, 0}, {0x3a1e, 0x26, 0, 0}, {0x3a11, 0x60, 0, 0},
+	{0x3a1f, 0x14, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3c00, 0x04, 0, 300},
+};
+
+static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
+
+	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x04, 0, 0}, {0x380f, 0x38, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x0e, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
+
+	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x04, 0, 0}, {0x380f, 0x38, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x0e, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
+	{0x3808, 0x04, 0, 0}, {0x3809, 0x00, 0, 0}, {0x380a, 0x03, 0, 0},
+	{0x380b, 0x00, 0, 0}, {0x3035, 0x12, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3808, 0x04, 0, 0},
+	{0x3809, 0x00, 0, 0}, {0x380a, 0x03, 0, 0}, {0x380b, 0x00, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
+	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x01, 0, 0}, {0x3809, 0x40, 0, 0}, {0x380a, 0x00, 0, 0},
+	{0x380b, 0xf0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x01, 0, 0}, {0x3809, 0x40, 0, 0}, {0x380a, 0x00, 0, 0},
+	{0x380b, 0xf0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
+	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x00, 0, 0}, {0x3809, 0xb0, 0, 0}, {0x380a, 0x00, 0, 0},
+	{0x380b, 0x90, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x00, 0, 0}, {0x3809, 0xb0, 0, 0}, {0x380a, 0x00, 0, 0},
+	{0x380b, 0x90, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
+	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x3c, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x01, 0, 0},
+	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x3c, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
+	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x02, 0, 0},
+	{0x380b, 0x40, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x38, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
+	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
+	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x02, 0, 0},
+	{0x380b, 0x40, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
+	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x38, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
+	{0x3008, 0x42, 0, 0},
+	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0xfa, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x06, 0, 0}, {0x3807, 0xa9, 0, 0},
+	{0x3808, 0x05, 0, 0}, {0x3809, 0x00, 0, 0}, {0x380a, 0x02, 0, 0},
+	{0x380b, 0xd0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x64, 0, 0},
+	{0x380e, 0x02, 0, 0}, {0x380f, 0xe4, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x02, 0, 0},
+	{0x3a03, 0xe4, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0xbc, 0, 0},
+	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
+	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x02, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
+	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0}, {0x4005, 0x1a, 0, 0},
+	{0x3008, 0x02, 0, 0}, {0x3503, 0,    0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
+	{0x3035, 0x41, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
+	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0xfa, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x06, 0, 0}, {0x3807, 0xa9, 0, 0},
+	{0x3808, 0x05, 0, 0}, {0x3809, 0x00, 0, 0}, {0x380a, 0x02, 0, 0},
+	{0x380b, 0xd0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x64, 0, 0},
+	{0x380e, 0x02, 0, 0}, {0x380f, 0xe4, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
+	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x02, 0, 0},
+	{0x3a03, 0xe4, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0xbc, 0, 0},
+	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
+	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x02, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
+	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
+	{0x3008, 0x42, 0, 0},
+	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
+	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
+	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
+	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
+	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
+	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
+	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, 0},
+	{0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
+	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
+	{0x3806, 0x05, 0, 0}, {0x3807, 0xf1, 0, 0}, {0x3808, 0x07, 0, 0},
+	{0x3809, 0x80, 0, 0}, {0x380a, 0x04, 0, 0}, {0x380b, 0x38, 0, 0},
+	{0x380c, 0x09, 0, 0}, {0x380d, 0xc4, 0, 0}, {0x380e, 0x04, 0, 0},
+	{0x380f, 0x60, 0, 0}, {0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
+	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
+	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
+	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
+	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
+	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0},
+	{0x3503, 0, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
+	{0x3008, 0x42, 0, 0},
+	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
+	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
+	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
+	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
+	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
+	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
+	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x21, 0, 0},
+	{0x3036, 0x54, 0, 1}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
+	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
+	{0x3806, 0x05, 0, 0}, {0x3807, 0xf1, 0, 0}, {0x3808, 0x07, 0, 0},
+	{0x3809, 0x80, 0, 0}, {0x380a, 0x04, 0, 0}, {0x380b, 0x38, 0, 0},
+	{0x380c, 0x09, 0, 0}, {0x380d, 0xc4, 0, 0}, {0x380e, 0x04, 0, 0},
+	{0x380f, 0x60, 0, 0}, {0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
+	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
+	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
+	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
+	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
+	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3503, 0, 0, 0},
+};
+
+static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
+	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0},
+	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
+	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
+	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
+	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
+	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
+	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
+	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
+	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
+	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
+	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
+	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
+	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
+	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 70},
+};
+
+/* power-on sensor init reg table */
+static const struct ov5640_mode_info ov5640_mode_init_data = {
+	0, SUBSAMPLING, 640, 480, ov5640_init_setting_30fps_VGA,
+	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
+};
+
+static const struct ov5640_mode_info
+ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
+	{
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
+		 ov5640_setting_15fps_QCIF_176_144,
+		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
+		 ov5640_setting_15fps_QVGA_320_240,
+		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
+		 ov5640_setting_15fps_VGA_640_480,
+		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
+		 ov5640_setting_15fps_NTSC_720_480,
+		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
+		 ov5640_setting_15fps_PAL_720_576,
+		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
+		 ov5640_setting_15fps_XGA_1024_768,
+		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
+		 ov5640_setting_15fps_720P_1280_720,
+		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
+		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
+		 ov5640_setting_15fps_1080P_1920_1080,
+		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
+		{OV5640_MODE_QSXGA_2592_1944, SCALING, 2592, 1944,
+		 ov5640_setting_15fps_QSXGA_2592_1944,
+		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
+	}, {
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
+		 ov5640_setting_30fps_QCIF_176_144,
+		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
+		 ov5640_setting_30fps_QVGA_320_240,
+		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
+		 ov5640_setting_30fps_VGA_640_480,
+		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
+		 ov5640_setting_30fps_NTSC_720_480,
+		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
+		 ov5640_setting_30fps_PAL_720_576,
+		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
+		 ov5640_setting_30fps_XGA_1024_768,
+		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
+		 ov5640_setting_30fps_720P_1280_720,
+		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
+		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
+		 ov5640_setting_30fps_1080P_1920_1080,
+		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, NULL, 0},
+	},
+};
+
+static int ov5640_init_slave_id(struct ov5640_dev *sensor)
+{
+	struct i2c_client *client = sensor->i2c_client;
+	struct i2c_msg msg;
+	u8 buf[3];
+	int ret;
+
+	if (client->addr == OV5640_DEFAULT_SLAVE_ID)
+		return 0;
+
+	buf[0] = OV5640_REG_SLAVE_ID >> 8;
+	buf[1] = OV5640_REG_SLAVE_ID & 0xff;
+	buf[2] = client->addr << 1;
+
+	msg.addr = OV5640_DEFAULT_SLAVE_ID;
+	msg.flags = 0;
+	msg.buf = buf;
+	msg.len = sizeof(buf);
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: failed with %d\n", __func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ov5640_write_reg(struct ov5640_dev *sensor, u16 reg, u8 val)
+{
+	struct i2c_client *client = sensor->i2c_client;
+	struct i2c_msg msg;
+	u8 buf[3];
+	int ret;
+
+	buf[0] = reg >> 8;
+	buf[1] = reg & 0xff;
+	buf[2] = val;
+
+	msg.addr = client->addr;
+	msg.flags = client->flags;
+	msg.buf = buf;
+	msg.len = sizeof(buf);
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0) {
+		v4l2_err(&sensor->sd, "%s: error: reg=%x, val=%x\n",
+			__func__, reg, val);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ov5640_read_reg(struct ov5640_dev *sensor, u16 reg, u8 *val)
+{
+	struct i2c_client *client = sensor->i2c_client;
+	struct i2c_msg msg[2];
+	u8 buf[2];
+	int ret;
+
+	buf[0] = reg >> 8;
+	buf[1] = reg & 0xff;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = client->flags;
+	msg[0].buf = buf;
+	msg[0].len = sizeof(buf);
+
+	msg[1].addr = client->addr;
+	msg[1].flags = client->flags | I2C_M_RD;
+	msg[1].buf = buf;
+	msg[1].len = 1;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0)
+		return ret;
+
+	*val = buf[0];
+	return 0;
+}
+
+static int ov5640_read_reg16(struct ov5640_dev *sensor, u16 reg, u16 *val)
+{
+	u8 hi, lo;
+
+	ov5640_read_reg(sensor, reg, &hi);
+	ov5640_read_reg(sensor, reg+1, &lo);
+
+	*val = ((u16)hi << 8) | (u16)lo;
+	return 0;
+}
+
+static int ov5640_write_reg16(struct ov5640_dev *sensor, u16 reg, u16 val)
+{
+	ov5640_write_reg(sensor, reg, val >> 8);
+	ov5640_write_reg(sensor, reg + 1, val & 0xff);
+	return 0;
+}
+
+static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
+			  u8 mask, u8 val)
+{
+	u8 readval;
+
+	ov5640_read_reg(sensor, reg, &readval);
+
+	readval &= ~mask;
+	val &= mask;
+	val |= readval;
+
+	ov5640_write_reg(sensor, reg, val);
+	return 0;
+}
+
+/* download ov5640 settings to sensor through i2c */
+static int ov5640_load_regs(struct ov5640_dev *sensor,
+			    const struct ov5640_mode_info *mode)
+{
+	const struct reg_value *regs = mode->reg_data;
+	unsigned int i;
+	u32 delay_ms;
+	u16 reg_addr;
+	u8 mask, val;
+
+	for (i = 0; i < mode->reg_data_size; ++i, ++regs) {
+		delay_ms = regs->delay_ms;
+		reg_addr = regs->reg_addr;
+		val = regs->val;
+		mask = regs->mask;
+
+		if (mask)
+			ov5640_mod_reg(sensor, reg_addr, mask, val);
+		else
+			ov5640_write_reg(sensor, reg_addr, val);
+		if (delay_ms)
+			usleep_range(1000*delay_ms, 1000*delay_ms+100);
+	}
+
+	return 0;
+}
+
+static int ov5640_set_hue(struct ov5640_dev *sensor, int value)
+{
+	if (value) {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(0), BIT(0));
+		ov5640_write_reg16(sensor, OV5640_REG_SDE_CTRL1, value);
+	} else {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(0), 0);
+	}
+
+	return 0;
+}
+
+static int ov5640_set_contrast(struct ov5640_dev *sensor, int value)
+{
+	if (value) {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(2), BIT(2));
+		ov5640_write_reg(sensor, OV5640_REG_SDE_CTRL5, value & 0xff);
+	} else {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(2), 0);
+	}
+
+	return 0;
+}
+
+static int ov5640_set_saturation(struct ov5640_dev *sensor, int value)
+{
+	if (value) {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(1), BIT(1));
+		ov5640_write_reg(sensor, OV5640_REG_SDE_CTRL3, value & 0xff);
+		ov5640_write_reg(sensor, OV5640_REG_SDE_CTRL4, value & 0xff);
+	} else {
+		ov5640_mod_reg(sensor, OV5640_REG_SDE_CTRL0, BIT(1), 0);
+	}
+
+	return 0;
+}
+
+static int ov5640_set_white_balance(struct ov5640_dev *sensor, int awb)
+{
+	ov5640_mod_reg(sensor, OV5640_REG_AWB_MANUAL_CTRL,
+		       BIT(0), awb ? 0 : 1);
+
+	if (!awb) {
+		u16 red = (u16)sensor->ctrls.red_balance->val;
+		u16 blue = (u16)sensor->ctrls.blue_balance->val;
+
+		ov5640_write_reg16(sensor, OV5640_REG_AWB_R_GAIN, red);
+		ov5640_write_reg16(sensor, OV5640_REG_AWB_B_GAIN, blue);
+	}
+
+	return 0;
+}
+
+static int ov5640_set_exposure(struct ov5640_dev *sensor, int exp)
+{
+	struct ov5640_ctrls *ctrls = &sensor->ctrls;
+	bool auto_exposure = (exp == V4L2_EXPOSURE_AUTO);
+
+	if (ctrls->auto_exp->is_new) {
+		ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
+			       BIT(0), auto_exposure ? 0 : BIT(0));
+	}
+
+	if (!auto_exposure && ctrls->exposure->is_new) {
+		u16 max_exp;
+
+		ov5640_read_reg16(sensor, OV5640_REG_AEC_PK_VTS, &max_exp);
+		if (ctrls->exposure->val < max_exp) {
+			u32 exposure = ctrls->exposure->val << 4;
+
+			ov5640_write_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_LO,
+					 exposure & 0xff);
+			ov5640_write_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_MED,
+					 (exposure >> 8) & 0xff);
+			ov5640_write_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_HI,
+					 (exposure >> 16) & 0x0f);
+		}
+	}
+
+	return 0;
+}
+
+/* read exposure, in number of line periods */
+static int ov5640_get_exposure(struct ov5640_dev *sensor)
+{
+	u8 temp;
+	int exp;
+
+	ov5640_read_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_HI, &temp);
+	exp = ((int)temp & 0x0f) << 16;
+	ov5640_read_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_MED, &temp);
+	exp |= ((int)temp << 8);
+	ov5640_read_reg(sensor, OV5640_REG_AEC_PK_EXPOSURE_LO, &temp);
+	exp |= (int)temp;
+
+	return exp >> 4;
+}
+
+static int ov5640_set_gain(struct ov5640_dev *sensor, int auto_gain)
+{
+	struct ov5640_ctrls *ctrls = &sensor->ctrls;
+
+	if (ctrls->auto_gain->is_new) {
+		ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
+			       BIT(1), ctrls->auto_gain->val ? 0 : BIT(1));
+	}
+
+	if (!auto_gain && ctrls->gain->is_new) {
+		u16 gain = (u16)ctrls->gain->val;
+
+		ov5640_write_reg16(sensor, OV5640_REG_AEC_PK_REAL_GAIN,
+				   gain & 0x3ff);
+	}
+
+	return 0;
+}
+
+static int ov5640_get_gain(struct ov5640_dev *sensor)
+{
+	u16 gain;
+
+	ov5640_read_reg16(sensor, OV5640_REG_AEC_PK_REAL_GAIN, &gain);
+
+	return gain & 0x3ff;
+}
+
+static int ov5640_set_agc_aec(struct ov5640_dev *sensor, bool on)
+{
+	ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
+		       0x3, on ? 0 : 0x3);
+	return 0;
+}
+
+static int ov5640_set_test_pattern(struct ov5640_dev *sensor, int value)
+{
+	ov5640_mod_reg(sensor, OV5640_REG_PRE_ISP_TEST_SET1,
+		       0xa4, value ? 0xa4 : 0);
+	return 0;
+}
+
+static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
+{
+	ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
+		       on ? 0 : BIT(5));
+	ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
+			 on ? 0x00 : 0x70);
+	ov5640_write_reg(sensor, OV5640_REG_FRAME_CTRL01,
+			 on ? 0x00 : 0x0f);
+	return 0;
+}
+
+static int ov5640_get_sysclk(struct ov5640_dev *sensor)
+{
+	 /* calculate sysclk */
+	u32 xvclk = sensor->xclk_freq / 10000;
+	u32 multiplier, prediv, VCO, sysdiv, pll_rdiv;
+	u32 sclk_rdiv_map[] = {1, 2, 4, 8};
+	u32 bit_div2x = 1, sclk_rdiv, sysclk;
+	u8 temp1, temp2;
+
+	ov5640_read_reg(sensor, OV5640_REG_SC_PLL_CTRL0, &temp1);
+	temp2 = temp1 & 0x0f;
+	if (temp2 == 8 || temp2 == 10)
+		bit_div2x = temp2 / 2;
+
+	ov5640_read_reg(sensor, OV5640_REG_SC_PLL_CTRL1, &temp1);
+	sysdiv = temp1 >> 4;
+	if (sysdiv == 0)
+		sysdiv = 16;
+
+	ov5640_read_reg(sensor, OV5640_REG_SC_PLL_CTRL2, &temp1);
+	multiplier = temp1;
+
+	ov5640_read_reg(sensor, OV5640_REG_SC_PLL_CTRL3, &temp1);
+	prediv = temp1 & 0x0f;
+	pll_rdiv = ((temp1 >> 4) & 0x01) + 1;
+
+	ov5640_read_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, &temp1);
+	temp2 = temp1 & 0x03;
+	sclk_rdiv = sclk_rdiv_map[temp2];
+
+	VCO = xvclk * multiplier / prediv;
+
+	sysclk = VCO / sysdiv / pll_rdiv * 2 / bit_div2x / sclk_rdiv;
+
+	return sysclk;
+}
+
+static int ov5640_set_night_mode(struct ov5640_dev *sensor)
+{
+	 /* read HTS from register settings */
+	u8 mode;
+
+	ov5640_read_reg(sensor, OV5640_REG_AEC_CTRL00, &mode);
+	mode &= 0xfb;
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL00, mode);
+	return 0;
+}
+
+static int ov5640_get_hts(struct ov5640_dev *sensor)
+{
+	/* read HTS from register settings */
+	u16 hts;
+
+	ov5640_read_reg16(sensor, OV5640_REG_TIMING_HTS, &hts);
+	return hts;
+}
+
+static int ov5640_get_vts(struct ov5640_dev *sensor)
+{
+	u16 vts;
+
+	ov5640_read_reg16(sensor, OV5640_REG_TIMING_VTS, &vts);
+	return vts;
+}
+
+static int ov5640_set_vts(struct ov5640_dev *sensor, int vts)
+{
+	ov5640_write_reg16(sensor, OV5640_REG_TIMING_VTS, vts);
+	return 0;
+}
+
+static int ov5640_get_light_freq(struct ov5640_dev *sensor)
+{
+	/* get banding filter value */
+	u8 temp, temp1;
+	int light_freq = 0;
+
+	ov5640_read_reg(sensor, OV5640_REG_HZ5060_CTRL01, &temp);
+
+	if (temp & 0x80) {
+		/* manual */
+		ov5640_read_reg(sensor, OV5640_REG_HZ5060_CTRL00, &temp1);
+		if (temp1 & 0x04) {
+			/* 50Hz */
+			light_freq = 50;
+		} else {
+			/* 60Hz */
+			light_freq = 60;
+		}
+	} else {
+		/* auto */
+		ov5640_read_reg(sensor, OV5640_REG_SIGMADELTA_CTRL0C,
+				&temp1);
+		if (temp1 & 0x01) {
+			/* 50Hz */
+			light_freq = 50;
+		} else {
+			/* 60Hz */
+		}
+	}
+
+	return light_freq;
+}
+
+static int ov5640_set_bandingfilter(struct ov5640_dev *sensor)
+{
+	u32 band_step60, max_band60, band_step50, max_band50, prev_vts;
+	int ret;
+
+	/* read preview PCLK */
+	ret = ov5640_get_sysclk(sensor);
+	if (ret < 0)
+		return ret;
+	sensor->prev_sysclk = ret;
+	/* read preview HTS */
+	ret = ov5640_get_hts(sensor);
+	if (ret < 0)
+		return ret;
+	sensor->prev_hts = ret;
+
+	/* read preview VTS */
+	ret = ov5640_get_vts(sensor);
+	if (ret < 0)
+		return ret;
+	prev_vts = ret;
+
+	/* calculate banding filter */
+	/* 60Hz */
+	band_step60 = sensor->prev_sysclk * 100 / sensor->prev_hts * 100/120;
+	ov5640_write_reg16(sensor, OV5640_REG_AEC_B60_STEP, band_step60);
+
+	max_band60 = (int)((prev_vts-4)/band_step60);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL0D, max_band60);
+
+	/* 50Hz */
+	band_step50 = sensor->prev_sysclk * 100 / sensor->prev_hts;
+	ov5640_write_reg16(sensor, OV5640_REG_AEC_B50_STEP, band_step50);
+
+	max_band50 = (int)((prev_vts-4)/band_step50);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL0E, max_band50);
+
+	return 0;
+}
+
+static int ov5640_set_ae_target(struct ov5640_dev *sensor, int target)
+{
+	/* stable in high */
+	u32 fast_high, fast_low;
+
+	sensor->ae_low = target * 23 / 25;	/* 0.92 */
+	sensor->ae_high = target * 27 / 25;	/* 1.08 */
+
+	fast_high = sensor->ae_high << 1;
+	if (fast_high > 255)
+		fast_high = 255;
+
+	fast_low = sensor->ae_low >> 1;
+
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL0F, sensor->ae_high);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL10, sensor->ae_low);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1B, sensor->ae_high);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1E, sensor->ae_low);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL11, fast_high);
+	ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1F, fast_low);
+
+	return 0;
+}
+
+static int ov5640_binning_on(struct ov5640_dev *sensor)
+{
+	u8 temp;
+
+	ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
+	temp &= 0xfe;
+
+	return temp ? 1 : 0;
+}
+
+static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
+{
+	u8 temp, channel = OV5640_MIPI_VC;
+
+	ov5640_read_reg(sensor, OV5640_REG_DEBUG_MODE, &temp);
+	temp &= ~(3 << 6);
+	temp |= (channel << 6);
+	ov5640_write_reg(sensor, OV5640_REG_DEBUG_MODE, temp);
+
+	return 0;
+}
+
+static const struct ov5640_mode_info *
+ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
+		 int width, int height, bool nearest)
+{
+	const struct ov5640_mode_info *mode = NULL;
+	int i;
+
+	for (i = OV5640_NUM_MODES - 1; i >= 0; i--) {
+		mode = &ov5640_mode_data[fr][i];
+
+		if (!mode->reg_data)
+			continue;
+
+		if ((nearest && mode->width <= width &&
+		     mode->height <= height) ||
+		    (!nearest && mode->width == width &&
+		     mode->height == height))
+			break;
+	}
+
+	if (nearest && i < 0)
+		mode = &ov5640_mode_data[fr][0];
+
+	return mode;
+}
+
+/*
+ * sensor changes between scaling and subsampling, go through
+ * exposure calculation
+ */
+static int ov5640_change_mode_exposure_calc(
+	struct ov5640_dev *sensor, const struct ov5640_mode_info *mode)
+{
+	u32 prev_shutter, prev_gain16;
+	u32 cap_shutter, cap_gain16;
+	u32 cap_sysclk, cap_hts, cap_vts;
+	u32 light_freq, cap_bandfilt, cap_maxband;
+	u32 cap_gain16_shutter;
+	u8 average;
+	int ret;
+
+	if (mode->reg_data == NULL)
+		return -EINVAL;
+
+	/* turn off AE/AG */
+	ret = ov5640_set_agc_aec(sensor, false);
+	if (ret < 0)
+		return ret;
+
+	/* read preview shutter */
+	ret = ov5640_get_exposure(sensor);
+	if (ret < 0)
+		return ret;
+	prev_shutter = ret;
+	ret = ov5640_binning_on(sensor);
+	if (ret < 0)
+		return ret;
+	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&
+	    mode->id != OV5640_MODE_1080P_1920_1080)
+		prev_shutter *= 2;
+
+	/* read preview gain */
+	ret = ov5640_get_gain(sensor);
+	if (ret < 0)
+		return ret;
+	prev_gain16 = ret;
+
+	/* get average */
+	ov5640_read_reg(sensor, OV5640_REG_AVG_READOUT, &average);
+
+	/* turn off night mode for capture */
+	ret = ov5640_set_night_mode(sensor);
+	if (ret < 0)
+		return ret;
+
+	/* Write capture setting */
+	ret = ov5640_load_regs(sensor, mode);
+	if (ret < 0)
+		return ret;
+
+	/* read capture VTS */
+	ret = ov5640_get_vts(sensor);
+	if (ret < 0)
+		return ret;
+	cap_vts = ret;
+	ret = ov5640_get_hts(sensor);
+	if (ret < 0)
+		return ret;
+	cap_hts = ret;
+	ret = ov5640_get_sysclk(sensor);
+	if (ret < 0)
+		return ret;
+	cap_sysclk = ret;
+
+	/* calculate capture banding filter */
+	ret = ov5640_get_light_freq(sensor);
+	if (ret < 0)
+		return ret;
+	light_freq = ret;
+
+	if (light_freq == 60) {
+		/* 60Hz */
+		cap_bandfilt = cap_sysclk * 100 / cap_hts * 100 / 120;
+	} else {
+		/* 50Hz */
+		cap_bandfilt = cap_sysclk * 100 / cap_hts;
+	}
+	cap_maxband = (int)((cap_vts - 4) / cap_bandfilt);
+
+	/* calculate capture shutter/gain16 */
+	if (average > sensor->ae_low && average < sensor->ae_high) {
+		/* in stable range */
+		cap_gain16_shutter =
+			prev_gain16 * prev_shutter *
+			cap_sysclk / sensor->prev_sysclk *
+			sensor->prev_hts / cap_hts *
+			sensor->ae_target / average;
+	} else {
+		cap_gain16_shutter =
+			prev_gain16 * prev_shutter *
+			cap_sysclk / sensor->prev_sysclk *
+			sensor->prev_hts / cap_hts;
+	}
+
+	/* gain to shutter */
+	if (cap_gain16_shutter < (cap_bandfilt * 16)) {
+		/* shutter < 1/100 */
+		cap_shutter = cap_gain16_shutter / 16;
+		if (cap_shutter < 1)
+			cap_shutter = 1;
+
+		cap_gain16 = cap_gain16_shutter / cap_shutter;
+		if (cap_gain16 < 16)
+			cap_gain16 = 16;
+	} else {
+		if (cap_gain16_shutter > (cap_bandfilt * cap_maxband * 16)) {
+			/* exposure reach max */
+			cap_shutter = cap_bandfilt * cap_maxband;
+			cap_gain16 = cap_gain16_shutter / cap_shutter;
+		} else {
+			/* 1/100 < (cap_shutter = n/100) =< max */
+			cap_shutter =
+				((int)(cap_gain16_shutter / 16 / cap_bandfilt))
+				* cap_bandfilt;
+			cap_gain16 = cap_gain16_shutter / cap_shutter;
+		}
+	}
+
+	/* write capture gain */
+	ret = ov5640_set_gain(sensor, cap_gain16);
+	if (ret < 0)
+		return ret;
+
+	/* write capture shutter */
+	if (cap_shutter > (cap_vts - 4)) {
+		cap_vts = cap_shutter + 4;
+		ret = ov5640_set_vts(sensor, cap_vts);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ov5640_set_exposure(sensor, cap_shutter);
+}
+
+/*
+ * if sensor changes inside scaling or subsampling
+ * change mode directly
+ */
+static int ov5640_change_mode_direct(struct ov5640_dev *sensor,
+				     const struct ov5640_mode_info *mode)
+{
+	int ret;
+
+	if (mode->reg_data == NULL)
+		return -EINVAL;
+
+	/* turn off AE/AG */
+	ret = ov5640_set_agc_aec(sensor, false);
+	if (ret < 0)
+		return ret;
+
+	/* Write capture setting */
+	ret = ov5640_load_regs(sensor, mode);
+	if (ret < 0)
+		return ret;
+
+	return ov5640_set_agc_aec(sensor, true);
+}
+
+static int ov5640_change_mode(struct ov5640_dev *sensor,
+			      enum ov5640_frame_rate frame_rate,
+			      const struct ov5640_mode_info *mode,
+			      const struct ov5640_mode_info *orig_mode)
+{
+	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
+	int ret;
+
+	dn_mode = mode->dn_mode;
+	orig_dn_mode = orig_mode->dn_mode;
+
+	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
+	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
+		/*
+		 * change between subsampling and scaling
+		 * go through exposure calucation
+		 */
+		ret = ov5640_change_mode_exposure_calc(sensor, mode);
+	} else {
+		/*
+		 * change inside subsampling or scaling
+		 * download firmware directly
+		 */
+		ret = ov5640_change_mode_direct(sensor, mode);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	ret = ov5640_set_ae_target(sensor, sensor->ae_target);
+	if (ret < 0)
+		return ret;
+	ret = ov5640_get_light_freq(sensor);
+	if (ret < 0)
+		return ret;
+	ret = ov5640_set_bandingfilter(sensor);
+	if (ret < 0)
+		return ret;
+	ret = ov5640_set_virtual_channel(sensor);
+	if (ret < 0)
+		return ret;
+
+	/* restore controls */
+	v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
+
+	sensor->current_mode = mode;
+	sensor->current_fr = frame_rate;
+
+	return 0;
+}
+
+/* restore the last set video mode after chip power-on */
+static int ov5640_restore_mode(struct ov5640_dev *sensor)
+{
+	int ret;
+
+	/* first load the initial register values */
+	ret = ov5640_load_regs(sensor, &ov5640_mode_init_data);
+	if (ret < 0)
+		return ret;
+
+	/* now restore the last capture mode */
+	return ov5640_change_mode(sensor, sensor->current_fr,
+				  sensor->current_mode,
+				  &ov5640_mode_init_data);
+}
+
+static void ov5640_power(struct ov5640_dev *sensor, bool enable)
+{
+	if (sensor->pwdn_gpio)
+		gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
+}
+
+static void ov5640_reset(struct ov5640_dev *sensor)
+{
+	if (!sensor->reset_gpio)
+		return;
+
+	gpiod_set_value(sensor->reset_gpio, 0);
+
+	/* camera power cycle */
+	ov5640_power(sensor, false);
+	usleep_range(5000, 10000);
+	ov5640_power(sensor, true);
+	usleep_range(5000, 10000);
+
+	gpiod_set_value(sensor->reset_gpio, 1);
+	usleep_range(1000, 2000);
+
+	gpiod_set_value(sensor->reset_gpio, 0);
+	usleep_range(5000, 10000);
+}
+
+static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
+{
+	int ret;
+
+	if (on) {
+		clk_prepare_enable(sensor->xclk);
+
+		ret = regulator_bulk_enable(OV5640_NUM_SUPPLIES,
+					    sensor->supplies);
+		if (ret)
+			return ret;
+
+		ov5640_reset(sensor);
+		ov5640_power(sensor, true);
+
+		ret = ov5640_init_slave_id(sensor);
+		if (ret)
+			return ret;
+
+		ret = ov5640_restore_mode(sensor);
+		if (ret)
+			return ret;
+
+		/*
+		 * start streaming briefly followed by stream off in
+		 * order to coax the clock lane into LP-11 state.
+		 */
+		ov5640_set_stream(sensor, true);
+		usleep_range(1000, 2000);
+		ov5640_set_stream(sensor, false);
+	} else {
+		ov5640_power(sensor, false);
+
+		regulator_bulk_disable(OV5640_NUM_SUPPLIES,
+				       sensor->supplies);
+
+		clk_disable_unprepare(sensor->xclk);
+	}
+
+	return 0;
+}
+
+/* --------------- Subdev Operations --------------- */
+
+static int ov5640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	int ret = 0;
+
+	mutex_lock(&sensor->power_lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (sensor->power_count == !on) {
+		ret = ov5640_set_power(sensor, !!on);
+		if (ret)
+			goto out;
+	}
+
+	/* Update the power count. */
+	sensor->power_count += on ? 1 : -1;
+	WARN_ON(sensor->power_count < 0);
+out:
+	mutex_unlock(&sensor->power_lock);
+	return ret;
+}
+
+static int ov5640_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	struct v4l2_captureparm *cparm = &a->parm.capture;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	/* This is the only case currently handled. */
+	memset(a, 0, sizeof(*a));
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	cparm->capability = sensor->streamcap.capability;
+	cparm->timeperframe = sensor->streamcap.timeperframe;
+	cparm->capturemode = sensor->streamcap.capturemode;
+
+	return 0;
+}
+
+static int ov5640_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	struct v4l2_fract *tpf = &a->parm.capture.timeperframe;
+	enum ov5640_frame_rate frame_rate;
+	u32 tgt_fps; /* target frames per secound */
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	/* Check that the new frame rate is allowed. */
+	if (tpf->numerator == 0 || tpf->denominator == 0) {
+		tpf->denominator = ov5640_framerates[OV5640_30_FPS];
+		tpf->numerator = 1;
+	}
+
+	tgt_fps = DIV_ROUND_CLOSEST(tpf->denominator, tpf->numerator);
+
+	if (tgt_fps > ov5640_framerates[OV5640_30_FPS]) {
+		tpf->denominator = ov5640_framerates[OV5640_30_FPS];
+		tpf->numerator = 1;
+	} else if (tgt_fps < ov5640_framerates[OV5640_15_FPS]) {
+		tpf->denominator = ov5640_framerates[OV5640_15_FPS];
+		tpf->numerator = 1;
+	}
+
+	/* Actual frame rate we use */
+	tgt_fps = DIV_ROUND_CLOSEST(tpf->denominator, tpf->numerator);
+
+	if (tgt_fps == 15)
+		frame_rate = OV5640_15_FPS;
+	else if (tgt_fps == 30)
+		frame_rate = OV5640_30_FPS;
+	else
+		return -EINVAL;
+
+	ret = ov5640_change_mode(sensor, frame_rate,
+				 sensor->current_mode,
+				 sensor->current_mode);
+	if (ret < 0)
+		return ret;
+
+	sensor->streamcap.timeperframe = *tpf;
+
+	return 0;
+}
+
+static int ov5640_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	struct v4l2_mbus_framefmt *fmt;
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		fmt = v4l2_subdev_get_try_format(&sensor->sd, cfg,
+						 format->pad);
+	else
+		fmt = &sensor->fmt;
+
+	format->format = *fmt;
+
+	return 0;
+}
+
+static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
+				   struct v4l2_mbus_framefmt *fmt,
+				   enum ov5640_frame_rate fr,
+				   const struct ov5640_mode_info **new_mode)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	const struct ov5640_mode_info *mode;
+
+	mode = ov5640_find_mode(sensor, fr, fmt->width, fmt->height, true);
+	if (!mode)
+		return -EINVAL;
+
+	fmt->width = mode->width;
+	fmt->height = mode->height;
+	fmt->code = sensor->fmt.code;
+
+	if (new_mode)
+		*new_mode = mode;
+	return 0;
+}
+
+static int ov5640_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	const struct ov5640_mode_info *new_mode;
+	int ret;
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	ret = ov5640_try_fmt_internal(sd, &format->format,
+				      sensor->current_fr, &new_mode);
+	if (ret)
+		return ret;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *fmt =
+			v4l2_subdev_get_try_format(sd, cfg, 0);
+
+		*fmt = format->format;
+		return 0;
+	}
+
+	ret = ov5640_change_mode(sensor, sensor->current_fr,
+				 new_mode, sensor->current_mode);
+	if (ret < 0)
+		return ret;
+
+	sensor->fmt = format->format;
+	return 0;
+}
+
+
+/*
+ * Sensor Controls.
+ */
+
+static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		if (!ctrl->val)
+			return 0;
+		sensor->ctrls.gain->val = ov5640_get_gain(sensor);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
+			return 0;
+		sensor->ctrls.exposure->val = ov5640_get_exposure(sensor);
+		break;
+	}
+
+	return 0;
+}
+
+static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	int ret = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		ret = ov5640_set_gain(sensor, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = ov5640_set_exposure(sensor, ctrl->val);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = ov5640_set_white_balance(sensor, ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		ret = ov5640_set_hue(sensor, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = ov5640_set_contrast(sensor, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		ret = ov5640_set_saturation(sensor, ctrl->val);
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		ret = ov5640_set_test_pattern(sensor, ctrl->val);
+		break;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops ov5640_ctrl_ops = {
+	.g_volatile_ctrl = ov5640_g_volatile_ctrl,
+	.s_ctrl = ov5640_s_ctrl,
+};
+
+static const char * const test_pattern_menu[] = {
+	"Disabled",
+	"Color bars",
+};
+
+static int ov5640_init_controls(struct ov5640_dev *sensor)
+{
+	const struct v4l2_ctrl_ops *ops = &ov5640_ctrl_ops;
+	struct ov5640_ctrls *ctrls = &sensor->ctrls;
+	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
+	int ret;
+
+	v4l2_ctrl_handler_init(hdl, 32);
+
+	/* Auto/manual white balance */
+	ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
+					   V4L2_CID_AUTO_WHITE_BALANCE,
+					   0, 1, 1, 1);
+	ctrls->blue_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BLUE_BALANCE,
+						0, 4095, 1, 0);
+	ctrls->red_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_RED_BALANCE,
+					       0, 4095, 1, 0);
+	/* Auto/manual exposure */
+	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
+						 V4L2_CID_EXPOSURE_AUTO,
+						 V4L2_EXPOSURE_MANUAL, 0,
+						 V4L2_EXPOSURE_AUTO);
+	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
+					    V4L2_CID_EXPOSURE_ABSOLUTE,
+					    0, 65535, 1, 0);
+	/* Auto/manual gain */
+	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
+					     0, 1, 1, 1);
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+					0, 1023, 1, 0);
+
+	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
+					      0, 255, 1, 64);
+	ctrls->hue = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HUE,
+				       0, 359, 1, 0);
+	ctrls->contrast = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST,
+					    0, 255, 1, 0);
+	ctrls->test_pattern =
+		v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
+					     ARRAY_SIZE(test_pattern_menu) - 1,
+					     0, 0, test_pattern_menu);
+
+	if (hdl->error) {
+		ret = hdl->error;
+		goto free_ctrls;
+	}
+
+	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	v4l2_ctrl_auto_cluster(3, &ctrls->auto_wb, 0, false);
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
+
+	sensor->sd.ctrl_handler = hdl;
+	return 0;
+
+free_ctrls:
+	v4l2_ctrl_handler_free(hdl);
+	return ret;
+}
+
+static int ov5640_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->pad != 0)
+		return -EINVAL;
+	if (fse->index >= OV5640_NUM_MODES)
+		return -EINVAL;
+
+	fse->min_width = fse->max_width =
+		ov5640_mode_data[0][fse->index].width;
+	fse->min_height = fse->max_height =
+		ov5640_mode_data[0][fse->index].height;
+
+	return 0;
+}
+
+static int ov5640_enum_frame_interval(
+	struct v4l2_subdev *sd,
+	struct v4l2_subdev_pad_config *cfg,
+	struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+	const struct ov5640_mode_info *mode;
+
+	if (fie->pad != 0)
+		return -EINVAL;
+	if (fie->index >= OV5640_NUM_FRAMERATES)
+		return -EINVAL;
+
+	mode = ov5640_find_mode(sensor, fie->index,
+				fie->width, fie->height, false);
+	if (!mode)
+		return -EINVAL;
+
+	fie->interval.numerator = 1;
+	fie->interval.denominator = ov5640_framerates[fie->index];
+
+	return 0;
+}
+
+static int ov5640_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+
+	if (code->pad != 0)
+		return -EINVAL;
+	if (code->index != 0)
+		return -EINVAL;
+
+	code->code = sensor->fmt.code;
+
+	return 0;
+}
+
+static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+
+	return ov5640_set_stream(sensor, enable);
+}
+
+static const struct v4l2_subdev_core_ops ov5640_core_ops = {
+	.s_power = ov5640_s_power,
+};
+
+static const struct v4l2_subdev_video_ops ov5640_video_ops = {
+	.s_parm = ov5640_s_parm,
+	.g_parm = ov5640_g_parm,
+	.s_stream = ov5640_s_stream,
+};
+
+static const struct v4l2_subdev_pad_ops ov5640_pad_ops = {
+	.enum_mbus_code = ov5640_enum_mbus_code,
+	.get_fmt = ov5640_get_fmt,
+	.set_fmt = ov5640_set_fmt,
+	.enum_frame_size = ov5640_enum_frame_size,
+	.enum_frame_interval = ov5640_enum_frame_interval,
+};
+
+static const struct v4l2_subdev_ops ov5640_subdev_ops = {
+	.core = &ov5640_core_ops,
+	.video = &ov5640_video_ops,
+	.pad = &ov5640_pad_ops,
+};
+
+static int ov5640_get_regulators(struct ov5640_dev *sensor)
+{
+	int i;
+
+	for (i = 0; i < OV5640_NUM_SUPPLIES; i++)
+		sensor->supplies[i].supply = ov5640_supply_name[i];
+
+	return devm_regulator_bulk_get(&sensor->i2c_client->dev,
+				       OV5640_NUM_SUPPLIES,
+				       sensor->supplies);
+}
+
+static int ov5640_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct device_node *endpoint;
+	struct ov5640_dev *sensor;
+	int ret;
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	sensor->i2c_client = client;
+	sensor->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
+	sensor->fmt.width = 640;
+	sensor->fmt.height = 480;
+	sensor->fmt.field = V4L2_FIELD_NONE;
+	sensor->streamcap.capability = V4L2_CAP_TIMEPERFRAME;
+	sensor->streamcap.capturemode = 0;
+	sensor->streamcap.timeperframe.denominator =
+		ov5640_framerates[OV5640_30_FPS];
+	sensor->streamcap.timeperframe.numerator = 1;
+	sensor->current_fr = OV5640_30_FPS;
+
+	sensor->current_mode =
+		&ov5640_mode_data[OV5640_30_FPS][OV5640_MODE_VGA_640_480];
+
+	sensor->ae_target = 52;
+
+	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
+	if (!endpoint) {
+		dev_err(dev, "endpoint node not found\n");
+		return -EINVAL;
+	}
+
+	v4l2_of_parse_endpoint(endpoint, &sensor->ep);
+	of_node_put(endpoint);
+
+	if (sensor->ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(dev, "invalid bus type, must be MIPI CSI2\n");
+		return -EINVAL;
+	}
+
+	/* get system clock (xclk) */
+	sensor->xclk = devm_clk_get(dev, "xclk");
+	if (IS_ERR(sensor->xclk)) {
+		dev_err(dev, "failed to get xclk\n");
+		return PTR_ERR(sensor->xclk);
+	}
+
+	sensor->xclk_freq = clk_get_rate(sensor->xclk);
+	if (sensor->xclk_freq < OV5640_XCLK_MIN ||
+	    sensor->xclk_freq > OV5640_XCLK_MAX) {
+		dev_err(dev, "xclk frequency out of range: %d Hz\n",
+			sensor->xclk_freq);
+		return -EINVAL;
+	}
+
+	/* request optional power down pin */
+	sensor->pwdn_gpio = devm_gpiod_get_optional(dev, "pwdn",
+						    GPIOD_OUT_HIGH);
+	/* request optional reset pin */
+	sensor->reset_gpio = devm_gpiod_get_optional(dev, "reset",
+						     GPIOD_OUT_HIGH);
+
+	v4l2_i2c_subdev_init(&sensor->sd, client, &ov5640_subdev_ops);
+
+	sensor->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&sensor->sd.entity, 1, &sensor->pad);
+	if (ret)
+		return ret;
+
+	ret = ov5640_get_regulators(sensor);
+	if (ret)
+		return ret;
+
+	mutex_init(&sensor->power_lock);
+
+	ret = ov5640_init_controls(sensor);
+	if (ret)
+		goto entity_cleanup;
+
+	ret = v4l2_async_register_subdev(&sensor->sd);
+	if (ret)
+		goto free_ctrls;
+
+	return 0;
+
+free_ctrls:
+	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
+entity_cleanup:
+	mutex_destroy(&sensor->power_lock);
+	media_entity_cleanup(&sensor->sd.entity);
+	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
+	return ret;
+}
+
+static int ov5640_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov5640_dev *sensor = to_ov5640_dev(sd);
+
+	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
+
+	v4l2_async_unregister_subdev(&sensor->sd);
+	mutex_destroy(&sensor->power_lock);
+	media_entity_cleanup(&sensor->sd.entity);
+	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
+
+	return 0;
+}
+
+static const struct i2c_device_id ov5640_id[] = {
+	{"ov5640", 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, ov5640_id);
+
+static const struct of_device_id ov5640_dt_ids[] = {
+	{ .compatible = "ovti,ov5640" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ov5640_dt_ids);
+
+static struct i2c_driver ov5640_i2c_driver = {
+	.driver = {
+		.name  = "ov5640",
+		.of_match_table	= ov5640_dt_ids,
+	},
+	.id_table = ov5640_id,
+	.probe    = ov5640_probe,
+	.remove   = ov5640_remove,
+};
+
+module_i2c_driver(ov5640_i2c_driver);
+
+MODULE_DESCRIPTION("OV5640 MIPI Camera Subdev Driver");
+MODULE_LICENSE("GPL");
-- 
2.7.4
