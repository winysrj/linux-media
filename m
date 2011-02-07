Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:56203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1BGLoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 06:44:39 -0500
MIME-version: 1.0
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LG800DZFWMCSJ20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Feb 2011 20:44:36 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LG800LF4WMC00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Feb 2011 20:44:36 +0900 (KST)
Date: Mon, 07 Feb 2011 20:44:33 +0900
From: Heungjun Kim <riverful.kim@samsung.com>
Subject: [PATCH v4] Add support for M5MO-LS 8 Mega Pixel camera
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, Heungjun Kim <riverful.kim@samsung.com>
Message-id: <1297079073-10916-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add I2C/V4L2 subdev driver for M5MO-LS camera sensor with integrated
image processor.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---

Hello,

This is fourth version of M5MOLS 8 Mega Pixel camera sensor.

The fourth version changes are below:
1. combine splitted i2c_transfer functions to single I2C operation
2. remove unneeded checking for control values
3. fix some typos and code clean

The third version changes are below:
1. the method to writing register accordint to state value
2. changing mdelay to usleep_range because of not hogging

The second versions changes are below:
1. remove I2C function macro, and use static inline for type-safe.
2. use the v4l2 control framework documented at v4l2-control.txt.
3. Add regulator enable/disable functions
4. fix any coding problems

The first version patch is here:
http://www.spinics.net/lists/linux-media/msg26246.html

This driver is tested on s5pc210 board using s5p-fimc driver.

Thanks for any ideas.

Regards,
	Heungjun Kim
	Samsung Electronics DMC R&D Center
---
 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/m5mols/Kconfig           |    6 +
 drivers/media/video/m5mols/Makefile          |    3 +
 drivers/media/video/m5mols/m5mols.h          |  233 +++++++
 drivers/media/video/m5mols/m5mols_controls.c |  165 +++++
 drivers/media/video/m5mols/m5mols_core.c     |  911 ++++++++++++++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h      |  103 +++
 include/media/m5mols.h                       |   31 +
 9 files changed, 1455 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/m5mols/Kconfig
 create mode 100644 drivers/media/video/m5mols/Makefile
 create mode 100644 drivers/media/video/m5mols/m5mols.h
 create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
 create mode 100644 drivers/media/video/m5mols/m5mols_core.c
 create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
 create mode 100644 include/media/m5mols.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index d40a8fc..6a03aad 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -746,6 +746,8 @@ config VIDEO_NOON010PC30
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
+source "drivers/media/video/m5mols/Kconfig"
+
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 251b7ca..adb9361 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
+obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
diff --git a/drivers/media/video/m5mols/Kconfig b/drivers/media/video/m5mols/Kconfig
new file mode 100644
index 0000000..425732b
--- /dev/null
+++ b/drivers/media/video/m5mols/Kconfig
@@ -0,0 +1,6 @@
+config VIDEO_M5MOLS
+	tristate "Fujitsu M5MO-LS 8MP sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	 This driver supports Fujitsu M5MO-LS camera sensor with ISP
+
diff --git a/drivers/media/video/m5mols/Makefile b/drivers/media/video/m5mols/Makefile
new file mode 100644
index 0000000..b5d19bf
--- /dev/null
+++ b/drivers/media/video/m5mols/Makefile
@@ -0,0 +1,3 @@
+m5mols-objs	:= m5mols_core.o m5mols_controls.o
+
+obj-$(CONFIG_VIDEO_M5MOLS)		+= m5mols.o
diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
new file mode 100644
index 0000000..3b4f6e8
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -0,0 +1,233 @@
+/*
+ * Header for M5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd
+ * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef M5MOLS_H
+#define M5MOLS_H
+
+#include <media/v4l2-subdev.h>
+#include "m5mols_reg.h"
+
+#define v4l2msg(fmt, arg...)	do {				\
+	v4l2_dbg(1, m5mols_debug, &info->sd, fmt, ## arg);	\
+} while (0)
+
+extern int m5mols_debug;
+
+enum m5mols_mode {
+	MODE_SYSINIT,
+	MODE_PARMSET,
+	MODE_MONITOR,
+	MODE_UNKNOWN,
+};
+
+enum m5mols_i2c_size {
+	I2C_8BIT	= 1,
+	I2C_16BIT	= 2,
+	I2C_32BIT	= 4,
+	I2C_MAX		= 4,
+};
+
+enum m5mols_fps {
+	M5MOLS_FPS_AUTO	= 0,
+	M5MOLS_FPS_10	= 10,
+	M5MOLS_FPS_12	= 12,
+	M5MOLS_FPS_15	= 15,
+	M5MOLS_FPS_20	= 20,
+	M5MOLS_FPS_21	= 21,
+	M5MOLS_FPS_22	= 22,
+	M5MOLS_FPS_23	= 23,
+	M5MOLS_FPS_24	= 24,
+	M5MOLS_FPS_30	= 30,
+	M5MOLS_FPS_MAX	= M5MOLS_FPS_30,
+};
+
+enum m5mols_res_type {
+	M5MOLS_RES_MON,
+	/* It's not supported below yet. */
+	M5MOLS_RES_PREVIEW,
+	M5MOLS_RES_THUMB,
+	M5MOLS_RES_CAPTURE,
+	M5MOLS_RES_UNKNOWN,
+};
+
+struct m5mols_resolution {
+	u8			value;
+	enum m5mols_res_type	type;
+	u16			width;
+	u16			height;
+};
+
+struct m5mols_format {
+	enum v4l2_mbus_pixelcode code;
+	enum v4l2_colorspace colorspace;
+};
+
+struct m5mols_version {
+	u8	ctm_code;	/* customer code */
+	u8	pj_code;	/* project code */
+	u16	fw;		/* firmware version */
+	u16	hw;		/* hardware version */
+	u16	parm;		/* parameter version */
+	u16	awb;		/* AWB version */
+};
+
+struct m5mols_info {
+	struct v4l2_subdev		sd;
+	struct v4l2_mbus_framefmt	fmt;
+	struct v4l2_fract		tpf;
+
+	struct v4l2_ctrl_handler	handle;
+	struct {
+		/* support only AE of the Monitor Mode in this version */
+		struct v4l2_ctrl	*autoexposure;
+		struct v4l2_ctrl	*exposure;
+	};
+	struct v4l2_ctrl		*autowb;
+	struct v4l2_ctrl		*colorfx;
+	struct v4l2_ctrl		*saturation;
+
+	enum m5mols_mode		mode;
+	enum m5mols_mode		mode_backup;
+
+	struct m5mols_version		ver;
+	int				gpio_nrst;
+	int				supply_size;
+	struct regulator_bulk_data	*supply;
+	bool				power;
+	int (*set_power)(struct device *dev, int on);
+};
+
+/* control functions */
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
+
+/* I2C functions - referenced by below I2C helper functions */
+int m5mols_read_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 *val);
+int m5mols_write_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 val);
+int m5mols_check_busy(struct v4l2_subdev *sd,
+		u8 category, u8 cmd, u32 value);
+int m5mols_set_mode(struct v4l2_subdev *sd, enum m5mols_mode mode);
+
+/*
+ * helper functions
+ */
+static inline struct m5mols_info *to_m5mols(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct m5mols_info, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct m5mols_info, handle)->sd;
+}
+
+static inline bool is_streaming(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	return info->mode == MODE_MONITOR;
+}
+
+static inline bool is_stopped(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	return info->mode != MODE_MONITOR;
+}
+
+static inline bool is_powerup(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	return info->power;
+}
+
+static inline bool is_powerdown(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	return !info->power;
+}
+
+static inline int __must_check i2c_w8_system(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_SYSTEM, cmd, val);
+}
+
+static inline int __must_check i2c_w8_param(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_PARAM, cmd, val);
+}
+
+static inline int __must_check i2c_w8_mon(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_MON, cmd, val);
+}
+
+static inline int __must_check i2c_w8_ae(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check i2c_w16_ae(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_16BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check i2c_w8_wb(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_WB, cmd, val);
+}
+
+static inline int __must_check i2c_w8_flash(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_FLASH, cmd, val);
+}
+
+static inline int __must_check i2c_r8_system(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_SYSTEM, cmd, val);
+}
+
+static inline int __must_check i2c_r8_param(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_PARAM, cmd, val);
+}
+
+static inline int __must_check i2c_r8_mon(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_MON, cmd, val);
+}
+
+static inline int __must_check i2c_r8_ae(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check i2c_r16_ae(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_16BIT, CAT_AE, cmd, val);
+}
+
+#endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
new file mode 100644
index 0000000..cc83b62
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -0,0 +1,165 @@
+/*
+ * Controls for M5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd
+ * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+
+#include "m5mols.h"
+#include "m5mols_reg.h"
+
+static int m5mols_set_ae_lock(struct m5mols_info *info, bool lock)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w8_ae(sd, CAT3_AE_LOCK, lock);
+}
+
+static int m5mols_set_awb_lock(struct m5mols_info *info, bool lock)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w8_wb(sd, CAT6_AWB_LOCK, lock);
+}
+
+static int m5mols_wb_mode(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	static u8 m5mols_wb_auto[] = { 0x1, 0x2, };	/* 0:Auto , 1:Manual */
+	int ret;
+
+	if (ctrl->val < 0 || ctrl->val > 1)
+		return -EINVAL;
+
+	ret = m5mols_set_awb_lock(info, false);
+	if (!ret)
+		ret = i2c_w8_wb(sd, CAT6_AWB_MODE, m5mols_wb_auto[ctrl->val]);
+
+	return ret;
+}
+
+static int m5mols_exposure_mode(struct m5mols_info *info,
+		struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+	u8 val;
+
+	val = (ctrl->val == V4L2_EXPOSURE_AUTO);
+
+	ret = m5mols_set_ae_lock(info, false);
+	if (ret)
+		return ret;
+
+	return i2c_w8_ae(sd, CAT3_AE_MODE, val);
+}
+
+static int m5mols_exposure(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w16_ae(sd, CAT3_MANUAL_GAIN_MON_1, info->exposure->val);
+}
+
+static int m5mols_set_saturation(struct m5mols_info *info,
+		struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	static u8 m5mols_chroma_lvl[] = {
+		0x1c, 0x3e, 0x5f, 0x80, 0xa1, 0xc2, 0xe4,
+	};
+	int ret;
+
+	ret = i2c_w8_mon(sd, CAT2_CHROMA_LVL, m5mols_chroma_lvl[ctrl->val]);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CHROMA_EN, true);
+
+	return ret;
+}
+
+static int m5mols_set_colorfx(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	static u8 m5mols_effects_gamma[] = {	/* cat 1: Effects */
+		[V4L2_COLORFX_NEGATIVE]		= 0x01,
+		[V4L2_COLORFX_EMBOSS]		= 0x06,
+		[V4L2_COLORFX_SKETCH]		= 0x07,
+	};
+	static u8 m5mols_cfixb_chroma[] = {	/* cat 2: Cr for effect */
+		[V4L2_COLORFX_BW]		= 0x0,
+		[V4L2_COLORFX_SEPIA]		= 0xd8,
+		[V4L2_COLORFX_SKY_BLUE]		= 0x40,
+		[V4L2_COLORFX_GRASS_GREEN]	= 0xe0,
+	};
+	static u8 m5mols_cfixr_chroma[] = {	/* cat 2: Cb for effect */
+		[V4L2_COLORFX_BW]		= 0x0,
+		[V4L2_COLORFX_SEPIA]		= 0x18,
+		[V4L2_COLORFX_SKY_BLUE]		= 0x00,
+		[V4L2_COLORFX_GRASS_GREEN]	= 0xe0,
+	};
+	int ret = -EINVAL;
+
+	switch (ctrl->val) {
+	case V4L2_COLORFX_NONE:
+		return i2c_w8_mon(sd, CAT2_COLOR_EFFECT, false);
+	case V4L2_COLORFX_BW:		/* chroma: Gray */
+	case V4L2_COLORFX_SEPIA:	/* chroma: Sepia */
+	case V4L2_COLORFX_SKY_BLUE:	/* chroma: Blue */
+	case V4L2_COLORFX_GRASS_GREEN:	/* chroma: Green */
+		ret = i2c_w8_mon(sd, CAT2_CFIXB,
+				m5mols_cfixb_chroma[ctrl->val]);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_CFIXR,
+					m5mols_cfixr_chroma[ctrl->val]);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_COLOR_EFFECT, true);
+		return ret;
+	case V4L2_COLORFX_NEGATIVE:	/* gamma: Negative */
+	case V4L2_COLORFX_EMBOSS:	/* gamma: Emboss */
+	case V4L2_COLORFX_SKETCH:	/* gamma: Outline */
+		ret = i2c_w8_param(sd, CAT1_EFFECT,
+				m5mols_effects_gamma[ctrl->val]);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_COLOR_EFFECT, true);
+		return ret;
+	}
+
+	return ret;
+}
+
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (!ctrl->is_new)
+			ctrl->val = V4L2_EXPOSURE_MANUAL;
+		ret = m5mols_exposure_mode(info, ctrl);
+		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
+			ret = m5mols_exposure(info);
+		return ret;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		return m5mols_wb_mode(info, ctrl);
+	case V4L2_CID_SATURATION:
+		return m5mols_set_saturation(info, ctrl);
+	case V4L2_CID_COLORFX:
+		return m5mols_set_colorfx(info, ctrl);
+	}
+
+	return -EINVAL;
+}
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
new file mode 100644
index 0000000..438d0b7
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -0,0 +1,911 @@
+/*
+ * Driver for M5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd
+ * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/m5mols.h>
+
+#include "m5mols.h"
+#include "m5mols_reg.h"
+
+int m5mols_debug;
+
+module_param(m5mols_debug, int, 0644);
+
+#define MOD_NAME		"M5MOLS"
+#define M5MOLS_I2C_CHECK_RETRY	50
+
+/* M5MOLS mode */
+static u8 m5mols_reg_mode[] = {
+	[MODE_SYSINIT]		= 0x00,
+	[MODE_PARMSET]		= 0x01,
+	[MODE_MONITOR]		= 0x02,
+	[MODE_UNKNOWN]		= 0xff,
+};
+
+/* M5MOLS regulator consumer names */
+static const char *supply_names[] = {
+	/* The DEFAULT names of power are referenced with M5MO datasheet. */
+	"core",		/* core power - 1.2v, generally at the M5MOLS */
+	"d_sensor",	/* sensor power 1 - 1.8v */
+	"dig_18",	/* digital power 1 - 1.8v */
+	"dig_28",	/* digital power 2 - 2.8v */
+	"a_sensor",	/* analog power */
+	"dig_12",	/* digital power 3 - 1.2v */
+};
+
+/* M5MOLS default format (codes, sizes, preset values) */
+static const struct v4l2_mbus_framefmt default_fmt = {
+	.width		= 1920,
+	.height		= 1080,
+	.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+	.field		= V4L2_FIELD_NONE,
+	.colorspace	= V4L2_COLORSPACE_JPEG,
+};
+
+static const struct m5mols_format m5mols_formats[] = {
+	{
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+
+static const struct m5mols_resolution m5mols_resolutions[] = {
+	/* monitor size */
+	{ 0x01, M5MOLS_RES_MON, 128, 96 },	/* SUB-QCIF */
+	{ 0x03, M5MOLS_RES_MON, 160, 120 },	/* QQVGA */
+	{ 0x05, M5MOLS_RES_MON, 176, 144 },	/* QCIF */
+	{ 0x06, M5MOLS_RES_MON, 176, 176 },	/* 176*176 */
+	{ 0x08, M5MOLS_RES_MON, 240, 320 },	/* 1 QVGA */
+	{ 0x09, M5MOLS_RES_MON, 320, 240 },	/* QVGA */
+	{ 0x0c, M5MOLS_RES_MON, 240, 400 },	/* l WQVGA */
+	{ 0x0d, M5MOLS_RES_MON, 400, 240 },	/* WQVGA */
+	{ 0x0e, M5MOLS_RES_MON, 352, 288 },	/* CIF */
+	{ 0x13, M5MOLS_RES_MON, 480, 360 },	/* 480*360 */
+	{ 0x15, M5MOLS_RES_MON, 640, 360 },	/* qHD */
+	{ 0x17, M5MOLS_RES_MON, 640, 480 },	/* VGA */
+	{ 0x18, M5MOLS_RES_MON, 720, 480 },	/* 720x480 */
+	{ 0x1a, M5MOLS_RES_MON, 800, 480 },	/* WVGA */
+	{ 0x1f, M5MOLS_RES_MON, 800, 600 },	/* SVGA */
+	{ 0x21, M5MOLS_RES_MON, 1280, 720 },	/* HD */
+	{ 0x25, M5MOLS_RES_MON, 1920, 1080 },	/* 1080p */
+	{ 0x29, M5MOLS_RES_MON, 3264, 2448 },	/* 8M (2.63fps@3264*2448) */
+	{ 0x30, M5MOLS_RES_MON, 320, 240 },	/* 60fps for slow motion */
+	{ 0x31, M5MOLS_RES_MON, 320, 240 },	/* 120fps for slow motion */
+	{ 0x39, M5MOLS_RES_MON, 800, 602 },	/* AHS_MON debug */
+};
+
+/* M5MOLS default FPS */
+static const struct v4l2_fract default_fps = {
+	.numerator		= 1,
+	.denominator		= M5MOLS_FPS_AUTO,
+};
+
+static u8 m5mols_reg_fps[] = {
+	[M5MOLS_FPS_AUTO]	= 0x01,
+	[M5MOLS_FPS_10]		= 0x05,
+	[M5MOLS_FPS_12]		= 0x04,
+	[M5MOLS_FPS_15]		= 0x03,
+	[M5MOLS_FPS_20]		= 0x08,
+	[M5MOLS_FPS_21]		= 0x09,
+	[M5MOLS_FPS_22]		= 0x0a,
+	[M5MOLS_FPS_23]		= 0x0b,
+	[M5MOLS_FPS_24]		= 0x07,
+	[M5MOLS_FPS_30]		= 0x02,
+};
+
+static u32 m5mols_swap_byte(u8 *data, enum m5mols_i2c_size size)
+{
+	if (size == I2C_8BIT)
+		return *data;
+
+	if (size == I2C_16BIT)
+		return be16_to_cpu(*((u16 *)data));
+
+	return be32_to_cpu(*((u32 *)data));
+}
+
+/*
+ * m5mols_read_reg/m5mols_write_reg - handle sensor's I2C communications.
+ *
+ * The I2C command packet of M5MOLS is made up 3 kinds of I2C bytes(category,
+ * command, bytes). Reference m5mols.h.
+ *
+ * The packet is needed 2, when M5MOLS is read through I2C.
+ * The packet is needed 1, when M5MOLS is written through I2C.
+ *
+ * I2C packet common order(including both reading/writing)
+ *   1st : size (data size + 4)
+ *   2nd : READ/WRITE (R - 0x01, W - 0x02)
+ *   3rd : Category
+ *   4th : Command
+ *
+ * I2C packet order for READING operation
+ *   5th : data real size for reading
+ *   And, read another I2C packet again, until data size.
+ *
+ * I2C packet order for WRITING operation
+ *   5th to 8th: an actual data to write
+ */
+
+#define M5MOLS_BYTE_READ	0x01
+#define M5MOLS_BYTE_WRITE	0x02
+
+int m5mols_read_reg(struct v4l2_subdev *sd,
+		enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 *val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct i2c_msg msg[2];
+	u8 wbuf[5], rbuf[I2C_MAX + 1];
+	int ret;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	if (size != I2C_8BIT && size != I2C_16BIT && size != I2C_32BIT)
+		return -EINVAL;
+
+	/* 1st I2C operation for writing category & command. */
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 5;		/* 1(cmd size per bytes) + 4 */
+	msg[0].buf = wbuf;
+	wbuf[0] = 5;		/* same as above */
+	wbuf[1] = M5MOLS_BYTE_READ;
+	wbuf[2] = category;
+	wbuf[3] = cmd;
+	wbuf[4] = size;
+
+	/* 2nd I2C operation for reading data. */
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = size + 1;
+	msg[1].buf = rbuf;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed READ[%d] at "
+				"cat[%02x] cmd[%02x]\n",
+				size, category, cmd);
+		return ret;
+	}
+
+	*val = m5mols_swap_byte(&rbuf[1], size);
+
+	usleep_range(15000, 20000);	/* must be for stabilization */
+
+	return 0;
+}
+
+int m5mols_write_reg(struct v4l2_subdev *sd,
+		enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	struct i2c_msg msg[1];
+	u8 wbuf[I2C_MAX + 4];
+	u32 *buf = (u32 *)&wbuf[4];
+	int ret;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	if (size != I2C_8BIT && size != I2C_16BIT && size != I2C_32BIT) {
+		dev_err(cdev, "Wrong data size\n");
+		return -EINVAL;
+	}
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = size + 4;
+	msg->buf = wbuf;
+	wbuf[0] = size + 4;
+	wbuf[1] = M5MOLS_BYTE_WRITE;
+	wbuf[2] = category;
+	wbuf[3] = cmd;
+
+	*buf = m5mols_swap_byte((u8 *)&val, size);
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed WRITE[%d] at "
+				"cat[%02x] cmd[%02x], ret %d\n",
+				size, msg->buf[2], msg->buf[3], ret);
+		return ret;
+	}
+
+	usleep_range(15000, 20000);	/* must be for stabilization */
+
+	return 0;
+}
+
+int m5mols_check_busy(struct v4l2_subdev *sd,
+		u8 category, u8 cmd, u32 value)
+{
+	u32 busy, i;
+	int ret;
+
+	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
+		ret = m5mols_read_reg(sd, I2C_8BIT, category, cmd, &busy);
+		if (ret < 0)
+			return ret;
+
+		if (busy == value)	/* bingo */
+			return 0;
+
+		mdelay(1);
+	}
+
+	return -EBUSY;
+}
+
+/*
+ * m5mols_set_mode - change and set mode of M5MOLS.
+ *
+ * This driver supports now only 3 modes(System, Monitor, Parameter).
+ */
+int m5mols_set_mode(struct v4l2_subdev *sd, enum m5mols_mode mode)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	const char *m5mols_str_mode[] = {
+		"System initialization",
+		"Parameter setting",
+		"Monitor setting",
+		"Unknown",
+	};
+	int ret = 0;
+
+	if (mode < MODE_SYSINIT || mode > MODE_UNKNOWN)
+		return -EINVAL;
+
+	ret = i2c_w8_system(sd, CAT0_SYSMODE, m5mols_reg_mode[mode]);
+	if (!ret)
+		ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_SYSMODE,
+				m5mols_reg_mode[mode]);
+	if (ret < 0)
+		return ret;
+
+	info->mode = m5mols_reg_mode[mode];
+	dev_dbg(cdev, " mode: %s\n", m5mols_str_mode[mode]);
+
+	return ret;
+}
+
+int m5mols_set_mode_backup(struct v4l2_subdev *sd,
+		enum m5mols_mode mode)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+
+	info->mode_backup = info->mode;
+	return m5mols_set_mode(sd, mode);
+}
+
+int m5mols_set_mode_restore(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	ret = m5mols_set_mode(sd, info->mode_backup);
+	if (!ret)
+		info->mode = info->mode_backup;
+	return ret;
+}
+
+/*
+ * get_version - get M5MOLS sensor versions.
+ */
+static int get_version(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	union {
+		struct m5mols_version	ver;
+		u8			bytes[10];
+	} value;
+	int ret, i;
+
+	for (i = CAT0_CUSTOMER_CODE; i <= CAT0_VERSION_AWB_L; i++) {
+		ret = i2c_r8_system(sd, i, (u32 *)&value.bytes[i]);
+		if (ret)
+			return ret;
+	}
+
+	info->ver = value.ver;
+
+	info->ver.fw = be16_to_cpu(info->ver.fw);
+	info->ver.hw = be16_to_cpu(info->ver.hw);
+	info->ver.parm = be16_to_cpu(info->ver.parm);
+	info->ver.awb = be16_to_cpu(info->ver.awb);
+
+	return ret;
+}
+
+static void m5mols_show_version(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	struct m5mols_info *info = to_m5mols(sd);
+
+	dev_info(dev, "customer code\t0x%02x\n", info->ver.ctm_code);
+	dev_info(dev, "project code\t0x%02x\n", info->ver.pj_code);
+	dev_info(dev, "firmware version\t0x%04x\n", info->ver.fw);
+	dev_info(dev, "hardware version\t0x%04x\n", info->ver.hw);
+	dev_info(dev, "parameter version\t0x%04x\n", info->ver.parm);
+	dev_info(dev, "AWB version\t0x%04x\n", info->ver.awb);
+}
+
+/*
+ * get_res_preset - find out M5MOLS register value from requested resolution.
+ *
+ * @width: requested width
+ * @height: requested height
+ * @type: requested type of each modes. It supports only monitor mode now.
+ */
+static int get_res_preset(struct v4l2_subdev *sd, u16 width, u16 height,
+		enum m5mols_res_type type)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(m5mols_resolutions); i++) {
+		if ((m5mols_resolutions[i].type == type) &&
+			(m5mols_resolutions[i].width == width) &&
+			(m5mols_resolutions[i].height == height))
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(m5mols_resolutions)) {
+		v4l2msg("no matching resolution\n");
+		return -EINVAL;
+	}
+
+	return m5mols_resolutions[i].value;
+}
+
+/*
+ * get_fps - calc & check FPS from v4l2_captureparm, if FPS is adequate, set.
+ *
+ * In M5MOLS case, the denominator means FPS. The each value of numerator and
+ * denominator should not be minus. If numerator is 0, it sets AUTO FPS. If
+ * numerator is not 1, it recalculates denominator. After it checks, the
+ * denominator is set to timeperframe.denominator, and used by FPS.
+ */
+static int get_fps(struct v4l2_subdev *sd,
+		struct v4l2_captureparm *parm)
+{
+	int numerator = parm->timeperframe.numerator;
+	int denominator = parm->timeperframe.denominator;
+
+	/* The denominator should be +, except 0. The numerator shoud be +. */
+	if (numerator < 0 || denominator <= 0)
+		return -EINVAL;
+
+	/* The numerator is 0, return auto fps. */
+	if (numerator == 0) {
+		parm->timeperframe.denominator = M5MOLS_FPS_AUTO;
+		return 0;
+	}
+
+	/* calc FPS(not time per frame) per 1 numerator */
+	denominator = denominator / numerator;
+
+	if (denominator < M5MOLS_FPS_AUTO || denominator > M5MOLS_FPS_MAX)
+		return -EINVAL;
+
+	if (!m5mols_reg_fps[denominator])
+		return -EINVAL;
+
+	return 0;
+}
+
+static int m5mols_g_mbus_fmt(struct v4l2_subdev *sd,
+		struct v4l2_mbus_framefmt *ffmt)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+
+	*ffmt = info->fmt;
+
+	return 0;
+}
+
+static int m5mols_s_mbus_fmt(struct v4l2_subdev *sd,
+		struct v4l2_mbus_framefmt *ffmt)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int size;
+	int ret = -EINVAL;
+
+	size = get_res_preset(sd, ffmt->width, ffmt->height,
+			M5MOLS_RES_MON);
+	if (size < 0)
+		return -EINVAL;
+
+	ret = m5mols_set_mode(sd, MODE_PARMSET);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, (u8)size);
+	if (!ret) {
+		info->fmt = default_fmt;
+		info->fmt.width = ffmt->width;
+		info->fmt.height = ffmt->height;
+
+		*ffmt = info->fmt;
+	}
+
+	return ret;
+}
+
+static int m5mols_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
+		enum v4l2_mbus_pixelcode *code)
+{
+	if (!code || index >= ARRAY_SIZE(m5mols_formats))
+		return -EINVAL;
+
+	*code = m5mols_formats[index].code;
+
+	return 0;
+}
+
+static int m5mols_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+			parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->timeperframe = info->tpf;
+
+	return 0;
+}
+
+static int m5mols_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+	int ret = -EINVAL;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+			parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	ret = m5mols_set_mode_backup(sd, MODE_PARMSET);
+	if (!ret)
+		ret = get_fps(sd, cp);	/* set right FPS to denominator. */
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS,
+				m5mols_reg_fps[cp->timeperframe.denominator]);
+	if (!ret)
+		ret = m5mols_set_mode_restore(sd);
+	if (!ret) {
+		cp->capability = V4L2_CAP_TIMEPERFRAME;
+		info->tpf = cp->timeperframe;
+	}
+
+	v4l2msg("denominator: %d / numerator: %d.\n",
+		cp->timeperframe.denominator, cp->timeperframe.numerator);
+
+	return ret;
+}
+
+static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	if (enable) {
+		if (is_stopped(sd))
+			return m5mols_set_mode(sd, MODE_MONITOR);
+
+		return -EINVAL;
+	}
+
+	if (is_streaming(sd))
+		return m5mols_set_mode(sd, MODE_PARMSET);
+
+	return -EINVAL;
+}
+
+static const struct v4l2_subdev_video_ops m5mols_video_ops = {
+	.g_mbus_fmt		= m5mols_g_mbus_fmt,
+	.s_mbus_fmt		= m5mols_s_mbus_fmt,
+	.enum_mbus_fmt		= m5mols_enum_mbus_fmt,
+	.g_parm			= m5mols_g_parm,
+	.s_parm			= m5mols_s_parm,
+	.s_stream		= m5mols_s_stream,
+};
+
+static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	int ret;
+
+	ret = m5mols_set_mode_backup(sd, MODE_PARMSET);
+	if (!ret)
+		ret = m5mols_set_ctrl(ctrl);
+	if (!ret)
+		ret = m5mols_set_mode_restore(sd);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
+	.s_ctrl = m5mols_s_ctrl,
+};
+
+/*
+ * m5mols_sensor_power - handle sensor power up/down.
+ *
+ * @enable: If it is true, power up. If is not, power down.
+ */
+static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	int ret;
+
+	if (enable) {
+		if (!is_powerdown(sd))
+			return 0;
+
+		if (gpio_is_valid(info->gpio_nrst))
+			gpio_set_value(info->gpio_nrst, 0);
+
+		if (info->set_power) {
+			ret = info->set_power(&c->dev, 1);
+			if (ret)
+				return ret;
+		}
+
+		ret = regulator_bulk_enable(info->supply_size,
+				info->supply);
+		if (ret)
+			return ret;
+
+		if (gpio_is_valid(info->gpio_nrst)) {
+			gpio_set_value(info->gpio_nrst, 0);
+			msleep(100);
+			gpio_set_value(info->gpio_nrst, 1);
+			msleep(100);
+		}
+
+		info->power = true;
+	} else {
+		if (!is_powerup(sd))
+			return 0;
+
+		if (gpio_is_valid(info->gpio_nrst)) {
+			gpio_set_value(info->gpio_nrst, 0);
+			msleep(100);
+		}
+
+		ret = regulator_bulk_disable(info->supply_size,
+				info->supply);
+		if (ret)
+			return ret;
+
+		if (info->set_power) {
+			ret = info->set_power(&c->dev, 0);
+			if (ret)
+				return ret;
+		}
+
+		if (gpio_is_valid(info->gpio_nrst))
+			gpio_set_value(info->gpio_nrst, 0);
+
+		info->power = false;
+	}
+
+	return ret;
+}
+
+/*
+ * m5mols_sensor_armboot - booting M5MOLS internal ARM core-controller.
+ *
+ * It makes to ready M5MOLS for I2C & MIPI interface. After it's powered up,
+ * it activates if it gets armboot command for I2C interface. After getting
+ * cmd, it must wait about least 500ms referenced by M5MOLS datasheet.
+ */
+static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	static u8 m5mols_mipi_value = 0x02;
+	int ret;
+
+	/* 1. ARM booting */
+	ret = i2c_w8_flash(sd, CAT0_INT_ROOTEN, true);
+	if (ret < 0)
+		return ret;
+
+	msleep(500);
+	dev_dbg(&client->dev, "Success ARM Booting\n");
+
+	ret = m5mols_set_mode(sd, MODE_PARMSET);
+	if (!ret)
+		ret = get_version(sd);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_DATA_INTERFACE, m5mols_mipi_value);
+
+	m5mols_show_version(sd);
+
+	return ret;
+}
+
+/*
+ * m5mols_init_controls - initialization using v4l2_ctrl.
+ */
+static int m5mols_init_controls(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 max_ex_mon;
+	int ret;
+
+	/* check minimum & maximum of M5MOLS controls */
+	ret = i2c_r16_ae(sd, CAT3_MAX_GAIN_MON_1, (u32 *)&max_ex_mon);
+	if (!ret)
+		return ret;
+
+	/* set the controls using v4l2 control frameworks */
+	v4l2_ctrl_handler_init(&info->handle, 5);
+
+	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_COLORFX,
+			9, 1, V4L2_COLORFX_NONE);
+	info->autoexposure = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
+			1, 0, V4L2_EXPOSURE_AUTO);
+	info->exposure = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
+			0, max_ex_mon, 1, (int)max_ex_mon/2);
+	info->autowb = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_WHITE_BALANCE,
+			0, 1, 1, 1);
+	info->saturation = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_SATURATION,
+			0, 6, 1, 3);
+
+	sd->ctrl_handler = &info->handle;
+	if (info->handle.error) {
+		dev_err(&client->dev, "Failed to init controls, %d\n", ret);
+		v4l2_ctrl_handler_free(&info->handle);
+		return info->handle.error;
+	}
+
+	v4l2_ctrl_cluster(2, &info->autoexposure);
+	v4l2_ctrl_handler_setup(&info->handle);
+
+	return 0;
+}
+
+/*
+ * m5mols_setup_default - set default size & fps in the monitor mode.
+ */
+static int m5mols_setup_default(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int value;
+	int ret = -EINVAL;
+
+	value = get_res_preset(sd, default_fmt.width, default_fmt.height,
+			M5MOLS_RES_MON);
+	if (value >= 0)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, (u8)value);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS,
+			m5mols_reg_fps[default_fps.denominator]);
+	if (!ret)
+		ret = m5mols_init_controls(info);
+	if (!ret) {
+		info->fmt = default_fmt;
+		info->tpf = default_fps;
+
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int m5mols_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	if (on) {
+		ret = m5mols_sensor_power(info, true);
+		if (!ret)
+			ret = m5mols_sensor_armboot(sd);
+		if (!ret)
+			ret = m5mols_setup_default(sd);
+	} else {
+		ret = m5mols_sensor_power(info, false);
+	}
+
+	return ret;
+}
+
+static int m5mols_log_status(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+
+	v4l2_ctrl_handler_log_status(&info->handle, sd->name);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops m5mols_core_ops = {
+	.s_power		= m5mols_s_power,
+	.g_ctrl			= v4l2_subdev_g_ctrl,
+	.s_ctrl			= v4l2_subdev_s_ctrl,
+	.queryctrl		= v4l2_subdev_queryctrl,
+	.querymenu		= v4l2_subdev_querymenu,
+	.g_ext_ctrls		= v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls		= v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls		= v4l2_subdev_s_ext_ctrls,
+	.log_status		= m5mols_log_status,
+};
+
+static const struct v4l2_subdev_ops m5mols_ops = {
+	.core	= &m5mols_core_ops,
+	.video	= &m5mols_video_ops,
+};
+
+static int m5mols_get_gpio(struct m5mols_info *info,
+	const struct m5mols_platform_data *pdata)
+{
+
+	if (!gpio_is_valid(pdata->gpio_nrst))
+		return -EINVAL;
+
+	if (gpio_request(pdata->gpio_nrst, "M5MOLS-NRST"))
+		return -EINVAL;
+
+	info->gpio_nrst = pdata->gpio_nrst;
+	gpio_direction_output(info->gpio_nrst, 0);
+	gpio_export(info->gpio_nrst, 0);
+
+	return 0;
+}
+
+static int m5mols_get_regulators(struct m5mols_info *info,
+		const struct m5mols_platform_data *pdata,
+		struct i2c_client *c)
+{
+	int i = 0;
+
+	info->supply = kzalloc(sizeof(struct regulator_bulk_data) *
+			ARRAY_SIZE(supply_names), GFP_KERNEL);
+	if (!info->supply)
+		return -ENOMEM;
+
+	info->supply_size = ARRAY_SIZE(supply_names);
+	for (i = 0; i < info->supply_size; i++)
+		info->supply[i].supply = supply_names[i];
+
+	return regulator_bulk_get(&c->dev, info->supply_size, info->supply);
+}
+
+static int m5mols_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	const struct m5mols_platform_data *pdata =
+		client->dev.platform_data;
+	struct m5mols_info *info;
+	struct v4l2_subdev *sd;
+	int ret = 0;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EIO;
+	}
+
+	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
+	if (info == NULL) {
+		dev_err(&client->dev, "Failed to allocate info\n");
+		return -ENOMEM;
+	}
+
+	info->set_power = pdata->set_power;
+
+	ret = m5mols_get_gpio(info, pdata);
+	if (ret) {
+		dev_err(&client->dev, "Failed to set gpio, %d\n", ret);
+		goto out_gpio;
+	}
+
+	ret = m5mols_get_regulators(info, pdata, client);
+	if (ret) {
+		dev_err(&client->dev, "Failed to get regulators, %d\n", ret);
+		goto out_reg;
+	}
+
+	sd = &info->sd;
+	strlcpy(sd->name, MOD_NAME, sizeof(sd->name));
+	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
+
+	v4l2msg("probed m5mols driver.\n");
+
+	return 0;
+
+out_reg:
+	regulator_bulk_free(info->supply_size, info->supply);
+	kfree(info->supply);
+out_gpio:
+	if (gpio_is_valid(info->gpio_nrst))
+		gpio_free(info->gpio_nrst);
+	kfree(info);
+
+	return ret;
+}
+
+static int m5mols_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct m5mols_info *info = to_m5mols(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&info->handle);
+
+	regulator_bulk_free(info->supply_size, info->supply);
+	if (gpio_is_valid(info->gpio_nrst))
+		gpio_free(info->gpio_nrst);
+
+	kfree(info->supply);
+	kfree(info);
+
+	return 0;
+}
+
+static const struct i2c_device_id m5mols_id[] = {
+	{ MOD_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, m5mols_id);
+
+static struct i2c_driver m5mols_i2c_driver = {
+	.driver = {
+		.name	= MOD_NAME,
+	},
+	.probe		= m5mols_probe,
+	.remove		= m5mols_remove,
+	.id_table	= m5mols_id,
+};
+
+static int __init m5mols_mod_init(void)
+{
+	return i2c_add_driver(&m5mols_i2c_driver);
+}
+
+static void __exit m5mols_mod_exit(void)
+{
+	i2c_del_driver(&m5mols_i2c_driver);
+}
+
+module_init(m5mols_mod_init);
+module_exit(m5mols_mod_exit);
+
+MODULE_AUTHOR("HeungJun Kim <riverful.kim@samsung.com>");
+MODULE_AUTHOR("Dongsoo Kim <dongsoo45.kim@samsung.com>");
+MODULE_DESCRIPTION("Fujitsu M5MOLS 8M Pixel camera sensor with ISP driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
new file mode 100644
index 0000000..036069e
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -0,0 +1,103 @@
+/*
+ * Register map for M5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd
+ * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef M5MOLS_REG_H
+#define M5MOLS_REG_H
+
+/*
+ * Category section register
+ *
+ * The category means a kind of command set. Including category section,
+ * all defined categories in this version supports only, as you see below:
+ */
+#define CAT_SYSTEM		0x00
+#define CAT_PARAM		0x01
+#define CAT_MON			0x02
+#define CAT_AE			0x03
+#define CAT_WB			0x06
+#define CAT_FLASH		0x0f	/* related with FW, Verions, booting */
+
+/*
+ * Category 0 - System
+ *
+ * This category supports FW version, managing mode, even interrupt.
+ */
+#define CAT0_CUSTOMER_CODE	0x00
+#define CAT0_PJ_CODE		0x01
+#define CAT0_VERSION_FW_H	0x02
+#define CAT0_VERSION_FW_L	0x03
+#define CAT0_VERSION_HW_H	0x04
+#define CAT0_VERSION_HW_L	0x05
+#define CAT0_VERSION_PARM_H	0x06
+#define CAT0_VERSION_PARM_L	0x07
+#define CAT0_VERSION_AWB_H	0x08
+#define CAT0_VERSION_AWB_L	0x09
+#define CAT0_SYSMODE		0x0b
+#define CAT0_INT_ROOTEN		0x12
+
+/*
+ * category 1 - Parameter mode
+ *
+ * This category is dealing with almost camera vendor. In spite of that,
+ * It's a register to be able to detailed value for whole camera syste.
+ * The key parameter like a resolution, FPS, data interface connecting
+ * with Mobile AP, even effects.
+ */
+#define CAT1_DATA_INTERFACE	0x00
+#define CAT1_MONITOR_SIZE	0x01
+#define CAT1_MONITOR_FPS	0x02
+#define CAT1_EFFECT		0x0b
+
+/*
+ * Category 2 - Monitor mode
+ *
+ * This category supports only monitoring mode. The monitoring mode means,
+ * similar to preview. It supports like a YUYV format. At the capture mode,
+ * it is handled like a JPEG & RAW formats.
+ */
+#define CAT2_CFIXB		0x09
+#define CAT2_CFIXR		0x0a
+#define CAT2_COLOR_EFFECT	0x0b
+#define CAT2_CHROMA_LVL		0x0f
+#define CAT2_CHROMA_EN		0x10
+
+/*
+ * Category 3 - Auto Exposure
+ *
+ * Currently, it supports only gain value with monitor mode. This device
+ * is able to support Shutter, Gain(similar with Aperture), Flicker, at
+ * monitor mode & capture mode both.
+ */
+#define CAT3_AE_LOCK		0x00
+#define CAT3_AE_MODE		0x01
+#define CAT3_MANUAL_GAIN_MON_1	0x12	/* upper byte */
+#define CAT3_MANUAL_GAIN_MON_2	0x13	/* lower byte */
+#define CAT3_MANUAL_SHUT_MON_1	0x14
+#define CAT3_MANUAL_SHUT_MON_2	0x15
+#define CAT3_MAX_SHUT_MON_1	0x16
+#define CAT3_MAX_SHUT_MON_2	0x17
+#define CAT3_MAX_GAIN_MON_1	0x1a
+#define CAT3_MAX_GAIN_MON_2	0x1b
+
+/*
+ * Category 6 - White Balance
+ *
+ * Currently, it supports only auto white balance.
+ */
+#define CAT6_AWB_LOCK		0x00
+#define CAT6_AWB_MODE		0x02
+#define CAT6_AWB_MANUAL		0x03
+
+#endif	/* M5MOLS_REG_H */
diff --git a/include/media/m5mols.h b/include/media/m5mols.h
new file mode 100644
index 0000000..bb04d76
--- /dev/null
+++ b/include/media/m5mols.h
@@ -0,0 +1,31 @@
+/*
+ * Driver for M5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd
+ * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef MEDIA_M5MOLS_H
+#define MEDIA_M5MOLS_H
+
+/**
+* struct m5mols_platform_data - platform data for M5MOLS driver
+* @gpio_nrst:  GPIO driving the reset pin of M5MOLS
+* @set_power:  an additional callback to a board setup code
+* 		to be called after enabling and before disabling
+*		the sensor device supply regulators		
+*/
+struct m5mols_platform_data {
+	int (*set_power)(struct device *dev, int on);
+	int gpio_nrst;
+};
+
+#endif	/* MEDIA_M5MOLS_H */
-- 
1.7.0.4

