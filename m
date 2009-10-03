Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40686 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755097AbZJCLUq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 07:20:46 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Mu2fX-0001fm-3y
	for linux-media@vger.kernel.org; Sat, 03 Oct 2009 13:20:55 +0200
Date: Sat, 3 Oct 2009 13:20:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] soc-camera: add a new driver for the RJ54N1CB0C camera
 sensor from Sharp
Message-ID: <Pine.LNX.4.64.0910031319320.5857@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds an soc-camera / v4l2-subdev driver for the RJ54N1CB0C CMOS camera
sensor from Sharp. The sensor is very picky about initialisation and
configuration sequences. The driver limits artificially maximum window size by
800x600, although the sensor supports 1600x1200. Sizes above 800x600 don't seem
to work correctly, besides, examples from the system integrator use sizes above
640x480 only for still photography. Unfortunately, I had to use "magic"
register-value pairs for undocumented and "reserved" registers. This version of
the driver also omits some functionality, like cropping, which hasn't been
sufficiently tested yet and will be added later.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Kconfig      |    6 +
 drivers/media/video/Makefile     |    1 +
 drivers/media/video/rj54n1cb0c.c | 1219 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h  |    3 +
 4 files changed, 1229 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/rj54n1cb0c.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c318676..0ab7ccd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -847,6 +847,12 @@ config SOC_CAMERA_MT9V022
 	help
 	  This driver supports MT9V022 cameras from Micron
 
+config SOC_CAMERA_RJ54N1
+	tristate "rj54n1cb0c support"
+	depends on SOC_CAMERA && I2C
+	help
+	  This is a rj54n1cb0c video driver
+
 config SOC_CAMERA_TW9910
 	tristate "tw9910 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index e706cee..2851e5e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
+obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
 
 # And now the v4l2 drivers:
 
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
new file mode 100644
index 0000000..373f2a3
--- /dev/null
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -0,0 +1,1219 @@
+/*
+ * Driver for RJ54N1CB0C CMOS Image Sensor from Micron
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/soc_camera.h>
+
+#define RJ54N1_DEV_CODE			0x0400
+#define RJ54N1_DEV_CODE2		0x0401
+#define RJ54N1_OUT_SEL			0x0403
+#define RJ54N1_XY_OUTPUT_SIZE_S_H	0x0404
+#define RJ54N1_X_OUTPUT_SIZE_S_L	0x0405
+#define RJ54N1_Y_OUTPUT_SIZE_S_L	0x0406
+#define RJ54N1_XY_OUTPUT_SIZE_P_H	0x0407
+#define RJ54N1_X_OUTPUT_SIZE_P_L	0x0408
+#define RJ54N1_Y_OUTPUT_SIZE_P_L	0x0409
+#define RJ54N1_LINE_LENGTH_PCK_S_H	0x040a
+#define RJ54N1_LINE_LENGTH_PCK_S_L	0x040b
+#define RJ54N1_LINE_LENGTH_PCK_P_H	0x040c
+#define RJ54N1_LINE_LENGTH_PCK_P_L	0x040d
+#define RJ54N1_RESIZE_N			0x040e
+#define RJ54N1_RESIZE_N_STEP		0x040f
+#define RJ54N1_RESIZE_STEP		0x0410
+#define RJ54N1_RESIZE_HOLD_H		0x0411
+#define RJ54N1_RESIZE_HOLD_L		0x0412
+#define RJ54N1_H_OBEN_OFS		0x0413
+#define RJ54N1_V_OBEN_OFS		0x0414
+#define RJ54N1_RESIZE_CONTROL		0x0415
+#define RJ54N1_INC_USE_SEL_H		0x0425
+#define RJ54N1_INC_USE_SEL_L		0x0426
+#define RJ54N1_MIRROR_STILL_MODE	0x0427
+#define RJ54N1_INIT_START		0x0428
+#define RJ54N1_SCALE_1_2_LEV		0x0429
+#define RJ54N1_SCALE_4_LEV		0x042a
+#define RJ54N1_Y_GAIN			0x04d8
+#define RJ54N1_APT_GAIN_UP		0x04fa
+#define RJ54N1_RA_SEL_UL		0x0530
+#define RJ54N1_BYTE_SWAP		0x0531
+#define RJ54N1_OUT_SIGPO		0x053b
+#define RJ54N1_FRAME_LENGTH_S_H		0x0595
+#define RJ54N1_FRAME_LENGTH_S_L		0x0596
+#define RJ54N1_FRAME_LENGTH_P_H		0x0597
+#define RJ54N1_FRAME_LENGTH_P_L		0x0598
+#define RJ54N1_IOC			0x05ef
+#define RJ54N1_TG_BYPASS		0x0700
+#define RJ54N1_PLL_L			0x0701
+#define RJ54N1_PLL_N			0x0702
+#define RJ54N1_PLL_EN			0x0704
+#define RJ54N1_RATIO_TG			0x0706
+#define RJ54N1_RATIO_T			0x0707
+#define RJ54N1_RATIO_R			0x0708
+#define RJ54N1_RAMP_TGCLK_EN		0x0709
+#define RJ54N1_OCLK_DSP			0x0710
+#define RJ54N1_RATIO_OP			0x0711
+#define RJ54N1_RATIO_O			0x0712
+#define RJ54N1_OCLK_SEL_EN		0x0713
+#define RJ54N1_CLK_RST			0x0717
+#define RJ54N1_RESET_STANDBY		0x0718
+
+#define E_EXCLK				(1 << 7)
+#define SOFT_STDBY			(1 << 4)
+#define SEN_RSTX			(1 << 2)
+#define TG_RSTX				(1 << 1)
+#define DSP_RSTX			(1 << 0)
+
+#define RESIZE_HOLD_SEL			(1 << 2)
+#define RESIZE_GO			(1 << 1)
+
+#define RJ54N1_COLUMN_SKIP		0
+#define RJ54N1_ROW_SKIP			0
+#define RJ54N1_MAX_WIDTH		1600
+#define RJ54N1_MAX_HEIGHT		1200
+
+/* I2C addresses: 0x50, 0x51, 0x60, 0x61 */
+
+static const struct soc_camera_data_format rj54n1_colour_formats[] = {
+	{
+		.name		= "YUYV",
+		.depth		= 16,
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		.name		= "RGB565",
+		.depth		= 16,
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+	}
+};
+
+struct rj54n1_clock_div {
+	u8 ratio_tg;
+	u8 ratio_t;
+	u8 ratio_r;
+	u8 ratio_op;
+	u8 ratio_o;
+};
+
+struct rj54n1 {
+	struct v4l2_subdev subdev;
+	struct v4l2_rect rect;	/* Sensor window */
+	unsigned short width;	/* Output window */
+	unsigned short height;
+	unsigned short resize;	/* Sensor * 1024 / resize = Output */
+	struct rj54n1_clock_div clk_div;
+	u32 fourcc;
+	unsigned short scale;
+	u8 bank;
+};
+
+struct rj54n1_reg_val {
+	u16 reg;
+	u8 val;
+};
+
+const static struct rj54n1_reg_val bank_4[] = {
+	{0x417, 0},
+	{0x42c, 0},
+	{0x42d, 0xf0},
+	{0x42e, 0},
+	{0x42f, 0x50},
+	{0x430, 0xf5},
+	{0x431, 0x16},
+	{0x432, 0x20},
+	{0x433, 0},
+	{0x434, 0xc8},
+	{0x43c, 8},
+	{0x43e, 0x90},
+	{0x445, 0x83},
+	{0x4ba, 0x58},
+	{0x4bb, 4},
+	{0x4bc, 0x20},
+	{0x4db, 4},
+	{0x4fe, 2},
+};
+
+const static struct rj54n1_reg_val bank_5[] = {
+	{0x514, 0},
+	{0x516, 0},
+	{0x518, 0},
+	{0x51a, 0},
+	{0x51d, 0xff},
+	{0x56f, 0x28},
+	{0x575, 0x40},
+	{0x5bc, 0x48},
+	{0x5c1, 6},
+	{0x5e5, 0x11},
+	{0x5e6, 0x43},
+	{0x5e7, 0x33},
+	{0x5e8, 0x21},
+	{0x5e9, 0x30},
+	{0x5ea, 0x0},
+	{0x5eb, 0xa5},
+	{0x5ec, 0xff},
+	{0x5fe, 2},
+};
+
+const static struct rj54n1_reg_val bank_7[] = {
+	{0x70a, 0},
+	{0x714, 0xff},
+	{0x715, 0xff},
+	{0x716, 0x1f},
+	{0x7FE, 0x02},
+};
+
+const static struct rj54n1_reg_val bank_8[] = {
+	{0x800, 0x00},
+	{0x801, 0x01},
+	{0x802, 0x61},
+	{0x805, 0x00},
+	{0x806, 0x00},
+	{0x807, 0x00},
+	{0x808, 0x00},
+	{0x809, 0x01},
+	{0x80A, 0x61},
+	{0x80B, 0x00},
+	{0x80C, 0x01},
+	{0x80D, 0x00},
+	{0x80E, 0x00},
+	{0x80F, 0x00},
+	{0x810, 0x00},
+	{0x811, 0x01},
+	{0x812, 0x61},
+	{0x813, 0x00},
+	{0x814, 0x11},
+	{0x815, 0x00},
+	{0x816, 0x41},
+	{0x817, 0x00},
+	{0x818, 0x51},
+	{0x819, 0x01},
+	{0x81A, 0x1F},
+	{0x81B, 0x00},
+	{0x81C, 0x01},
+	{0x81D, 0x00},
+	{0x81E, 0x11},
+	{0x81F, 0x00},
+	{0x820, 0x41},
+	{0x821, 0x00},
+	{0x822, 0x51},
+	{0x823, 0x00},
+	{0x824, 0x00},
+	{0x825, 0x00},
+	{0x826, 0x47},
+	{0x827, 0x01},
+	{0x828, 0x4F},
+	{0x829, 0x00},
+	{0x82A, 0x00},
+	{0x82B, 0x00},
+	{0x82C, 0x30},
+	{0x82D, 0x00},
+	{0x82E, 0x40},
+	{0x82F, 0x00},
+	{0x830, 0xB3},
+	{0x831, 0x00},
+	{0x832, 0xE3},
+	{0x833, 0x00},
+	{0x834, 0x00},
+	{0x835, 0x00},
+	{0x836, 0x00},
+	{0x837, 0x00},
+	{0x838, 0x00},
+	{0x839, 0x01},
+	{0x83A, 0x61},
+	{0x83B, 0x00},
+	{0x83C, 0x01},
+	{0x83D, 0x00},
+	{0x83E, 0x00},
+	{0x83F, 0x00},
+	{0x840, 0x00},
+	{0x841, 0x01},
+	{0x842, 0x61},
+	{0x843, 0x00},
+	{0x844, 0x1D},
+	{0x845, 0x00},
+	{0x846, 0x00},
+	{0x847, 0x00},
+	{0x848, 0x00},
+	{0x849, 0x01},
+	{0x84A, 0x1F},
+	{0x84B, 0x00},
+	{0x84C, 0x05},
+	{0x84D, 0x00},
+	{0x84E, 0x19},
+	{0x84F, 0x01},
+	{0x850, 0x21},
+	{0x851, 0x01},
+	{0x852, 0x5D},
+	{0x853, 0x00},
+	{0x854, 0x00},
+	{0x855, 0x00},
+	{0x856, 0x19},
+	{0x857, 0x01},
+	{0x858, 0x21},
+	{0x859, 0x00},
+	{0x85A, 0x00},
+	{0x85B, 0x00},
+	{0x85C, 0x00},
+	{0x85D, 0x00},
+	{0x85E, 0x00},
+	{0x85F, 0x00},
+	{0x860, 0xB3},
+	{0x861, 0x00},
+	{0x862, 0xE3},
+	{0x863, 0x00},
+	{0x864, 0x00},
+	{0x865, 0x00},
+	{0x866, 0x00},
+	{0x867, 0x00},
+	{0x868, 0x00},
+	{0x869, 0xE2},
+	{0x86A, 0x00},
+	{0x86B, 0x01},
+	{0x86C, 0x06},
+	{0x86D, 0x00},
+	{0x86E, 0x00},
+	{0x86F, 0x00},
+	{0x870, 0x60},
+	{0x871, 0x8C},
+	{0x872, 0x10},
+	{0x873, 0x00},
+	{0x874, 0xE0},
+	{0x875, 0x00},
+	{0x876, 0x27},
+	{0x877, 0x01},
+	{0x878, 0x00},
+	{0x879, 0x00},
+	{0x87A, 0x00},
+	{0x87B, 0x03},
+	{0x87C, 0x00},
+	{0x87D, 0x00},
+	{0x87E, 0x00},
+	{0x87F, 0x00},
+	{0x880, 0x00},
+	{0x881, 0x00},
+	{0x882, 0x00},
+	{0x883, 0x00},
+	{0x884, 0x00},
+	{0x885, 0x00},
+	{0x886, 0xF8},
+	{0x887, 0x00},
+	{0x888, 0x03},
+	{0x889, 0x00},
+	{0x88A, 0x64},
+	{0x88B, 0x00},
+	{0x88C, 0x03},
+	{0x88D, 0x00},
+	{0x88E, 0xB1},
+	{0x88F, 0x00},
+	{0x890, 0x03},
+	{0x891, 0x01},
+	{0x892, 0x1D},
+	{0x893, 0x00},
+	{0x894, 0x03},
+	{0x895, 0x01},
+	{0x896, 0x4B},
+	{0x897, 0x00},
+	{0x898, 0xE5},
+	{0x899, 0x00},
+	{0x89A, 0x01},
+	{0x89B, 0x00},
+	{0x89C, 0x01},
+	{0x89D, 0x04},
+	{0x89E, 0xC8},
+	{0x89F, 0x00},
+	{0x8A0, 0x01},
+	{0x8A1, 0x01},
+	{0x8A2, 0x61},
+	{0x8A3, 0x00},
+	{0x8A4, 0x01},
+	{0x8A5, 0x00},
+	{0x8A6, 0x00},
+	{0x8A7, 0x00},
+	{0x8A8, 0x00},
+	{0x8A9, 0x00},
+	{0x8AA, 0x7F},
+	{0x8AB, 0x03},
+	{0x8AC, 0x00},
+	{0x8AD, 0x00},
+	{0x8AE, 0x00},
+	{0x8AF, 0x00},
+	{0x8B0, 0x00},
+	{0x8B1, 0x00},
+	{0x8B6, 0x00},
+	{0x8B7, 0x01},
+	{0x8B8, 0x00},
+	{0x8B9, 0x00},
+	{0x8BA, 0x02},
+	{0x8BB, 0x00},
+	{0x8BC, 0xFF},
+	{0x8BD, 0x00},
+	{0x8FE, 0x02},
+};
+
+const static struct rj54n1_reg_val bank_10[] = {
+	{0x10bf, 0x69}
+};
+
+/* Clock dividers - these are default register values, divider = register + 1 */
+const static struct rj54n1_clock_div clk_div = {
+	.ratio_tg	= 3 /* default: 5 */,
+	.ratio_t	= 4 /* default: 1 */,
+	.ratio_r	= 4 /* default: 0 */,
+	.ratio_op	= 1 /* default: 5 */,
+	.ratio_o	= 9 /* default: 0 */,
+};
+
+static struct rj54n1 *to_rj54n1(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct rj54n1, subdev);
+}
+
+static int reg_read(struct i2c_client *client, const u16 reg)
+{
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	int ret;
+
+	/* set bank */
+	if (rj54n1->bank != reg >> 8) {
+		dev_dbg(&client->dev, "[0x%x] = 0x%x\n", 0xff, reg >> 8);
+		ret = i2c_smbus_write_byte_data(client, 0xff, reg >> 8);
+		if (ret < 0)
+			return ret;
+		rj54n1->bank = reg >> 8;
+	}
+	return i2c_smbus_read_byte_data(client, reg & 0xff);
+}
+
+static int reg_write(struct i2c_client *client, const u16 reg,
+		     const u8 data)
+{
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	int ret;
+
+	/* set bank */
+	if (rj54n1->bank != reg >> 8) {
+		dev_dbg(&client->dev, "[0x%x] = 0x%x\n", 0xff, reg >> 8);
+		ret = i2c_smbus_write_byte_data(client, 0xff, reg >> 8);
+		if (ret < 0)
+			return ret;
+		rj54n1->bank = reg >> 8;
+	}
+	dev_dbg(&client->dev, "[0x%x] = 0x%x\n", reg & 0xff, data);
+	return i2c_smbus_write_byte_data(client, reg & 0xff, data);
+}
+
+static int reg_set(struct i2c_client *client, const u16 reg,
+		   const u8 data, const u8 mask)
+{
+	int ret;
+
+	ret = reg_read(client, reg);
+	if (ret < 0)
+		return ret;
+	return reg_write(client, reg, (ret & ~mask) | (data & mask));
+}
+
+static int reg_write_multiple(struct i2c_client *client,
+			      const struct rj54n1_reg_val *rv, const int n)
+{
+	int i, ret;
+
+	for (i = 0; i < n; i++) {
+		ret = reg_write(client, rv->reg, rv->val);
+		if (ret < 0)
+			return ret;
+		rv++;
+	}
+
+	return 0;
+}
+
+static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	/* TODO: start / stop streaming */
+	return 0;
+}
+
+static int rj54n1_set_bus_param(struct soc_camera_device *icd,
+				unsigned long flags)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct i2c_client *client = sd->priv;
+	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
+
+	if (flags & SOCAM_PCLK_SAMPLE_RISING)
+		return reg_write(client, RJ54N1_OUT_SIGPO, 1 << 4);
+	else
+		return reg_write(client, RJ54N1_OUT_SIGPO, 0);
+}
+
+static unsigned long rj54n1_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	const unsigned long flags =
+		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
+		SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_DATA_ACTIVE_HIGH;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+static int rj54n1_set_rect(struct i2c_client *client,
+			   u16 reg_x, u16 reg_y, u16 reg_xy,
+			   u32 width, u32 height)
+{
+	int ret;
+
+	ret = reg_write(client, reg_xy,
+			((width >> 4) & 0x70) |
+			((height >> 8) & 7));
+
+	if (!ret)
+		ret = reg_write(client, reg_x, width & 0xff);
+	if (!ret)
+		ret = reg_write(client, reg_y, height & 0xff);
+
+	return ret;
+}
+
+/*
+ * Some commands, specifically certain initialisation sequences, require
+ * a commit operation.
+ */
+static int rj54n1_commit(struct i2c_client *client)
+{
+	int ret = reg_write(client, RJ54N1_INIT_START, 1);
+	msleep(10);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_INIT_START, 0);
+	return ret;
+}
+
+static int rj54n1_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+
+	a->c	= rj54n1->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= RJ54N1_COLUMN_SKIP;
+	a->bounds.top			= RJ54N1_ROW_SKIP;
+	a->bounds.width			= RJ54N1_MAX_WIDTH;
+	a->bounds.height		= RJ54N1_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int rj54n1_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->pixelformat	= rj54n1->fourcc;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->width		= rj54n1->width;
+	pix->height		= rj54n1->height;
+
+	return 0;
+}
+
+/*
+ * The actual geometry configuration routine. It scales the input window into
+ * the output one, updates the window sizes and returns an error or the resize
+ * coefficient on success. Note: we only use the "Fixed Scaling" on this camera.
+ */
+static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
+			       u32 *out_w, u32 *out_h)
+{
+	struct i2c_client *client = sd->priv;
+	unsigned int skip, resize, input_w = *in_w, input_h = *in_h,
+		output_w = *out_w, output_h = *out_h;
+	u16 inc_sel;
+	int ret;
+
+	ret = rj54n1_set_rect(client, RJ54N1_X_OUTPUT_SIZE_S_L,
+			      RJ54N1_Y_OUTPUT_SIZE_S_L,
+			      RJ54N1_XY_OUTPUT_SIZE_S_H, output_w, output_h);
+	if (!ret)
+		ret = rj54n1_set_rect(client, RJ54N1_X_OUTPUT_SIZE_P_L,
+			      RJ54N1_Y_OUTPUT_SIZE_P_L,
+			      RJ54N1_XY_OUTPUT_SIZE_P_H, output_w, output_h);
+
+	if (ret < 0)
+		return ret;
+
+	if (output_w > input_w || output_h > input_h) {
+		input_w = output_w;
+		input_h = output_h;
+
+		resize = 1024;
+	} else {
+		unsigned int resize_x, resize_y;
+		resize_x = input_w * 1024 / output_w;
+		resize_y = input_h * 1024 / output_h;
+
+		resize = min(resize_x, resize_y);
+
+		/* Prohibited value ranges */
+		switch (resize) {
+		case 2040 ... 2047:
+			resize = 2039;
+			break;
+		case 4080 ... 4095:
+			resize = 4079;
+			break;
+		case 8160 ... 8191:
+			resize = 8159;
+			break;
+		case 16320 ... 16383:
+			resize = 16319;
+		}
+
+		input_w = output_w * resize / 1024;
+		input_h = output_h * resize / 1024;
+	}
+
+	/* Set scaling */
+	ret = reg_write(client, RJ54N1_RESIZE_HOLD_L, resize & 0xff);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESIZE_HOLD_H, resize >> 8);
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Configure a skipping bitmask. The sensor will select a skipping value
+	 * among set bits automatically.
+	 */
+	skip = min(resize / 1024, (unsigned)15);
+	inc_sel = 1 << skip;
+
+	if (inc_sel <= 2)
+		inc_sel = 0xc;
+	else if (resize & 1023 && skip < 15)
+		inc_sel |= 1 << (skip + 1);
+
+	ret = reg_write(client, RJ54N1_INC_USE_SEL_L, inc_sel & 0xfc);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_INC_USE_SEL_H, inc_sel >> 8);
+
+	/* Start resizing */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
+				RESIZE_HOLD_SEL | RESIZE_GO | 1);
+
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&client->dev, "resize %u, skip %u\n", resize, skip);
+
+	/* Constant taken from manufacturer's example */
+	msleep(230);
+
+	ret = reg_write(client, RJ54N1_RESIZE_CONTROL, RESIZE_HOLD_SEL | 1);
+	if (ret < 0)
+		return ret;
+
+	*in_w = input_w;
+	*in_h = input_h;
+	*out_w = output_w;
+	*out_h = output_h;
+
+	return resize;
+}
+
+static int rj54n1_set_clock(struct i2c_client *client)
+{
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	int ret;
+
+	/* Enable external clock */
+	ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK | SOFT_STDBY);
+	/* Leave stand-by */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK);
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_L, 2);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_N, 0x31);
+
+	/* TGCLK dividers */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_TG,
+				rj54n1->clk_div.ratio_tg);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_T,
+				rj54n1->clk_div.ratio_t);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_R,
+				rj54n1->clk_div.ratio_r);
+
+	/* Enable TGCLK & RAMP */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RAMP_TGCLK_EN, 3);
+
+	/* Disable clock output */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_DSP, 0);
+
+	/* Set divisors */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_OP,
+				rj54n1->clk_div.ratio_op);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_O,
+				rj54n1->clk_div.ratio_o);
+
+	/* Enable OCLK */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
+
+	/* Use PLL for Timing Generator, write 2 to reserved bits */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_TG_BYPASS, 2);
+
+	/* Take sensor out of reset */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | SEN_RSTX);
+	/* Enable PLL */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_EN, 1);
+
+	/* Wait for PLL to stabilise */
+	msleep(10);
+
+	/* Enable clock to frequency divider */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_CLK_RST, 1);
+
+	if (!ret)
+		ret = reg_read(client, RJ54N1_CLK_RST);
+	if (ret != 1) {
+		dev_err(&client->dev,
+			"Resetting RJ54N1CB0C clock failed: %d!\n", ret);
+		return -EIO;
+	}
+	/* Start the PLL */
+	ret = reg_set(client, RJ54N1_OCLK_DSP, 1, 1);
+
+	/* Enable OCLK */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
+
+	return ret;
+}
+
+static int rj54n1_reg_init(struct i2c_client *client)
+{
+	int ret = rj54n1_set_clock(client);
+
+	if (!ret)
+		ret = reg_write_multiple(client, bank_7, ARRAY_SIZE(bank_7));
+	if (!ret)
+		ret = reg_write_multiple(client, bank_10, ARRAY_SIZE(bank_10));
+
+	/* Set binning divisors */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_SCALE_1_2_LEV, 3 | (7 << 4));
+	if (!ret)
+		ret = reg_write(client, RJ54N1_SCALE_4_LEV, 0xf);
+
+	/* Switch to fixed resize mode */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
+				RESIZE_HOLD_SEL | 1);
+
+	/* Set gain */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_Y_GAIN, 0x84);
+
+	/* Mirror the image back: default is upside down and left-to-right... */
+	if (!ret)
+		ret = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 3, 3);
+
+	if (!ret)
+		ret = reg_write_multiple(client, bank_4, ARRAY_SIZE(bank_4));
+	if (!ret)
+		ret = reg_write_multiple(client, bank_5, ARRAY_SIZE(bank_5));
+	if (!ret)
+		ret = reg_write_multiple(client, bank_8, ARRAY_SIZE(bank_8));
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | DSP_RSTX | SEN_RSTX);
+
+	/* Commit init */
+	if (!ret)
+		ret = rj54n1_commit(client);
+
+	/* Take DSP, TG, sensor out of reset */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | DSP_RSTX | TG_RSTX | SEN_RSTX);
+
+	if (!ret)
+		ret = reg_write(client, 0x7fe, 2);
+
+	/* Constant taken from manufacturer's example */
+	msleep(700);
+
+	return ret;
+}
+
+/* FIXME: streaming output only up to 800x600 is functional */
+static int rj54n1_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->field = V4L2_FIELD_NONE;
+
+	if (pix->width > 800)
+		pix->width = 800;
+	if (pix->height > 600)
+		pix->height = 600;
+
+	return 0;
+}
+
+static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	unsigned int output_w, output_h,
+		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
+	int ret;
+
+	/*
+	 * The host driver can call us without .try_fmt(), so, we have to take
+	 * care ourseleves
+	 */
+	ret = rj54n1_try_fmt(sd, f);
+
+	/*
+	 * Verify if the sensor has just been powered on. TODO: replace this
+	 * with proper PM, when a suitable API is available.
+	 */
+	if (!ret)
+		ret = reg_read(client, RJ54N1_RESET_STANDBY);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & E_EXCLK)) {
+		ret = rj54n1_reg_init(client);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	/* Supported scales 1:1 - 1:16 */
+	if (pix->width < input_w / 16)
+		pix->width = input_w / 16;
+	if (pix->height < input_h / 16)
+		pix->height = input_h / 16;
+
+	output_w = pix->width;
+	output_h = pix->height;
+
+	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
+	if (ret < 0)
+		return ret;
+
+	rj54n1->fourcc		= pix->pixelformat;
+	rj54n1->resize		= ret;
+	rj54n1->rect.width	= input_w;
+	rj54n1->rect.height	= input_h;
+	rj54n1->width		= output_w;
+	rj54n1->height		= output_h;
+
+	pix->width		= output_w;
+	pix->height		= output_h;
+	pix->field		= V4L2_FIELD_NONE;
+
+	return ret;
+}
+
+static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_chip_ident *id)
+{
+	struct i2c_client *client = sd->priv;
+
+	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
+
+	if (id->match.addr != client->addr)
+		return -ENODEV;
+
+	id->ident	= V4L2_IDENT_RJ54N1CB0C;
+	id->revision	= 0;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int rj54n1_g_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+
+	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
+	    reg->reg < 0x400 || reg->reg > 0x1fff)
+		/* Registers > 0x0800 are only available from Sharp support */
+		return -EINVAL;
+
+	if (reg->match.addr != client->addr)
+		return -ENODEV;
+
+	reg->size = 1;
+	reg->val = reg_read(client, reg->reg);
+
+	if (reg->val > 0xff)
+		return -EIO;
+
+	return 0;
+}
+
+static int rj54n1_s_register(struct v4l2_subdev *sd,
+			     struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+
+	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
+	    reg->reg < 0x400 || reg->reg > 0x1fff)
+		/* Registers >= 0x0800 are only available from Sharp support */
+		return -EINVAL;
+
+	if (reg->match.addr != client->addr)
+		return -ENODEV;
+
+	if (reg_write(client, reg->reg, reg->val) < 0)
+		return -EIO;
+
+	return 0;
+}
+#endif
+
+static const struct v4l2_queryctrl rj54n1_controls[] = {
+	{
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Vertically",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	}, {
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Horizontally",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	}, {
+		.id		= V4L2_CID_GAIN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Gain",
+		.minimum	= 0,
+		.maximum	= 127,
+		.step		= 1,
+		.default_value	= 66,
+		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	},
+};
+
+static struct soc_camera_ops rj54n1_ops = {
+	.set_bus_param		= rj54n1_set_bus_param,
+	.query_bus_param	= rj54n1_query_bus_param,
+	.controls		= rj54n1_controls,
+	.num_controls		= ARRAY_SIZE(rj54n1_controls),
+};
+
+static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = sd->priv;
+	int data;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		data = reg_read(client, RJ54N1_MIRROR_STILL_MODE);
+		if (data < 0)
+			return -EIO;
+		ctrl->value = !(data & 1);
+		break;
+	case V4L2_CID_HFLIP:
+		data = reg_read(client, RJ54N1_MIRROR_STILL_MODE);
+		if (data < 0)
+			return -EIO;
+		ctrl->value = !(data & 2);
+		break;
+	case V4L2_CID_GAIN:
+		data = reg_read(client, RJ54N1_Y_GAIN);
+		if (data < 0)
+			return -EIO;
+
+		ctrl->value = data / 2;
+		break;
+	}
+
+	return 0;
+}
+
+static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	int data;
+	struct i2c_client *client = sd->priv;
+	const struct v4l2_queryctrl *qctrl;
+
+	qctrl = soc_camera_find_qctrl(&rj54n1_ops, ctrl->id);
+	if (!qctrl)
+		return -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		if (ctrl->value)
+			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 0, 1);
+		else
+			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 1, 1);
+		if (data < 0)
+			return -EIO;
+		break;
+	case V4L2_CID_HFLIP:
+		if (ctrl->value)
+			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 0, 2);
+		else
+			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 2, 2);
+		if (data < 0)
+			return -EIO;
+		break;
+	case V4L2_CID_GAIN:
+		if (ctrl->value > qctrl->maximum ||
+		    ctrl->value < qctrl->minimum)
+			return -EINVAL;
+		else if (reg_write(client, RJ54N1_Y_GAIN, ctrl->value * 2) < 0)
+			return -EIO;
+		break;
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
+	.g_ctrl		= rj54n1_g_ctrl,
+	.s_ctrl		= rj54n1_s_ctrl,
+	.g_chip_ident	= rj54n1_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register	= rj54n1_g_register,
+	.s_register	= rj54n1_s_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
+	.s_stream	= rj54n1_s_stream,
+	.s_fmt		= rj54n1_s_fmt,
+	.g_fmt		= rj54n1_g_fmt,
+	.try_fmt	= rj54n1_try_fmt,
+	.g_crop		= rj54n1_g_crop,
+	.cropcap	= rj54n1_cropcap,
+};
+
+static struct v4l2_subdev_ops rj54n1_subdev_ops = {
+	.core	= &rj54n1_subdev_core_ops,
+	.video	= &rj54n1_subdev_video_ops,
+};
+
+static int rj54n1_pin_config(struct i2c_client *client)
+{
+	/*
+	 * Experimentally found out IOCTRL wired to 0. TODO: add to platform
+	 * data: 0 or 1 << 7.
+	 */
+	return reg_write(client, RJ54N1_IOC, 0);
+}
+
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
+static int rj54n1_video_probe(struct soc_camera_device *icd,
+			      struct i2c_client *client)
+{
+	int data1, data2;
+	int ret;
+
+	/* This could be a BUG_ON() or a WARN_ON(), or remove it completely */
+	if (!icd->dev.parent ||
+	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
+		return -ENODEV;
+
+	/* Read out the chip version register */
+	data1 = reg_read(client, RJ54N1_DEV_CODE);
+	data2 = reg_read(client, RJ54N1_DEV_CODE2);
+
+	if (data1 != 0x51 || data2 != 0x10) {
+		ret = -ENODEV;
+		dev_info(&client->dev, "No RJ54N1CB0C found, read 0x%x:0x%x\n",
+			 data1, data2);
+		goto ei2c;
+	}
+
+	ret = rj54n1_pin_config(client);
+	if (ret < 0)
+		goto ei2c;
+
+	dev_info(&client->dev, "Detected a RJ54N1CB0C chip ID 0x%x:0x%x\n",
+		 data1, data2);
+
+ei2c:
+	return ret;
+}
+
+static int rj54n1_probe(struct i2c_client *client,
+			const struct i2c_device_id *did)
+{
+	struct rj54n1 *rj54n1;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct soc_camera_link *icl;
+	int ret;
+
+	if (!icd) {
+		dev_err(&client->dev, "RJ54N1CB0C: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
+	if (!icl) {
+		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
+		return -EINVAL;
+	}
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_warn(&adapter->dev,
+			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE\n");
+		return -EIO;
+	}
+
+	rj54n1 = kzalloc(sizeof(struct rj54n1), GFP_KERNEL);
+	if (!rj54n1)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&rj54n1->subdev, client, &rj54n1_subdev_ops);
+
+	icd->ops		= &rj54n1_ops;
+
+	rj54n1->clk_div		= clk_div;
+	rj54n1->rect.left	= RJ54N1_COLUMN_SKIP;
+	rj54n1->rect.top	= RJ54N1_ROW_SKIP;
+	rj54n1->rect.width	= RJ54N1_MAX_WIDTH;
+	rj54n1->rect.height	= RJ54N1_MAX_HEIGHT;
+	rj54n1->width		= RJ54N1_MAX_WIDTH;
+	rj54n1->height		= RJ54N1_MAX_HEIGHT;
+	rj54n1->fourcc		= V4L2_PIX_FMT_YUYV;
+	rj54n1->resize		= 1024;
+
+	ret = rj54n1_video_probe(icd, client);
+	if (ret < 0) {
+		icd->ops = NULL;
+		i2c_set_clientdata(client, NULL);
+		kfree(rj54n1);
+		return ret;
+	}
+
+	icd->formats		= rj54n1_colour_formats;
+	icd->num_formats	= ARRAY_SIZE(rj54n1_colour_formats);
+
+	return ret;
+}
+
+static int rj54n1_remove(struct i2c_client *client)
+{
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	icd->ops = NULL;
+	if (icl->free_bus)
+		icl->free_bus(icl);
+	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
+	kfree(rj54n1);
+
+	return 0;
+}
+
+static const struct i2c_device_id rj54n1_id[] = {
+	{ "rj54n1cb0c", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rj54n1_id);
+
+static struct i2c_driver rj54n1_i2c_driver = {
+	.driver = {
+		.name = "rj54n1cb0c",
+	},
+	.probe		= rj54n1_probe,
+	.remove		= rj54n1_remove,
+	.id_table	= rj54n1_id,
+};
+
+static int __init rj54n1_mod_init(void)
+{
+	return i2c_add_driver(&rj54n1_i2c_driver);
+}
+
+static void __exit rj54n1_mod_exit(void)
+{
+	i2c_del_driver(&rj54n1_i2c_driver);
+}
+
+module_init(rj54n1_mod_init);
+module_exit(rj54n1_mod_exit);
+
+MODULE_DESCRIPTION("Sharp RJ54N1CB0C Camera driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 5ce56f9..56a5975 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -265,6 +265,9 @@ enum {
 
 	/* module m52790: just ident 52790 */
 	V4L2_IDENT_M52790 = 52790,
+
+	/* Sharp RJ54N1CB0C, 0xCB0C = 51980 */
+	V4L2_IDENT_RJ54N1CB0C = 51980,
 };
 
 #endif
-- 
1.6.2.4

