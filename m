Return-path: <mchehab@gaivota>
Received: from mailout3.samsung.com ([203.254.224.33]:15205 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1EMLjh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 07:39:37 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LL400BOFTPTF8V0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 May 2011 20:39:34 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LL400H05TPYYZ@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 May 2011 20:39:34 +0900 (KST)
Date: Fri, 13 May 2011 20:38:58 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH v7] Add support for M-5MOLS 8 Mega Pixel camera ISP
In-reply-to: <1305281165-3658-1-git-send-email-riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1305286738-5055-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1305281165-3658-1-git-send-email-riverful.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add I2C/V4L2 subdev driver for M-5MOLS integrated image signal processor
with 8 Mega Pixel sensor.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hello,

I've just got some misses in this patch, so I re-send same version of the
patch, just fixed misses. I hope to discard the previous email I sent and
let the patch in this email be reviewed, please.

Sorry to confuse and thanks!

===============================================================================

Hello,

This is the seventh version of the subdev for M-5MOLS 8M Pixel camera sensor.
This version has a lot of changes againt previous one. The major change is
that it supports to capture with JPEG format generating in itself.

The capture function and all the other operations are tested on the Universal
Board with EXYNOS4 SoCs using s5p-fimc driver and the NURI board, but it needed
for enabling the capture capability to support V4L2_MBUS_FMT_JPEG_1X8 media code.
The relevant patch can be found here:
http://www.spinics.net/lists/linux-media/msg32231.html

In this patch, the big changes except for capture are here:

1. Convert previous format operation to media bus operation
2. Add scenemode function for setting default scenemode
3. Enable to change the mode more stably
4. Add some variation according to M-5MOLS FW versions and manufacturers

And the full thread about the previous version of M-5MOLS driver can be found
here: http://www.spinics.net/lists/linux-media/msg29350.html

Any comments and reviews are welcome!

--
Regards,
Heungjun Kim
Samsung Electronics DMC R&D Center
---
 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/m5mols/Kconfig           |    5 +
 drivers/media/video/m5mols/Makefile          |    3 +
 drivers/media/video/m5mols/m5mols.h          |  357 +++++++++
 drivers/media/video/m5mols/m5mols_capture.c  |  217 ++++++
 drivers/media/video/m5mols/m5mols_controls.c |  293 ++++++++
 drivers/media/video/m5mols/m5mols_core.c     | 1034 ++++++++++++++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h      |  321 ++++++++
 include/media/m5mols.h                       |   35 +
 10 files changed, 2268 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/m5mols/Kconfig
 create mode 100644 drivers/media/video/m5mols/Makefile
 create mode 100644 drivers/media/video/m5mols/m5mols.h
 create mode 100644 drivers/media/video/m5mols/m5mols_capture.c
 create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
 create mode 100644 drivers/media/video/m5mols/m5mols_core.c
 create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
 create mode 100644 include/media/m5mols.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index d61414e..242c80c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -753,6 +753,8 @@ config VIDEO_NOON010PC30
 	---help---
 	  This driver supports NOON010PC30 CIF camera from Siliconfile
 
+source "drivers/media/video/m5mols/Kconfig"
+
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
 	select OMAP_IOMMU
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a10e4c3..d5d6de1 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
+obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
diff --git a/drivers/media/video/m5mols/Kconfig b/drivers/media/video/m5mols/Kconfig
new file mode 100644
index 0000000..302dc3d
--- /dev/null
+++ b/drivers/media/video/m5mols/Kconfig
@@ -0,0 +1,5 @@
+config VIDEO_M5MOLS
+	tristate "Fujitsu M-5MOLS 8MP sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
diff --git a/drivers/media/video/m5mols/Makefile b/drivers/media/video/m5mols/Makefile
new file mode 100644
index 0000000..0a44e02
--- /dev/null
+++ b/drivers/media/video/m5mols/Makefile
@@ -0,0 +1,3 @@
+m5mols-objs	:= m5mols_core.o m5mols_controls.o m5mols_capture.o
+
+obj-$(CONFIG_VIDEO_M5MOLS)		+= m5mols.o
diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
new file mode 100644
index 0000000..ba1890e
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -0,0 +1,357 @@
+/*
+ * Header for M-5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+#define M5MOLS_BYTE_READ	0x01
+#define M5MOLS_BYTE_WRITE	0x02
+
+enum m5mols_i2c_size {
+	I2C_8BIT	= 1,
+	I2C_16BIT	= 2,
+	I2C_32BIT	= 4,
+	I2C_MAX		= I2C_32BIT,
+};
+
+/*
+ * In the MONITOR mode, the M-5MOLS sensor's format is YUV kinds, on the other
+ * hand, in the CAPTURE mode, its format is available to JPEG, RAW.
+ */
+enum m5mols_restype {
+	M5MOLS_RESTYPE_MONITOR,
+	M5MOLS_RESTYPE_CAPTURE,
+	M5MOLS_RESTYPE_MAX,
+};
+
+struct m5mols_resolution {
+	u8			reg;
+	enum m5mols_restype	type;
+	u16			width;
+	u16			height;
+};
+
+struct m5mols_exif {
+	u32			exposure_time;
+	u32			shutter_speed;
+	u32			aperture;
+	u32			brightness;
+	u32			exposure_bias;
+	u16			iso_speed;
+	u16			flash;
+	u16			sdr;	/* Subject(object) Distance Range */
+	u16			qval;	/* Not written exact meanning
+					 * in datasheet */
+};
+
+struct m5mols_capture {
+	struct m5mols_exif	exif;
+	u32			main;
+	u32			thumb;
+	u32			total;
+};
+
+struct m5mols_scenemode {	/* Recommended setting in document */
+	u32			metering;	/* AE light metering */
+	u32			ev_bias;	/* EV bias */
+	u32			wb_mode;	/* WhiteBalance(Auto/Manual) */
+	u32			wb_preset;	/* WhiteBalance Preset */
+	u32			chroma_en;	/* Chroma Enable */
+	u32			chroma_lvl;	/* Chroma Level */
+	u32			edge_en;	/* Edge Enable */
+	u32			edge_lvl;	/* Edge Level */
+	u32			af_range;	/* Auto Focus scan range */
+	u32			fd_mode;	/* Face Detection mode */
+	u32			mcc;		/* Multi-axis Color Conversion:
+						 * (A.K.A Emotion color) */
+	u32			light;		/* Light control */
+	u32			flash;		/* Flash control */
+
+				/* User setting needed for */
+	u32			tone;		/* Tone color(contrast) */
+	u32			iso;		/* ISO */
+	u32			capture_mode;	/* CAPTURE mode for
+						 * the Image stabilization */
+	u32			wdr;		/* Wide Dynamic Range */
+};
+
+#define VERSION_STRING_SIZE	22
+struct m5mols_version {
+	u8	customer;	/* Customer code:	bytes[0] */
+	u8	project;	/* Project code:	bytes[1] */
+	u16	fw;		/* FirmWare version:	bytes[3][2] */
+	u16	hw;		/* HardWare version:	bytes[5][4] */
+	u16	param;		/* Parameter version:	bytes[7][6] */
+	u16	awb;		/* AWB version:		bytes[9][8] */
+	u8	str[VERSION_STRING_SIZE];		/* manufacturer &
+							 * packging vendor */
+	u8	af;		/* AF version:		seperate register */
+};
+#define VERSION_SIZE		sizeof(struct m5mols_version)
+
+/* The LSB 2 bytes of version string means packaging manufacturer */
+#define SAMSUNG_ELECTRO		"SE"	/* Samsung Electro-Mechanics */
+#define SAMSUNG_OPTICS		"OP"	/* Samsung Fiber-Optics */
+#define SAMSUNG_TECHWIN		"TB"	/* Samsung Techwin */
+
+struct m5mols_info {
+	const struct m5mols_platform_data	*pdata;
+	struct v4l2_subdev		sd;
+	struct media_pad		pad;
+	struct v4l2_mbus_framefmt	ffmt[M5MOLS_RESTYPE_MAX];
+	int				curr_res_type;
+	enum v4l2_mbus_pixelcode	code;
+	wait_queue_head_t		wait_capture;
+	struct work_struct		work_irq;
+
+	struct v4l2_ctrl_handler	handle;
+	struct {
+		struct v4l2_ctrl	*autoexposure;
+		struct v4l2_ctrl	*exposure;
+	};
+	struct v4l2_ctrl		*autowb;
+	struct v4l2_ctrl		*colorfx;
+	struct v4l2_ctrl		*saturation;
+	struct v4l2_ctrl		*zoom;
+
+	struct m5mols_version		ver;
+	struct m5mols_capture		cap;
+
+	bool				power;
+	bool				ctrl_sync;
+	bool				capture;
+	bool				lock_ae;
+	bool				lock_awb;
+
+	/* Saved register value */
+	u8				resolution;
+	u32				interrupt;
+	u32				mode;
+	u32				mode_save;
+
+	/* Optional power callback function dealing with like GPIO. */
+	int (*set_power)(struct device *dev, int on);
+};
+
+/* Helper functions */
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
+static inline bool is_powered(struct m5mols_info *info)
+{
+	return info->power;
+}
+
+static inline bool is_ctrl_synced(struct m5mols_info *info)
+{
+	return info->ctrl_sync;
+}
+
+static inline bool is_captured(struct m5mols_info *info)
+{
+	return info->capture;
+}
+
+static inline bool is_manufacturer(struct m5mols_info *info, u8 *manufacturer)
+{
+	return (info->ver.str[0] == manufacturer[0] &&
+			info->ver.str[1] == manufacturer[1]) ?
+		true : false;
+}
+
+#define is_code(__code, __type) (__code == m5mols_default_ffmt[__type].code)
+
+/*
+ * m5mols_read_reg() / m5mols_write_reg()
+ *
+ * For reading something from M-5MOLS sensor, the I2C operation is needed 2
+ * packets, one is for requesting reading and another is for getting data.
+ * On the other hand, for writing, it's needed just 1. The value's
+ * order in the packet is much similar in both case reading and writing.
+ *
+ * I2C packet common order
+ *   1st : size (data size + 4)
+ *   2nd : flag (R:0x01, W:0x02)
+ *   3rd : category
+ *   4th : command
+ *
+ * Added extra bytes in case reading
+ *   5th: data
+ *   And read another I2C bytes again as much data size
+ *
+ * Added extra bytes in case writing
+ *   5th..8th: data(as much size of data)
+ */
+int m5mols_read_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		    u8 category, u8 cmd, u32 *val);
+int m5mols_write_reg(struct v4l2_subdev *sd, enum m5mols_i2c_size size,
+		     u8 category, u8 cmd, u32 val);
+int m5mols_check_busy(struct v4l2_subdev *sd,
+		      u8 category, u8 cmd, u32 value);
+
+/*
+ * The m5mols_change_mode() makes the right order executing command for
+ * changing to the desired operating mode. The three modes(PARAMETER,
+ * MONITOR, CAPTURE) exist, and only these modes can be changed intentionally
+ * by user. The each category is assigned in the given mode.
+ * +============================================================+
+ * | mode	| category					|
+ * +============================================================+
+ * | These mode must be done for using the sensor automatically |
+ * +------------------------------------------------------------+
+ * | FLASH	| FLASH(be only after Stand-by or Power-on)	|
+ * | SYSTEM	| SYSTEM(be only after sensor arm-booting)	|
+ * +============================================================+
+ * | Usually these mode is used on operating sensor		|
+ * +------------------------------------------------------------+
+ * | PARAMETER	| PARAMETER					|
+ * | MONITOR	| MONITOR(preview), Auto Focus, Face Detection	|
+ * | CAPTURE	| Single CAPTURE, Preview(recording)		|
+ * +============================================================+
+ *
+ * The possible executing order between each modes is the following:
+ * ============================================================
+ *   +-----------+         +---------+          +---------+
+ *   | PARAMETER |<------->| MONITOR |<-------->| CAPTURE |
+ *   +-----------+         +---------+          +---------+
+ */
+int m5mols_change_mode(struct m5mols_info *info, u32 mode);
+
+int m5mols_change_scenemode(struct m5mols_info *info, u32 mode);
+int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg);
+int m5mols_start_capture(struct m5mols_info *info);
+int m5mols_sync_control(struct m5mols_info *info);
+int m5mols_lock_3a(struct m5mols_info *info, bool lock);
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
+
+static inline int __must_check
+i2c_w8_system(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_SYSTEM, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_param(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_PARAM, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_mon(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_MONITOR, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_ae(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check
+i2c_w16_ae(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_16BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_wb(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_WB, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_fd(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_FD, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_lens(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_LENS, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_capt_param(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_CAPTURE_PARAMETER, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_capt_ctrl(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_CAPTURE_CONTROL, cmd, val);
+}
+
+static inline int __must_check
+i2c_w8_flash(struct v4l2_subdev *sd, u8 cmd, u32 val)
+{
+	return m5mols_write_reg(sd, I2C_8BIT, CAT_FLASH, cmd, val);
+}
+
+static inline int __must_check
+i2c_r8_system(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_SYSTEM, cmd, val);
+}
+
+static inline int __must_check
+i2c_r16_ae(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_16BIT, CAT_AE, cmd, val);
+}
+
+static inline int __must_check
+i2c_r8_lens(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_8BIT, CAT_LENS, cmd, val);
+}
+
+static inline int __must_check
+i2c_r32_capt_ctrl(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_32BIT, CAT_CAPTURE_CONTROL, cmd, val);
+}
+
+static inline int __must_check
+i2c_r16_exif(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_16BIT, CAT_EXIF, cmd, val);
+}
+
+static inline int __must_check
+i2c_r32_exif(struct v4l2_subdev *sd, u8 cmd, u32 *val)
+{
+	return m5mols_read_reg(sd, I2C_32BIT, CAT_EXIF, cmd, val);
+}
+
+/* The firmware function */
+int m5mols_update_fw(struct v4l2_subdev *sd,
+		     int (*set_power)(struct m5mols_info *, bool));
+
+#endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
new file mode 100644
index 0000000..32da9b1
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -0,0 +1,217 @@
+/*
+ * The Capture code for Fujitsu M-5MOLS ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+#include <linux/version.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/m5mols.h>
+
+#include "m5mols.h"
+#include "m5mols_reg.h"
+
+static int m5mols_capture_error_handler(struct m5mols_info *info,
+					int timeout)
+{
+	int ret;
+
+	/* Disable all interrupt & clear desired interrupt */
+	ret = i2c_w8_system(&info->sd, CAT0_INT_ENABLE,
+			info->interrupt & ~(REG_INT_CAPTURE));
+	if (ret)
+		return ret;
+
+	/* If all timeout exhausted, return error. */
+	if (!timeout)
+		return -ETIMEDOUT;
+
+	/* Clear capture */
+	if (!ret)
+		info->capture = false;
+
+	return 0;
+}
+
+/* m5mols_capture_info() - Gather captured image informations. For now,
+ * it gathers only EXIF information and file size. */
+static int m5mols_capture_info(struct m5mols_info *info, bool msgon)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct m5mols_exif *exif = &info->cap.exif;
+	int denominator, numerator;
+	int ret;
+
+	ret = i2c_r32_exif(sd, CAT7_INFO_EXPTIME_NU, &numerator);
+	if (!ret)
+		ret = i2c_r32_exif(sd, CAT7_INFO_EXPTIME_DE, &denominator);
+	if (!ret)
+		exif->exposure_time = (u32)(numerator / denominator);
+	if (ret)
+		return ret;
+
+	ret = i2c_r32_exif(sd, CAT7_INFO_TV_NU, &numerator);
+	if (!ret)
+		ret = i2c_r32_exif(sd, CAT7_INFO_TV_DE, &denominator);
+	if (!ret)
+		exif->shutter_speed = (u32)(numerator / denominator);
+	if (ret)
+		return ret;
+
+	ret = i2c_r32_exif(sd, CAT7_INFO_AV_NU, &numerator);
+	if (!ret)
+		ret = i2c_r32_exif(sd, CAT7_INFO_AV_DE, &denominator);
+	if (!ret)
+		exif->aperture = (u32)(numerator / denominator);
+	if (ret)
+		return ret;
+
+	ret = i2c_r32_exif(sd, CAT7_INFO_BV_NU, &numerator);
+	if (!ret)
+		ret = i2c_r32_exif(sd, CAT7_INFO_BV_DE, &denominator);
+	if (!ret)
+		exif->brightness = (u32)(numerator / denominator);
+	if (ret)
+		return ret;
+
+	ret = i2c_r32_exif(sd, CAT7_INFO_EBV_NU, &numerator);
+	if (!ret)
+		ret = i2c_r32_exif(sd, CAT7_INFO_EBV_DE, &denominator);
+	if (!ret)
+		exif->exposure_bias = (u32)(numerator / denominator);
+	if (ret)
+		return ret;
+
+	ret = i2c_r16_exif(sd, CAT7_INFO_ISO, (u32 *)&exif->iso_speed);
+	if (!ret)
+		ret = i2c_r16_exif(sd, CAT7_INFO_FLASH, (u32 *)&exif->flash);
+	if (!ret)
+		ret = i2c_r16_exif(sd, CAT7_INFO_SDR, (u32 *)&exif->sdr);
+	if (!ret)
+		ret = i2c_r16_exif(sd, CAT7_INFO_QVAL, (u32 *)&exif->qval);
+	if (ret)
+		return ret;
+
+	if (!ret)
+		ret = i2c_r32_capt_ctrl(sd, CATC_CAP_IMAGE_SIZE,
+				&info->cap.main);
+	if (!ret)
+		ret = i2c_r32_capt_ctrl(sd, CATC_CAP_THUMB_SIZE,
+				&info->cap.thumb);
+	if (ret)
+		return ret;
+
+	info->cap.total = info->cap.main + info->cap.thumb;
+
+	if (msgon) {
+		struct i2c_client *client = v4l2_get_subdevdata(sd);
+		struct device *cdev = &client->dev;
+
+		dev_info(cdev, "capture: total size\t%d\n", info->cap.total);
+		dev_info(cdev, "capture: main size\t%d\n", info->cap.main);
+		dev_info(cdev, "capture: thumb size\t%d\n", info->cap.thumb);
+		dev_info(cdev, "capture: exposure_time\t%d\n",
+				exif->exposure_time);
+		dev_info(cdev, "capture: shutter_speed\t%d\n",
+				exif->shutter_speed);
+		dev_info(cdev, "capture: aperture\t%d\n", exif->aperture);
+		dev_info(cdev, "capture: brightness\t%d\n", exif->brightness);
+		dev_info(cdev, "capture: exposure_bias\t%d\n",
+				exif->exposure_bias);
+		dev_info(cdev, "capture: iso_speed\t%d\n", exif->iso_speed);
+		dev_info(cdev, "capture: flash\t%d\n", exif->flash);
+		dev_info(cdev, "capture: sdr\t%d\n", exif->sdr);
+		dev_info(cdev, "capture: qval\t%d\n", exif->qval);
+	}
+
+	return ret;
+}
+
+int m5mols_start_capture(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	u32 resolution = info->resolution;
+	int timeout;
+	int ret;
+
+	/*
+	 * Preparing capture. Setting control & interrupt before entering
+	 * capture mode
+	 *
+	 * 1) change to MONITOR mode for operating control & interrupt
+	 * 2) set controls (considering v4l2_control value & lock 3A)
+	 * 3) set interrupt
+	 * 4) change to CAPTURE mode
+	 */
+	ret = m5mols_change_mode(info, REG_MODE_MONITOR);
+	if (!ret)
+		ret = m5mols_sync_control(info);
+	if (!ret)
+		ret = m5mols_lock_3a(info, true);
+	if (!ret)
+		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
+	if (!ret)
+		ret = m5mols_change_mode(info, REG_MODE_CAPTURE);
+	if (!ret)
+		/* Wait for capture interrupt, after changing capture mode */
+		timeout = wait_event_interruptible_timeout(info->wait_capture,
+				is_captured(info), msecs_to_jiffies(2000));
+	if (!ret && is_captured(info))
+		ret = m5mols_capture_error_handler(info, timeout);
+	if (!ret)
+		ret = m5mols_lock_3a(info, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * Starting capture. Setting capture frame count and resolution and
+	 * the format(available format: JPEG, Bayer RAW, YUV).
+	 *
+	 * 1) select single or multi(enable to 25), format, size
+	 * 2) set interrupt
+	 * 3) start capture(for main image, now)
+	 * 4) get information
+	 * 5) notify file size to v4l2 device(e.g, to s5p-fimc v4l2 device)
+	 */
+	ret = i2c_w8_capt_ctrl(sd, CATC_CAP_SEL_FRAME, 1);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_YUVOUT_MAIN, REG_JPEG);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_MAIN_IMAGE_SIZE, resolution);
+	if (!ret)
+		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
+	if (!ret)
+		ret = i2c_w8_capt_ctrl(sd, CATC_CAP_START, REG_CAP_START_MAIN);
+	if (!ret)
+		/* Wait for capture interrupt, after starting capture */
+		timeout = wait_event_interruptible_timeout(info->wait_capture,
+				is_captured(info), msecs_to_jiffies(2000));
+	if (!ret && is_captured(info))
+		ret = m5mols_capture_info(info, false);
+	if (!ret)
+		v4l2_subdev_notify(sd, 0, &info->cap.total);
+	if (!ret)
+		ret = m5mols_capture_error_handler(info, timeout);
+
+	return ret;
+}
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
new file mode 100644
index 0000000..1eb909e
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -0,0 +1,293 @@
+/*
+ * Controls for M-5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+static struct m5mols_scenemode m5mols_default_scenemode[] = {
+	[REG_SCENE_NORMAL] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_NORMAL, REG_LIGHT_OFF, REG_FLASH_OFF,
+		5, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_PORTRAIT] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 4,
+		REG_AF_MODE_NORMAL, BIT_FD_EN | BIT_FD_DRAW_FACE_FRAME,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_LANDSCAPE] = {
+		REG_AE_MODE_ALL, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 4, REG_EDGE_ON, 6,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_SPORTS] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_PARTY_INDOOR] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 4, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_200, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_BEACH_SNOW] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_10_POS, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 4, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_50, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_SUNSET] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_PRESET,
+		REG_AWB_DAYLIGHT,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_DAWN_DUSK] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_PRESET,
+		REG_AWB_FLUORESCENT_1,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_FALL] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 5, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_NIGHT] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_AGAINST_LIGHT] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_FIRE] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_50, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+	[REG_SCENE_TEXT] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 7,
+		REG_AF_MODE_MACRO, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_ANTI_SHAKE, REG_WDR_ON,
+	},
+	[REG_SCENE_CANDLE] = {
+		REG_AE_MODE_CENTER, REG_AE_INDEX_00, REG_AWB_MODE_AUTO, 0,
+		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
+		REG_AF_MODE_NORMAL, REG_FD_OFF,
+		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
+		6, REG_ISO_AUTO, REG_CAP_MODE_NONE, REG_WDR_OFF,
+	},
+};
+
+/* m5mols_change_scenemode() - Change current scenemode */
+int m5mols_change_scenemode(struct m5mols_info *info, u32 mode)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct m5mols_scenemode scenemode = m5mols_default_scenemode[mode];
+	int ret;
+
+	ret = m5mols_lock_3a(info, false);
+	if (!ret)
+		ret = i2c_w8_ae(sd, CAT3_EV_PRESET_MODE_MON, mode);
+	if (!ret)
+		ret = i2c_w8_ae(sd, CAT3_EV_PRESET_MODE_CAP, mode);
+	if (!ret)
+		ret = i2c_w8_ae(sd, CAT3_AE_MODE, scenemode.metering);
+	if (!ret)
+		ret = i2c_w8_ae(sd, CAT3_AE_INDEX, scenemode.ev_bias);
+	if (!ret)
+		ret = i2c_w8_wb(sd, CAT6_AWB_MODE, scenemode.wb_mode);
+	if (!ret)
+		ret = i2c_w8_wb(sd, CAT6_AWB_MANUAL, scenemode.wb_preset);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CHROMA_EN, scenemode.chroma_en);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_CHROMA_LVL, scenemode.chroma_lvl);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_EDGE_EN, scenemode.edge_en);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_EDGE_LVL, scenemode.edge_lvl);
+	if (!ret && info->ver.af)
+		ret = i2c_w8_lens(sd, CATA_AF_MODE, scenemode.af_range);
+	if (!ret && info->ver.af)
+		ret = i2c_w8_fd(sd, CAT9_FD_CTL, scenemode.fd_mode);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT2_TONE_CTL, scenemode.tone);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CAT3_ISO, scenemode.iso);
+	if (!ret)
+		ret = m5mols_change_mode(info, REG_MODE_CAPTURE);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CATB_WDR_EN, scenemode.wdr);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_MCC_MODE, scenemode.mcc);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_LIGHT_CTRL, scenemode.light);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_FLASH_CTRL, scenemode.flash);
+	if (!ret)
+		ret = i2c_w8_capt_param(sd, CATB_FLASH_CTRL, scenemode.flash);
+	if (!ret)
+		ret = i2c_w8_mon(sd, CATC_CAP_MODE, scenemode.capture_mode);
+	if (!ret)
+		ret = m5mols_change_mode(info, REG_MODE_MONITOR);
+
+	return ret;
+}
+
+static int m5mols_lock_ae(struct m5mols_info *info, bool lock)
+{
+	int ret = 0;
+
+	if (info->lock_ae != lock)
+		ret = i2c_w8_ae(&info->sd, CAT3_AE_LOCK,
+				lock ? REG_AE_LOCK : REG_AE_UNLOCK);
+	if (!ret)
+		info->lock_ae = lock;
+
+	return ret;
+}
+
+static int m5mols_lock_awb(struct m5mols_info *info, bool lock)
+{
+	int ret = 0;
+
+	if (info->lock_awb != lock)
+		ret = i2c_w8_wb(&info->sd, CAT6_AWB_LOCK,
+				lock ? REG_AWB_LOCK : REG_AWB_UNLOCK);
+	if (!ret)
+		info->lock_awb = lock;
+
+	return ret;
+}
+
+/* m5mols_lock_3a() - Lock 3A(Auto Exposure, Whitebalance, Focus) */
+int m5mols_lock_3a(struct m5mols_info *info, bool lock)
+{
+	int ret;
+
+	ret = m5mols_lock_ae(info, lock);
+	if (!ret)
+		ret = m5mols_lock_awb(info, lock);
+	if (!ret && info->ver.af && lock)
+		/* Don't need to handle unlocking AF */
+		ret = i2c_w8_lens(&info->sd, CATA_AF_EXECUTE, REG_AF_STOP);
+
+	return ret;
+}
+
+/* m5mols_set_ctrl() - The main s_ctrl function called by m5mols_set_ctrl() */
+int m5mols_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ZOOM_ABSOLUTE:
+		return i2c_w8_mon(sd, CAT2_ZOOM, ctrl->val);
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = m5mols_lock_ae(info, ctrl->val == V4L2_EXPOSURE_AUTO ?
+				false : true);
+		if (!ret)
+			ret = i2c_w8_ae(sd, CAT3_AE_MODE,
+				ctrl->val == V4L2_EXPOSURE_AUTO ?
+				REG_AE_MODE_ALL : REG_AE_MODE_OFF);
+		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
+			ret = i2c_w16_ae(sd, CAT3_MANUAL_GAIN_MON,
+				info->exposure->val);
+		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
+			ret = i2c_w16_ae(sd, CAT3_MANUAL_GAIN_CAP,
+				info->exposure->val);
+		return ret;
+
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = m5mols_lock_awb(info, ctrl->val ? false : true);
+		if (!ret)
+			ret = i2c_w8_wb(sd, CAT6_AWB_MODE, ctrl->val ?
+				REG_AWB_MODE_AUTO : REG_AWB_MODE_PRESET);
+		return ret;
+
+	case V4L2_CID_SATURATION:
+		ret = i2c_w8_mon(sd, CAT2_CHROMA_LVL, ctrl->val);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_CHROMA_EN, REG_CHROMA_ON);
+		return ret;
+
+	case V4L2_CID_COLORFX:
+		/*
+		 * This control uses two kinds of registers: normal & color.
+		 * The normal effect belongs to category 1, while the color
+		 * one belongs to category 2.
+		 *
+		 * The normal effect uses one register: CAT1_EFFECT.
+		 * The color effect uses three registers:
+		 * CAT2_COLOR_EFFECT, CAT2_CFIXR, CAT2_CFIXB.
+		 */
+		ret = i2c_w8_param(sd, CAT1_EFFECT,
+			ctrl->val == V4L2_COLORFX_NEGATIVE ? REG_EFFECT_NEGA :
+			ctrl->val == V4L2_COLORFX_EMBOSS ? REG_EFFECT_EMBOSS :
+			REG_EFFECT_OFF);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_COLOR_EFFECT,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_COLOR_EFFECT_ON : REG_COLOR_EFFECT_OFF);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_CFIXR,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_CFIXR_SEPIA : 0);
+		if (!ret)
+			ret = i2c_w8_mon(sd, CAT2_CFIXB,
+				ctrl->val == V4L2_COLORFX_SEPIA ?
+				REG_CFIXB_SEPIA : 0);
+		return ret;
+	}
+
+	return -EINVAL;
+}
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
new file mode 100644
index 0000000..cf28dd5
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -0,0 +1,1034 @@
+/*
+ * Driver for M-5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+#define M5MOLS_I2C_CHECK_RETRY	500
+
+/* The regulator consumer names are derived from M-5MOLS datasheets. */
+static struct regulator_bulk_data supplies[] = {
+	{
+		.supply		= "core",	/* ARM core power, 1.2V */
+	}, {
+		.supply		= "dig_18",	/* digital power 1, 1.8V */
+	}, {
+		.supply		= "d_sensor",	/* sensor power 1, 1.8V */
+	}, {
+		.supply		= "dig_28",	/* digital power 2, 2.8V */
+	}, {
+		.supply		= "a_sensor",	/* analog power */
+	}, {
+		.supply		= "dig_12",	/* digital power 3, 1.2V */
+	},
+};
+
+const struct v4l2_mbus_framefmt m5mols_default_ffmt[M5MOLS_RESTYPE_MAX] = {
+	[M5MOLS_RESTYPE_MONITOR] = {
+		.width		= 1920,
+		.height		= 1080,
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.field		= V4L2_FIELD_NONE,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+	[M5MOLS_RESTYPE_CAPTURE] = {
+		.width		= 1920,
+		.height		= 1080,
+		.code		= V4L2_MBUS_FMT_JPEG_1X8,
+		.field		= V4L2_FIELD_NONE,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+#define SIZE_DEFAULT_FFMT	ARRAY_SIZE(m5mols_default_ffmt)
+
+static const struct m5mols_resolution m5mols_reg_res[] = {
+	{ 0x01, M5MOLS_RESTYPE_MONITOR, 128, 96 },	/* SUB-QCIF */
+	{ 0x03, M5MOLS_RESTYPE_MONITOR, 160, 120 },	/* QQVGA */
+	{ 0x05, M5MOLS_RESTYPE_MONITOR, 176, 144 },	/* QCIF */
+	{ 0x06, M5MOLS_RESTYPE_MONITOR, 176, 176 },
+	{ 0x08, M5MOLS_RESTYPE_MONITOR, 240, 320 },	/* QVGA */
+	{ 0x09, M5MOLS_RESTYPE_MONITOR, 320, 240 },	/* QVGA */
+	{ 0x0c, M5MOLS_RESTYPE_MONITOR, 240, 400 },	/* WQVGA */
+	{ 0x0d, M5MOLS_RESTYPE_MONITOR, 400, 240 },	/* WQVGA */
+	{ 0x0e, M5MOLS_RESTYPE_MONITOR, 352, 288 },	/* CIF */
+	{ 0x13, M5MOLS_RESTYPE_MONITOR, 480, 360 },
+	{ 0x15, M5MOLS_RESTYPE_MONITOR, 640, 360 },	/* qHD */
+	{ 0x17, M5MOLS_RESTYPE_MONITOR, 640, 480 },	/* VGA */
+	{ 0x18, M5MOLS_RESTYPE_MONITOR, 720, 480 },
+	{ 0x1a, M5MOLS_RESTYPE_MONITOR, 800, 480 },	/* WVGA */
+	{ 0x1f, M5MOLS_RESTYPE_MONITOR, 800, 600 },	/* SVGA */
+	{ 0x21, M5MOLS_RESTYPE_MONITOR, 1280, 720 },	/* HD */
+	{ 0x25, M5MOLS_RESTYPE_MONITOR, 1920, 1080 },	/* 1080p */
+	{ 0x29, M5MOLS_RESTYPE_MONITOR, 3264, 2448 },	/* 2.63fps 8M */
+	{ 0x39, M5MOLS_RESTYPE_MONITOR, 800, 602 },	/* AHS_MON debug */
+
+	{ 0x02, M5MOLS_RESTYPE_CAPTURE, 320, 240 },	/* QVGA */
+	{ 0x04, M5MOLS_RESTYPE_CAPTURE, 400, 240 },	/* WQVGA */
+	{ 0x07, M5MOLS_RESTYPE_CAPTURE, 480, 360 },
+	{ 0x08, M5MOLS_RESTYPE_CAPTURE, 640, 360 },	/* qHD */
+	{ 0x09, M5MOLS_RESTYPE_CAPTURE, 640, 480 },	/* VGA */
+	{ 0x0a, M5MOLS_RESTYPE_CAPTURE, 800, 480 },	/* WVGA */
+	{ 0x10, M5MOLS_RESTYPE_CAPTURE, 1280, 720 },	/* HD */
+	{ 0x14, M5MOLS_RESTYPE_CAPTURE, 1280, 960 },	/* 1M */
+	{ 0x17, M5MOLS_RESTYPE_CAPTURE, 1600, 1200 },	/* 2M */
+	{ 0x19, M5MOLS_RESTYPE_CAPTURE, 1920, 1080 },	/* Full-HD */
+	{ 0x1a, M5MOLS_RESTYPE_CAPTURE, 2048, 1152 },	/* 3Mega */
+	{ 0x1b, M5MOLS_RESTYPE_CAPTURE, 2048, 1536 },
+	{ 0x1c, M5MOLS_RESTYPE_CAPTURE, 2560, 1440 },	/* 4Mega */
+	{ 0x1d, M5MOLS_RESTYPE_CAPTURE, 2560, 1536 },
+	{ 0x1f, M5MOLS_RESTYPE_CAPTURE, 2560, 1920 },	/* 5Mega */
+	{ 0x21, M5MOLS_RESTYPE_CAPTURE, 3264, 1836 },	/* 6Mega */
+	{ 0x22, M5MOLS_RESTYPE_CAPTURE, 3264, 1960 },
+	{ 0x25, M5MOLS_RESTYPE_CAPTURE, 3264, 2448 },	/* 8Mega */
+};
+
+/*
+ * m5mols_swap_byte() - byte array to integer conversion
+ * @size:	the size's kinds of I2C packet defined in the M-5MOLS datasheet
+ *
+ * Convert I2C data byte array with performing any required byte
+ * reordering to assure proper values for each data type, regardless
+ * of the architecture endianness.
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
+/*
+ * m5mols_read_reg() - raw function of I2C reading operation
+ * @size:	the kinds of I2C packet's size defined in the M-5MOLS datasheet
+ * @category:	the category value of I2C command
+ * @cmd:	the command
+ * @val:	the read values
+ *
+ * The M-5MOLS I2C operation always consists of category, command, value(s)
+ * as an element. The numbers of each operation vary according to reading or
+ * writing. The more specific explanation can be found in the m5mol.h.
+ */
+int m5mols_read_reg(struct v4l2_subdev *sd,
+		    enum m5mols_i2c_size size,
+		    u8 category, u8 cmd, u32 *val)
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
+	/* for designating category and command */
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 5;
+	msg[0].buf = wbuf;
+	wbuf[0] = 5;
+	wbuf[1] = M5MOLS_BYTE_READ;
+	wbuf[2] = category;
+	wbuf[3] = cmd;
+	wbuf[4] = size;
+
+	/* for reading desired data */
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = size + 1;
+	msg[1].buf = rbuf;
+
+	/* minimum stabilization time */
+	usleep_range(200, 200);
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"failed READ[%d] at cat[%02x] cmd[%02x]\n",
+			size, category, cmd);
+		return ret;
+	}
+
+	*val = m5mols_swap_byte(&rbuf[1], size);
+
+	return 0;
+}
+
+/*
+ * m5mols_write_reg() - raw function of I2C writing operation
+ * @size:	the kinds of I2C packet's size defined in the M-5MOLS datasheet
+ * @category:	the category value of I2C command
+ * @cmd:	the I2C command
+ * @val:	the written value(s)
+ */
+int m5mols_write_reg(struct v4l2_subdev *sd,
+		     enum m5mols_i2c_size size,
+		     u8 category, u8 cmd, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	struct i2c_msg msg[1];
+	u8 wbuf[I2C_MAX + 4];
+	u32 *buf;
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
+	msg->len = (u16)size + 4;
+	msg->buf = wbuf;
+	wbuf[0] = size + 4;
+	wbuf[1] = M5MOLS_BYTE_WRITE;
+	wbuf[2] = category;
+	wbuf[3] = cmd;
+
+	buf = (u32 *)&wbuf[4];
+	*buf = m5mols_swap_byte((u8 *)&val, size);
+
+	usleep_range(200, 200);
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"failed WRITE[%d] at cat[%02x] cmd[%02x], ret %d\n",
+			size, msg->buf[2], msg->buf[3], ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int m5mols_check_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 mask)
+{
+	u32 busy, i;
+	int ret;
+
+	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
+		ret = m5mols_read_reg(sd, I2C_8BIT, category, cmd, &busy);
+		if (ret < 0)
+			return ret;
+
+		if ((busy & mask) == mask)
+			return 0;
+	}
+
+	return -EBUSY;
+}
+
+/*
+ * m5mols_enable_interrupt() - clear pending register and set interrupt
+ *
+ * Before writing desired interrupt value, should clear INT_FACTOR register
+ * automatically documented in the M-5MOLS datasheet.
+ */
+int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	u32 dummy;
+	int ret;
+
+	ret = i2c_r8_system(sd, CAT0_INT_FACTOR, &dummy);
+	if (!ret)
+		ret = i2c_w8_system(sd, CAT0_INT_ENABLE,
+				info->ver.af ? reg & ~REG_INT_AF : reg);
+	return ret;
+}
+
+/*
+ * m5mols_write_mode() - Write the mode and check busy status.
+ *
+ * Changing the M-5MOLS mode accompanies a little delay all the time, so
+ * checking current busy status is needed to guarantee changing right mode.
+ */
+static int m5mols_write_mode(struct v4l2_subdev *sd, u32 mode)
+{
+	int ret = i2c_w8_system(sd, CAT0_SYSMODE, mode);
+	if (!ret)
+		ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, mode);
+
+	return ret;
+}
+
+/*
+ * m5mols_change_mode() - manage the M-5MOLS's mode.
+ * @mode:	the desired mode
+ *
+ * All commands of M-5MOLS belong to a specific its own mode. Each functionality
+ * can be guaranteed only when the sensor is operating in the mode which
+ * the command belongs to. The more explanation can be found in the m5mols.h.
+ */
+int m5mols_change_mode(struct m5mols_info *info, u32 mode)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 reg;
+	int ret = -EINVAL;
+
+	if (mode != REG_MODE_PARAM && mode != REG_MODE_MONITOR &&
+	    mode != REG_MODE_CAPTURE)
+		return ret;
+
+	ret = i2c_r8_system(sd, CAT0_SYSMODE, &reg);
+	if ((!ret && reg == mode) || ret)
+		return ret;
+
+	switch (reg) {
+	case REG_MODE_PARAM:
+		ret = m5mols_write_mode(sd, REG_MODE_MONITOR);
+		if (!ret && mode == REG_MODE_MONITOR)
+			break;
+		if (!ret)
+			ret = m5mols_write_mode(sd, REG_MODE_CAPTURE);
+		break;
+
+	case REG_MODE_MONITOR:
+		if (mode == REG_MODE_PARAM) {
+			ret = m5mols_write_mode(sd, REG_MODE_PARAM);
+			break;
+		}
+
+		ret = m5mols_write_mode(sd, REG_MODE_CAPTURE);
+		break;
+
+	case REG_MODE_CAPTURE:
+		ret = m5mols_write_mode(sd, REG_MODE_MONITOR);
+		if (!ret && mode == REG_MODE_MONITOR)
+			break;
+		if (!ret)
+			ret = m5mols_write_mode(sd, REG_MODE_PARAM);
+		break;
+
+	default:
+		dev_warn(&client->dev, "Wrong mode: %d", mode);
+	}
+
+	if (!ret)
+		info->mode = mode;
+
+	return ret;
+}
+
+/*
+ * m5mols_get_version() - Retrieve all internal version of M-5MOLS.
+ *
+ * The version information includes revisions hardware and firmware, AutoFocus
+ * alghorithm version and the version string. The version string should be read
+ * at the same register offset until the read value is NULL.
+ */
+static int m5mols_get_version(struct v4l2_subdev *sd)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *cdev = &client->dev;
+	union {
+		struct m5mols_version ver;
+		u8 bytes[VERSION_SIZE];
+	} value;
+	int ret, cmd = CAT0_CUSTOMER_CODE;
+
+	do {
+		ret = i2c_r8_system(sd, cmd, (u32 *)&value.bytes[cmd]);
+		if (ret)
+			return ret;
+	} while (cmd++ != CAT0_VERSION_AWB);
+
+	do {
+		ret = i2c_r8_system(sd, CAT0_VERSION_STRING,
+				(u32 *)&value.bytes[cmd]);
+		if (ret)
+			return ret;
+	} while (value.bytes[cmd++]);
+
+	ret = i2c_r8_lens(sd, CATA_AF_VERSION, (u32 *)&value.bytes[cmd]);
+	if (ret)
+		return ret;
+
+	/* store version information swapped for being readable */
+	info->ver	= value.ver;
+	info->ver.fw	= be16_to_cpu(info->ver.fw);
+	info->ver.hw	= be16_to_cpu(info->ver.hw);
+	info->ver.param	= be16_to_cpu(info->ver.param);
+	info->ver.awb	= be16_to_cpu(info->ver.awb);
+
+	dev_info(cdev, "Manufacturer\t[%s]\n",
+			is_manufacturer(info, SAMSUNG_ELECTRO) ?
+			"Samsung Electro-Machanics" :
+			is_manufacturer(info, SAMSUNG_OPTICS) ?
+			"Samsung Fiber-Optics" :
+			is_manufacturer(info, SAMSUNG_TECHWIN) ?
+			"Samsung Techwin" : "None");
+	dev_info(cdev, "Customer/Project\t[0x%02x/0x%02x]\n",
+			info->ver.customer, info->ver.project);
+	if (!info->ver.af)
+		dev_info(cdev, "No support Auto Focus on this firmware\n");
+
+	return ret;
+}
+
+/*
+ * __find_restype() - look up M-5MOLS resolution type according to pixel code
+ * @code:	pixel code
+ */
+static enum m5mols_restype __find_restype(enum v4l2_mbus_pixelcode code)
+{
+	enum m5mols_restype type = M5MOLS_RESTYPE_MONITOR;
+
+	do {
+		if (code == m5mols_default_ffmt[type].code)
+			return type;
+	} while (type++ != SIZE_DEFAULT_FFMT);
+
+	return 0;
+}
+
+/*
+ * __find_resolution() - look up preset and type of M-5MOLS's resolution
+ * @mf:         pixel format to find/negotiate the resolution preset for
+ * @type:	M-5MOLS resolution type
+ * @resolution:	M-5MOLS resolution preset register value
+ *
+ * Find nearest resolution matching resolution preset and adjust mf
+ * to supported values.
+ */
+static int __find_resolution(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_framefmt *mf,
+			     enum m5mols_restype *type,
+			     u32 *resolution)
+{
+	const struct m5mols_resolution *fsize = &m5mols_reg_res[0],
+				 *match = NULL;
+	enum m5mols_restype stype = __find_restype(mf->code);
+	int i = ARRAY_SIZE(m5mols_reg_res);
+	unsigned int min_err = ~0;
+
+	while (i--) {
+		int err;
+		if (stype != fsize->type)
+			continue;
+
+		err = abs(fsize->width - mf->width)
+			  + abs(fsize->height - mf->height);
+
+		if (err < min_err) {
+			min_err = err;
+			match = fsize;
+		}
+		fsize++;
+	}
+	if (match) {
+		mf->width  = match->width;
+		mf->height = match->height;
+		*resolution = match->reg;
+		*type = stype;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct v4l2_mbus_framefmt *__find_format(struct m5mols_info *info,
+				struct v4l2_subdev_fh *fh,
+				enum v4l2_subdev_format_whence which,
+				enum m5mols_restype type)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
+
+	return &info->ffmt[type];
+}
+
+static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	format = __find_format(info, fh, fmt->which, info->curr_res_type);
+	if (!format)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_mbus_framefmt *format = &fmt->format;
+	struct v4l2_mbus_framefmt *sfmt;
+	enum m5mols_restype type;
+	u32 resolution = 0;
+	int ret;
+
+	if (fmt->pad != 0)
+		return -EINVAL;
+
+	ret = __find_resolution(sd, format, &type, &resolution);
+	if (ret < 0)
+		return ret;
+
+	sfmt = __find_format(info, fh, fmt->which, type);
+	if (!sfmt)
+		return 0;
+
+	*sfmt		= m5mols_default_ffmt[type];
+	sfmt->width	= format->width;
+	sfmt->height	= format->height;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		info->resolution	= resolution;
+		info->code		= format->code;
+		info->curr_res_type	= type;
+	}
+
+	return 0;
+}
+
+static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (!code || code->index >= SIZE_DEFAULT_FFMT)
+		return -EINVAL;
+
+	code->code = m5mols_default_ffmt[code->index].code;
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
+	.enum_mbus_code	= m5mols_enum_mbus_code,
+	.get_fmt	= m5mols_get_fmt,
+	.set_fmt	= m5mols_set_fmt,
+};
+
+/*
+ * m5mols_sync_control() - do default control and v4l2_ctrl_handler_setup()
+ *
+ * This is used only streaming for syncing between v4l2_ctrl framework and
+ * m5mols's controls. First, do the scenemode to the sensor, then call
+ * v4l2_ctrl_handler_setup(). It can be same between some commands and
+ * the scenemode's in the default v4l2_ctrls. But, such commands of control
+ * should be prior to the scenemode's one.
+ */
+int m5mols_sync_control(struct m5mols_info *info)
+{
+	int ret = -EINVAL;
+
+	if (!is_ctrl_synced(info)) {
+		ret = m5mols_change_scenemode(info, REG_SCENE_NORMAL);
+		if (ret)
+			return ret;
+
+		v4l2_ctrl_handler_setup(&info->handle);
+
+		info->ctrl_sync = true;
+	}
+
+	return ret;
+}
+
+/*
+ * m5mols_start_monitor() - start monitor mode
+ *
+ * Before syncing control, do the commands in the available PARAMETER mode,
+ * and then, change the mode as MONITOR.
+ */
+static int m5mols_start_monitor(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	int ret;
+
+	ret = m5mols_change_mode(info, REG_MODE_PARAM);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, info->resolution);
+	if (!ret)
+		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS, REG_FPS_30);
+	if (!ret)
+		ret = m5mols_change_mode(info, REG_MODE_MONITOR);
+	if (!ret)
+		ret = m5mols_sync_control(info);
+
+	return ret;
+}
+
+static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+
+	if (enable) {
+		int ret = -EINVAL;
+		if (is_code(info->code, M5MOLS_RESTYPE_MONITOR))
+			ret = m5mols_start_monitor(info);
+		if (is_code(info->code, M5MOLS_RESTYPE_CAPTURE))
+			ret = m5mols_start_capture(info);
+
+		return ret;
+	}
+
+	return m5mols_change_mode(info, REG_MODE_PARAM);
+}
+
+static const struct v4l2_subdev_video_ops m5mols_video_ops = {
+	.s_stream	= m5mols_s_stream,
+};
+
+static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct m5mols_info *info = to_m5mols(sd);
+	int ret;
+
+	info->mode_save = info->mode;
+
+	ret = m5mols_change_mode(info, REG_MODE_PARAM);
+	if (!ret)
+		ret = m5mols_set_ctrl(ctrl);
+	if (!ret)
+		ret = m5mols_change_mode(info, info->mode_save);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
+	.s_ctrl		= m5mols_s_ctrl,
+};
+
+static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	const struct m5mols_platform_data *pdata = info->pdata;
+	int ret;
+
+	if (enable) {
+		if (is_powered(info))
+			return 0;
+
+		if (info->set_power) {
+			ret = info->set_power(&client->dev, 1);
+			if (ret)
+				return ret;
+		}
+
+		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
+		if (ret)
+			return ret;
+
+		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
+		usleep_range(1000, 1000);
+		info->power = true;
+
+		return ret;
+	}
+
+	if (!is_powered(info))
+		return 0;
+
+	ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
+	if (ret)
+		return ret;
+
+	if (info->set_power) {
+		ret = info->set_power(&client->dev, 0);
+		if (ret)
+			return ret;
+	}
+
+	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
+	usleep_range(1000, 1000);
+	info->power = false;
+
+	return ret;
+}
+
+/* m5mols_update_fw() - m5mols_update_fw() is optional. */
+int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
+		int (*set_power)(struct m5mols_info *, bool))
+{
+	return 0;
+}
+
+/*
+ * m5mols_sensor_armboot() - booting M-5MOLS internal ARM core.
+ *
+ * Booting internal ARM core makes the M-5MOLS is ready for getting commands
+ * with I2C. It's the first thing to be done after it powered up. It must wait
+ * at least 520ms recommended by M-5MOLS datasheet, after executing arm booting.
+ */
+static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	ret = i2c_w8_flash(sd, CATF_CAM_START, REG_START_ARM_BOOT);
+	if (ret < 0)
+		return ret;
+
+	msleep(520);
+
+	ret = m5mols_get_version(sd);
+	if (!ret)
+		ret = m5mols_update_fw(sd, m5mols_sensor_power);
+	if (ret)
+		return ret;
+
+	dev_dbg(&client->dev, "Success ARM Booting\n");
+
+	ret = i2c_w8_param(sd, CAT1_DATA_INTERFACE, REG_INTERFACE_MIPI);
+	if (!ret)
+		ret = m5mols_enable_interrupt(sd, REG_INT_AF);
+
+	return ret;
+}
+
+static int m5mols_init_controls(struct m5mols_info *info)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 max_exposure, step_zoom;
+	int ret;
+
+	/* Determine value's range & step of controls for various FW version */
+	ret = i2c_r16_ae(sd, CAT3_MAX_GAIN_MON, (u32 *)&max_exposure);
+	if (!ret)
+		step_zoom = is_manufacturer(info, SAMSUNG_OPTICS) ? 31 : 1;
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_handler_init(&info->handle, 6);
+	info->autowb = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_WHITE_BALANCE,
+			0, 1, 1, 0);
+	info->saturation = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_SATURATION,
+			1, 5, 1, 3);
+	info->zoom = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_ZOOM_ABSOLUTE,
+			1, 70, step_zoom, 1);
+	info->exposure = v4l2_ctrl_new_std(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
+			0, max_exposure, 1, (int)max_exposure/2);
+	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_COLORFX,
+			4, (1 << V4L2_COLORFX_BW), V4L2_COLORFX_NONE);
+	info->autoexposure = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
+			1, 0, V4L2_EXPOSURE_MANUAL);
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
+/*
+ * m5mols_s_power() - callback function of s_power in the subdev core operation
+ *
+ * Breaking the lens is considered when the sensor going to power off.
+ * But it provided only in the M-5MOLS with Samsung Techwin firiware. And, It
+ * calls Soft-Landing algorithm.
+ */
+static int m5mols_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	if (on) {
+		ret = m5mols_sensor_power(info, true);
+		if (!ret)
+			ret = m5mols_sensor_armboot(sd);
+		if (!ret)
+			ret = m5mols_init_controls(info);
+		if (!ret) {
+			info->ffmt[M5MOLS_RESTYPE_MONITOR] =
+				m5mols_default_ffmt[M5MOLS_RESTYPE_MONITOR];
+			info->ffmt[M5MOLS_RESTYPE_CAPTURE] =
+				m5mols_default_ffmt[M5MOLS_RESTYPE_CAPTURE];
+		}
+
+		return ret;
+	}
+
+	if (is_manufacturer(info, SAMSUNG_TECHWIN)) {
+		ret = m5mols_change_mode(info, REG_MODE_MONITOR);
+		if (!ret)
+			ret = i2c_w8_lens(sd, CATA_AF_EXECUTE, REG_AF_STOP);
+		if (!ret)
+			ret = i2c_w8_lens(sd, CATA_AF_MODE,
+					REG_AF_MODE_POWEROFF);
+		if (!ret)
+			ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_STATUS,
+					REG_AF_IDLE);
+		if (!ret)
+			dev_info(&client->dev, "Success soft-landing lens\n");
+	}
+
+	ret = m5mols_sensor_power(info, false);
+	if (!ret) {
+		v4l2_ctrl_handler_free(&info->handle);
+		info->ctrl_sync = false;
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
+	.s_power	= m5mols_s_power,
+	.g_ctrl		= v4l2_subdev_g_ctrl,
+	.s_ctrl		= v4l2_subdev_s_ctrl,
+	.queryctrl	= v4l2_subdev_queryctrl,
+	.querymenu	= v4l2_subdev_querymenu,
+	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
+	.log_status	= m5mols_log_status,
+};
+
+static const struct v4l2_subdev_ops m5mols_ops = {
+	.core		= &m5mols_core_ops,
+	.pad		= &m5mols_pad_ops,
+	.video		= &m5mols_video_ops,
+};
+
+static void m5mols_irq_work(struct work_struct *work)
+{
+	struct m5mols_info *info = container_of(work, struct m5mols_info,
+			work_irq);
+	struct v4l2_subdev *sd = &info->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 reg;
+	int ret;
+
+	/*
+	 * For preventing I2C operation when it's not powered and prepared for
+	 * the I2C operation.
+	 */
+	if (!is_powered(info) ||
+			i2c_r8_system(sd, CAT0_INT_FACTOR, &info->interrupt))
+		return;
+
+	switch (info->interrupt & REG_INT_MASK) {
+	case REG_INT_AF:
+		if (info->ver.af) {
+			ret = i2c_r8_lens(sd, CATA_AF_STATUS, &reg);
+			dev_dbg(&client->dev, "= AF %s\n",
+				reg == REG_AF_FAIL ? "Failed" :
+				reg == REG_AF_SUCCESS ? "Success" :
+				reg == REG_AF_IDLE ? "Idle" : "Busy");
+		}
+		break;
+	case REG_INT_CAPTURE:
+		if (!is_captured(info)) {
+			wake_up_interruptible(&info->wait_capture);
+			info->capture = true;
+		}
+		dev_dbg(&client->dev, "= CAPTURE\n");
+		break;
+	default:
+		dev_dbg(&client->dev, "= Nothing : %02x\n", reg);
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
+	if (!gpio_is_valid(pdata->gpio_reset)) {
+		dev_err(&client->dev, "No valid RESET GPIO specified\n");
+		return -EINVAL;
+	}
+
+	if (!pdata->irq) {
+		dev_err(&client->dev, "Interrupt not assigned\n");
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
+	info->set_power	= pdata->set_power;
+
+	ret = gpio_request(pdata->gpio_reset, "M5MOLS_NRST");
+	if (ret) {
+		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
+		goto out_free;
+	}
+
+	gpio_direction_output(pdata->gpio_reset, pdata->reset_polarity);
+
+	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
+	if (ret) {
+		dev_err(&client->dev, "Failed to get regulators: %d\n", ret);
+		goto out_gpio;
+	}
+
+	sd = &info->sd;
+	strlcpy(sd->name, MOD_NAME, sizeof(sd->name));
+	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
+
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
+	if (ret < 0)
+		goto out_gpio;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+
+	init_waitqueue_head(&info->wait_capture);
+	INIT_WORK(&info->work_irq, m5mols_irq_work);
+	ret = request_irq(pdata->irq, m5mols_irq_handler,
+			  IRQF_TRIGGER_RISING, MOD_NAME, sd);
+	if (ret) {
+		dev_err(&client->dev, "Failed to request irq: %d\n", ret);
+		goto out_reg;
+	}
+	info->curr_res_type = M5MOLS_RESTYPE_MONITOR;
+
+	v4l2_dbg(1, m5mols_debug, sd, "Probed m5mols driver.\n");
+
+	return 0;
+
+out_reg:
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+out_gpio:
+	gpio_free(pdata->gpio_reset);
+out_free:
+	kfree(info);
+	return ret;
+}
+
+static int m5mols_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct m5mols_info *info = to_m5mols(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	free_irq(info->pdata->irq, sd);
+
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+	gpio_free(info->pdata->gpio_reset);
+	kfree(info);
+
+	v4l2_dbg(1, m5mols_debug, sd, "Removed m5mols driver\n");
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
+MODULE_DESCRIPTION("Fujitsu M-5MOLS 8M Pixel camera driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
new file mode 100644
index 0000000..f07b362
--- /dev/null
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -0,0 +1,321 @@
+/*
+ * Register map for M-5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+#define CAT_FD			0x09
+#define CAT_LENS		0x0a
+#define CAT_CAPTURE_PARAMETER	0x0b
+#define CAT_CAPTURE_CONTROL	0x0c
+#define CAT_FLASH		0x0f	/* related with FW, Verions, booting */
+
+/*
+ * Category 0 - SYSTEM mode
+ *
+ * The SYSTEM mode in the M-5MOLS means area available to handle with the whole
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
+#define CAT0_VERSION_AWB	0x09	/* Auto WB version */
+#define CAT0_VERSION_STRING	0x0a	/* string including M-5MOLS */
+#define CAT0_SYSMODE		0x0b	/* SYSTEM mode register */
+#define CAT0_STATUS		0x0c	/* SYSTEM mode status register */
+#define CAT0_INT_FACTOR		0x10	/* interrupt pending register */
+#define CAT0_INT_ENABLE		0x11	/* interrupt enable register */
+
+#define REG_MODE_SYSINIT	0x00	/* SYSTEM mode */
+#define REG_MODE_PARAM		0x01	/* PARAMETER mode */
+#define REG_MODE_MONITOR	0x02	/* MONITOR mode */
+#define REG_MODE_CAPTURE	0x03	/* CAPTURE mode */
+
+#define REG_INT_MODE		(1 << 0)
+#define REG_INT_AF		(1 << 1)
+#define REG_INT_ZOOM		(1 << 2)
+#define REG_INT_CAPTURE		(1 << 3)
+#define REG_INT_FRAMESYNC	(1 << 4)
+#define REG_INT_FD		(1 << 5)
+#define REG_INT_LENS_INIT	(1 << 6)
+#define REG_INT_SOUND		(1 << 7)
+#define REG_INT_MASK		0x0f
+
+/*
+ * category 1 - PARAMETER mode
+ *
+ * This category supports function of camera features of M-5MOLS. It means we
+ * can handle with preview(MONITOR) resolution size/frame per second/interface
+ * between the sensor and the Application Processor/even the image effect.
+ */
+#define CAT1_DATA_INTERFACE	0x00	/* interface between sensor and AP */
+#define CAT1_MONITOR_SIZE	0x01	/* resolution at the MONITOR mode */
+#define CAT1_MONITOR_FPS	0x02	/* frame per second at this mode */
+#define CAT1_EFFECT		0x0b	/* image effects */
+
+#define REG_INTERFACE_MIPI	0x02
+
+#define REG_FPS_30		0x02
+
+#define REG_EFFECT_OFF		0x00
+#define REG_EFFECT_NEGA		0x01
+#define REG_EFFECT_EMBOSS	0x06
+#define REG_EFFECT_OUTLINE	0x07
+#define REG_EFFECT_WATERCOLOR	0x08
+
+/*
+ * Category 2 - MONITOR mode
+ *
+ * The MONITOR mode is same as preview mode as we said. The M-5MOLS has another
+ * mode named "Preview", but this preview mode is used at the case specific
+ * vider-recording mode. This mmode supports only YUYV format. On the other
+ * hand, the JPEG & RAW formats is supports by CAPTURE mode. And, there are
+ * another options like zoom/color effect(different with effect in PARAMETER
+ * mode)/anti hand shaking algorithm.
+ */
+#define CAT2_ZOOM		0x01	/* set the zoom position & execute */
+#define CAT2_ZOOM_STEP		0x03	/* set the zoom step */
+#define CAT2_CFIXB		0x09	/* CB value for color effect */
+#define CAT2_CFIXR		0x0a	/* CR value for color effect */
+#define CAT2_COLOR_EFFECT	0x0b	/* set on/off of color effect */
+#define CAT2_CHROMA_LVL		0x0f	/* set chroma level */
+#define CAT2_CHROMA_EN		0x10	/* set on/off of choroma */
+#define CAT2_EDGE_LVL		0x11	/* set sharpness level */
+#define CAT2_EDGE_EN		0x12	/* set on/off sharpness */
+#define CAT2_TONE_CTL		0x25	/* set tone color(contrast) */
+
+#define REG_CFIXB_SEPIA		0xd8
+#define REG_CFIXR_SEPIA		0x18
+
+#define REG_COLOR_EFFECT_OFF	0x00
+#define REG_COLOR_EFFECT_ON	0x01
+
+#define REG_CHROMA_OFF		0x00
+#define REG_CHROMA_ON		0x01
+
+#define REG_EDGE_OFF		0x00
+#define REG_EDGE_ON		0x01
+
+/*
+ * Category 3 - Auto Exposure
+ *
+ * The M-5MOLS exposure capbility is detailed as which is similar to digital
+ * camera. This category supports AE locking/various AE mode(range of exposure)
+ * /ISO/flickering/EV bias/shutter/meteoring, and anything else. And the
+ * maximum/minimum exposure gain value depending on M-5MOLS firmware, may be
+ * different. So, this category also provide getting the max/min values. And,
+ * each MONITOR and CAPTURE mode has each gain/shutter/max exposure values.
+ */
+#define CAT3_AE_LOCK		0x00	/* locking Auto exposure */
+#define CAT3_AE_MODE		0x01	/* set AE mode, mode means range */
+#define CAT3_ISO		0x05	/* set ISO */
+#define CAT3_EV_PRESET_MODE_MON	0x0a	/* EV(scenemode) preset for MONITOR */
+#define CAT3_EV_PRESET_MODE_CAP	0x0b	/* EV(scenemode) preset for CAPTURE */
+#define CAT3_MANUAL_GAIN_MON	0x12	/* meteoring value for the MONITOR */
+#define CAT3_MAX_GAIN_MON	0x1a	/* max gain value for the MONITOR */
+#define CAT3_MANUAL_GAIN_CAP	0x26	/* meteoring value for the CAPTURE */
+#define CAT3_AE_INDEX		0x38	/* AE index */
+
+#define REG_AE_UNLOCK		0x00
+#define REG_AE_LOCK		0x01
+
+#define REG_AE_MODE_OFF		0x00	/* AE off */
+#define REG_AE_MODE_ALL		0x01	/* calc AE in all block integral */
+#define REG_AE_MODE_CENTER	0x03	/* calc AE in center weighted */
+#define REG_AE_MODE_SPOT	0x06	/* calc AE in specific spot */
+
+#define REG_ISO_AUTO		0x00
+#define REG_ISO_50		0x0
+#define REG_ISO_100		0x02
+#define REG_ISO_200		0x03
+#define REG_ISO_400		0x04
+#define REG_ISO_800		0x05
+
+#define REG_SCENE_NORMAL	0x00
+#define REG_SCENE_PORTRAIT	0x01
+#define REG_SCENE_LANDSCAPE	0x02
+#define REG_SCENE_SPORTS	0x03
+#define REG_SCENE_PARTY_INDOOR	0x04
+#define REG_SCENE_BEACH_SNOW	0x05
+#define REG_SCENE_SUNSET	0x06
+#define REG_SCENE_DAWN_DUSK	0x07
+#define REG_SCENE_FALL		0x08
+#define REG_SCENE_NIGHT		0x09
+#define REG_SCENE_AGAINST_LIGHT	0x0a
+#define REG_SCENE_FIRE		0x0b
+#define REG_SCENE_TEXT		0x0c
+#define REG_SCENE_CANDLE	0x0d
+#define REG_SCENE_NONE		0xff
+
+#define REG_AE_INDEX_20_NEG	0x00
+#define REG_AE_INDEX_15_NEG	0x01
+#define REG_AE_INDEX_10_NEG	0x02
+#define REG_AE_INDEX_05_NEG	0x03
+#define REG_AE_INDEX_00		0x04
+#define REG_AE_INDEX_05_POS	0x05
+#define REG_AE_INDEX_10_POS	0x06
+#define REG_AE_INDEX_15_POS	0x07
+#define REG_AE_INDEX_20_POS	0x08
+
+/*
+ * Category 6 - White Balance
+ *
+ * This cagetory provide AWB locking/mode/preset/speed/gain bias, etc.
+ */
+#define CAT6_AWB_LOCK		0x00	/* locking Auto Whitebalance */
+#define CAT6_AWB_MODE		0x02	/* set Auto or Manual */
+#define CAT6_AWB_MANUAL		0x03	/* set Manual(preset) value */
+
+#define REG_AWB_UNLOCK		0x00
+#define REG_AWB_LOCK		0x01
+
+#define REG_AWB_MODE_AUTO	0x01	/* AWB off */
+#define REG_AWB_MODE_PRESET	0x02	/* AWB preset */
+
+#define REG_AWB_INCANDESCENT	0x01
+#define REG_AWB_FLUORESCENT_1	0x02
+#define REG_AWB_FLUORESCENT_2	0x03
+#define REG_AWB_DAYLIGHT	0x04
+#define REG_AWB_CLOUDY		0x05
+#define REG_AWB_SHADE		0x06
+#define REG_AWB_HORIZON		0x07
+#define REG_AWB_LEDLIGHT	0x09
+
+/*
+ * Category 7 - EXIF information
+ */
+#define CAT7_INFO_EXPTIME_NU	0x00
+#define CAT7_INFO_EXPTIME_DE	0x04
+#define CAT7_INFO_TV_NU		0x08
+#define CAT7_INFO_TV_DE		0x0c
+#define CAT7_INFO_AV_NU		0x10
+#define CAT7_INFO_AV_DE		0x14
+#define CAT7_INFO_BV_NU		0x18
+#define CAT7_INFO_BV_DE		0x1c
+#define CAT7_INFO_EBV_NU	0x20
+#define CAT7_INFO_EBV_DE	0x24
+#define CAT7_INFO_ISO		0x28
+#define CAT7_INFO_FLASH		0x2a
+#define CAT7_INFO_SDR		0x2c
+#define CAT7_INFO_QVAL		0x2e
+
+/*
+ * Category 9 - Face Detection
+ */
+#define CAT9_FD_CTL		0x00
+
+#define BIT_FD_EN		0
+#define BIT_FD_DRAW_FACE_FRAME	4
+#define BIT_FD_DRAW_SMILE_LVL	6
+#define REG_FD(shift)		(1 << shift)
+#define REG_FD_OFF		0x0
+
+/*
+ * Category A - Lens Parameter
+ */
+#define CATA_AF_MODE		0x01
+#define CATA_AF_EXECUTE		0x02
+#define CATA_AF_STATUS		0x03
+#define CATA_AF_VERSION		0x0a
+
+#define REG_AF_FAIL		0x00
+#define REG_AF_SUCCESS		0x02
+#define REG_AF_IDLE		0x04
+#define REG_AF_BUSY		0x05
+
+#define REG_AF_MODE_NORMAL	0x00	/* Normal AF, one time */
+#define REG_AF_MODE_MACRO	0x01	/* Macro AF, one time */
+#define REG_AF_MODE_POWEROFF	0x07
+
+#define REG_AF_STOP		0x00
+#define REG_AF_EXE_AUTO		0x01
+#define REG_AF_EXE_CAF		0x02
+
+/*
+ * Category B - CAPTURE Parameter
+ */
+#define CATB_YUVOUT_MAIN	0x00
+#define CATB_MAIN_IMAGE_SIZE	0x01
+#define CATB_MCC_MODE		0x1d
+#define CATB_WDR_EN		0x2c
+#define CATB_LIGHT_CTRL		0x40
+#define CATB_FLASH_CTRL		0x41
+
+/* n = 0..3 */
+#define CATB_JPEG_SIZE_MAX(n)	(0x12 - (n))
+#define CATB_JPEG_SIZE_MIN(n)	(0x16 - (n))
+
+#define REG_YUV422		0x00
+#define REG_BAYER10		0x05
+#define REG_BAYER8		0x06
+#define REG_JPEG		0x10
+
+#define REG_MCC_OFF		0x00
+#define REG_MCC_NORMAL		0x01
+
+#define REG_WDR_OFF		0x00
+#define REG_WDR_ON		0x01
+#define REG_WDR_AUTO		0x02
+
+#define REG_LIGHT_OFF		0x00
+#define REG_LIGHT_ON		0x01
+#define REG_LIGHT_AUTO		0x02
+
+#define REG_FLASH_OFF		0x00
+#define REG_FLASH_ON		0x01
+#define REG_FLASH_AUTO		0x02
+
+/*
+ * Category C - CAPTURE Control
+ */
+#define CATC_CAP_MODE		0x00
+#define CATC_CAP_SEL_FRAME	0x06	/* It determines Single or Multi. */
+#define CATC_CAP_START		0x09
+#define CATC_CAP_IMAGE_SIZE	0x0d
+#define CATC_CAP_THUMB_SIZE	0x11
+
+#define REG_CAP_MODE_NONE	0x00
+#define REG_CAP_MODE_ANTI_SHAKE	0x02
+
+#define REG_CAP_START_MAIN	0x01
+#define REG_CAP_START_THUMB	0x03
+
+/*
+ * Category F - Flash
+ *
+ * This mode provides functions about internal flash stuff and system startup.
+ */
+#define CATF_CAM_START		0x12	/* It start internal ARM core booting
+					 * after power-up */
+
+#define REG_START_ARM_BOOT	0x01
+
+#endif	/* M5MOLS_REG_H */
diff --git a/include/media/m5mols.h b/include/media/m5mols.h
new file mode 100644
index 0000000..2d7e7ca
--- /dev/null
+++ b/include/media/m5mols.h
@@ -0,0 +1,35 @@
+/*
+ * Driver header for M-5MOLS 8M Pixel camera sensor with ISP
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: HeungJun Kim, riverful.kim@samsung.com
+ *
+ * Copyright (C) 2009 Samsung Electronics Co., Ltd.
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
+ * @gpio_reset:	GPIO driving the reset pin of M-5MOLS
+ * @reset_polarity: active state for gpio_rst pin, 0 or 1
+ * @set_power:	an additional callback to the board setup code
+ *		to be called after enabling and before disabling
+ *		the sensor's supply regulators
+ */
+struct m5mols_platform_data {
+	int irq;
+	int gpio_reset;
+	u8 reset_polarity;
+	int (*set_power)(struct device *dev, int on);
+};
+
+#endif	/* MEDIA_M5MOLS_H */
-- 
1.7.0.4

