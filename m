Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36957 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754069AbdFMTht (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 15:37:49 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 11/11] [media] vimc: sca: Add scaler
Date: Tue, 13 Jun 2017 16:35:39 -0300
Message-Id: <1497382545-16408-12-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
References: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement scaler and integrated with the core

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v4:
[media] vimc: sca: Add scaler
	- use vimc_colorimetry_clamp
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct
	- use struct vimc_platform_data to retrieve the entity's name

Changes in v3:
[media] vimc: sca: Add scaler
	- Declare frame_size as a local variable
	- s_stream(sd, 1): return 0 if stream is already enabled
	- s_stream(sd, 0): return 0 if stream is already disabled
	- s_stream: add ret variable to propagate return errors
	- structure code to be a module, use platform_driver and component system
	- s/thought/through
	- clamp height and width of the image by an even value
	- if user try to set colorspace to an invalid format, set all
	    colorimetry parameters to _DEFAULT
	- uset _DEFAULT for colorimetry in the default format

Changes in v2:
[media] vimc: sca: Add scaler
	- Add function MEDIA_ENT_F_IO_V4L
	- remove v4l2_dev and dev
	- s/sink_mbus_fmt/sink_fmt
	- remove BUG_ON, remove redundant if else, rewrite TODO, check end of enum
	- rm src_width/height, enum fsize with min and max values
	- set/try fmt
	- remove unecessary include freezer.h
	- core: add bayer boolean in pixel table
	- coding style
	- fix bug in enum frame size
	- check pad types on create
	- return EBUSY when trying to set the format while stream is on
	- remove vsd struct
	- add IS_SRC and IS_SINK macros
	- add sca_mult as a parameter of the module
	- check set_fmt default parameters for quantization, colorspace ...
	- add more dev_dbg


---
 drivers/media/platform/vimc/Makefile      |   3 +-
 drivers/media/platform/vimc/vimc-common.c |  27 ++
 drivers/media/platform/vimc/vimc-common.h |   1 +
 drivers/media/platform/vimc/vimc-scaler.c | 455 ++++++++++++++++++++++++++++++
 4 files changed, 485 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.c

diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
index 4fba8ef..68c5d98 100644
--- a/drivers/media/platform/vimc/Makefile
+++ b/drivers/media/platform/vimc/Makefile
@@ -2,7 +2,8 @@ vimc-objs := vimc-core.o
 vimc_capture-objs := vimc-capture.o
 vimc_common-objs := vimc-common.o
 vimc_debayer-objs := vimc-debayer.o
+vimc_scaler-objs := vimc-scaler.o
 vimc_sensor-objs := vimc-sensor.o
 
 obj-$(CONFIG_VIDEO_VIMC) += vimc.o vimc_capture.o vimc_common.o vimc-debayer.o \
-				vimc_sensor.o
+				vimc_scaler.o vimc_sensor.o
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index da7f2b7..9d63c84 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -20,6 +20,10 @@
 
 #include "vimc-common.h"
 
+/*
+ * NOTE: non-bayer formats need to come first (necessary for enum_mbus_code
+ * in the scaler)
+ */
 static const struct vimc_pix_map vimc_pix_map_list[] = {
 	/* TODO: add all missing formats */
 
@@ -28,16 +32,19 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
 		.code = MEDIA_BUS_FMT_BGR888_1X24,
 		.pixelformat = V4L2_PIX_FMT_BGR24,
 		.bpp = 3,
+		.bayer = false,
 	},
 	{
 		.code = MEDIA_BUS_FMT_RGB888_1X24,
 		.pixelformat = V4L2_PIX_FMT_RGB24,
 		.bpp = 3,
+		.bayer = false,
 	},
 	{
 		.code = MEDIA_BUS_FMT_ARGB8888_1X32,
 		.pixelformat = V4L2_PIX_FMT_ARGB32,
 		.bpp = 4,
+		.bayer = false,
 	},
 
 	/* Bayer formats */
@@ -45,41 +52,49 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
 		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SBGGR8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGBRG8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGRBG8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SRGGB8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pixelformat = V4L2_PIX_FMT_SBGGR10,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
 		.pixelformat = V4L2_PIX_FMT_SGBRG10,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
 		.pixelformat = V4L2_PIX_FMT_SGRBG10,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
 		.pixelformat = V4L2_PIX_FMT_SRGGB10,
 		.bpp = 2,
+		.bayer = true,
 	},
 
 	/* 10bit raw bayer a-law compressed to 8 bits */
@@ -87,21 +102,25 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
 		.code = MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
 		.bpp = 1,
+		.bayer = true,
 	},
 
 	/* 10bit raw bayer DPCM compressed to 8 bits */
@@ -109,41 +128,49 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
 		.code = MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
 		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
 		.bpp = 1,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
 		.pixelformat = V4L2_PIX_FMT_SBGGR12,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
 		.pixelformat = V4L2_PIX_FMT_SGBRG12,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
 		.pixelformat = V4L2_PIX_FMT_SGRBG12,
 		.bpp = 2,
+		.bayer = true,
 	},
 	{
 		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
 		.pixelformat = V4L2_PIX_FMT_SRGGB12,
 		.bpp = 2,
+		.bayer = true,
 	},
 };
 
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 25ba752..dca528a 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -84,6 +84,7 @@ struct vimc_pix_map {
 	unsigned int code;
 	unsigned int bpp;
 	u32 pixelformat;
+	bool bayer;
 };
 
 /**
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
new file mode 100644
index 0000000..604ab2c
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -0,0 +1,455 @@
+/*
+ * vimc-scaler.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/component.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/vmalloc.h>
+#include <linux/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+#include "vimc-common.h"
+
+#define VIMC_SCA_DRV_NAME "vimc-scaler"
+
+static unsigned int sca_mult = 3;
+module_param(sca_mult, uint, 0000);
+MODULE_PARM_DESC(sca_mult, " the image size multiplier");
+
+#define IS_SINK(pad)	(!pad)
+#define IS_SRC(pad)	(pad)
+#define MAX_ZOOM	8
+
+struct vimc_sca_device {
+	struct vimc_ent_device ved;
+	struct v4l2_subdev sd;
+	struct device *dev;
+	/* NOTE: the source fmt is the same as the sink
+	 * with the width and hight multiplied by mult
+	 */
+	struct v4l2_mbus_framefmt sink_fmt;
+	/* Values calculated when the stream starts */
+	u8 *src_frame;
+	unsigned int src_line_size;
+	unsigned int bpp;
+};
+
+static const struct v4l2_mbus_framefmt sink_fmt_default = {
+	.width = 640,
+	.height = 480,
+	.code = MEDIA_BUS_FMT_RGB888_1X24,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_DEFAULT,
+};
+
+static int vimc_sca_init_cfg(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+	unsigned int i;
+
+	mf = v4l2_subdev_get_try_format(sd, cfg, 0);
+	*mf = sink_fmt_default;
+
+	for (i = 1; i < sd->entity.num_pads; i++) {
+		mf = v4l2_subdev_get_try_format(sd, cfg, i);
+		*mf = sink_fmt_default;
+		mf->width = mf->width * sca_mult;
+		mf->height = mf->height * sca_mult;
+	}
+
+	return 0;
+}
+
+static int vimc_sca_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(code->index);
+
+	/* We don't support bayer format */
+	if (!vpix || vpix->bayer)
+		return -EINVAL;
+
+	code->code = vpix->code;
+
+	return 0;
+}
+
+static int vimc_sca_enum_frame_size(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_frame_size_enum *fse)
+{
+	const struct vimc_pix_map *vpix;
+
+	if (fse->index)
+		return -EINVAL;
+
+	/* Only accept code in the pix map table in non bayer format */
+	vpix = vimc_pix_map_by_code(fse->code);
+	if (!vpix || vpix->bayer)
+		return -EINVAL;
+
+	fse->min_width = VIMC_FRAME_MIN_WIDTH;
+	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
+
+	if (IS_SINK(fse->pad)) {
+		fse->max_width = VIMC_FRAME_MAX_WIDTH;
+		fse->max_height = VIMC_FRAME_MAX_HEIGHT;
+	} else {
+		fse->max_width = VIMC_FRAME_MAX_WIDTH * MAX_ZOOM;
+		fse->max_height = VIMC_FRAME_MAX_HEIGHT * MAX_ZOOM;
+	}
+
+	return 0;
+}
+
+static int vimc_sca_get_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
+{
+	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
+
+	/* Get the current sink format */
+	format->format = (format->which == V4L2_SUBDEV_FORMAT_TRY) ?
+			 *v4l2_subdev_get_try_format(sd, cfg, 0) :
+			 vsca->sink_fmt;
+
+	/* Scale the frame size for the source pad */
+	if (IS_SRC(format->pad)) {
+		format->format.width = vsca->sink_fmt.width * sca_mult;
+		format->format.height = vsca->sink_fmt.height * sca_mult;
+	}
+
+	return 0;
+}
+
+static void vimc_sca_adjust_sink_fmt(struct v4l2_mbus_framefmt *fmt)
+{
+	const struct vimc_pix_map *vpix;
+
+	/* Only accept code in the pix map table in non bayer format */
+	vpix = vimc_pix_map_by_code(fmt->code);
+	if (!vpix || vpix->bayer)
+		fmt->code = sink_fmt_default.code;
+
+	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
+			     VIMC_FRAME_MAX_WIDTH) & ~1;
+	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
+			      VIMC_FRAME_MAX_HEIGHT) & ~1;
+
+	if (fmt->field == V4L2_FIELD_ANY)
+		fmt->field = sink_fmt_default.field;
+
+	vimc_colorimetry_clamp(fmt);
+}
+
+static int vimc_sca_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
+{
+	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *sink_fmt;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		/* Do not change the format while stream is on */
+		if (vsca->src_frame)
+			return -EBUSY;
+
+		sink_fmt = &vsca->sink_fmt;
+	} else {
+		sink_fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+	}
+
+	/*
+	 * Do not change the format of the source pad,
+	 * it is propagated from the sink
+	 */
+	if (IS_SRC(fmt->pad)) {
+		fmt->format = *sink_fmt;
+		fmt->format.width = sink_fmt->width * sca_mult;
+		fmt->format.height = sink_fmt->height * sca_mult;
+	} else {
+		/* Set the new format in the sink pad */
+		vimc_sca_adjust_sink_fmt(&fmt->format);
+
+		dev_dbg(vsca->dev, "%s: sink format update: "
+			"old:%dx%d (0x%x, %d, %d, %d, %d) "
+			"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vsca->sd.name,
+			/* old */
+			sink_fmt->width, sink_fmt->height, sink_fmt->code,
+			sink_fmt->colorspace, sink_fmt->quantization,
+			sink_fmt->xfer_func, sink_fmt->ycbcr_enc,
+			/* new */
+			fmt->format.width, fmt->format.height, fmt->format.code,
+			fmt->format.colorspace,	fmt->format.quantization,
+			fmt->format.xfer_func, fmt->format.ycbcr_enc);
+
+		*sink_fmt = fmt->format;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
+	.init_cfg		= vimc_sca_init_cfg,
+	.enum_mbus_code		= vimc_sca_enum_mbus_code,
+	.enum_frame_size	= vimc_sca_enum_frame_size,
+	.get_fmt		= vimc_sca_get_fmt,
+	.set_fmt		= vimc_sca_set_fmt,
+};
+
+static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
+	int ret;
+
+	if (enable) {
+		const struct vimc_pix_map *vpix;
+		unsigned int frame_size;
+
+		if (vsca->src_frame)
+			return 0;
+
+		/* Save the bytes per pixel of the sink */
+		vpix = vimc_pix_map_by_code(vsca->sink_fmt.code);
+		vsca->bpp = vpix->bpp;
+
+		/* Calculate the width in bytes of the src frame */
+		vsca->src_line_size = vsca->sink_fmt.width *
+				      sca_mult * vsca->bpp;
+
+		/* Calculate the frame size of the source pad */
+		frame_size = vsca->src_line_size * vsca->sink_fmt.height *
+			     sca_mult;
+
+		/* Allocate the frame buffer. Use vmalloc to be able to
+		 * allocate a large amount of memory
+		 */
+		vsca->src_frame = vmalloc(frame_size);
+		if (!vsca->src_frame)
+			return -ENOMEM;
+
+		/* Turn the stream on in the subdevices directly connected */
+		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 1);
+		if (ret) {
+			vfree(vsca->src_frame);
+			vsca->src_frame = NULL;
+			return ret;
+		}
+	} else {
+		if (!vsca->src_frame)
+			return 0;
+
+		/* Disable streaming from the pipe */
+		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 0);
+		if (ret)
+			return ret;
+
+		vfree(vsca->src_frame);
+		vsca->src_frame = NULL;
+	}
+
+	return 0;
+}
+
+struct v4l2_subdev_video_ops vimc_sca_video_ops = {
+	.s_stream = vimc_sca_s_stream,
+};
+
+static const struct v4l2_subdev_ops vimc_sca_ops = {
+	.pad = &vimc_sca_pad_ops,
+	.video = &vimc_sca_video_ops,
+};
+
+static void vimc_sca_fill_pix(u8 *const ptr,
+			      const u8 *const pixel,
+			      const unsigned int bpp)
+{
+	unsigned int i;
+
+	/* copy the pixel to the pointer */
+	for (i = 0; i < bpp; i++)
+		ptr[i] = pixel[i];
+}
+
+static void vimc_sca_scale_pix(const struct vimc_sca_device *const vsca,
+			       const unsigned int lin, const unsigned int col,
+			       const u8 *const sink_frame)
+{
+	unsigned int i, j, index;
+	const u8 *pixel;
+
+	/* Point to the pixel value in position (lin, col) in the sink frame */
+	index = VIMC_FRAME_INDEX(lin, col,
+				 vsca->sink_fmt.width,
+				 vsca->bpp);
+	pixel = &sink_frame[index];
+
+	dev_dbg(vsca->dev,
+		"sca: %s: --- scale_pix sink pos %dx%d, index %d ---\n",
+		vsca->sd.name, lin, col, index);
+
+	/* point to the place we are going to put the first pixel
+	 * in the scaled src frame
+	 */
+	index = VIMC_FRAME_INDEX(lin * sca_mult, col * sca_mult,
+				 vsca->sink_fmt.width * sca_mult, vsca->bpp);
+
+	dev_dbg(vsca->dev, "sca: %s: scale_pix src pos %dx%d, index %d\n",
+		vsca->sd.name, lin * sca_mult, col * sca_mult, index);
+
+	/* Repeat this pixel mult times */
+	for (i = 0; i < sca_mult; i++) {
+		/* Iterate through each beginning of a
+		 * pixel repetition in a line
+		 */
+		for (j = 0; j < sca_mult * vsca->bpp; j += vsca->bpp) {
+			dev_dbg(vsca->dev,
+				"sca: %s: sca: scale_pix src pos %d\n",
+				vsca->sd.name, index + j);
+
+			/* copy the pixel to the position index + j */
+			vimc_sca_fill_pix(&vsca->src_frame[index + j],
+					  pixel, vsca->bpp);
+		}
+
+		/* move the index to the next line */
+		index += vsca->src_line_size;
+	}
+}
+
+static void vimc_sca_fill_src_frame(const struct vimc_sca_device *const vsca,
+				    const u8 *const sink_frame)
+{
+	unsigned int i, j;
+
+	/* Scale each pixel from the original sink frame */
+	/* TODO: implement scale down, only scale up is supported for now */
+	for (i = 0; i < vsca->sink_fmt.height; i++)
+		for (j = 0; j < vsca->sink_fmt.width; j++)
+			vimc_sca_scale_pix(vsca, i, j, sink_frame);
+}
+
+static void vimc_sca_process_frame(struct vimc_ent_device *ved,
+				   struct media_pad *sink,
+				   const void *sink_frame)
+{
+	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
+						    ved);
+	unsigned int i;
+
+	/* If the stream in this node is not active, just return */
+	if (!vsca->src_frame)
+		return;
+
+	vimc_sca_fill_src_frame(vsca, sink_frame);
+
+	/* Propagate the frame through all source pads */
+	for (i = 1; i < vsca->sd.entity.num_pads; i++) {
+		struct media_pad *pad = &vsca->sd.entity.pads[i];
+
+		vimc_propagate_frame(pad, vsca->src_frame);
+	}
+};
+
+static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
+				 void *master_data)
+{
+	struct vimc_ent_device *ved = dev_get_drvdata(comp);
+	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
+						    ved);
+
+	vimc_ent_sd_unregister(ved, &vsca->sd);
+	kfree(vsca);
+}
+
+
+static int vimc_sca_comp_bind(struct device *comp, struct device *master,
+			      void *master_data)
+{
+	struct v4l2_device *v4l2_dev = master_data;
+	struct vimc_platform_data *pdata = comp->platform_data;
+	struct vimc_sca_device *vsca;
+	int ret;
+
+	/* Allocate the vsca struct */
+	vsca = kzalloc(sizeof(*vsca), GFP_KERNEL);
+	if (!vsca)
+		return -ENOMEM;
+
+	/* Initialize ved and sd */
+	ret = vimc_ent_sd_register(&vsca->ved, &vsca->sd, v4l2_dev,
+				   pdata->entity_name,
+				   MEDIA_ENT_F_ATV_DECODER, 2,
+				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
+				   MEDIA_PAD_FL_SOURCE},
+				   &vimc_sca_ops);
+	if (ret) {
+		kfree(vsca);
+		return ret;
+	}
+
+	vsca->ved.process_frame = vimc_sca_process_frame;
+	dev_set_drvdata(comp, &vsca->ved);
+	vsca->dev = comp;
+
+	/* Initialize the frame format */
+	vsca->sink_fmt = sink_fmt_default;
+
+	return 0;
+}
+
+static const struct component_ops vimc_sca_comp_ops = {
+	.bind = vimc_sca_comp_bind,
+	.unbind = vimc_sca_comp_unbind,
+};
+
+static int vimc_sca_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &vimc_sca_comp_ops);
+}
+
+static int vimc_sca_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &vimc_sca_comp_ops);
+
+	return 0;
+}
+
+static struct platform_driver vimc_sca_pdrv = {
+	.probe		= vimc_sca_probe,
+	.remove		= vimc_sca_remove,
+	.driver		= {
+		.name	= VIMC_SCA_DRV_NAME,
+	},
+};
+
+static const struct platform_device_id vimc_sca_driver_ids[] = {
+	{
+		.name           = VIMC_SCA_DRV_NAME,
+	},
+	{ }
+};
+
+module_platform_driver(vimc_sca_pdrv);
+
+MODULE_DEVICE_TABLE(platform, vimc_sca_driver_ids);
+
+MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Scaler");
+MODULE_AUTHOR("Helen Mae Koike Fornazier <helen.fornazier@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
2.7.4
