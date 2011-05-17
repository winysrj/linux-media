Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57454 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1EQJ3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 05:29:09 -0400
Received: by wwa36 with SMTP id 36so335730wwa.1
        for <linux-media@vger.kernel.org>; Tue, 17 May 2011 02:29:07 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
Date: Tue, 17 May 2011 11:28:47 +0200
Message-Id: <1305624528-5595-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It has been tested in beagleboard xM, using LI-5M03 module.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/Kconfig     |    8 +
 drivers/media/video/Makefile    |    1 +
 drivers/media/video/mt9p031.c   |  773 +++++++++++++++++++++++++++++++++++++++
 include/media/mt9p031.h         |   11 +
 include/media/v4l2-chip-ident.h |    1 +
 5 files changed, 794 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mt9p031.c
 create mode 100644 include/media/mt9p031.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 00f51dd..32df8bd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -329,6 +329,14 @@ config VIDEO_OV7670
 	  OV7670 VGA camera.  It currently only works with the M88ALP01
 	  controller.
 
+config VIDEO_MT9P031
+	tristate "Micron MT9P031 support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This driver supports MT9P031 cameras from Micron
+	  This is a Video4Linux2 sensor-level driver for the Micron
+	  mt0p031 5 Mpixel camera.
+
 config VIDEO_MT9V011
 	tristate "Micron mt9v011 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ace5d8b..912b29b 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
 obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
+obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
new file mode 100644
index 0000000..850cfec
--- /dev/null
+++ b/drivers/media/video/mt9p031.c
@@ -0,0 +1,773 @@
+/*
+ * Driver for MT9P031 CMOS Image Sensor from Aptina
+ *
+ * Copyright (C) 2011, Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * Based on the MT9V032 driver and Bastian Hecht's code.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/log2.h>
+#include <linux/pm.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+#include <linux/videodev2.h>
+
+#include <media/mt9p031.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+
+/* mt9p031 selected register addresses */
+#define MT9P031_CHIP_VERSION			0x00
+#define		MT9P031_CHIP_VERSION_VALUE	0x1801
+#define MT9P031_ROW_START			0x01
+#define		MT9P031_ROW_START_SKIP		54
+#define MT9P031_COLUMN_START			0x02
+#define		MT9P031_COLUMN_START_SKIP	16
+#define MT9P031_WINDOW_HEIGHT			0x03
+#define MT9P031_WINDOW_WIDTH			0x04
+#define MT9P031_H_BLANKING			0x05
+#define		MT9P031_H_BLANKING_VALUE	0
+#define MT9P031_V_BLANKING			0x06
+#define		MT9P031_V_BLANKING_VALUE	25
+#define MT9P031_OUTPUT_CONTROL			0x07
+#define		MT9P031_OUTPUT_CONTROL_CEN	2
+#define		MT9P031_OUTPUT_CONTROL_SYN	1
+#define MT9P031_SHUTTER_WIDTH_UPPER		0x08
+#define MT9P031_SHUTTER_WIDTH			0x09
+#define MT9P031_PIXEL_CLOCK_CONTROL		0x0a
+#define MT9P031_FRAME_RESTART			0x0b
+#define MT9P031_SHUTTER_DELAY			0x0c
+#define MT9P031_RESET				0x0d
+#define		MT9P031_RESET_ENABLE		1
+#define		MT9P031_RESET_DISABLE		0
+#define MT9P031_READ_MODE_1			0x1e
+#define MT9P031_READ_MODE_2			0x20
+#define		MT9P031_READ_MODE_2_ROW_MIR	0x8000
+#define		MT9P031_READ_MODE_2_COL_MIR	0x4000
+#define MT9P031_ROW_ADDRESS_MODE		0x22
+#define MT9P031_COLUMN_ADDRESS_MODE		0x23
+#define MT9P031_GLOBAL_GAIN			0x35
+
+#define MT9P031_MAX_HEIGHT			1944
+#define MT9P031_MAX_WIDTH			2592
+#define MT9P031_MIN_HEIGHT			2
+#define MT9P031_MIN_WIDTH			18
+
+struct mt9p031 {
+	struct v4l2_subdev subdev;
+	struct media_pad pad;
+	struct v4l2_rect rect;	/* Sensor window */
+	struct v4l2_mbus_framefmt format;
+	struct mt9p031_platform_data *pdata;
+	int model;	/* V4L2_IDENT_MT9P031* codes from v4l2-chip-ident.h */
+	u16 xskip;
+	u16 yskip;
+	struct regulator *reg_1v8, *reg_2v8;
+};
+
+static struct mt9p031 *to_mt9p031(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct mt9p031, subdev);
+}
+
+static int reg_read(struct i2c_client *client, const u8 reg)
+{
+	s32 data = i2c_smbus_read_word_data(client, reg);
+	return data < 0 ? data : swab16(data);
+}
+
+static int reg_write(struct i2c_client *client, const u8 reg,
+		     const u16 data)
+{
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
+}
+
+static int reg_set(struct i2c_client *client, const u8 reg,
+		   const u16 data)
+{
+	int ret;
+
+	ret = reg_read(client, reg);
+	if (ret < 0)
+		return ret;
+	return reg_write(client, reg, ret | data);
+}
+
+static int reg_clear(struct i2c_client *client, const u8 reg,
+		     const u16 data)
+{
+	int ret;
+
+	ret = reg_read(client, reg);
+	if (ret < 0)
+		return ret;
+	return reg_write(client, reg, ret & ~data);
+}
+
+static int mt9p031_idle(struct i2c_client *client)
+{
+	int ret;
+
+	/* Disable chip output, synchronous option update */
+	ret = reg_write(client, MT9P031_RESET, MT9P031_RESET_ENABLE);
+	if (ret < 0)
+		goto err;
+	ret = reg_write(client, MT9P031_RESET, MT9P031_RESET_DISABLE);
+	if (ret < 0)
+		goto err;
+	ret = reg_clear(client, MT9P031_OUTPUT_CONTROL,
+			MT9P031_OUTPUT_CONTROL_CEN);
+	if (ret < 0)
+		goto err;
+	return 0;
+err:
+	return -EIO;
+}
+
+static int mt9p031_power_on(struct mt9p031 *mt9p031)
+{
+	int ret;
+
+	if (mt9p031->pdata->set_xclk)
+		mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);
+	/* turn on VDD_IO */
+	ret = regulator_enable(mt9p031->reg_2v8);
+	if (ret) {
+		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+static void mt9p031_power_off(struct mt9p031 *mt9p031)
+{
+	if (mt9p031->pdata->set_xclk)
+		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
+	regulator_disable(mt9p031->reg_2v8);
+}
+
+static int mt9p031_enum_mbus_code(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	if (code->pad || code->index)
+		return -EINVAL;
+
+	code->code = mt9p031->format.code;
+
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *mt9p031_get_pad_format(
+			struct mt9p031 *mt9p031,
+			struct v4l2_subdev_fh *fh,
+			unsigned int pad, u32 which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &mt9p031->format;
+	default:
+		return NULL;
+	}
+}
+
+static struct v4l2_rect *mt9p031_get_pad_crop(struct mt9p031 *mt9p031,
+			struct v4l2_subdev_fh *fh, unsigned int pad, u32 which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &mt9p031->rect;
+	default:
+		return NULL;
+	}
+}
+
+static int mt9p031_get_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+	struct v4l2_rect *rect = mt9p031_get_pad_crop(mt9p031, fh, crop->pad,
+							crop->which);
+	if (!rect)
+		return -EINVAL;
+
+	crop->rect = *rect;
+
+	return 0;
+}
+
+static u16 mt9p031_skip_for_crop(s32 source, s32 *target, s32 max_skip)
+{
+	unsigned int skip;
+
+	if (source - source / 4 < *target) {
+		*target = source;
+		return 1;
+	}
+
+	skip = DIV_ROUND_CLOSEST(source, *target);
+	if (skip > max_skip)
+		skip = max_skip;
+	*target = 2 * DIV_ROUND_UP(source, 2 * skip);
+
+	return skip;
+}
+
+static int mt9p031_set_params(struct i2c_client *client,
+			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
+{
+	struct mt9p031 *mt9p031 = to_mt9p031(client);
+	int ret;
+	u16 xbin, ybin;
+	const u16 hblank = MT9P031_H_BLANKING_VALUE,
+		vblank = MT9P031_V_BLANKING_VALUE;
+
+	/*
+	 * TODO: Attention! When implementing horizontal flipping, adjust
+	 * alignment according to R2 "Column Start" description in the datasheet
+	 */
+	if (xskip & 1) {
+		xbin = 1;
+		rect->left &= ~3;
+	} else if (xskip & 2) {
+		xbin = 2;
+		rect->left &= ~7;
+	} else {
+		xbin = 4;
+		rect->left &= ~15;
+	}
+
+	ybin = min(yskip, (u16)4);
+
+	rect->top &= ~1;
+
+	/* Disable register update, reconfigure atomically */
+	ret = reg_set(client, MT9P031_OUTPUT_CONTROL,
+				MT9P031_OUTPUT_CONTROL_SYN);
+	if (ret < 0)
+		goto err;
+
+	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
+		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
+
+	/* Blanking and start values - default... */
+	ret = reg_write(client, MT9P031_H_BLANKING, hblank);
+	if (ret < 0)
+		goto err;
+	ret = reg_write(client, MT9P031_V_BLANKING, vblank);
+	if (ret < 0)
+		goto err;
+
+	if (yskip != mt9p031->yskip || xskip != mt9p031->xskip) {
+		/* Binning, skipping */
+		ret = reg_write(client, MT9P031_COLUMN_ADDRESS_MODE,
+					((xbin - 1) << 4) | (xskip - 1));
+		if (ret < 0)
+			goto err;
+		ret = reg_write(client, MT9P031_ROW_ADDRESS_MODE,
+					((ybin - 1) << 4) | (yskip - 1));
+		if (ret < 0)
+			goto err;
+	}
+	dev_dbg(&client->dev, "new physical left %u, top %u\n",
+		rect->left, rect->top);
+
+	ret = reg_write(client, MT9P031_COLUMN_START,
+				rect->left + MT9P031_COLUMN_START_SKIP);
+	if (ret < 0)
+		goto err;
+	ret = reg_write(client, MT9P031_ROW_START,
+				rect->top + MT9P031_ROW_START_SKIP);
+	if (ret < 0)
+		goto err;
+	ret = reg_write(client, MT9P031_WINDOW_WIDTH,
+				rect->width - 1);
+	if (ret < 0)
+		goto err;
+	ret = reg_write(client, MT9P031_WINDOW_HEIGHT,
+				rect->height - 1);
+	if (ret < 0)
+		goto err;
+
+	/* Re-enable register update, commit all changes */
+	ret = reg_clear(client, MT9P031_OUTPUT_CONTROL,
+				MT9P031_OUTPUT_CONTROL_SYN);
+	if (ret < 0)
+		goto err;
+
+	mt9p031->xskip = xskip;
+	mt9p031->yskip = yskip;
+	return ret;
+err:
+	return -1;
+}
+
+static int mt9p031_set_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+	struct v4l2_mbus_framefmt *f;
+	struct v4l2_rect *c;
+	struct v4l2_rect rect;
+	u16 xskip, yskip;
+	s32 width, height;
+	int ret;
+
+	pr_info("%s(%ux%u@%u:%u : %u)\n", __func__,
+			crop->rect.width, crop->rect.height,
+			crop->rect.left, crop->rect.top, crop->which);
+
+	/*
+	 * Clamp the crop rectangle boundaries and align them to a multiple of 2
+	 * pixels.
+	 */
+	rect.width = ALIGN(clamp(crop->rect.width,
+				 MT9P031_MIN_WIDTH, MT9P031_MAX_WIDTH), 2);
+	rect.height = ALIGN(clamp(crop->rect.height,
+				  MT9P031_MIN_HEIGHT, MT9P031_MAX_HEIGHT), 2);
+	rect.left = ALIGN(clamp(crop->rect.left,
+				0, MT9P031_MAX_WIDTH - rect.width), 2);
+	rect.top = ALIGN(clamp(crop->rect.top,
+			       0, MT9P031_MAX_HEIGHT - rect.height), 2);
+
+	c = mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
+
+	if (rect.width != c->width || rect.height != c->height) {
+		/*
+		 * Reset the output image size if the crop rectangle size has
+		 * been modified.
+		 */
+		f = mt9p031_get_pad_format(mt9p031, fh, crop->pad,
+						    crop->which);
+		width = f->width;
+		height = f->height;
+
+		xskip = mt9p031_skip_for_crop(rect.width, &width, 7);
+		yskip = mt9p031_skip_for_crop(rect.height, &height, 8);
+	} else {
+		xskip = mt9p031->xskip;
+		yskip = mt9p031->yskip;
+		f = NULL;
+	}
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = mt9p031_set_params(client, &rect, xskip, yskip);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (f) {
+		f->width = width;
+		f->height = height;
+	}
+
+	*c = rect;
+	crop->rect = rect;
+
+	return 0;
+}
+
+static int mt9p031_get_format(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_format *fmt)
+{
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	fmt->format =
+		*mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
+	return 0;
+}
+
+static u16 mt9p031_skip_for_scale(s32 *source, s32 target,
+					s32 max_skip, s32 max)
+{
+	unsigned int skip;
+
+	if (*source - *source / 4 < target) {
+		*source = target;
+		return 1;
+	}
+
+	skip = min(max, *source + target / 2) / target;
+	if (skip > max_skip)
+		skip = max_skip;
+	*source = target * skip;
+
+	return skip;
+}
+
+static int mt9p031_fmt_validate(struct v4l2_subdev *sd,
+				struct v4l2_subdev_format *fmt)
+{
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+	struct v4l2_mbus_framefmt *format = &fmt->format;
+
+	if (format->code != mt9p031->format.code || fmt->pad)
+		return -EINVAL;
+
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+	format->width = clamp_t(int, ALIGN(format->width, 2), 2,
+						MT9P031_MAX_WIDTH);
+	format->height = clamp_t(int, ALIGN(format->height, 2), 2,
+						MT9P031_MAX_HEIGHT);
+	format->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int mt9p031_set_format(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_format *fmt)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev_format sdf = *fmt;
+	struct v4l2_mbus_framefmt *f, *format = &sdf.format;
+	struct v4l2_rect *c, rect;
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+	u16 xskip, yskip;
+	int ret;
+
+	ret = mt9p031_fmt_validate(sd, &sdf);
+	if (ret < 0)
+		return ret;
+
+	f = mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
+
+	if (f->width != format->width || f->height != format->height) {
+		c = mt9p031_get_pad_crop(mt9p031, fh, fmt->pad, fmt->which);
+
+		rect.width = c->width;
+		rect.height = c->height;
+
+		xskip = mt9p031_skip_for_scale(&rect.width, format->width, 7,
+					       MT9P031_MAX_WIDTH);
+		if (rect.width + c->left > MT9P031_MAX_WIDTH)
+			rect.left = (MT9P031_MAX_WIDTH - rect.width) / 2;
+		else
+			rect.left = c->left;
+		yskip = mt9p031_skip_for_scale(&rect.height, format->height, 8,
+					       MT9P031_MAX_HEIGHT);
+		if (rect.height + c->top > MT9P031_MAX_HEIGHT)
+			rect.top = (MT9P031_MAX_HEIGHT - rect.height) / 2;
+		else
+			rect.top = c->top;
+	} else {
+		xskip = mt9p031->xskip;
+		yskip = mt9p031->yskip;
+		c = NULL;
+	}
+
+	pr_info("%s(%ux%u : %u)\n", __func__,
+		format->width, format->height, fmt->which);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		/* mt9p031_set_params() doesn't change width and height */
+		ret = mt9p031_set_params(client, &rect, xskip, yskip);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (c)
+		*c = rect;
+
+	*f = *format;
+	fmt->format = *format;
+
+	return 0;
+}
+
+static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	if (enable) {
+		/* Switch to master "normal" mode */
+		ret = reg_set(client, MT9P031_OUTPUT_CONTROL,
+			      MT9P031_OUTPUT_CONTROL_CEN);
+	} else {
+		/* Stop sensor readout */
+		ret = reg_clear(client, MT9P031_OUTPUT_CONTROL,
+				MT9P031_OUTPUT_CONTROL_CEN);
+	}
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
+static int mt9p031_video_probe(struct i2c_client *client)
+{
+	struct mt9p031 *mt9p031 = to_mt9p031(client);
+	s32 data;
+	int ret;
+
+	/* Read out the chip version register */
+	data = reg_read(client, MT9P031_CHIP_VERSION);
+
+	switch (data) {
+	case MT9P031_CHIP_VERSION_VALUE:
+		mt9p031->model = V4L2_IDENT_MT9P031;
+		break;
+	default:
+		dev_err(&client->dev,
+			"No MT9P031 chip detected, register read %x\n", data);
+		return -ENODEV;
+	}
+
+	dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", data);
+
+	ret = mt9p031_idle(client);
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to initialise the camera\n");
+
+	return ret;
+}
+
+static int mt9p031_registered(struct v4l2_subdev *sd)
+{
+	struct mt9p031 *mt9p031;
+	mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	mt9p031_power_off(mt9p031);
+	return 0;
+}
+
+static int mt9p031_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct mt9p031 *mt9p031;
+	mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	return mt9p031_power_on(mt9p031);
+}
+
+static int mt9p031_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct mt9p031 *mt9p031;
+
+	mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	mt9p031_power_off(mt9p031);
+	return 0;
+}
+
+static int mt9p031_set_power(struct v4l2_subdev *sd, int on)
+{
+	struct mt9p031 *mt9p031;
+	int ret = 0;
+
+	mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	if (on) {
+		ret = mt9p031_power_on(mt9p031);
+		if (ret) {
+			pr_err("Failed to enable 2.8v regulator: %d\n", ret);
+			goto out;
+		}
+	} else {
+		mt9p031_power_off(mt9p031);
+	}
+out:
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
+	.s_power	= mt9p031_set_power,
+};
+
+static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
+	.s_stream	= mt9p031_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
+	.enum_mbus_code = mt9p031_enum_mbus_code,
+	.get_fmt = mt9p031_get_format,
+	.set_fmt = mt9p031_set_format,
+	.get_crop = mt9p031_get_crop,
+	.set_crop = mt9p031_set_crop,
+};
+
+static struct v4l2_subdev_ops mt9p031_subdev_ops = {
+	.core	= &mt9p031_subdev_core_ops,
+	.video	= &mt9p031_subdev_video_ops,
+	.pad	= &mt9p031_subdev_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops mt9p031_subdev_internal_ops = {
+	.registered = mt9p031_registered,
+	.open = mt9p031_open,
+	.close = mt9p031_close,
+};
+
+static int mt9p031_probe(struct i2c_client *client,
+			 const struct i2c_device_id *did)
+{
+	struct mt9p031 *mt9p031;
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct mt9p031_platform_data *pdata = client->dev.platform_data;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_warn(&adapter->dev,
+			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
+		return -EIO;
+	}
+
+	mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
+	if (!mt9p031)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
+	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
+
+	mt9p031->pdata		= pdata;
+	mt9p031->rect.left	= 0/*MT9P031_COLUMN_SKIP*/;
+	mt9p031->rect.top	= 0/*MT9P031_ROW_SKIP*/;
+	mt9p031->rect.width	= MT9P031_MAX_WIDTH;
+	mt9p031->rect.height	= MT9P031_MAX_HEIGHT;
+
+	mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+
+	mt9p031->format.width = MT9P031_MAX_WIDTH;
+	mt9p031->format.height = MT9P031_MAX_HEIGHT;
+	mt9p031->format.field = V4L2_FIELD_NONE;
+	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
+
+	/* mt9p031_idle() will reset the chip to default. */
+
+	mt9p031->xskip = 1;
+	mt9p031->yskip = 1;
+
+	mt9p031->reg_1v8 = regulator_get(NULL, "cam_1v8");
+	if (IS_ERR(mt9p031->reg_1v8)) {
+		ret = PTR_ERR(mt9p031->reg_1v8);
+		pr_err("Failed 1.8v regulator: %d\n", ret);
+		goto e1v8;
+	}
+
+	mt9p031->reg_2v8 = regulator_get(NULL, "cam_2v8");
+	if (IS_ERR(mt9p031->reg_2v8)) {
+		ret = PTR_ERR(mt9p031->reg_2v8);
+		pr_err("Failed 2.8v regulator: %d\n", ret);
+		goto e2v8;
+	}
+
+	ret = mt9p031_power_on(mt9p031);
+	if (ret) {
+		pr_err("Failed to power on device: %d\n", ret);
+		goto pwron;
+	}
+	/* turn on VDD_IO */
+	ret = regulator_enable(mt9p031->reg_2v8);
+	if (ret) {
+		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
+		goto e2v8en;
+	}
+
+	if (pdata->reset)
+		pdata->reset(sd, 1);
+
+	msleep(50);
+
+	if (pdata->reset)
+		pdata->reset(sd, 0);
+
+	msleep(50);
+
+	ret = mt9p031_video_probe(client);
+	if (ret)
+		goto evprobe;
+
+	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
+	if (ret)
+		goto evprobe;
+
+	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	return ret;
+
+evprobe:
+	regulator_disable(mt9p031->reg_2v8);
+e2v8en:
+	mt9p031_power_off(mt9p031);
+pwron:
+	regulator_put(mt9p031->reg_2v8);
+e2v8:
+	regulator_put(mt9p031->reg_1v8);
+e1v8:
+	kfree(mt9p031);
+	return ret;
+}
+
+static int mt9p031_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	regulator_disable(mt9p031->reg_2v8);
+	regulator_put(mt9p031->reg_2v8);
+	regulator_put(mt9p031->reg_1v8);
+	kfree(mt9p031);
+
+	return 0;
+}
+
+static const struct i2c_device_id mt9p031_id[] = {
+	{ "mt9p031", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, mt9p031_id);
+
+static struct i2c_driver mt9p031_i2c_driver = {
+	.driver = {
+		.name = "mt9p031",
+	},
+	.probe		= mt9p031_probe,
+	.remove		= mt9p031_remove,
+	.id_table	= mt9p031_id,
+};
+
+static int __init mt9p031_mod_init(void)
+{
+	return i2c_add_driver(&mt9p031_i2c_driver);
+}
+
+static void __exit mt9p031_mod_exit(void)
+{
+	i2c_del_driver(&mt9p031_i2c_driver);
+}
+
+module_init(mt9p031_mod_init);
+module_exit(mt9p031_mod_exit);
+
+MODULE_DESCRIPTION("Aptina MT9P031 Camera driver");
+MODULE_AUTHOR("Bastian Hecht <hechtb@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
new file mode 100644
index 0000000..ad37eb3
--- /dev/null
+++ b/include/media/mt9p031.h
@@ -0,0 +1,11 @@
+#ifndef MT9P031_H
+#define MT9P031_H
+
+struct v4l2_subdev;
+
+struct mt9p031_platform_data {
+	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
+	int (*reset)(struct v4l2_subdev *subdev, int active);
+};
+
+#endif
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index b3edb67..97919f2 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -297,6 +297,7 @@ enum {
 	V4L2_IDENT_MT9T112		= 45022,
 	V4L2_IDENT_MT9V111		= 45031,
 	V4L2_IDENT_MT9V112		= 45032,
+	V4L2_IDENT_MT9P031		= 45033,
 
 	/* HV7131R CMOS sensor: just ident 46000 */
 	V4L2_IDENT_HV7131R		= 46000,
-- 
1.7.0.4

