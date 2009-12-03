Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34505 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755661AbZLCJqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 04:46:44 -0500
Date: Thu, 3 Dec 2009 10:46:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 1/2 v4] v4l: add a media-bus API for configuring v4l2 subdev
 pixel and frame formats
In-Reply-To: <200912022257.33941.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0912031036510.4328@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
 <200912020811.12156.hverkuil@xs4all.nl> <Pine.LNX.4.64.0912020847350.4694@axis700.grange>
 <200912022257.33941.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video subdevices, like cameras, decoders, connect to video bridges over
specialised busses. Data is being transferred over these busses in various
formats, which only loosely correspond to fourcc codes, describing how video
data is stored in RAM. This is not a one-to-one correspondence, therefore we
cannot use fourcc codes to configure subdevice output data formats. This patch
adds codes for several such on-the-bus formats and an API, similar to the
familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for configuring those
codes. After all users of the old API in struct v4l2_subdev_video_ops are
converted, it will be removed. Also add helper routines to support generic
pass-through mode for the soc-camera framework.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v3 -> v4: more comments addressed - thanks! Now based on the current 
linux-next. Hans, as for _nXk suffixes, I preferred to preserve them to 
keep all notation explicit. Without them a format like 
V4L2_MBUS_FMT_SBGGR10 would be ambiguous, whether one of 
V4L2_MBUS_FMT_SBGGR10_2X8_PAD*_?E or the V4L2_MBUS_FMT_SBGGR10_1X10 is 
meant. I also removed struct soc_mbus_datafmt and soc_mbus_find_datafmt() 
upon your request, although I'm not happy having to open-code it in about 
4 drivers. But we can extract that code in a generic routine later. One of 
the important advantages of that struct and function was, that they 
allowed to keep supported formats in drivers centrally at just one 
location, thus being able to add new or remove deprecated formats easily, 
and to avoid long switch-case blocks by just calling one function to 
search in the array.

Thanks
Guennadi

 drivers/media/video/Makefile       |    2 +-
 drivers/media/video/soc_mediabus.c |  157 ++++++++++++++++++++++++++++++++++++
 include/media/soc_mediabus.h       |   65 +++++++++++++++
 include/media/v4l2-mediabus.h      |   61 ++++++++++++++
 include/media/v4l2-subdev.h        |   19 ++++-
 5 files changed, 302 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/soc_mediabus.c
 create mode 100644 include/media/soc_mediabus.h
 create mode 100644 include/media/v4l2-mediabus.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7a2dcc3..e7bc8da 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -149,7 +149,7 @@ obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 # soc-camera host drivers have to be linked after camera drivers
 obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
new file mode 100644
index 0000000..c54cae7
--- /dev/null
+++ b/drivers/media/video/soc_mediabus.c
@@ -0,0 +1,157 @@
+/*
+ * soc-camera media bus helper routines
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/soc_mediabus.h>
+
+#define MBUS_IDX(f) (V4L2_MBUS_FMT_ ## f - V4L2_MBUS_FMT_FIXED - 1)
+
+static const struct soc_mbus_pixelfmt mbus_fmt[] = {
+	[MBUS_IDX(YUYV8_2X8)] = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(YVYU8_2X8)] = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(UYVY8_2X8)] = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(VYUY8_2X8)] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(RGB555_2X8_PADHI_LE)] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(RGB555_2X8_PADHI_BE)] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(RGB565_2X8_LE)] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(RGB565_2X8_BE)] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(SBGGR8_1X8)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(SBGGR10_1X10)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(GREY8_1X8)] = {
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.name			= "Grey",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(Y10_1X10)] = {
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(SBGGR10_2X8_PADHI_LE)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(SBGGR10_2X8_PADLO_LE)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, [MBUS_IDX(SBGGR10_2X8_PADHI_BE)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	}, [MBUS_IDX(SBGGR10_2X8_PADLO_BE)] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+};
+
+s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
+{
+	switch (mf->packing) {
+	case SOC_MBUS_PACKING_NONE:
+		return width * mf->bits_per_sample / 8;
+	case SOC_MBUS_PACKING_2X8_PADHI:
+	case SOC_MBUS_PACKING_2X8_PADLO:
+	case SOC_MBUS_PACKING_EXTEND16:
+		return width * 2;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(soc_mbus_bytes_per_line);
+
+const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
+	enum v4l2_mbus_pixelcode code)
+{
+	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
+		return NULL;
+	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
+}
+EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
+
+static int __init soc_mbus_init(void)
+{
+	return 0;
+}
+
+static void __exit soc_mbus_exit(void)
+{
+}
+
+module_init(soc_mbus_init);
+module_exit(soc_mbus_exit);
+
+MODULE_DESCRIPTION("soc-camera media bus interface");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
new file mode 100644
index 0000000..037cd7b
--- /dev/null
+++ b/include/media/soc_mediabus.h
@@ -0,0 +1,65 @@
+/*
+ * SoC-camera Media Bus API extensions
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SOC_MEDIABUS_H
+#define SOC_MEDIABUS_H
+
+#include <linux/videodev2.h>
+
+#include <media/v4l2-mediabus.h>
+
+/**
+ * enum soc_mbus_packing - data packing types on the media-bus
+ * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM
+ * @SOC_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
+ *				possibly incomplete byte high bits are padding
+ * @SOC_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
+ * @SOC_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
+ *				to 16 bits
+ */
+enum soc_mbus_packing {
+	SOC_MBUS_PACKING_NONE,
+	SOC_MBUS_PACKING_2X8_PADHI,
+	SOC_MBUS_PACKING_2X8_PADLO,
+	SOC_MBUS_PACKING_EXTEND16,
+};
+
+/**
+ * enum soc_mbus_order - sample order on the media bus
+ * @SOC_MBUS_ORDER_LE:		least significant sample first
+ * @SOC_MBUS_ORDER_BE:		most significant sample first
+ */
+enum soc_mbus_order {
+	SOC_MBUS_ORDER_LE,
+	SOC_MBUS_ORDER_BE,
+};
+
+/**
+ * struct soc_mbus_pixelfmt - Data format on the media bus
+ * @name:		Name of the format
+ * @fourcc:		Fourcc code, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @packing:		Type of sample-packing, that has to be used
+ * @order:		Sample order when storing in memory
+ * @bits_per_sample:	How many bits the bridge has to sample
+ */
+struct soc_mbus_pixelfmt {
+	const char		*name;
+	u32			fourcc;
+	enum soc_mbus_packing	packing;
+	enum soc_mbus_order	order;
+	u8			bits_per_sample;
+};
+
+const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
+	enum v4l2_mbus_pixelcode code);
+s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
+
+#endif
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
new file mode 100644
index 0000000..5cf2a6d
--- /dev/null
+++ b/include/media/v4l2-mediabus.h
@@ -0,0 +1,61 @@
+/*
+ * Media Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef V4L2_MEDIABUS_H
+#define V4L2_MEDIABUS_H
+
+/*
+ * These pixel codes uniquely identify data formats on the media bus. Mostly
+ * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
+ * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
+ * data format is fixed. Additionally, "2X8" means that one pixel is transferred
+ * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
+ * transferred over the bus: "LE" means that the least significant bits are
+ * transferred first, "BE" means that the most significant bits are transferred
+ * first, and "PADHI" and "PADLO" define which bits - low or high, in the
+ * incomplete high byte, are filled with padding bits.
+ */
+enum v4l2_mbus_pixelcode {
+	V4L2_MBUS_FMT_FIXED = 1,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	V4L2_MBUS_FMT_RGB565_2X8_LE,
+	V4L2_MBUS_FMT_RGB565_2X8_BE,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_GREY8_1X8,
+	V4L2_MBUS_FMT_Y10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+};
+
+/**
+ * struct v4l2_mbus_framefmt - frame format on the media bus
+ * @width:	frame width
+ * @height:	frame height
+ * @code:	data format code
+ * @field:	used interlacing type
+ * @colorspace:	colorspace of the data
+ */
+struct v4l2_mbus_framefmt {
+	__u32				width;
+	__u32				height;
+	enum v4l2_mbus_pixelcode	code;
+	enum v4l2_field			field;
+	enum v4l2_colorspace		colorspace;
+};
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 544ce87..c53d462 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-mediabus.h>
 
 /* generic v4l2_device notify callback notification values */
 #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
@@ -207,7 +208,7 @@ struct v4l2_subdev_audio_ops {
    s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
 	video input devices.
 
-  s_crystal_freq: sets the frequency of the crystal used to generate the
+   s_crystal_freq: sets the frequency of the crystal used to generate the
 	clocks in Hz. An extra flags field allows device specific configuration
 	regarding clock frequency dividers, etc. If not used, then set flags
 	to 0. If the frequency is not supported, then -EINVAL is returned.
@@ -217,6 +218,14 @@ struct v4l2_subdev_audio_ops {
 
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
+
+   enum_mbus_fmt: enumerate pixel formats, provided by a video data source
+
+   g_mbus_fmt: get the current pixel format, provided by a video data source
+
+   try_mbus_fmt: try to set a pixel format on a video data source
+
+   s_mbus_fmt: set a pixel format on a video data source
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -240,6 +249,14 @@ struct v4l2_subdev_video_ops {
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
+	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, int index,
+			     enum v4l2_mbus_pixelcode *code);
+	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *fmt);
+	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
+			    struct v4l2_mbus_framefmt *fmt);
+	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *fmt);
 };
 
 /**
-- 
1.6.2.4

