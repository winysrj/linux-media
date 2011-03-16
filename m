Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:24808 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1CPNit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 09:38:49 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LI500JHNKKMJ720@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Mar 2011 22:38:46 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LI500A46KKM2T@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Mar 2011 22:38:46 +0900 (KST)
Date: Wed, 16 Mar 2011 22:38:43 +0900
From: "Kim, Heungjun" <riverful.kim@samsung.com>
Subject: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	"Kim, Heungjun" <riverful.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
image signal processor.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hi Hans and everyone,

This is sixth version of M-5MOLS 8 Mega Pixel camera sensor. And, if you see
previous version, you can find at:
http://www.spinics.net/lists/linux-media/msg29350.html

This driver patch is fixed several times, and the important issues is almost
corrected. And, I hope that this is the last version one merged for 2.6.39.
I look forward to be reviewed one more time.

The summary of this version's feature is belows:

1. Add focus control
	: I've suggest menu type focus control, but I agreed this version is
	not yet the level accepted. So, I did not use focus control which
	I suggest.
	The M-5MOLS focus routine takes some time to execute. But, the user
	application calling v4l2 control, should not hanged while streaming
	using q/dqbuf. So, I use workqueue. I want to discuss the focus
	subject on mailnglist next time.

2. Add irq routine
	: M-5MOLS can issues using GPIO pin, and I insert the basic routine
	of irq. This version handles only the Auto focus interrupt source.
	It shows only lens focusing status, don't any action now.

3. Speed-up whole I2C operation
	: I've tested several times for decreasing the stabilization time
	while I2C communication, and I have find proper time. Of course,
	it's more faster than previous version.

4. Let streamon() be called once at the streamming
	: It might be an issue, videobuf2 framework calls streamon when
	qbuf() for enqueueing. It means, the driver's streamon() function
	might be callled continuously if there is no proper handling in the
	subdev driver, and low the framerate by adding unneeded I2C operation.
	The M-5MOLS sensor needs command one time for streaming. If commands
	once, this sensor streams continuously, and this version handles it.

5. Update FW
	: It's a little tricky. Originally, the v4l2 frame provide load_fw(),
	but, there is the occasion which should do in openning the videonode,
	and it's the same occasion with us. So, if it's not wrong or it makes
	any problem, we hope to insert m5mols_update_fw() with weak attribute.
	And, I'm sorry that the fw updating code is confidential. unserstand
	by favor, plz.

And, as always, this driver is tested on s5pc210 board using s5p-fimc driver.

I'll wait for reviewing.

Thanks and Regards,
	Heungjun Kim
	Samsung Electronics DMC R&D Center

 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/m5mols/Kconfig           |    5 +
 drivers/media/video/m5mols/Makefile          |    3 +
 drivers/media/video/m5mols/m5mols.h          |  251 ++++++
 drivers/media/video/m5mols/m5mols_controls.c |  213 +++++
 drivers/media/video/m5mols/m5mols_core.c     | 1062 ++++++++++++++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h      |  218 ++++++
 include/media/m5mols.h                       |   35 +
 9 files changed, 1790 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/m5mols/Kconfig
 create mode 100644 drivers/media/video/m5mols/Makefile
 create mode 100644 drivers/media/video/m5mols/m5mols.h
 create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
 create mode 100644 drivers/media/video/m5mols/m5mols_core.c
 create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
 create mode 100644 include/media/m5mols.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4498b94..581a0f9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -746,6 +746,8 @@ config VIDEO_NOON010PC30
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
+source "drivers/media/video/m5mols/Kconfig"
+
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
 	select OMAP_IOMMU
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ace5d8b..a65458b 100644
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
index 0000000..220282b
--- /dev/null
+++ b/drivers/media/video/m5mols/Kconfig
@@ -0,0 +1,5 @@
+config VIDEO_M5MOLS
+	tristate "Fujitsu M-5MOLS 8MP sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
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
index 0000000..fa36536
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -0,0 +1,251 @@
+/*
+ * Header for M-5MOLS 8M Pixel camera sensor with ISP
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
+extern int m5mols_debug;
+
+enum m5mols_mode {
+	MODE_SYSINIT,
+	MODE_PARAM,
+	MODE_MONITOR,
+	MODE_UNKNOWN,
+};
+
+enum m5mols_status {
+	STATUS_SYSINIT,
+	STATUS_PARAM,
+	STATUS_MONITOR,
+	STATUS_AUTO_FOCUS,
+	STATUS_FD,			/* Face Detection */
+	STATUS_DC,			/* Dual Capture */
+	STATUS_SC,			/* Single Capture */
+	STATUS_PREVIEW,
+	STATUS_UNKNOWN,
+};
+
+enum m5mols_i2c_size {
+	I2C_8BIT	= 1,
+	I2C_16BIT	= 2,
+	I2C_32BIT	= 4,
+	I2C_MAX		= I2C_32BIT,
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
+	M5MOLS_RES_MAX,
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
+/* version maximum counts = version values + version strings + AF version */
+#define VER_STR_MAX		22
+#define VER_MAX			(10 + VER_STR_MAX + 1)
+
+struct m5mols_version {
+	u8	ctm_code;	/* customer code - address offset 0x0 */
+	u8	pj_code;	/* project code - address offset 0x1 */
+	u16	fw;		/* firmware version - offset 0x2, 0x3 */
+	u16	hw;		/* hardware version - offset 0x4, 0x5 */
+	u16	parm;		/* parameter version - offset 0x6, 0x7 */
+	u16	awb;		/* AWB version - offset 0x8, 0x9 */
+	u8	str[VER_STR_MAX];	/* manufacturer & packging vendor */
+	u8	af;		/* AF version */
+};
+
+struct m5mols_info {
+	struct v4l2_subdev		sd;
+	struct v4l2_mbus_framefmt	fmt[M5MOLS_RES_MAX];
+	struct v4l2_fract		tpf;
+	enum v4l2_mbus_pixelcode	code;		/* last setted. */
+	const struct m5mols_platform_data	*pdata;
+
+	/* additional power function, like GPIO or etc. */
+	int (*set_power)(struct device *dev, int on);
+	struct m5mols_version		ver;
+	struct work_struct		work_irq;
+	struct work_struct		work_af;
+	bool				poweron;
+
+	/* it is used when want to be called only once after probing */
+	bool				do_once;
+
+	/* v4l2 control clusters */
+	struct v4l2_ctrl_handler	handle;
+	struct {
+		struct v4l2_ctrl	*autoexposure;
+		struct v4l2_ctrl	*exposure;
+	};
+	struct v4l2_ctrl		*autowb;
+	struct v4l2_ctrl		*colorfx;
+	struct v4l2_ctrl		*saturation;
+	struct v4l2_ctrl		*zoom;
+	struct v4l2_ctrl		*autofocus;
+
+	/* control & status variables */
+	bool				lock_ae;
+	bool				lock_awb;
+	bool				focusing;
+	bool				streaming;
+	enum m5mols_mode		mode;
+	enum m5mols_mode		mode_backup;
+	enum m5mols_status		status;
+
+	/* resolution size/fps preset variables */
+	u8				res_preset;
+	u8				fps_preset;
+};
+
+/* I2C functions - referenced by below I2C helper functions */
+int m5mols_read_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 *val);
+int m5mols_write_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		u8 category, u8 cmd, u32 val);
+int m5mols_check_busy(struct v4l2_subdev *sd,
+		u8 category, u8 cmd, u32 value);
+
+/* The system mode & status functions */
+void m5mols_show_mode(struct v4l2_subdev *sd);
+int m5mols_set_mode(struct v4l2_subdev *sd, enum m5mols_mode mode);
+enum m5mols_status m5mols_get_status(struct v4l2_subdev *sd);
+
+/* The utility functions */
+int get_res_preset(struct v4l2_subdev *sd, u16 width, u16 height,
+		enum m5mols_res_type type);
+
+/* The externing camera control functions */
+int m5mols_lock_ae(struct m5mols_info *info, bool lock);
+int m5mols_lock_awb(struct m5mols_info *info, bool lock);
+void m5mols_af_work(struct work_struct *work);
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
+
+/* helper functions */
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
+	return info->streaming;
+}
+
+static inline bool is_powerup(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	return info->poweron;
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
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_MONITOR, cmd, val);
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
+static inline int __must_check i2c_w8_lens(struct v4l2_subdev *sd,
+		u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_LENS, cmd, val);
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
+static inline int __must_check i2c_r16_ae(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_16BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check i2c_r8_lens(struct v4l2_subdev *sd,
+		u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_LENS, cmd, val);
+}
+
+#endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
new file mode 100644
index 0000000..784b764
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -0,0 +1,213 @@
+/*
+ * Controls for M-5MOLS 8M Pixel camera sensor with ISP
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
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+
+#include "m5mols.h"
+#include "m5mols_reg.h"
+
+/* The externing camera control functions */
+int m5mols_lock_ae(struct m5mols_info *info, bool lock)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w8_ae(sd, CAT3_AE_LOCK, !!(info->lock_ae = lock));
+}
+
+int m5mols_lock_awb(struct m5mols_info *info, bool lock)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	info->lock_awb = lock;
+
+	return i2c_w8_wb(sd, CAT6_AWB_LOCK, !!(info->lock_awb = lock));
+}
+
+void m5mols_af_work(struct work_struct *work)
+{
+	struct m5mols_info *info = container_of(work, struct m5mols_info,
+			work_af);
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	info->focusing = true;
+
+	/* locking AE/AWB */
+	ret = m5mols_lock_ae(info, true);
+	if (!ret)
+		ret = m5mols_lock_awb(info, true);
+	if (!ret)
+		/* First, stop AF and set the AF mode. Second, start AF. */
+		ret = i2c_w8_lens(sd, CATA_AF_EXCUTE, REG_AF_STOP);
+	if (!ret)
+		ret = i2c_w8_lens(sd, CATA_AF_MODE, REG_AF_MODE_NORMAL);
+	if (!ret)
+		ret = m5mols_check_busy(sd, CAT_LENS, CATA_AF_STATUS,
+				REG_AF_IDLE);
+	if (!ret)
+		ret = i2c_w8_lens(sd, CATA_AF_EXCUTE, REG_AF_EXE_AUTO);
+	if (!ret)
+		ret = m5mols_check_busy(sd, CAT_LENS, CATA_AF_STATUS,
+				REG_AF_SUCCESS);
+	if (!ret)
+		ret = m5mols_lock_ae(info, false);
+	if (!ret)
+		ret = m5mols_lock_awb(info, false);
+
+	/* If focus is failed, just set the focusing done */
+	info->focusing = false;
+}
+
+/* v4l2 control functions */
+static int m5mols_wb_mode(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	if (info->lock_awb)
+		ret = m5mols_lock_awb(info, false);
+	if (!ret)
+		ret = i2c_w8_wb(sd, CAT6_AWB_MODE, ctrl->val ?
+				REG_AWB_MODE_AUTO : REG_AWB_MODE_MANUAL);
+
+	return ret;
+}
+
+static int m5mols_exposure_mode(struct m5mols_info *info,
+		struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	if (info->lock_ae)
+		ret = m5mols_lock_ae(info, false);
+	if (!ret)
+		ret = i2c_w8_ae(sd, CAT3_AE_MODE,
+				(ctrl->val == V4L2_EXPOSURE_AUTO) ?
+				REG_AE_MODE_ALL : REG_AE_MODE_OFF);
+	return ret;
+}
+
+static int m5mols_exposure(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w16_ae(sd, CAT3_MANUAL_GAIN_MON, info->exposure->val);
+}
+
+static int m5mols_zoom(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	return i2c_w8_mon(sd, CAT2_ZOOM, ctrl->val);
+}
+
+static int m5mols_set_saturation(struct m5mols_info *info,
+		struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	static u8 m5mols_chroma_lvl[] = {
+		REG_CHROMA_LVL0, REG_CHROMA_LVL1, REG_CHROMA_LVL2,
+		REG_CHROMA_LVL3, REG_CHROMA_LVL4, REG_CHROMA_LVL5,
+		REG_CHROMA_LVL6,
+	};
+	int ret;
+
+	ret = i2c_w8_mon(sd, CAT2_CHROMA_LVL, m5mols_chroma_lvl[ctrl->val]);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CHROMA_EN, REG_CHROMA_ON);
+
+	return ret;
+}
+
+static int m5mols_set_colorfx(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	/* This contol uses 2 kinds of register: normal effect & color effect.
+	 * The normal effect belongs to category 1. On the other hand the color
+	 * effect belongs to category 2.
+	 *
+	 * The normal effect uses one register
+	 *	: CAT1_EFFECT
+	 * The color effect uses three register
+	 *	: CAT2_COLOR_EFFECT, CAT2_CFIXR, CAT2_CFIXB */
+
+	ret = i2c_w8_param(sd, CAT1_EFFECT,
+			ctrl->val == V4L2_COLORFX_NEGATIVE ?
+							REG_EFFECT_NEGATIVE :
+			ctrl->val == V4L2_COLORFX_EMBOSS ?
+							REG_EFFECT_EMBOSS :
+		REG_EFFECT_OFF);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_COLOR_EFFECT,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_COLOR_EFFECT_ON : REG_COLOR_EFFECT_OFF);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CFIXR,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_CFIXR_SEPIA : 0);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CFIXB,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_CFIXB_SEPIA : 0);
+
+	return ret;
+}
+
+static int m5mols_af(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
+{
+	if (!info->focusing)
+		schedule_work(&info->work_af);
+	return 0;
+}
+
+/* The function called by s_ctrl() */
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ZOOM_ABSOLUTE:
+		return m5mols_zoom(info, ctrl);
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
+	case V4L2_CID_FOCUS_AUTO:
+		if (ctrl->val)
+			ret = m5mols_af(info, ctrl);
+		else
+			ret = i2c_w8_lens(sd, CATA_AF_EXCUTE, REG_AF_STOP);
+		return ret;
+	}
+
+	return -EINVAL;
+}
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
new file mode 100644
index 0000000..634db1f
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -0,0 +1,1062 @@
+/*
+ * Driver for M-5MOLS 8M Pixel camera sensor with ISP
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
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/version.h>
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
+module_param(m5mols_debug, int, 0644);
+
+#define MOD_NAME		"M5MOLS"
+#define M5MOLS_I2C_CHECK_RETRY	300
+
+/* M-5MOLS mode */
+static u8 m5mols_reg_mode[] = {
+	[MODE_SYSINIT]		= REG_MODE_SYSINIT,
+	[MODE_PARAM]		= REG_MODE_PARAM,
+	[MODE_MONITOR]		= REG_MODE_MONITOR,
+};
+
+/* M-5MOLS regulator consumer names */
+/* The DEFAULT names of power are referenced with M-5MOLS datasheet. */
+static struct regulator_bulk_data supplies[] = {
+	{
+		/* core power - 1.2v, generally at the M-5MOLS */
+		.supply		= "core",
+	}, {
+		.supply		= "dig_18",	/* digital power 1 - 1.8v */
+	}, {
+		.supply		= "d_sensor",	/* sensor power 1 - 1.8v */
+	}, {
+		.supply		= "dig_28",	/* digital power 2 - 2.8v */
+	}, {
+		.supply		= "a_sensor",	/* analog power */
+	}, {
+		.supply		= "dig_12",	/* digital power 3 - 1.2v */
+	},
+};
+
+/* M-5MOLS default format (codes, sizes, preset values) */
+static const struct v4l2_mbus_framefmt default_fmt[M5MOLS_RES_MAX] = {
+	[M5MOLS_RES_MON] = {
+		.width		= 1920,
+		.height		= 1080,
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.field		= V4L2_FIELD_NONE,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+
+static const struct m5mols_format m5mols_formats[] = {
+	[M5MOLS_RES_MON] = {
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+
+/* M-5MOLS default FPS */
+static const struct v4l2_fract default_fps = {
+	.numerator		= 1,
+	.denominator		= M5MOLS_FPS_AUTO,
+};
+
+static const struct m5mols_resolution m5mols_reg_res[] = {
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
+/*
+ * m5mols_swap_byte() / to_res_type() - These functions is utility.
+ *
+ * The m5mols_swap_byte() returns value swapped depends on 8/16/32 width.
+ * The value independent system. It generally is used in the I2C function.
+ */
+static u32 m5mols_swap_byte(u8 *data, enum m5mols_i2c_size size)
+{
+	if (size == I2C_8BIT)
+		return *data;
+	else if (size == I2C_16BIT)
+		return be16_to_cpu(*((u16 *)data));
+	else
+		return be32_to_cpu(*((u32 *)data));
+}
+
+static enum m5mols_res_type to_res_type(struct v4l2_subdev *sd,
+		enum v4l2_mbus_pixelcode code)
+{
+	int i = ARRAY_SIZE(m5mols_formats);
+
+	while (i--)
+		if (code == m5mols_formats[i].code)
+			break;
+	if (i < 0)
+		return M5MOLS_RES_MAX;
+	return i;
+}
+
+/*
+ * m5mols_read_reg() / m5mols_write_reg() - handle sensor's I2C communications.
+ *
+ * The I2C command packet of M-5MOLS is made up 3 kinds of I2C bytes(category,
+ * command, bytes). Reference m5mols.h.
+ *
+ * The packet is needed 2, when M-5MOLS is read through I2C.
+ * The packet is needed 1, when M-5MOLS is written through I2C.
+ *
+ * I2C packet common order(including both reading/writing)
+ *   1st : size (data size + 4)
+ *   2nd : READ/WRITE (R - 0x01, W - 0x02)
+ *   3rd : Category
+ *   4th : Command
+ *
+ * I2C packet order for READING operation
+ *   5th : data real size for reading
+ *   And, read another I2C packet again, until data size.
+ *
+ * I2C packet order for WRITING operation
+ *   5th to 8th: an actual data to write
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
+	wbuf[0] = 5;		/* same right above this */
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
+	usleep_range(200, 200);		/* must be for stabilization */
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
+	usleep_range(200, 200);		/* must be for stabilization */
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed WRITE[%d] at "
+				"cat[%02x] cmd[%02x], ret %d\n",
+				size, msg->buf[2], msg->buf[3], ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int m5mols_check_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 value)
+{
+	u32 busy, i;
+	int ret;
+
+	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
+
+		ret = m5mols_read_reg(sd, I2C_8BIT, category, cmd, &busy);
+		if (ret < 0)
+			return ret;
+
+		if (busy == value)	/* bingo */
+			return 0;
+	}
+
+	return -EBUSY;
+}
+
+/*
+ * m5mols_set_mode() / m5mols_show_mode() / m5mols_get_status()
+ *
+ * The sensor M-5MOLS has system mode and system status. The system mode means
+ * the M-5MOLS's state and this is changable to us. The system mode supported
+ * M-5MOLS is only 4 - System, Parameter, Monitor, Capture. But, the System
+ * mode is not able to be set by us, it's available only after powering up.
+ *
+ * On the other hand, The sensor M-5MOLS's system status is similar with the
+ * system mode, but this is not acceptable to be set by us.
+ */
+void m5mols_show_mode(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+
+	dev_info(cdev, "mode: %s\n",
+			info->mode == MODE_SYSINIT ? "System" :
+			info->mode == MODE_PARAM ? "Parameter" :
+			info->mode == MODE_MONITOR ? "Monitor" :
+			"Unknown");
+}
+
+int m5mols_set_mode(struct v4l2_subdev *sd, enum m5mols_mode mode)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	if (mode < MODE_SYSINIT || mode > MODE_MONITOR)
+		return -EINVAL;
+
+	ret = i2c_w8_system(sd, CAT0_SYSMODE, m5mols_reg_mode[mode]);
+	if (!ret)
+		ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_STATUS,
+				m5mols_reg_mode[mode]);
+	if (!ret)
+		info->mode = m5mols_reg_mode[mode];
+
+	return ret;
+}
+
+enum m5mols_status m5mols_get_status(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	int ret;
+
+	ret = i2c_r8_system(sd, CAT0_STATUS, (u32 *)&info->status);
+	if (!ret)
+		dev_info(cdev, "status %s\n",
+			info->status == STATUS_SYSINIT ? "System" :
+			info->status == STATUS_PARAM ? "Parameter" :
+			info->status == STATUS_MONITOR ? "Monitor" :
+			info->status == STATUS_AUTO_FOCUS ? "Auto Focus" :
+			info->status == STATUS_FD ? "Face Detction" :
+			info->status == STATUS_DC ? "Dual Capture" :
+			info->status == STATUS_SC ? "Single Capture" :
+			info->status == STATUS_PREVIEW ? "Preview" :
+			"Unknown");
+
+	return ret;
+}
+
+/*
+ * m5mols_get_version() / m5mols_show_version()
+ *
+ * This function's role is getting M-5MOLS version including basic information
+ * version & AF & even version string. Each information is stored internal
+ * version structure.
+ */
+static int m5mols_get_version(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	union {
+		struct m5mols_version	ver;
+		u8			bytes[VER_MAX];
+	} value;
+	int ret, i;
+
+	info->ver = value.ver;
+
+	/* get from custom code version offset to AWB version offset */
+	for (i = CAT0_CUSTOMER_CODE; i <= CAT0_VERSION_AWB_L; i++) {
+		ret = i2c_r8_system(sd, i, (u32 *)&value.bytes[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* get version string */
+	for (; i < VER_MAX - 1; i++)
+		ret = i2c_r8_system(sd, CAT0_VERSION_STR,
+				(u32 *)&value.bytes[i]);
+	value.bytes[i] = '\0';
+
+	/* get AF version */
+	ret = i2c_r8_lens(sd, CATA_AF_VERSION, (u32 *)&value.bytes[i]);
+	if (ret)
+		return ret;
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
+	dev_info(dev, "AF version\t0x%04x\n", info->ver.af);
+	dev_info(dev, "Version string\t%s\n", info->ver.str);
+}
+
+/*
+ * get_res_preset() - find out M-5MOLS register value from requested resolution.
+ *
+ * @width: requested width
+ * @height: requested height
+ * @type: requested type of each modes. It supports only monitor mode now.
+ */
+int get_res_preset(struct v4l2_subdev *sd, u16 width, u16 height,
+		enum m5mols_res_type type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(m5mols_reg_res); i++) {
+		if ((m5mols_reg_res[i].type == type) &&
+			(m5mols_reg_res[i].width == width) &&
+			(m5mols_reg_res[i].height == height))
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(m5mols_reg_res))
+		return -EINVAL;
+
+	return m5mols_reg_res[i].value;
+}
+
+/*
+ * get_fps() - calc & check FPS from v4l2_captureparm, if FPS is adequate, set.
+ *
+ * In M-5MOLS case, the denominator means FPS. The values of numerator and
+ * denominator should not be minus both. If numerator is 0, it sets AUTO FPS.
+ * If numerator is not 1, it recalculates denominator. After it checks, the
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
+	enum m5mols_res_type res_type;
+
+	res_type = to_res_type(sd, ffmt->code);
+	if (res_type == M5MOLS_RES_MAX)
+		return -EINVAL;
+
+	*ffmt = info->fmt[res_type];
+	info->code = ffmt->code;
+
+	return 0;
+}
+
+static int m5mols_s_mbus_fmt(struct v4l2_subdev *sd,
+		struct v4l2_mbus_framefmt *ffmt)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	enum m5mols_res_type res_type;
+	int size;
+
+	res_type = to_res_type(sd, ffmt->code);
+	if (res_type == M5MOLS_RES_MAX)
+		return -EINVAL;
+
+	size = get_res_preset(sd, ffmt->width, ffmt->height, res_type);
+	if (size < 0)
+		return -EINVAL;
+
+	if (ffmt->code == m5mols_formats[M5MOLS_RES_MON].code) {
+		info->res_preset = (u8)size;
+
+		info->fmt[res_type]		= default_fmt[res_type];
+		info->fmt[res_type].width	= ffmt->width;
+		info->fmt[res_type].height	= ffmt->height;
+
+		*ffmt = info->fmt[res_type];
+		info->code = ffmt->code;
+	}
+
+	return 0;
+}
+
+static int m5mols_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
+			      enum v4l2_mbus_pixelcode *code)
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
+	int ret;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+			parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	ret = get_fps(sd, cp);	/* set right FPS to denominator. */
+	if (!ret)
+		info->fps_preset = m5mols_reg_fps[cp->timeperframe.denominator];
+	if (!ret) {
+		cp->capability = V4L2_CAP_TIMEPERFRAME;
+		info->tpf = cp->timeperframe;
+	}
+
+	return ret;
+}
+
+static int m5mols_start_monitor(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	ret = m5mols_set_mode(sd, MODE_PARAM);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, info->res_preset);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS, info->fps_preset);
+	if (!ret)
+		ret = m5mols_set_mode(sd, MODE_MONITOR);
+	if (!ret && info->do_once) {
+		/* After probing the driver, this should be callde once. */
+		v4l2_ctrl_handler_setup(&info->handle);
+		info->do_once = false;
+	}
+
+	return ret;
+}
+
+static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret = -EINVAL;
+
+	/* It happens the driver using this subdev chooses the method doing
+	 * streamon/off when qbuf/dqbuf continuously. But, in the case of
+	 * M-5MOLS, it's no problem to set streaming command just once.
+	 * So, the status of streamon/off of the level of v4l2, should be
+	 * checked in here for controlling separately with no problems. */
+	if (enable && !is_streaming(sd)) {
+
+		/* streaming mode determines whether mediabus code */
+		ret = m5mols_start_monitor(sd);
+		if (!ret)
+			info->streaming = true;
+
+	} else if (!enable && is_streaming(sd)) {
+
+		/* The is_streaming() is the key to determine streamon/off. The
+		 * 'enable' has meaning depends on streaming */
+		ret = m5mols_set_mode(sd, MODE_PARAM);
+		if (!ret)
+			info->streaming = false;
+	}
+
+	return ret;
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
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	info->mode_backup = info->mode;
+
+	ret = m5mols_set_mode(sd, MODE_PARAM);
+	if (!ret)
+		ret = m5mols_set_ctrl(ctrl);
+	if (!ret)
+		ret = m5mols_set_mode(sd, info->mode_backup);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
+	.s_ctrl = m5mols_s_ctrl,
+};
+
+/*
+ * m5mols_sensor_power() - handle sensor power up/down.
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
+		if (is_powerup(sd))
+			return 0;
+
+		/* power-on additional power */
+		if (info->set_power) {
+			ret = info->set_power(&c->dev, 1);
+			if (ret)
+				return ret;
+		}
+
+		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
+		if (ret)
+			return ret;
+
+		gpio_set_value(info->pdata->gpio_rst, info->pdata->enable_rst);
+		usleep_range(1000, 1000);
+
+		info->poweron = true;
+
+	} else {
+		if (!is_powerup(sd))
+			return 0;
+
+		ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
+		if (ret)
+			return ret;
+
+		/* power-off additional power */
+		if (info->set_power) {
+			ret = info->set_power(&c->dev, 0);
+			if (ret)
+				return ret;
+		}
+
+		info->poweron = false;
+
+		gpio_set_value(info->pdata->gpio_rst, !info->pdata->enable_rst);
+		usleep_range(1000, 1000);
+	}
+
+	return ret;
+}
+
+/* m5mols_update_fw() - Note that m5mols_update_fw() is optional. */
+int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
+		int (*set_power)(struct m5mols_info *, bool))
+{
+	return 0;
+}
+
+/*
+ * m5mols_sensor_armboot() - booting M-5MOLS internal ARM core-controller.
+ *
+ * It makes to ready M-5MOLS for I2C & MIPI interface. After it's powered up,
+ * it activates if it gets armboot command for I2C interface. After getting
+ * cmd, it must wait about least 520ms referenced by M-5MOLS datasheet.
+ */
+static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 reg;
+	int ret;
+
+	/* ARM(M-5MOLS core) booting */
+	ret = i2c_w8_flash(sd, CATF_CAM_START, true);
+	if (ret < 0)
+		return ret;
+
+	msleep(520);
+	dev_dbg(&client->dev, "Success ARM Booting\n");
+
+	/* checking firmware */
+	ret = m5mols_get_version(sd);
+	if (!ret)
+		ret = m5mols_update_fw(sd, m5mols_sensor_power);
+	if (ret)
+		return ret;
+
+	m5mols_show_version(sd);
+
+	/* clear intterupt */
+	ret = i2c_r8_system(sd, CAT0_INT_FACTOR, &reg);
+	if (!ret)
+		/* Enable only AF intterupt */
+		ret = i2c_w8_system(sd, CAT0_INT_ENABLE, REG_INT_AF);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_DATA_INTERFACE,
+				REG_INTERFACE_MIPI);
+
+	return ret;
+}
+
+/* m5mols_init_controls - initialization for v4l2 control */
+static int m5mols_init_controls(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 max_ex_mon;
+	int ret;
+
+	/* check minimum & maximum of M-5MOLS controls */
+	ret = i2c_r16_ae(sd, CAT3_MAX_GAIN_MON, (u32 *)&max_ex_mon);
+	if (ret)
+		return ret;
+
+	/* set the controls using v4l2 control frameworks */
+	v4l2_ctrl_handler_init(&info->handle, 7);
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
+	info->zoom = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_ZOOM_ABSOLUTE,
+			0, 70, 1, 0);
+	info->autofocus = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_FOCUS_AUTO,
+			0, 1, 1, 1);
+
+	sd->ctrl_handler = &info->handle;
+	if (info->handle.error) {
+		dev_err(&client->dev, "Failed to init controls, %d\n", ret);
+		v4l2_ctrl_handler_free(&info->handle);
+		return info->handle.error;
+	}
+
+	v4l2_ctrl_cluster(2, &info->autoexposure);
+
+	return 0;
+}
+
+static int m5mols_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	int ret;
+
+	if (on) {
+
+		/* power on sequence
+		 * 1. power on sensor - regulator & other power gpio pins.
+		 * 2. armboot armboot, checking version, etc(using I2C).
+		 * 3. init v4l2 control - settle min/max values(using I2C).
+		 * 4. set information values - default resolution/fps */
+
+		ret = m5mols_sensor_power(info, true);
+		if (!ret)
+			ret = m5mols_sensor_armboot(sd);
+		if (!ret)
+			ret = m5mols_init_controls(info);
+		if (!ret) {
+			/* setup defulat size & fps */
+			info->fmt[M5MOLS_RES_MON] = default_fmt[M5MOLS_RES_MON];
+			info->tpf = default_fps;
+		}
+
+	} else {
+
+		/* power off sequence
+		 * 1. power off AF - let the lens do the soft-landing algorithm
+		 * 2. power off sensor - force it, if failed powering off AF */
+
+		/* landing softly lens & poweroff AF. If do not soft-landing
+		 * when powering off, the lens can be damaged. */
+		ret = m5mols_set_mode(sd, MODE_MONITOR);
+		if (!ret)
+			ret = i2c_w8_lens(sd, CATA_AF_EXCUTE, REG_AF_STOP);
+		if (!ret)
+			ret = i2c_w8_lens(sd, CATA_AF_MODE, REG_AF_POWEROFF);
+		if (!ret)
+			ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_STATUS,
+					REG_AF_IDLE);
+		if (!ret)
+			dev_info(cdev, "Success AF soft-landing lens\n");
+
+		/* Force powering off the sensor, if AF powering off is failed
+		 * or not */
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
+static void m5mols_irq_work(struct work_struct *work)
+{
+	struct m5mols_info *info = container_of(work, struct m5mols_info,
+			work_irq);
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	u32 reg;
+	int ret;
+
+	/* If not powering up and I2C failed, return immediately */
+	if (!is_powerup(sd) || i2c_r8_system(sd, CAT0_INT_FACTOR, &reg))
+		return;
+
+	switch (reg & REG_INT_MASK) {
+	case REG_INT_AF:
+		ret = i2c_r8_lens(sd, CATA_AF_STATUS, &reg);
+		dev_dbg(cdev, "= AF %s\n",
+				reg == REG_AF_FAIL ? "Failed" :
+				reg == REG_AF_SUCCESS ? "Success" :
+				reg == REG_AF_IDLE ? "Idle" : "Busy");
+		break;
+	case REG_INT_CAPTURE:
+	case REG_INT_ZOOM:
+	case REG_INT_FRAMESYNC:
+	case REG_INT_FD:
+	case REG_INT_LENS_INIT:
+	case REG_INT_SOUND:
+	case REG_INT_MODE:
+	default:
+		dev_dbg(cdev, "= Nothing : %02x\n", reg);
+		break;
+	};
+}
+
+static irqreturn_t m5mols_irq_handler(int irq, void *data)
+{
+	struct v4l2_subdev *sd = data;
+	struct m5mols_info *info = to_m5mols(sd);
+
+	schedule_work(&info->work_irq);
+
+	return IRQ_HANDLED;
+}
+
+static int m5mols_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	const struct m5mols_platform_data *pdata =
+		client->dev.platform_data;
+	struct m5mols_info *info;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
+	if (!gpio_is_valid(pdata->gpio_rst)) {
+		dev_err(&client->dev, "No valid nRST gpio pin.\n");
+		return -EINVAL;
+	}
+
+	if (!pdata->irq) {
+		dev_err(&client->dev, "Interrupt not assigned.\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
+	if (info == NULL) {
+		dev_err(&client->dev, "Failed to allocate info\n");
+		return -ENOMEM;
+	}
+
+	info->pdata	= pdata;
+	if (info->pdata->set_power)	/* for additional power if needed. */
+		info->set_power = pdata->set_power;
+
+	ret = gpio_request(info->pdata->gpio_rst, "M5MOLS nRST");
+	if (ret) {
+		dev_err(&client->dev, "Failed to set gpio, %d\n", ret);
+		goto out_gpio;
+	}
+
+	gpio_direction_output(info->pdata->gpio_rst, !info->pdata->enable_rst);
+
+	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
+	if (ret) {
+		dev_err(&client->dev, "Failed to get regulators, %d\n", ret);
+		goto out_reg;
+	}
+
+	sd = &info->sd;
+	strlcpy(sd->name, MOD_NAME, sizeof(sd->name));
+	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
+
+	INIT_WORK(&info->work_af, m5mols_af_work);
+
+	/* After calling v4l2_i2c_subdev_init() the I2C is available, and
+	 * then it's not happend the problem when issued irq & done workqueue,
+	 * and then I2C is accessed. */
+	if (info->pdata->irq) {
+		INIT_WORK(&info->work_irq, m5mols_irq_work);
+		ret = request_irq(info->pdata->irq,
+				m5mols_irq_handler,
+				IRQF_TRIGGER_RISING,
+				MOD_NAME, sd);
+		if (ret) {
+			dev_err(&client->dev,
+				"Failed to request irq: %d\n", ret);
+			goto out_irq;
+		}
+	}
+
+	info->do_once = true;
+	v4l2_dbg(1, m5mols_debug, sd, "probed m5mols driver.\n");
+
+	return 0;
+
+out_irq:
+	free_irq(info->pdata->irq, sd);
+out_reg:
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+out_gpio:
+	gpio_free(info->pdata->gpio_rst);
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
+	free_irq(info->pdata->irq, sd);
+
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+	gpio_free(info->pdata->gpio_rst);
+	kfree(info);
+
+	info->do_once = false;
+	v4l2_dbg(1, m5mols_debug, sd, "removed m5mols driver.\n");
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
+MODULE_DESCRIPTION("Fujitsu M-5MOLS 8M Pixel camera sensor with ISP driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
new file mode 100644
index 0000000..707930f
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -0,0 +1,218 @@
+/*
+ * Register map for M-5MOLS 8M Pixel camera sensor with ISP
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
+ * The category means set including relevant command of M-5MOLS.
+ */
+#define CAT_SYSTEM		0x00
+#define CAT_PARAM		0x01
+#define CAT_MONITOR		0x02
+#define CAT_AE			0x03
+#define CAT_WB			0x06
+#define CAT_EXIF		0x07
+#define CAT_LENS		0x0a
+#define CAT_FLASH		0x0f	/* related with FW, Verions, booting */
+
+/*
+ * Category 0 - System mode
+ *
+ * The system mode in the M-5MOLS means area available to handle with the whole
+ * & all-round system of sensor. It deals with version/interrupt/setting mode &
+ * even sensor's status. Especially, the M-5MOLS sensor with ISP varys by
+ * packaging & manufactur vendors, even the customer user vendor. And the
+ * detailed function may have a difference. The version information can
+ * determine what method use in the driver.
+ *
+ * There is many registers between customer version address and awb one. For
+ * more specific contents, reference the m5mols.h.
+ */
+#define CAT0_CUSTOMER_CODE	0x00	/* customer version*/
+#define CAT0_VERSION_AWB_L	0x09	/* Auto WB version low byte */
+#define CAT0_VERSION_STR	0x0a	/* string including M-5MOLS */
+#define CAT0_SYSMODE		0x0b	/* system mode register */
+#define CAT0_STATUS		0x0c	/* system status register */
+#define CAT0_INT_FACTOR		0x10	/* interrupt pending register */
+#define CAT0_INT_ENABLE		0x11	/* interrupt enable register */
+
+#define REG_MODE_SYSINIT	0x00	/* system mode */
+#define REG_MODE_PARAM		0x01	/* parameter mode */
+#define REG_MODE_MONITOR	0x02	/* monitor mode */
+#define REG_MODE_CAPTURE	0x03	/* capture mode */
+
+#define REG_INT_MODE		(1 << 0)
+#define REG_INT_AF		(1 << 1)
+#define REG_INT_ZOOM		(1 << 2)
+#define REG_INT_CAPTURE		(1 << 3)
+#define REG_INT_FRAMESYNC	(1 << 4)
+#define REG_INT_FD		(1 << 5)
+#define REG_INT_LENS_INIT	(1 << 6)
+#define REG_INT_SOUND		(1 << 7)
+#define REG_INT_ALLOFF		0x0
+#define REG_INT_MASK		0x0f
+
+/*
+ * category 1 - Parameter mode
+ *
+ * This category supports function of camera features of M-5MOLS. It means we
+ * can handle with preview(monitor) resolution size/frame per second/interface
+ * between the sensor and the Application Processor/even the image effect.
+ */
+#define CAT1_DATA_INTERFACE	0x00	/* interface between sensor and AP */
+#define CAT1_MONITOR_SIZE	0x01	/* resolution at the monitor mode */
+#define CAT1_MONITOR_FPS	0x02	/* frame per second at this mode */
+#define CAT1_EFFECT		0x0b	/* image effects */
+
+#define REG_INTERFACE_YUV	0x00
+#define REG_INTERFACE_HDMI	0x01
+#define REG_INTERFACE_MIPI	0x02	/* only this is used in this version */
+
+#define REG_EFFECT_OFF		0x00
+#define REG_EFFECT_NEGATIVE	0x01
+#define REG_EFFECT_SOLARIZATION	0x02
+#define REG_EFFECT_EMBOSS	0x06
+#define REG_EFFECT_OUTLINE	0x07
+#define REG_EFFECT_WATERCOLOR	0x08
+
+/*
+ * Category 2 - Monitor mode
+ *
+ * The monitor mode is same as preview mode as we said. The M-5MOLS has another
+ * mode named "Preview", but this preview mode is used at the case specific
+ * vider-recording mode. This mmode supports only YUYV format. On the other
+ * hand, the JPEG & RAW formats is supports by capture mode. And, there are
+ * another options like zoom/color effect(different with effect in parameter
+ * mode)/anti hand shaking algorithm.
+ */
+#define CAT2_ZOOM		0x01	/* set the zoom position & execute */
+#define CAT2_ZOOM_POSITION	0x02	/* get the zoom position */
+#define CAT2_ZOOM_STEP		0x03	/* set the zoom step */
+#define CAT2_CFIXB		0x09	/* CB value for color effect */
+#define CAT2_CFIXR		0x0a	/* CR value for color effect */
+#define CAT2_COLOR_EFFECT	0x0b	/* set on/off of color effect */
+#define CAT2_CHROMA_LVL		0x0f	/* set chroma level */
+#define CAT2_CHROMA_EN		0x10	/* set on/off of choroma */
+
+#define REG_CFIXB_SEPIA		0xd8
+#define REG_CFIXB_GRAY		0x00
+#define REG_CFIXB_RED		0x00
+#define REG_CFIXB_GREEN		0xe0
+#define REG_CFIXB_BLUE		0x40
+#define REG_CFIXB_PINK		0x20
+#define REG_CFIXB_YELLOW	0x80
+#define REG_CFIXB_PURPLE	0x50
+#define REG_CFIXB_ANTIQUE	0xd0
+
+#define REG_CFIXR_SEPIA		0x18
+#define REG_CFIXR_GRAY		0x00
+#define REG_CFIXR_RED		0x6b
+#define REG_CFIXR_GREEN		0xe0
+#define REG_CFIXR_BLUE		0x00
+#define REG_CFIXR_PINK		0x40
+#define REG_CFIXR_YELLOW	0x00
+#define REG_CFIXR_PURPLE	0x20
+#define REG_CFIXR_ANTIQUE	0x30
+
+#define REG_COLOR_EFFECT_OFF	0x00
+#define REG_COLOR_EFFECT_ON	0x01
+
+#define REG_CHROMA_LVL0		0x1c
+#define REG_CHROMA_LVL1		0x3e
+#define REG_CHROMA_LVL2		0x5f
+#define REG_CHROMA_LVL3		0x80
+#define REG_CHROMA_LVL4		0xa1
+#define REG_CHROMA_LVL5		0xc2
+#define REG_CHROMA_LVL6		0xe4
+
+#define REG_CHROMA_OFF		0x00
+#define REG_CHROMA_ON		0x01
+
+/*
+ * Category 3 - Auto Exposure
+ *
+ * The M-5MOLS exposure capbility is detailed as which is similar to digital
+ * camera. This category supports AE locking/various AE mode(range of exposure)
+ * /ISO/flickering/EV bias/shutter/meteoring, and anything else. And the
+ * maximum/minimum exposure gain value depending on M-5MOLS firmware, may be
+ * different. So, this category also provide getting the max/min values. And,
+ * each monitor and capture mode has each gain/shutter/max exposure values.
+ */
+#define CAT3_AE_LOCK		0x00	/* locking Auto exposure */
+#define CAT3_AE_MODE		0x01	/* set AE mode, mode means range */
+#define CAT3_MANUAL_GAIN_MON	0x12	/* meteoring value, monitor mode */
+#define CAT3_MANUAL_SHUT_MON	0x14	/* shutter value, monitor mode */
+#define CAT3_MAX_EXPOSURE_MON	0x16	/* max value at the monitor mode */
+#define CAT3_MAX_EXPOSURE_CAP	0x18	/* max value at the capture mode */
+#define CAT3_MAX_GAIN_MON	0x1a	/* max gain value at the monitor */
+#define CAT3_MAX_GAIN_CAP	0x1c	/* max gain value at the capture */
+#define CAT3_MANUAL_GAIN_CAP	0x26	/* meteoring value, capture mode */
+#define CAT3_MANUAL_SHUT_CAP	0x28	/* shutter value, capture mode */
+
+#define REG_AE_MODE_OFF		0x00	/* AE off */
+#define REG_AE_MODE_ALL		0x01	/* calc AE in all block integral */
+#define REG_AE_MODE_CENTER1	0x02	/* calc AE at the center area 1 */
+#define REG_AE_MODE_CENTER2	0x03	/* calc AE at the center area 2 */
+#define REG_AE_MODE_CENTER3	0x04	/* calc AE at the center area 3 */
+#define REG_AE_MODE_SPOT1	0x05	/* spot 1 */
+#define REG_AE_MODE_SPOT2	0x06	/* spot 2 */
+
+/*
+ * Category 6 - White Balance
+ *
+ * This cagetory provide AWB locking/mode/preset/speed/gain bias, etc.
+ */
+#define CAT6_AWB_LOCK		0x00	/* locking Auto Whitebalance */
+#define CAT6_AWB_MODE		0x02	/* set Auto or Manual */
+#define CAT6_AWB_MANUAL		0x03	/* preset, not used in this version */
+
+#define REG_AWB_MODE_AUTO	0x01	/* AWB off */
+#define REG_AWB_MODE_MANUAL	0x02	/* AWB preset */
+
+/*
+ * Category A - Lens parameter
+ */
+#define CATA_INIT_AF_FUNC	0x00
+#define CATA_AF_MODE		0x01
+#define CATA_AF_EXCUTE		0x02
+#define CATA_AF_STATUS		0x03
+#define CATA_AF_VERSION		0x0a
+
+#define REG_AF_FAIL		0x00
+#define REG_AF_SUCCESS		0x02
+#define REG_AF_IDLE		0x04
+#define REG_AF_BUSY		0x05
+
+#define REG_AF_MODE_NORMAL	0x00
+#define REG_AF_MODE_MACRO	0x01
+#define REG_AF_MODE_CAF		0x02
+
+#define REG_AF_STOP		0x00
+#define REG_AF_EXE_AUTO		0x01
+#define REG_AF_EXE_CAF		0x02
+#define REG_AF_POWEROFF		0x07
+
+/*
+ * Category F - Flash
+ *
+ * This mode provides functions about internal flash stuff and system startup.
+ */
+#define CATF_CAM_START		0x12	/* It start internal ARM core booting
+					 * after power-up */
+
+#endif	/* M5MOLS_REG_H */
diff --git a/include/media/m5mols.h b/include/media/m5mols.h
new file mode 100644
index 0000000..6986855
--- /dev/null
+++ b/include/media/m5mols.h
@@ -0,0 +1,35 @@
+/*
+ * Driver header for M-5MOLS 8M Pixel camera sensor with ISP
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
+ * struct m5mols_platform_data - platform data for M-5MOLS driver
+ * @irq:	GPIO getting the irq pin of M-5MOLS
+ * @gpio_rst:	GPIO driving the reset pin of M-5MOLS
+ * @enable_rst:	the pin state when reset pin is enabled
+ * @set_power:	an additional callback to a board setup code
+ *		to be called after enabling and before disabling
+ *		the sensor device supply regulators
+ */
+struct m5mols_platform_data {
+	int irq;
+	int gpio_rst;
+	bool enable_rst;
+	int (*set_power)(struct device *dev, int on);
+};
+
+#endif	/* MEDIA_M5MOLS_H */
-- 
1.7.0.4

