Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54228 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0JEPE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 11:04:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L9T0008DOK7K200@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Oct 2010 16:04:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L9T00EL6OK6UR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Oct 2010 16:04:55 +0100 (BST)
Date: Tue, 05 Oct 2010 17:04:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L/DVB: Add support for SR030PC30 VGA camera
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1286291091-3741-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for SR030PC30 SiliconFile camera sensor.

---

Hello,

this is an initial version of I2C/v4l2 subdevice driver for SR030PC30
camera sensor from SiliconFile. The sensor supports VGA/QVGA/QQVGA
resolutions at 30 fps.
It has been tested with s5p-fimc driver on Aquila board.
Not all available controls are yet exported through g/s_ctrl interface
in this initial version.
I hope to have this driver merged in 2.6.37 if possible.

Any comments are appreciated.

Regards,

Sylwester

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig     |    6 +
 drivers/media/video/Makefile    |    1 +
 drivers/media/video/sr030pc30.c |  925 +++++++++++++++++++++++++++++++++++++++
 include/media/sr030pc30.h       |   21 +
 4 files changed, 953 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/sr030pc30.c
 create mode 100644 include/media/sr030pc30.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..06a4123 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -774,6 +774,12 @@ config VIDEO_CAFE_CCIC
 	  CMOS camera controller.  This is the controller found on first-
 	  generation OLPC systems.
 
+config VIDEO_SR030PC30
+	tristate "SR030PC30 VGA camera sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a v4l driver for the Samsung SR030OC30 camera sensor
+
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 40f98fb..56f21ed 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
+obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
new file mode 100644
index 0000000..57168c7
--- /dev/null
+++ b/drivers/media/video/sr030pc30.c
@@ -0,0 +1,925 @@
+/*
+ * Driver for SR030PC30 camera sensor by Siliconfile
+ *
+ * Copyright (C) 2010 Samsung Electronics Co., Ltd
+ * Author: Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * Based on original driver authored by:
+ *	Dongsoo Nathaniel Kim and
+ *	HeungJun Kim <riverful.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
+#include "sr030pc30.h"
+
+static int debug = 1;
+module_param(debug, int, 0644);
+
+#define MODULE_NAME	"SR030PC30"
+#define REG_TERM	0xFFFF
+
+#define PAGE_REG(page, addr) ((page) << 8 | (addr))
+#define GET_PAGE(reg) (reg >> 8)
+#define GET_ADDR(reg) (reg & 0xFF)
+
+/* Register offsets within a page */
+/* page 0 */
+#define POWER_CTRL_REG		PAGE_REG(0, 0x01)
+#define PAGEMODE_REG		0x03
+#define DEVICE_ID_REG		PAGE_REG(0, 0x04)
+#define NOON010PC30_ID		0x86
+#define SR030PC30_ID		0x8C
+#define VDO_CTL1_REG		PAGE_REG(0, 0x10)
+#define SUBSAMPL_NONE_VGA	0
+#define SUBSAMPL_QVGA		0x10
+#define SUBSAMPL_QQVGA		0x20
+#define VDO_CTL2_REG		PAGE_REG(0, 0x11)
+#define SYNC_CTL_REG		PAGE_REG(0, 0x12)
+#define WIN_ROWH_REG		PAGE_REG(0, 0x20)
+#define WIN_ROWL_REG		PAGE_REG(0, 0x21)
+#define WIN_COLH_REG		PAGE_REG(0, 0x22)
+#define WIN_COLL_REG		PAGE_REG(0, 0x23)
+#define WIN_HEIGHTH_REG		PAGE_REG(0, 0x24)
+#define WIN_HEIGHTL_REG		PAGE_REG(0, 0x25)
+#define WIN_WIDTHH_REG		PAGE_REG(0, 0x26)
+#define WIN_WIDTHL_REG		PAGE_REG(0, 0x27)
+#define HBLANKH_REG		PAGE_REG(0, 0x40)
+#define HBLANKL_REG		PAGE_REG(0, 0x41)
+#define VSYNCH_REG		PAGE_REG(0, 0x42)
+#define VSYNCL_REG		PAGE_REG(0, 0x43)
+/* page 10 */
+#define ISP_CTL_REG(n)		(PAGE_REG(10, 0x10 + (n) - 1))
+#define YOFS_REG		PAGE_REG(10, 0x40)
+#define DARK_YOFS_REG		PAGE_REG(10, 0x41)
+#define AG_ABRTH_REG		PAGE_REG(10, 0x50)
+#define SAT_CTL_REG		PAGE_REG(10, 0x60)
+#define BSAT_REG		PAGE_REG(10, 0x61)
+#define RSAT_REG		PAGE_REG(10, 0x62)
+#define AG_SAT_TH_REG		PAGE_REG(10, 0x63)
+/* page 11 */
+#define ZLPF_CTRL_REG		PAGE_REG(11, 0x10)
+#define ZLPF_CTRL2_REG		PAGE_REG(11, 0x12)
+#define ZLPF_AGH_THR_REG	PAGE_REG(11, 0x21)
+#define ZLPF_THR_REG		PAGE_REG(11, 0x60)
+#define ZLPF_DYN_THR_REG	PAGE_REG(11, 0x60)
+/* page 12 */
+#define YCLPF_CTL1_REG		PAGE_REG(12, 0x40)
+#define YCLPF_CTL2_REG		PAGE_REG(12, 0x41)
+#define YCLPF_THR_REG		PAGE_REG(12, 0x50)
+#define BLPF_CTL_REG		PAGE_REG(12, 0x70)
+#define BLPF_THR1_REG		PAGE_REG(12, 0x74)
+#define BLPF_THR2_REG		PAGE_REG(12, 0x75)
+/* page 14 - Lens Shading Compensation */
+#define LENS_CTRL_REG		PAGE_REG(14, 0x10)
+#define LENS_XCEN_REG		PAGE_REG(14, 0x20)
+#define LENS_YCEN_REG		PAGE_REG(14, 0x21)
+#define LENS_R_COMP_REG		PAGE_REG(14, 0x22)
+#define LENS_G_COMP_REG		PAGE_REG(14, 0x23)
+#define LENS_B_COMP_REG		PAGE_REG(14, 0x24)
+/* page 20 - Auto Exposure */
+#define AE_CTL1_REG		PAGE_REG(20, 0x10)
+#define AE_CTL2_REG		PAGE_REG(20, 0x11)
+#define AE_FRM_CTL_REG		PAGE_REG(20, 0x20)
+#define AE_FINE_CTL_REG(n)	PAGE_REG(20, 0x28 + (n) - 1)
+#define EXP_TIMEH_REG		PAGE_REG(20, 0x83)
+#define EXP_TIMEM_REG		PAGE_REG(20, 0x84)
+#define EXP_TIMEL_REG		PAGE_REG(20, 0x85)
+/* page 22 - Auto White Balance */
+#define AWB_CTL1_REG		PAGE_REG(22, 0x10)
+#define AWB_ENABLE		0x80
+#define AWB_CTL2_REG		PAGE_REG(22, 0x11)
+#define MWB_ENABLE		0x01
+/* RGB gain control (manual WB) when AWB_CTL1[7]=0 */
+#define AWB_RGAIN_REG		PAGE_REG(22, 0x80)
+#define AWB_GGAIN_REG		PAGE_REG(22, 0x81)
+#define AWB_BGAIN_REG		PAGE_REG(22, 0x82)
+#define AWB_RMAX_REG		PAGE_REG(22, 0x83)
+#define AWB_RMIN_REG		PAGE_REG(22, 0x84)
+#define AWB_BMAX_REG		PAGE_REG(22, 0x85)
+#define AWB_BMIN_REG		PAGE_REG(22, 0x86)
+/* R, B gain range in bright light conditions */
+#define AWB_RMAXB_REG		PAGE_REG(22, 0x87)
+#define AWB_RMINB_REG		PAGE_REG(22, 0x88)
+#define AWB_BMAXB_REG		PAGE_REG(22, 0x89)
+#define AWB_BMINB_REG		PAGE_REG(22, 0x8A)
+/* manual white balance, when AWB_CTL2[0]=1 */
+#define MWB_BGAIN_REG		PAGE_REG(22, 0xB2)
+#define MWB_RGAIN_REG		PAGE_REG(22, 0xB3)
+
+
+struct sr030pc30_info {
+	struct v4l2_subdev sd;
+	const struct sr030pc30_platform_data *pdata;
+	const struct sr030pc30_format *curr_fmt;
+	const struct sr030pc30_frmsize *curr_win;
+	unsigned int sleep:1;
+	unsigned int auto_wb:1;
+	unsigned int auto_exp:1;
+	unsigned int hflip:1;
+	unsigned int vflip:1;
+	unsigned int user_win:1;
+	unsigned int exposure;
+	u8 blue_balance, red_balance;
+	u8 i2c_reg_page;
+};
+
+struct sr030pc30_format {
+	enum v4l2_mbus_pixelcode code;
+	enum v4l2_colorspace colorspace;
+	u16 ispctl1_reg;
+};
+
+struct sr030pc30_frmsize {
+	struct v4l2_frmsize_discrete size;
+	/* subsampling register data */
+	int subsampl;
+};
+
+struct i2c_regval {
+	u16 addr;
+	u16 val;
+};
+
+static const struct v4l2_queryctrl sr030pc30_ctrl[] = {
+	{
+		.id = V4L2_CID_AUTO_WHITE_BALANCE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Auto White Balance",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 1,
+	}, {
+		.id = V4L2_CID_RED_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Red Balance",
+		.minimum = 0,
+		.maximum = 128,
+		.step = 1,
+		.default_value = 64,
+		.flags = 0,
+	}, {
+		.id = V4L2_CID_BLUE_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Blue Balance",
+		.minimum = 0,
+		.maximum = 128,
+		.step = 1,
+		.default_value = 64,
+	}, {
+		.id = V4L2_CID_EXPOSURE_AUTO,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Auto Exposure",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 1,
+	}, {
+	}
+};
+
+/* supported resolutions */
+static const struct sr030pc30_frmsize sr030pc30_sizes[] = {
+	{
+		.size = {
+			.width		= 640,
+			.height		= 480,
+		},
+		.subsampl = SUBSAMPL_NONE_VGA,
+	}, {
+		.size = {
+			.width		= 320,
+			.height		= 240,
+		},
+		.subsampl = SUBSAMPL_QVGA,
+	}, {
+		.size = {
+			.width		= 160,
+			.height		= 120,
+		},
+		.subsampl = SUBSAMPL_QQVGA,
+	},
+};
+
+/* supported pixel formats */
+static const struct sr030pc30_format sr030pc30_formats[] = {
+	{
+		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.ispctl1_reg	= 0x03,
+	}, {
+		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.ispctl1_reg	= 0x02,
+	}, {
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.ispctl1_reg	= 0,
+	}, {
+		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.ispctl1_reg	= 0x01,
+	}, {
+		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.ispctl1_reg	= 0x40,
+	},
+};
+
+/* page 0 - window size and position within pixel matrix */
+static const struct i2c_regval vga_regs[] = {
+	/* (offset, value) */
+	{ WIN_ROWH_REG, 0x00 },
+	{ WIN_ROWL_REG, 0x06 },
+	{ WIN_COLH_REG, 0x00 },
+	{ WIN_COLL_REG, 0x06 },
+	{ WIN_HEIGHTH_REG, 0x01 },
+	{ WIN_HEIGHTL_REG, 0xE0 },
+	{ WIN_WIDTHH_REG, 0x02 },
+	{ WIN_WIDTHL_REG, 0x80 },
+	{ HBLANKH_REG, 0x01 },
+	{ HBLANKL_REG, 0x50 },
+	{ VSYNCH_REG, 0x00 },
+	{ VSYNCL_REG, 0x14 },
+	{ REG_TERM, 0 },
+};
+
+/* page 10 - offsets and thresholds for color saturation control */
+static const struct i2c_regval color_sat_cfg[] = {
+	{ ISP_CTL_REG(1), 0x30 },
+	{ YOFS_REG, 0x80 },
+	{ DARK_YOFS_REG, 0x04 },
+	{ AG_ABRTH_REG, 0x78 },
+	{ SAT_CTL_REG, 0x1F },
+	{ BSAT_REG, 0x90 },
+	{ AG_SAT_TH_REG, 0xF0 },
+	{ PAGE_REG(10, 0x64), 0x80 },
+	{ REG_TERM, 0 },
+};
+
+/* page 11 - Z-LPF filter setup */
+static const struct i2c_regval zlpf_cfg[] = {
+	{ ZLPF_CTRL_REG, 0x99 },
+	{ ZLPF_CTRL2_REG, 0x0e },
+	{ ZLPF_AGH_THR_REG, 0x29 },
+	{ ZLPF_THR_REG, 0x0F },
+	{ ZLPF_DYN_THR_REG, 0x63 },
+	{ REG_TERM, 0 },
+};
+
+/* page 12 - YC-LPF and BLPF filter setup */
+static const struct i2c_regval yc_blpf_cfg[] = {
+	{ YCLPF_CTL1_REG, 0x23 },
+	{ YCLPF_CTL2_REG, 0x3B },
+	{ YCLPF_THR_REG, 0x05 },
+	{ BLPF_CTL_REG, 0x1D },
+	{ BLPF_THR1_REG, 0x05 },
+	{ BLPF_THR2_REG, 0x04 },
+	{ REG_TERM, 0 },
+};
+
+static const struct i2c_regval auto_wb_cfg[] = {
+	{ AWB_CTL2_REG, 0x26 },
+	{ AWB_RMAX_REG, 0x54 },
+	{ AWB_RMIN_REG, 0x2B },
+	{ AWB_BMAX_REG, 0x57 },
+	{ AWB_BMIN_REG, 0x29 },
+	{ AWB_RMAXB_REG, 0x50 },
+	{ AWB_RMINB_REG, 0x43 },
+	{ AWB_BMAXB_REG, 0x30 },
+	{ AWB_BMINB_REG, 0x22 },
+	{ REG_TERM, 0 },
+};
+
+/* page 20 */
+static const struct i2c_regval auto_exposure_cfg[] = {
+	{ AE_CTL1_REG, 0x0C },
+	{ AE_CTL2_REG, 0x04 },
+	{ AE_FRM_CTL_REG, 0x01 },
+	{ AE_FINE_CTL_REG(1), 0x3F },
+	{ AE_FINE_CTL_REG(2), 0xA3 },
+	{ AE_FINE_CTL_REG(4), 0x34 },
+	{ REG_TERM, 0 },
+};
+
+static inline struct sr030pc30_info *to_sr030pc30(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct sr030pc30_info, sd);
+}
+
+static inline int set_i2c_page(struct sr030pc30_info *info,
+			       struct i2c_client *client, unsigned int reg)
+{
+	int ret;
+	u32 page = GET_PAGE(reg);
+
+	if (info->i2c_reg_page != page && (reg & 0xFF) != 0x03) {
+		ret = i2c_smbus_write_byte_data(client, PAGEMODE_REG, page);
+		if (!ret)
+			info->i2c_reg_page = page;
+	}
+	return ret;
+}
+
+static inline int cam_i2c_read(struct v4l2_subdev *sd, u32 reg_addr)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
+
+	ret = set_i2c_page(info, client, reg_addr);
+	if (!ret)
+		ret = i2c_smbus_read_byte_data(client, reg_addr & 0xFF);
+	return ret;
+}
+
+static int cam_i2c_write(struct v4l2_subdev *sd, u32 reg_addr, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
+
+	ret = set_i2c_page(info, client, reg_addr);
+	if (!ret)
+		ret = i2c_smbus_write_byte_data(client,
+						reg_addr & 0xFF, val);
+	return ret;
+}
+
+static inline int sr030pc30_bulk_write_reg(struct v4l2_subdev *sd,
+				const struct i2c_regval *msg)
+{
+	int ret;
+	while (msg->addr != REG_TERM) {
+		ret = cam_i2c_write(sd, msg->addr, msg->val);
+		if (ret)
+			break;
+		msg++;
+	}
+	return ret;
+}
+
+/* Device reset and sleep mode control */
+static inline int sr030pc30_pwr_ctrl(struct v4l2_subdev *sd,
+				     bool reset, bool sleep)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	u8 reg = sleep ? 0xF1 : 0xF0;
+	int ret = 0;
+
+	if (reset)
+		ret = cam_i2c_write(sd, POWER_CTRL_REG, reg | 0x02);
+	if (!ret) {
+		ret = cam_i2c_write(sd, POWER_CTRL_REG, reg);
+		if (!ret) {
+			info->sleep = sleep;
+			if (reset)
+				info->i2c_reg_page = -1;
+		}
+	}
+	return ret;
+}
+
+/* Lens shading compensation */
+static int sr030pc30_configure_lens_shading(struct v4l2_subdev *sd,
+					    bool enable)
+{
+	return cam_i2c_write(sd, LENS_CTRL_REG, enable ? 1 : 0) +
+		cam_i2c_write(sd, LENS_XCEN_REG, 128) +
+		cam_i2c_write(sd, LENS_YCEN_REG, 112) +
+		cam_i2c_write(sd, LENS_R_COMP_REG, 0x53) +
+		cam_i2c_write(sd, LENS_G_COMP_REG, 0x40) +
+		cam_i2c_write(sd, LENS_B_COMP_REG, 0x3e);
+}
+
+/* Noise reduction */
+static int sr030pc30_configure_noise_red(struct v4l2_subdev *sd,
+					 bool enable)
+{
+	return sr030pc30_bulk_write_reg(sd, zlpf_cfg) +
+		sr030pc30_bulk_write_reg(sd, yc_blpf_cfg);
+}
+
+/* Automatic white balance control */
+static int sr030pc30_enable_auto_wb(struct v4l2_subdev *sd, int on)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	s32 reg, ret = -EIO;
+
+	reg = cam_i2c_read(sd, AWB_CTL2_REG);
+	if (reg >= 0) {
+		if (on)
+			reg &= ~MWB_ENABLE;
+		else
+			reg |= MWB_ENABLE;
+		ret = cam_i2c_write(sd, AWB_CTL2_REG, reg);
+	}
+
+	reg = cam_i2c_read(sd, AWB_CTL1_REG);
+	if (reg >= 0) {
+		if (on)
+			reg |= AWB_ENABLE;
+		else
+			reg &= ~AWB_ENABLE;
+		ret = cam_i2c_write(sd, AWB_CTL1_REG, reg);
+		if (!ret)
+			info->auto_wb = on;
+	}
+	return ret;
+}
+
+static inline int sr030pc30_enable_auto_exp(struct v4l2_subdev *sd,
+					    int on)
+{
+	/* auto anti-flicker is also enabled here */
+	return cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
+}
+
+static int sr030pc30_configure_autoexp(struct v4l2_subdev *sd, int on)
+{
+	return sr030pc30_bulk_write_reg(sd, auto_exposure_cfg) +
+		cam_i2c_write(sd, AE_CTL2_REG, 0x04) +
+		sr030pc30_enable_auto_exp(sd, on);
+}
+
+static int sr030pc30_set_exposure(struct v4l2_subdev *sd, int value)
+{
+	int ret;
+
+	ret = sr030pc30_enable_auto_exp(sd, false);
+	if (!ret)
+		ret = cam_i2c_write(sd, EXP_TIMEH_REG,
+				      value >> 24 & 0xFF);
+	if (!ret)
+		ret = cam_i2c_write(sd, EXP_TIMEM_REG,
+				      value >> 8 & 0xFF);
+	if (!ret)
+		ret = cam_i2c_write(sd, EXP_TIMEL_REG,
+				      value & 0xFF);
+	if (!ret)
+		sr030pc30_enable_auto_exp(sd, true);
+	return ret;
+}
+
+static int sr030pc30_set_flip(struct v4l2_subdev *sd)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	s32 reg = cam_i2c_read(sd, VDO_CTL2_REG);
+	if (reg < 0)
+		return reg;
+	reg &= 0x7C;
+	if (info->hflip)
+		reg |= 0x01;
+	if (info->vflip)
+		reg |= 0x02;
+	if (info->user_win) /* enable user image size */
+		reg |= 0x80;
+	return cam_i2c_write(sd, VDO_CTL2_REG, reg);
+}
+
+static int sr030pc30_set_params(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
+
+	if (!client || !info->curr_win)
+		return -EINVAL;
+	/*
+	 * Set 640x480 window size, lower resolutions are obtained
+	 * through pixel subsampling.
+	 */
+	ret = sr030pc30_bulk_write_reg(sd, vga_regs);
+	if (!ret)
+		ret = cam_i2c_write(sd, VDO_CTL1_REG,
+					info->curr_win->subsampl);
+	if (!ret && info->curr_fmt)
+		ret = cam_i2c_write(sd, ISP_CTL_REG(1),
+				info->curr_fmt->ispctl1_reg);
+	if (!ret)
+		ret = sr030pc30_set_flip(sd);
+
+	return ret;
+}
+
+/* Find nearest matching image pixel size. */
+static int sr030pc30_try_frame_size(struct v4l2_mbus_framefmt *mf)
+{
+	unsigned int min_err = ~0;
+	int i = ARRAY_SIZE(sr030pc30_sizes);
+	const struct sr030pc30_frmsize *fsize = &sr030pc30_sizes[0],
+					*match = NULL;
+	while (i--) {
+		int err = abs(fsize->size.width - mf->width)
+				+ abs(fsize->size.height - mf->height);
+		if (err < min_err) {
+			min_err = err;
+			match = fsize;
+		}
+		fsize++;
+	}
+	if (match) {
+		mf->width  = match->size.width;
+		mf->height = match->size.height;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int sr030pc30_queryctrl(struct v4l2_subdev *sd,
+			       struct v4l2_queryctrl *qc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
+		if (qc->id == sr030pc30_ctrl[i].id) {
+			*qc = sr030pc30_ctrl[i];
+			v4l2_dbg(1, debug, sd, "%s id: %d\n",
+				 __func__, qc->id);
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static int sr030pc30_s_ctrl(struct v4l2_subdev *sd,
+			    struct v4l2_control *ctrl)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
+		if (ctrl->id == sr030pc30_ctrl[i].id)
+			break;
+
+	if (i == ARRAY_SIZE(sr030pc30_ctrl))
+		return -EINVAL;
+
+	if (ctrl->value < sr030pc30_ctrl[i].minimum ||
+		ctrl->value > sr030pc30_ctrl[i].maximum)
+			return -ERANGE;
+
+	v4l2_dbg(1, debug, sd, "%s: ctrl_id: %d, value: %d\n",
+			 __func__, ctrl->id, ctrl->value);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = sr030pc30_enable_auto_wb(sd, ctrl->value);
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		ret = cam_i2c_write(sd, AWB_BGAIN_REG, ctrl->value);
+		if (!ret)
+			info->blue_balance = ctrl->value;
+		break;
+	case V4L2_CID_RED_BALANCE:
+		ret = cam_i2c_write(sd, AWB_RGAIN_REG, ctrl->value);
+		if (!ret)
+			info->red_balance = ctrl->value;
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = sr030pc30_enable_auto_exp(sd,
+				ctrl->value == V4L2_EXPOSURE_AUTO);
+		if (!ret)
+			info->auto_exp = ctrl->value;
+		break;
+	case V4L2_CID_EXPOSURE:
+		ret = sr030pc30_set_exposure(sd, ctrl->value);
+		if (!ret)
+			info->exposure = ctrl->value;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	v4l2_dbg(1, debug, sd, "%s ret= %d\n", __func__, ret);
+
+	/* disable AWB if required */
+	if (!ret && ctrl->id != V4L2_CID_AUTO_WHITE_BALANCE)
+		sr030pc30_enable_auto_wb(sd, false);
+
+	return ret;
+}
+
+static int sr030pc30_g_ctrl(struct v4l2_subdev *sd,
+			    struct v4l2_control *ctrl)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	v4l2_dbg(1, debug, sd, "%s: id: %d\n", __func__, ctrl->id);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = info->auto_wb;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		ctrl->value = info->blue_balance;
+		break;
+	case V4L2_CID_RED_BALANCE:
+		ctrl->value = info->red_balance;
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ctrl->value = info->auto_exp;
+		break;
+	case V4L2_CID_EXPOSURE:
+		ctrl->value = info->exposure;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int sr030pc30_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+			      enum v4l2_mbus_pixelcode *code)
+{
+	if (!code || index >= ARRAY_SIZE(sr030pc30_formats))
+		return -EINVAL;
+
+	*code = sr030pc30_formats[index].code;
+	return 0;
+}
+
+static int sr030pc30_g_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
+
+	if (!mf)
+		return -EINVAL;
+
+	if (!info->curr_win || !info->curr_fmt) {
+		ret = sr030pc30_set_params(sd);
+		if (ret)
+			return ret;
+	}
+
+	mf->width	= info->curr_win->size.width;
+	mf->height	= info->curr_win->size.height;
+	mf->code	= info->curr_fmt->code;
+	mf->colorspace	= info->curr_fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+/* Return nearest media bus frame format. */
+static const struct sr030pc30_format *try_fmt(struct v4l2_subdev *sd,
+					      struct v4l2_mbus_framefmt *mf)
+{
+	int i = ARRAY_SIZE(sr030pc30_formats);
+
+	sr030pc30_try_frame_size(mf);
+
+	while (i--)
+		if (mf->code == sr030pc30_formats[i].code)
+			break;
+
+	mf->code = sr030pc30_formats[i].code;
+
+	return &sr030pc30_formats[i];
+}
+
+/* Return nearest media bus frame format. */
+static int sr030pc30_try_fmt(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_framefmt *mf)
+{
+	if (!sd || !mf)
+		return -EINVAL;
+
+	try_fmt(sd, mf);
+	return 0;
+}
+
+static int sr030pc30_s_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	if (!sd || !mf)
+		return -EINVAL;
+
+	v4l2_dbg(1, debug, sd, "%s mf->code: %d\n",
+		 __func__, mf->code);
+
+	info->curr_fmt = try_fmt(sd, mf);
+
+	v4l2_dbg(1, debug, sd, "%s mf->code: %d\n",
+		 __func__, info->curr_fmt->code);
+
+	return sr030pc30_set_params(sd);
+}
+
+static int sr030pc30_setup(struct v4l2_subdev *sd)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	int ret;
+
+	v4l2_dbg(1, debug, sd, "%s sd: %p\n", __func__, sd);
+
+	ret = cam_i2c_write(sd, SYNC_CTL_REG, 0);
+	if (!ret)
+		ret = sr030pc30_bulk_write_reg(sd, color_sat_cfg);
+	if (!ret)
+		ret = sr030pc30_configure_autoexp(sd, true);
+	if (!ret)
+		ret = sr030pc30_bulk_write_reg(sd, auto_wb_cfg);
+	if (!ret)
+		ret = sr030pc30_configure_lens_shading(sd, true);
+	if (!ret)
+		ret = sr030pc30_set_exposure(sd, info->exposure);
+	if (!ret)
+		ret = sr030pc30_configure_noise_red(sd, true);
+	if (!ret) {
+		info->curr_fmt = &sr030pc30_formats[0];
+		info->curr_win = &sr030pc30_sizes[0];
+		ret = sr030pc30_set_params(sd);
+	}
+	if (!ret)
+		ret = sr030pc30_pwr_ctrl(sd, false, false);
+
+	if (!ret)
+		v4l2_dbg(1, debug, sd,
+			"%s: %dx%d, pixelcode: 0x%X", __func__,
+			info->curr_win->size.width,
+			info->curr_win->size.height,
+			info->curr_fmt->code);
+	return ret;
+}
+
+static int sr030pc30_s_config(struct v4l2_subdev *sd,
+			      int irq, void *platform_data)
+{
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	info->pdata = platform_data;
+	return 0;
+}
+
+static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	return 0;
+}
+
+static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+	const struct sr030pc30_platform_data *pdata = info->pdata;
+	int ret;
+
+	if (WARN(pdata == NULL, "platform data is not set"))
+		return -ENOMEM;
+
+	/*
+	 * Put sensor into power sleep mode before switching off
+	 * power and disabling MCLK
+	 */
+	if (!on)
+		sr030pc30_pwr_ctrl(sd, false, true);
+
+	/* set_power controls sensor's power and clock */
+	if (pdata->set_power) {
+		ret = pdata->set_power(&client->dev, on);
+		if (ret)
+			return ret;
+	}
+
+	if (on) {
+		ret = sr030pc30_setup(sd);
+	} else {
+		info->curr_win = NULL;
+		info->curr_fmt = NULL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
+	.s_config	= sr030pc30_s_config,
+	.s_power	= sr030pc30_s_power,
+	.queryctrl	= sr030pc30_queryctrl,
+	.s_ctrl		= sr030pc30_s_ctrl,
+	.g_ctrl		= sr030pc30_g_ctrl,
+};
+
+static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
+	.s_stream	= sr030pc30_s_stream,
+	.g_mbus_fmt	= sr030pc30_g_fmt,
+	.s_mbus_fmt	= sr030pc30_s_fmt,
+	.try_mbus_fmt	= sr030pc30_try_fmt,
+	.enum_mbus_fmt	= sr030pc30_enum_fmt,
+};
+
+static const struct v4l2_subdev_ops sr030pc30_ops = {
+	.core	= &sr030pc30_core_ops,
+	.video	= &sr030pc30_video_ops,
+};
+
+static int sr030pc30_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct sr030pc30_info *info;
+	struct v4l2_subdev *sd;
+	const struct sr030pc30_platform_data *pdata
+		= client->dev.platform_data;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&client->dev, "Platform data is not set");
+		return -EIO;
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	sd = &info->sd;
+	strcpy(sd->name, MODULE_NAME);
+	info->pdata = client->dev.platform_data;
+
+	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
+
+	/* Enable sensor's power to identify it's type */
+	if (pdata->set_power) {
+		ret = pdata->set_power(&client->dev, 1);
+		if (ret)
+			return ret;
+	}
+
+	ret = cam_i2c_read(sd, DEVICE_ID_REG);
+
+	if (pdata->set_power)
+		pdata->set_power(&client->dev, 0);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: I2C read failed\n", __func__);
+		return ret;
+	}
+	/* Don't bother with other I2C devices than SR030PC30 */
+	if (ret != SR030PC30_ID)
+		return -ENODEV;
+
+	info->i2c_reg_page = -1;
+	info->hflip = 1;
+	/* Enable window setup with WIN_* registers */
+	info->user_win = 1;
+	info->auto_exp = 1;
+	info->exposure = 50000;
+
+	return 0;
+}
+
+static int sr030pc30_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct sr030pc30_info *info = to_sr030pc30(sd);
+
+	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
+	kfree(info);
+	return 0;
+}
+
+static const struct i2c_device_id sr030pc30_id[] = {
+	{ MODULE_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, sr030pc30_id);
+
+
+static struct i2c_driver sr030pc30_i2c_driver = {
+	.driver = {
+		.name = MODULE_NAME
+	},
+	.probe		= sr030pc30_probe,
+	.remove		= sr030pc30_remove,
+	.id_table	= sr030pc30_id,
+};
+
+static int __init sr030pc30_init(void)
+{
+	return i2c_add_driver(&sr030pc30_i2c_driver);
+}
+
+static void __exit sr030pc30_exit(void)
+{
+	i2c_del_driver(&sr030pc30_i2c_driver);
+}
+
+module_init(sr030pc30_init);
+module_exit(sr030pc30_exit);
+
+MODULE_DESCRIPTION("Siliconfile SR030PC30 camera driver");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/media/sr030pc30.h b/include/media/sr030pc30.h
new file mode 100644
index 0000000..6c9791b
--- /dev/null
+++ b/include/media/sr030pc30.h
@@ -0,0 +1,21 @@
+/*
+ * Driver header for SR030PC30 camera sensor
+ *
+ * Copyright (c) 2009 - 2010 Samsung Electronics, Co. Ltd
+ * Contact: Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef SR030PC30_H
+#define SR030PC30_H
+
+struct sr030pc30_platform_data {
+	unsigned long clk_rate;	/* master clock frequency in Hz */
+	int (*set_power)(struct device *dev, int on);
+};
+
+#endif
-- 
1.7.3.1

