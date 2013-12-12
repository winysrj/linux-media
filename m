Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3456 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LLMU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 07:20:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	David Cohen <dacohen@gmail.com>
Subject: [RFC PATCH 2/2] omap24xx/tcm825x: move to staging for future removal.
Date: Thu, 12 Dec 2013 13:20:22 +0100
Message-Id: <1386850822-3487-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386850822-3487-1-git-send-email-hverkuil@xs4all.nl>
References: <1386850822-3487-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The omap24xx driver and the tcm825x sensor driver are the only two
remaining drivers to still use the old deprecated v4l2-int-device API.

Nobody maintains these drivers anymore. But unfortunately the v4l2-int-device
API is used by out-of-tree drivers (MXC platform). This is a very bad situation
since as long as this deprecated API stays in the kernel there is no reason for
those out-of-tree drivers to convert.

This patch moves v4l2-int-device and the two drivers that depend on it to
staging in preparation for their removal.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: David Cohen <dacohen@gmail.com>
---
 drivers/media/i2c/Kconfig                        |    8 -
 drivers/media/i2c/Makefile                       |    1 -
 drivers/media/i2c/tcm825x.c                      |  937 -----------
 drivers/media/i2c/tcm825x.h                      |  200 ---
 drivers/media/platform/Kconfig                   |    7 -
 drivers/media/platform/Makefile                  |    3 -
 drivers/media/platform/omap24xxcam-dma.c         |  601 -------
 drivers/media/platform/omap24xxcam.c             | 1888 ----------------------
 drivers/media/platform/omap24xxcam.h             |  596 -------
 drivers/media/v4l2-core/Kconfig                  |   11 -
 drivers/media/v4l2-core/Makefile                 |    1 -
 drivers/media/v4l2-core/v4l2-int-device.c        |  164 --
 drivers/staging/media/Kconfig                    |    2 +
 drivers/staging/media/Makefile                   |    2 +
 drivers/staging/media/omap24xx/Kconfig           |   35 +
 drivers/staging/media/omap24xx/Makefile          |    5 +
 drivers/staging/media/omap24xx/omap24xxcam-dma.c |  601 +++++++
 drivers/staging/media/omap24xx/omap24xxcam.c     | 1888 ++++++++++++++++++++++
 drivers/staging/media/omap24xx/omap24xxcam.h     |  596 +++++++
 drivers/staging/media/omap24xx/tcm825x.c         |  937 +++++++++++
 drivers/staging/media/omap24xx/tcm825x.h         |  200 +++
 drivers/staging/media/omap24xx/v4l2-int-device.c |  164 ++
 drivers/staging/media/omap24xx/v4l2-int-device.h |  305 ++++
 include/media/v4l2-int-device.h                  |  305 ----
 24 files changed, 4735 insertions(+), 4722 deletions(-)
 delete mode 100644 drivers/media/i2c/tcm825x.c
 delete mode 100644 drivers/media/i2c/tcm825x.h
 delete mode 100644 drivers/media/platform/omap24xxcam-dma.c
 delete mode 100644 drivers/media/platform/omap24xxcam.c
 delete mode 100644 drivers/media/platform/omap24xxcam.h
 delete mode 100644 drivers/media/v4l2-core/v4l2-int-device.c
 create mode 100644 drivers/staging/media/omap24xx/Kconfig
 create mode 100644 drivers/staging/media/omap24xx/Makefile
 create mode 100644 drivers/staging/media/omap24xx/omap24xxcam-dma.c
 create mode 100644 drivers/staging/media/omap24xx/omap24xxcam.c
 create mode 100644 drivers/staging/media/omap24xx/omap24xxcam.h
 create mode 100644 drivers/staging/media/omap24xx/tcm825x.c
 create mode 100644 drivers/staging/media/omap24xx/tcm825x.h
 create mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.c
 create mode 100644 drivers/staging/media/omap24xx/v4l2-int-device.h
 delete mode 100644 include/media/v4l2-int-device.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 842654d..997cd66 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -555,14 +555,6 @@ config VIDEO_MT9V032
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
 
-config VIDEO_TCM825X
-	tristate "TCM825x camera sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_INT_DEVICE
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a driver for the Toshiba TCM825x VGA camera sensor.
-	  It is used for example in Nokia N800.
-
 config VIDEO_SR030PC30
 	tristate "Siliconfile SR030PC30 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index e03f177..abd25e3 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
-obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
 obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
 obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
diff --git a/drivers/media/i2c/tcm825x.c b/drivers/media/i2c/tcm825x.c
deleted file mode 100644
index 9252529..0000000
--- a/drivers/media/i2c/tcm825x.c
+++ /dev/null
@@ -1,937 +0,0 @@
-/*
- * drivers/media/i2c/tcm825x.c
- *
- * TCM825X camera sensor driver.
- *
- * Copyright (C) 2007 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * Based on code from David Cohen <david.cohen@indt.org.br>
- *
- * This driver was based on ov9640 sensor driver from MontaVista
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#include <linux/i2c.h>
-#include <linux/module.h>
-#include <media/v4l2-int-device.h>
-
-#include "tcm825x.h"
-
-/*
- * The sensor has two fps modes: the lower one just gives half the fps
- * at the same xclk than the high one.
- */
-#define MAX_FPS 30
-#define MIN_FPS 8
-#define MAX_HALF_FPS (MAX_FPS / 2)
-#define HIGH_FPS_MODE_LOWER_LIMIT 14
-#define DEFAULT_FPS MAX_HALF_FPS
-
-struct tcm825x_sensor {
-	const struct tcm825x_platform_data *platform_data;
-	struct v4l2_int_device *v4l2_int_device;
-	struct i2c_client *i2c_client;
-	struct v4l2_pix_format pix;
-	struct v4l2_fract timeperframe;
-};
-
-/* list of image formats supported by TCM825X sensor */
-static const struct v4l2_fmtdesc tcm825x_formats[] = {
-	{
-		.description = "YUYV (YUV 4:2:2), packed",
-		.pixelformat = V4L2_PIX_FMT_UYVY,
-	}, {
-		/* Note:  V4L2 defines RGB565 as:
-		 *
-		 *      Byte 0                    Byte 1
-		 *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
-		 *
-		 * We interpret RGB565 as:
-		 *
-		 *      Byte 0                    Byte 1
-		 *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
-		 */
-		.description = "RGB565, le",
-		.pixelformat = V4L2_PIX_FMT_RGB565,
-	},
-};
-
-#define TCM825X_NUM_CAPTURE_FORMATS	ARRAY_SIZE(tcm825x_formats)
-
-/*
- * TCM825X register configuration for all combinations of pixel format and
- * image size
- */
-static const struct tcm825x_reg subqcif	=	{ 0x20, TCM825X_PICSIZ };
-static const struct tcm825x_reg qcif	=	{ 0x18, TCM825X_PICSIZ };
-static const struct tcm825x_reg cif	=	{ 0x14, TCM825X_PICSIZ };
-static const struct tcm825x_reg qqvga	=	{ 0x0c, TCM825X_PICSIZ };
-static const struct tcm825x_reg qvga	=	{ 0x04, TCM825X_PICSIZ };
-static const struct tcm825x_reg vga	=	{ 0x00, TCM825X_PICSIZ };
-
-static const struct tcm825x_reg yuv422	=	{ 0x00, TCM825X_PICFMT };
-static const struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
-
-/* Our own specific controls */
-#define V4L2_CID_ALC				V4L2_CID_PRIVATE_BASE
-#define V4L2_CID_H_EDGE_EN			V4L2_CID_PRIVATE_BASE + 1
-#define V4L2_CID_V_EDGE_EN			V4L2_CID_PRIVATE_BASE + 2
-#define V4L2_CID_LENS				V4L2_CID_PRIVATE_BASE + 3
-#define V4L2_CID_MAX_EXPOSURE_TIME		V4L2_CID_PRIVATE_BASE + 4
-#define V4L2_CID_LAST_PRIV			V4L2_CID_MAX_EXPOSURE_TIME
-
-/*  Video controls  */
-static struct vcontrol {
-	struct v4l2_queryctrl qc;
-	u16 reg;
-	u16 start_bit;
-} video_control[] = {
-	{
-		{
-			.id = V4L2_CID_GAIN,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Gain",
-			.minimum = 0,
-			.maximum = 63,
-			.step = 1,
-		},
-		.reg = TCM825X_AG,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_RED_BALANCE,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Red Balance",
-			.minimum = 0,
-			.maximum = 255,
-			.step = 1,
-		},
-		.reg = TCM825X_MRG,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_BLUE_BALANCE,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Blue Balance",
-			.minimum = 0,
-			.maximum = 255,
-			.step = 1,
-		},
-		.reg = TCM825X_MBG,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_AUTO_WHITE_BALANCE,
-			.type = V4L2_CTRL_TYPE_BOOLEAN,
-			.name = "Auto White Balance",
-			.minimum = 0,
-			.maximum = 1,
-			.step = 0,
-		},
-		.reg = TCM825X_AWBSW,
-		.start_bit = 7,
-	},
-	{
-		{
-			.id = V4L2_CID_EXPOSURE,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Exposure Time",
-			.minimum = 0,
-			.maximum = 0x1fff,
-			.step = 1,
-		},
-		.reg = TCM825X_ESRSPD_U,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_HFLIP,
-			.type = V4L2_CTRL_TYPE_BOOLEAN,
-			.name = "Mirror Image",
-			.minimum = 0,
-			.maximum = 1,
-			.step = 0,
-		},
-		.reg = TCM825X_H_INV,
-		.start_bit = 6,
-	},
-	{
-		{
-			.id = V4L2_CID_VFLIP,
-			.type = V4L2_CTRL_TYPE_BOOLEAN,
-			.name = "Vertical Flip",
-			.minimum = 0,
-			.maximum = 1,
-			.step = 0,
-		},
-		.reg = TCM825X_V_INV,
-		.start_bit = 7,
-	},
-	/* Private controls */
-	{
-		{
-			.id = V4L2_CID_ALC,
-			.type = V4L2_CTRL_TYPE_BOOLEAN,
-			.name = "Auto Luminance Control",
-			.minimum = 0,
-			.maximum = 1,
-			.step = 0,
-		},
-		.reg = TCM825X_ALCSW,
-		.start_bit = 7,
-	},
-	{
-		{
-			.id = V4L2_CID_H_EDGE_EN,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Horizontal Edge Enhancement",
-			.minimum = 0,
-			.maximum = 0xff,
-			.step = 1,
-		},
-		.reg = TCM825X_HDTG,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_V_EDGE_EN,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Vertical Edge Enhancement",
-			.minimum = 0,
-			.maximum = 0xff,
-			.step = 1,
-		},
-		.reg = TCM825X_VDTG,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_LENS,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Lens Shading Compensation",
-			.minimum = 0,
-			.maximum = 0x3f,
-			.step = 1,
-		},
-		.reg = TCM825X_LENS,
-		.start_bit = 0,
-	},
-	{
-		{
-			.id = V4L2_CID_MAX_EXPOSURE_TIME,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-			.name = "Maximum Exposure Time",
-			.minimum = 0,
-			.maximum = 0x3,
-			.step = 1,
-		},
-		.reg = TCM825X_ESRLIM,
-		.start_bit = 5,
-	},
-};
-
-
-static const struct tcm825x_reg *tcm825x_siz_reg[NUM_IMAGE_SIZES] =
-{ &subqcif, &qqvga, &qcif, &qvga, &cif, &vga };
-
-static const struct tcm825x_reg *tcm825x_fmt_reg[NUM_PIXEL_FORMATS] =
-{ &yuv422, &rgb565 };
-
-/*
- * Read a value from a register in an TCM825X sensor device.  The value is
- * returned in 'val'.
- * Returns zero if successful, or non-zero otherwise.
- */
-static int tcm825x_read_reg(struct i2c_client *client, int reg)
-{
-	int err;
-	struct i2c_msg msg[2];
-	u8 reg_buf, data_buf = 0;
-
-	if (!client->adapter)
-		return -ENODEV;
-
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = &reg_buf;
-	msg[1].addr = client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = 1;
-	msg[1].buf = &data_buf;
-
-	reg_buf = reg;
-
-	err = i2c_transfer(client->adapter, msg, 2);
-	if (err < 0)
-		return err;
-	return data_buf;
-}
-
-/*
- * Write a value to a register in an TCM825X sensor device.
- * Returns zero if successful, or non-zero otherwise.
- */
-static int tcm825x_write_reg(struct i2c_client *client, u8 reg, u8 val)
-{
-	int err;
-	struct i2c_msg msg[1];
-	unsigned char data[2];
-
-	if (!client->adapter)
-		return -ENODEV;
-
-	msg->addr = client->addr;
-	msg->flags = 0;
-	msg->len = 2;
-	msg->buf = data;
-	data[0] = reg;
-	data[1] = val;
-	err = i2c_transfer(client->adapter, msg, 1);
-	if (err >= 0)
-		return 0;
-	return err;
-}
-
-static int __tcm825x_write_reg_mask(struct i2c_client *client,
-				    u8 reg, u8 val, u8 mask)
-{
-	int rc;
-
-	/* need to do read - modify - write */
-	rc = tcm825x_read_reg(client, reg);
-	if (rc < 0)
-		return rc;
-
-	rc &= (~mask);	/* Clear the masked bits */
-	val &= mask;	/* Enforce mask on value */
-	val |= rc;
-
-	/* write the new value to the register */
-	rc = tcm825x_write_reg(client, reg, val);
-	if (rc)
-		return rc;
-
-	return 0;
-}
-
-#define tcm825x_write_reg_mask(client, regmask, val)			\
-	__tcm825x_write_reg_mask(client, TCM825X_ADDR((regmask)), val,	\
-				 TCM825X_MASK((regmask)))
-
-
-/*
- * Initialize a list of TCM825X registers.
- * The list of registers is terminated by the pair of values
- * { TCM825X_REG_TERM, TCM825X_VAL_TERM }.
- * Returns zero if successful, or non-zero otherwise.
- */
-static int tcm825x_write_default_regs(struct i2c_client *client,
-				      const struct tcm825x_reg *reglist)
-{
-	int err;
-	const struct tcm825x_reg *next = reglist;
-
-	while (!((next->reg == TCM825X_REG_TERM)
-		 && (next->val == TCM825X_VAL_TERM))) {
-		err = tcm825x_write_reg(client, next->reg, next->val);
-		if (err) {
-			dev_err(&client->dev, "register writing failed\n");
-			return err;
-		}
-		next++;
-	}
-
-	return 0;
-}
-
-static struct vcontrol *find_vctrl(int id)
-{
-	int i;
-
-	if (id < V4L2_CID_BASE)
-		return NULL;
-
-	for (i = 0; i < ARRAY_SIZE(video_control); i++)
-		if (video_control[i].qc.id == id)
-			return &video_control[i];
-
-	return NULL;
-}
-
-/*
- * Find the best match for a requested image capture size.  The best match
- * is chosen as the nearest match that has the same number or fewer pixels
- * as the requested size, or the smallest image size if the requested size
- * has fewer pixels than the smallest image.
- */
-static enum image_size tcm825x_find_size(struct v4l2_int_device *s,
-					 unsigned int width,
-					 unsigned int height)
-{
-	enum image_size isize;
-	unsigned long pixels = width * height;
-	struct tcm825x_sensor *sensor = s->priv;
-
-	for (isize = subQCIF; isize < VGA; isize++) {
-		if (tcm825x_sizes[isize + 1].height
-		    * tcm825x_sizes[isize + 1].width > pixels) {
-			dev_dbg(&sensor->i2c_client->dev, "size %d\n", isize);
-
-			return isize;
-		}
-	}
-
-	dev_dbg(&sensor->i2c_client->dev, "format default VGA\n");
-
-	return VGA;
-}
-
-/*
- * Configure the TCM825X for current image size, pixel format, and
- * frame period. fper is the frame period (in seconds) expressed as a
- * fraction. Returns zero if successful, or non-zero otherwise. The
- * actual frame period is returned in fper.
- */
-static int tcm825x_configure(struct v4l2_int_device *s)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_pix_format *pix = &sensor->pix;
-	enum image_size isize = tcm825x_find_size(s, pix->width, pix->height);
-	struct v4l2_fract *fper = &sensor->timeperframe;
-	enum pixel_format pfmt;
-	int err;
-	u32 tgt_fps;
-	u8 val;
-
-	/* common register initialization */
-	err = tcm825x_write_default_regs(
-		sensor->i2c_client, sensor->platform_data->default_regs());
-	if (err)
-		return err;
-
-	/* configure image size */
-	val = tcm825x_siz_reg[isize]->val;
-	dev_dbg(&sensor->i2c_client->dev,
-		"configuring image size %d\n", isize);
-	err = tcm825x_write_reg_mask(sensor->i2c_client,
-				     tcm825x_siz_reg[isize]->reg, val);
-	if (err)
-		return err;
-
-	/* configure pixel format */
-	switch (pix->pixelformat) {
-	default:
-	case V4L2_PIX_FMT_RGB565:
-		pfmt = RGB565;
-		break;
-	case V4L2_PIX_FMT_UYVY:
-		pfmt = YUV422;
-		break;
-	}
-
-	dev_dbg(&sensor->i2c_client->dev,
-		"configuring pixel format %d\n", pfmt);
-	val = tcm825x_fmt_reg[pfmt]->val;
-
-	err = tcm825x_write_reg_mask(sensor->i2c_client,
-				     tcm825x_fmt_reg[pfmt]->reg, val);
-	if (err)
-		return err;
-
-	/*
-	 * For frame rate < 15, the FPS reg (addr 0x02, bit 7) must be
-	 * set. Frame rate will be halved from the normal.
-	 */
-	tgt_fps = fper->denominator / fper->numerator;
-	if (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) {
-		val = tcm825x_read_reg(sensor->i2c_client, 0x02);
-		val |= 0x80;
-		tcm825x_write_reg(sensor->i2c_client, 0x02, val);
-	}
-
-	return 0;
-}
-
-static int ioctl_queryctrl(struct v4l2_int_device *s,
-				struct v4l2_queryctrl *qc)
-{
-	struct vcontrol *control;
-
-	control = find_vctrl(qc->id);
-
-	if (control == NULL)
-		return -EINVAL;
-
-	*qc = control->qc;
-
-	return 0;
-}
-
-static int ioctl_g_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct i2c_client *client = sensor->i2c_client;
-	int val, r;
-	struct vcontrol *lvc;
-
-	/* exposure time is special, spread across 2 registers */
-	if (vc->id == V4L2_CID_EXPOSURE) {
-		int val_lower, val_upper;
-
-		val_upper = tcm825x_read_reg(client,
-					     TCM825X_ADDR(TCM825X_ESRSPD_U));
-		if (val_upper < 0)
-			return val_upper;
-		val_lower = tcm825x_read_reg(client,
-					     TCM825X_ADDR(TCM825X_ESRSPD_L));
-		if (val_lower < 0)
-			return val_lower;
-
-		vc->value = ((val_upper & 0x1f) << 8) | (val_lower);
-		return 0;
-	}
-
-	lvc = find_vctrl(vc->id);
-	if (lvc == NULL)
-		return -EINVAL;
-
-	r = tcm825x_read_reg(client, TCM825X_ADDR(lvc->reg));
-	if (r < 0)
-		return r;
-	val = r & TCM825X_MASK(lvc->reg);
-	val >>= lvc->start_bit;
-
-	if (val < 0)
-		return val;
-
-	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
-		val ^= sensor->platform_data->is_upside_down();
-
-	vc->value = val;
-	return 0;
-}
-
-static int ioctl_s_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct i2c_client *client = sensor->i2c_client;
-	struct vcontrol *lvc;
-	int val = vc->value;
-
-	/* exposure time is special, spread across 2 registers */
-	if (vc->id == V4L2_CID_EXPOSURE) {
-		int val_lower, val_upper;
-		val_lower = val & TCM825X_MASK(TCM825X_ESRSPD_L);
-		val_upper = (val >> 8) & TCM825X_MASK(TCM825X_ESRSPD_U);
-
-		if (tcm825x_write_reg_mask(client,
-					   TCM825X_ESRSPD_U, val_upper))
-			return -EIO;
-
-		if (tcm825x_write_reg_mask(client,
-					   TCM825X_ESRSPD_L, val_lower))
-			return -EIO;
-
-		return 0;
-	}
-
-	lvc = find_vctrl(vc->id);
-	if (lvc == NULL)
-		return -EINVAL;
-
-	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
-		val ^= sensor->platform_data->is_upside_down();
-
-	val = val << lvc->start_bit;
-	if (tcm825x_write_reg_mask(client, lvc->reg, val))
-		return -EIO;
-
-	return 0;
-}
-
-static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
-				   struct v4l2_fmtdesc *fmt)
-{
-	int index = fmt->index;
-
-	switch (fmt->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (index >= TCM825X_NUM_CAPTURE_FORMATS)
-			return -EINVAL;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	fmt->flags = tcm825x_formats[index].flags;
-	strlcpy(fmt->description, tcm825x_formats[index].description,
-		sizeof(fmt->description));
-	fmt->pixelformat = tcm825x_formats[index].pixelformat;
-
-	return 0;
-}
-
-static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
-			     struct v4l2_format *f)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	enum image_size isize;
-	int ifmt;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-
-	isize = tcm825x_find_size(s, pix->width, pix->height);
-	dev_dbg(&sensor->i2c_client->dev, "isize = %d num_capture = %lu\n",
-		isize, (unsigned long)TCM825X_NUM_CAPTURE_FORMATS);
-
-	pix->width = tcm825x_sizes[isize].width;
-	pix->height = tcm825x_sizes[isize].height;
-
-	for (ifmt = 0; ifmt < TCM825X_NUM_CAPTURE_FORMATS; ifmt++)
-		if (pix->pixelformat == tcm825x_formats[ifmt].pixelformat)
-			break;
-
-	if (ifmt == TCM825X_NUM_CAPTURE_FORMATS)
-		ifmt = 0;	/* Default = YUV 4:2:2 */
-
-	pix->pixelformat = tcm825x_formats[ifmt].pixelformat;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = pix->width * TCM825X_BYTES_PER_PIXEL;
-	pix->sizeimage = pix->bytesperline * pix->height;
-	pix->priv = 0;
-	dev_dbg(&sensor->i2c_client->dev, "format = 0x%08x\n",
-		pix->pixelformat);
-
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_UYVY:
-	default:
-		pix->colorspace = V4L2_COLORSPACE_JPEG;
-		break;
-	case V4L2_PIX_FMT_RGB565:
-		pix->colorspace = V4L2_COLORSPACE_SRGB;
-		break;
-	}
-
-	return 0;
-}
-
-static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int rval;
-
-	rval = ioctl_try_fmt_cap(s, f);
-	if (rval)
-		return rval;
-
-	rval = tcm825x_configure(s);
-
-	sensor->pix = *pix;
-
-	return rval;
-}
-
-static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-
-	f->fmt.pix = sensor->pix;
-
-	return 0;
-}
-
-static int ioctl_g_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_captureparm *cparm = &a->parm.capture;
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	memset(a, 0, sizeof(*a));
-	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	cparm->capability = V4L2_CAP_TIMEPERFRAME;
-	cparm->timeperframe = sensor->timeperframe;
-
-	return 0;
-}
-
-static int ioctl_s_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
-	u32 tgt_fps;	/* target frames per secound */
-	int rval;
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if ((timeperframe->numerator == 0)
-	    || (timeperframe->denominator == 0)) {
-		timeperframe->denominator = DEFAULT_FPS;
-		timeperframe->numerator = 1;
-	}
-
-	tgt_fps = timeperframe->denominator / timeperframe->numerator;
-
-	if (tgt_fps > MAX_FPS) {
-		timeperframe->denominator = MAX_FPS;
-		timeperframe->numerator = 1;
-	} else if (tgt_fps < MIN_FPS) {
-		timeperframe->denominator = MIN_FPS;
-		timeperframe->numerator = 1;
-	}
-
-	sensor->timeperframe = *timeperframe;
-
-	rval = tcm825x_configure(s);
-
-	return rval;
-}
-
-static int ioctl_s_power(struct v4l2_int_device *s, int on)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-
-	return sensor->platform_data->power_set(on);
-}
-
-/*
- * Given the image capture format in pix, the nominal frame period in
- * timeperframe, calculate the required xclk frequency.
- *
- * TCM825X input frequency characteristics are:
- *     Minimum 11.9 MHz, Typical 24.57 MHz and maximum 25/27 MHz
- */
-
-static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_fract *timeperframe = &sensor->timeperframe;
-	u32 tgt_xclk;	/* target xclk */
-	u32 tgt_fps;	/* target frames per secound */
-	int rval;
-
-	rval = sensor->platform_data->ifparm(p);
-	if (rval)
-		return rval;
-
-	tgt_fps = timeperframe->denominator / timeperframe->numerator;
-
-	tgt_xclk = (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) ?
-		(2457 * tgt_fps) / MAX_HALF_FPS :
-		(2457 * tgt_fps) / MAX_FPS;
-	tgt_xclk *= 10000;
-
-	tgt_xclk = min(tgt_xclk, (u32)TCM825X_XCLK_MAX);
-	tgt_xclk = max(tgt_xclk, (u32)TCM825X_XCLK_MIN);
-
-	p->u.bt656.clock_curr = tgt_xclk;
-
-	return 0;
-}
-
-static int ioctl_g_needs_reset(struct v4l2_int_device *s, void *buf)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-
-	return sensor->platform_data->needs_reset(s, buf, &sensor->pix);
-}
-
-static int ioctl_reset(struct v4l2_int_device *s)
-{
-	return -EBUSY;
-}
-
-static int ioctl_init(struct v4l2_int_device *s)
-{
-	return tcm825x_configure(s);
-}
-
-static int ioctl_dev_exit(struct v4l2_int_device *s)
-{
-	return 0;
-}
-
-static int ioctl_dev_init(struct v4l2_int_device *s)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	int r;
-
-	r = tcm825x_read_reg(sensor->i2c_client, 0x01);
-	if (r < 0)
-		return r;
-	if (r == 0) {
-		dev_err(&sensor->i2c_client->dev, "device not detected\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-static struct v4l2_int_ioctl_desc tcm825x_ioctl_desc[] = {
-	{ vidioc_int_dev_init_num,
-	  (v4l2_int_ioctl_func *)ioctl_dev_init },
-	{ vidioc_int_dev_exit_num,
-	  (v4l2_int_ioctl_func *)ioctl_dev_exit },
-	{ vidioc_int_s_power_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_power },
-	{ vidioc_int_g_ifparm_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_ifparm },
-	{ vidioc_int_g_needs_reset_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_needs_reset },
-	{ vidioc_int_reset_num,
-	  (v4l2_int_ioctl_func *)ioctl_reset },
-	{ vidioc_int_init_num,
-	  (v4l2_int_ioctl_func *)ioctl_init },
-	{ vidioc_int_enum_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
-	{ vidioc_int_try_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
-	{ vidioc_int_g_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
-	{ vidioc_int_s_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
-	{ vidioc_int_g_parm_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_parm },
-	{ vidioc_int_s_parm_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_parm },
-	{ vidioc_int_queryctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_queryctrl },
-	{ vidioc_int_g_ctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_ctrl },
-	{ vidioc_int_s_ctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_ctrl },
-};
-
-static struct v4l2_int_slave tcm825x_slave = {
-	.ioctls = tcm825x_ioctl_desc,
-	.num_ioctls = ARRAY_SIZE(tcm825x_ioctl_desc),
-};
-
-static struct tcm825x_sensor tcm825x;
-
-static struct v4l2_int_device tcm825x_int_device = {
-	.module = THIS_MODULE,
-	.name = TCM825X_NAME,
-	.priv = &tcm825x,
-	.type = v4l2_int_type_slave,
-	.u = {
-		.slave = &tcm825x_slave,
-	},
-};
-
-static int tcm825x_probe(struct i2c_client *client,
-			 const struct i2c_device_id *did)
-{
-	struct tcm825x_sensor *sensor = &tcm825x;
-
-	if (i2c_get_clientdata(client))
-		return -EBUSY;
-
-	sensor->platform_data = client->dev.platform_data;
-
-	if (sensor->platform_data == NULL
-	    || !sensor->platform_data->is_okay())
-		return -ENODEV;
-
-	sensor->v4l2_int_device = &tcm825x_int_device;
-
-	sensor->i2c_client = client;
-	i2c_set_clientdata(client, sensor);
-
-	/* Make the default capture format QVGA RGB565 */
-	sensor->pix.width = tcm825x_sizes[QVGA].width;
-	sensor->pix.height = tcm825x_sizes[QVGA].height;
-	sensor->pix.pixelformat = V4L2_PIX_FMT_RGB565;
-
-	return v4l2_int_device_register(sensor->v4l2_int_device);
-}
-
-static int tcm825x_remove(struct i2c_client *client)
-{
-	struct tcm825x_sensor *sensor = i2c_get_clientdata(client);
-
-	if (!client->adapter)
-		return -ENODEV;	/* our client isn't attached */
-
-	v4l2_int_device_unregister(sensor->v4l2_int_device);
-
-	return 0;
-}
-
-static const struct i2c_device_id tcm825x_id[] = {
-	{ "tcm825x", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, tcm825x_id);
-
-static struct i2c_driver tcm825x_i2c_driver = {
-	.driver	= {
-		.name = TCM825X_NAME,
-	},
-	.probe	= tcm825x_probe,
-	.remove	= tcm825x_remove,
-	.id_table = tcm825x_id,
-};
-
-static struct tcm825x_sensor tcm825x = {
-	.timeperframe = {
-		.numerator   = 1,
-		.denominator = DEFAULT_FPS,
-	},
-};
-
-static int __init tcm825x_init(void)
-{
-	int rval;
-
-	rval = i2c_add_driver(&tcm825x_i2c_driver);
-	if (rval)
-		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
-		       __func__);
-
-	return rval;
-}
-
-static void __exit tcm825x_exit(void)
-{
-	i2c_del_driver(&tcm825x_i2c_driver);
-}
-
-/*
- * FIXME: Menelaus isn't ready (?) at module_init stage, so use
- * late_initcall for now.
- */
-late_initcall(tcm825x_init);
-module_exit(tcm825x_exit);
-
-MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
-MODULE_DESCRIPTION("TCM825x camera sensor driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/i2c/tcm825x.h b/drivers/media/i2c/tcm825x.h
deleted file mode 100644
index 8ebab95..0000000
--- a/drivers/media/i2c/tcm825x.h
+++ /dev/null
@@ -1,200 +0,0 @@
-/*
- * drivers/media/i2c/tcm825x.h
- *
- * Register definitions for the TCM825X CameraChip.
- *
- * Author: David Cohen (david.cohen@indt.org.br)
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- *
- * This file was based on ov9640.h from MontaVista
- */
-
-#ifndef TCM825X_H
-#define TCM825X_H
-
-#include <linux/videodev2.h>
-
-#include <media/v4l2-int-device.h>
-
-#define TCM825X_NAME "tcm825x"
-
-#define TCM825X_MASK(x)  x & 0x00ff
-#define TCM825X_ADDR(x) (x & 0xff00) >> 8
-
-/* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
-#define TCM825X_I2C_ADDR	0x3d
-
-/*
- * define register offsets for the TCM825X sensor chip
- * OFFSET(8 bits) + MASK(8 bits)
- * MASK bit 4 and 3 are used when the register uses more than one address
- */
-#define TCM825X_FPS		0x0280
-#define TCM825X_ACF		0x0240
-#define TCM825X_DOUTBUF		0x020C
-#define TCM825X_DCLKP		0x0202
-#define TCM825X_ACFDET		0x0201
-#define TCM825X_DOUTSW		0x0380
-#define TCM825X_DATAHZ		0x0340
-#define TCM825X_PICSIZ		0x033c
-#define TCM825X_PICFMT		0x0302
-#define TCM825X_V_INV		0x0480
-#define TCM825X_H_INV		0x0440
-#define TCM825X_ESRLSW		0x0430
-#define TCM825X_V_LENGTH	0x040F
-#define TCM825X_ALCSW		0x0580
-#define TCM825X_ESRLIM		0x0560
-#define TCM825X_ESRSPD_U        0x051F
-#define TCM825X_ESRSPD_L        0x06FF
-#define TCM825X_AG		0x07FF
-#define TCM825X_ESRSPD2         0x06FF
-#define TCM825X_ALCMODE         0x0830
-#define TCM825X_ALCH            0x080F
-#define TCM825X_ALCL            0x09FF
-#define TCM825X_AWBSW           0x0A80
-#define TCM825X_MRG             0x0BFF
-#define TCM825X_MBG             0x0CFF
-#define TCM825X_GAMSW           0x0D80
-#define TCM825X_HDTG            0x0EFF
-#define TCM825X_VDTG            0x0FFF
-#define TCM825X_HDTCORE         0x10F0
-#define TCM825X_VDTCORE         0x100F
-#define TCM825X_CONT            0x11FF
-#define TCM825X_BRIGHT          0x12FF
-#define TCM825X_VHUE            0x137F
-#define TCM825X_UHUE            0x147F
-#define TCM825X_VGAIN           0x153F
-#define TCM825X_UGAIN           0x163F
-#define TCM825X_UVCORE          0x170F
-#define TCM825X_SATU            0x187F
-#define TCM825X_MHMODE          0x1980
-#define TCM825X_MHLPFSEL        0x1940
-#define TCM825X_YMODE           0x1930
-#define TCM825X_MIXHG           0x1907
-#define TCM825X_LENS            0x1A3F
-#define TCM825X_AGLIM           0x1BE0
-#define TCM825X_LENSRPOL        0x1B10
-#define TCM825X_LENSRGAIN       0x1B0F
-#define TCM825X_ES100S          0x1CFF
-#define TCM825X_ES120S          0x1DFF
-#define TCM825X_DMASK           0x1EC0
-#define TCM825X_CODESW          0x1E20
-#define TCM825X_CODESEL         0x1E10
-#define TCM825X_TESPIC          0x1E04
-#define TCM825X_PICSEL          0x1E03
-#define TCM825X_HNUM            0x20FF
-#define TCM825X_VOUTPH          0x287F
-#define TCM825X_ESROUT          0x327F
-#define TCM825X_ESROUT2         0x33FF
-#define TCM825X_AGOUT           0x34FF
-#define TCM825X_DGOUT           0x353F
-#define TCM825X_AGSLOW1         0x39C0
-#define TCM825X_FLLSMODE        0x3930
-#define TCM825X_FLLSLIM         0x390F
-#define TCM825X_DETSEL          0x3AF0
-#define TCM825X_ACDETNC         0x3A0F
-#define TCM825X_AGSLOW2         0x3BC0
-#define TCM825X_DG              0x3B3F
-#define TCM825X_REJHLEV         0x3CFF
-#define TCM825X_ALCLOCK         0x3D80
-#define TCM825X_FPSLNKSW        0x3D40
-#define TCM825X_ALCSPD          0x3D30
-#define TCM825X_REJH            0x3D03
-#define TCM825X_SHESRSW         0x3E80
-#define TCM825X_ESLIMSEL        0x3E40
-#define TCM825X_SHESRSPD        0x3E30
-#define TCM825X_ELSTEP          0x3E0C
-#define TCM825X_ELSTART         0x3E03
-#define TCM825X_AGMIN           0x3FFF
-#define TCM825X_PREGRG          0x423F
-#define TCM825X_PREGBG          0x433F
-#define TCM825X_PRERG           0x443F
-#define TCM825X_PREBG           0x453F
-#define TCM825X_MSKBR           0x477F
-#define TCM825X_MSKGR           0x487F
-#define TCM825X_MSKRB           0x497F
-#define TCM825X_MSKGB           0x4A7F
-#define TCM825X_MSKRG           0x4B7F
-#define TCM825X_MSKBG           0x4C7F
-#define TCM825X_HDTCSW          0x4D80
-#define TCM825X_VDTCSW          0x4D40
-#define TCM825X_DTCYL           0x4D3F
-#define TCM825X_HDTPSW          0x4E80
-#define TCM825X_VDTPSW          0x4E40
-#define TCM825X_DTCGAIN         0x4E3F
-#define TCM825X_DTLLIMSW        0x4F10
-#define TCM825X_DTLYLIM         0x4F0F
-#define TCM825X_YLCUTLMSK       0x5080
-#define TCM825X_YLCUTL          0x503F
-#define TCM825X_YLCUTHMSK       0x5180
-#define TCM825X_YLCUTH          0x513F
-#define TCM825X_UVSKNC          0x527F
-#define TCM825X_UVLJ            0x537F
-#define TCM825X_WBGMIN          0x54FF
-#define TCM825X_WBGMAX          0x55FF
-#define TCM825X_WBSPDUP         0x5603
-#define TCM825X_ALLAREA         0x5820
-#define TCM825X_WBLOCK          0x5810
-#define TCM825X_WB2SP           0x580F
-#define TCM825X_KIZUSW          0x5920
-#define TCM825X_PBRSW           0x5910
-#define TCM825X_ABCSW           0x5903
-#define TCM825X_PBDLV           0x5AFF
-#define TCM825X_PBC1LV          0x5BFF
-
-#define TCM825X_NUM_REGS	(TCM825X_ADDR(TCM825X_PBC1LV) + 1)
-
-#define TCM825X_BYTES_PER_PIXEL 2
-
-#define TCM825X_REG_TERM 0xff		/* terminating list entry for reg */
-#define TCM825X_VAL_TERM 0xff		/* terminating list entry for val */
-
-/* define a structure for tcm825x register initialization values */
-struct tcm825x_reg {
-	u8 val;
-	u16 reg;
-};
-
-enum image_size { subQCIF = 0, QQVGA, QCIF, QVGA, CIF, VGA };
-enum pixel_format { YUV422 = 0, RGB565 };
-#define NUM_IMAGE_SIZES 6
-#define NUM_PIXEL_FORMATS 2
-
-#define TCM825X_XCLK_MIN	11900000
-#define TCM825X_XCLK_MAX	25000000
-
-struct capture_size {
-	unsigned long width;
-	unsigned long height;
-};
-
-struct tcm825x_platform_data {
-	/* Is the sensor usable? Doesn't yet mean it's there, but you
-	 * can try! */
-	int (*is_okay)(void);
-	/* Set power state, zero is off, non-zero is on. */
-	int (*power_set)(int power);
-	/* Default registers written after power-on or reset. */
-	const struct tcm825x_reg *(*default_regs)(void);
-	int (*needs_reset)(struct v4l2_int_device *s, void *buf,
-			   struct v4l2_pix_format *fmt);
-	int (*ifparm)(struct v4l2_ifparm *p);
-	int (*is_upside_down)(void);
-};
-
-/* Array of image sizes supported by TCM825X.  These must be ordered from
- * smallest image size to largest.
- */
-static const struct capture_size tcm825x_sizes[] = {
-	{ 128,  96 }, /* subQCIF */
-	{ 160, 120 }, /* QQVGA */
-	{ 176, 144 }, /* QCIF */
-	{ 320, 240 }, /* QVGA */
-	{ 352, 288 }, /* CIF */
-	{ 640, 480 }, /* VGA */
-};
-
-#endif /* ifndef TCM825X_H */
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 7f6ea65..b2a4403 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,13 +91,6 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
-config VIDEO_OMAP2
-	tristate "OMAP2 Camera Capture Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP2 && VIDEO_V4L2_INT_DEVICE
-	select VIDEOBUF_DMA_SG
-	---help---
-	  This is a v4l2 driver for the TI OMAP2 camera capture interface
-
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 1348ba1..e5269da 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
-
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 
@@ -14,7 +12,6 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
-obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
diff --git a/drivers/media/platform/omap24xxcam-dma.c b/drivers/media/platform/omap24xxcam-dma.c
deleted file mode 100644
index 9c00776..0000000
--- a/drivers/media/platform/omap24xxcam-dma.c
+++ /dev/null
@@ -1,601 +0,0 @@
-/*
- * drivers/media/platform/omap24xxcam-dma.c
- *
- * Copyright (C) 2004 MontaVista Software, Inc.
- * Copyright (C) 2004 Texas Instruments.
- * Copyright (C) 2007 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * Based on code from Andy Lowe <source@mvista.com> and
- *                    David Cohen <david.cohen@indt.org.br>.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/scatterlist.h>
-
-#include "omap24xxcam.h"
-
-/*
- *
- * DMA hardware.
- *
- */
-
-/* Ack all interrupt on CSR and IRQSTATUS_L0 */
-static void omap24xxcam_dmahw_ack_all(void __iomem *base)
-{
-	u32 csr;
-	int i;
-
-	for (i = 0; i < NUM_CAMDMA_CHANNELS; ++i) {
-		csr = omap24xxcam_reg_in(base, CAMDMA_CSR(i));
-		/* ack interrupt in CSR */
-		omap24xxcam_reg_out(base, CAMDMA_CSR(i), csr);
-	}
-	omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, 0xf);
-}
-
-/* Ack dmach on CSR and IRQSTATUS_L0 */
-static u32 omap24xxcam_dmahw_ack_ch(void __iomem *base, int dmach)
-{
-	u32 csr;
-
-	csr = omap24xxcam_reg_in(base, CAMDMA_CSR(dmach));
-	/* ack interrupt in CSR */
-	omap24xxcam_reg_out(base, CAMDMA_CSR(dmach), csr);
-	/* ack interrupt in IRQSTATUS */
-	omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, (1 << dmach));
-
-	return csr;
-}
-
-static int omap24xxcam_dmahw_running(void __iomem *base, int dmach)
-{
-	return omap24xxcam_reg_in(base, CAMDMA_CCR(dmach)) & CAMDMA_CCR_ENABLE;
-}
-
-static void omap24xxcam_dmahw_transfer_setup(void __iomem *base, int dmach,
-					     dma_addr_t start, u32 len)
-{
-	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
-			    CAMDMA_CCR_SEL_SRC_DST_SYNC
-			    | CAMDMA_CCR_BS
-			    | CAMDMA_CCR_DST_AMODE_POST_INC
-			    | CAMDMA_CCR_SRC_AMODE_POST_INC
-			    | CAMDMA_CCR_FS
-			    | CAMDMA_CCR_WR_ACTIVE
-			    | CAMDMA_CCR_RD_ACTIVE
-			    | CAMDMA_CCR_SYNCHRO_CAMERA);
-	omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(dmach), 0);
-	omap24xxcam_reg_out(base, CAMDMA_CEN(dmach), len);
-	omap24xxcam_reg_out(base, CAMDMA_CFN(dmach), 1);
-	omap24xxcam_reg_out(base, CAMDMA_CSDP(dmach),
-			    CAMDMA_CSDP_WRITE_MODE_POSTED
-			    | CAMDMA_CSDP_DST_BURST_EN_32
-			    | CAMDMA_CSDP_DST_PACKED
-			    | CAMDMA_CSDP_SRC_BURST_EN_32
-			    | CAMDMA_CSDP_SRC_PACKED
-			    | CAMDMA_CSDP_DATA_TYPE_8BITS);
-	omap24xxcam_reg_out(base, CAMDMA_CSSA(dmach), 0);
-	omap24xxcam_reg_out(base, CAMDMA_CDSA(dmach), start);
-	omap24xxcam_reg_out(base, CAMDMA_CSEI(dmach), 0);
-	omap24xxcam_reg_out(base, CAMDMA_CSFI(dmach), DMA_THRESHOLD);
-	omap24xxcam_reg_out(base, CAMDMA_CDEI(dmach), 0);
-	omap24xxcam_reg_out(base, CAMDMA_CDFI(dmach), 0);
-	omap24xxcam_reg_out(base, CAMDMA_CSR(dmach),
-			    CAMDMA_CSR_MISALIGNED_ERR
-			    | CAMDMA_CSR_SECURE_ERR
-			    | CAMDMA_CSR_TRANS_ERR
-			    | CAMDMA_CSR_BLOCK
-			    | CAMDMA_CSR_DROP);
-	omap24xxcam_reg_out(base, CAMDMA_CICR(dmach),
-			    CAMDMA_CICR_MISALIGNED_ERR_IE
-			    | CAMDMA_CICR_SECURE_ERR_IE
-			    | CAMDMA_CICR_TRANS_ERR_IE
-			    | CAMDMA_CICR_BLOCK_IE
-			    | CAMDMA_CICR_DROP_IE);
-}
-
-static void omap24xxcam_dmahw_transfer_start(void __iomem *base, int dmach)
-{
-	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
-			    CAMDMA_CCR_SEL_SRC_DST_SYNC
-			    | CAMDMA_CCR_BS
-			    | CAMDMA_CCR_DST_AMODE_POST_INC
-			    | CAMDMA_CCR_SRC_AMODE_POST_INC
-			    | CAMDMA_CCR_ENABLE
-			    | CAMDMA_CCR_FS
-			    | CAMDMA_CCR_SYNCHRO_CAMERA);
-}
-
-static void omap24xxcam_dmahw_transfer_chain(void __iomem *base, int dmach,
-					     int free_dmach)
-{
-	int prev_dmach, ch;
-
-	if (dmach == 0)
-		prev_dmach = NUM_CAMDMA_CHANNELS - 1;
-	else
-		prev_dmach = dmach - 1;
-	omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(prev_dmach),
-			    CAMDMA_CLNK_CTRL_ENABLE_LNK | dmach);
-	/* Did we chain the DMA transfer before the previous one
-	 * finished?
-	 */
-	ch = (dmach + free_dmach) % NUM_CAMDMA_CHANNELS;
-	while (!(omap24xxcam_reg_in(base, CAMDMA_CCR(ch))
-		 & CAMDMA_CCR_ENABLE)) {
-		if (ch == dmach) {
-			/* The previous transfer has ended and this one
-			 * hasn't started, so we must not have chained
-			 * to the previous one in time.  We'll have to
-			 * start it now.
-			 */
-			omap24xxcam_dmahw_transfer_start(base, dmach);
-			break;
-		} else
-			ch = (ch + 1) % NUM_CAMDMA_CHANNELS;
-	}
-}
-
-/* Abort all chained DMA transfers. After all transfers have been
- * aborted and the DMA controller is idle, the completion routines for
- * any aborted transfers will be called in sequence. The DMA
- * controller may not be idle after this routine completes, because
- * the completion routines might start new transfers.
- */
-static void omap24xxcam_dmahw_abort_ch(void __iomem *base, int dmach)
-{
-	/* mask all interrupts from this channel */
-	omap24xxcam_reg_out(base, CAMDMA_CICR(dmach), 0);
-	/* unlink this channel */
-	omap24xxcam_reg_merge(base, CAMDMA_CLNK_CTRL(dmach), 0,
-			      CAMDMA_CLNK_CTRL_ENABLE_LNK);
-	/* disable this channel */
-	omap24xxcam_reg_merge(base, CAMDMA_CCR(dmach), 0, CAMDMA_CCR_ENABLE);
-}
-
-static void omap24xxcam_dmahw_init(void __iomem *base)
-{
-	omap24xxcam_reg_out(base, CAMDMA_OCP_SYSCONFIG,
-			    CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY
-			    | CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE
-			    | CAMDMA_OCP_SYSCONFIG_AUTOIDLE);
-
-	omap24xxcam_reg_merge(base, CAMDMA_GCR, 0x10,
-			      CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH);
-
-	omap24xxcam_reg_out(base, CAMDMA_IRQENABLE_L0, 0xf);
-}
-
-/*
- *
- * Individual DMA channel handling.
- *
- */
-
-/* Start a DMA transfer from the camera to memory.
- * Returns zero if the transfer was successfully started, or non-zero if all
- * DMA channels are already in use or starting is currently inhibited.
- */
-static int omap24xxcam_dma_start(struct omap24xxcam_dma *dma, dma_addr_t start,
-				 u32 len, dma_callback_t callback, void *arg)
-{
-	unsigned long flags;
-	int dmach;
-
-	spin_lock_irqsave(&dma->lock, flags);
-
-	if (!dma->free_dmach || atomic_read(&dma->dma_stop)) {
-		spin_unlock_irqrestore(&dma->lock, flags);
-		return -EBUSY;
-	}
-
-	dmach = dma->next_dmach;
-
-	dma->ch_state[dmach].callback = callback;
-	dma->ch_state[dmach].arg = arg;
-
-	omap24xxcam_dmahw_transfer_setup(dma->base, dmach, start, len);
-
-	/* We're ready to start the DMA transfer. */
-
-	if (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
-		/* A transfer is already in progress, so try to chain to it. */
-		omap24xxcam_dmahw_transfer_chain(dma->base, dmach,
-						 dma->free_dmach);
-	} else {
-		/* No transfer is in progress, so we'll just start this one
-		 * now.
-		 */
-		omap24xxcam_dmahw_transfer_start(dma->base, dmach);
-	}
-
-	dma->next_dmach = (dma->next_dmach + 1) % NUM_CAMDMA_CHANNELS;
-	dma->free_dmach--;
-
-	spin_unlock_irqrestore(&dma->lock, flags);
-
-	return 0;
-}
-
-/* Abort all chained DMA transfers. After all transfers have been
- * aborted and the DMA controller is idle, the completion routines for
- * any aborted transfers will be called in sequence. The DMA
- * controller may not be idle after this routine completes, because
- * the completion routines might start new transfers.
- */
-static void omap24xxcam_dma_abort(struct omap24xxcam_dma *dma, u32 csr)
-{
-	unsigned long flags;
-	int dmach, i, free_dmach;
-	dma_callback_t callback;
-	void *arg;
-
-	spin_lock_irqsave(&dma->lock, flags);
-
-	/* stop any DMA transfers in progress */
-	dmach = (dma->next_dmach + dma->free_dmach) % NUM_CAMDMA_CHANNELS;
-	for (i = 0; i < NUM_CAMDMA_CHANNELS; i++) {
-		omap24xxcam_dmahw_abort_ch(dma->base, dmach);
-		dmach = (dmach + 1) % NUM_CAMDMA_CHANNELS;
-	}
-
-	/* We have to be careful here because the callback routine
-	 * might start a new DMA transfer, and we only want to abort
-	 * transfers that were started before this routine was called.
-	 */
-	free_dmach = dma->free_dmach;
-	while ((dma->free_dmach < NUM_CAMDMA_CHANNELS) &&
-	       (free_dmach < NUM_CAMDMA_CHANNELS)) {
-		dmach = (dma->next_dmach + dma->free_dmach)
-			% NUM_CAMDMA_CHANNELS;
-		callback = dma->ch_state[dmach].callback;
-		arg = dma->ch_state[dmach].arg;
-		dma->free_dmach++;
-		free_dmach++;
-		if (callback) {
-			/* leave interrupts disabled during callback */
-			spin_unlock(&dma->lock);
-			(*callback) (dma, csr, arg);
-			spin_lock(&dma->lock);
-		}
-	}
-
-	spin_unlock_irqrestore(&dma->lock, flags);
-}
-
-/* Abort all chained DMA transfers. After all transfers have been
- * aborted and the DMA controller is idle, the completion routines for
- * any aborted transfers will be called in sequence. If the completion
- * routines attempt to start a new DMA transfer it will fail, so the
- * DMA controller will be idle after this routine completes.
- */
-static void omap24xxcam_dma_stop(struct omap24xxcam_dma *dma, u32 csr)
-{
-	atomic_inc(&dma->dma_stop);
-	omap24xxcam_dma_abort(dma, csr);
-	atomic_dec(&dma->dma_stop);
-}
-
-/* Camera DMA interrupt service routine. */
-void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma)
-{
-	int dmach;
-	dma_callback_t callback;
-	void *arg;
-	u32 csr;
-	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
-		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
-		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
-
-	spin_lock(&dma->lock);
-
-	if (dma->free_dmach == NUM_CAMDMA_CHANNELS) {
-		/* A camera DMA interrupt occurred while all channels
-		 * are idle, so we'll acknowledge the interrupt in the
-		 * IRQSTATUS register and exit.
-		 */
-		omap24xxcam_dmahw_ack_all(dma->base);
-		spin_unlock(&dma->lock);
-		return;
-	}
-
-	while (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
-		dmach = (dma->next_dmach + dma->free_dmach)
-			% NUM_CAMDMA_CHANNELS;
-		if (omap24xxcam_dmahw_running(dma->base, dmach)) {
-			/* This buffer hasn't finished yet, so we're done. */
-			break;
-		}
-		csr = omap24xxcam_dmahw_ack_ch(dma->base, dmach);
-		if (csr & csr_error) {
-			/* A DMA error occurred, so stop all DMA
-			 * transfers in progress.
-			 */
-			spin_unlock(&dma->lock);
-			omap24xxcam_dma_stop(dma, csr);
-			return;
-		} else {
-			callback = dma->ch_state[dmach].callback;
-			arg = dma->ch_state[dmach].arg;
-			dma->free_dmach++;
-			if (callback) {
-				spin_unlock(&dma->lock);
-				(*callback) (dma, csr, arg);
-				spin_lock(&dma->lock);
-			}
-		}
-	}
-
-	spin_unlock(&dma->lock);
-
-	omap24xxcam_sgdma_process(
-		container_of(dma, struct omap24xxcam_sgdma, dma));
-}
-
-void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dma->lock, flags);
-
-	omap24xxcam_dmahw_init(dma->base);
-
-	spin_unlock_irqrestore(&dma->lock, flags);
-}
-
-static void omap24xxcam_dma_init(struct omap24xxcam_dma *dma,
-				 void __iomem *base)
-{
-	int ch;
-
-	/* group all channels on DMA IRQ0 and unmask irq */
-	spin_lock_init(&dma->lock);
-	dma->base = base;
-	dma->free_dmach = NUM_CAMDMA_CHANNELS;
-	dma->next_dmach = 0;
-	for (ch = 0; ch < NUM_CAMDMA_CHANNELS; ch++) {
-		dma->ch_state[ch].callback = NULL;
-		dma->ch_state[ch].arg = NULL;
-	}
-}
-
-/*
- *
- * Scatter-gather DMA.
- *
- * High-level DMA construct for transferring whole picture frames to
- * memory that is discontinuous.
- *
- */
-
-/* DMA completion routine for the scatter-gather DMA fragments. */
-static void omap24xxcam_sgdma_callback(struct omap24xxcam_dma *dma, u32 csr,
-				       void *arg)
-{
-	struct omap24xxcam_sgdma *sgdma =
-		container_of(dma, struct omap24xxcam_sgdma, dma);
-	int sgslot = (int)arg;
-	struct sgdma_state *sg_state;
-	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
-		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
-		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
-
-	spin_lock(&sgdma->lock);
-
-	/* We got an interrupt, we can remove the timer */
-	del_timer(&sgdma->reset_timer);
-
-	sg_state = sgdma->sg_state + sgslot;
-	if (!sg_state->queued_sglist) {
-		spin_unlock(&sgdma->lock);
-		printk(KERN_ERR "%s: sgdma completed when none queued!\n",
-		       __func__);
-		return;
-	}
-
-	sg_state->csr |= csr;
-	if (!--sg_state->queued_sglist) {
-		/* Queue for this sglist is empty, so check to see if we're
-		 * done.
-		 */
-		if ((sg_state->next_sglist == sg_state->sglen)
-		    || (sg_state->csr & csr_error)) {
-			sgdma_callback_t callback = sg_state->callback;
-			void *arg = sg_state->arg;
-			u32 sg_csr = sg_state->csr;
-			/* All done with this sglist */
-			sgdma->free_sgdma++;
-			if (callback) {
-				spin_unlock(&sgdma->lock);
-				(*callback) (sgdma, sg_csr, arg);
-				return;
-			}
-		}
-	}
-
-	spin_unlock(&sgdma->lock);
-}
-
-/* Start queued scatter-gather DMA transfers. */
-void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma)
-{
-	unsigned long flags;
-	int queued_sgdma, sgslot;
-	struct sgdma_state *sg_state;
-	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
-		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
-		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
-
-	spin_lock_irqsave(&sgdma->lock, flags);
-
-	queued_sgdma = NUM_SG_DMA - sgdma->free_sgdma;
-	sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
-	while (queued_sgdma > 0) {
-		sg_state = sgdma->sg_state + sgslot;
-		while ((sg_state->next_sglist < sg_state->sglen) &&
-		       !(sg_state->csr & csr_error)) {
-			const struct scatterlist *sglist;
-			unsigned int len;
-
-			sglist = sg_state->sglist + sg_state->next_sglist;
-			/* try to start the next DMA transfer */
-			if (sg_state->next_sglist + 1 == sg_state->sglen) {
-				/*
-				 *  On the last sg, we handle the case where
-				 *  cam->img.pix.sizeimage % PAGE_ALIGN != 0
-				 */
-				len = sg_state->len - sg_state->bytes_read;
-			} else {
-				len = sg_dma_len(sglist);
-			}
-
-			if (omap24xxcam_dma_start(&sgdma->dma,
-						  sg_dma_address(sglist),
-						  len,
-						  omap24xxcam_sgdma_callback,
-						  (void *)sgslot)) {
-				/* DMA start failed */
-				spin_unlock_irqrestore(&sgdma->lock, flags);
-				return;
-			} else {
-				unsigned long expires;
-				/* DMA start was successful */
-				sg_state->next_sglist++;
-				sg_state->bytes_read += len;
-				sg_state->queued_sglist++;
-
-				/* We start the reset timer */
-				expires = jiffies + HZ;
-				mod_timer(&sgdma->reset_timer, expires);
-			}
-		}
-		queued_sgdma--;
-		sgslot = (sgslot + 1) % NUM_SG_DMA;
-	}
-
-	spin_unlock_irqrestore(&sgdma->lock, flags);
-}
-
-/*
- * Queue a scatter-gather DMA transfer from the camera to memory.
- * Returns zero if the transfer was successfully queued, or non-zero
- * if all of the scatter-gather slots are already in use.
- */
-int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
-			    const struct scatterlist *sglist, int sglen,
-			    int len, sgdma_callback_t callback, void *arg)
-{
-	unsigned long flags;
-	struct sgdma_state *sg_state;
-
-	if ((sglen < 0) || ((sglen > 0) && !sglist))
-		return -EINVAL;
-
-	spin_lock_irqsave(&sgdma->lock, flags);
-
-	if (!sgdma->free_sgdma) {
-		spin_unlock_irqrestore(&sgdma->lock, flags);
-		return -EBUSY;
-	}
-
-	sg_state = sgdma->sg_state + sgdma->next_sgdma;
-
-	sg_state->sglist = sglist;
-	sg_state->sglen = sglen;
-	sg_state->next_sglist = 0;
-	sg_state->bytes_read = 0;
-	sg_state->len = len;
-	sg_state->queued_sglist = 0;
-	sg_state->csr = 0;
-	sg_state->callback = callback;
-	sg_state->arg = arg;
-
-	sgdma->next_sgdma = (sgdma->next_sgdma + 1) % NUM_SG_DMA;
-	sgdma->free_sgdma--;
-
-	spin_unlock_irqrestore(&sgdma->lock, flags);
-
-	omap24xxcam_sgdma_process(sgdma);
-
-	return 0;
-}
-
-/* Sync scatter-gather DMA by aborting any DMA transfers currently in progress.
- * Any queued scatter-gather DMA transactions that have not yet been started
- * will remain queued.  The DMA controller will be idle after this routine
- * completes.  When the scatter-gather queue is restarted, the next
- * scatter-gather DMA transfer will begin at the start of a new transaction.
- */
-void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma)
-{
-	unsigned long flags;
-	int sgslot;
-	struct sgdma_state *sg_state;
-	u32 csr = CAMDMA_CSR_TRANS_ERR;
-
-	/* stop any DMA transfers in progress */
-	omap24xxcam_dma_stop(&sgdma->dma, csr);
-
-	spin_lock_irqsave(&sgdma->lock, flags);
-
-	if (sgdma->free_sgdma < NUM_SG_DMA) {
-		sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
-		sg_state = sgdma->sg_state + sgslot;
-		if (sg_state->next_sglist != 0) {
-			/* This DMA transfer was in progress, so abort it. */
-			sgdma_callback_t callback = sg_state->callback;
-			void *arg = sg_state->arg;
-			sgdma->free_sgdma++;
-			if (callback) {
-				/* leave interrupts masked */
-				spin_unlock(&sgdma->lock);
-				(*callback) (sgdma, csr, arg);
-				spin_lock(&sgdma->lock);
-			}
-		}
-	}
-
-	spin_unlock_irqrestore(&sgdma->lock, flags);
-}
-
-void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
-			    void __iomem *base,
-			    void (*reset_callback)(unsigned long data),
-			    unsigned long reset_callback_data)
-{
-	int sg;
-
-	spin_lock_init(&sgdma->lock);
-	sgdma->free_sgdma = NUM_SG_DMA;
-	sgdma->next_sgdma = 0;
-	for (sg = 0; sg < NUM_SG_DMA; sg++) {
-		sgdma->sg_state[sg].sglen = 0;
-		sgdma->sg_state[sg].next_sglist = 0;
-		sgdma->sg_state[sg].bytes_read = 0;
-		sgdma->sg_state[sg].queued_sglist = 0;
-		sgdma->sg_state[sg].csr = 0;
-		sgdma->sg_state[sg].callback = NULL;
-		sgdma->sg_state[sg].arg = NULL;
-	}
-
-	omap24xxcam_dma_init(&sgdma->dma, base);
-	setup_timer(&sgdma->reset_timer, reset_callback, reset_callback_data);
-}
diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
deleted file mode 100644
index d2b440c..0000000
--- a/drivers/media/platform/omap24xxcam.c
+++ /dev/null
@@ -1,1888 +0,0 @@
-/*
- * drivers/media/platform/omap24xxcam.c
- *
- * OMAP 2 camera block driver.
- *
- * Copyright (C) 2004 MontaVista Software, Inc.
- * Copyright (C) 2004 Texas Instruments.
- * Copyright (C) 2007-2008 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * Based on code from Andy Lowe <source@mvista.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/videodev2.h>
-#include <linux/pci.h>		/* needed for videobufs */
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-#include <linux/sched.h>
-#include <linux/module.h>
-
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-
-#include "omap24xxcam.h"
-
-#define OMAP24XXCAM_VERSION "0.0.1"
-
-#define RESET_TIMEOUT_NS 10000
-
-static void omap24xxcam_reset(struct omap24xxcam_device *cam);
-static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam);
-static void omap24xxcam_device_unregister(struct v4l2_int_device *s);
-static int omap24xxcam_remove(struct platform_device *pdev);
-
-/* module parameters */
-static int video_nr = -1;	/* video device minor (-1 ==> auto assign) */
-/*
- * Maximum amount of memory to use for capture buffers.
- * Default is 4800KB, enough to double-buffer SXGA.
- */
-static int capture_mem = 1280 * 960 * 2 * 2;
-
-static struct v4l2_int_device omap24xxcam;
-
-/*
- *
- * Clocks.
- *
- */
-
-static void omap24xxcam_clock_put(struct omap24xxcam_device *cam)
-{
-	if (cam->ick != NULL && !IS_ERR(cam->ick))
-		clk_put(cam->ick);
-	if (cam->fck != NULL && !IS_ERR(cam->fck))
-		clk_put(cam->fck);
-
-	cam->ick = cam->fck = NULL;
-}
-
-static int omap24xxcam_clock_get(struct omap24xxcam_device *cam)
-{
-	int rval = 0;
-
-	cam->fck = clk_get(cam->dev, "fck");
-	if (IS_ERR(cam->fck)) {
-		dev_err(cam->dev, "can't get camera fck");
-		rval = PTR_ERR(cam->fck);
-		omap24xxcam_clock_put(cam);
-		return rval;
-	}
-
-	cam->ick = clk_get(cam->dev, "ick");
-	if (IS_ERR(cam->ick)) {
-		dev_err(cam->dev, "can't get camera ick");
-		rval = PTR_ERR(cam->ick);
-		omap24xxcam_clock_put(cam);
-	}
-
-	return rval;
-}
-
-static void omap24xxcam_clock_on(struct omap24xxcam_device *cam)
-{
-	clk_enable(cam->fck);
-	clk_enable(cam->ick);
-}
-
-static void omap24xxcam_clock_off(struct omap24xxcam_device *cam)
-{
-	clk_disable(cam->fck);
-	clk_disable(cam->ick);
-}
-
-/*
- *
- * Camera core
- *
- */
-
-/*
- * Set xclk.
- *
- * To disable xclk, use value zero.
- */
-static void omap24xxcam_core_xclk_set(const struct omap24xxcam_device *cam,
-				      u32 xclk)
-{
-	if (xclk) {
-		u32 divisor = CAM_MCLK / xclk;
-
-		if (divisor == 1)
-			omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
-					    CC_CTRL_XCLK,
-					    CC_CTRL_XCLK_DIV_BYPASS);
-		else
-			omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
-					    CC_CTRL_XCLK, divisor);
-	} else
-		omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
-				    CC_CTRL_XCLK, CC_CTRL_XCLK_DIV_STABLE_LOW);
-}
-
-static void omap24xxcam_core_hwinit(const struct omap24xxcam_device *cam)
-{
-	/*
-	 * Setting the camera core AUTOIDLE bit causes problems with frame
-	 * synchronization, so we will clear the AUTOIDLE bit instead.
-	 */
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_SYSCONFIG,
-			    CC_SYSCONFIG_AUTOIDLE);
-
-	/* program the camera interface DMA packet size */
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL_DMA,
-			    CC_CTRL_DMA_EN | (DMA_THRESHOLD / 4 - 1));
-
-	/* enable camera core error interrupts */
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQENABLE,
-			    CC_IRQENABLE_FW_ERR_IRQ
-			    | CC_IRQENABLE_FSC_ERR_IRQ
-			    | CC_IRQENABLE_SSC_ERR_IRQ
-			    | CC_IRQENABLE_FIFO_OF_IRQ);
-}
-
-/*
- * Enable the camera core.
- *
- * Data transfer to the camera DMA starts from next starting frame.
- */
-static void omap24xxcam_core_enable(const struct omap24xxcam_device *cam)
-{
-
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
-			    cam->cc_ctrl);
-}
-
-/*
- * Disable camera core.
- *
- * The data transfer will be stopped immediately (CC_CTRL_CC_RST). The
- * core internal state machines will be reset. Use
- * CC_CTRL_CC_FRAME_TRIG instead if you want to transfer the current
- * frame completely.
- */
-static void omap24xxcam_core_disable(const struct omap24xxcam_device *cam)
-{
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
-			    CC_CTRL_CC_RST);
-}
-
-/* Interrupt service routine for camera core interrupts. */
-static void omap24xxcam_core_isr(struct omap24xxcam_device *cam)
-{
-	u32 cc_irqstatus;
-	const u32 cc_irqstatus_err =
-		CC_IRQSTATUS_FW_ERR_IRQ
-		| CC_IRQSTATUS_FSC_ERR_IRQ
-		| CC_IRQSTATUS_SSC_ERR_IRQ
-		| CC_IRQSTATUS_FIFO_UF_IRQ
-		| CC_IRQSTATUS_FIFO_OF_IRQ;
-
-	cc_irqstatus = omap24xxcam_reg_in(cam->mmio_base + CC_REG_OFFSET,
-					  CC_IRQSTATUS);
-	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQSTATUS,
-			    cc_irqstatus);
-
-	if (cc_irqstatus & cc_irqstatus_err
-	    && !atomic_read(&cam->in_reset)) {
-		dev_dbg(cam->dev, "resetting camera, cc_irqstatus 0x%x\n",
-			cc_irqstatus);
-		omap24xxcam_reset(cam);
-	}
-}
-
-/*
- *
- * videobuf_buffer handling.
- *
- * Memory for mmapped videobuf_buffers is not allocated
- * conventionally, but by several kmalloc allocations and then
- * creating the scatterlist on our own. User-space buffers are handled
- * normally.
- *
- */
-
-/*
- * Free the memory-mapped buffer memory allocated for a
- * videobuf_buffer and the associated scatterlist.
- */
-static void omap24xxcam_vbq_free_mmap_buffer(struct videobuf_buffer *vb)
-{
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-	size_t alloc_size;
-	struct page *page;
-	int i;
-
-	if (dma->sglist == NULL)
-		return;
-
-	i = dma->sglen;
-	while (i) {
-		i--;
-		alloc_size = sg_dma_len(&dma->sglist[i]);
-		page = sg_page(&dma->sglist[i]);
-		do {
-			ClearPageReserved(page++);
-		} while (alloc_size -= PAGE_SIZE);
-		__free_pages(sg_page(&dma->sglist[i]),
-			     get_order(sg_dma_len(&dma->sglist[i])));
-	}
-
-	kfree(dma->sglist);
-	dma->sglist = NULL;
-}
-
-/* Release all memory related to the videobuf_queue. */
-static void omap24xxcam_vbq_free_mmap_buffers(struct videobuf_queue *vbq)
-{
-	int i;
-
-	mutex_lock(&vbq->vb_lock);
-
-	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (NULL == vbq->bufs[i])
-			continue;
-		if (V4L2_MEMORY_MMAP != vbq->bufs[i]->memory)
-			continue;
-		vbq->ops->buf_release(vbq, vbq->bufs[i]);
-		omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
-		kfree(vbq->bufs[i]);
-		vbq->bufs[i] = NULL;
-	}
-
-	mutex_unlock(&vbq->vb_lock);
-
-	videobuf_mmap_free(vbq);
-}
-
-/*
- * Allocate physically as contiguous as possible buffer for video
- * frame and allocate and build DMA scatter-gather list for it.
- */
-static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
-{
-	unsigned int order;
-	size_t alloc_size, size = vb->bsize; /* vb->bsize is page aligned */
-	struct page *page;
-	int max_pages, err = 0, i = 0;
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
-	/*
-	 * allocate maximum size scatter-gather list. Note this is
-	 * overhead. We may not use as many entries as we allocate
-	 */
-	max_pages = vb->bsize >> PAGE_SHIFT;
-	dma->sglist = kcalloc(max_pages, sizeof(*dma->sglist), GFP_KERNEL);
-	if (dma->sglist == NULL) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	while (size) {
-		order = get_order(size);
-		/*
-		 * do not over-allocate even if we would get larger
-		 * contiguous chunk that way
-		 */
-		if ((PAGE_SIZE << order) > size)
-			order--;
-
-		/* try to allocate as many contiguous pages as possible */
-		page = alloc_pages(GFP_KERNEL, order);
-		/* if allocation fails, try to allocate smaller amount */
-		while (page == NULL) {
-			order--;
-			page = alloc_pages(GFP_KERNEL, order);
-			if (page == NULL && !order) {
-				err = -ENOMEM;
-				goto out;
-			}
-		}
-		size -= (PAGE_SIZE << order);
-
-		/* append allocated chunk of pages into scatter-gather list */
-		sg_set_page(&dma->sglist[i], page, PAGE_SIZE << order, 0);
-		dma->sglen++;
-		i++;
-
-		alloc_size = (PAGE_SIZE << order);
-
-		/* clear pages before giving them to user space */
-		memset(page_address(page), 0, alloc_size);
-
-		/* mark allocated pages reserved */
-		do {
-			SetPageReserved(page++);
-		} while (alloc_size -= PAGE_SIZE);
-	}
-	/*
-	 * REVISIT: not fully correct to assign nr_pages == sglen but
-	 * video-buf is passing nr_pages for e.g. unmap_sg calls
-	 */
-	dma->nr_pages = dma->sglen;
-	dma->direction = PCI_DMA_FROMDEVICE;
-
-	return 0;
-
-out:
-	omap24xxcam_vbq_free_mmap_buffer(vb);
-	return err;
-}
-
-static int omap24xxcam_vbq_alloc_mmap_buffers(struct videobuf_queue *vbq,
-					      unsigned int count)
-{
-	int i, err = 0;
-	struct omap24xxcam_fh *fh =
-		container_of(vbq, struct omap24xxcam_fh, vbq);
-
-	mutex_lock(&vbq->vb_lock);
-
-	for (i = 0; i < count; i++) {
-		err = omap24xxcam_vbq_alloc_mmap_buffer(vbq->bufs[i]);
-		if (err)
-			goto out;
-		dev_dbg(fh->cam->dev, "sglen is %d for buffer %d\n",
-			videobuf_to_dma(vbq->bufs[i])->sglen, i);
-	}
-
-	mutex_unlock(&vbq->vb_lock);
-
-	return 0;
-out:
-	while (i) {
-		i--;
-		omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
-	}
-
-	mutex_unlock(&vbq->vb_lock);
-
-	return err;
-}
-
-/*
- * This routine is called from interrupt context when a scatter-gather DMA
- * transfer of a videobuf_buffer completes.
- */
-static void omap24xxcam_vbq_complete(struct omap24xxcam_sgdma *sgdma,
-				     u32 csr, void *arg)
-{
-	struct omap24xxcam_device *cam =
-		container_of(sgdma, struct omap24xxcam_device, sgdma);
-	struct omap24xxcam_fh *fh = cam->streaming->private_data;
-	struct videobuf_buffer *vb = (struct videobuf_buffer *)arg;
-	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
-		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
-		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
-	if (--cam->sgdma_in_queue == 0)
-		omap24xxcam_core_disable(cam);
-	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
-
-	v4l2_get_timestamp(&vb->ts);
-	vb->field_count = atomic_add_return(2, &fh->field_count);
-	if (csr & csr_error) {
-		vb->state = VIDEOBUF_ERROR;
-		if (!atomic_read(&fh->cam->in_reset)) {
-			dev_dbg(cam->dev, "resetting camera, csr 0x%x\n", csr);
-			omap24xxcam_reset(cam);
-		}
-	} else
-		vb->state = VIDEOBUF_DONE;
-	wake_up(&vb->done);
-}
-
-static void omap24xxcam_vbq_release(struct videobuf_queue *vbq,
-				    struct videobuf_buffer *vb)
-{
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
-	/* wait for buffer, especially to get out of the sgdma queue */
-	videobuf_waiton(vbq, vb, 0, 0);
-	if (vb->memory == V4L2_MEMORY_MMAP) {
-		dma_unmap_sg(vbq->dev, dma->sglist, dma->sglen,
-			     dma->direction);
-		dma->direction = DMA_NONE;
-	} else {
-		videobuf_dma_unmap(vbq->dev, videobuf_to_dma(vb));
-		videobuf_dma_free(videobuf_to_dma(vb));
-	}
-
-	vb->state = VIDEOBUF_NEEDS_INIT;
-}
-
-/*
- * Limit the number of available kernel image capture buffers based on the
- * number requested, the currently selected image size, and the maximum
- * amount of memory permitted for kernel capture buffers.
- */
-static int omap24xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
-				 unsigned int *size)
-{
-	struct omap24xxcam_fh *fh = vbq->priv_data;
-
-	if (*cnt <= 0)
-		*cnt = VIDEO_MAX_FRAME;	/* supply a default number of buffers */
-
-	if (*cnt > VIDEO_MAX_FRAME)
-		*cnt = VIDEO_MAX_FRAME;
-
-	*size = fh->pix.sizeimage;
-
-	/* accessing fh->cam->capture_mem is ok, it's constant */
-	if (*size * *cnt > fh->cam->capture_mem)
-		*cnt = fh->cam->capture_mem / *size;
-
-	return 0;
-}
-
-static int omap24xxcam_dma_iolock(struct videobuf_queue *vbq,
-				  struct videobuf_dmabuf *dma)
-{
-	int err = 0;
-
-	dma->direction = PCI_DMA_FROMDEVICE;
-	if (!dma_map_sg(vbq->dev, dma->sglist, dma->sglen, dma->direction)) {
-		kfree(dma->sglist);
-		dma->sglist = NULL;
-		dma->sglen = 0;
-		err = -EIO;
-	}
-
-	return err;
-}
-
-static int omap24xxcam_vbq_prepare(struct videobuf_queue *vbq,
-				   struct videobuf_buffer *vb,
-				   enum v4l2_field field)
-{
-	struct omap24xxcam_fh *fh = vbq->priv_data;
-	int err = 0;
-
-	/*
-	 * Accessing pix here is okay since it's constant while
-	 * streaming is on (and we only get called then).
-	 */
-	if (vb->baddr) {
-		/* This is a userspace buffer. */
-		if (fh->pix.sizeimage > vb->bsize) {
-			/* The buffer isn't big enough. */
-			err = -EINVAL;
-		} else
-			vb->size = fh->pix.sizeimage;
-	} else {
-		if (vb->state != VIDEOBUF_NEEDS_INIT) {
-			/*
-			 * We have a kernel bounce buffer that has
-			 * already been allocated.
-			 */
-			if (fh->pix.sizeimage > vb->size) {
-				/*
-				 * The image size has been changed to
-				 * a larger size since this buffer was
-				 * allocated, so we need to free and
-				 * reallocate it.
-				 */
-				omap24xxcam_vbq_release(vbq, vb);
-				vb->size = fh->pix.sizeimage;
-			}
-		} else {
-			/* We need to allocate a new kernel bounce buffer. */
-			vb->size = fh->pix.sizeimage;
-		}
-	}
-
-	if (err)
-		return err;
-
-	vb->width = fh->pix.width;
-	vb->height = fh->pix.height;
-	vb->field = field;
-
-	if (vb->state == VIDEOBUF_NEEDS_INIT) {
-		if (vb->memory == V4L2_MEMORY_MMAP)
-			/*
-			 * we have built the scatter-gather list by ourself so
-			 * do the scatter-gather mapping as well
-			 */
-			err = omap24xxcam_dma_iolock(vbq, videobuf_to_dma(vb));
-		else
-			err = videobuf_iolock(vbq, vb, NULL);
-	}
-
-	if (!err)
-		vb->state = VIDEOBUF_PREPARED;
-	else
-		omap24xxcam_vbq_release(vbq, vb);
-
-	return err;
-}
-
-static void omap24xxcam_vbq_queue(struct videobuf_queue *vbq,
-				  struct videobuf_buffer *vb)
-{
-	struct omap24xxcam_fh *fh = vbq->priv_data;
-	struct omap24xxcam_device *cam = fh->cam;
-	enum videobuf_state state = vb->state;
-	unsigned long flags;
-	int err;
-
-	/*
-	 * FIXME: We're marking the buffer active since we have no
-	 * pretty way of marking it active exactly when the
-	 * scatter-gather transfer starts.
-	 */
-	vb->state = VIDEOBUF_ACTIVE;
-
-	err = omap24xxcam_sgdma_queue(&fh->cam->sgdma,
-				      videobuf_to_dma(vb)->sglist,
-				      videobuf_to_dma(vb)->sglen, vb->size,
-				      omap24xxcam_vbq_complete, vb);
-
-	if (!err) {
-		spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
-		if (++cam->sgdma_in_queue == 1
-		    && !atomic_read(&cam->in_reset))
-			omap24xxcam_core_enable(cam);
-		spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
-	} else {
-		/*
-		 * Oops. We're not supposed to get any errors here.
-		 * The only way we could get an error is if we ran out
-		 * of scatter-gather DMA slots, but we are supposed to
-		 * have at least as many scatter-gather DMA slots as
-		 * video buffers so that can't happen.
-		 */
-		dev_err(cam->dev, "failed to queue a video buffer for dma!\n");
-		dev_err(cam->dev, "likely a bug in the driver!\n");
-		vb->state = state;
-	}
-}
-
-static struct videobuf_queue_ops omap24xxcam_vbq_ops = {
-	.buf_setup   = omap24xxcam_vbq_setup,
-	.buf_prepare = omap24xxcam_vbq_prepare,
-	.buf_queue   = omap24xxcam_vbq_queue,
-	.buf_release = omap24xxcam_vbq_release,
-};
-
-/*
- *
- * OMAP main camera system
- *
- */
-
-/*
- * Reset camera block to power-on state.
- */
-static void omap24xxcam_poweron_reset(struct omap24xxcam_device *cam)
-{
-	int max_loop = RESET_TIMEOUT_NS;
-
-	/* Reset whole camera subsystem */
-	omap24xxcam_reg_out(cam->mmio_base,
-			    CAM_SYSCONFIG,
-			    CAM_SYSCONFIG_SOFTRESET);
-
-	/* Wait till it's finished */
-	while (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
-		 & CAM_SYSSTATUS_RESETDONE)
-	       && --max_loop) {
-		ndelay(1);
-	}
-
-	if (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
-	      & CAM_SYSSTATUS_RESETDONE))
-		dev_err(cam->dev, "camera soft reset timeout\n");
-}
-
-/*
- * (Re)initialise the camera block.
- */
-static void omap24xxcam_hwinit(struct omap24xxcam_device *cam)
-{
-	omap24xxcam_poweron_reset(cam);
-
-	/* set the camera subsystem autoidle bit */
-	omap24xxcam_reg_out(cam->mmio_base, CAM_SYSCONFIG,
-			    CAM_SYSCONFIG_AUTOIDLE);
-
-	/* set the camera MMU autoidle bit */
-	omap24xxcam_reg_out(cam->mmio_base,
-			    CAMMMU_REG_OFFSET + CAMMMU_SYSCONFIG,
-			    CAMMMU_SYSCONFIG_AUTOIDLE);
-
-	omap24xxcam_core_hwinit(cam);
-
-	omap24xxcam_dma_hwinit(&cam->sgdma.dma);
-}
-
-/*
- * Callback for dma transfer stalling.
- */
-static void omap24xxcam_stalled_dma_reset(unsigned long data)
-{
-	struct omap24xxcam_device *cam = (struct omap24xxcam_device *)data;
-
-	if (!atomic_read(&cam->in_reset)) {
-		dev_dbg(cam->dev, "dma stalled, resetting camera\n");
-		omap24xxcam_reset(cam);
-	}
-}
-
-/*
- * Stop capture. Mark we're doing a reset, stop DMA transfers and
- * core. (No new scatter-gather transfers will be queued whilst
- * in_reset is non-zero.)
- *
- * If omap24xxcam_capture_stop is called from several places at
- * once, only the first call will have an effect. Similarly, the last
- * call omap24xxcam_streaming_cont will have effect.
- *
- * Serialisation is ensured by using cam->core_enable_disable_lock.
- */
-static void omap24xxcam_capture_stop(struct omap24xxcam_device *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
-
-	if (atomic_inc_return(&cam->in_reset) != 1) {
-		spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
-		return;
-	}
-
-	omap24xxcam_core_disable(cam);
-
-	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
-
-	omap24xxcam_sgdma_sync(&cam->sgdma);
-}
-
-/*
- * Reset and continue streaming.
- *
- * Note: Resetting the camera FIFO via the CC_RST bit in the CC_CTRL
- * register is supposed to be sufficient to recover from a camera
- * interface error, but it doesn't seem to be enough. If we only do
- * that then subsequent image captures are out of sync by either one
- * or two times DMA_THRESHOLD bytes. Resetting and re-initializing the
- * entire camera subsystem prevents the problem with frame
- * synchronization.
- */
-static void omap24xxcam_capture_cont(struct omap24xxcam_device *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
-
-	if (atomic_read(&cam->in_reset) != 1)
-		goto out;
-
-	omap24xxcam_hwinit(cam);
-
-	omap24xxcam_sensor_if_enable(cam);
-
-	omap24xxcam_sgdma_process(&cam->sgdma);
-
-	if (cam->sgdma_in_queue)
-		omap24xxcam_core_enable(cam);
-
-out:
-	atomic_dec(&cam->in_reset);
-	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
-}
-
-static ssize_t
-omap24xxcam_streaming_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	struct omap24xxcam_device *cam = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", cam->streaming ?  "active" : "inactive");
-}
-static DEVICE_ATTR(streaming, S_IRUGO, omap24xxcam_streaming_show, NULL);
-
-/*
- * Stop capture and restart it. I.e. reset the camera during use.
- */
-static void omap24xxcam_reset(struct omap24xxcam_device *cam)
-{
-	omap24xxcam_capture_stop(cam);
-	omap24xxcam_capture_cont(cam);
-}
-
-/*
- * The main interrupt handler.
- */
-static irqreturn_t omap24xxcam_isr(int irq, void *arg)
-{
-	struct omap24xxcam_device *cam = (struct omap24xxcam_device *)arg;
-	u32 irqstatus;
-	unsigned int irqhandled = 0;
-
-	irqstatus = omap24xxcam_reg_in(cam->mmio_base, CAM_IRQSTATUS);
-
-	if (irqstatus &
-	    (CAM_IRQSTATUS_DMA_IRQ2 | CAM_IRQSTATUS_DMA_IRQ1
-	     | CAM_IRQSTATUS_DMA_IRQ0)) {
-		omap24xxcam_dma_isr(&cam->sgdma.dma);
-		irqhandled = 1;
-	}
-	if (irqstatus & CAM_IRQSTATUS_CC_IRQ) {
-		omap24xxcam_core_isr(cam);
-		irqhandled = 1;
-	}
-	if (irqstatus & CAM_IRQSTATUS_MMU_IRQ)
-		dev_err(cam->dev, "unhandled camera MMU interrupt!\n");
-
-	return IRQ_RETVAL(irqhandled);
-}
-
-/*
- *
- * Sensor handling.
- *
- */
-
-/*
- * Enable the external sensor interface. Try to negotiate interface
- * parameters with the sensor and start using the new ones. The calls
- * to sensor_if_enable and sensor_if_disable need not to be balanced.
- */
-static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam)
-{
-	int rval;
-	struct v4l2_ifparm p;
-
-	rval = vidioc_int_g_ifparm(cam->sdev, &p);
-	if (rval) {
-		dev_err(cam->dev, "vidioc_int_g_ifparm failed with %d\n", rval);
-		return rval;
-	}
-
-	cam->if_type = p.if_type;
-
-	cam->cc_ctrl = CC_CTRL_CC_EN;
-
-	switch (p.if_type) {
-	case V4L2_IF_TYPE_BT656:
-		if (p.u.bt656.frame_start_on_rising_vs)
-			cam->cc_ctrl |= CC_CTRL_NOBT_SYNCHRO;
-		if (p.u.bt656.bt_sync_correct)
-			cam->cc_ctrl |= CC_CTRL_BT_CORRECT;
-		if (p.u.bt656.swap)
-			cam->cc_ctrl |= CC_CTRL_PAR_ORDERCAM;
-		if (p.u.bt656.latch_clk_inv)
-			cam->cc_ctrl |= CC_CTRL_PAR_CLK_POL;
-		if (p.u.bt656.nobt_hs_inv)
-			cam->cc_ctrl |= CC_CTRL_NOBT_HS_POL;
-		if (p.u.bt656.nobt_vs_inv)
-			cam->cc_ctrl |= CC_CTRL_NOBT_VS_POL;
-
-		switch (p.u.bt656.mode) {
-		case V4L2_IF_TYPE_BT656_MODE_NOBT_8BIT:
-			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT8;
-			break;
-		case V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT:
-			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT10;
-			break;
-		case V4L2_IF_TYPE_BT656_MODE_NOBT_12BIT:
-			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT12;
-			break;
-		case V4L2_IF_TYPE_BT656_MODE_BT_8BIT:
-			cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT8;
-			break;
-		case V4L2_IF_TYPE_BT656_MODE_BT_10BIT:
-			cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT10;
-			break;
-		default:
-			dev_err(cam->dev,
-				"bt656 interface mode %d not supported\n",
-				p.u.bt656.mode);
-			return -EINVAL;
-		}
-		/*
-		 * The clock rate that the sensor wants has changed.
-		 * We have to adjust the xclk from OMAP 2 side to
-		 * match the sensor's wish as closely as possible.
-		 */
-		if (p.u.bt656.clock_curr != cam->if_u.bt656.xclk) {
-			u32 xclk = p.u.bt656.clock_curr;
-			u32 divisor;
-
-			if (xclk == 0)
-				return -EINVAL;
-
-			if (xclk > CAM_MCLK)
-				xclk = CAM_MCLK;
-
-			divisor = CAM_MCLK / xclk;
-			if (divisor * xclk < CAM_MCLK)
-				divisor++;
-			if (CAM_MCLK / divisor < p.u.bt656.clock_min
-			    && divisor > 1)
-				divisor--;
-			if (divisor > 30)
-				divisor = 30;
-
-			xclk = CAM_MCLK / divisor;
-
-			if (xclk < p.u.bt656.clock_min
-			    || xclk > p.u.bt656.clock_max)
-				return -EINVAL;
-
-			cam->if_u.bt656.xclk = xclk;
-		}
-		omap24xxcam_core_xclk_set(cam, cam->if_u.bt656.xclk);
-		break;
-	default:
-		/* FIXME: how about other interfaces? */
-		dev_err(cam->dev, "interface type %d not supported\n",
-			p.if_type);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static void omap24xxcam_sensor_if_disable(const struct omap24xxcam_device *cam)
-{
-	switch (cam->if_type) {
-	case V4L2_IF_TYPE_BT656:
-		omap24xxcam_core_xclk_set(cam, 0);
-		break;
-	}
-}
-
-/*
- * Initialise the sensor hardware.
- */
-static int omap24xxcam_sensor_init(struct omap24xxcam_device *cam)
-{
-	int err = 0;
-	struct v4l2_int_device *sdev = cam->sdev;
-
-	omap24xxcam_clock_on(cam);
-	err = omap24xxcam_sensor_if_enable(cam);
-	if (err) {
-		dev_err(cam->dev, "sensor interface could not be enabled at "
-			"initialisation, %d\n", err);
-		cam->sdev = NULL;
-		goto out;
-	}
-
-	/* power up sensor during sensor initialization */
-	vidioc_int_s_power(sdev, 1);
-
-	err = vidioc_int_dev_init(sdev);
-	if (err) {
-		dev_err(cam->dev, "cannot initialize sensor, error %d\n", err);
-		/* Sensor init failed --- it's nonexistent to us! */
-		cam->sdev = NULL;
-		goto out;
-	}
-
-	dev_info(cam->dev, "sensor is %s\n", sdev->name);
-
-out:
-	omap24xxcam_sensor_if_disable(cam);
-	omap24xxcam_clock_off(cam);
-
-	vidioc_int_s_power(sdev, 0);
-
-	return err;
-}
-
-static void omap24xxcam_sensor_exit(struct omap24xxcam_device *cam)
-{
-	if (cam->sdev)
-		vidioc_int_dev_exit(cam->sdev);
-}
-
-static void omap24xxcam_sensor_disable(struct omap24xxcam_device *cam)
-{
-	omap24xxcam_sensor_if_disable(cam);
-	omap24xxcam_clock_off(cam);
-	vidioc_int_s_power(cam->sdev, 0);
-}
-
-/*
- * Power-up and configure camera sensor. It's ready for capturing now.
- */
-static int omap24xxcam_sensor_enable(struct omap24xxcam_device *cam)
-{
-	int rval;
-
-	omap24xxcam_clock_on(cam);
-
-	omap24xxcam_sensor_if_enable(cam);
-
-	rval = vidioc_int_s_power(cam->sdev, 1);
-	if (rval)
-		goto out;
-
-	rval = vidioc_int_init(cam->sdev);
-	if (rval)
-		goto out;
-
-	return 0;
-
-out:
-	omap24xxcam_sensor_disable(cam);
-
-	return rval;
-}
-
-static void omap24xxcam_sensor_reset_work(struct work_struct *work)
-{
-	struct omap24xxcam_device *cam =
-		container_of(work, struct omap24xxcam_device,
-			     sensor_reset_work);
-
-	if (atomic_read(&cam->reset_disable))
-		return;
-
-	omap24xxcam_capture_stop(cam);
-
-	if (vidioc_int_reset(cam->sdev) == 0) {
-		vidioc_int_init(cam->sdev);
-	} else {
-		/* Can't reset it by vidioc_int_reset. */
-		omap24xxcam_sensor_disable(cam);
-		omap24xxcam_sensor_enable(cam);
-	}
-
-	omap24xxcam_capture_cont(cam);
-}
-
-/*
- *
- * IOCTL interface.
- *
- */
-
-static int vidioc_querycap(struct file *file, void *fh,
-			   struct v4l2_capability *cap)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-
-	strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, cam->vfd->name, sizeof(cap->card));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-
-	return 0;
-}
-
-static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
-				   struct v4l2_fmtdesc *f)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	rval = vidioc_int_enum_fmt_cap(cam->sdev, f);
-
-	return rval;
-}
-
-static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
-				struct v4l2_format *f)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	rval = vidioc_int_g_fmt_cap(cam->sdev, f);
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
-				struct v4l2_format *f)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming) {
-		rval = -EBUSY;
-		goto out;
-	}
-
-	rval = vidioc_int_s_fmt_cap(cam->sdev, f);
-
-out:
-	mutex_unlock(&cam->mutex);
-
-	if (!rval) {
-		mutex_lock(&ofh->vbq.vb_lock);
-		ofh->pix = f->fmt.pix;
-		mutex_unlock(&ofh->vbq.vb_lock);
-	}
-
-	memset(f, 0, sizeof(*f));
-	vidioc_g_fmt_vid_cap(file, fh, f);
-
-	return rval;
-}
-
-static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
-				  struct v4l2_format *f)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	rval = vidioc_int_try_fmt_cap(cam->sdev, f);
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_reqbufs(struct file *file, void *fh,
-			  struct v4l2_requestbuffers *b)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming) {
-		mutex_unlock(&cam->mutex);
-		return -EBUSY;
-	}
-
-	omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
-	mutex_unlock(&cam->mutex);
-
-	rval = videobuf_reqbufs(&ofh->vbq, b);
-
-	/*
-	 * Either videobuf_reqbufs failed or the buffers are not
-	 * memory-mapped (which would need special attention).
-	 */
-	if (rval < 0 || b->memory != V4L2_MEMORY_MMAP)
-		goto out;
-
-	rval = omap24xxcam_vbq_alloc_mmap_buffers(&ofh->vbq, rval);
-	if (rval)
-		omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
-
-out:
-	return rval;
-}
-
-static int vidioc_querybuf(struct file *file, void *fh,
-			   struct v4l2_buffer *b)
-{
-	struct omap24xxcam_fh *ofh = fh;
-
-	return videobuf_querybuf(&ofh->vbq, b);
-}
-
-static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
-{
-	struct omap24xxcam_fh *ofh = fh;
-
-	return videobuf_qbuf(&ofh->vbq, b);
-}
-
-static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	struct videobuf_buffer *vb;
-	int rval;
-
-videobuf_dqbuf_again:
-	rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
-	if (rval)
-		goto out;
-
-	vb = ofh->vbq.bufs[b->index];
-
-	mutex_lock(&cam->mutex);
-	/* _needs_reset returns -EIO if reset is required. */
-	rval = vidioc_int_g_needs_reset(cam->sdev, (void *)vb->baddr);
-	mutex_unlock(&cam->mutex);
-	if (rval == -EIO)
-		schedule_work(&cam->sensor_reset_work);
-	else
-		rval = 0;
-
-out:
-	/*
-	 * This is a hack. We don't want to show -EIO to the user
-	 * space. Requeue the buffer and try again if we're not doing
-	 * this in non-blocking mode.
-	 */
-	if (rval == -EIO) {
-		videobuf_qbuf(&ofh->vbq, b);
-		if (!(file->f_flags & O_NONBLOCK))
-			goto videobuf_dqbuf_again;
-		/*
-		 * We don't have a videobuf_buffer now --- maybe next
-		 * time...
-		 */
-		rval = -EAGAIN;
-	}
-
-	return rval;
-}
-
-static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming) {
-		rval = -EBUSY;
-		goto out;
-	}
-
-	rval = omap24xxcam_sensor_if_enable(cam);
-	if (rval) {
-		dev_dbg(cam->dev, "vidioc_int_g_ifparm failed\n");
-		goto out;
-	}
-
-	rval = videobuf_streamon(&ofh->vbq);
-	if (!rval) {
-		cam->streaming = file;
-		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
-	}
-
-out:
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	struct videobuf_queue *q = &ofh->vbq;
-	int rval;
-
-	atomic_inc(&cam->reset_disable);
-
-	flush_work(&cam->sensor_reset_work);
-
-	rval = videobuf_streamoff(q);
-	if (!rval) {
-		mutex_lock(&cam->mutex);
-		cam->streaming = NULL;
-		mutex_unlock(&cam->mutex);
-		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
-	}
-
-	atomic_dec(&cam->reset_disable);
-
-	return rval;
-}
-
-static int vidioc_enum_input(struct file *file, void *fh,
-			     struct v4l2_input *inp)
-{
-	if (inp->index > 0)
-		return -EINVAL;
-
-	strlcpy(inp->name, "camera", sizeof(inp->name));
-	inp->type = V4L2_INPUT_TYPE_CAMERA;
-
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
-{
-	*i = 0;
-
-	return 0;
-}
-
-static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
-{
-	if (i > 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *fh,
-			    struct v4l2_queryctrl *a)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	rval = vidioc_int_queryctrl(cam->sdev, a);
-
-	return rval;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh,
-			 struct v4l2_control *a)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	rval = vidioc_int_g_ctrl(cam->sdev, a);
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh,
-			 struct v4l2_control *a)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	rval = vidioc_int_s_ctrl(cam->sdev, a);
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_g_parm(struct file *file, void *fh,
-			 struct v4l2_streamparm *a) {
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	rval = vidioc_int_g_parm(cam->sdev, a);
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-static int vidioc_s_parm(struct file *file, void *fh,
-			 struct v4l2_streamparm *a)
-{
-	struct omap24xxcam_fh *ofh = fh;
-	struct omap24xxcam_device *cam = ofh->cam;
-	struct v4l2_streamparm old_streamparm;
-	int rval;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming) {
-		rval = -EBUSY;
-		goto out;
-	}
-
-	old_streamparm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	rval = vidioc_int_g_parm(cam->sdev, &old_streamparm);
-	if (rval)
-		goto out;
-
-	rval = vidioc_int_s_parm(cam->sdev, a);
-	if (rval)
-		goto out;
-
-	rval = omap24xxcam_sensor_if_enable(cam);
-	/*
-	 * Revert to old streaming parameters if enabling sensor
-	 * interface with the new ones failed.
-	 */
-	if (rval)
-		vidioc_int_s_parm(cam->sdev, &old_streamparm);
-
-out:
-	mutex_unlock(&cam->mutex);
-
-	return rval;
-}
-
-/*
- *
- * File operations.
- *
- */
-
-static unsigned int omap24xxcam_poll(struct file *file,
-				     struct poll_table_struct *wait)
-{
-	struct omap24xxcam_fh *fh = file->private_data;
-	struct omap24xxcam_device *cam = fh->cam;
-	struct videobuf_buffer *vb;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming != file) {
-		mutex_unlock(&cam->mutex);
-		return POLLERR;
-	}
-	mutex_unlock(&cam->mutex);
-
-	mutex_lock(&fh->vbq.vb_lock);
-	if (list_empty(&fh->vbq.stream)) {
-		mutex_unlock(&fh->vbq.vb_lock);
-		return POLLERR;
-	}
-	vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer, stream);
-	mutex_unlock(&fh->vbq.vb_lock);
-
-	poll_wait(file, &vb->done, wait);
-
-	if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
-		return POLLIN | POLLRDNORM;
-
-	return 0;
-}
-
-static int omap24xxcam_mmap_buffers(struct file *file,
-				    struct vm_area_struct *vma)
-{
-	struct omap24xxcam_fh *fh = file->private_data;
-	struct omap24xxcam_device *cam = fh->cam;
-	struct videobuf_queue *vbq = &fh->vbq;
-	unsigned int first, last, size, i, j;
-	int err = 0;
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming) {
-		mutex_unlock(&cam->mutex);
-		return -EBUSY;
-	}
-	mutex_unlock(&cam->mutex);
-	mutex_lock(&vbq->vb_lock);
-
-	/* look for first buffer to map */
-	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
-		if (NULL == vbq->bufs[first])
-			continue;
-		if (V4L2_MEMORY_MMAP != vbq->bufs[first]->memory)
-			continue;
-		if (vbq->bufs[first]->boff == (vma->vm_pgoff << PAGE_SHIFT))
-			break;
-	}
-
-	/* look for last buffer to map */
-	for (size = 0, last = first; last < VIDEO_MAX_FRAME; last++) {
-		if (NULL == vbq->bufs[last])
-			continue;
-		if (V4L2_MEMORY_MMAP != vbq->bufs[last]->memory)
-			continue;
-		size += vbq->bufs[last]->bsize;
-		if (size == (vma->vm_end - vma->vm_start))
-			break;
-	}
-
-	size = 0;
-	for (i = first; i <= last && i < VIDEO_MAX_FRAME; i++) {
-		struct videobuf_dmabuf *dma = videobuf_to_dma(vbq->bufs[i]);
-
-		for (j = 0; j < dma->sglen; j++) {
-			err = remap_pfn_range(
-				vma, vma->vm_start + size,
-				page_to_pfn(sg_page(&dma->sglist[j])),
-				sg_dma_len(&dma->sglist[j]), vma->vm_page_prot);
-			if (err)
-				goto out;
-			size += sg_dma_len(&dma->sglist[j]);
-		}
-	}
-
-out:
-	mutex_unlock(&vbq->vb_lock);
-
-	return err;
-}
-
-static int omap24xxcam_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct omap24xxcam_fh *fh = file->private_data;
-	int rval;
-
-	/* let the video-buf mapper check arguments and set-up structures */
-	rval = videobuf_mmap_mapper(&fh->vbq, vma);
-	if (rval)
-		return rval;
-
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	/* do mapping to our allocated buffers */
-	rval = omap24xxcam_mmap_buffers(file, vma);
-	/*
-	 * In case of error, free vma->vm_private_data allocated by
-	 * videobuf_mmap_mapper.
-	 */
-	if (rval)
-		kfree(vma->vm_private_data);
-
-	return rval;
-}
-
-static int omap24xxcam_open(struct file *file)
-{
-	struct omap24xxcam_device *cam = omap24xxcam.priv;
-	struct omap24xxcam_fh *fh;
-	struct v4l2_format format;
-
-	if (!cam || !cam->vfd)
-		return -ENODEV;
-
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (fh == NULL)
-		return -ENOMEM;
-
-	mutex_lock(&cam->mutex);
-	if (cam->sdev == NULL || !try_module_get(cam->sdev->module)) {
-		mutex_unlock(&cam->mutex);
-		goto out_try_module_get;
-	}
-
-	if (atomic_inc_return(&cam->users) == 1) {
-		omap24xxcam_hwinit(cam);
-		if (omap24xxcam_sensor_enable(cam)) {
-			mutex_unlock(&cam->mutex);
-			goto out_omap24xxcam_sensor_enable;
-		}
-	}
-	mutex_unlock(&cam->mutex);
-
-	fh->cam = cam;
-	mutex_lock(&cam->mutex);
-	vidioc_int_g_fmt_cap(cam->sdev, &format);
-	mutex_unlock(&cam->mutex);
-	/* FIXME: how about fh->pix when there are more users? */
-	fh->pix = format.fmt.pix;
-
-	file->private_data = fh;
-
-	spin_lock_init(&fh->vbq_lock);
-
-	videobuf_queue_sg_init(&fh->vbq, &omap24xxcam_vbq_ops, NULL,
-				&fh->vbq_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				V4L2_FIELD_NONE,
-				sizeof(struct videobuf_buffer), fh, NULL);
-
-	return 0;
-
-out_omap24xxcam_sensor_enable:
-	omap24xxcam_poweron_reset(cam);
-	module_put(cam->sdev->module);
-
-out_try_module_get:
-	kfree(fh);
-
-	return -ENODEV;
-}
-
-static int omap24xxcam_release(struct file *file)
-{
-	struct omap24xxcam_fh *fh = file->private_data;
-	struct omap24xxcam_device *cam = fh->cam;
-
-	atomic_inc(&cam->reset_disable);
-
-	flush_work(&cam->sensor_reset_work);
-
-	/* stop streaming capture */
-	videobuf_streamoff(&fh->vbq);
-
-	mutex_lock(&cam->mutex);
-	if (cam->streaming == file) {
-		cam->streaming = NULL;
-		mutex_unlock(&cam->mutex);
-		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
-	} else {
-		mutex_unlock(&cam->mutex);
-	}
-
-	atomic_dec(&cam->reset_disable);
-
-	omap24xxcam_vbq_free_mmap_buffers(&fh->vbq);
-
-	/*
-	 * Make sure the reset work we might have scheduled is not
-	 * pending! It may be run *only* if we have users. (And it may
-	 * not be scheduled anymore since streaming is already
-	 * disabled.)
-	 */
-	flush_work(&cam->sensor_reset_work);
-
-	mutex_lock(&cam->mutex);
-	if (atomic_dec_return(&cam->users) == 0) {
-		omap24xxcam_sensor_disable(cam);
-		omap24xxcam_poweron_reset(cam);
-	}
-	mutex_unlock(&cam->mutex);
-
-	file->private_data = NULL;
-
-	module_put(cam->sdev->module);
-	kfree(fh);
-
-	return 0;
-}
-
-static struct v4l2_file_operations omap24xxcam_fops = {
-	.ioctl	 = video_ioctl2,
-	.poll	 = omap24xxcam_poll,
-	.mmap	 = omap24xxcam_mmap,
-	.open	 = omap24xxcam_open,
-	.release = omap24xxcam_release,
-};
-
-/*
- *
- * Power management.
- *
- */
-
-#ifdef CONFIG_PM
-static int omap24xxcam_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
-
-	if (atomic_read(&cam->users) == 0)
-		return 0;
-
-	if (!atomic_read(&cam->reset_disable))
-		omap24xxcam_capture_stop(cam);
-
-	omap24xxcam_sensor_disable(cam);
-	omap24xxcam_poweron_reset(cam);
-
-	return 0;
-}
-
-static int omap24xxcam_resume(struct platform_device *pdev)
-{
-	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
-
-	if (atomic_read(&cam->users) == 0)
-		return 0;
-
-	omap24xxcam_hwinit(cam);
-	omap24xxcam_sensor_enable(cam);
-
-	if (!atomic_read(&cam->reset_disable))
-		omap24xxcam_capture_cont(cam);
-
-	return 0;
-}
-#endif /* CONFIG_PM */
-
-static const struct v4l2_ioctl_ops omap24xxcam_ioctl_fops = {
-	.vidioc_querycap	= vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
-	.vidioc_reqbufs		= vidioc_reqbufs,
-	.vidioc_querybuf	= vidioc_querybuf,
-	.vidioc_qbuf		= vidioc_qbuf,
-	.vidioc_dqbuf		= vidioc_dqbuf,
-	.vidioc_streamon	= vidioc_streamon,
-	.vidioc_streamoff	= vidioc_streamoff,
-	.vidioc_enum_input	= vidioc_enum_input,
-	.vidioc_g_input		= vidioc_g_input,
-	.vidioc_s_input		= vidioc_s_input,
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
-	.vidioc_g_parm		= vidioc_g_parm,
-	.vidioc_s_parm		= vidioc_s_parm,
-};
-
-/*
- *
- * Camera device (i.e. /dev/video).
- *
- */
-
-static int omap24xxcam_device_register(struct v4l2_int_device *s)
-{
-	struct omap24xxcam_device *cam = s->u.slave->master->priv;
-	struct video_device *vfd;
-	int rval;
-
-	/* We already have a slave. */
-	if (cam->sdev)
-		return -EBUSY;
-
-	cam->sdev = s;
-
-	if (device_create_file(cam->dev, &dev_attr_streaming) != 0) {
-		dev_err(cam->dev, "could not register sysfs entry\n");
-		rval = -EBUSY;
-		goto err;
-	}
-
-	/* initialize the video_device struct */
-	vfd = cam->vfd = video_device_alloc();
-	if (!vfd) {
-		dev_err(cam->dev, "could not allocate video device struct\n");
-		rval = -ENOMEM;
-		goto err;
-	}
-	vfd->release = video_device_release;
-
-	vfd->v4l2_dev = &cam->v4l2_dev;
-
-	strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
-	vfd->fops		 = &omap24xxcam_fops;
-	vfd->ioctl_ops		 = &omap24xxcam_ioctl_fops;
-
-	omap24xxcam_hwinit(cam);
-
-	rval = omap24xxcam_sensor_init(cam);
-	if (rval)
-		goto err;
-
-	if (video_register_device(vfd, VFL_TYPE_GRABBER, video_nr) < 0) {
-		dev_err(cam->dev, "could not register V4L device\n");
-		rval = -EBUSY;
-		goto err;
-	}
-
-	omap24xxcam_poweron_reset(cam);
-
-	dev_info(cam->dev, "registered device %s\n",
-		 video_device_node_name(vfd));
-
-	return 0;
-
-err:
-	omap24xxcam_device_unregister(s);
-
-	return rval;
-}
-
-static void omap24xxcam_device_unregister(struct v4l2_int_device *s)
-{
-	struct omap24xxcam_device *cam = s->u.slave->master->priv;
-
-	omap24xxcam_sensor_exit(cam);
-
-	if (cam->vfd) {
-		if (!video_is_registered(cam->vfd)) {
-			/*
-			 * The device was never registered, so release the
-			 * video_device struct directly.
-			 */
-			video_device_release(cam->vfd);
-		} else {
-			/*
-			 * The unregister function will release the
-			 * video_device struct as well as
-			 * unregistering it.
-			 */
-			video_unregister_device(cam->vfd);
-		}
-		cam->vfd = NULL;
-	}
-
-	device_remove_file(cam->dev, &dev_attr_streaming);
-
-	cam->sdev = NULL;
-}
-
-static struct v4l2_int_master omap24xxcam_master = {
-	.attach = omap24xxcam_device_register,
-	.detach = omap24xxcam_device_unregister,
-};
-
-static struct v4l2_int_device omap24xxcam = {
-	.module	= THIS_MODULE,
-	.name	= CAM_NAME,
-	.type	= v4l2_int_type_master,
-	.u	= {
-		.master = &omap24xxcam_master
-	},
-};
-
-/*
- *
- * Driver initialisation and deinitialisation.
- *
- */
-
-static int omap24xxcam_probe(struct platform_device *pdev)
-{
-	struct omap24xxcam_device *cam;
-	struct resource *mem;
-	int irq;
-
-	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
-	if (!cam) {
-		dev_err(&pdev->dev, "could not allocate memory\n");
-		goto err;
-	}
-
-	platform_set_drvdata(pdev, cam);
-
-	cam->dev = &pdev->dev;
-
-	if (v4l2_device_register(&pdev->dev, &cam->v4l2_dev)) {
-		dev_err(&pdev->dev, "v4l2_device_register failed\n");
-		goto err;
-	}
-
-	/*
-	 * Impose a lower limit on the amount of memory allocated for
-	 * capture. We require at least enough memory to double-buffer
-	 * QVGA (300KB).
-	 */
-	if (capture_mem < 320 * 240 * 2 * 2)
-		capture_mem = 320 * 240 * 2 * 2;
-	cam->capture_mem = capture_mem;
-
-	/* request the mem region for the camera registers */
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(cam->dev, "no mem resource?\n");
-		goto err;
-	}
-	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
-		dev_err(cam->dev,
-			"cannot reserve camera register I/O region\n");
-		goto err;
-	}
-	cam->mmio_base_phys = mem->start;
-	cam->mmio_size = resource_size(mem);
-
-	/* map the region */
-	cam->mmio_base = ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
-	if (!cam->mmio_base) {
-		dev_err(cam->dev, "cannot map camera register I/O region\n");
-		goto err;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_err(cam->dev, "no irq for camera?\n");
-		goto err;
-	}
-
-	/* install the interrupt service routine */
-	if (request_irq(irq, omap24xxcam_isr, 0, CAM_NAME, cam)) {
-		dev_err(cam->dev,
-			"could not install interrupt service routine\n");
-		goto err;
-	}
-	cam->irq = irq;
-
-	if (omap24xxcam_clock_get(cam))
-		goto err;
-
-	INIT_WORK(&cam->sensor_reset_work, omap24xxcam_sensor_reset_work);
-
-	mutex_init(&cam->mutex);
-	spin_lock_init(&cam->core_enable_disable_lock);
-
-	omap24xxcam_sgdma_init(&cam->sgdma,
-			       cam->mmio_base + CAMDMA_REG_OFFSET,
-			       omap24xxcam_stalled_dma_reset,
-			       (unsigned long)cam);
-
-	omap24xxcam.priv = cam;
-
-	if (v4l2_int_device_register(&omap24xxcam))
-		goto err;
-
-	return 0;
-
-err:
-	omap24xxcam_remove(pdev);
-	return -ENODEV;
-}
-
-static int omap24xxcam_remove(struct platform_device *pdev)
-{
-	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
-
-	if (!cam)
-		return 0;
-
-	if (omap24xxcam.priv != NULL)
-		v4l2_int_device_unregister(&omap24xxcam);
-	omap24xxcam.priv = NULL;
-
-	omap24xxcam_clock_put(cam);
-
-	if (cam->irq) {
-		free_irq(cam->irq, cam);
-		cam->irq = 0;
-	}
-
-	if (cam->mmio_base) {
-		iounmap((void *)cam->mmio_base);
-		cam->mmio_base = 0;
-	}
-
-	if (cam->mmio_base_phys) {
-		release_mem_region(cam->mmio_base_phys, cam->mmio_size);
-		cam->mmio_base_phys = 0;
-	}
-
-	v4l2_device_unregister(&cam->v4l2_dev);
-
-	kfree(cam);
-
-	return 0;
-}
-
-static struct platform_driver omap24xxcam_driver = {
-	.probe	 = omap24xxcam_probe,
-	.remove	 = omap24xxcam_remove,
-#ifdef CONFIG_PM
-	.suspend = omap24xxcam_suspend,
-	.resume	 = omap24xxcam_resume,
-#endif
-	.driver	 = {
-		.name = CAM_NAME,
-		.owner = THIS_MODULE,
-	},
-};
-
-module_platform_driver(omap24xxcam_driver);
-
-MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
-MODULE_DESCRIPTION("OMAP24xx Video for Linux camera driver");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(OMAP24XXCAM_VERSION);
-module_param(video_nr, int, 0);
-MODULE_PARM_DESC(video_nr,
-		 "Minor number for video device (-1 ==> auto assign)");
-module_param(capture_mem, int, 0);
-MODULE_PARM_DESC(capture_mem, "Maximum amount of memory for capture "
-		 "buffers (default 4800kiB)");
diff --git a/drivers/media/platform/omap24xxcam.h b/drivers/media/platform/omap24xxcam.h
deleted file mode 100644
index 7f6f791..0000000
--- a/drivers/media/platform/omap24xxcam.h
+++ /dev/null
@@ -1,596 +0,0 @@
-/*
- * drivers/media/platform/omap24xxcam.h
- *
- * Copyright (C) 2004 MontaVista Software, Inc.
- * Copyright (C) 2004 Texas Instruments.
- * Copyright (C) 2007 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * Based on code from Andy Lowe <source@mvista.com>.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef OMAP24XXCAM_H
-#define OMAP24XXCAM_H
-
-#include <media/videobuf-dma-sg.h>
-#include <media/v4l2-int-device.h>
-#include <media/v4l2-device.h>
-
-/*
- *
- * General driver related definitions.
- *
- */
-
-#define CAM_NAME				"omap24xxcam"
-
-#define CAM_MCLK				96000000
-
-/* number of bytes transferred per DMA request */
-#define DMA_THRESHOLD				32
-
-/*
- * NUM_CAMDMA_CHANNELS is the number of logical channels provided by
- * the camera DMA controller.
- */
-#define NUM_CAMDMA_CHANNELS			4
-
-/*
- * NUM_SG_DMA is the number of scatter-gather DMA transfers that can
- * be queued. (We don't have any overlay sglists now.)
- */
-#define NUM_SG_DMA				(VIDEO_MAX_FRAME)
-
-/*
- *
- * Register definitions.
- *
- */
-
-/* subsystem register block offsets */
-#define CC_REG_OFFSET				0x00000400
-#define CAMDMA_REG_OFFSET			0x00000800
-#define CAMMMU_REG_OFFSET			0x00000C00
-
-/* define camera subsystem register offsets */
-#define CAM_REVISION				0x000
-#define CAM_SYSCONFIG				0x010
-#define CAM_SYSSTATUS				0x014
-#define CAM_IRQSTATUS				0x018
-#define CAM_GPO					0x040
-#define CAM_GPI					0x050
-
-/* define camera core register offsets */
-#define CC_REVISION				0x000
-#define CC_SYSCONFIG				0x010
-#define CC_SYSSTATUS				0x014
-#define CC_IRQSTATUS				0x018
-#define CC_IRQENABLE				0x01C
-#define CC_CTRL					0x040
-#define CC_CTRL_DMA				0x044
-#define CC_CTRL_XCLK				0x048
-#define CC_FIFODATA				0x04C
-#define CC_TEST					0x050
-#define CC_GENPAR				0x054
-#define CC_CCPFSCR				0x058
-#define CC_CCPFECR				0x05C
-#define CC_CCPLSCR				0x060
-#define CC_CCPLECR				0x064
-#define CC_CCPDFR				0x068
-
-/* define camera dma register offsets */
-#define CAMDMA_REVISION				0x000
-#define CAMDMA_IRQSTATUS_L0			0x008
-#define CAMDMA_IRQSTATUS_L1			0x00C
-#define CAMDMA_IRQSTATUS_L2			0x010
-#define CAMDMA_IRQSTATUS_L3			0x014
-#define CAMDMA_IRQENABLE_L0			0x018
-#define CAMDMA_IRQENABLE_L1			0x01C
-#define CAMDMA_IRQENABLE_L2			0x020
-#define CAMDMA_IRQENABLE_L3			0x024
-#define CAMDMA_SYSSTATUS			0x028
-#define CAMDMA_OCP_SYSCONFIG			0x02C
-#define CAMDMA_CAPS_0				0x064
-#define CAMDMA_CAPS_2				0x06C
-#define CAMDMA_CAPS_3				0x070
-#define CAMDMA_CAPS_4				0x074
-#define CAMDMA_GCR				0x078
-#define CAMDMA_CCR(n)				(0x080 + (n)*0x60)
-#define CAMDMA_CLNK_CTRL(n)			(0x084 + (n)*0x60)
-#define CAMDMA_CICR(n)				(0x088 + (n)*0x60)
-#define CAMDMA_CSR(n)				(0x08C + (n)*0x60)
-#define CAMDMA_CSDP(n)				(0x090 + (n)*0x60)
-#define CAMDMA_CEN(n)				(0x094 + (n)*0x60)
-#define CAMDMA_CFN(n)				(0x098 + (n)*0x60)
-#define CAMDMA_CSSA(n)				(0x09C + (n)*0x60)
-#define CAMDMA_CDSA(n)				(0x0A0 + (n)*0x60)
-#define CAMDMA_CSEI(n)				(0x0A4 + (n)*0x60)
-#define CAMDMA_CSFI(n)				(0x0A8 + (n)*0x60)
-#define CAMDMA_CDEI(n)				(0x0AC + (n)*0x60)
-#define CAMDMA_CDFI(n)				(0x0B0 + (n)*0x60)
-#define CAMDMA_CSAC(n)				(0x0B4 + (n)*0x60)
-#define CAMDMA_CDAC(n)				(0x0B8 + (n)*0x60)
-#define CAMDMA_CCEN(n)				(0x0BC + (n)*0x60)
-#define CAMDMA_CCFN(n)				(0x0C0 + (n)*0x60)
-#define CAMDMA_COLOR(n)				(0x0C4 + (n)*0x60)
-
-/* define camera mmu register offsets */
-#define CAMMMU_REVISION				0x000
-#define CAMMMU_SYSCONFIG			0x010
-#define CAMMMU_SYSSTATUS			0x014
-#define CAMMMU_IRQSTATUS			0x018
-#define CAMMMU_IRQENABLE			0x01C
-#define CAMMMU_WALKING_ST			0x040
-#define CAMMMU_CNTL				0x044
-#define CAMMMU_FAULT_AD				0x048
-#define CAMMMU_TTB				0x04C
-#define CAMMMU_LOCK				0x050
-#define CAMMMU_LD_TLB				0x054
-#define CAMMMU_CAM				0x058
-#define CAMMMU_RAM				0x05C
-#define CAMMMU_GFLUSH				0x060
-#define CAMMMU_FLUSH_ENTRY			0x064
-#define CAMMMU_READ_CAM				0x068
-#define CAMMMU_READ_RAM				0x06C
-#define CAMMMU_EMU_FAULT_AD			0x070
-
-/* Define bit fields within selected registers */
-#define CAM_REVISION_MAJOR			(15 << 4)
-#define CAM_REVISION_MAJOR_SHIFT		4
-#define CAM_REVISION_MINOR			(15 << 0)
-#define CAM_REVISION_MINOR_SHIFT		0
-
-#define CAM_SYSCONFIG_SOFTRESET			(1 <<  1)
-#define CAM_SYSCONFIG_AUTOIDLE			(1 <<  0)
-
-#define CAM_SYSSTATUS_RESETDONE			(1 <<  0)
-
-#define CAM_IRQSTATUS_CC_IRQ			(1 <<  4)
-#define CAM_IRQSTATUS_MMU_IRQ			(1 <<  3)
-#define CAM_IRQSTATUS_DMA_IRQ2			(1 <<  2)
-#define CAM_IRQSTATUS_DMA_IRQ1			(1 <<  1)
-#define CAM_IRQSTATUS_DMA_IRQ0			(1 <<  0)
-
-#define CAM_GPO_CAM_S_P_EN			(1 <<  1)
-#define CAM_GPO_CAM_CCP_MODE			(1 <<  0)
-
-#define CAM_GPI_CC_DMA_REQ1			(1 << 24)
-#define CAP_GPI_CC_DMA_REQ0			(1 << 23)
-#define CAP_GPI_CAM_MSTANDBY			(1 << 21)
-#define CAP_GPI_CAM_WAIT			(1 << 20)
-#define CAP_GPI_CAM_S_DATA			(1 << 17)
-#define CAP_GPI_CAM_S_CLK			(1 << 16)
-#define CAP_GPI_CAM_P_DATA			(0xFFF << 3)
-#define CAP_GPI_CAM_P_DATA_SHIFT		3
-#define CAP_GPI_CAM_P_VS			(1 <<  2)
-#define CAP_GPI_CAM_P_HS			(1 <<  1)
-#define CAP_GPI_CAM_P_CLK			(1 <<  0)
-
-#define CC_REVISION_MAJOR			(15 << 4)
-#define CC_REVISION_MAJOR_SHIFT			4
-#define CC_REVISION_MINOR			(15 << 0)
-#define CC_REVISION_MINOR_SHIFT			0
-
-#define CC_SYSCONFIG_SIDLEMODE			(3 <<  3)
-#define CC_SYSCONFIG_SIDLEMODE_FIDLE		(0 <<  3)
-#define CC_SYSCONFIG_SIDLEMODE_NIDLE		(1 <<  3)
-#define CC_SYSCONFIG_SOFTRESET			(1 <<  1)
-#define CC_SYSCONFIG_AUTOIDLE			(1 <<  0)
-
-#define CC_SYSSTATUS_RESETDONE			(1 <<  0)
-
-#define CC_IRQSTATUS_FS_IRQ			(1 << 19)
-#define CC_IRQSTATUS_LE_IRQ			(1 << 18)
-#define CC_IRQSTATUS_LS_IRQ			(1 << 17)
-#define CC_IRQSTATUS_FE_IRQ			(1 << 16)
-#define CC_IRQSTATUS_FW_ERR_IRQ			(1 << 10)
-#define CC_IRQSTATUS_FSC_ERR_IRQ		(1 <<  9)
-#define CC_IRQSTATUS_SSC_ERR_IRQ		(1 <<  8)
-#define CC_IRQSTATUS_FIFO_NOEMPTY_IRQ		(1 <<  4)
-#define CC_IRQSTATUS_FIFO_FULL_IRQ		(1 <<  3)
-#define CC_IRQSTATUS_FIFO_THR_IRQ		(1 <<  2)
-#define CC_IRQSTATUS_FIFO_OF_IRQ		(1 <<  1)
-#define CC_IRQSTATUS_FIFO_UF_IRQ		(1 <<  0)
-
-#define CC_IRQENABLE_FS_IRQ			(1 << 19)
-#define CC_IRQENABLE_LE_IRQ			(1 << 18)
-#define CC_IRQENABLE_LS_IRQ			(1 << 17)
-#define CC_IRQENABLE_FE_IRQ			(1 << 16)
-#define CC_IRQENABLE_FW_ERR_IRQ			(1 << 10)
-#define CC_IRQENABLE_FSC_ERR_IRQ		(1 <<  9)
-#define CC_IRQENABLE_SSC_ERR_IRQ		(1 <<  8)
-#define CC_IRQENABLE_FIFO_NOEMPTY_IRQ		(1 <<  4)
-#define CC_IRQENABLE_FIFO_FULL_IRQ		(1 <<  3)
-#define CC_IRQENABLE_FIFO_THR_IRQ		(1 <<  2)
-#define CC_IRQENABLE_FIFO_OF_IRQ		(1 <<  1)
-#define CC_IRQENABLE_FIFO_UF_IRQ		(1 <<  0)
-
-#define CC_CTRL_CC_ONE_SHOT			(1 << 20)
-#define CC_CTRL_CC_IF_SYNCHRO			(1 << 19)
-#define CC_CTRL_CC_RST				(1 << 18)
-#define CC_CTRL_CC_FRAME_TRIG			(1 << 17)
-#define CC_CTRL_CC_EN				(1 << 16)
-#define CC_CTRL_NOBT_SYNCHRO			(1 << 13)
-#define CC_CTRL_BT_CORRECT			(1 << 12)
-#define CC_CTRL_PAR_ORDERCAM			(1 << 11)
-#define CC_CTRL_PAR_CLK_POL			(1 << 10)
-#define CC_CTRL_NOBT_HS_POL			(1 <<  9)
-#define CC_CTRL_NOBT_VS_POL			(1 <<  8)
-#define CC_CTRL_PAR_MODE			(7 <<  1)
-#define CC_CTRL_PAR_MODE_SHIFT			1
-#define CC_CTRL_PAR_MODE_NOBT8			(0 <<  1)
-#define CC_CTRL_PAR_MODE_NOBT10			(1 <<  1)
-#define CC_CTRL_PAR_MODE_NOBT12			(2 <<  1)
-#define CC_CTRL_PAR_MODE_BT8			(4 <<  1)
-#define CC_CTRL_PAR_MODE_BT10			(5 <<  1)
-#define CC_CTRL_PAR_MODE_FIFOTEST		(7 <<  1)
-#define CC_CTRL_CCP_MODE			(1 <<  0)
-
-#define CC_CTRL_DMA_EN				(1 <<  8)
-#define CC_CTRL_DMA_FIFO_THRESHOLD		(0x7F << 0)
-#define CC_CTRL_DMA_FIFO_THRESHOLD_SHIFT	0
-
-#define CC_CTRL_XCLK_DIV			(0x1F << 0)
-#define CC_CTRL_XCLK_DIV_SHIFT			0
-#define CC_CTRL_XCLK_DIV_STABLE_LOW		(0 <<  0)
-#define CC_CTRL_XCLK_DIV_STABLE_HIGH		(1 <<  0)
-#define CC_CTRL_XCLK_DIV_BYPASS			(31 << 0)
-
-#define CC_TEST_FIFO_RD_POINTER			(0xFF << 24)
-#define CC_TEST_FIFO_RD_POINTER_SHIFT		24
-#define CC_TEST_FIFO_WR_POINTER			(0xFF << 16)
-#define CC_TEST_FIFO_WR_POINTER_SHIFT		16
-#define CC_TEST_FIFO_LEVEL			(0xFF <<  8)
-#define CC_TEST_FIFO_LEVEL_SHIFT		8
-#define CC_TEST_FIFO_LEVEL_PEAK			(0xFF <<  0)
-#define CC_TEST_FIFO_LEVEL_PEAK_SHIFT		0
-
-#define CC_GENPAR_FIFO_DEPTH			(7 <<  0)
-#define CC_GENPAR_FIFO_DEPTH_SHIFT		0
-
-#define CC_CCPDFR_ALPHA				(0xFF <<  8)
-#define CC_CCPDFR_ALPHA_SHIFT			8
-#define CC_CCPDFR_DATAFORMAT			(15 <<  0)
-#define CC_CCPDFR_DATAFORMAT_SHIFT		0
-#define CC_CCPDFR_DATAFORMAT_YUV422BE		(0 <<  0)
-#define CC_CCPDFR_DATAFORMAT_YUV422		(1 <<  0)
-#define CC_CCPDFR_DATAFORMAT_YUV420		(2 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RGB444		(4 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RGB565		(5 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RGB888NDE		(6 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RGB888		(7 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW8NDE		(8 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW8		(9 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW10NDE		(10 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW10		(11 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW12NDE		(12 <<  0)
-#define CC_CCPDFR_DATAFORMAT_RAW12		(13 <<  0)
-#define CC_CCPDFR_DATAFORMAT_JPEG8		(15 <<  0)
-
-#define CAMDMA_REVISION_MAJOR			(15 << 4)
-#define CAMDMA_REVISION_MAJOR_SHIFT		4
-#define CAMDMA_REVISION_MINOR			(15 << 0)
-#define CAMDMA_REVISION_MINOR_SHIFT		0
-
-#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE		(3 << 12)
-#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY	(0 << 12)
-#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_NSTANDBY	(1 << 12)
-#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_SSTANDBY	(2 << 12)
-#define CAMDMA_OCP_SYSCONFIG_FUNC_CLOCK		(1 <<  9)
-#define CAMDMA_OCP_SYSCONFIG_OCP_CLOCK		(1 <<  8)
-#define CAMDMA_OCP_SYSCONFIG_EMUFREE		(1 <<  5)
-#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE		(3 <<  3)
-#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE	(0 <<  3)
-#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_NIDLE	(1 <<  3)
-#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_SIDLE	(2 <<  3)
-#define CAMDMA_OCP_SYSCONFIG_SOFTRESET		(1 <<  1)
-#define CAMDMA_OCP_SYSCONFIG_AUTOIDLE		(1 <<  0)
-
-#define CAMDMA_SYSSTATUS_RESETDONE		(1 <<  0)
-
-#define CAMDMA_GCR_ARBITRATION_RATE		(0xFF << 16)
-#define CAMDMA_GCR_ARBITRATION_RATE_SHIFT	16
-#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH	(0xFF << 0)
-#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH_SHIFT	0
-
-#define CAMDMA_CCR_SEL_SRC_DST_SYNC		(1 << 24)
-#define CAMDMA_CCR_PREFETCH			(1 << 23)
-#define CAMDMA_CCR_SUPERVISOR			(1 << 22)
-#define CAMDMA_CCR_SECURE			(1 << 21)
-#define CAMDMA_CCR_BS				(1 << 18)
-#define CAMDMA_CCR_TRANSPARENT_COPY_ENABLE	(1 << 17)
-#define CAMDMA_CCR_CONSTANT_FILL_ENABLE		(1 << 16)
-#define CAMDMA_CCR_DST_AMODE			(3 << 14)
-#define CAMDMA_CCR_DST_AMODE_CONST_ADDR		(0 << 14)
-#define CAMDMA_CCR_DST_AMODE_POST_INC		(1 << 14)
-#define CAMDMA_CCR_DST_AMODE_SGL_IDX		(2 << 14)
-#define CAMDMA_CCR_DST_AMODE_DBL_IDX		(3 << 14)
-#define CAMDMA_CCR_SRC_AMODE			(3 << 12)
-#define CAMDMA_CCR_SRC_AMODE_CONST_ADDR		(0 << 12)
-#define CAMDMA_CCR_SRC_AMODE_POST_INC		(1 << 12)
-#define CAMDMA_CCR_SRC_AMODE_SGL_IDX		(2 << 12)
-#define CAMDMA_CCR_SRC_AMODE_DBL_IDX		(3 << 12)
-#define CAMDMA_CCR_WR_ACTIVE			(1 << 10)
-#define CAMDMA_CCR_RD_ACTIVE			(1 <<  9)
-#define CAMDMA_CCR_SUSPEND_SENSITIVE		(1 <<  8)
-#define CAMDMA_CCR_ENABLE			(1 <<  7)
-#define CAMDMA_CCR_PRIO				(1 <<  6)
-#define CAMDMA_CCR_FS				(1 <<  5)
-#define CAMDMA_CCR_SYNCHRO			((3 << 19) | (31 << 0))
-#define CAMDMA_CCR_SYNCHRO_CAMERA		0x01
-
-#define CAMDMA_CLNK_CTRL_ENABLE_LNK		(1 << 15)
-#define CAMDMA_CLNK_CTRL_NEXTLCH_ID		(0x1F << 0)
-#define CAMDMA_CLNK_CTRL_NEXTLCH_ID_SHIFT	0
-
-#define CAMDMA_CICR_MISALIGNED_ERR_IE		(1 << 11)
-#define CAMDMA_CICR_SUPERVISOR_ERR_IE		(1 << 10)
-#define CAMDMA_CICR_SECURE_ERR_IE		(1 <<  9)
-#define CAMDMA_CICR_TRANS_ERR_IE		(1 <<  8)
-#define CAMDMA_CICR_PACKET_IE			(1 <<  7)
-#define CAMDMA_CICR_BLOCK_IE			(1 <<  5)
-#define CAMDMA_CICR_LAST_IE			(1 <<  4)
-#define CAMDMA_CICR_FRAME_IE			(1 <<  3)
-#define CAMDMA_CICR_HALF_IE			(1 <<  2)
-#define CAMDMA_CICR_DROP_IE			(1 <<  1)
-
-#define CAMDMA_CSR_MISALIGNED_ERR		(1 << 11)
-#define CAMDMA_CSR_SUPERVISOR_ERR		(1 << 10)
-#define CAMDMA_CSR_SECURE_ERR			(1 <<  9)
-#define CAMDMA_CSR_TRANS_ERR			(1 <<  8)
-#define CAMDMA_CSR_PACKET			(1 <<  7)
-#define CAMDMA_CSR_SYNC				(1 <<  6)
-#define CAMDMA_CSR_BLOCK			(1 <<  5)
-#define CAMDMA_CSR_LAST				(1 <<  4)
-#define CAMDMA_CSR_FRAME			(1 <<  3)
-#define CAMDMA_CSR_HALF				(1 <<  2)
-#define CAMDMA_CSR_DROP				(1 <<  1)
-
-#define CAMDMA_CSDP_SRC_ENDIANNESS		(1 << 21)
-#define CAMDMA_CSDP_SRC_ENDIANNESS_LOCK		(1 << 20)
-#define CAMDMA_CSDP_DST_ENDIANNESS		(1 << 19)
-#define CAMDMA_CSDP_DST_ENDIANNESS_LOCK		(1 << 18)
-#define CAMDMA_CSDP_WRITE_MODE			(3 << 16)
-#define CAMDMA_CSDP_WRITE_MODE_WRNP		(0 << 16)
-#define CAMDMA_CSDP_WRITE_MODE_POSTED		(1 << 16)
-#define CAMDMA_CSDP_WRITE_MODE_POSTED_LAST_WRNP	(2 << 16)
-#define CAMDMA_CSDP_DST_BURST_EN		(3 << 14)
-#define CAMDMA_CSDP_DST_BURST_EN_1		(0 << 14)
-#define CAMDMA_CSDP_DST_BURST_EN_16		(1 << 14)
-#define CAMDMA_CSDP_DST_BURST_EN_32		(2 << 14)
-#define CAMDMA_CSDP_DST_BURST_EN_64		(3 << 14)
-#define CAMDMA_CSDP_DST_PACKED			(1 << 13)
-#define CAMDMA_CSDP_WR_ADD_TRSLT		(15 << 9)
-#define CAMDMA_CSDP_WR_ADD_TRSLT_ENABLE_MREQADD	(3 <<  9)
-#define CAMDMA_CSDP_SRC_BURST_EN		(3 <<  7)
-#define CAMDMA_CSDP_SRC_BURST_EN_1		(0 <<  7)
-#define CAMDMA_CSDP_SRC_BURST_EN_16		(1 <<  7)
-#define CAMDMA_CSDP_SRC_BURST_EN_32		(2 <<  7)
-#define CAMDMA_CSDP_SRC_BURST_EN_64		(3 <<  7)
-#define CAMDMA_CSDP_SRC_PACKED			(1 <<  6)
-#define CAMDMA_CSDP_RD_ADD_TRSLT		(15 << 2)
-#define CAMDMA_CSDP_RD_ADD_TRSLT_ENABLE_MREQADD	(3 <<  2)
-#define CAMDMA_CSDP_DATA_TYPE			(3 <<  0)
-#define CAMDMA_CSDP_DATA_TYPE_8BITS		(0 <<  0)
-#define CAMDMA_CSDP_DATA_TYPE_16BITS		(1 <<  0)
-#define CAMDMA_CSDP_DATA_TYPE_32BITS		(2 <<  0)
-
-#define CAMMMU_SYSCONFIG_AUTOIDLE		(1 <<  0)
-
-/*
- *
- * Declarations.
- *
- */
-
-/* forward declarations */
-struct omap24xxcam_sgdma;
-struct omap24xxcam_dma;
-
-typedef void (*sgdma_callback_t)(struct omap24xxcam_sgdma *cam,
-				 u32 status, void *arg);
-typedef void (*dma_callback_t)(struct omap24xxcam_dma *cam,
-			       u32 status, void *arg);
-
-struct channel_state {
-	dma_callback_t callback;
-	void *arg;
-};
-
-/* sgdma state for each of the possible videobuf_buffers + 2 overlays */
-struct sgdma_state {
-	const struct scatterlist *sglist;
-	int sglen;		 /* number of sglist entries */
-	int next_sglist;	 /* index of next sglist entry to process */
-	unsigned int bytes_read; /* number of bytes read */
-	unsigned int len;        /* total length of sglist (excluding
-				  * bytes due to page alignment) */
-	int queued_sglist;	 /* number of sglist entries queued for DMA */
-	u32 csr;		 /* DMA return code */
-	sgdma_callback_t callback;
-	void *arg;
-};
-
-/* physical DMA channel management */
-struct omap24xxcam_dma {
-	spinlock_t lock;	/* Lock for the whole structure. */
-
-	void __iomem *base;	/* base address for dma controller */
-
-	/* While dma_stop!=0, an attempt to start a new DMA transfer will
-	 * fail.
-	 */
-	atomic_t dma_stop;
-	int free_dmach;		/* number of dma channels free */
-	int next_dmach;		/* index of next dma channel to use */
-	struct channel_state ch_state[NUM_CAMDMA_CHANNELS];
-};
-
-/* scatter-gather DMA (scatterlist stuff) management */
-struct omap24xxcam_sgdma {
-	struct omap24xxcam_dma dma;
-
-	spinlock_t lock;	/* Lock for the fields below. */
-	int free_sgdma;		/* number of free sg dma slots */
-	int next_sgdma;		/* index of next sg dma slot to use */
-	struct sgdma_state sg_state[NUM_SG_DMA];
-
-	/* Reset timer data */
-	struct timer_list reset_timer;
-};
-
-/* per-device data structure */
-struct omap24xxcam_device {
-	/*** mutex  ***/
-	/*
-	 * mutex serialises access to this structure. Also camera
-	 * opening and releasing is synchronised by this.
-	 */
-	struct mutex mutex;
-
-	struct v4l2_device v4l2_dev;
-
-	/*** general driver state information ***/
-	atomic_t users;
-	/*
-	 * Lock to serialise core enabling and disabling and access to
-	 * sgdma_in_queue.
-	 */
-	spinlock_t core_enable_disable_lock;
-	/*
-	 * Number or sgdma requests in scatter-gather queue, protected
-	 * by the lock above.
-	 */
-	int sgdma_in_queue;
-	/*
-	 * Sensor interface parameters: interface type, CC_CTRL
-	 * register value and interface specific data.
-	 */
-	int if_type;
-	union {
-		struct parallel {
-			u32 xclk;
-		} bt656;
-	} if_u;
-	u32 cc_ctrl;
-
-	/*** subsystem structures ***/
-	struct omap24xxcam_sgdma sgdma;
-
-	/*** hardware resources ***/
-	unsigned int irq;
-	void __iomem *mmio_base;
-	unsigned long mmio_base_phys;
-	unsigned long mmio_size;
-
-	/*** interfaces and device ***/
-	struct v4l2_int_device *sdev;
-	struct device *dev;
-	struct video_device *vfd;
-
-	/*** camera and sensor reset related stuff ***/
-	struct work_struct sensor_reset_work;
-	/*
-	 * We're in the middle of a reset. Don't enable core if this
-	 * is non-zero! This exists to help decisionmaking in a case
-	 * where videobuf_qbuf is called while we are in the middle of
-	 * a reset.
-	 */
-	atomic_t in_reset;
-	/*
-	 * Non-zero if we don't want any resets for now. Used to
-	 * prevent reset work to run when we're about to stop
-	 * streaming.
-	 */
-	atomic_t reset_disable;
-
-	/*** video device parameters ***/
-	int capture_mem;
-
-	/*** camera module clocks ***/
-	struct clk *fck;
-	struct clk *ick;
-
-	/*** capture data ***/
-	/* file handle, if streaming is on */
-	struct file *streaming;
-};
-
-/* Per-file handle data. */
-struct omap24xxcam_fh {
-	spinlock_t vbq_lock; /* spinlock for the videobuf queue */
-	struct videobuf_queue vbq;
-	struct v4l2_pix_format pix; /* serialise pix by vbq->lock */
-	atomic_t field_count; /* field counter for videobuf_buffer */
-	/* accessing cam here doesn't need serialisation: it's constant */
-	struct omap24xxcam_device *cam;
-};
-
-/*
- *
- * Register I/O functions.
- *
- */
-
-static inline u32 omap24xxcam_reg_in(u32 __iomem *base, u32 offset)
-{
-	return readl(base + offset);
-}
-
-static inline u32 omap24xxcam_reg_out(u32 __iomem *base, u32 offset,
-					  u32 val)
-{
-	writel(val, base + offset);
-	return val;
-}
-
-static inline u32 omap24xxcam_reg_merge(u32 __iomem *base, u32 offset,
-					    u32 val, u32 mask)
-{
-	u32 __iomem *addr = base + offset;
-	u32 new_val = (readl(addr) & ~mask) | (val & mask);
-
-	writel(new_val, addr);
-	return new_val;
-}
-
-/*
- *
- * Function prototypes.
- *
- */
-
-/* dma prototypes */
-
-void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma);
-void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma);
-
-/* sgdma prototypes */
-
-void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma);
-int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
-			    const struct scatterlist *sglist, int sglen,
-			    int len, sgdma_callback_t callback, void *arg);
-void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma);
-void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
-			    void __iomem *base,
-			    void (*reset_callback)(unsigned long data),
-			    unsigned long reset_callback_data);
-void omap24xxcam_sgdma_exit(struct omap24xxcam_sgdma *sgdma);
-
-#endif
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8c05565..2189bfb 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -83,14 +83,3 @@ config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
-
-config VIDEO_V4L2_INT_DEVICE
-	tristate "V4L2 int device (DEPRECATED)"
-	depends on VIDEO_V4L2
-	---help---
-	  An early framework for a hardware-independent interface for
-	  image sensors and bridges etc. Currently used by omap24xxcam and
-	  tcm825x drivers that should be converted to V4L2 subdev.
-
-	  Do not use for new developments.
-
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1a85eee..c6ae7ba 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -15,7 +15,6 @@ ifeq ($(CONFIG_OF),y)
 endif
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
-obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
 
diff --git a/drivers/media/v4l2-core/v4l2-int-device.c b/drivers/media/v4l2-core/v4l2-int-device.c
deleted file mode 100644
index f447349..0000000
--- a/drivers/media/v4l2-core/v4l2-int-device.c
+++ /dev/null
@@ -1,164 +0,0 @@
-/*
- * drivers/media/video/v4l2-int-device.c
- *
- * V4L2 internal ioctl interface.
- *
- * Copyright (C) 2007 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/sort.h>
-#include <linux/string.h>
-#include <linux/module.h>
-
-#include <media/v4l2-int-device.h>
-
-static DEFINE_MUTEX(mutex);
-static LIST_HEAD(int_list);
-
-void v4l2_int_device_try_attach_all(void)
-{
-	struct v4l2_int_device *m, *s;
-
-	list_for_each_entry(m, &int_list, head) {
-		if (m->type != v4l2_int_type_master)
-			continue;
-
-		list_for_each_entry(s, &int_list, head) {
-			if (s->type != v4l2_int_type_slave)
-				continue;
-
-			/* Slave is connected? */
-			if (s->u.slave->master)
-				continue;
-
-			/* Slave wants to attach to master? */
-			if (s->u.slave->attach_to[0] != 0
-			    && strncmp(m->name, s->u.slave->attach_to,
-				       V4L2NAMESIZE))
-				continue;
-
-			if (!try_module_get(m->module))
-				continue;
-
-			s->u.slave->master = m;
-			if (m->u.master->attach(s)) {
-				s->u.slave->master = NULL;
-				module_put(m->module);
-				continue;
-			}
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(v4l2_int_device_try_attach_all);
-
-static int ioctl_sort_cmp(const void *a, const void *b)
-{
-	const struct v4l2_int_ioctl_desc *d1 = a, *d2 = b;
-
-	if (d1->num > d2->num)
-		return 1;
-
-	if (d1->num < d2->num)
-		return -1;
-
-	return 0;
-}
-
-int v4l2_int_device_register(struct v4l2_int_device *d)
-{
-	if (d->type == v4l2_int_type_slave)
-		sort(d->u.slave->ioctls, d->u.slave->num_ioctls,
-		     sizeof(struct v4l2_int_ioctl_desc),
-		     &ioctl_sort_cmp, NULL);
-	mutex_lock(&mutex);
-	list_add(&d->head, &int_list);
-	v4l2_int_device_try_attach_all();
-	mutex_unlock(&mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(v4l2_int_device_register);
-
-void v4l2_int_device_unregister(struct v4l2_int_device *d)
-{
-	mutex_lock(&mutex);
-	list_del(&d->head);
-	if (d->type == v4l2_int_type_slave
-	    && d->u.slave->master != NULL) {
-		d->u.slave->master->u.master->detach(d);
-		module_put(d->u.slave->master->module);
-		d->u.slave->master = NULL;
-	}
-	mutex_unlock(&mutex);
-}
-EXPORT_SYMBOL_GPL(v4l2_int_device_unregister);
-
-/* Adapted from search_extable in extable.c. */
-static v4l2_int_ioctl_func *find_ioctl(struct v4l2_int_slave *slave, int cmd,
-				       v4l2_int_ioctl_func *no_such_ioctl)
-{
-	const struct v4l2_int_ioctl_desc *first = slave->ioctls;
-	const struct v4l2_int_ioctl_desc *last =
-		first + slave->num_ioctls - 1;
-
-	while (first <= last) {
-		const struct v4l2_int_ioctl_desc *mid;
-
-		mid = (last - first) / 2 + first;
-
-		if (mid->num < cmd)
-			first = mid + 1;
-		else if (mid->num > cmd)
-			last = mid - 1;
-		else
-			return mid->func;
-	}
-
-	return no_such_ioctl;
-}
-
-static int no_such_ioctl_0(struct v4l2_int_device *d)
-{
-	return -ENOIOCTLCMD;
-}
-
-int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd)
-{
-	return ((v4l2_int_ioctl_func_0 *)
-		find_ioctl(d->u.slave, cmd,
-			   (v4l2_int_ioctl_func *)no_such_ioctl_0))(d);
-}
-EXPORT_SYMBOL_GPL(v4l2_int_ioctl_0);
-
-static int no_such_ioctl_1(struct v4l2_int_device *d, void *arg)
-{
-	return -ENOIOCTLCMD;
-}
-
-int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg)
-{
-	return ((v4l2_int_ioctl_func_1 *)
-		find_ioctl(d->u.slave, cmd,
-			   (v4l2_int_ioctl_func *)no_such_ioctl_1))(d, arg);
-}
-EXPORT_SYMBOL_GPL(v4l2_int_ioctl_1);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 6a20217..22b0c9d 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,6 +33,8 @@ source "drivers/staging/media/go7007/Kconfig"
 
 source "drivers/staging/media/msi3101/Kconfig"
 
+source "drivers/staging/media/omap24xx/Kconfig"
+
 source "drivers/staging/media/sn9c102/Kconfig"
 
 source "drivers/staging/media/solo6x10/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 2a15451..bedc62a 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_USB_SN9C102)       += sn9c102/
+obj-$(CONFIG_VIDEO_OMAP2)       += omap24xx/
+obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
diff --git a/drivers/staging/media/omap24xx/Kconfig b/drivers/staging/media/omap24xx/Kconfig
new file mode 100644
index 0000000..82e569a
--- /dev/null
+++ b/drivers/staging/media/omap24xx/Kconfig
@@ -0,0 +1,35 @@
+config VIDEO_V4L2_INT_DEVICE
+       tristate
+
+config VIDEO_OMAP2
+	tristate "OMAP2 Camera Capture Interface driver (DEPRECATED)"
+	depends on VIDEO_DEV && ARCH_OMAP2
+	select VIDEOBUF_DMA_SG
+	select VIDEO_V4L2_INT_DEVICE
+	---help---
+	  This is a v4l2 driver for the TI OMAP2 camera capture interface
+
+	  It uses the deprecated int-device API. Since this driver is no
+	  longer actively maintained and nobody is interested in converting
+	  it to the subdev API, this driver will be removed soon.
+
+	  If you do want to keep this driver in the kernel, and are willing
+	  to convert it to the subdev API, then please contact the linux-media
+	  mailinglist.
+
+config VIDEO_TCM825X
+	tristate "TCM825x camera sensor support (DEPRECATED)"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	select VIDEO_V4L2_INT_DEVICE
+	---help---
+	  This is a driver for the Toshiba TCM825x VGA camera sensor.
+	  It is used for example in Nokia N800.
+
+	  It uses the deprecated int-device API. Since this driver is no
+	  longer actively maintained and nobody is interested in converting
+	  it to the subdev API, this driver will be removed soon.
+
+	  If you do want to keep this driver in the kernel, and are willing
+	  to convert it to the subdev API, then please contact the linux-media
+	  mailinglist.
diff --git a/drivers/staging/media/omap24xx/Makefile b/drivers/staging/media/omap24xx/Makefile
new file mode 100644
index 0000000..c2e7175
--- /dev/null
+++ b/drivers/staging/media/omap24xx/Makefile
@@ -0,0 +1,5 @@
+omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
+
+obj-$(CONFIG_VIDEO_OMAP2)   += omap2cam.o
+obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
+obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
diff --git a/drivers/staging/media/omap24xx/omap24xxcam-dma.c b/drivers/staging/media/omap24xx/omap24xxcam-dma.c
new file mode 100644
index 0000000..9c00776
--- /dev/null
+++ b/drivers/staging/media/omap24xx/omap24xxcam-dma.c
@@ -0,0 +1,601 @@
+/*
+ * drivers/media/platform/omap24xxcam-dma.c
+ *
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2004 Texas Instruments.
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * Based on code from Andy Lowe <source@mvista.com> and
+ *                    David Cohen <david.cohen@indt.org.br>.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+
+#include "omap24xxcam.h"
+
+/*
+ *
+ * DMA hardware.
+ *
+ */
+
+/* Ack all interrupt on CSR and IRQSTATUS_L0 */
+static void omap24xxcam_dmahw_ack_all(void __iomem *base)
+{
+	u32 csr;
+	int i;
+
+	for (i = 0; i < NUM_CAMDMA_CHANNELS; ++i) {
+		csr = omap24xxcam_reg_in(base, CAMDMA_CSR(i));
+		/* ack interrupt in CSR */
+		omap24xxcam_reg_out(base, CAMDMA_CSR(i), csr);
+	}
+	omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, 0xf);
+}
+
+/* Ack dmach on CSR and IRQSTATUS_L0 */
+static u32 omap24xxcam_dmahw_ack_ch(void __iomem *base, int dmach)
+{
+	u32 csr;
+
+	csr = omap24xxcam_reg_in(base, CAMDMA_CSR(dmach));
+	/* ack interrupt in CSR */
+	omap24xxcam_reg_out(base, CAMDMA_CSR(dmach), csr);
+	/* ack interrupt in IRQSTATUS */
+	omap24xxcam_reg_out(base, CAMDMA_IRQSTATUS_L0, (1 << dmach));
+
+	return csr;
+}
+
+static int omap24xxcam_dmahw_running(void __iomem *base, int dmach)
+{
+	return omap24xxcam_reg_in(base, CAMDMA_CCR(dmach)) & CAMDMA_CCR_ENABLE;
+}
+
+static void omap24xxcam_dmahw_transfer_setup(void __iomem *base, int dmach,
+					     dma_addr_t start, u32 len)
+{
+	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
+			    CAMDMA_CCR_SEL_SRC_DST_SYNC
+			    | CAMDMA_CCR_BS
+			    | CAMDMA_CCR_DST_AMODE_POST_INC
+			    | CAMDMA_CCR_SRC_AMODE_POST_INC
+			    | CAMDMA_CCR_FS
+			    | CAMDMA_CCR_WR_ACTIVE
+			    | CAMDMA_CCR_RD_ACTIVE
+			    | CAMDMA_CCR_SYNCHRO_CAMERA);
+	omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(dmach), 0);
+	omap24xxcam_reg_out(base, CAMDMA_CEN(dmach), len);
+	omap24xxcam_reg_out(base, CAMDMA_CFN(dmach), 1);
+	omap24xxcam_reg_out(base, CAMDMA_CSDP(dmach),
+			    CAMDMA_CSDP_WRITE_MODE_POSTED
+			    | CAMDMA_CSDP_DST_BURST_EN_32
+			    | CAMDMA_CSDP_DST_PACKED
+			    | CAMDMA_CSDP_SRC_BURST_EN_32
+			    | CAMDMA_CSDP_SRC_PACKED
+			    | CAMDMA_CSDP_DATA_TYPE_8BITS);
+	omap24xxcam_reg_out(base, CAMDMA_CSSA(dmach), 0);
+	omap24xxcam_reg_out(base, CAMDMA_CDSA(dmach), start);
+	omap24xxcam_reg_out(base, CAMDMA_CSEI(dmach), 0);
+	omap24xxcam_reg_out(base, CAMDMA_CSFI(dmach), DMA_THRESHOLD);
+	omap24xxcam_reg_out(base, CAMDMA_CDEI(dmach), 0);
+	omap24xxcam_reg_out(base, CAMDMA_CDFI(dmach), 0);
+	omap24xxcam_reg_out(base, CAMDMA_CSR(dmach),
+			    CAMDMA_CSR_MISALIGNED_ERR
+			    | CAMDMA_CSR_SECURE_ERR
+			    | CAMDMA_CSR_TRANS_ERR
+			    | CAMDMA_CSR_BLOCK
+			    | CAMDMA_CSR_DROP);
+	omap24xxcam_reg_out(base, CAMDMA_CICR(dmach),
+			    CAMDMA_CICR_MISALIGNED_ERR_IE
+			    | CAMDMA_CICR_SECURE_ERR_IE
+			    | CAMDMA_CICR_TRANS_ERR_IE
+			    | CAMDMA_CICR_BLOCK_IE
+			    | CAMDMA_CICR_DROP_IE);
+}
+
+static void omap24xxcam_dmahw_transfer_start(void __iomem *base, int dmach)
+{
+	omap24xxcam_reg_out(base, CAMDMA_CCR(dmach),
+			    CAMDMA_CCR_SEL_SRC_DST_SYNC
+			    | CAMDMA_CCR_BS
+			    | CAMDMA_CCR_DST_AMODE_POST_INC
+			    | CAMDMA_CCR_SRC_AMODE_POST_INC
+			    | CAMDMA_CCR_ENABLE
+			    | CAMDMA_CCR_FS
+			    | CAMDMA_CCR_SYNCHRO_CAMERA);
+}
+
+static void omap24xxcam_dmahw_transfer_chain(void __iomem *base, int dmach,
+					     int free_dmach)
+{
+	int prev_dmach, ch;
+
+	if (dmach == 0)
+		prev_dmach = NUM_CAMDMA_CHANNELS - 1;
+	else
+		prev_dmach = dmach - 1;
+	omap24xxcam_reg_out(base, CAMDMA_CLNK_CTRL(prev_dmach),
+			    CAMDMA_CLNK_CTRL_ENABLE_LNK | dmach);
+	/* Did we chain the DMA transfer before the previous one
+	 * finished?
+	 */
+	ch = (dmach + free_dmach) % NUM_CAMDMA_CHANNELS;
+	while (!(omap24xxcam_reg_in(base, CAMDMA_CCR(ch))
+		 & CAMDMA_CCR_ENABLE)) {
+		if (ch == dmach) {
+			/* The previous transfer has ended and this one
+			 * hasn't started, so we must not have chained
+			 * to the previous one in time.  We'll have to
+			 * start it now.
+			 */
+			omap24xxcam_dmahw_transfer_start(base, dmach);
+			break;
+		} else
+			ch = (ch + 1) % NUM_CAMDMA_CHANNELS;
+	}
+}
+
+/* Abort all chained DMA transfers. After all transfers have been
+ * aborted and the DMA controller is idle, the completion routines for
+ * any aborted transfers will be called in sequence. The DMA
+ * controller may not be idle after this routine completes, because
+ * the completion routines might start new transfers.
+ */
+static void omap24xxcam_dmahw_abort_ch(void __iomem *base, int dmach)
+{
+	/* mask all interrupts from this channel */
+	omap24xxcam_reg_out(base, CAMDMA_CICR(dmach), 0);
+	/* unlink this channel */
+	omap24xxcam_reg_merge(base, CAMDMA_CLNK_CTRL(dmach), 0,
+			      CAMDMA_CLNK_CTRL_ENABLE_LNK);
+	/* disable this channel */
+	omap24xxcam_reg_merge(base, CAMDMA_CCR(dmach), 0, CAMDMA_CCR_ENABLE);
+}
+
+static void omap24xxcam_dmahw_init(void __iomem *base)
+{
+	omap24xxcam_reg_out(base, CAMDMA_OCP_SYSCONFIG,
+			    CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY
+			    | CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE
+			    | CAMDMA_OCP_SYSCONFIG_AUTOIDLE);
+
+	omap24xxcam_reg_merge(base, CAMDMA_GCR, 0x10,
+			      CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH);
+
+	omap24xxcam_reg_out(base, CAMDMA_IRQENABLE_L0, 0xf);
+}
+
+/*
+ *
+ * Individual DMA channel handling.
+ *
+ */
+
+/* Start a DMA transfer from the camera to memory.
+ * Returns zero if the transfer was successfully started, or non-zero if all
+ * DMA channels are already in use or starting is currently inhibited.
+ */
+static int omap24xxcam_dma_start(struct omap24xxcam_dma *dma, dma_addr_t start,
+				 u32 len, dma_callback_t callback, void *arg)
+{
+	unsigned long flags;
+	int dmach;
+
+	spin_lock_irqsave(&dma->lock, flags);
+
+	if (!dma->free_dmach || atomic_read(&dma->dma_stop)) {
+		spin_unlock_irqrestore(&dma->lock, flags);
+		return -EBUSY;
+	}
+
+	dmach = dma->next_dmach;
+
+	dma->ch_state[dmach].callback = callback;
+	dma->ch_state[dmach].arg = arg;
+
+	omap24xxcam_dmahw_transfer_setup(dma->base, dmach, start, len);
+
+	/* We're ready to start the DMA transfer. */
+
+	if (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
+		/* A transfer is already in progress, so try to chain to it. */
+		omap24xxcam_dmahw_transfer_chain(dma->base, dmach,
+						 dma->free_dmach);
+	} else {
+		/* No transfer is in progress, so we'll just start this one
+		 * now.
+		 */
+		omap24xxcam_dmahw_transfer_start(dma->base, dmach);
+	}
+
+	dma->next_dmach = (dma->next_dmach + 1) % NUM_CAMDMA_CHANNELS;
+	dma->free_dmach--;
+
+	spin_unlock_irqrestore(&dma->lock, flags);
+
+	return 0;
+}
+
+/* Abort all chained DMA transfers. After all transfers have been
+ * aborted and the DMA controller is idle, the completion routines for
+ * any aborted transfers will be called in sequence. The DMA
+ * controller may not be idle after this routine completes, because
+ * the completion routines might start new transfers.
+ */
+static void omap24xxcam_dma_abort(struct omap24xxcam_dma *dma, u32 csr)
+{
+	unsigned long flags;
+	int dmach, i, free_dmach;
+	dma_callback_t callback;
+	void *arg;
+
+	spin_lock_irqsave(&dma->lock, flags);
+
+	/* stop any DMA transfers in progress */
+	dmach = (dma->next_dmach + dma->free_dmach) % NUM_CAMDMA_CHANNELS;
+	for (i = 0; i < NUM_CAMDMA_CHANNELS; i++) {
+		omap24xxcam_dmahw_abort_ch(dma->base, dmach);
+		dmach = (dmach + 1) % NUM_CAMDMA_CHANNELS;
+	}
+
+	/* We have to be careful here because the callback routine
+	 * might start a new DMA transfer, and we only want to abort
+	 * transfers that were started before this routine was called.
+	 */
+	free_dmach = dma->free_dmach;
+	while ((dma->free_dmach < NUM_CAMDMA_CHANNELS) &&
+	       (free_dmach < NUM_CAMDMA_CHANNELS)) {
+		dmach = (dma->next_dmach + dma->free_dmach)
+			% NUM_CAMDMA_CHANNELS;
+		callback = dma->ch_state[dmach].callback;
+		arg = dma->ch_state[dmach].arg;
+		dma->free_dmach++;
+		free_dmach++;
+		if (callback) {
+			/* leave interrupts disabled during callback */
+			spin_unlock(&dma->lock);
+			(*callback) (dma, csr, arg);
+			spin_lock(&dma->lock);
+		}
+	}
+
+	spin_unlock_irqrestore(&dma->lock, flags);
+}
+
+/* Abort all chained DMA transfers. After all transfers have been
+ * aborted and the DMA controller is idle, the completion routines for
+ * any aborted transfers will be called in sequence. If the completion
+ * routines attempt to start a new DMA transfer it will fail, so the
+ * DMA controller will be idle after this routine completes.
+ */
+static void omap24xxcam_dma_stop(struct omap24xxcam_dma *dma, u32 csr)
+{
+	atomic_inc(&dma->dma_stop);
+	omap24xxcam_dma_abort(dma, csr);
+	atomic_dec(&dma->dma_stop);
+}
+
+/* Camera DMA interrupt service routine. */
+void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma)
+{
+	int dmach;
+	dma_callback_t callback;
+	void *arg;
+	u32 csr;
+	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
+		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
+		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
+
+	spin_lock(&dma->lock);
+
+	if (dma->free_dmach == NUM_CAMDMA_CHANNELS) {
+		/* A camera DMA interrupt occurred while all channels
+		 * are idle, so we'll acknowledge the interrupt in the
+		 * IRQSTATUS register and exit.
+		 */
+		omap24xxcam_dmahw_ack_all(dma->base);
+		spin_unlock(&dma->lock);
+		return;
+	}
+
+	while (dma->free_dmach < NUM_CAMDMA_CHANNELS) {
+		dmach = (dma->next_dmach + dma->free_dmach)
+			% NUM_CAMDMA_CHANNELS;
+		if (omap24xxcam_dmahw_running(dma->base, dmach)) {
+			/* This buffer hasn't finished yet, so we're done. */
+			break;
+		}
+		csr = omap24xxcam_dmahw_ack_ch(dma->base, dmach);
+		if (csr & csr_error) {
+			/* A DMA error occurred, so stop all DMA
+			 * transfers in progress.
+			 */
+			spin_unlock(&dma->lock);
+			omap24xxcam_dma_stop(dma, csr);
+			return;
+		} else {
+			callback = dma->ch_state[dmach].callback;
+			arg = dma->ch_state[dmach].arg;
+			dma->free_dmach++;
+			if (callback) {
+				spin_unlock(&dma->lock);
+				(*callback) (dma, csr, arg);
+				spin_lock(&dma->lock);
+			}
+		}
+	}
+
+	spin_unlock(&dma->lock);
+
+	omap24xxcam_sgdma_process(
+		container_of(dma, struct omap24xxcam_sgdma, dma));
+}
+
+void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dma->lock, flags);
+
+	omap24xxcam_dmahw_init(dma->base);
+
+	spin_unlock_irqrestore(&dma->lock, flags);
+}
+
+static void omap24xxcam_dma_init(struct omap24xxcam_dma *dma,
+				 void __iomem *base)
+{
+	int ch;
+
+	/* group all channels on DMA IRQ0 and unmask irq */
+	spin_lock_init(&dma->lock);
+	dma->base = base;
+	dma->free_dmach = NUM_CAMDMA_CHANNELS;
+	dma->next_dmach = 0;
+	for (ch = 0; ch < NUM_CAMDMA_CHANNELS; ch++) {
+		dma->ch_state[ch].callback = NULL;
+		dma->ch_state[ch].arg = NULL;
+	}
+}
+
+/*
+ *
+ * Scatter-gather DMA.
+ *
+ * High-level DMA construct for transferring whole picture frames to
+ * memory that is discontinuous.
+ *
+ */
+
+/* DMA completion routine for the scatter-gather DMA fragments. */
+static void omap24xxcam_sgdma_callback(struct omap24xxcam_dma *dma, u32 csr,
+				       void *arg)
+{
+	struct omap24xxcam_sgdma *sgdma =
+		container_of(dma, struct omap24xxcam_sgdma, dma);
+	int sgslot = (int)arg;
+	struct sgdma_state *sg_state;
+	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
+		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
+		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
+
+	spin_lock(&sgdma->lock);
+
+	/* We got an interrupt, we can remove the timer */
+	del_timer(&sgdma->reset_timer);
+
+	sg_state = sgdma->sg_state + sgslot;
+	if (!sg_state->queued_sglist) {
+		spin_unlock(&sgdma->lock);
+		printk(KERN_ERR "%s: sgdma completed when none queued!\n",
+		       __func__);
+		return;
+	}
+
+	sg_state->csr |= csr;
+	if (!--sg_state->queued_sglist) {
+		/* Queue for this sglist is empty, so check to see if we're
+		 * done.
+		 */
+		if ((sg_state->next_sglist == sg_state->sglen)
+		    || (sg_state->csr & csr_error)) {
+			sgdma_callback_t callback = sg_state->callback;
+			void *arg = sg_state->arg;
+			u32 sg_csr = sg_state->csr;
+			/* All done with this sglist */
+			sgdma->free_sgdma++;
+			if (callback) {
+				spin_unlock(&sgdma->lock);
+				(*callback) (sgdma, sg_csr, arg);
+				return;
+			}
+		}
+	}
+
+	spin_unlock(&sgdma->lock);
+}
+
+/* Start queued scatter-gather DMA transfers. */
+void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma)
+{
+	unsigned long flags;
+	int queued_sgdma, sgslot;
+	struct sgdma_state *sg_state;
+	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
+		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
+		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
+
+	spin_lock_irqsave(&sgdma->lock, flags);
+
+	queued_sgdma = NUM_SG_DMA - sgdma->free_sgdma;
+	sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
+	while (queued_sgdma > 0) {
+		sg_state = sgdma->sg_state + sgslot;
+		while ((sg_state->next_sglist < sg_state->sglen) &&
+		       !(sg_state->csr & csr_error)) {
+			const struct scatterlist *sglist;
+			unsigned int len;
+
+			sglist = sg_state->sglist + sg_state->next_sglist;
+			/* try to start the next DMA transfer */
+			if (sg_state->next_sglist + 1 == sg_state->sglen) {
+				/*
+				 *  On the last sg, we handle the case where
+				 *  cam->img.pix.sizeimage % PAGE_ALIGN != 0
+				 */
+				len = sg_state->len - sg_state->bytes_read;
+			} else {
+				len = sg_dma_len(sglist);
+			}
+
+			if (omap24xxcam_dma_start(&sgdma->dma,
+						  sg_dma_address(sglist),
+						  len,
+						  omap24xxcam_sgdma_callback,
+						  (void *)sgslot)) {
+				/* DMA start failed */
+				spin_unlock_irqrestore(&sgdma->lock, flags);
+				return;
+			} else {
+				unsigned long expires;
+				/* DMA start was successful */
+				sg_state->next_sglist++;
+				sg_state->bytes_read += len;
+				sg_state->queued_sglist++;
+
+				/* We start the reset timer */
+				expires = jiffies + HZ;
+				mod_timer(&sgdma->reset_timer, expires);
+			}
+		}
+		queued_sgdma--;
+		sgslot = (sgslot + 1) % NUM_SG_DMA;
+	}
+
+	spin_unlock_irqrestore(&sgdma->lock, flags);
+}
+
+/*
+ * Queue a scatter-gather DMA transfer from the camera to memory.
+ * Returns zero if the transfer was successfully queued, or non-zero
+ * if all of the scatter-gather slots are already in use.
+ */
+int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
+			    const struct scatterlist *sglist, int sglen,
+			    int len, sgdma_callback_t callback, void *arg)
+{
+	unsigned long flags;
+	struct sgdma_state *sg_state;
+
+	if ((sglen < 0) || ((sglen > 0) && !sglist))
+		return -EINVAL;
+
+	spin_lock_irqsave(&sgdma->lock, flags);
+
+	if (!sgdma->free_sgdma) {
+		spin_unlock_irqrestore(&sgdma->lock, flags);
+		return -EBUSY;
+	}
+
+	sg_state = sgdma->sg_state + sgdma->next_sgdma;
+
+	sg_state->sglist = sglist;
+	sg_state->sglen = sglen;
+	sg_state->next_sglist = 0;
+	sg_state->bytes_read = 0;
+	sg_state->len = len;
+	sg_state->queued_sglist = 0;
+	sg_state->csr = 0;
+	sg_state->callback = callback;
+	sg_state->arg = arg;
+
+	sgdma->next_sgdma = (sgdma->next_sgdma + 1) % NUM_SG_DMA;
+	sgdma->free_sgdma--;
+
+	spin_unlock_irqrestore(&sgdma->lock, flags);
+
+	omap24xxcam_sgdma_process(sgdma);
+
+	return 0;
+}
+
+/* Sync scatter-gather DMA by aborting any DMA transfers currently in progress.
+ * Any queued scatter-gather DMA transactions that have not yet been started
+ * will remain queued.  The DMA controller will be idle after this routine
+ * completes.  When the scatter-gather queue is restarted, the next
+ * scatter-gather DMA transfer will begin at the start of a new transaction.
+ */
+void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma)
+{
+	unsigned long flags;
+	int sgslot;
+	struct sgdma_state *sg_state;
+	u32 csr = CAMDMA_CSR_TRANS_ERR;
+
+	/* stop any DMA transfers in progress */
+	omap24xxcam_dma_stop(&sgdma->dma, csr);
+
+	spin_lock_irqsave(&sgdma->lock, flags);
+
+	if (sgdma->free_sgdma < NUM_SG_DMA) {
+		sgslot = (sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
+		sg_state = sgdma->sg_state + sgslot;
+		if (sg_state->next_sglist != 0) {
+			/* This DMA transfer was in progress, so abort it. */
+			sgdma_callback_t callback = sg_state->callback;
+			void *arg = sg_state->arg;
+			sgdma->free_sgdma++;
+			if (callback) {
+				/* leave interrupts masked */
+				spin_unlock(&sgdma->lock);
+				(*callback) (sgdma, csr, arg);
+				spin_lock(&sgdma->lock);
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&sgdma->lock, flags);
+}
+
+void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
+			    void __iomem *base,
+			    void (*reset_callback)(unsigned long data),
+			    unsigned long reset_callback_data)
+{
+	int sg;
+
+	spin_lock_init(&sgdma->lock);
+	sgdma->free_sgdma = NUM_SG_DMA;
+	sgdma->next_sgdma = 0;
+	for (sg = 0; sg < NUM_SG_DMA; sg++) {
+		sgdma->sg_state[sg].sglen = 0;
+		sgdma->sg_state[sg].next_sglist = 0;
+		sgdma->sg_state[sg].bytes_read = 0;
+		sgdma->sg_state[sg].queued_sglist = 0;
+		sgdma->sg_state[sg].csr = 0;
+		sgdma->sg_state[sg].callback = NULL;
+		sgdma->sg_state[sg].arg = NULL;
+	}
+
+	omap24xxcam_dma_init(&sgdma->dma, base);
+	setup_timer(&sgdma->reset_timer, reset_callback, reset_callback_data);
+}
diff --git a/drivers/staging/media/omap24xx/omap24xxcam.c b/drivers/staging/media/omap24xx/omap24xxcam.c
new file mode 100644
index 0000000..d2b440c
--- /dev/null
+++ b/drivers/staging/media/omap24xx/omap24xxcam.c
@@ -0,0 +1,1888 @@
+/*
+ * drivers/media/platform/omap24xxcam.c
+ *
+ * OMAP 2 camera block driver.
+ *
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2004 Texas Instruments.
+ * Copyright (C) 2007-2008 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * Based on code from Andy Lowe <source@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/videodev2.h>
+#include <linux/pci.h>		/* needed for videobufs */
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+#include "omap24xxcam.h"
+
+#define OMAP24XXCAM_VERSION "0.0.1"
+
+#define RESET_TIMEOUT_NS 10000
+
+static void omap24xxcam_reset(struct omap24xxcam_device *cam);
+static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam);
+static void omap24xxcam_device_unregister(struct v4l2_int_device *s);
+static int omap24xxcam_remove(struct platform_device *pdev);
+
+/* module parameters */
+static int video_nr = -1;	/* video device minor (-1 ==> auto assign) */
+/*
+ * Maximum amount of memory to use for capture buffers.
+ * Default is 4800KB, enough to double-buffer SXGA.
+ */
+static int capture_mem = 1280 * 960 * 2 * 2;
+
+static struct v4l2_int_device omap24xxcam;
+
+/*
+ *
+ * Clocks.
+ *
+ */
+
+static void omap24xxcam_clock_put(struct omap24xxcam_device *cam)
+{
+	if (cam->ick != NULL && !IS_ERR(cam->ick))
+		clk_put(cam->ick);
+	if (cam->fck != NULL && !IS_ERR(cam->fck))
+		clk_put(cam->fck);
+
+	cam->ick = cam->fck = NULL;
+}
+
+static int omap24xxcam_clock_get(struct omap24xxcam_device *cam)
+{
+	int rval = 0;
+
+	cam->fck = clk_get(cam->dev, "fck");
+	if (IS_ERR(cam->fck)) {
+		dev_err(cam->dev, "can't get camera fck");
+		rval = PTR_ERR(cam->fck);
+		omap24xxcam_clock_put(cam);
+		return rval;
+	}
+
+	cam->ick = clk_get(cam->dev, "ick");
+	if (IS_ERR(cam->ick)) {
+		dev_err(cam->dev, "can't get camera ick");
+		rval = PTR_ERR(cam->ick);
+		omap24xxcam_clock_put(cam);
+	}
+
+	return rval;
+}
+
+static void omap24xxcam_clock_on(struct omap24xxcam_device *cam)
+{
+	clk_enable(cam->fck);
+	clk_enable(cam->ick);
+}
+
+static void omap24xxcam_clock_off(struct omap24xxcam_device *cam)
+{
+	clk_disable(cam->fck);
+	clk_disable(cam->ick);
+}
+
+/*
+ *
+ * Camera core
+ *
+ */
+
+/*
+ * Set xclk.
+ *
+ * To disable xclk, use value zero.
+ */
+static void omap24xxcam_core_xclk_set(const struct omap24xxcam_device *cam,
+				      u32 xclk)
+{
+	if (xclk) {
+		u32 divisor = CAM_MCLK / xclk;
+
+		if (divisor == 1)
+			omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
+					    CC_CTRL_XCLK,
+					    CC_CTRL_XCLK_DIV_BYPASS);
+		else
+			omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
+					    CC_CTRL_XCLK, divisor);
+	} else
+		omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET,
+				    CC_CTRL_XCLK, CC_CTRL_XCLK_DIV_STABLE_LOW);
+}
+
+static void omap24xxcam_core_hwinit(const struct omap24xxcam_device *cam)
+{
+	/*
+	 * Setting the camera core AUTOIDLE bit causes problems with frame
+	 * synchronization, so we will clear the AUTOIDLE bit instead.
+	 */
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_SYSCONFIG,
+			    CC_SYSCONFIG_AUTOIDLE);
+
+	/* program the camera interface DMA packet size */
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL_DMA,
+			    CC_CTRL_DMA_EN | (DMA_THRESHOLD / 4 - 1));
+
+	/* enable camera core error interrupts */
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQENABLE,
+			    CC_IRQENABLE_FW_ERR_IRQ
+			    | CC_IRQENABLE_FSC_ERR_IRQ
+			    | CC_IRQENABLE_SSC_ERR_IRQ
+			    | CC_IRQENABLE_FIFO_OF_IRQ);
+}
+
+/*
+ * Enable the camera core.
+ *
+ * Data transfer to the camera DMA starts from next starting frame.
+ */
+static void omap24xxcam_core_enable(const struct omap24xxcam_device *cam)
+{
+
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
+			    cam->cc_ctrl);
+}
+
+/*
+ * Disable camera core.
+ *
+ * The data transfer will be stopped immediately (CC_CTRL_CC_RST). The
+ * core internal state machines will be reset. Use
+ * CC_CTRL_CC_FRAME_TRIG instead if you want to transfer the current
+ * frame completely.
+ */
+static void omap24xxcam_core_disable(const struct omap24xxcam_device *cam)
+{
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_CTRL,
+			    CC_CTRL_CC_RST);
+}
+
+/* Interrupt service routine for camera core interrupts. */
+static void omap24xxcam_core_isr(struct omap24xxcam_device *cam)
+{
+	u32 cc_irqstatus;
+	const u32 cc_irqstatus_err =
+		CC_IRQSTATUS_FW_ERR_IRQ
+		| CC_IRQSTATUS_FSC_ERR_IRQ
+		| CC_IRQSTATUS_SSC_ERR_IRQ
+		| CC_IRQSTATUS_FIFO_UF_IRQ
+		| CC_IRQSTATUS_FIFO_OF_IRQ;
+
+	cc_irqstatus = omap24xxcam_reg_in(cam->mmio_base + CC_REG_OFFSET,
+					  CC_IRQSTATUS);
+	omap24xxcam_reg_out(cam->mmio_base + CC_REG_OFFSET, CC_IRQSTATUS,
+			    cc_irqstatus);
+
+	if (cc_irqstatus & cc_irqstatus_err
+	    && !atomic_read(&cam->in_reset)) {
+		dev_dbg(cam->dev, "resetting camera, cc_irqstatus 0x%x\n",
+			cc_irqstatus);
+		omap24xxcam_reset(cam);
+	}
+}
+
+/*
+ *
+ * videobuf_buffer handling.
+ *
+ * Memory for mmapped videobuf_buffers is not allocated
+ * conventionally, but by several kmalloc allocations and then
+ * creating the scatterlist on our own. User-space buffers are handled
+ * normally.
+ *
+ */
+
+/*
+ * Free the memory-mapped buffer memory allocated for a
+ * videobuf_buffer and the associated scatterlist.
+ */
+static void omap24xxcam_vbq_free_mmap_buffer(struct videobuf_buffer *vb)
+{
+	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+	size_t alloc_size;
+	struct page *page;
+	int i;
+
+	if (dma->sglist == NULL)
+		return;
+
+	i = dma->sglen;
+	while (i) {
+		i--;
+		alloc_size = sg_dma_len(&dma->sglist[i]);
+		page = sg_page(&dma->sglist[i]);
+		do {
+			ClearPageReserved(page++);
+		} while (alloc_size -= PAGE_SIZE);
+		__free_pages(sg_page(&dma->sglist[i]),
+			     get_order(sg_dma_len(&dma->sglist[i])));
+	}
+
+	kfree(dma->sglist);
+	dma->sglist = NULL;
+}
+
+/* Release all memory related to the videobuf_queue. */
+static void omap24xxcam_vbq_free_mmap_buffers(struct videobuf_queue *vbq)
+{
+	int i;
+
+	mutex_lock(&vbq->vb_lock);
+
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+		if (NULL == vbq->bufs[i])
+			continue;
+		if (V4L2_MEMORY_MMAP != vbq->bufs[i]->memory)
+			continue;
+		vbq->ops->buf_release(vbq, vbq->bufs[i]);
+		omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
+		kfree(vbq->bufs[i]);
+		vbq->bufs[i] = NULL;
+	}
+
+	mutex_unlock(&vbq->vb_lock);
+
+	videobuf_mmap_free(vbq);
+}
+
+/*
+ * Allocate physically as contiguous as possible buffer for video
+ * frame and allocate and build DMA scatter-gather list for it.
+ */
+static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
+{
+	unsigned int order;
+	size_t alloc_size, size = vb->bsize; /* vb->bsize is page aligned */
+	struct page *page;
+	int max_pages, err = 0, i = 0;
+	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+
+	/*
+	 * allocate maximum size scatter-gather list. Note this is
+	 * overhead. We may not use as many entries as we allocate
+	 */
+	max_pages = vb->bsize >> PAGE_SHIFT;
+	dma->sglist = kcalloc(max_pages, sizeof(*dma->sglist), GFP_KERNEL);
+	if (dma->sglist == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	while (size) {
+		order = get_order(size);
+		/*
+		 * do not over-allocate even if we would get larger
+		 * contiguous chunk that way
+		 */
+		if ((PAGE_SIZE << order) > size)
+			order--;
+
+		/* try to allocate as many contiguous pages as possible */
+		page = alloc_pages(GFP_KERNEL, order);
+		/* if allocation fails, try to allocate smaller amount */
+		while (page == NULL) {
+			order--;
+			page = alloc_pages(GFP_KERNEL, order);
+			if (page == NULL && !order) {
+				err = -ENOMEM;
+				goto out;
+			}
+		}
+		size -= (PAGE_SIZE << order);
+
+		/* append allocated chunk of pages into scatter-gather list */
+		sg_set_page(&dma->sglist[i], page, PAGE_SIZE << order, 0);
+		dma->sglen++;
+		i++;
+
+		alloc_size = (PAGE_SIZE << order);
+
+		/* clear pages before giving them to user space */
+		memset(page_address(page), 0, alloc_size);
+
+		/* mark allocated pages reserved */
+		do {
+			SetPageReserved(page++);
+		} while (alloc_size -= PAGE_SIZE);
+	}
+	/*
+	 * REVISIT: not fully correct to assign nr_pages == sglen but
+	 * video-buf is passing nr_pages for e.g. unmap_sg calls
+	 */
+	dma->nr_pages = dma->sglen;
+	dma->direction = PCI_DMA_FROMDEVICE;
+
+	return 0;
+
+out:
+	omap24xxcam_vbq_free_mmap_buffer(vb);
+	return err;
+}
+
+static int omap24xxcam_vbq_alloc_mmap_buffers(struct videobuf_queue *vbq,
+					      unsigned int count)
+{
+	int i, err = 0;
+	struct omap24xxcam_fh *fh =
+		container_of(vbq, struct omap24xxcam_fh, vbq);
+
+	mutex_lock(&vbq->vb_lock);
+
+	for (i = 0; i < count; i++) {
+		err = omap24xxcam_vbq_alloc_mmap_buffer(vbq->bufs[i]);
+		if (err)
+			goto out;
+		dev_dbg(fh->cam->dev, "sglen is %d for buffer %d\n",
+			videobuf_to_dma(vbq->bufs[i])->sglen, i);
+	}
+
+	mutex_unlock(&vbq->vb_lock);
+
+	return 0;
+out:
+	while (i) {
+		i--;
+		omap24xxcam_vbq_free_mmap_buffer(vbq->bufs[i]);
+	}
+
+	mutex_unlock(&vbq->vb_lock);
+
+	return err;
+}
+
+/*
+ * This routine is called from interrupt context when a scatter-gather DMA
+ * transfer of a videobuf_buffer completes.
+ */
+static void omap24xxcam_vbq_complete(struct omap24xxcam_sgdma *sgdma,
+				     u32 csr, void *arg)
+{
+	struct omap24xxcam_device *cam =
+		container_of(sgdma, struct omap24xxcam_device, sgdma);
+	struct omap24xxcam_fh *fh = cam->streaming->private_data;
+	struct videobuf_buffer *vb = (struct videobuf_buffer *)arg;
+	const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
+		| CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
+		| CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
+	if (--cam->sgdma_in_queue == 0)
+		omap24xxcam_core_disable(cam);
+	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
+
+	v4l2_get_timestamp(&vb->ts);
+	vb->field_count = atomic_add_return(2, &fh->field_count);
+	if (csr & csr_error) {
+		vb->state = VIDEOBUF_ERROR;
+		if (!atomic_read(&fh->cam->in_reset)) {
+			dev_dbg(cam->dev, "resetting camera, csr 0x%x\n", csr);
+			omap24xxcam_reset(cam);
+		}
+	} else
+		vb->state = VIDEOBUF_DONE;
+	wake_up(&vb->done);
+}
+
+static void omap24xxcam_vbq_release(struct videobuf_queue *vbq,
+				    struct videobuf_buffer *vb)
+{
+	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+
+	/* wait for buffer, especially to get out of the sgdma queue */
+	videobuf_waiton(vbq, vb, 0, 0);
+	if (vb->memory == V4L2_MEMORY_MMAP) {
+		dma_unmap_sg(vbq->dev, dma->sglist, dma->sglen,
+			     dma->direction);
+		dma->direction = DMA_NONE;
+	} else {
+		videobuf_dma_unmap(vbq->dev, videobuf_to_dma(vb));
+		videobuf_dma_free(videobuf_to_dma(vb));
+	}
+
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+/*
+ * Limit the number of available kernel image capture buffers based on the
+ * number requested, the currently selected image size, and the maximum
+ * amount of memory permitted for kernel capture buffers.
+ */
+static int omap24xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
+				 unsigned int *size)
+{
+	struct omap24xxcam_fh *fh = vbq->priv_data;
+
+	if (*cnt <= 0)
+		*cnt = VIDEO_MAX_FRAME;	/* supply a default number of buffers */
+
+	if (*cnt > VIDEO_MAX_FRAME)
+		*cnt = VIDEO_MAX_FRAME;
+
+	*size = fh->pix.sizeimage;
+
+	/* accessing fh->cam->capture_mem is ok, it's constant */
+	if (*size * *cnt > fh->cam->capture_mem)
+		*cnt = fh->cam->capture_mem / *size;
+
+	return 0;
+}
+
+static int omap24xxcam_dma_iolock(struct videobuf_queue *vbq,
+				  struct videobuf_dmabuf *dma)
+{
+	int err = 0;
+
+	dma->direction = PCI_DMA_FROMDEVICE;
+	if (!dma_map_sg(vbq->dev, dma->sglist, dma->sglen, dma->direction)) {
+		kfree(dma->sglist);
+		dma->sglist = NULL;
+		dma->sglen = 0;
+		err = -EIO;
+	}
+
+	return err;
+}
+
+static int omap24xxcam_vbq_prepare(struct videobuf_queue *vbq,
+				   struct videobuf_buffer *vb,
+				   enum v4l2_field field)
+{
+	struct omap24xxcam_fh *fh = vbq->priv_data;
+	int err = 0;
+
+	/*
+	 * Accessing pix here is okay since it's constant while
+	 * streaming is on (and we only get called then).
+	 */
+	if (vb->baddr) {
+		/* This is a userspace buffer. */
+		if (fh->pix.sizeimage > vb->bsize) {
+			/* The buffer isn't big enough. */
+			err = -EINVAL;
+		} else
+			vb->size = fh->pix.sizeimage;
+	} else {
+		if (vb->state != VIDEOBUF_NEEDS_INIT) {
+			/*
+			 * We have a kernel bounce buffer that has
+			 * already been allocated.
+			 */
+			if (fh->pix.sizeimage > vb->size) {
+				/*
+				 * The image size has been changed to
+				 * a larger size since this buffer was
+				 * allocated, so we need to free and
+				 * reallocate it.
+				 */
+				omap24xxcam_vbq_release(vbq, vb);
+				vb->size = fh->pix.sizeimage;
+			}
+		} else {
+			/* We need to allocate a new kernel bounce buffer. */
+			vb->size = fh->pix.sizeimage;
+		}
+	}
+
+	if (err)
+		return err;
+
+	vb->width = fh->pix.width;
+	vb->height = fh->pix.height;
+	vb->field = field;
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		if (vb->memory == V4L2_MEMORY_MMAP)
+			/*
+			 * we have built the scatter-gather list by ourself so
+			 * do the scatter-gather mapping as well
+			 */
+			err = omap24xxcam_dma_iolock(vbq, videobuf_to_dma(vb));
+		else
+			err = videobuf_iolock(vbq, vb, NULL);
+	}
+
+	if (!err)
+		vb->state = VIDEOBUF_PREPARED;
+	else
+		omap24xxcam_vbq_release(vbq, vb);
+
+	return err;
+}
+
+static void omap24xxcam_vbq_queue(struct videobuf_queue *vbq,
+				  struct videobuf_buffer *vb)
+{
+	struct omap24xxcam_fh *fh = vbq->priv_data;
+	struct omap24xxcam_device *cam = fh->cam;
+	enum videobuf_state state = vb->state;
+	unsigned long flags;
+	int err;
+
+	/*
+	 * FIXME: We're marking the buffer active since we have no
+	 * pretty way of marking it active exactly when the
+	 * scatter-gather transfer starts.
+	 */
+	vb->state = VIDEOBUF_ACTIVE;
+
+	err = omap24xxcam_sgdma_queue(&fh->cam->sgdma,
+				      videobuf_to_dma(vb)->sglist,
+				      videobuf_to_dma(vb)->sglen, vb->size,
+				      omap24xxcam_vbq_complete, vb);
+
+	if (!err) {
+		spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
+		if (++cam->sgdma_in_queue == 1
+		    && !atomic_read(&cam->in_reset))
+			omap24xxcam_core_enable(cam);
+		spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
+	} else {
+		/*
+		 * Oops. We're not supposed to get any errors here.
+		 * The only way we could get an error is if we ran out
+		 * of scatter-gather DMA slots, but we are supposed to
+		 * have at least as many scatter-gather DMA slots as
+		 * video buffers so that can't happen.
+		 */
+		dev_err(cam->dev, "failed to queue a video buffer for dma!\n");
+		dev_err(cam->dev, "likely a bug in the driver!\n");
+		vb->state = state;
+	}
+}
+
+static struct videobuf_queue_ops omap24xxcam_vbq_ops = {
+	.buf_setup   = omap24xxcam_vbq_setup,
+	.buf_prepare = omap24xxcam_vbq_prepare,
+	.buf_queue   = omap24xxcam_vbq_queue,
+	.buf_release = omap24xxcam_vbq_release,
+};
+
+/*
+ *
+ * OMAP main camera system
+ *
+ */
+
+/*
+ * Reset camera block to power-on state.
+ */
+static void omap24xxcam_poweron_reset(struct omap24xxcam_device *cam)
+{
+	int max_loop = RESET_TIMEOUT_NS;
+
+	/* Reset whole camera subsystem */
+	omap24xxcam_reg_out(cam->mmio_base,
+			    CAM_SYSCONFIG,
+			    CAM_SYSCONFIG_SOFTRESET);
+
+	/* Wait till it's finished */
+	while (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
+		 & CAM_SYSSTATUS_RESETDONE)
+	       && --max_loop) {
+		ndelay(1);
+	}
+
+	if (!(omap24xxcam_reg_in(cam->mmio_base, CAM_SYSSTATUS)
+	      & CAM_SYSSTATUS_RESETDONE))
+		dev_err(cam->dev, "camera soft reset timeout\n");
+}
+
+/*
+ * (Re)initialise the camera block.
+ */
+static void omap24xxcam_hwinit(struct omap24xxcam_device *cam)
+{
+	omap24xxcam_poweron_reset(cam);
+
+	/* set the camera subsystem autoidle bit */
+	omap24xxcam_reg_out(cam->mmio_base, CAM_SYSCONFIG,
+			    CAM_SYSCONFIG_AUTOIDLE);
+
+	/* set the camera MMU autoidle bit */
+	omap24xxcam_reg_out(cam->mmio_base,
+			    CAMMMU_REG_OFFSET + CAMMMU_SYSCONFIG,
+			    CAMMMU_SYSCONFIG_AUTOIDLE);
+
+	omap24xxcam_core_hwinit(cam);
+
+	omap24xxcam_dma_hwinit(&cam->sgdma.dma);
+}
+
+/*
+ * Callback for dma transfer stalling.
+ */
+static void omap24xxcam_stalled_dma_reset(unsigned long data)
+{
+	struct omap24xxcam_device *cam = (struct omap24xxcam_device *)data;
+
+	if (!atomic_read(&cam->in_reset)) {
+		dev_dbg(cam->dev, "dma stalled, resetting camera\n");
+		omap24xxcam_reset(cam);
+	}
+}
+
+/*
+ * Stop capture. Mark we're doing a reset, stop DMA transfers and
+ * core. (No new scatter-gather transfers will be queued whilst
+ * in_reset is non-zero.)
+ *
+ * If omap24xxcam_capture_stop is called from several places at
+ * once, only the first call will have an effect. Similarly, the last
+ * call omap24xxcam_streaming_cont will have effect.
+ *
+ * Serialisation is ensured by using cam->core_enable_disable_lock.
+ */
+static void omap24xxcam_capture_stop(struct omap24xxcam_device *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
+
+	if (atomic_inc_return(&cam->in_reset) != 1) {
+		spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
+		return;
+	}
+
+	omap24xxcam_core_disable(cam);
+
+	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
+
+	omap24xxcam_sgdma_sync(&cam->sgdma);
+}
+
+/*
+ * Reset and continue streaming.
+ *
+ * Note: Resetting the camera FIFO via the CC_RST bit in the CC_CTRL
+ * register is supposed to be sufficient to recover from a camera
+ * interface error, but it doesn't seem to be enough. If we only do
+ * that then subsequent image captures are out of sync by either one
+ * or two times DMA_THRESHOLD bytes. Resetting and re-initializing the
+ * entire camera subsystem prevents the problem with frame
+ * synchronization.
+ */
+static void omap24xxcam_capture_cont(struct omap24xxcam_device *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
+
+	if (atomic_read(&cam->in_reset) != 1)
+		goto out;
+
+	omap24xxcam_hwinit(cam);
+
+	omap24xxcam_sensor_if_enable(cam);
+
+	omap24xxcam_sgdma_process(&cam->sgdma);
+
+	if (cam->sgdma_in_queue)
+		omap24xxcam_core_enable(cam);
+
+out:
+	atomic_dec(&cam->in_reset);
+	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
+}
+
+static ssize_t
+omap24xxcam_streaming_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct omap24xxcam_device *cam = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", cam->streaming ?  "active" : "inactive");
+}
+static DEVICE_ATTR(streaming, S_IRUGO, omap24xxcam_streaming_show, NULL);
+
+/*
+ * Stop capture and restart it. I.e. reset the camera during use.
+ */
+static void omap24xxcam_reset(struct omap24xxcam_device *cam)
+{
+	omap24xxcam_capture_stop(cam);
+	omap24xxcam_capture_cont(cam);
+}
+
+/*
+ * The main interrupt handler.
+ */
+static irqreturn_t omap24xxcam_isr(int irq, void *arg)
+{
+	struct omap24xxcam_device *cam = (struct omap24xxcam_device *)arg;
+	u32 irqstatus;
+	unsigned int irqhandled = 0;
+
+	irqstatus = omap24xxcam_reg_in(cam->mmio_base, CAM_IRQSTATUS);
+
+	if (irqstatus &
+	    (CAM_IRQSTATUS_DMA_IRQ2 | CAM_IRQSTATUS_DMA_IRQ1
+	     | CAM_IRQSTATUS_DMA_IRQ0)) {
+		omap24xxcam_dma_isr(&cam->sgdma.dma);
+		irqhandled = 1;
+	}
+	if (irqstatus & CAM_IRQSTATUS_CC_IRQ) {
+		omap24xxcam_core_isr(cam);
+		irqhandled = 1;
+	}
+	if (irqstatus & CAM_IRQSTATUS_MMU_IRQ)
+		dev_err(cam->dev, "unhandled camera MMU interrupt!\n");
+
+	return IRQ_RETVAL(irqhandled);
+}
+
+/*
+ *
+ * Sensor handling.
+ *
+ */
+
+/*
+ * Enable the external sensor interface. Try to negotiate interface
+ * parameters with the sensor and start using the new ones. The calls
+ * to sensor_if_enable and sensor_if_disable need not to be balanced.
+ */
+static int omap24xxcam_sensor_if_enable(struct omap24xxcam_device *cam)
+{
+	int rval;
+	struct v4l2_ifparm p;
+
+	rval = vidioc_int_g_ifparm(cam->sdev, &p);
+	if (rval) {
+		dev_err(cam->dev, "vidioc_int_g_ifparm failed with %d\n", rval);
+		return rval;
+	}
+
+	cam->if_type = p.if_type;
+
+	cam->cc_ctrl = CC_CTRL_CC_EN;
+
+	switch (p.if_type) {
+	case V4L2_IF_TYPE_BT656:
+		if (p.u.bt656.frame_start_on_rising_vs)
+			cam->cc_ctrl |= CC_CTRL_NOBT_SYNCHRO;
+		if (p.u.bt656.bt_sync_correct)
+			cam->cc_ctrl |= CC_CTRL_BT_CORRECT;
+		if (p.u.bt656.swap)
+			cam->cc_ctrl |= CC_CTRL_PAR_ORDERCAM;
+		if (p.u.bt656.latch_clk_inv)
+			cam->cc_ctrl |= CC_CTRL_PAR_CLK_POL;
+		if (p.u.bt656.nobt_hs_inv)
+			cam->cc_ctrl |= CC_CTRL_NOBT_HS_POL;
+		if (p.u.bt656.nobt_vs_inv)
+			cam->cc_ctrl |= CC_CTRL_NOBT_VS_POL;
+
+		switch (p.u.bt656.mode) {
+		case V4L2_IF_TYPE_BT656_MODE_NOBT_8BIT:
+			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT8;
+			break;
+		case V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT:
+			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT10;
+			break;
+		case V4L2_IF_TYPE_BT656_MODE_NOBT_12BIT:
+			cam->cc_ctrl |= CC_CTRL_PAR_MODE_NOBT12;
+			break;
+		case V4L2_IF_TYPE_BT656_MODE_BT_8BIT:
+			cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT8;
+			break;
+		case V4L2_IF_TYPE_BT656_MODE_BT_10BIT:
+			cam->cc_ctrl |= CC_CTRL_PAR_MODE_BT10;
+			break;
+		default:
+			dev_err(cam->dev,
+				"bt656 interface mode %d not supported\n",
+				p.u.bt656.mode);
+			return -EINVAL;
+		}
+		/*
+		 * The clock rate that the sensor wants has changed.
+		 * We have to adjust the xclk from OMAP 2 side to
+		 * match the sensor's wish as closely as possible.
+		 */
+		if (p.u.bt656.clock_curr != cam->if_u.bt656.xclk) {
+			u32 xclk = p.u.bt656.clock_curr;
+			u32 divisor;
+
+			if (xclk == 0)
+				return -EINVAL;
+
+			if (xclk > CAM_MCLK)
+				xclk = CAM_MCLK;
+
+			divisor = CAM_MCLK / xclk;
+			if (divisor * xclk < CAM_MCLK)
+				divisor++;
+			if (CAM_MCLK / divisor < p.u.bt656.clock_min
+			    && divisor > 1)
+				divisor--;
+			if (divisor > 30)
+				divisor = 30;
+
+			xclk = CAM_MCLK / divisor;
+
+			if (xclk < p.u.bt656.clock_min
+			    || xclk > p.u.bt656.clock_max)
+				return -EINVAL;
+
+			cam->if_u.bt656.xclk = xclk;
+		}
+		omap24xxcam_core_xclk_set(cam, cam->if_u.bt656.xclk);
+		break;
+	default:
+		/* FIXME: how about other interfaces? */
+		dev_err(cam->dev, "interface type %d not supported\n",
+			p.if_type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void omap24xxcam_sensor_if_disable(const struct omap24xxcam_device *cam)
+{
+	switch (cam->if_type) {
+	case V4L2_IF_TYPE_BT656:
+		omap24xxcam_core_xclk_set(cam, 0);
+		break;
+	}
+}
+
+/*
+ * Initialise the sensor hardware.
+ */
+static int omap24xxcam_sensor_init(struct omap24xxcam_device *cam)
+{
+	int err = 0;
+	struct v4l2_int_device *sdev = cam->sdev;
+
+	omap24xxcam_clock_on(cam);
+	err = omap24xxcam_sensor_if_enable(cam);
+	if (err) {
+		dev_err(cam->dev, "sensor interface could not be enabled at "
+			"initialisation, %d\n", err);
+		cam->sdev = NULL;
+		goto out;
+	}
+
+	/* power up sensor during sensor initialization */
+	vidioc_int_s_power(sdev, 1);
+
+	err = vidioc_int_dev_init(sdev);
+	if (err) {
+		dev_err(cam->dev, "cannot initialize sensor, error %d\n", err);
+		/* Sensor init failed --- it's nonexistent to us! */
+		cam->sdev = NULL;
+		goto out;
+	}
+
+	dev_info(cam->dev, "sensor is %s\n", sdev->name);
+
+out:
+	omap24xxcam_sensor_if_disable(cam);
+	omap24xxcam_clock_off(cam);
+
+	vidioc_int_s_power(sdev, 0);
+
+	return err;
+}
+
+static void omap24xxcam_sensor_exit(struct omap24xxcam_device *cam)
+{
+	if (cam->sdev)
+		vidioc_int_dev_exit(cam->sdev);
+}
+
+static void omap24xxcam_sensor_disable(struct omap24xxcam_device *cam)
+{
+	omap24xxcam_sensor_if_disable(cam);
+	omap24xxcam_clock_off(cam);
+	vidioc_int_s_power(cam->sdev, 0);
+}
+
+/*
+ * Power-up and configure camera sensor. It's ready for capturing now.
+ */
+static int omap24xxcam_sensor_enable(struct omap24xxcam_device *cam)
+{
+	int rval;
+
+	omap24xxcam_clock_on(cam);
+
+	omap24xxcam_sensor_if_enable(cam);
+
+	rval = vidioc_int_s_power(cam->sdev, 1);
+	if (rval)
+		goto out;
+
+	rval = vidioc_int_init(cam->sdev);
+	if (rval)
+		goto out;
+
+	return 0;
+
+out:
+	omap24xxcam_sensor_disable(cam);
+
+	return rval;
+}
+
+static void omap24xxcam_sensor_reset_work(struct work_struct *work)
+{
+	struct omap24xxcam_device *cam =
+		container_of(work, struct omap24xxcam_device,
+			     sensor_reset_work);
+
+	if (atomic_read(&cam->reset_disable))
+		return;
+
+	omap24xxcam_capture_stop(cam);
+
+	if (vidioc_int_reset(cam->sdev) == 0) {
+		vidioc_int_init(cam->sdev);
+	} else {
+		/* Can't reset it by vidioc_int_reset. */
+		omap24xxcam_sensor_disable(cam);
+		omap24xxcam_sensor_enable(cam);
+	}
+
+	omap24xxcam_capture_cont(cam);
+}
+
+/*
+ *
+ * IOCTL interface.
+ *
+ */
+
+static int vidioc_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+
+	strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, cam->vfd->name, sizeof(cap->card));
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_fmtdesc *f)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	rval = vidioc_int_enum_fmt_cap(cam->sdev, f);
+
+	return rval;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	rval = vidioc_int_g_fmt_cap(cam->sdev, f);
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	rval = vidioc_int_s_fmt_cap(cam->sdev, f);
+
+out:
+	mutex_unlock(&cam->mutex);
+
+	if (!rval) {
+		mutex_lock(&ofh->vbq.vb_lock);
+		ofh->pix = f->fmt.pix;
+		mutex_unlock(&ofh->vbq.vb_lock);
+	}
+
+	memset(f, 0, sizeof(*f));
+	vidioc_g_fmt_vid_cap(file, fh, f);
+
+	return rval;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	rval = vidioc_int_try_fmt_cap(cam->sdev, f);
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *b)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming) {
+		mutex_unlock(&cam->mutex);
+		return -EBUSY;
+	}
+
+	omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
+	mutex_unlock(&cam->mutex);
+
+	rval = videobuf_reqbufs(&ofh->vbq, b);
+
+	/*
+	 * Either videobuf_reqbufs failed or the buffers are not
+	 * memory-mapped (which would need special attention).
+	 */
+	if (rval < 0 || b->memory != V4L2_MEMORY_MMAP)
+		goto out;
+
+	rval = omap24xxcam_vbq_alloc_mmap_buffers(&ofh->vbq, rval);
+	if (rval)
+		omap24xxcam_vbq_free_mmap_buffers(&ofh->vbq);
+
+out:
+	return rval;
+}
+
+static int vidioc_querybuf(struct file *file, void *fh,
+			   struct v4l2_buffer *b)
+{
+	struct omap24xxcam_fh *ofh = fh;
+
+	return videobuf_querybuf(&ofh->vbq, b);
+}
+
+static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct omap24xxcam_fh *ofh = fh;
+
+	return videobuf_qbuf(&ofh->vbq, b);
+}
+
+static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	struct videobuf_buffer *vb;
+	int rval;
+
+videobuf_dqbuf_again:
+	rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
+	if (rval)
+		goto out;
+
+	vb = ofh->vbq.bufs[b->index];
+
+	mutex_lock(&cam->mutex);
+	/* _needs_reset returns -EIO if reset is required. */
+	rval = vidioc_int_g_needs_reset(cam->sdev, (void *)vb->baddr);
+	mutex_unlock(&cam->mutex);
+	if (rval == -EIO)
+		schedule_work(&cam->sensor_reset_work);
+	else
+		rval = 0;
+
+out:
+	/*
+	 * This is a hack. We don't want to show -EIO to the user
+	 * space. Requeue the buffer and try again if we're not doing
+	 * this in non-blocking mode.
+	 */
+	if (rval == -EIO) {
+		videobuf_qbuf(&ofh->vbq, b);
+		if (!(file->f_flags & O_NONBLOCK))
+			goto videobuf_dqbuf_again;
+		/*
+		 * We don't have a videobuf_buffer now --- maybe next
+		 * time...
+		 */
+		rval = -EAGAIN;
+	}
+
+	return rval;
+}
+
+static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	rval = omap24xxcam_sensor_if_enable(cam);
+	if (rval) {
+		dev_dbg(cam->dev, "vidioc_int_g_ifparm failed\n");
+		goto out;
+	}
+
+	rval = videobuf_streamon(&ofh->vbq);
+	if (!rval) {
+		cam->streaming = file;
+		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
+	}
+
+out:
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	struct videobuf_queue *q = &ofh->vbq;
+	int rval;
+
+	atomic_inc(&cam->reset_disable);
+
+	flush_work(&cam->sensor_reset_work);
+
+	rval = videobuf_streamoff(q);
+	if (!rval) {
+		mutex_lock(&cam->mutex);
+		cam->streaming = NULL;
+		mutex_unlock(&cam->mutex);
+		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
+	}
+
+	atomic_dec(&cam->reset_disable);
+
+	return rval;
+}
+
+static int vidioc_enum_input(struct file *file, void *fh,
+			     struct v4l2_input *inp)
+{
+	if (inp->index > 0)
+		return -EINVAL;
+
+	strlcpy(inp->name, "camera", sizeof(inp->name));
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vidioc_queryctrl(struct file *file, void *fh,
+			    struct v4l2_queryctrl *a)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	rval = vidioc_int_queryctrl(cam->sdev, a);
+
+	return rval;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *fh,
+			 struct v4l2_control *a)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	rval = vidioc_int_g_ctrl(cam->sdev, a);
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *fh,
+			 struct v4l2_control *a)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	rval = vidioc_int_s_ctrl(cam->sdev, a);
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_g_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a) {
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	rval = vidioc_int_g_parm(cam->sdev, a);
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+static int vidioc_s_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a)
+{
+	struct omap24xxcam_fh *ofh = fh;
+	struct omap24xxcam_device *cam = ofh->cam;
+	struct v4l2_streamparm old_streamparm;
+	int rval;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	old_streamparm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	rval = vidioc_int_g_parm(cam->sdev, &old_streamparm);
+	if (rval)
+		goto out;
+
+	rval = vidioc_int_s_parm(cam->sdev, a);
+	if (rval)
+		goto out;
+
+	rval = omap24xxcam_sensor_if_enable(cam);
+	/*
+	 * Revert to old streaming parameters if enabling sensor
+	 * interface with the new ones failed.
+	 */
+	if (rval)
+		vidioc_int_s_parm(cam->sdev, &old_streamparm);
+
+out:
+	mutex_unlock(&cam->mutex);
+
+	return rval;
+}
+
+/*
+ *
+ * File operations.
+ *
+ */
+
+static unsigned int omap24xxcam_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct omap24xxcam_fh *fh = file->private_data;
+	struct omap24xxcam_device *cam = fh->cam;
+	struct videobuf_buffer *vb;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming != file) {
+		mutex_unlock(&cam->mutex);
+		return POLLERR;
+	}
+	mutex_unlock(&cam->mutex);
+
+	mutex_lock(&fh->vbq.vb_lock);
+	if (list_empty(&fh->vbq.stream)) {
+		mutex_unlock(&fh->vbq.vb_lock);
+		return POLLERR;
+	}
+	vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer, stream);
+	mutex_unlock(&fh->vbq.vb_lock);
+
+	poll_wait(file, &vb->done, wait);
+
+	if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static int omap24xxcam_mmap_buffers(struct file *file,
+				    struct vm_area_struct *vma)
+{
+	struct omap24xxcam_fh *fh = file->private_data;
+	struct omap24xxcam_device *cam = fh->cam;
+	struct videobuf_queue *vbq = &fh->vbq;
+	unsigned int first, last, size, i, j;
+	int err = 0;
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming) {
+		mutex_unlock(&cam->mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&cam->mutex);
+	mutex_lock(&vbq->vb_lock);
+
+	/* look for first buffer to map */
+	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
+		if (NULL == vbq->bufs[first])
+			continue;
+		if (V4L2_MEMORY_MMAP != vbq->bufs[first]->memory)
+			continue;
+		if (vbq->bufs[first]->boff == (vma->vm_pgoff << PAGE_SHIFT))
+			break;
+	}
+
+	/* look for last buffer to map */
+	for (size = 0, last = first; last < VIDEO_MAX_FRAME; last++) {
+		if (NULL == vbq->bufs[last])
+			continue;
+		if (V4L2_MEMORY_MMAP != vbq->bufs[last]->memory)
+			continue;
+		size += vbq->bufs[last]->bsize;
+		if (size == (vma->vm_end - vma->vm_start))
+			break;
+	}
+
+	size = 0;
+	for (i = first; i <= last && i < VIDEO_MAX_FRAME; i++) {
+		struct videobuf_dmabuf *dma = videobuf_to_dma(vbq->bufs[i]);
+
+		for (j = 0; j < dma->sglen; j++) {
+			err = remap_pfn_range(
+				vma, vma->vm_start + size,
+				page_to_pfn(sg_page(&dma->sglist[j])),
+				sg_dma_len(&dma->sglist[j]), vma->vm_page_prot);
+			if (err)
+				goto out;
+			size += sg_dma_len(&dma->sglist[j]);
+		}
+	}
+
+out:
+	mutex_unlock(&vbq->vb_lock);
+
+	return err;
+}
+
+static int omap24xxcam_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct omap24xxcam_fh *fh = file->private_data;
+	int rval;
+
+	/* let the video-buf mapper check arguments and set-up structures */
+	rval = videobuf_mmap_mapper(&fh->vbq, vma);
+	if (rval)
+		return rval;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	/* do mapping to our allocated buffers */
+	rval = omap24xxcam_mmap_buffers(file, vma);
+	/*
+	 * In case of error, free vma->vm_private_data allocated by
+	 * videobuf_mmap_mapper.
+	 */
+	if (rval)
+		kfree(vma->vm_private_data);
+
+	return rval;
+}
+
+static int omap24xxcam_open(struct file *file)
+{
+	struct omap24xxcam_device *cam = omap24xxcam.priv;
+	struct omap24xxcam_fh *fh;
+	struct v4l2_format format;
+
+	if (!cam || !cam->vfd)
+		return -ENODEV;
+
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (fh == NULL)
+		return -ENOMEM;
+
+	mutex_lock(&cam->mutex);
+	if (cam->sdev == NULL || !try_module_get(cam->sdev->module)) {
+		mutex_unlock(&cam->mutex);
+		goto out_try_module_get;
+	}
+
+	if (atomic_inc_return(&cam->users) == 1) {
+		omap24xxcam_hwinit(cam);
+		if (omap24xxcam_sensor_enable(cam)) {
+			mutex_unlock(&cam->mutex);
+			goto out_omap24xxcam_sensor_enable;
+		}
+	}
+	mutex_unlock(&cam->mutex);
+
+	fh->cam = cam;
+	mutex_lock(&cam->mutex);
+	vidioc_int_g_fmt_cap(cam->sdev, &format);
+	mutex_unlock(&cam->mutex);
+	/* FIXME: how about fh->pix when there are more users? */
+	fh->pix = format.fmt.pix;
+
+	file->private_data = fh;
+
+	spin_lock_init(&fh->vbq_lock);
+
+	videobuf_queue_sg_init(&fh->vbq, &omap24xxcam_vbq_ops, NULL,
+				&fh->vbq_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_NONE,
+				sizeof(struct videobuf_buffer), fh, NULL);
+
+	return 0;
+
+out_omap24xxcam_sensor_enable:
+	omap24xxcam_poweron_reset(cam);
+	module_put(cam->sdev->module);
+
+out_try_module_get:
+	kfree(fh);
+
+	return -ENODEV;
+}
+
+static int omap24xxcam_release(struct file *file)
+{
+	struct omap24xxcam_fh *fh = file->private_data;
+	struct omap24xxcam_device *cam = fh->cam;
+
+	atomic_inc(&cam->reset_disable);
+
+	flush_work(&cam->sensor_reset_work);
+
+	/* stop streaming capture */
+	videobuf_streamoff(&fh->vbq);
+
+	mutex_lock(&cam->mutex);
+	if (cam->streaming == file) {
+		cam->streaming = NULL;
+		mutex_unlock(&cam->mutex);
+		sysfs_notify(&cam->dev->kobj, NULL, "streaming");
+	} else {
+		mutex_unlock(&cam->mutex);
+	}
+
+	atomic_dec(&cam->reset_disable);
+
+	omap24xxcam_vbq_free_mmap_buffers(&fh->vbq);
+
+	/*
+	 * Make sure the reset work we might have scheduled is not
+	 * pending! It may be run *only* if we have users. (And it may
+	 * not be scheduled anymore since streaming is already
+	 * disabled.)
+	 */
+	flush_work(&cam->sensor_reset_work);
+
+	mutex_lock(&cam->mutex);
+	if (atomic_dec_return(&cam->users) == 0) {
+		omap24xxcam_sensor_disable(cam);
+		omap24xxcam_poweron_reset(cam);
+	}
+	mutex_unlock(&cam->mutex);
+
+	file->private_data = NULL;
+
+	module_put(cam->sdev->module);
+	kfree(fh);
+
+	return 0;
+}
+
+static struct v4l2_file_operations omap24xxcam_fops = {
+	.ioctl	 = video_ioctl2,
+	.poll	 = omap24xxcam_poll,
+	.mmap	 = omap24xxcam_mmap,
+	.open	 = omap24xxcam_open,
+	.release = omap24xxcam_release,
+};
+
+/*
+ *
+ * Power management.
+ *
+ */
+
+#ifdef CONFIG_PM
+static int omap24xxcam_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
+
+	if (atomic_read(&cam->users) == 0)
+		return 0;
+
+	if (!atomic_read(&cam->reset_disable))
+		omap24xxcam_capture_stop(cam);
+
+	omap24xxcam_sensor_disable(cam);
+	omap24xxcam_poweron_reset(cam);
+
+	return 0;
+}
+
+static int omap24xxcam_resume(struct platform_device *pdev)
+{
+	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
+
+	if (atomic_read(&cam->users) == 0)
+		return 0;
+
+	omap24xxcam_hwinit(cam);
+	omap24xxcam_sensor_enable(cam);
+
+	if (!atomic_read(&cam->reset_disable))
+		omap24xxcam_capture_cont(cam);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+static const struct v4l2_ioctl_ops omap24xxcam_ioctl_fops = {
+	.vidioc_querycap	= vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+	.vidioc_enum_input	= vidioc_enum_input,
+	.vidioc_g_input		= vidioc_g_input,
+	.vidioc_s_input		= vidioc_s_input,
+	.vidioc_queryctrl	= vidioc_queryctrl,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_g_parm		= vidioc_g_parm,
+	.vidioc_s_parm		= vidioc_s_parm,
+};
+
+/*
+ *
+ * Camera device (i.e. /dev/video).
+ *
+ */
+
+static int omap24xxcam_device_register(struct v4l2_int_device *s)
+{
+	struct omap24xxcam_device *cam = s->u.slave->master->priv;
+	struct video_device *vfd;
+	int rval;
+
+	/* We already have a slave. */
+	if (cam->sdev)
+		return -EBUSY;
+
+	cam->sdev = s;
+
+	if (device_create_file(cam->dev, &dev_attr_streaming) != 0) {
+		dev_err(cam->dev, "could not register sysfs entry\n");
+		rval = -EBUSY;
+		goto err;
+	}
+
+	/* initialize the video_device struct */
+	vfd = cam->vfd = video_device_alloc();
+	if (!vfd) {
+		dev_err(cam->dev, "could not allocate video device struct\n");
+		rval = -ENOMEM;
+		goto err;
+	}
+	vfd->release = video_device_release;
+
+	vfd->v4l2_dev = &cam->v4l2_dev;
+
+	strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
+	vfd->fops		 = &omap24xxcam_fops;
+	vfd->ioctl_ops		 = &omap24xxcam_ioctl_fops;
+
+	omap24xxcam_hwinit(cam);
+
+	rval = omap24xxcam_sensor_init(cam);
+	if (rval)
+		goto err;
+
+	if (video_register_device(vfd, VFL_TYPE_GRABBER, video_nr) < 0) {
+		dev_err(cam->dev, "could not register V4L device\n");
+		rval = -EBUSY;
+		goto err;
+	}
+
+	omap24xxcam_poweron_reset(cam);
+
+	dev_info(cam->dev, "registered device %s\n",
+		 video_device_node_name(vfd));
+
+	return 0;
+
+err:
+	omap24xxcam_device_unregister(s);
+
+	return rval;
+}
+
+static void omap24xxcam_device_unregister(struct v4l2_int_device *s)
+{
+	struct omap24xxcam_device *cam = s->u.slave->master->priv;
+
+	omap24xxcam_sensor_exit(cam);
+
+	if (cam->vfd) {
+		if (!video_is_registered(cam->vfd)) {
+			/*
+			 * The device was never registered, so release the
+			 * video_device struct directly.
+			 */
+			video_device_release(cam->vfd);
+		} else {
+			/*
+			 * The unregister function will release the
+			 * video_device struct as well as
+			 * unregistering it.
+			 */
+			video_unregister_device(cam->vfd);
+		}
+		cam->vfd = NULL;
+	}
+
+	device_remove_file(cam->dev, &dev_attr_streaming);
+
+	cam->sdev = NULL;
+}
+
+static struct v4l2_int_master omap24xxcam_master = {
+	.attach = omap24xxcam_device_register,
+	.detach = omap24xxcam_device_unregister,
+};
+
+static struct v4l2_int_device omap24xxcam = {
+	.module	= THIS_MODULE,
+	.name	= CAM_NAME,
+	.type	= v4l2_int_type_master,
+	.u	= {
+		.master = &omap24xxcam_master
+	},
+};
+
+/*
+ *
+ * Driver initialisation and deinitialisation.
+ *
+ */
+
+static int omap24xxcam_probe(struct platform_device *pdev)
+{
+	struct omap24xxcam_device *cam;
+	struct resource *mem;
+	int irq;
+
+	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
+	if (!cam) {
+		dev_err(&pdev->dev, "could not allocate memory\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, cam);
+
+	cam->dev = &pdev->dev;
+
+	if (v4l2_device_register(&pdev->dev, &cam->v4l2_dev)) {
+		dev_err(&pdev->dev, "v4l2_device_register failed\n");
+		goto err;
+	}
+
+	/*
+	 * Impose a lower limit on the amount of memory allocated for
+	 * capture. We require at least enough memory to double-buffer
+	 * QVGA (300KB).
+	 */
+	if (capture_mem < 320 * 240 * 2 * 2)
+		capture_mem = 320 * 240 * 2 * 2;
+	cam->capture_mem = capture_mem;
+
+	/* request the mem region for the camera registers */
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(cam->dev, "no mem resource?\n");
+		goto err;
+	}
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
+		dev_err(cam->dev,
+			"cannot reserve camera register I/O region\n");
+		goto err;
+	}
+	cam->mmio_base_phys = mem->start;
+	cam->mmio_size = resource_size(mem);
+
+	/* map the region */
+	cam->mmio_base = ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
+	if (!cam->mmio_base) {
+		dev_err(cam->dev, "cannot map camera register I/O region\n");
+		goto err;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(cam->dev, "no irq for camera?\n");
+		goto err;
+	}
+
+	/* install the interrupt service routine */
+	if (request_irq(irq, omap24xxcam_isr, 0, CAM_NAME, cam)) {
+		dev_err(cam->dev,
+			"could not install interrupt service routine\n");
+		goto err;
+	}
+	cam->irq = irq;
+
+	if (omap24xxcam_clock_get(cam))
+		goto err;
+
+	INIT_WORK(&cam->sensor_reset_work, omap24xxcam_sensor_reset_work);
+
+	mutex_init(&cam->mutex);
+	spin_lock_init(&cam->core_enable_disable_lock);
+
+	omap24xxcam_sgdma_init(&cam->sgdma,
+			       cam->mmio_base + CAMDMA_REG_OFFSET,
+			       omap24xxcam_stalled_dma_reset,
+			       (unsigned long)cam);
+
+	omap24xxcam.priv = cam;
+
+	if (v4l2_int_device_register(&omap24xxcam))
+		goto err;
+
+	return 0;
+
+err:
+	omap24xxcam_remove(pdev);
+	return -ENODEV;
+}
+
+static int omap24xxcam_remove(struct platform_device *pdev)
+{
+	struct omap24xxcam_device *cam = platform_get_drvdata(pdev);
+
+	if (!cam)
+		return 0;
+
+	if (omap24xxcam.priv != NULL)
+		v4l2_int_device_unregister(&omap24xxcam);
+	omap24xxcam.priv = NULL;
+
+	omap24xxcam_clock_put(cam);
+
+	if (cam->irq) {
+		free_irq(cam->irq, cam);
+		cam->irq = 0;
+	}
+
+	if (cam->mmio_base) {
+		iounmap((void *)cam->mmio_base);
+		cam->mmio_base = 0;
+	}
+
+	if (cam->mmio_base_phys) {
+		release_mem_region(cam->mmio_base_phys, cam->mmio_size);
+		cam->mmio_base_phys = 0;
+	}
+
+	v4l2_device_unregister(&cam->v4l2_dev);
+
+	kfree(cam);
+
+	return 0;
+}
+
+static struct platform_driver omap24xxcam_driver = {
+	.probe	 = omap24xxcam_probe,
+	.remove	 = omap24xxcam_remove,
+#ifdef CONFIG_PM
+	.suspend = omap24xxcam_suspend,
+	.resume	 = omap24xxcam_resume,
+#endif
+	.driver	 = {
+		.name = CAM_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(omap24xxcam_driver);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
+MODULE_DESCRIPTION("OMAP24xx Video for Linux camera driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(OMAP24XXCAM_VERSION);
+module_param(video_nr, int, 0);
+MODULE_PARM_DESC(video_nr,
+		 "Minor number for video device (-1 ==> auto assign)");
+module_param(capture_mem, int, 0);
+MODULE_PARM_DESC(capture_mem, "Maximum amount of memory for capture "
+		 "buffers (default 4800kiB)");
diff --git a/drivers/staging/media/omap24xx/omap24xxcam.h b/drivers/staging/media/omap24xx/omap24xxcam.h
new file mode 100644
index 0000000..233bb40
--- /dev/null
+++ b/drivers/staging/media/omap24xx/omap24xxcam.h
@@ -0,0 +1,596 @@
+/*
+ * drivers/media/platform/omap24xxcam.h
+ *
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2004 Texas Instruments.
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * Based on code from Andy Lowe <source@mvista.com>.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP24XXCAM_H
+#define OMAP24XXCAM_H
+
+#include <media/videobuf-dma-sg.h>
+#include <media/v4l2-device.h>
+#include "v4l2-int-device.h"
+
+/*
+ *
+ * General driver related definitions.
+ *
+ */
+
+#define CAM_NAME				"omap24xxcam"
+
+#define CAM_MCLK				96000000
+
+/* number of bytes transferred per DMA request */
+#define DMA_THRESHOLD				32
+
+/*
+ * NUM_CAMDMA_CHANNELS is the number of logical channels provided by
+ * the camera DMA controller.
+ */
+#define NUM_CAMDMA_CHANNELS			4
+
+/*
+ * NUM_SG_DMA is the number of scatter-gather DMA transfers that can
+ * be queued. (We don't have any overlay sglists now.)
+ */
+#define NUM_SG_DMA				(VIDEO_MAX_FRAME)
+
+/*
+ *
+ * Register definitions.
+ *
+ */
+
+/* subsystem register block offsets */
+#define CC_REG_OFFSET				0x00000400
+#define CAMDMA_REG_OFFSET			0x00000800
+#define CAMMMU_REG_OFFSET			0x00000C00
+
+/* define camera subsystem register offsets */
+#define CAM_REVISION				0x000
+#define CAM_SYSCONFIG				0x010
+#define CAM_SYSSTATUS				0x014
+#define CAM_IRQSTATUS				0x018
+#define CAM_GPO					0x040
+#define CAM_GPI					0x050
+
+/* define camera core register offsets */
+#define CC_REVISION				0x000
+#define CC_SYSCONFIG				0x010
+#define CC_SYSSTATUS				0x014
+#define CC_IRQSTATUS				0x018
+#define CC_IRQENABLE				0x01C
+#define CC_CTRL					0x040
+#define CC_CTRL_DMA				0x044
+#define CC_CTRL_XCLK				0x048
+#define CC_FIFODATA				0x04C
+#define CC_TEST					0x050
+#define CC_GENPAR				0x054
+#define CC_CCPFSCR				0x058
+#define CC_CCPFECR				0x05C
+#define CC_CCPLSCR				0x060
+#define CC_CCPLECR				0x064
+#define CC_CCPDFR				0x068
+
+/* define camera dma register offsets */
+#define CAMDMA_REVISION				0x000
+#define CAMDMA_IRQSTATUS_L0			0x008
+#define CAMDMA_IRQSTATUS_L1			0x00C
+#define CAMDMA_IRQSTATUS_L2			0x010
+#define CAMDMA_IRQSTATUS_L3			0x014
+#define CAMDMA_IRQENABLE_L0			0x018
+#define CAMDMA_IRQENABLE_L1			0x01C
+#define CAMDMA_IRQENABLE_L2			0x020
+#define CAMDMA_IRQENABLE_L3			0x024
+#define CAMDMA_SYSSTATUS			0x028
+#define CAMDMA_OCP_SYSCONFIG			0x02C
+#define CAMDMA_CAPS_0				0x064
+#define CAMDMA_CAPS_2				0x06C
+#define CAMDMA_CAPS_3				0x070
+#define CAMDMA_CAPS_4				0x074
+#define CAMDMA_GCR				0x078
+#define CAMDMA_CCR(n)				(0x080 + (n)*0x60)
+#define CAMDMA_CLNK_CTRL(n)			(0x084 + (n)*0x60)
+#define CAMDMA_CICR(n)				(0x088 + (n)*0x60)
+#define CAMDMA_CSR(n)				(0x08C + (n)*0x60)
+#define CAMDMA_CSDP(n)				(0x090 + (n)*0x60)
+#define CAMDMA_CEN(n)				(0x094 + (n)*0x60)
+#define CAMDMA_CFN(n)				(0x098 + (n)*0x60)
+#define CAMDMA_CSSA(n)				(0x09C + (n)*0x60)
+#define CAMDMA_CDSA(n)				(0x0A0 + (n)*0x60)
+#define CAMDMA_CSEI(n)				(0x0A4 + (n)*0x60)
+#define CAMDMA_CSFI(n)				(0x0A8 + (n)*0x60)
+#define CAMDMA_CDEI(n)				(0x0AC + (n)*0x60)
+#define CAMDMA_CDFI(n)				(0x0B0 + (n)*0x60)
+#define CAMDMA_CSAC(n)				(0x0B4 + (n)*0x60)
+#define CAMDMA_CDAC(n)				(0x0B8 + (n)*0x60)
+#define CAMDMA_CCEN(n)				(0x0BC + (n)*0x60)
+#define CAMDMA_CCFN(n)				(0x0C0 + (n)*0x60)
+#define CAMDMA_COLOR(n)				(0x0C4 + (n)*0x60)
+
+/* define camera mmu register offsets */
+#define CAMMMU_REVISION				0x000
+#define CAMMMU_SYSCONFIG			0x010
+#define CAMMMU_SYSSTATUS			0x014
+#define CAMMMU_IRQSTATUS			0x018
+#define CAMMMU_IRQENABLE			0x01C
+#define CAMMMU_WALKING_ST			0x040
+#define CAMMMU_CNTL				0x044
+#define CAMMMU_FAULT_AD				0x048
+#define CAMMMU_TTB				0x04C
+#define CAMMMU_LOCK				0x050
+#define CAMMMU_LD_TLB				0x054
+#define CAMMMU_CAM				0x058
+#define CAMMMU_RAM				0x05C
+#define CAMMMU_GFLUSH				0x060
+#define CAMMMU_FLUSH_ENTRY			0x064
+#define CAMMMU_READ_CAM				0x068
+#define CAMMMU_READ_RAM				0x06C
+#define CAMMMU_EMU_FAULT_AD			0x070
+
+/* Define bit fields within selected registers */
+#define CAM_REVISION_MAJOR			(15 << 4)
+#define CAM_REVISION_MAJOR_SHIFT		4
+#define CAM_REVISION_MINOR			(15 << 0)
+#define CAM_REVISION_MINOR_SHIFT		0
+
+#define CAM_SYSCONFIG_SOFTRESET			(1 <<  1)
+#define CAM_SYSCONFIG_AUTOIDLE			(1 <<  0)
+
+#define CAM_SYSSTATUS_RESETDONE			(1 <<  0)
+
+#define CAM_IRQSTATUS_CC_IRQ			(1 <<  4)
+#define CAM_IRQSTATUS_MMU_IRQ			(1 <<  3)
+#define CAM_IRQSTATUS_DMA_IRQ2			(1 <<  2)
+#define CAM_IRQSTATUS_DMA_IRQ1			(1 <<  1)
+#define CAM_IRQSTATUS_DMA_IRQ0			(1 <<  0)
+
+#define CAM_GPO_CAM_S_P_EN			(1 <<  1)
+#define CAM_GPO_CAM_CCP_MODE			(1 <<  0)
+
+#define CAM_GPI_CC_DMA_REQ1			(1 << 24)
+#define CAP_GPI_CC_DMA_REQ0			(1 << 23)
+#define CAP_GPI_CAM_MSTANDBY			(1 << 21)
+#define CAP_GPI_CAM_WAIT			(1 << 20)
+#define CAP_GPI_CAM_S_DATA			(1 << 17)
+#define CAP_GPI_CAM_S_CLK			(1 << 16)
+#define CAP_GPI_CAM_P_DATA			(0xFFF << 3)
+#define CAP_GPI_CAM_P_DATA_SHIFT		3
+#define CAP_GPI_CAM_P_VS			(1 <<  2)
+#define CAP_GPI_CAM_P_HS			(1 <<  1)
+#define CAP_GPI_CAM_P_CLK			(1 <<  0)
+
+#define CC_REVISION_MAJOR			(15 << 4)
+#define CC_REVISION_MAJOR_SHIFT			4
+#define CC_REVISION_MINOR			(15 << 0)
+#define CC_REVISION_MINOR_SHIFT			0
+
+#define CC_SYSCONFIG_SIDLEMODE			(3 <<  3)
+#define CC_SYSCONFIG_SIDLEMODE_FIDLE		(0 <<  3)
+#define CC_SYSCONFIG_SIDLEMODE_NIDLE		(1 <<  3)
+#define CC_SYSCONFIG_SOFTRESET			(1 <<  1)
+#define CC_SYSCONFIG_AUTOIDLE			(1 <<  0)
+
+#define CC_SYSSTATUS_RESETDONE			(1 <<  0)
+
+#define CC_IRQSTATUS_FS_IRQ			(1 << 19)
+#define CC_IRQSTATUS_LE_IRQ			(1 << 18)
+#define CC_IRQSTATUS_LS_IRQ			(1 << 17)
+#define CC_IRQSTATUS_FE_IRQ			(1 << 16)
+#define CC_IRQSTATUS_FW_ERR_IRQ			(1 << 10)
+#define CC_IRQSTATUS_FSC_ERR_IRQ		(1 <<  9)
+#define CC_IRQSTATUS_SSC_ERR_IRQ		(1 <<  8)
+#define CC_IRQSTATUS_FIFO_NOEMPTY_IRQ		(1 <<  4)
+#define CC_IRQSTATUS_FIFO_FULL_IRQ		(1 <<  3)
+#define CC_IRQSTATUS_FIFO_THR_IRQ		(1 <<  2)
+#define CC_IRQSTATUS_FIFO_OF_IRQ		(1 <<  1)
+#define CC_IRQSTATUS_FIFO_UF_IRQ		(1 <<  0)
+
+#define CC_IRQENABLE_FS_IRQ			(1 << 19)
+#define CC_IRQENABLE_LE_IRQ			(1 << 18)
+#define CC_IRQENABLE_LS_IRQ			(1 << 17)
+#define CC_IRQENABLE_FE_IRQ			(1 << 16)
+#define CC_IRQENABLE_FW_ERR_IRQ			(1 << 10)
+#define CC_IRQENABLE_FSC_ERR_IRQ		(1 <<  9)
+#define CC_IRQENABLE_SSC_ERR_IRQ		(1 <<  8)
+#define CC_IRQENABLE_FIFO_NOEMPTY_IRQ		(1 <<  4)
+#define CC_IRQENABLE_FIFO_FULL_IRQ		(1 <<  3)
+#define CC_IRQENABLE_FIFO_THR_IRQ		(1 <<  2)
+#define CC_IRQENABLE_FIFO_OF_IRQ		(1 <<  1)
+#define CC_IRQENABLE_FIFO_UF_IRQ		(1 <<  0)
+
+#define CC_CTRL_CC_ONE_SHOT			(1 << 20)
+#define CC_CTRL_CC_IF_SYNCHRO			(1 << 19)
+#define CC_CTRL_CC_RST				(1 << 18)
+#define CC_CTRL_CC_FRAME_TRIG			(1 << 17)
+#define CC_CTRL_CC_EN				(1 << 16)
+#define CC_CTRL_NOBT_SYNCHRO			(1 << 13)
+#define CC_CTRL_BT_CORRECT			(1 << 12)
+#define CC_CTRL_PAR_ORDERCAM			(1 << 11)
+#define CC_CTRL_PAR_CLK_POL			(1 << 10)
+#define CC_CTRL_NOBT_HS_POL			(1 <<  9)
+#define CC_CTRL_NOBT_VS_POL			(1 <<  8)
+#define CC_CTRL_PAR_MODE			(7 <<  1)
+#define CC_CTRL_PAR_MODE_SHIFT			1
+#define CC_CTRL_PAR_MODE_NOBT8			(0 <<  1)
+#define CC_CTRL_PAR_MODE_NOBT10			(1 <<  1)
+#define CC_CTRL_PAR_MODE_NOBT12			(2 <<  1)
+#define CC_CTRL_PAR_MODE_BT8			(4 <<  1)
+#define CC_CTRL_PAR_MODE_BT10			(5 <<  1)
+#define CC_CTRL_PAR_MODE_FIFOTEST		(7 <<  1)
+#define CC_CTRL_CCP_MODE			(1 <<  0)
+
+#define CC_CTRL_DMA_EN				(1 <<  8)
+#define CC_CTRL_DMA_FIFO_THRESHOLD		(0x7F << 0)
+#define CC_CTRL_DMA_FIFO_THRESHOLD_SHIFT	0
+
+#define CC_CTRL_XCLK_DIV			(0x1F << 0)
+#define CC_CTRL_XCLK_DIV_SHIFT			0
+#define CC_CTRL_XCLK_DIV_STABLE_LOW		(0 <<  0)
+#define CC_CTRL_XCLK_DIV_STABLE_HIGH		(1 <<  0)
+#define CC_CTRL_XCLK_DIV_BYPASS			(31 << 0)
+
+#define CC_TEST_FIFO_RD_POINTER			(0xFF << 24)
+#define CC_TEST_FIFO_RD_POINTER_SHIFT		24
+#define CC_TEST_FIFO_WR_POINTER			(0xFF << 16)
+#define CC_TEST_FIFO_WR_POINTER_SHIFT		16
+#define CC_TEST_FIFO_LEVEL			(0xFF <<  8)
+#define CC_TEST_FIFO_LEVEL_SHIFT		8
+#define CC_TEST_FIFO_LEVEL_PEAK			(0xFF <<  0)
+#define CC_TEST_FIFO_LEVEL_PEAK_SHIFT		0
+
+#define CC_GENPAR_FIFO_DEPTH			(7 <<  0)
+#define CC_GENPAR_FIFO_DEPTH_SHIFT		0
+
+#define CC_CCPDFR_ALPHA				(0xFF <<  8)
+#define CC_CCPDFR_ALPHA_SHIFT			8
+#define CC_CCPDFR_DATAFORMAT			(15 <<  0)
+#define CC_CCPDFR_DATAFORMAT_SHIFT		0
+#define CC_CCPDFR_DATAFORMAT_YUV422BE		(0 <<  0)
+#define CC_CCPDFR_DATAFORMAT_YUV422		(1 <<  0)
+#define CC_CCPDFR_DATAFORMAT_YUV420		(2 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RGB444		(4 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RGB565		(5 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RGB888NDE		(6 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RGB888		(7 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW8NDE		(8 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW8		(9 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW10NDE		(10 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW10		(11 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW12NDE		(12 <<  0)
+#define CC_CCPDFR_DATAFORMAT_RAW12		(13 <<  0)
+#define CC_CCPDFR_DATAFORMAT_JPEG8		(15 <<  0)
+
+#define CAMDMA_REVISION_MAJOR			(15 << 4)
+#define CAMDMA_REVISION_MAJOR_SHIFT		4
+#define CAMDMA_REVISION_MINOR			(15 << 0)
+#define CAMDMA_REVISION_MINOR_SHIFT		0
+
+#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE		(3 << 12)
+#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_FSTANDBY	(0 << 12)
+#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_NSTANDBY	(1 << 12)
+#define CAMDMA_OCP_SYSCONFIG_MIDLEMODE_SSTANDBY	(2 << 12)
+#define CAMDMA_OCP_SYSCONFIG_FUNC_CLOCK		(1 <<  9)
+#define CAMDMA_OCP_SYSCONFIG_OCP_CLOCK		(1 <<  8)
+#define CAMDMA_OCP_SYSCONFIG_EMUFREE		(1 <<  5)
+#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE		(3 <<  3)
+#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_FIDLE	(0 <<  3)
+#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_NIDLE	(1 <<  3)
+#define CAMDMA_OCP_SYSCONFIG_SIDLEMODE_SIDLE	(2 <<  3)
+#define CAMDMA_OCP_SYSCONFIG_SOFTRESET		(1 <<  1)
+#define CAMDMA_OCP_SYSCONFIG_AUTOIDLE		(1 <<  0)
+
+#define CAMDMA_SYSSTATUS_RESETDONE		(1 <<  0)
+
+#define CAMDMA_GCR_ARBITRATION_RATE		(0xFF << 16)
+#define CAMDMA_GCR_ARBITRATION_RATE_SHIFT	16
+#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH	(0xFF << 0)
+#define CAMDMA_GCR_MAX_CHANNEL_FIFO_DEPTH_SHIFT	0
+
+#define CAMDMA_CCR_SEL_SRC_DST_SYNC		(1 << 24)
+#define CAMDMA_CCR_PREFETCH			(1 << 23)
+#define CAMDMA_CCR_SUPERVISOR			(1 << 22)
+#define CAMDMA_CCR_SECURE			(1 << 21)
+#define CAMDMA_CCR_BS				(1 << 18)
+#define CAMDMA_CCR_TRANSPARENT_COPY_ENABLE	(1 << 17)
+#define CAMDMA_CCR_CONSTANT_FILL_ENABLE		(1 << 16)
+#define CAMDMA_CCR_DST_AMODE			(3 << 14)
+#define CAMDMA_CCR_DST_AMODE_CONST_ADDR		(0 << 14)
+#define CAMDMA_CCR_DST_AMODE_POST_INC		(1 << 14)
+#define CAMDMA_CCR_DST_AMODE_SGL_IDX		(2 << 14)
+#define CAMDMA_CCR_DST_AMODE_DBL_IDX		(3 << 14)
+#define CAMDMA_CCR_SRC_AMODE			(3 << 12)
+#define CAMDMA_CCR_SRC_AMODE_CONST_ADDR		(0 << 12)
+#define CAMDMA_CCR_SRC_AMODE_POST_INC		(1 << 12)
+#define CAMDMA_CCR_SRC_AMODE_SGL_IDX		(2 << 12)
+#define CAMDMA_CCR_SRC_AMODE_DBL_IDX		(3 << 12)
+#define CAMDMA_CCR_WR_ACTIVE			(1 << 10)
+#define CAMDMA_CCR_RD_ACTIVE			(1 <<  9)
+#define CAMDMA_CCR_SUSPEND_SENSITIVE		(1 <<  8)
+#define CAMDMA_CCR_ENABLE			(1 <<  7)
+#define CAMDMA_CCR_PRIO				(1 <<  6)
+#define CAMDMA_CCR_FS				(1 <<  5)
+#define CAMDMA_CCR_SYNCHRO			((3 << 19) | (31 << 0))
+#define CAMDMA_CCR_SYNCHRO_CAMERA		0x01
+
+#define CAMDMA_CLNK_CTRL_ENABLE_LNK		(1 << 15)
+#define CAMDMA_CLNK_CTRL_NEXTLCH_ID		(0x1F << 0)
+#define CAMDMA_CLNK_CTRL_NEXTLCH_ID_SHIFT	0
+
+#define CAMDMA_CICR_MISALIGNED_ERR_IE		(1 << 11)
+#define CAMDMA_CICR_SUPERVISOR_ERR_IE		(1 << 10)
+#define CAMDMA_CICR_SECURE_ERR_IE		(1 <<  9)
+#define CAMDMA_CICR_TRANS_ERR_IE		(1 <<  8)
+#define CAMDMA_CICR_PACKET_IE			(1 <<  7)
+#define CAMDMA_CICR_BLOCK_IE			(1 <<  5)
+#define CAMDMA_CICR_LAST_IE			(1 <<  4)
+#define CAMDMA_CICR_FRAME_IE			(1 <<  3)
+#define CAMDMA_CICR_HALF_IE			(1 <<  2)
+#define CAMDMA_CICR_DROP_IE			(1 <<  1)
+
+#define CAMDMA_CSR_MISALIGNED_ERR		(1 << 11)
+#define CAMDMA_CSR_SUPERVISOR_ERR		(1 << 10)
+#define CAMDMA_CSR_SECURE_ERR			(1 <<  9)
+#define CAMDMA_CSR_TRANS_ERR			(1 <<  8)
+#define CAMDMA_CSR_PACKET			(1 <<  7)
+#define CAMDMA_CSR_SYNC				(1 <<  6)
+#define CAMDMA_CSR_BLOCK			(1 <<  5)
+#define CAMDMA_CSR_LAST				(1 <<  4)
+#define CAMDMA_CSR_FRAME			(1 <<  3)
+#define CAMDMA_CSR_HALF				(1 <<  2)
+#define CAMDMA_CSR_DROP				(1 <<  1)
+
+#define CAMDMA_CSDP_SRC_ENDIANNESS		(1 << 21)
+#define CAMDMA_CSDP_SRC_ENDIANNESS_LOCK		(1 << 20)
+#define CAMDMA_CSDP_DST_ENDIANNESS		(1 << 19)
+#define CAMDMA_CSDP_DST_ENDIANNESS_LOCK		(1 << 18)
+#define CAMDMA_CSDP_WRITE_MODE			(3 << 16)
+#define CAMDMA_CSDP_WRITE_MODE_WRNP		(0 << 16)
+#define CAMDMA_CSDP_WRITE_MODE_POSTED		(1 << 16)
+#define CAMDMA_CSDP_WRITE_MODE_POSTED_LAST_WRNP	(2 << 16)
+#define CAMDMA_CSDP_DST_BURST_EN		(3 << 14)
+#define CAMDMA_CSDP_DST_BURST_EN_1		(0 << 14)
+#define CAMDMA_CSDP_DST_BURST_EN_16		(1 << 14)
+#define CAMDMA_CSDP_DST_BURST_EN_32		(2 << 14)
+#define CAMDMA_CSDP_DST_BURST_EN_64		(3 << 14)
+#define CAMDMA_CSDP_DST_PACKED			(1 << 13)
+#define CAMDMA_CSDP_WR_ADD_TRSLT		(15 << 9)
+#define CAMDMA_CSDP_WR_ADD_TRSLT_ENABLE_MREQADD	(3 <<  9)
+#define CAMDMA_CSDP_SRC_BURST_EN		(3 <<  7)
+#define CAMDMA_CSDP_SRC_BURST_EN_1		(0 <<  7)
+#define CAMDMA_CSDP_SRC_BURST_EN_16		(1 <<  7)
+#define CAMDMA_CSDP_SRC_BURST_EN_32		(2 <<  7)
+#define CAMDMA_CSDP_SRC_BURST_EN_64		(3 <<  7)
+#define CAMDMA_CSDP_SRC_PACKED			(1 <<  6)
+#define CAMDMA_CSDP_RD_ADD_TRSLT		(15 << 2)
+#define CAMDMA_CSDP_RD_ADD_TRSLT_ENABLE_MREQADD	(3 <<  2)
+#define CAMDMA_CSDP_DATA_TYPE			(3 <<  0)
+#define CAMDMA_CSDP_DATA_TYPE_8BITS		(0 <<  0)
+#define CAMDMA_CSDP_DATA_TYPE_16BITS		(1 <<  0)
+#define CAMDMA_CSDP_DATA_TYPE_32BITS		(2 <<  0)
+
+#define CAMMMU_SYSCONFIG_AUTOIDLE		(1 <<  0)
+
+/*
+ *
+ * Declarations.
+ *
+ */
+
+/* forward declarations */
+struct omap24xxcam_sgdma;
+struct omap24xxcam_dma;
+
+typedef void (*sgdma_callback_t)(struct omap24xxcam_sgdma *cam,
+				 u32 status, void *arg);
+typedef void (*dma_callback_t)(struct omap24xxcam_dma *cam,
+			       u32 status, void *arg);
+
+struct channel_state {
+	dma_callback_t callback;
+	void *arg;
+};
+
+/* sgdma state for each of the possible videobuf_buffers + 2 overlays */
+struct sgdma_state {
+	const struct scatterlist *sglist;
+	int sglen;		 /* number of sglist entries */
+	int next_sglist;	 /* index of next sglist entry to process */
+	unsigned int bytes_read; /* number of bytes read */
+	unsigned int len;        /* total length of sglist (excluding
+				  * bytes due to page alignment) */
+	int queued_sglist;	 /* number of sglist entries queued for DMA */
+	u32 csr;		 /* DMA return code */
+	sgdma_callback_t callback;
+	void *arg;
+};
+
+/* physical DMA channel management */
+struct omap24xxcam_dma {
+	spinlock_t lock;	/* Lock for the whole structure. */
+
+	void __iomem *base;	/* base address for dma controller */
+
+	/* While dma_stop!=0, an attempt to start a new DMA transfer will
+	 * fail.
+	 */
+	atomic_t dma_stop;
+	int free_dmach;		/* number of dma channels free */
+	int next_dmach;		/* index of next dma channel to use */
+	struct channel_state ch_state[NUM_CAMDMA_CHANNELS];
+};
+
+/* scatter-gather DMA (scatterlist stuff) management */
+struct omap24xxcam_sgdma {
+	struct omap24xxcam_dma dma;
+
+	spinlock_t lock;	/* Lock for the fields below. */
+	int free_sgdma;		/* number of free sg dma slots */
+	int next_sgdma;		/* index of next sg dma slot to use */
+	struct sgdma_state sg_state[NUM_SG_DMA];
+
+	/* Reset timer data */
+	struct timer_list reset_timer;
+};
+
+/* per-device data structure */
+struct omap24xxcam_device {
+	/*** mutex  ***/
+	/*
+	 * mutex serialises access to this structure. Also camera
+	 * opening and releasing is synchronised by this.
+	 */
+	struct mutex mutex;
+
+	struct v4l2_device v4l2_dev;
+
+	/*** general driver state information ***/
+	atomic_t users;
+	/*
+	 * Lock to serialise core enabling and disabling and access to
+	 * sgdma_in_queue.
+	 */
+	spinlock_t core_enable_disable_lock;
+	/*
+	 * Number or sgdma requests in scatter-gather queue, protected
+	 * by the lock above.
+	 */
+	int sgdma_in_queue;
+	/*
+	 * Sensor interface parameters: interface type, CC_CTRL
+	 * register value and interface specific data.
+	 */
+	int if_type;
+	union {
+		struct parallel {
+			u32 xclk;
+		} bt656;
+	} if_u;
+	u32 cc_ctrl;
+
+	/*** subsystem structures ***/
+	struct omap24xxcam_sgdma sgdma;
+
+	/*** hardware resources ***/
+	unsigned int irq;
+	void __iomem *mmio_base;
+	unsigned long mmio_base_phys;
+	unsigned long mmio_size;
+
+	/*** interfaces and device ***/
+	struct v4l2_int_device *sdev;
+	struct device *dev;
+	struct video_device *vfd;
+
+	/*** camera and sensor reset related stuff ***/
+	struct work_struct sensor_reset_work;
+	/*
+	 * We're in the middle of a reset. Don't enable core if this
+	 * is non-zero! This exists to help decisionmaking in a case
+	 * where videobuf_qbuf is called while we are in the middle of
+	 * a reset.
+	 */
+	atomic_t in_reset;
+	/*
+	 * Non-zero if we don't want any resets for now. Used to
+	 * prevent reset work to run when we're about to stop
+	 * streaming.
+	 */
+	atomic_t reset_disable;
+
+	/*** video device parameters ***/
+	int capture_mem;
+
+	/*** camera module clocks ***/
+	struct clk *fck;
+	struct clk *ick;
+
+	/*** capture data ***/
+	/* file handle, if streaming is on */
+	struct file *streaming;
+};
+
+/* Per-file handle data. */
+struct omap24xxcam_fh {
+	spinlock_t vbq_lock; /* spinlock for the videobuf queue */
+	struct videobuf_queue vbq;
+	struct v4l2_pix_format pix; /* serialise pix by vbq->lock */
+	atomic_t field_count; /* field counter for videobuf_buffer */
+	/* accessing cam here doesn't need serialisation: it's constant */
+	struct omap24xxcam_device *cam;
+};
+
+/*
+ *
+ * Register I/O functions.
+ *
+ */
+
+static inline u32 omap24xxcam_reg_in(u32 __iomem *base, u32 offset)
+{
+	return readl(base + offset);
+}
+
+static inline u32 omap24xxcam_reg_out(u32 __iomem *base, u32 offset,
+					  u32 val)
+{
+	writel(val, base + offset);
+	return val;
+}
+
+static inline u32 omap24xxcam_reg_merge(u32 __iomem *base, u32 offset,
+					    u32 val, u32 mask)
+{
+	u32 __iomem *addr = base + offset;
+	u32 new_val = (readl(addr) & ~mask) | (val & mask);
+
+	writel(new_val, addr);
+	return new_val;
+}
+
+/*
+ *
+ * Function prototypes.
+ *
+ */
+
+/* dma prototypes */
+
+void omap24xxcam_dma_hwinit(struct omap24xxcam_dma *dma);
+void omap24xxcam_dma_isr(struct omap24xxcam_dma *dma);
+
+/* sgdma prototypes */
+
+void omap24xxcam_sgdma_process(struct omap24xxcam_sgdma *sgdma);
+int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
+			    const struct scatterlist *sglist, int sglen,
+			    int len, sgdma_callback_t callback, void *arg);
+void omap24xxcam_sgdma_sync(struct omap24xxcam_sgdma *sgdma);
+void omap24xxcam_sgdma_init(struct omap24xxcam_sgdma *sgdma,
+			    void __iomem *base,
+			    void (*reset_callback)(unsigned long data),
+			    unsigned long reset_callback_data);
+void omap24xxcam_sgdma_exit(struct omap24xxcam_sgdma *sgdma);
+
+#endif
diff --git a/drivers/staging/media/omap24xx/tcm825x.c b/drivers/staging/media/omap24xx/tcm825x.c
new file mode 100644
index 0000000..b1ae8e9
--- /dev/null
+++ b/drivers/staging/media/omap24xx/tcm825x.c
@@ -0,0 +1,937 @@
+/*
+ * drivers/media/i2c/tcm825x.c
+ *
+ * TCM825X camera sensor driver.
+ *
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * Based on code from David Cohen <david.cohen@indt.org.br>
+ *
+ * This driver was based on ov9640 sensor driver from MontaVista
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include "v4l2-int-device.h"
+
+#include "tcm825x.h"
+
+/*
+ * The sensor has two fps modes: the lower one just gives half the fps
+ * at the same xclk than the high one.
+ */
+#define MAX_FPS 30
+#define MIN_FPS 8
+#define MAX_HALF_FPS (MAX_FPS / 2)
+#define HIGH_FPS_MODE_LOWER_LIMIT 14
+#define DEFAULT_FPS MAX_HALF_FPS
+
+struct tcm825x_sensor {
+	const struct tcm825x_platform_data *platform_data;
+	struct v4l2_int_device *v4l2_int_device;
+	struct i2c_client *i2c_client;
+	struct v4l2_pix_format pix;
+	struct v4l2_fract timeperframe;
+};
+
+/* list of image formats supported by TCM825X sensor */
+static const struct v4l2_fmtdesc tcm825x_formats[] = {
+	{
+		.description = "YUYV (YUV 4:2:2), packed",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+	}, {
+		/* Note:  V4L2 defines RGB565 as:
+		 *
+		 *      Byte 0                    Byte 1
+		 *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
+		 *
+		 * We interpret RGB565 as:
+		 *
+		 *      Byte 0                    Byte 1
+		 *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
+		 */
+		.description = "RGB565, le",
+		.pixelformat = V4L2_PIX_FMT_RGB565,
+	},
+};
+
+#define TCM825X_NUM_CAPTURE_FORMATS	ARRAY_SIZE(tcm825x_formats)
+
+/*
+ * TCM825X register configuration for all combinations of pixel format and
+ * image size
+ */
+static const struct tcm825x_reg subqcif	=	{ 0x20, TCM825X_PICSIZ };
+static const struct tcm825x_reg qcif	=	{ 0x18, TCM825X_PICSIZ };
+static const struct tcm825x_reg cif	=	{ 0x14, TCM825X_PICSIZ };
+static const struct tcm825x_reg qqvga	=	{ 0x0c, TCM825X_PICSIZ };
+static const struct tcm825x_reg qvga	=	{ 0x04, TCM825X_PICSIZ };
+static const struct tcm825x_reg vga	=	{ 0x00, TCM825X_PICSIZ };
+
+static const struct tcm825x_reg yuv422	=	{ 0x00, TCM825X_PICFMT };
+static const struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
+
+/* Our own specific controls */
+#define V4L2_CID_ALC				V4L2_CID_PRIVATE_BASE
+#define V4L2_CID_H_EDGE_EN			V4L2_CID_PRIVATE_BASE + 1
+#define V4L2_CID_V_EDGE_EN			V4L2_CID_PRIVATE_BASE + 2
+#define V4L2_CID_LENS				V4L2_CID_PRIVATE_BASE + 3
+#define V4L2_CID_MAX_EXPOSURE_TIME		V4L2_CID_PRIVATE_BASE + 4
+#define V4L2_CID_LAST_PRIV			V4L2_CID_MAX_EXPOSURE_TIME
+
+/*  Video controls  */
+static struct vcontrol {
+	struct v4l2_queryctrl qc;
+	u16 reg;
+	u16 start_bit;
+} video_control[] = {
+	{
+		{
+			.id = V4L2_CID_GAIN,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Gain",
+			.minimum = 0,
+			.maximum = 63,
+			.step = 1,
+		},
+		.reg = TCM825X_AG,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_RED_BALANCE,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Red Balance",
+			.minimum = 0,
+			.maximum = 255,
+			.step = 1,
+		},
+		.reg = TCM825X_MRG,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_BLUE_BALANCE,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Blue Balance",
+			.minimum = 0,
+			.maximum = 255,
+			.step = 1,
+		},
+		.reg = TCM825X_MBG,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_AUTO_WHITE_BALANCE,
+			.type = V4L2_CTRL_TYPE_BOOLEAN,
+			.name = "Auto White Balance",
+			.minimum = 0,
+			.maximum = 1,
+			.step = 0,
+		},
+		.reg = TCM825X_AWBSW,
+		.start_bit = 7,
+	},
+	{
+		{
+			.id = V4L2_CID_EXPOSURE,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Exposure Time",
+			.minimum = 0,
+			.maximum = 0x1fff,
+			.step = 1,
+		},
+		.reg = TCM825X_ESRSPD_U,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_HFLIP,
+			.type = V4L2_CTRL_TYPE_BOOLEAN,
+			.name = "Mirror Image",
+			.minimum = 0,
+			.maximum = 1,
+			.step = 0,
+		},
+		.reg = TCM825X_H_INV,
+		.start_bit = 6,
+	},
+	{
+		{
+			.id = V4L2_CID_VFLIP,
+			.type = V4L2_CTRL_TYPE_BOOLEAN,
+			.name = "Vertical Flip",
+			.minimum = 0,
+			.maximum = 1,
+			.step = 0,
+		},
+		.reg = TCM825X_V_INV,
+		.start_bit = 7,
+	},
+	/* Private controls */
+	{
+		{
+			.id = V4L2_CID_ALC,
+			.type = V4L2_CTRL_TYPE_BOOLEAN,
+			.name = "Auto Luminance Control",
+			.minimum = 0,
+			.maximum = 1,
+			.step = 0,
+		},
+		.reg = TCM825X_ALCSW,
+		.start_bit = 7,
+	},
+	{
+		{
+			.id = V4L2_CID_H_EDGE_EN,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Horizontal Edge Enhancement",
+			.minimum = 0,
+			.maximum = 0xff,
+			.step = 1,
+		},
+		.reg = TCM825X_HDTG,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_V_EDGE_EN,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Vertical Edge Enhancement",
+			.minimum = 0,
+			.maximum = 0xff,
+			.step = 1,
+		},
+		.reg = TCM825X_VDTG,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_LENS,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Lens Shading Compensation",
+			.minimum = 0,
+			.maximum = 0x3f,
+			.step = 1,
+		},
+		.reg = TCM825X_LENS,
+		.start_bit = 0,
+	},
+	{
+		{
+			.id = V4L2_CID_MAX_EXPOSURE_TIME,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Maximum Exposure Time",
+			.minimum = 0,
+			.maximum = 0x3,
+			.step = 1,
+		},
+		.reg = TCM825X_ESRLIM,
+		.start_bit = 5,
+	},
+};
+
+
+static const struct tcm825x_reg *tcm825x_siz_reg[NUM_IMAGE_SIZES] =
+{ &subqcif, &qqvga, &qcif, &qvga, &cif, &vga };
+
+static const struct tcm825x_reg *tcm825x_fmt_reg[NUM_PIXEL_FORMATS] =
+{ &yuv422, &rgb565 };
+
+/*
+ * Read a value from a register in an TCM825X sensor device.  The value is
+ * returned in 'val'.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int tcm825x_read_reg(struct i2c_client *client, int reg)
+{
+	int err;
+	struct i2c_msg msg[2];
+	u8 reg_buf, data_buf = 0;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = &reg_buf;
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 1;
+	msg[1].buf = &data_buf;
+
+	reg_buf = reg;
+
+	err = i2c_transfer(client->adapter, msg, 2);
+	if (err < 0)
+		return err;
+	return data_buf;
+}
+
+/*
+ * Write a value to a register in an TCM825X sensor device.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int tcm825x_write_reg(struct i2c_client *client, u8 reg, u8 val)
+{
+	int err;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = 2;
+	msg->buf = data;
+	data[0] = reg;
+	data[1] = val;
+	err = i2c_transfer(client->adapter, msg, 1);
+	if (err >= 0)
+		return 0;
+	return err;
+}
+
+static int __tcm825x_write_reg_mask(struct i2c_client *client,
+				    u8 reg, u8 val, u8 mask)
+{
+	int rc;
+
+	/* need to do read - modify - write */
+	rc = tcm825x_read_reg(client, reg);
+	if (rc < 0)
+		return rc;
+
+	rc &= (~mask);	/* Clear the masked bits */
+	val &= mask;	/* Enforce mask on value */
+	val |= rc;
+
+	/* write the new value to the register */
+	rc = tcm825x_write_reg(client, reg, val);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+#define tcm825x_write_reg_mask(client, regmask, val)			\
+	__tcm825x_write_reg_mask(client, TCM825X_ADDR((regmask)), val,	\
+				 TCM825X_MASK((regmask)))
+
+
+/*
+ * Initialize a list of TCM825X registers.
+ * The list of registers is terminated by the pair of values
+ * { TCM825X_REG_TERM, TCM825X_VAL_TERM }.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int tcm825x_write_default_regs(struct i2c_client *client,
+				      const struct tcm825x_reg *reglist)
+{
+	int err;
+	const struct tcm825x_reg *next = reglist;
+
+	while (!((next->reg == TCM825X_REG_TERM)
+		 && (next->val == TCM825X_VAL_TERM))) {
+		err = tcm825x_write_reg(client, next->reg, next->val);
+		if (err) {
+			dev_err(&client->dev, "register writing failed\n");
+			return err;
+		}
+		next++;
+	}
+
+	return 0;
+}
+
+static struct vcontrol *find_vctrl(int id)
+{
+	int i;
+
+	if (id < V4L2_CID_BASE)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(video_control); i++)
+		if (video_control[i].qc.id == id)
+			return &video_control[i];
+
+	return NULL;
+}
+
+/*
+ * Find the best match for a requested image capture size.  The best match
+ * is chosen as the nearest match that has the same number or fewer pixels
+ * as the requested size, or the smallest image size if the requested size
+ * has fewer pixels than the smallest image.
+ */
+static enum image_size tcm825x_find_size(struct v4l2_int_device *s,
+					 unsigned int width,
+					 unsigned int height)
+{
+	enum image_size isize;
+	unsigned long pixels = width * height;
+	struct tcm825x_sensor *sensor = s->priv;
+
+	for (isize = subQCIF; isize < VGA; isize++) {
+		if (tcm825x_sizes[isize + 1].height
+		    * tcm825x_sizes[isize + 1].width > pixels) {
+			dev_dbg(&sensor->i2c_client->dev, "size %d\n", isize);
+
+			return isize;
+		}
+	}
+
+	dev_dbg(&sensor->i2c_client->dev, "format default VGA\n");
+
+	return VGA;
+}
+
+/*
+ * Configure the TCM825X for current image size, pixel format, and
+ * frame period. fper is the frame period (in seconds) expressed as a
+ * fraction. Returns zero if successful, or non-zero otherwise. The
+ * actual frame period is returned in fper.
+ */
+static int tcm825x_configure(struct v4l2_int_device *s)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct v4l2_pix_format *pix = &sensor->pix;
+	enum image_size isize = tcm825x_find_size(s, pix->width, pix->height);
+	struct v4l2_fract *fper = &sensor->timeperframe;
+	enum pixel_format pfmt;
+	int err;
+	u32 tgt_fps;
+	u8 val;
+
+	/* common register initialization */
+	err = tcm825x_write_default_regs(
+		sensor->i2c_client, sensor->platform_data->default_regs());
+	if (err)
+		return err;
+
+	/* configure image size */
+	val = tcm825x_siz_reg[isize]->val;
+	dev_dbg(&sensor->i2c_client->dev,
+		"configuring image size %d\n", isize);
+	err = tcm825x_write_reg_mask(sensor->i2c_client,
+				     tcm825x_siz_reg[isize]->reg, val);
+	if (err)
+		return err;
+
+	/* configure pixel format */
+	switch (pix->pixelformat) {
+	default:
+	case V4L2_PIX_FMT_RGB565:
+		pfmt = RGB565;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		pfmt = YUV422;
+		break;
+	}
+
+	dev_dbg(&sensor->i2c_client->dev,
+		"configuring pixel format %d\n", pfmt);
+	val = tcm825x_fmt_reg[pfmt]->val;
+
+	err = tcm825x_write_reg_mask(sensor->i2c_client,
+				     tcm825x_fmt_reg[pfmt]->reg, val);
+	if (err)
+		return err;
+
+	/*
+	 * For frame rate < 15, the FPS reg (addr 0x02, bit 7) must be
+	 * set. Frame rate will be halved from the normal.
+	 */
+	tgt_fps = fper->denominator / fper->numerator;
+	if (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) {
+		val = tcm825x_read_reg(sensor->i2c_client, 0x02);
+		val |= 0x80;
+		tcm825x_write_reg(sensor->i2c_client, 0x02, val);
+	}
+
+	return 0;
+}
+
+static int ioctl_queryctrl(struct v4l2_int_device *s,
+				struct v4l2_queryctrl *qc)
+{
+	struct vcontrol *control;
+
+	control = find_vctrl(qc->id);
+
+	if (control == NULL)
+		return -EINVAL;
+
+	*qc = control->qc;
+
+	return 0;
+}
+
+static int ioctl_g_ctrl(struct v4l2_int_device *s,
+			     struct v4l2_control *vc)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct i2c_client *client = sensor->i2c_client;
+	int val, r;
+	struct vcontrol *lvc;
+
+	/* exposure time is special, spread across 2 registers */
+	if (vc->id == V4L2_CID_EXPOSURE) {
+		int val_lower, val_upper;
+
+		val_upper = tcm825x_read_reg(client,
+					     TCM825X_ADDR(TCM825X_ESRSPD_U));
+		if (val_upper < 0)
+			return val_upper;
+		val_lower = tcm825x_read_reg(client,
+					     TCM825X_ADDR(TCM825X_ESRSPD_L));
+		if (val_lower < 0)
+			return val_lower;
+
+		vc->value = ((val_upper & 0x1f) << 8) | (val_lower);
+		return 0;
+	}
+
+	lvc = find_vctrl(vc->id);
+	if (lvc == NULL)
+		return -EINVAL;
+
+	r = tcm825x_read_reg(client, TCM825X_ADDR(lvc->reg));
+	if (r < 0)
+		return r;
+	val = r & TCM825X_MASK(lvc->reg);
+	val >>= lvc->start_bit;
+
+	if (val < 0)
+		return val;
+
+	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
+		val ^= sensor->platform_data->is_upside_down();
+
+	vc->value = val;
+	return 0;
+}
+
+static int ioctl_s_ctrl(struct v4l2_int_device *s,
+			     struct v4l2_control *vc)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct i2c_client *client = sensor->i2c_client;
+	struct vcontrol *lvc;
+	int val = vc->value;
+
+	/* exposure time is special, spread across 2 registers */
+	if (vc->id == V4L2_CID_EXPOSURE) {
+		int val_lower, val_upper;
+		val_lower = val & TCM825X_MASK(TCM825X_ESRSPD_L);
+		val_upper = (val >> 8) & TCM825X_MASK(TCM825X_ESRSPD_U);
+
+		if (tcm825x_write_reg_mask(client,
+					   TCM825X_ESRSPD_U, val_upper))
+			return -EIO;
+
+		if (tcm825x_write_reg_mask(client,
+					   TCM825X_ESRSPD_L, val_lower))
+			return -EIO;
+
+		return 0;
+	}
+
+	lvc = find_vctrl(vc->id);
+	if (lvc == NULL)
+		return -EINVAL;
+
+	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
+		val ^= sensor->platform_data->is_upside_down();
+
+	val = val << lvc->start_bit;
+	if (tcm825x_write_reg_mask(client, lvc->reg, val))
+		return -EIO;
+
+	return 0;
+}
+
+static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
+				   struct v4l2_fmtdesc *fmt)
+{
+	int index = fmt->index;
+
+	switch (fmt->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (index >= TCM825X_NUM_CAPTURE_FORMATS)
+			return -EINVAL;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	fmt->flags = tcm825x_formats[index].flags;
+	strlcpy(fmt->description, tcm825x_formats[index].description,
+		sizeof(fmt->description));
+	fmt->pixelformat = tcm825x_formats[index].pixelformat;
+
+	return 0;
+}
+
+static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
+			     struct v4l2_format *f)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	enum image_size isize;
+	int ifmt;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	isize = tcm825x_find_size(s, pix->width, pix->height);
+	dev_dbg(&sensor->i2c_client->dev, "isize = %d num_capture = %lu\n",
+		isize, (unsigned long)TCM825X_NUM_CAPTURE_FORMATS);
+
+	pix->width = tcm825x_sizes[isize].width;
+	pix->height = tcm825x_sizes[isize].height;
+
+	for (ifmt = 0; ifmt < TCM825X_NUM_CAPTURE_FORMATS; ifmt++)
+		if (pix->pixelformat == tcm825x_formats[ifmt].pixelformat)
+			break;
+
+	if (ifmt == TCM825X_NUM_CAPTURE_FORMATS)
+		ifmt = 0;	/* Default = YUV 4:2:2 */
+
+	pix->pixelformat = tcm825x_formats[ifmt].pixelformat;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = pix->width * TCM825X_BYTES_PER_PIXEL;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->priv = 0;
+	dev_dbg(&sensor->i2c_client->dev, "format = 0x%08x\n",
+		pix->pixelformat);
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_UYVY:
+	default:
+		pix->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	}
+
+	return 0;
+}
+
+static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
+				struct v4l2_format *f)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int rval;
+
+	rval = ioctl_try_fmt_cap(s, f);
+	if (rval)
+		return rval;
+
+	rval = tcm825x_configure(s);
+
+	sensor->pix = *pix;
+
+	return rval;
+}
+
+static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
+				struct v4l2_format *f)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+
+	f->fmt.pix = sensor->pix;
+
+	return 0;
+}
+
+static int ioctl_g_parm(struct v4l2_int_device *s,
+			     struct v4l2_streamparm *a)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct v4l2_captureparm *cparm = &a->parm.capture;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(a, 0, sizeof(*a));
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	cparm->capability = V4L2_CAP_TIMEPERFRAME;
+	cparm->timeperframe = sensor->timeperframe;
+
+	return 0;
+}
+
+static int ioctl_s_parm(struct v4l2_int_device *s,
+			     struct v4l2_streamparm *a)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
+	u32 tgt_fps;	/* target frames per secound */
+	int rval;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if ((timeperframe->numerator == 0)
+	    || (timeperframe->denominator == 0)) {
+		timeperframe->denominator = DEFAULT_FPS;
+		timeperframe->numerator = 1;
+	}
+
+	tgt_fps = timeperframe->denominator / timeperframe->numerator;
+
+	if (tgt_fps > MAX_FPS) {
+		timeperframe->denominator = MAX_FPS;
+		timeperframe->numerator = 1;
+	} else if (tgt_fps < MIN_FPS) {
+		timeperframe->denominator = MIN_FPS;
+		timeperframe->numerator = 1;
+	}
+
+	sensor->timeperframe = *timeperframe;
+
+	rval = tcm825x_configure(s);
+
+	return rval;
+}
+
+static int ioctl_s_power(struct v4l2_int_device *s, int on)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+
+	return sensor->platform_data->power_set(on);
+}
+
+/*
+ * Given the image capture format in pix, the nominal frame period in
+ * timeperframe, calculate the required xclk frequency.
+ *
+ * TCM825X input frequency characteristics are:
+ *     Minimum 11.9 MHz, Typical 24.57 MHz and maximum 25/27 MHz
+ */
+
+static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	struct v4l2_fract *timeperframe = &sensor->timeperframe;
+	u32 tgt_xclk;	/* target xclk */
+	u32 tgt_fps;	/* target frames per secound */
+	int rval;
+
+	rval = sensor->platform_data->ifparm(p);
+	if (rval)
+		return rval;
+
+	tgt_fps = timeperframe->denominator / timeperframe->numerator;
+
+	tgt_xclk = (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) ?
+		(2457 * tgt_fps) / MAX_HALF_FPS :
+		(2457 * tgt_fps) / MAX_FPS;
+	tgt_xclk *= 10000;
+
+	tgt_xclk = min(tgt_xclk, (u32)TCM825X_XCLK_MAX);
+	tgt_xclk = max(tgt_xclk, (u32)TCM825X_XCLK_MIN);
+
+	p->u.bt656.clock_curr = tgt_xclk;
+
+	return 0;
+}
+
+static int ioctl_g_needs_reset(struct v4l2_int_device *s, void *buf)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+
+	return sensor->platform_data->needs_reset(s, buf, &sensor->pix);
+}
+
+static int ioctl_reset(struct v4l2_int_device *s)
+{
+	return -EBUSY;
+}
+
+static int ioctl_init(struct v4l2_int_device *s)
+{
+	return tcm825x_configure(s);
+}
+
+static int ioctl_dev_exit(struct v4l2_int_device *s)
+{
+	return 0;
+}
+
+static int ioctl_dev_init(struct v4l2_int_device *s)
+{
+	struct tcm825x_sensor *sensor = s->priv;
+	int r;
+
+	r = tcm825x_read_reg(sensor->i2c_client, 0x01);
+	if (r < 0)
+		return r;
+	if (r == 0) {
+		dev_err(&sensor->i2c_client->dev, "device not detected\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+static struct v4l2_int_ioctl_desc tcm825x_ioctl_desc[] = {
+	{ vidioc_int_dev_init_num,
+	  (v4l2_int_ioctl_func *)ioctl_dev_init },
+	{ vidioc_int_dev_exit_num,
+	  (v4l2_int_ioctl_func *)ioctl_dev_exit },
+	{ vidioc_int_s_power_num,
+	  (v4l2_int_ioctl_func *)ioctl_s_power },
+	{ vidioc_int_g_ifparm_num,
+	  (v4l2_int_ioctl_func *)ioctl_g_ifparm },
+	{ vidioc_int_g_needs_reset_num,
+	  (v4l2_int_ioctl_func *)ioctl_g_needs_reset },
+	{ vidioc_int_reset_num,
+	  (v4l2_int_ioctl_func *)ioctl_reset },
+	{ vidioc_int_init_num,
+	  (v4l2_int_ioctl_func *)ioctl_init },
+	{ vidioc_int_enum_fmt_cap_num,
+	  (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
+	{ vidioc_int_try_fmt_cap_num,
+	  (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
+	{ vidioc_int_g_fmt_cap_num,
+	  (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
+	{ vidioc_int_s_fmt_cap_num,
+	  (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
+	{ vidioc_int_g_parm_num,
+	  (v4l2_int_ioctl_func *)ioctl_g_parm },
+	{ vidioc_int_s_parm_num,
+	  (v4l2_int_ioctl_func *)ioctl_s_parm },
+	{ vidioc_int_queryctrl_num,
+	  (v4l2_int_ioctl_func *)ioctl_queryctrl },
+	{ vidioc_int_g_ctrl_num,
+	  (v4l2_int_ioctl_func *)ioctl_g_ctrl },
+	{ vidioc_int_s_ctrl_num,
+	  (v4l2_int_ioctl_func *)ioctl_s_ctrl },
+};
+
+static struct v4l2_int_slave tcm825x_slave = {
+	.ioctls = tcm825x_ioctl_desc,
+	.num_ioctls = ARRAY_SIZE(tcm825x_ioctl_desc),
+};
+
+static struct tcm825x_sensor tcm825x;
+
+static struct v4l2_int_device tcm825x_int_device = {
+	.module = THIS_MODULE,
+	.name = TCM825X_NAME,
+	.priv = &tcm825x,
+	.type = v4l2_int_type_slave,
+	.u = {
+		.slave = &tcm825x_slave,
+	},
+};
+
+static int tcm825x_probe(struct i2c_client *client,
+			 const struct i2c_device_id *did)
+{
+	struct tcm825x_sensor *sensor = &tcm825x;
+
+	if (i2c_get_clientdata(client))
+		return -EBUSY;
+
+	sensor->platform_data = client->dev.platform_data;
+
+	if (sensor->platform_data == NULL
+	    || !sensor->platform_data->is_okay())
+		return -ENODEV;
+
+	sensor->v4l2_int_device = &tcm825x_int_device;
+
+	sensor->i2c_client = client;
+	i2c_set_clientdata(client, sensor);
+
+	/* Make the default capture format QVGA RGB565 */
+	sensor->pix.width = tcm825x_sizes[QVGA].width;
+	sensor->pix.height = tcm825x_sizes[QVGA].height;
+	sensor->pix.pixelformat = V4L2_PIX_FMT_RGB565;
+
+	return v4l2_int_device_register(sensor->v4l2_int_device);
+}
+
+static int tcm825x_remove(struct i2c_client *client)
+{
+	struct tcm825x_sensor *sensor = i2c_get_clientdata(client);
+
+	if (!client->adapter)
+		return -ENODEV;	/* our client isn't attached */
+
+	v4l2_int_device_unregister(sensor->v4l2_int_device);
+
+	return 0;
+}
+
+static const struct i2c_device_id tcm825x_id[] = {
+	{ "tcm825x", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tcm825x_id);
+
+static struct i2c_driver tcm825x_i2c_driver = {
+	.driver	= {
+		.name = TCM825X_NAME,
+	},
+	.probe	= tcm825x_probe,
+	.remove	= tcm825x_remove,
+	.id_table = tcm825x_id,
+};
+
+static struct tcm825x_sensor tcm825x = {
+	.timeperframe = {
+		.numerator   = 1,
+		.denominator = DEFAULT_FPS,
+	},
+};
+
+static int __init tcm825x_init(void)
+{
+	int rval;
+
+	rval = i2c_add_driver(&tcm825x_i2c_driver);
+	if (rval)
+		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
+		       __func__);
+
+	return rval;
+}
+
+static void __exit tcm825x_exit(void)
+{
+	i2c_del_driver(&tcm825x_i2c_driver);
+}
+
+/*
+ * FIXME: Menelaus isn't ready (?) at module_init stage, so use
+ * late_initcall for now.
+ */
+late_initcall(tcm825x_init);
+module_exit(tcm825x_exit);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
+MODULE_DESCRIPTION("TCM825x camera sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/omap24xx/tcm825x.h b/drivers/staging/media/omap24xx/tcm825x.h
new file mode 100644
index 0000000..e2d1bcd
--- /dev/null
+++ b/drivers/staging/media/omap24xx/tcm825x.h
@@ -0,0 +1,200 @@
+/*
+ * drivers/media/i2c/tcm825x.h
+ *
+ * Register definitions for the TCM825X CameraChip.
+ *
+ * Author: David Cohen (david.cohen@indt.org.br)
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ * This file was based on ov9640.h from MontaVista
+ */
+
+#ifndef TCM825X_H
+#define TCM825X_H
+
+#include <linux/videodev2.h>
+
+#include "v4l2-int-device.h"
+
+#define TCM825X_NAME "tcm825x"
+
+#define TCM825X_MASK(x)  x & 0x00ff
+#define TCM825X_ADDR(x) (x & 0xff00) >> 8
+
+/* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
+#define TCM825X_I2C_ADDR	0x3d
+
+/*
+ * define register offsets for the TCM825X sensor chip
+ * OFFSET(8 bits) + MASK(8 bits)
+ * MASK bit 4 and 3 are used when the register uses more than one address
+ */
+#define TCM825X_FPS		0x0280
+#define TCM825X_ACF		0x0240
+#define TCM825X_DOUTBUF		0x020C
+#define TCM825X_DCLKP		0x0202
+#define TCM825X_ACFDET		0x0201
+#define TCM825X_DOUTSW		0x0380
+#define TCM825X_DATAHZ		0x0340
+#define TCM825X_PICSIZ		0x033c
+#define TCM825X_PICFMT		0x0302
+#define TCM825X_V_INV		0x0480
+#define TCM825X_H_INV		0x0440
+#define TCM825X_ESRLSW		0x0430
+#define TCM825X_V_LENGTH	0x040F
+#define TCM825X_ALCSW		0x0580
+#define TCM825X_ESRLIM		0x0560
+#define TCM825X_ESRSPD_U        0x051F
+#define TCM825X_ESRSPD_L        0x06FF
+#define TCM825X_AG		0x07FF
+#define TCM825X_ESRSPD2         0x06FF
+#define TCM825X_ALCMODE         0x0830
+#define TCM825X_ALCH            0x080F
+#define TCM825X_ALCL            0x09FF
+#define TCM825X_AWBSW           0x0A80
+#define TCM825X_MRG             0x0BFF
+#define TCM825X_MBG             0x0CFF
+#define TCM825X_GAMSW           0x0D80
+#define TCM825X_HDTG            0x0EFF
+#define TCM825X_VDTG            0x0FFF
+#define TCM825X_HDTCORE         0x10F0
+#define TCM825X_VDTCORE         0x100F
+#define TCM825X_CONT            0x11FF
+#define TCM825X_BRIGHT          0x12FF
+#define TCM825X_VHUE            0x137F
+#define TCM825X_UHUE            0x147F
+#define TCM825X_VGAIN           0x153F
+#define TCM825X_UGAIN           0x163F
+#define TCM825X_UVCORE          0x170F
+#define TCM825X_SATU            0x187F
+#define TCM825X_MHMODE          0x1980
+#define TCM825X_MHLPFSEL        0x1940
+#define TCM825X_YMODE           0x1930
+#define TCM825X_MIXHG           0x1907
+#define TCM825X_LENS            0x1A3F
+#define TCM825X_AGLIM           0x1BE0
+#define TCM825X_LENSRPOL        0x1B10
+#define TCM825X_LENSRGAIN       0x1B0F
+#define TCM825X_ES100S          0x1CFF
+#define TCM825X_ES120S          0x1DFF
+#define TCM825X_DMASK           0x1EC0
+#define TCM825X_CODESW          0x1E20
+#define TCM825X_CODESEL         0x1E10
+#define TCM825X_TESPIC          0x1E04
+#define TCM825X_PICSEL          0x1E03
+#define TCM825X_HNUM            0x20FF
+#define TCM825X_VOUTPH          0x287F
+#define TCM825X_ESROUT          0x327F
+#define TCM825X_ESROUT2         0x33FF
+#define TCM825X_AGOUT           0x34FF
+#define TCM825X_DGOUT           0x353F
+#define TCM825X_AGSLOW1         0x39C0
+#define TCM825X_FLLSMODE        0x3930
+#define TCM825X_FLLSLIM         0x390F
+#define TCM825X_DETSEL          0x3AF0
+#define TCM825X_ACDETNC         0x3A0F
+#define TCM825X_AGSLOW2         0x3BC0
+#define TCM825X_DG              0x3B3F
+#define TCM825X_REJHLEV         0x3CFF
+#define TCM825X_ALCLOCK         0x3D80
+#define TCM825X_FPSLNKSW        0x3D40
+#define TCM825X_ALCSPD          0x3D30
+#define TCM825X_REJH            0x3D03
+#define TCM825X_SHESRSW         0x3E80
+#define TCM825X_ESLIMSEL        0x3E40
+#define TCM825X_SHESRSPD        0x3E30
+#define TCM825X_ELSTEP          0x3E0C
+#define TCM825X_ELSTART         0x3E03
+#define TCM825X_AGMIN           0x3FFF
+#define TCM825X_PREGRG          0x423F
+#define TCM825X_PREGBG          0x433F
+#define TCM825X_PRERG           0x443F
+#define TCM825X_PREBG           0x453F
+#define TCM825X_MSKBR           0x477F
+#define TCM825X_MSKGR           0x487F
+#define TCM825X_MSKRB           0x497F
+#define TCM825X_MSKGB           0x4A7F
+#define TCM825X_MSKRG           0x4B7F
+#define TCM825X_MSKBG           0x4C7F
+#define TCM825X_HDTCSW          0x4D80
+#define TCM825X_VDTCSW          0x4D40
+#define TCM825X_DTCYL           0x4D3F
+#define TCM825X_HDTPSW          0x4E80
+#define TCM825X_VDTPSW          0x4E40
+#define TCM825X_DTCGAIN         0x4E3F
+#define TCM825X_DTLLIMSW        0x4F10
+#define TCM825X_DTLYLIM         0x4F0F
+#define TCM825X_YLCUTLMSK       0x5080
+#define TCM825X_YLCUTL          0x503F
+#define TCM825X_YLCUTHMSK       0x5180
+#define TCM825X_YLCUTH          0x513F
+#define TCM825X_UVSKNC          0x527F
+#define TCM825X_UVLJ            0x537F
+#define TCM825X_WBGMIN          0x54FF
+#define TCM825X_WBGMAX          0x55FF
+#define TCM825X_WBSPDUP         0x5603
+#define TCM825X_ALLAREA         0x5820
+#define TCM825X_WBLOCK          0x5810
+#define TCM825X_WB2SP           0x580F
+#define TCM825X_KIZUSW          0x5920
+#define TCM825X_PBRSW           0x5910
+#define TCM825X_ABCSW           0x5903
+#define TCM825X_PBDLV           0x5AFF
+#define TCM825X_PBC1LV          0x5BFF
+
+#define TCM825X_NUM_REGS	(TCM825X_ADDR(TCM825X_PBC1LV) + 1)
+
+#define TCM825X_BYTES_PER_PIXEL 2
+
+#define TCM825X_REG_TERM 0xff		/* terminating list entry for reg */
+#define TCM825X_VAL_TERM 0xff		/* terminating list entry for val */
+
+/* define a structure for tcm825x register initialization values */
+struct tcm825x_reg {
+	u8 val;
+	u16 reg;
+};
+
+enum image_size { subQCIF = 0, QQVGA, QCIF, QVGA, CIF, VGA };
+enum pixel_format { YUV422 = 0, RGB565 };
+#define NUM_IMAGE_SIZES 6
+#define NUM_PIXEL_FORMATS 2
+
+#define TCM825X_XCLK_MIN	11900000
+#define TCM825X_XCLK_MAX	25000000
+
+struct capture_size {
+	unsigned long width;
+	unsigned long height;
+};
+
+struct tcm825x_platform_data {
+	/* Is the sensor usable? Doesn't yet mean it's there, but you
+	 * can try! */
+	int (*is_okay)(void);
+	/* Set power state, zero is off, non-zero is on. */
+	int (*power_set)(int power);
+	/* Default registers written after power-on or reset. */
+	const struct tcm825x_reg *(*default_regs)(void);
+	int (*needs_reset)(struct v4l2_int_device *s, void *buf,
+			   struct v4l2_pix_format *fmt);
+	int (*ifparm)(struct v4l2_ifparm *p);
+	int (*is_upside_down)(void);
+};
+
+/* Array of image sizes supported by TCM825X.  These must be ordered from
+ * smallest image size to largest.
+ */
+static const struct capture_size tcm825x_sizes[] = {
+	{ 128,  96 }, /* subQCIF */
+	{ 160, 120 }, /* QQVGA */
+	{ 176, 144 }, /* QCIF */
+	{ 320, 240 }, /* QVGA */
+	{ 352, 288 }, /* CIF */
+	{ 640, 480 }, /* VGA */
+};
+
+#endif /* ifndef TCM825X_H */
diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.c b/drivers/staging/media/omap24xx/v4l2-int-device.c
new file mode 100644
index 0000000..427a890
--- /dev/null
+++ b/drivers/staging/media/omap24xx/v4l2-int-device.c
@@ -0,0 +1,164 @@
+/*
+ * drivers/media/video/v4l2-int-device.c
+ *
+ * V4L2 internal ioctl interface.
+ *
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/sort.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+#include "v4l2-int-device.h"
+
+static DEFINE_MUTEX(mutex);
+static LIST_HEAD(int_list);
+
+void v4l2_int_device_try_attach_all(void)
+{
+	struct v4l2_int_device *m, *s;
+
+	list_for_each_entry(m, &int_list, head) {
+		if (m->type != v4l2_int_type_master)
+			continue;
+
+		list_for_each_entry(s, &int_list, head) {
+			if (s->type != v4l2_int_type_slave)
+				continue;
+
+			/* Slave is connected? */
+			if (s->u.slave->master)
+				continue;
+
+			/* Slave wants to attach to master? */
+			if (s->u.slave->attach_to[0] != 0
+			    && strncmp(m->name, s->u.slave->attach_to,
+				       V4L2NAMESIZE))
+				continue;
+
+			if (!try_module_get(m->module))
+				continue;
+
+			s->u.slave->master = m;
+			if (m->u.master->attach(s)) {
+				s->u.slave->master = NULL;
+				module_put(m->module);
+				continue;
+			}
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(v4l2_int_device_try_attach_all);
+
+static int ioctl_sort_cmp(const void *a, const void *b)
+{
+	const struct v4l2_int_ioctl_desc *d1 = a, *d2 = b;
+
+	if (d1->num > d2->num)
+		return 1;
+
+	if (d1->num < d2->num)
+		return -1;
+
+	return 0;
+}
+
+int v4l2_int_device_register(struct v4l2_int_device *d)
+{
+	if (d->type == v4l2_int_type_slave)
+		sort(d->u.slave->ioctls, d->u.slave->num_ioctls,
+		     sizeof(struct v4l2_int_ioctl_desc),
+		     &ioctl_sort_cmp, NULL);
+	mutex_lock(&mutex);
+	list_add(&d->head, &int_list);
+	v4l2_int_device_try_attach_all();
+	mutex_unlock(&mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_int_device_register);
+
+void v4l2_int_device_unregister(struct v4l2_int_device *d)
+{
+	mutex_lock(&mutex);
+	list_del(&d->head);
+	if (d->type == v4l2_int_type_slave
+	    && d->u.slave->master != NULL) {
+		d->u.slave->master->u.master->detach(d);
+		module_put(d->u.slave->master->module);
+		d->u.slave->master = NULL;
+	}
+	mutex_unlock(&mutex);
+}
+EXPORT_SYMBOL_GPL(v4l2_int_device_unregister);
+
+/* Adapted from search_extable in extable.c. */
+static v4l2_int_ioctl_func *find_ioctl(struct v4l2_int_slave *slave, int cmd,
+				       v4l2_int_ioctl_func *no_such_ioctl)
+{
+	const struct v4l2_int_ioctl_desc *first = slave->ioctls;
+	const struct v4l2_int_ioctl_desc *last =
+		first + slave->num_ioctls - 1;
+
+	while (first <= last) {
+		const struct v4l2_int_ioctl_desc *mid;
+
+		mid = (last - first) / 2 + first;
+
+		if (mid->num < cmd)
+			first = mid + 1;
+		else if (mid->num > cmd)
+			last = mid - 1;
+		else
+			return mid->func;
+	}
+
+	return no_such_ioctl;
+}
+
+static int no_such_ioctl_0(struct v4l2_int_device *d)
+{
+	return -ENOIOCTLCMD;
+}
+
+int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd)
+{
+	return ((v4l2_int_ioctl_func_0 *)
+		find_ioctl(d->u.slave, cmd,
+			   (v4l2_int_ioctl_func *)no_such_ioctl_0))(d);
+}
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_0);
+
+static int no_such_ioctl_1(struct v4l2_int_device *d, void *arg)
+{
+	return -ENOIOCTLCMD;
+}
+
+int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg)
+{
+	return ((v4l2_int_ioctl_func_1 *)
+		find_ioctl(d->u.slave, cmd,
+			   (v4l2_int_ioctl_func *)no_such_ioctl_1))(d, arg);
+}
+EXPORT_SYMBOL_GPL(v4l2_int_ioctl_1);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
new file mode 100644
index 0000000..0286c95
--- /dev/null
+++ b/drivers/staging/media/omap24xx/v4l2-int-device.h
@@ -0,0 +1,305 @@
+/*
+ * include/media/v4l2-int-device.h
+ *
+ * V4L2 internal ioctl interface.
+ *
+ * Copyright (C) 2007 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef V4L2_INT_DEVICE_H
+#define V4L2_INT_DEVICE_H
+
+#include <media/v4l2-common.h>
+
+#define V4L2NAMESIZE 32
+
+/*
+ *
+ * The internal V4L2 device interface core.
+ *
+ */
+
+enum v4l2_int_type {
+	v4l2_int_type_master = 1,
+	v4l2_int_type_slave
+};
+
+struct module;
+
+struct v4l2_int_device;
+
+struct v4l2_int_master {
+	int (*attach)(struct v4l2_int_device *slave);
+	void (*detach)(struct v4l2_int_device *slave);
+};
+
+typedef int (v4l2_int_ioctl_func)(struct v4l2_int_device *);
+typedef int (v4l2_int_ioctl_func_0)(struct v4l2_int_device *);
+typedef int (v4l2_int_ioctl_func_1)(struct v4l2_int_device *, void *);
+
+struct v4l2_int_ioctl_desc {
+	int num;
+	v4l2_int_ioctl_func *func;
+};
+
+struct v4l2_int_slave {
+	/* Don't touch master. */
+	struct v4l2_int_device *master;
+
+	char attach_to[V4L2NAMESIZE];
+
+	int num_ioctls;
+	struct v4l2_int_ioctl_desc *ioctls;
+};
+
+struct v4l2_int_device {
+	/* Don't touch head. */
+	struct list_head head;
+
+	struct module *module;
+
+	char name[V4L2NAMESIZE];
+
+	enum v4l2_int_type type;
+	union {
+		struct v4l2_int_master *master;
+		struct v4l2_int_slave *slave;
+	} u;
+
+	void *priv;
+};
+
+void v4l2_int_device_try_attach_all(void);
+
+int v4l2_int_device_register(struct v4l2_int_device *d);
+void v4l2_int_device_unregister(struct v4l2_int_device *d);
+
+int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd);
+int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg);
+
+/*
+ *
+ * Types and definitions for IOCTL commands.
+ *
+ */
+
+enum v4l2_power {
+	V4L2_POWER_OFF = 0,
+	V4L2_POWER_ON,
+	V4L2_POWER_STANDBY,
+};
+
+/* Slave interface type. */
+enum v4l2_if_type {
+	/*
+	 * Parallel 8-, 10- or 12-bit interface, used by for example
+	 * on certain image sensors.
+	 */
+	V4L2_IF_TYPE_BT656,
+};
+
+enum v4l2_if_type_bt656_mode {
+	/*
+	 * Modes without Bt synchronisation codes. Separate
+	 * synchronisation signal lines are used.
+	 */
+	V4L2_IF_TYPE_BT656_MODE_NOBT_8BIT,
+	V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT,
+	V4L2_IF_TYPE_BT656_MODE_NOBT_12BIT,
+	/*
+	 * Use Bt synchronisation codes. The vertical and horizontal
+	 * synchronisation is done based on synchronisation codes.
+	 */
+	V4L2_IF_TYPE_BT656_MODE_BT_8BIT,
+	V4L2_IF_TYPE_BT656_MODE_BT_10BIT,
+};
+
+struct v4l2_if_type_bt656 {
+	/*
+	 * 0: Frame begins when vsync is high.
+	 * 1: Frame begins when vsync changes from low to high.
+	 */
+	unsigned frame_start_on_rising_vs:1;
+	/* Use Bt synchronisation codes for sync correction. */
+	unsigned bt_sync_correct:1;
+	/* Swap every two adjacent image data elements. */
+	unsigned swap:1;
+	/* Inverted latch clock polarity from slave. */
+	unsigned latch_clk_inv:1;
+	/* Hs polarity. 0 is active high, 1 active low. */
+	unsigned nobt_hs_inv:1;
+	/* Vs polarity. 0 is active high, 1 active low. */
+	unsigned nobt_vs_inv:1;
+	enum v4l2_if_type_bt656_mode mode;
+	/* Minimum accepted bus clock for slave (in Hz). */
+	u32 clock_min;
+	/* Maximum accepted bus clock for slave. */
+	u32 clock_max;
+	/*
+	 * Current wish of the slave. May only change in response to
+	 * ioctls that affect image capture.
+	 */
+	u32 clock_curr;
+};
+
+struct v4l2_ifparm {
+	enum v4l2_if_type if_type;
+	union {
+		struct v4l2_if_type_bt656 bt656;
+	} u;
+};
+
+/* IOCTL command numbers. */
+enum v4l2_int_ioctl_num {
+	/*
+	 *
+	 * "Proper" V4L ioctls, as in struct video_device.
+	 *
+	 */
+	vidioc_int_enum_fmt_cap_num = 1,
+	vidioc_int_g_fmt_cap_num,
+	vidioc_int_s_fmt_cap_num,
+	vidioc_int_try_fmt_cap_num,
+	vidioc_int_queryctrl_num,
+	vidioc_int_g_ctrl_num,
+	vidioc_int_s_ctrl_num,
+	vidioc_int_cropcap_num,
+	vidioc_int_g_crop_num,
+	vidioc_int_s_crop_num,
+	vidioc_int_g_parm_num,
+	vidioc_int_s_parm_num,
+	vidioc_int_querystd_num,
+	vidioc_int_s_std_num,
+	vidioc_int_s_video_routing_num,
+
+	/*
+	 *
+	 * Strictly internal ioctls.
+	 *
+	 */
+	/* Initialise the device when slave attaches to the master. */
+	vidioc_int_dev_init_num = 1000,
+	/* Delinitialise the device at slave detach. */
+	vidioc_int_dev_exit_num,
+	/* Set device power state. */
+	vidioc_int_s_power_num,
+	/*
+	* Get slave private data, e.g. platform-specific slave
+	* configuration used by the master.
+	*/
+	vidioc_int_g_priv_num,
+	/* Get slave interface parameters. */
+	vidioc_int_g_ifparm_num,
+	/* Does the slave need to be reset after VIDIOC_DQBUF? */
+	vidioc_int_g_needs_reset_num,
+	vidioc_int_enum_framesizes_num,
+	vidioc_int_enum_frameintervals_num,
+
+	/*
+	 *
+	 * VIDIOC_INT_* ioctls.
+	 *
+	 */
+	/* VIDIOC_INT_RESET */
+	vidioc_int_reset_num,
+	/* VIDIOC_INT_INIT */
+	vidioc_int_init_num,
+
+	/*
+	 *
+	 * Start of private ioctls.
+	 *
+	 */
+	vidioc_int_priv_start_num = 2000,
+};
+
+/*
+ *
+ * IOCTL wrapper functions for better type checking.
+ *
+ */
+
+#define V4L2_INT_WRAPPER_0(name)					\
+	static inline int vidioc_int_##name(struct v4l2_int_device *d)	\
+	{								\
+		return v4l2_int_ioctl_0(d, vidioc_int_##name##_num);	\
+	}								\
+									\
+	static inline struct v4l2_int_ioctl_desc			\
+	vidioc_int_##name##_cb(int (*func)				\
+			       (struct v4l2_int_device *))		\
+	{								\
+		struct v4l2_int_ioctl_desc desc;			\
+									\
+		desc.num = vidioc_int_##name##_num;			\
+		desc.func = (v4l2_int_ioctl_func *)func;		\
+									\
+		return desc;						\
+	}
+
+#define V4L2_INT_WRAPPER_1(name, arg_type, asterisk)			\
+	static inline int vidioc_int_##name(struct v4l2_int_device *d,	\
+					    arg_type asterisk arg)	\
+	{								\
+		return v4l2_int_ioctl_1(d, vidioc_int_##name##_num,	\
+					(void *)(unsigned long)arg);	\
+	}								\
+									\
+	static inline struct v4l2_int_ioctl_desc			\
+	vidioc_int_##name##_cb(int (*func)				\
+			       (struct v4l2_int_device *,		\
+				arg_type asterisk))			\
+	{								\
+		struct v4l2_int_ioctl_desc desc;			\
+									\
+		desc.num = vidioc_int_##name##_num;			\
+		desc.func = (v4l2_int_ioctl_func *)func;		\
+									\
+		return desc;						\
+	}
+
+V4L2_INT_WRAPPER_1(enum_fmt_cap, struct v4l2_fmtdesc, *);
+V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
+V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
+V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
+V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
+V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
+V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
+V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
+V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
+V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
+V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
+V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
+V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
+V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
+
+V4L2_INT_WRAPPER_0(dev_init);
+V4L2_INT_WRAPPER_0(dev_exit);
+V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
+V4L2_INT_WRAPPER_1(g_priv, void, *);
+V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
+V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
+V4L2_INT_WRAPPER_1(enum_framesizes, struct v4l2_frmsizeenum, *);
+V4L2_INT_WRAPPER_1(enum_frameintervals, struct v4l2_frmivalenum, *);
+
+V4L2_INT_WRAPPER_0(reset);
+V4L2_INT_WRAPPER_0(init);
+
+#endif
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
deleted file mode 100644
index 0286c95..0000000
--- a/include/media/v4l2-int-device.h
+++ /dev/null
@@ -1,305 +0,0 @@
-/*
- * include/media/v4l2-int-device.h
- *
- * V4L2 internal ioctl interface.
- *
- * Copyright (C) 2007 Nokia Corporation.
- *
- * Contact: Sakari Ailus <sakari.ailus@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef V4L2_INT_DEVICE_H
-#define V4L2_INT_DEVICE_H
-
-#include <media/v4l2-common.h>
-
-#define V4L2NAMESIZE 32
-
-/*
- *
- * The internal V4L2 device interface core.
- *
- */
-
-enum v4l2_int_type {
-	v4l2_int_type_master = 1,
-	v4l2_int_type_slave
-};
-
-struct module;
-
-struct v4l2_int_device;
-
-struct v4l2_int_master {
-	int (*attach)(struct v4l2_int_device *slave);
-	void (*detach)(struct v4l2_int_device *slave);
-};
-
-typedef int (v4l2_int_ioctl_func)(struct v4l2_int_device *);
-typedef int (v4l2_int_ioctl_func_0)(struct v4l2_int_device *);
-typedef int (v4l2_int_ioctl_func_1)(struct v4l2_int_device *, void *);
-
-struct v4l2_int_ioctl_desc {
-	int num;
-	v4l2_int_ioctl_func *func;
-};
-
-struct v4l2_int_slave {
-	/* Don't touch master. */
-	struct v4l2_int_device *master;
-
-	char attach_to[V4L2NAMESIZE];
-
-	int num_ioctls;
-	struct v4l2_int_ioctl_desc *ioctls;
-};
-
-struct v4l2_int_device {
-	/* Don't touch head. */
-	struct list_head head;
-
-	struct module *module;
-
-	char name[V4L2NAMESIZE];
-
-	enum v4l2_int_type type;
-	union {
-		struct v4l2_int_master *master;
-		struct v4l2_int_slave *slave;
-	} u;
-
-	void *priv;
-};
-
-void v4l2_int_device_try_attach_all(void);
-
-int v4l2_int_device_register(struct v4l2_int_device *d);
-void v4l2_int_device_unregister(struct v4l2_int_device *d);
-
-int v4l2_int_ioctl_0(struct v4l2_int_device *d, int cmd);
-int v4l2_int_ioctl_1(struct v4l2_int_device *d, int cmd, void *arg);
-
-/*
- *
- * Types and definitions for IOCTL commands.
- *
- */
-
-enum v4l2_power {
-	V4L2_POWER_OFF = 0,
-	V4L2_POWER_ON,
-	V4L2_POWER_STANDBY,
-};
-
-/* Slave interface type. */
-enum v4l2_if_type {
-	/*
-	 * Parallel 8-, 10- or 12-bit interface, used by for example
-	 * on certain image sensors.
-	 */
-	V4L2_IF_TYPE_BT656,
-};
-
-enum v4l2_if_type_bt656_mode {
-	/*
-	 * Modes without Bt synchronisation codes. Separate
-	 * synchronisation signal lines are used.
-	 */
-	V4L2_IF_TYPE_BT656_MODE_NOBT_8BIT,
-	V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT,
-	V4L2_IF_TYPE_BT656_MODE_NOBT_12BIT,
-	/*
-	 * Use Bt synchronisation codes. The vertical and horizontal
-	 * synchronisation is done based on synchronisation codes.
-	 */
-	V4L2_IF_TYPE_BT656_MODE_BT_8BIT,
-	V4L2_IF_TYPE_BT656_MODE_BT_10BIT,
-};
-
-struct v4l2_if_type_bt656 {
-	/*
-	 * 0: Frame begins when vsync is high.
-	 * 1: Frame begins when vsync changes from low to high.
-	 */
-	unsigned frame_start_on_rising_vs:1;
-	/* Use Bt synchronisation codes for sync correction. */
-	unsigned bt_sync_correct:1;
-	/* Swap every two adjacent image data elements. */
-	unsigned swap:1;
-	/* Inverted latch clock polarity from slave. */
-	unsigned latch_clk_inv:1;
-	/* Hs polarity. 0 is active high, 1 active low. */
-	unsigned nobt_hs_inv:1;
-	/* Vs polarity. 0 is active high, 1 active low. */
-	unsigned nobt_vs_inv:1;
-	enum v4l2_if_type_bt656_mode mode;
-	/* Minimum accepted bus clock for slave (in Hz). */
-	u32 clock_min;
-	/* Maximum accepted bus clock for slave. */
-	u32 clock_max;
-	/*
-	 * Current wish of the slave. May only change in response to
-	 * ioctls that affect image capture.
-	 */
-	u32 clock_curr;
-};
-
-struct v4l2_ifparm {
-	enum v4l2_if_type if_type;
-	union {
-		struct v4l2_if_type_bt656 bt656;
-	} u;
-};
-
-/* IOCTL command numbers. */
-enum v4l2_int_ioctl_num {
-	/*
-	 *
-	 * "Proper" V4L ioctls, as in struct video_device.
-	 *
-	 */
-	vidioc_int_enum_fmt_cap_num = 1,
-	vidioc_int_g_fmt_cap_num,
-	vidioc_int_s_fmt_cap_num,
-	vidioc_int_try_fmt_cap_num,
-	vidioc_int_queryctrl_num,
-	vidioc_int_g_ctrl_num,
-	vidioc_int_s_ctrl_num,
-	vidioc_int_cropcap_num,
-	vidioc_int_g_crop_num,
-	vidioc_int_s_crop_num,
-	vidioc_int_g_parm_num,
-	vidioc_int_s_parm_num,
-	vidioc_int_querystd_num,
-	vidioc_int_s_std_num,
-	vidioc_int_s_video_routing_num,
-
-	/*
-	 *
-	 * Strictly internal ioctls.
-	 *
-	 */
-	/* Initialise the device when slave attaches to the master. */
-	vidioc_int_dev_init_num = 1000,
-	/* Delinitialise the device at slave detach. */
-	vidioc_int_dev_exit_num,
-	/* Set device power state. */
-	vidioc_int_s_power_num,
-	/*
-	* Get slave private data, e.g. platform-specific slave
-	* configuration used by the master.
-	*/
-	vidioc_int_g_priv_num,
-	/* Get slave interface parameters. */
-	vidioc_int_g_ifparm_num,
-	/* Does the slave need to be reset after VIDIOC_DQBUF? */
-	vidioc_int_g_needs_reset_num,
-	vidioc_int_enum_framesizes_num,
-	vidioc_int_enum_frameintervals_num,
-
-	/*
-	 *
-	 * VIDIOC_INT_* ioctls.
-	 *
-	 */
-	/* VIDIOC_INT_RESET */
-	vidioc_int_reset_num,
-	/* VIDIOC_INT_INIT */
-	vidioc_int_init_num,
-
-	/*
-	 *
-	 * Start of private ioctls.
-	 *
-	 */
-	vidioc_int_priv_start_num = 2000,
-};
-
-/*
- *
- * IOCTL wrapper functions for better type checking.
- *
- */
-
-#define V4L2_INT_WRAPPER_0(name)					\
-	static inline int vidioc_int_##name(struct v4l2_int_device *d)	\
-	{								\
-		return v4l2_int_ioctl_0(d, vidioc_int_##name##_num);	\
-	}								\
-									\
-	static inline struct v4l2_int_ioctl_desc			\
-	vidioc_int_##name##_cb(int (*func)				\
-			       (struct v4l2_int_device *))		\
-	{								\
-		struct v4l2_int_ioctl_desc desc;			\
-									\
-		desc.num = vidioc_int_##name##_num;			\
-		desc.func = (v4l2_int_ioctl_func *)func;		\
-									\
-		return desc;						\
-	}
-
-#define V4L2_INT_WRAPPER_1(name, arg_type, asterisk)			\
-	static inline int vidioc_int_##name(struct v4l2_int_device *d,	\
-					    arg_type asterisk arg)	\
-	{								\
-		return v4l2_int_ioctl_1(d, vidioc_int_##name##_num,	\
-					(void *)(unsigned long)arg);	\
-	}								\
-									\
-	static inline struct v4l2_int_ioctl_desc			\
-	vidioc_int_##name##_cb(int (*func)				\
-			       (struct v4l2_int_device *,		\
-				arg_type asterisk))			\
-	{								\
-		struct v4l2_int_ioctl_desc desc;			\
-									\
-		desc.num = vidioc_int_##name##_num;			\
-		desc.func = (v4l2_int_ioctl_func *)func;		\
-									\
-		return desc;						\
-	}
-
-V4L2_INT_WRAPPER_1(enum_fmt_cap, struct v4l2_fmtdesc, *);
-V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
-V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
-V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
-V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
-V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
-V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
-V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
-V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
-V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
-V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
-V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
-V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
-V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
-V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
-
-V4L2_INT_WRAPPER_0(dev_init);
-V4L2_INT_WRAPPER_0(dev_exit);
-V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
-V4L2_INT_WRAPPER_1(g_priv, void, *);
-V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
-V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
-V4L2_INT_WRAPPER_1(enum_framesizes, struct v4l2_frmsizeenum, *);
-V4L2_INT_WRAPPER_1(enum_frameintervals, struct v4l2_frmivalenum, *);
-
-V4L2_INT_WRAPPER_0(reset);
-V4L2_INT_WRAPPER_0(init);
-
-#endif
-- 
1.8.4.3

