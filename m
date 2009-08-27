Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39054 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751987AbZH0Js7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 05:48:59 -0400
Date: Thu, 27 Aug 2009 11:49:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908271147280.4808@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
 <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To help discussion a bit, here's a current example implementation of the 
imagebus interface, still working to provide a working example.

diff --git a/drivers/media/video/v4l2-imagebus.c b/drivers/media/video/v4l2-imagebus.c
new file mode 100644
index 0000000..d7ddf93
--- /dev/null
+++ b/drivers/media/video/v4l2-imagebus.c
@@ -0,0 +1,142 @@
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
+		.rawformat		= V4L2_PIX_FMT_YUYV,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_YVYU] = {
+		.rawformat		= V4L2_PIX_FMT_YVYU,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_UYVY] = {
+		.rawformat		= V4L2_PIX_FMT_UYVY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY] = {
+		.rawformat		= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8] = {
+		.rawformat		= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16] = {
+		.rawformat		= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.bits_per_sample	= 16,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555] = {
+		.rawformat		= V4L2_PIX_FMT_RGB555,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555X] = {
+		.rawformat		= V4L2_PIX_FMT_RGB555X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565] = {
+		.rawformat		= V4L2_PIX_FMT_RGB565,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565X] = {
+		.rawformat		= V4L2_PIX_FMT_RGB565X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_2X8,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR8] = {
+		.rawformat		= V4L2_PIX_FMT_SBGGR8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGBRG8] = {
+		.rawformat		= V4L2_PIX_FMT_SGBRG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG8] = {
+		.rawformat		= V4L2_PIX_FMT_SGRBG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SRGGB8] = {
+		.rawformat		= V4L2_PIX_FMT_SRGGB8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG10] = {
+		.rawformat		= V4L2_PIX_FMT_SGRBG10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 10,
+		.packing		= V4L2_DATA_PACKING_EXTEND16,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR16] = {
+		.rawformat		= V4L2_PIX_FMT_SBGGR16,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.bits_per_sample	= 16,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_GREY] = {
+		.rawformat		= V4L2_PIX_FMT_GREY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 8,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y16] = {
+		.rawformat		= V4L2_PIX_FMT_Y16,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 16,
+		.packing		= V4L2_DATA_PACKING_NONE,
+		.order			= V4L2_DATA_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y10] = {
+		.rawformat		= V4L2_PIX_FMT_Y10,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.bits_per_sample	= 10,
+		.packing		= V4L2_DATA_PACKING_EXTEND16,
+		.order			= V4L2_DATA_ORDER_LE,
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
diff --git a/include/media/v4l2-imagebus.h b/include/media/v4l2-imagebus.h
new file mode 100644
index 0000000..0c38a95
--- /dev/null
+++ b/include/media/v4l2-imagebus.h
@@ -0,0 +1,65 @@
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
+	V4L2_IMGBUS_FMT_RGB555,
+	V4L2_IMGBUS_FMT_RGB555X,
+	V4L2_IMGBUS_FMT_RGB565,
+	V4L2_IMGBUS_FMT_RGB565X,
+	V4L2_IMGBUS_FMT_SBGGR8,
+	V4L2_IMGBUS_FMT_SGBRG8,
+	V4L2_IMGBUS_FMT_SGRBG8,
+	V4L2_IMGBUS_FMT_SRGGB8,
+	V4L2_IMGBUS_FMT_SGRBG10,
+	V4L2_IMGBUS_FMT_SBGGR16,
+	V4L2_IMGBUS_FMT_GREY,
+	V4L2_IMGBUS_FMT_Y16,
+	V4L2_IMGBUS_FMT_Y10,
+};
+
+/**
+ * struct v4l2_imgbus_pixelfmt - Data format on the image bus
+ * @rawformat:		Fourcc code...
+ * @colorspace:		and colorspace, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @bits_per_sample:	How many bits the bridge has to sample
+ * @packing:		Type of sample-packing, that has to be used
+ * @order:		Sample order when storing in memory
+ */
+struct v4l2_imgbus_pixelfmt {
+	u32				rawformat;
+	enum v4l2_colorspace		colorspace;
+	enum v4l2_imgbus_packing	packing;
+	enum v4l2_imgbus_order		order;
+	u8				bits_per_sample;
+};
+
+const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
+	enum v4l2_imgbus_pixelcode code);
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 81b90d2..a70b164 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-imgbus.h>
 
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
+   enum_src_pixelfmt: enumerate pixel formats provided by a video data source
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -225,6 +228,8 @@ struct v4l2_subdev_video_ops {
 	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
+	int (*enum_imgbus_pixelfmt)(struct v4l2_subdev *sd, int index,
+				    enum v4l2_imgbus_pixelcode *code);
 };
 
 /**

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
