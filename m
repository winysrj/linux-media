Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59446 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751582AbZIBMdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 08:33:45 -0400
Date: Wed, 2 Sep 2009 14:33:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: [PATCH 2/3] v4l: add an image-bus API for configuring v4l2 subdev
 pixel and frame formats
In-Reply-To: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
Message-ID: <Pine.LNX.4.64.0909021430280.6326@axis700.grange>
References: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
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
converted, the API will be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Makefile        |    2 +-
 drivers/media/video/v4l2-imagebus.c |  196 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-imagebus.h       |   80 ++++++++++++++
 include/media/v4l2-subdev.h         |   10 ++-
 4 files changed, 286 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/v4l2-imagebus.c
 create mode 100644 include/media/v4l2-imagebus.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 00fb23e..9b7446a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-imagebus.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-imagebus.c b/drivers/media/video/v4l2-imagebus.c
new file mode 100644
index 0000000..e3dc48b
--- /dev/null
+++ b/drivers/media/video/v4l2-imagebus.c
@@ -0,0 +1,196 @@
+/*
+ * Image Bus API
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
+#include <media/v4l2-imagebus.h>
+
+static const struct v4l2_imgbus_pixelfmt imgbus_fmt[] = {
+	[V4L2_IMGBUS_FMT_YUYV] = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "YUYV",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_YVYU] = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_UYVY] = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.name			= "VYUY in SMPTE170M",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.name			= "VYUY in SMPTE170M, 16bit",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555X] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565X] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR8] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGBRG8] = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 GBRG",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG8] = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SRGGB8] = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 RGGB",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR10] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGBRG10] = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10 GBRG",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG10] = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10 GRBG",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SRGGB10] = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10 RGGB",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_GREY] = {
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y16] = {
+		.fourcc			= V4L2_PIX_FMT_Y16,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey 16bit",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y10] = {
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR10_2X8] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	},
+};
+
+const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
+	enum v4l2_imgbus_pixelcode code)
+{
+	if ((unsigned int)code > ARRAY_SIZE(imgbus_fmt))
+		return NULL;
+	return imgbus_fmt + code;
+}
+EXPORT_SYMBOL(v4l2_imgbus_get_fmtdesc);
+
+s32 v4l2_imgbus_bytes_per_line(u32 width,
+			       const struct v4l2_imgbus_pixelfmt *imgf)
+{
+	switch (imgf->packing) {
+	case V4L2_IMGBUS_PACKING_NONE:
+		return width * imgf->bits_per_sample / 8;
+	case V4L2_IMGBUS_PACKING_2X8:
+	case V4L2_IMGBUS_PACKING_EXTEND16:
+		return width * 2;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(v4l2_imgbus_bytes_per_line);
diff --git a/include/media/v4l2-imagebus.h b/include/media/v4l2-imagebus.h
new file mode 100644
index 0000000..d8c0fb8
--- /dev/null
+++ b/include/media/v4l2-imagebus.h
@@ -0,0 +1,80 @@
+/*
+ * Image Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef V4L2_IMGBUS_H
+#define V4L2_IMGBUS_H
+
+enum v4l2_imgbus_packing {
+	V4L2_IMGBUS_PACKING_NONE,
+	V4L2_IMGBUS_PACKING_2X8,
+	V4L2_IMGBUS_PACKING_EXTEND16,
+};
+
+enum v4l2_imgbus_order {
+	V4L2_IMGBUS_ORDER_LE,
+	V4L2_IMGBUS_ORDER_BE,
+};
+
+enum v4l2_imgbus_pixelcode {
+	V4L2_IMGBUS_FMT_YUYV,
+	V4L2_IMGBUS_FMT_YVYU,
+	V4L2_IMGBUS_FMT_UYVY,
+	V4L2_IMGBUS_FMT_VYUY,
+	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8,
+	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16,
+	V4L2_IMGBUS_FMT_RGB555,
+	V4L2_IMGBUS_FMT_RGB555X,
+	V4L2_IMGBUS_FMT_RGB565,
+	V4L2_IMGBUS_FMT_RGB565X,
+	V4L2_IMGBUS_FMT_SBGGR8,
+	V4L2_IMGBUS_FMT_SGBRG8,
+	V4L2_IMGBUS_FMT_SGRBG8,
+	V4L2_IMGBUS_FMT_SRGGB8,
+	V4L2_IMGBUS_FMT_SBGGR10,
+	V4L2_IMGBUS_FMT_SGBRG10,
+	V4L2_IMGBUS_FMT_SGRBG10,
+	V4L2_IMGBUS_FMT_SRGGB10,
+	V4L2_IMGBUS_FMT_GREY,
+	V4L2_IMGBUS_FMT_Y16,
+	V4L2_IMGBUS_FMT_Y10,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8,
+};
+
+/**
+ * struct v4l2_imgbus_pixelfmt - Data format on the image bus
+ * @fourcc:		Fourcc code...
+ * @colorspace:		and colorspace, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @bits_per_sample:	How many bits the bridge has to sample
+ * @packing:		Type of sample-packing, that has to be used
+ * @order:		Sample order when storing in memory
+ */
+struct v4l2_imgbus_pixelfmt {
+	u32				fourcc;
+	enum v4l2_colorspace		colorspace;
+	const char			*name;
+	enum v4l2_imgbus_packing	packing;
+	enum v4l2_imgbus_order		order;
+	u8				bits_per_sample;
+};
+
+struct v4l2_imgbus_framefmt {
+	__u32				width;
+	__u32				height;
+	enum v4l2_imgbus_pixelcode	code;
+	enum v4l2_field			field;
+};
+
+const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
+	enum v4l2_imgbus_pixelcode code);
+s32 v4l2_imgbus_bytes_per_line(u32 width,
+			       const struct v4l2_imgbus_pixelfmt *imgf);
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 81b90d2..daf8620 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-imagebus.h>
 
 struct v4l2_device;
 struct v4l2_subdev;
@@ -194,7 +195,7 @@ struct v4l2_subdev_audio_ops {
    s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
 	video input devices.
 
-  s_crystal_freq: sets the frequency of the crystal used to generate the
+   s_crystal_freq: sets the frequency of the crystal used to generate the
 	clocks in Hz. An extra flags field allows device specific configuration
 	regarding clock frequency dividers, etc. If not used, then set flags
 	to 0. If the frequency is not supported, then -EINVAL is returned.
@@ -204,6 +205,8 @@ struct v4l2_subdev_audio_ops {
 
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
+
+   enum_imgbus_fmt: enumerate pixel formats provided by a video data source
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -225,6 +228,11 @@ struct v4l2_subdev_video_ops {
 	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
+	int (*enum_imgbus_fmt)(struct v4l2_subdev *sd, int index,
+			       enum v4l2_imgbus_pixelcode *code);
+	int (*g_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
+	int (*try_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
+	int (*s_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
 };
 
 /**
-- 
1.6.2.4

