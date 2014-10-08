Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbaJHIqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 04:46:46 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400J60B1WKXA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 17:46:45 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
Date: Wed, 08 Oct 2014 10:46:20 +0200
Message-id: <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plugin provides support for the media device on Exynos4 SoC.
Added is also a media device configuration file parser.
The media configuration file is used for conveying information
about media device links that need to be established as well
as V4L2 user control ioctls redirection to a particular
sub-device.

The plugin performs single plane <-> multi plane API conversion,
video pipeline linking and takes care of automatic data format
negotiation for the whole pipeline, after intercepting
VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 configure.ac                                       |    1 +
 lib/Makefile.am                                    |    5 +-
 lib/libv4l-exynos4-camera/Makefile.am              |    7 +
 .../libv4l-devconfig-parser.h                      |  145 ++
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486 ++++++++++++++++++++
 5 files changed, 2642 insertions(+), 2 deletions(-)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c

diff --git a/configure.ac b/configure.ac
index c9b0524..ae653b9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,6 +17,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libdvbv5/Makefile
 	lib/libv4l2rds/Makefile
 	lib/libv4l-mplane/Makefile
+	lib/libv4l-exynos4-camera/Makefile
 
 	utils/Makefile
 	utils/libv4l2util/Makefile
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 3a0e19c..29455ab 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -3,9 +3,10 @@ SUBDIRS = \
 	libv4l2 \
 	libv4l1 \
 	libv4l2rds \
-	libv4l-mplane
+	libv4l-mplane \
+	libv4l-exynos4-camera
 
 if LINUX_OS
 SUBDIRS += \
 	libdvbv5
-endif
\ No newline at end of file
+endif
diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
new file mode 100644
index 0000000..3552ec8
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/Makefile.am
@@ -0,0 +1,7 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
+endif
+
+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c
+libv4l_exynos4_camera_la_CPPFLAGS = -fvisibility=hidden -std=gnu99
+libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
diff --git a/lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h b/lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
new file mode 100644
index 0000000..c56a469
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
@@ -0,0 +1,145 @@
+/*
+ * Parser of media device configuration file.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * The configuration file has to comply with following format:
+ *
+ * Link description entry format:
+ *
+ * link {
+ * <TAB>source_entity: <entity_name><LF>
+ * <TAB>source_pad: <pad_id><LF>
+ * <TAB>sink_entity: <entity_name><LF>
+ * <TAB>sink_pad: <pad_id><LF>
+ * }
+ *
+ * The V4L2 control group format:
+ *
+ * v4l2-controls {
+ * <TAB><control1_name>: <entity_name><LF>
+ * <TAB><control2_name>: <entity_name><LF>
+ * ...
+ * <TAB><controlN_name>: <entity_name><LF>
+ * }
+ *
+ * Example:
+ *
+ * link {
+ *         source_entity: s5p-mipi-csis.0
+ *         source_pad: 1
+ *         sink_entity: FIMC.0
+ *         sink_pad: 0
+ * }
+ *
+ * v4l2-controls {
+ *         Color Effects: S5C73M3
+ *         Saturation: S5C73M3
+ * }
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#ifndef LIBV4L_DEVCONFIG_PARSER_H
+	#define LIBV4L_DEVCONFIG_PARSER_H
+
+#include <libv4l2.h>
+
+#ifdef DEBUG
+#define V4L2_DEVCFG_PARSER_DBG(format, ARG...)\
+	printf("[%s:%d] [%s] " format " \n", __FILE__, __LINE__, __func__, ##ARG)
+#else
+#define V4L2_DEVCFG_PARSER_DBG(format, ARG...)
+#endif
+
+#define V4L2_DEVCFG_PARSER_ERR(format, ARG...)\
+	fprintf(stderr, "Libv4l device config parser: "format "\n", ##ARG)
+
+#define V4L2_DEVCFG_PARSER_LOG(format, ARG...)\
+	fprintf(stdout, "Libv4l device config parser: "format "\n", ##ARG)
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+/*
+ * struct libv4l_media_link_conf - media entity link configuration
+ * @source_entity:	source entity of the link
+ * @source_pad:		source pad id
+ * @sink_entity:	sink entity of the link
+ * @sink_pad:		sink pad id
+ * @next:		pointer to the next data structure in the list
+ */
+struct libv4l_media_link_conf {
+	char *source_entity;
+	int source_pad;
+	char *sink_entity;
+	int sink_pad;
+	struct libv4l_media_link_conf *next;
+};
+
+/*
+ * struct libv4l_media_ctrl_conf - user control to media entity configuration
+ * @control_name:	user control name
+ * @entity_name:	media entity name
+ * @entity:		media entity matched by entity_name
+ * @cid:		user control id
+ * @next:		pointer to the next data structure in the list
+ */
+struct libv4l_media_ctrl_conf {
+	char *control_name;
+	char *entity_name;
+	struct media_entity *entity;
+	int cid;
+	struct libv4l_media_ctrl_conf *next;
+};
+
+/*
+ * struct libv4l_media_device_conf - media device config
+ * @links:	media entity link config
+ * @controls:	user control to media entity config
+ */
+struct libv4l_media_device_conf {
+	struct libv4l_media_link_conf *links;
+	struct libv4l_media_ctrl_conf *controls;
+};
+
+/*
+ * struct libv4l_conf_parser_ctx - parser context
+ * @line_start_pos:	start position of the current line in the file buffer
+ * @line_end:		end position of the current line in the file buffer
+ * @buf_pos:		file buffer position of the currently analyzed character
+ * @buf:		config file buffer
+ * @buf_size:		number of characters in the file buffer
+ */
+struct libv4l_conf_parser_ctx {
+	int line_start_pos;
+	int line_end_pos;
+	int buf_pos;
+	char *buf;
+	int buf_size;
+};
+
+/*
+ * Read configuration file and initialize config argument with the parsed data.
+ * The config's links and controls fields must be released with use of
+ * libv4l_media_conf_release_links and libv4l_media_conf_release_controls
+ * functions respectively.
+ */
+int libv4l_media_conf_read(char *fname, struct libv4l_media_device_conf *config);
+
+void libv4l_media_conf_release_links(struct libv4l_media_link_conf *cfg);
+
+void libv4l_media_conf_release_controls(struct libv4l_media_ctrl_conf *cfg);
+
+#endif /* LIBV4L_DEVCONFIG_PARSER_H */
diff --git a/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
new file mode 100644
index 0000000..d6956d5
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
@@ -0,0 +1,2486 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#include <config.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/kdev_t.h>
+#include <linux/media.h>
+#include <linux/types.h>
+#include <linux/v4l2-subdev.h>
+#include <linux/videodev2.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+
+#include "libv4l-devconfig-parser.h"
+#include "libv4l-plugin.h"
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+#ifdef DEBUG
+#define V4L2_EXYNOS4_DBG(format, ARG...)\
+	printf("[%s:%d] [%s] " format " \n", __FILE__, __LINE__, __func__, ##ARG)
+#else
+#define V4L2_EXYNOS4_DBG(format, ARG...)
+#endif
+
+#define V4L2_EXYNOS4_ERR(format, ARG...)\
+	fprintf(stderr, "Libv4l Exynos4 camera plugin: "format "\n", ##ARG)
+
+#define V4L2_EXYNOS4_LOG(format, ARG...)\
+	fprintf(stdout, "Libv4l Exynos4 camera plugin: "format "\n", ##ARG)
+
+#define SIMPLE_CONVERT_IOCTL(fd, cmd, arg, __struc) ({          \
+	int __ret;                                              \
+	struct __struc *req = arg;                              \
+	uint32_t type = req->type;                              \
+	req->type = convert_type(type);                         \
+	__ret = SYS_IOCTL(fd, cmd, arg);                        \
+	req->type = type;                                       \
+	__ret;                                                  \
+	})
+
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#if HAVE_VISIBILITY
+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
+#else
+#define PLUGIN_PUBLIC
+#endif
+
+#define EXYNOS4_FIMC_DRV	"exynos4-fimc"
+#define EXYNOS4_FIMC_LITE_DRV	"exynos-fimc-lit"
+#define EXYNOS4_FIMC_IS_ISP_DRV	"exynos4-fimc-is"
+#define ENTITY_CAPTURE_SEGMENT	"capture"
+#define EXYNOS4_CAPTURE_CONF	"/var/lib/libv4l/exynos4_capture_conf"
+#define EXYNOS4_FIMC_IS_ISP	"FIMC-IS-ISP"
+#define EXYNOS4_FIMC_PREFIX	"FIMC."
+#define MAX_FMT_NEGO_NUM	50
+
+#define RGB_PX_FMT (1 << 1)
+#define YUV_PX_FMT (1 << 2)
+#define JPEG_PX_FMT (1 << 3)
+#define SENSOR_PX_FMT (1 << 4)
+
+/*
+ * struct mbus_code_meta_pkg - media bus format meta package
+ * @name:		media bus code name
+ * @code:		media bus code
+ * @compat_pix_fmts:	pixel formats compatible with this mbus code
+ * @supported:		indicates if the code is supported by all entities
+			in the pipeline
+ */
+struct mbus_code_meta_pkg {
+	const char *name;
+	enum v4l2_mbus_pixelcode code;
+	int compat_pix_fmts;
+	int supported;
+};
+
+struct mbus_code_meta_pkg mbus_codes[] = {
+	/* RGB */
+	{"RGB444_2X8_PADHI_BE", 0x1001, RGB_PX_FMT},
+	{"RGB444_2X8_PADHI_LE", 0x1002, RGB_PX_FMT},
+	{"RGB555_2X8_PADHI_BE", 0x1003, RGB_PX_FMT},
+	{"RGB555_2X8_PADHI_LE", 0x1004, RGB_PX_FMT},
+	{"BGR565_2X8_BE", 0x1005, RGB_PX_FMT},
+	{"BGR565_2X8_LE", 0x1006, RGB_PX_FMT},
+	{"RGB565_2X8_BE", 0x1007, RGB_PX_FMT},
+	{"RGB565_2X8_LE", 0x1008, RGB_PX_FMT},
+
+	/* YUV (including grey) */
+	{"Y8_1X8", 0x2001, RGB_PX_FMT | YUV_PX_FMT},
+	{"UYVY8_1_5X8", 0x2002, RGB_PX_FMT | YUV_PX_FMT},
+	{"VYUY8_1_5X8", 0x2003, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUYV8_1_5X8", 0x2004, RGB_PX_FMT | YUV_PX_FMT},
+	{"YVYU8_1_5X8", 0x2005, RGB_PX_FMT | YUV_PX_FMT},
+	{"UYVY8_2X8", 0x2006, RGB_PX_FMT | YUV_PX_FMT},
+	{"VYUY8_2X8", 0x2007, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUYV8_2X8", 0x2008, RGB_PX_FMT | YUV_PX_FMT},
+	{"YVYU8_2X8", 0x2009, RGB_PX_FMT | YUV_PX_FMT},
+	{"Y10_1X10", 0x200a, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUYV10_2X10", 0x200b, RGB_PX_FMT | YUV_PX_FMT},
+	{"YVYU10_2X10", 0x200c, RGB_PX_FMT | YUV_PX_FMT},
+	{"Y12_1X12", 0x2013, RGB_PX_FMT | YUV_PX_FMT},
+	{"UYVY8_1X16", 0x200f, RGB_PX_FMT | YUV_PX_FMT},
+	{"VYUY8_1X16", 0x2010, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUYV8_1X16", 0x2011, RGB_PX_FMT | YUV_PX_FMT},
+	{"YVYU8_1X16", 0x2012, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUYV10_1X20", 0x200d, RGB_PX_FMT | YUV_PX_FMT},
+	{"YVYU10_1X20", 0x200e, RGB_PX_FMT | YUV_PX_FMT},
+	{"YUV10_1X30", 0x2016, RGB_PX_FMT | YUV_PX_FMT},
+
+	/* Bayer */
+	{"SBGGR8_1X8", 0x3001, RGB_PX_FMT},
+	{"SGBRG8_1X8", 0x3013, RGB_PX_FMT},
+	{"SGRBG8_1X8", 0x3002, RGB_PX_FMT},
+	{"SRGGB8_1X8", 0x3014, RGB_PX_FMT},
+	{"SBGGR10_DPCM8_1X8", 0x300b, RGB_PX_FMT},
+	{"SGBRG10_DPCM8_1X8", 0x300c, RGB_PX_FMT},
+	{"SGRBG10_DPCM8_1X8", 0x3009, RGB_PX_FMT},
+	{"SRGGB10_DPCM8_1X8", 0x300d, RGB_PX_FMT},
+	{"SBGGR10_2X8_PADHI_BE", 0x3003, RGB_PX_FMT},
+	{"SBGGR10_2X8_PADHI_LE", 0x3004, RGB_PX_FMT},
+	{"SBGGR10_2X8_PADLO_BE", 0x3005, RGB_PX_FMT},
+	{"SBGGR10_2X8_PADLO_LE", 0x3006, RGB_PX_FMT},
+	{"SBGGR10_1X10", 0x3007, RGB_PX_FMT},
+	{"SGBRG10_1X10", 0x300e, RGB_PX_FMT},
+	{"SGRBG10_1X10", 0x300a, RGB_PX_FMT},
+	{"SRGGB10_1X10", 0x300f, RGB_PX_FMT},
+	{"SBGGR12_1X12", 0x3008, RGB_PX_FMT},
+	{"SGBRG12_1X12", 0x3010, RGB_PX_FMT},
+	{"SGRBG12_1X12", 0x3011, RGB_PX_FMT},
+	{"SRGGB12_1X12", 0x3012, RGB_PX_FMT},
+
+	/* JPEG compressed formats */
+	{"JPEG_1X8", 0x4001, JPEG_PX_FMT},
+
+	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
+	{"S5C_UYVY_JPEG_1X8", 0x5001, SENSOR_PX_FMT},
+
+};
+
+unsigned int rgb_px_fmt[] = {
+	V4L2_PIX_FMT_RGB565,
+	V4L2_PIX_FMT_BGR666,
+	V4L2_PIX_FMT_BGR32,
+	V4L2_PIX_FMT_RGB555,
+	V4L2_PIX_FMT_RGB444
+};
+
+unsigned int yuv_px_fmt[] = {
+	V4L2_PIX_FMT_YUYV,
+	V4L2_PIX_FMT_UYVY,
+	V4L2_PIX_FMT_VYUY,
+	V4L2_PIX_FMT_YVYU,
+	V4L2_PIX_FMT_YUV422P,
+	V4L2_PIX_FMT_NV16,
+	V4L2_PIX_FMT_NV61,
+	V4L2_PIX_FMT_YUV420,
+	V4L2_PIX_FMT_NV12,
+	V4L2_PIX_FMT_NV12M,
+	V4L2_PIX_FMT_YUV420M,
+	V4L2_PIX_FMT_NV12M,
+	V4L2_PIX_FMT_NV12MT
+};
+
+unsigned int jpeg_px_fmt[] = { V4L2_PIX_FMT_JPEG };
+
+unsigned int sensor_px_fmt[] = { V4L2_PIX_FMT_S5C_UYVY_JPG };
+
+/*
+ * struct media_entity - media device entity data
+ * @id:			media entity id within media controller
+ * @name:		media entity name
+ * @node_name:		media entity related device node name
+ * @pads:		array of media_entity pads
+ * @num_pads:		number of elements in the pads array
+ * @links:		array of media_entity links
+ * @num_links:		number of elements in the links array
+ * @subdev_fmt:		related sub-device format
+ * @fd:			related sub-device node file descriptor
+ */
+struct media_entity {
+	int id;
+	char name[32];
+	char node_name[32];
+	struct media_pad_desc *pads;
+	int num_pads;
+	struct media_link_desc *links;
+	int num_links;
+	struct v4l2_subdev_format subdev_fmt;
+	int fd;
+	int src_pad_id;
+	int sink_pad_id;
+	struct media_entity *next;
+};
+
+/*
+ * struct media_device
+ * @entities:		media entities comprised by a video device
+ * @num_entities:	number of media entities within a video device
+ * @pipeline:		pipeline of media entities from sensor to the video node
+ * @media_fd:		file descriptor of the media device this
+ *			video device belongs to
+ */
+struct media_device {
+	struct media_entity *entities;
+	int num_entities;
+	struct media_entity *pipeline;
+	int media_fd;
+};
+
+/*
+ * struct exynos4_camera_plugin - libv4l exynos4 camera plugin
+ * @config:		configuration data for the plugin
+ * @vid_fd:		video device node file descriptor
+ * @mdev:		media device comprising the vid_fd related video device
+ */
+struct exynos4_camera_plugin {
+	struct libv4l_media_device_conf config;
+	int vid_fd;
+	struct media_device mdev;
+};
+
+/*---------- Media Device configuration parser -------------*/
+
+static int get_line(struct libv4l_conf_parser_ctx *ctx)
+{
+	int i;
+
+	if (ctx->buf_pos == ctx->buf_size)
+		return -EINVAL;
+
+	ctx->line_start_pos = ctx->buf_pos;
+
+	for (i = ctx->buf_pos; i < ctx->buf_size; ++i) {
+		if (ctx->buf[i] == '\n') {
+			ctx->buf_pos = i + 1;
+			break;
+		}
+	}
+
+	ctx->line_end_pos = i - 1;
+
+	return 0;
+}
+
+static int parse_field_value(struct libv4l_conf_parser_ctx *ctx,
+				const char *field_name, char **field_value)
+{
+	char *value;
+	int line_offset = ctx->line_start_pos, i;
+	char *line_buf = ctx->buf + line_offset;
+	int field_name_len = strlen(field_name);
+	int field_value_pos = field_name_len + 3;
+	int field_value_len = ctx->line_end_pos - line_offset
+	    - field_value_pos + 1;
+
+	if (line_buf[0] != '\t') {
+		V4L2_DEVCFG_PARSER_ERR("Lack of leading tab.");
+		return -EINVAL;
+	}
+
+	if (strncmp(line_buf + 1, field_name, field_name_len) != 0) {
+		V4L2_DEVCFG_PARSER_ERR("Invalid field name.");
+		return -EINVAL;
+	}
+
+	if (line_buf[field_value_pos - 1] != ' ') {
+		V4L2_DEVCFG_PARSER_ERR("Lack of space after colon.");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < field_value_len; ++i)
+		if (line_buf[field_value_pos + i] == ' ') {
+			V4L2_DEVCFG_PARSER_ERR("Field value must not include spaces.");
+			return -EINVAL;
+		}
+
+	value = malloc(sizeof(char) * (field_value_len + 1));
+	if (value == NULL)
+		return -ENOMEM;
+
+	strncpy(value, line_buf + field_value_pos, field_value_len);
+	value[field_value_len] = '\0';
+
+	*field_value = value;
+
+	return 0;
+}
+
+static int parse_link(struct libv4l_conf_parser_ctx *ctx,
+			struct libv4l_media_link_conf **link)
+{
+	int *l_start = &ctx->line_start_pos, i;
+	int *l_end = &ctx->line_end_pos;
+	struct libv4l_media_link_conf *ret_link = NULL;
+	int ret;
+	static const char *link_fields[] = {
+		"source_entity",
+		"source_pad",
+		"sink_entity",
+		"sink_pad"
+	};
+	char *field_values[4];
+
+	memset(field_values, 0, sizeof(field_values));
+
+	ctx->line_start_pos = 0;
+	ctx->line_end_pos = 0;
+
+	/* look for link beginning signature */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0)
+			goto err_parser;
+
+		/* handling empty line case */
+		if (*l_end - *l_start <= 1)
+			continue;
+
+		ret = strncmp(ctx->buf + *l_start,
+			      "link {\n", *l_end - *l_start);
+		if (ret == 0)
+			break;
+	}
+
+	/* read link fields */
+	for (i = 0; i < ARRAY_SIZE(link_fields); ++i) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_DEVCFG_PARSER_ERR("Link entry incomplete.");
+			goto err_parser;
+		}
+
+		ret = parse_field_value(ctx, link_fields[i], &field_values[i]);
+		if (ret < 0) {
+			V4L2_DEVCFG_PARSER_ERR("Link field format error (%s)",
+					 link_fields[i]);
+			goto err_parser;
+		}
+	}
+
+	/* look for link end */
+	ret = get_line(ctx);
+	if (ret < 0) {
+		V4L2_DEVCFG_PARSER_ERR("EOF reached, link end not found.");
+		goto err_parser;
+	}
+
+	if (ctx->buf[*l_start] != '}') {
+		V4L2_DEVCFG_PARSER_ERR("Link closing marker not found");
+		goto err_parser;
+	}
+
+	ret_link = malloc(sizeof(struct libv4l_media_link_conf));
+	if (ret_link == NULL) {
+		V4L2_DEVCFG_PARSER_ERR("Could not allocate memory for a link.");
+		goto err_parser;
+	}
+
+	ret_link->source_entity = field_values[0];
+	ret_link->source_pad = atoi(field_values[1]);
+	ret_link->sink_entity = field_values[2];
+	ret_link->sink_pad = atoi(field_values[3]);
+
+	free(field_values[1]);
+	free(field_values[3]);
+
+	*link = ret_link;
+
+	return 1;
+
+err_parser:
+	for (i = 0; i < ARRAY_SIZE(field_values); ++i) {
+		if (field_values[i] != NULL)
+			free(field_values[i]);
+	}
+
+	if (ret_link != NULL)
+		free(ret_link);
+
+	return 0;
+}
+
+static int parse_property(struct libv4l_conf_parser_ctx *ctx,
+				char **key, char **value)
+{
+	int line_offset = ctx->line_start_pos,
+	    line_length = ctx->line_end_pos - ctx->line_start_pos + 1,
+	    val_length, i;
+	char *line_buf = ctx->buf + line_offset, *k, *v;
+
+	if (line_buf[0] != '\t') {
+		V4L2_DEVCFG_PARSER_ERR("Lack of leading tab.");
+		return -EINVAL;
+	}
+
+	/* Parse key segment of a property */
+	for (i = 1; i < line_length; ++i)
+		if (line_buf[i] == ':')
+			break;
+
+	if (i == line_length) {
+		V4L2_DEVCFG_PARSER_ERR("Property format error - lack of semicolon");
+		return -EINVAL;
+	}
+
+	/* At least one character should be left for value segment */
+	if (i >= line_length - 2) {
+		V4L2_DEVCFG_PARSER_ERR("Property format error - no value segment");
+		return -EINVAL;
+	}
+
+	k = malloc(sizeof(char) * i);
+	if (k == NULL)
+		return -ENOMEM;
+
+	strncpy(k, line_buf + 1, i - 1);
+	k[i - 1] = '\0';
+
+	val_length = line_length - i - 2;
+
+	v = malloc(sizeof(char) * (val_length + 1));
+	if (v == NULL)
+		return -ENOMEM;
+
+	strncpy(v, line_buf + i + 2, val_length);
+	v[val_length] = '\0';
+
+	*key = k;
+	*value = v;
+
+	return 0;
+}
+
+static int parse_controls(struct libv4l_conf_parser_ctx *ctx,
+				struct libv4l_media_ctrl_conf **controls)
+{
+	int *l_start = &ctx->line_start_pos;
+	int *l_end = &ctx->line_end_pos;
+	struct libv4l_media_ctrl_conf *head = NULL, *tmp_ctrl, *c = NULL;
+	int ret;
+	char *control_name = NULL, *entity_name = NULL;
+
+	if (controls == NULL)
+		return -EINVAL;
+
+	ctx->buf_pos = 0;
+	ctx->line_start_pos = 0;
+	ctx->line_end_pos = 0;
+
+	/* look for controls beginning signature */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_DEVCFG_PARSER_LOG("Controls configuration not found");
+			return 0;
+		}
+
+		/* handling empty line case */
+		if (*l_end - *l_start <= 1)
+			continue;
+
+		ret = strncmp(ctx->buf + *l_start,
+			      "v4l2-controls {\n", *l_end - *l_start);
+		if (ret == 0)
+			break;
+	}
+
+	/* read control-entity pairs */
+	for (;;) {
+		ret = get_line(ctx);
+		if (ret < 0) {
+			V4L2_DEVCFG_PARSER_ERR("Controls closing marker not found");
+			goto err_parser;
+		}
+
+		if (ctx->buf[*l_start] == '}')
+			break;
+
+		ret = parse_property(ctx, &control_name, &entity_name);
+		if (ret < 0) {
+			V4L2_DEVCFG_PARSER_ERR("Control property parsing error");
+			goto err_parser;
+		}
+
+		tmp_ctrl = calloc(1, sizeof(*tmp_ctrl));
+		if (tmp_ctrl == NULL) {
+			ret = -ENOMEM;
+			goto err_parser;
+		}
+
+		tmp_ctrl->entity_name = entity_name;
+		tmp_ctrl->control_name = control_name;
+
+		if (head == NULL) {
+			head = tmp_ctrl;
+			c = head;
+		} else {
+			c->next = tmp_ctrl;
+			c = c->next;
+		}
+	}
+
+	*controls = head;
+
+	return 0;
+
+err_parser:
+	libv4l_media_conf_release_controls(head);
+	return ret;
+}
+
+static int parse_links(struct libv4l_conf_parser_ctx *ctx,
+			struct libv4l_media_link_conf **links)
+{
+	int cnt = 0;
+	struct libv4l_media_link_conf *l = NULL, *head = NULL, *tmp = NULL;
+
+	ctx->line_start_pos = 0;
+	ctx->buf_pos = 0;
+
+	while (parse_link(ctx, &tmp)) {
+		if (head == NULL) {
+			head = tmp;
+			head->next = NULL;
+			l = head;
+		} else {
+			l->next = tmp;
+			l = l->next;
+			l->next = NULL;
+		}
+		++cnt;
+	}
+
+	if (cnt == 0) {
+		V4L2_DEVCFG_PARSER_ERR("No links have been found!");
+		goto err_no_data;
+	}
+
+	*links = head;
+
+	return 0;
+
+err_no_data:
+	libv4l_media_conf_release_links(head);
+	return -EINVAL;
+
+}
+
+void libv4l_media_conf_release_links(struct libv4l_media_link_conf *cfg)
+{
+	struct libv4l_media_link_conf *tmp;
+
+	while (cfg) {
+		tmp = cfg->next;
+		free(cfg->source_entity);
+		free(cfg->sink_entity);
+		free(cfg);
+		cfg = tmp;
+	}
+}
+
+void libv4l_media_conf_release_controls(struct libv4l_media_ctrl_conf *cfg)
+{
+	struct libv4l_media_ctrl_conf *tmp;
+
+	while (cfg) {
+		tmp = cfg->next;
+		free(cfg->entity_name);
+		free(cfg->control_name);
+		free(cfg);
+		cfg = tmp;
+	}
+}
+
+int libv4l_media_conf_read(char *fname, struct libv4l_media_device_conf *config)
+{
+	struct libv4l_media_link_conf *links;
+	struct libv4l_media_ctrl_conf *controls = NULL;
+	struct stat st;
+	struct libv4l_conf_parser_ctx ctx;
+	int fd, ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	/* read config file to a buffer */
+
+	fd = open(fname, O_RDONLY);
+
+	if (fd < 0) {
+		V4L2_DEVCFG_PARSER_ERR("Could not open config file");
+		return -EINVAL;
+	}
+
+	ret = fstat(fd, &st);
+	if (ret < 0) {
+		V4L2_DEVCFG_PARSER_ERR("Could not get config file statistics");
+		goto err_fstat;
+	}
+
+	ctx.buf_size = st.st_size;
+	ctx.buf = malloc(ctx.buf_size);
+	if (ctx.buf == NULL) {
+		V4L2_DEVCFG_PARSER_ERR("Could not allocate file buffer");
+		ret = -ENOMEM;
+		goto err_fstat;
+	}
+
+	ret = read(fd, ctx.buf, ctx.buf_size);
+	if (ret < 0)
+		goto err_config_read;
+
+	/* parse file buffer */
+
+	ret = parse_links(&ctx, &links);
+	if (ret < 0)
+		goto err_config_read;
+
+	ret = parse_controls(&ctx, &controls);
+	if (ret < 0)
+		goto err_parse_controls;
+
+	config->links = links;
+	config->controls = controls;
+
+	free(ctx.buf);
+
+	return ret;
+
+err_parse_controls:
+	libv4l_media_conf_release_links(links);
+err_config_read:
+	if (ctx.buf != NULL)
+		free(ctx.buf);
+err_fstat:
+	close(fd);
+
+	return ret;
+}
+
+
+/*---------- Dev node info helpers ----------*/
+
+static int get_node_by_devnum(unsigned int major, unsigned int minor,
+				char *node_name)
+{
+	struct stat devstat;
+	char devname[32];
+	char sysname[32];
+	char target[1024];
+	char *p;
+	int ret;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	sprintf(sysname, "/sys/dev/char/%u:%u", major, minor);
+	ret = readlink(sysname, target, sizeof(target));
+	if (ret < 0)
+		return -EINVAL;
+
+	target[ret] = '\0';
+	p = strrchr(target, '/');
+	if (p == NULL)
+		return -EINVAL;
+
+	sprintf(devname, "/dev/%s", p + 1);
+	ret = stat(devname, &devstat);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (major(devstat.st_rdev) == major &&
+	    minor(devstat.st_rdev) == minor)
+		strcpy(node_name, devname);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int get_node_by_fd(int fd, char *node_name)
+{
+	struct stat stat;
+	int major_num, minor_num;
+	int ret;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	ret = fstat(fd, &stat);
+	if (ret < 0)
+		return -EINVAL;
+
+	major_num = MAJOR(stat.st_rdev);
+	minor_num = MINOR(stat.st_rdev);
+
+	ret = get_node_by_devnum(major_num, minor_num, node_name);
+	if (ret < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*---------- Media controller API helpers ----------*/
+
+static int enumerate_entites(struct media_device *mdev)
+{
+	struct media_entity *entity, *entity_buf;
+	struct media_entity_desc entity_desc;
+	unsigned int entities_cnt = 0, entity_buf_size;
+	int ret, id;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	entity_buf = calloc(1, sizeof(*entity));
+	memset(&entity_desc, 0, sizeof(entity_desc));
+
+	for (id = 0;; id = entity_desc.id, ++entities_cnt) {
+		entity_buf_size = (entities_cnt + 1) * sizeof(*entity);
+		entity_buf = realloc(entity_buf, entity_buf_size);
+
+		entity = &entity_buf[entities_cnt];
+		memset(entity, 0, sizeof(*entity));
+
+		entity_desc.id = id | MEDIA_ENT_ID_FLAG_NEXT;
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_ENUM_ENTITIES,
+			    &entity_desc);
+		if (ret < 0) {
+			ret = errno != EINVAL ? -errno : 0;
+			break;
+		}
+		entity->id = entity_desc.id;
+		entity->num_pads = entity_desc.pads;
+		entity->num_links = entity_desc.links;
+		strcpy(entity->name, entity_desc.name);
+
+		if (!(entity_desc.type & MEDIA_ENT_T_DEVNODE) &&
+		    !(entity_desc.type & MEDIA_ENT_T_V4L2_SUBDEV))
+			continue;
+
+		ret = get_node_by_devnum(entity_desc.v4l.major,
+					 entity_desc.v4l.minor,
+					 entity->node_name);
+		if (ret < 0)
+			goto err_media_dev;
+	}
+
+	mdev->num_entities = entities_cnt;
+	mdev->entities = entity_buf;
+
+	return ret;
+
+err_media_dev:
+	free(entity_buf);
+	return -EINVAL;
+}
+
+static int enumerate_links(struct media_device *mdev)
+{
+	struct media_entity *entities = mdev->entities;
+	struct media_links_enum links_enum;
+	int i, j, ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (entities[i].num_pads == 0)
+			continue;
+		links_enum.entity = entities[i].id;
+		links_enum.pads = malloc(entities[i].num_pads *
+					 sizeof(struct media_pad_desc));
+		links_enum.links = malloc(entities[i].num_links *
+					  sizeof(struct media_link_desc));
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_ENUM_LINKS,
+			    &links_enum);
+		if (ret < 0) {
+			ret = -errno;
+			goto err_enum_links;
+		}
+
+		entities[i].pads = links_enum.pads;
+		entities[i].links = links_enum.links;
+	}
+
+	return 0;
+
+err_enum_links:
+	for (j = 0; j < i; ++j) {
+		free(entities[j].pads);
+		free(entities[j].links);
+	}
+
+	return ret;
+}
+
+static int release_entities(struct media_device *mdev)
+{
+	int i;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		free(mdev->entities[i].links);
+		free(mdev->entities[i].pads);
+	}
+
+	free(mdev->entities);
+
+	return 0;
+}
+
+static int get_device_topology(struct media_device *mdev)
+{
+	int ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	ret = enumerate_entites(mdev);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Failed to enumerate video entities.");
+		return ret;
+	}
+
+	ret = enumerate_links(mdev);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Failed to enumerate links.");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int has_device_node(struct media_device *mdev, char *entity_node,
+		char **entity_name)
+{
+	int i;
+
+	if (mdev == NULL || entity_node == NULL || entity_name == NULL)
+		return 0;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (strcmp(mdev->entities[i].node_name,
+			   entity_node) == 0) {
+			*entity_name = mdev->entities[i].name;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int capture_entity(char *name)
+{
+	int cap_segment_pos;
+
+	if (name == NULL)
+		return 0;
+
+	cap_segment_pos = strlen(name) - strlen(ENTITY_CAPTURE_SEGMENT);
+
+	if (strcmp(name + cap_segment_pos, ENTITY_CAPTURE_SEGMENT) == 0)
+		return 1;
+
+	return 0;
+}
+
+static int get_media_node(struct media_device *mdev, int capture_fd,
+	       char **entity_name)
+{
+	char media_dev_node[32], capture_dev_node[32];
+	int i, ret = 0;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	ret = get_node_by_fd(capture_fd, capture_dev_node);
+	if (ret < 0)
+		return -EINVAL;
+
+	/* query all available media devices */
+	for (i = 0;; ++i) {
+		sprintf(media_dev_node, "/dev/media%d", i);
+
+		mdev->media_fd = open(media_dev_node, O_RDWR);
+		if (mdev->media_fd < 0) {
+			close(mdev->media_fd);
+			return -EINVAL;
+		}
+
+		ret = get_device_topology(mdev);
+		if (ret < 0)
+			return ret;
+
+		if (has_device_node(mdev, capture_dev_node,
+				    entity_name))
+			return 0;
+
+		release_entities(mdev);
+		close(mdev->media_fd);
+	}
+
+	return -EINVAL;
+}
+
+static int get_pad_parent_name(struct media_device *mdev,
+		    struct media_pad_desc *pad, char **parent_name)
+{
+	int i;
+
+	if (mdev == NULL || pad == NULL || parent_name == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (mdev->entities[i].id == pad->entity) {
+			*parent_name = mdev->entities[i].name;
+			break;
+		}
+	}
+
+	if (i == mdev->num_entities)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int entity_get_id_by_name(struct media_device *mdev, char *name, int *id)
+{
+	int i;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (strcmp(mdev->entities[i].name, name) == 0) {
+			*id = mdev->entities[i].id;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+
+}
+
+static int has_link_pad(struct media_link_desc *link,
+			struct media_pad_desc *pad)
+{
+	if (link == NULL || pad == NULL)
+		return -EINVAL;
+
+	if (link->source.entity == pad->entity &&
+	    link->source.index == pad->index)
+		return 1;
+	if (link->sink.entity == pad->entity &&
+	    link->sink.index == pad->index)
+		return 1;
+
+	return 0;
+}
+
+static int pad_busy(struct media_device *mdev, struct media_pad_desc *pad,
+			struct media_link_desc **link)
+{
+	struct media_link_desc *cur_link;
+	int i, j;
+
+	if (mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    has_link_pad(cur_link, pad)) {
+				*link = cur_link;
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int print_link_log(char *message, struct media_device *mdev,
+				struct media_link_desc *link)
+{
+	char *src_entity = NULL, *sink_entity = NULL;
+	int ret;
+
+	if (message == NULL || mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	ret = get_pad_parent_name(mdev, &link->source, &src_entity);
+	if (ret < 0)
+		return ret;
+
+	ret = get_pad_parent_name(mdev, &link->sink, &sink_entity);
+	if (ret < 0)
+		return ret;
+
+	V4L2_EXYNOS4_LOG("%s: [%s]:%d -> [%s]:%d",
+	    message,
+	    src_entity, link->source.index, sink_entity, link->sink.index);
+
+	return 0;
+}
+
+static int disable_link(struct media_device *mdev, struct media_link_desc *link)
+{
+	int ret = -1;
+
+	if (mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	if (link->flags & MEDIA_LNK_FL_IMMUTABLE) {
+		V4L2_EXYNOS4_ERR("Can't disable immutable link.");
+		return -EINVAL;
+	}
+
+	link->flags &= ~MEDIA_LNK_FL_ENABLED;
+	ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_SETUP_LINK, link);
+	if (ret) {
+		V4L2_EXYNOS4_ERR("MEDIA_IOC_SETUP_LINK ioctl failed.");
+		return ret;
+	}
+
+	print_link_log("Disabled link", mdev, link);
+
+	return 0;
+}
+
+static int get_v4l2_pad(struct media_device *mdev, char *entity_name,
+			int pad_id, struct media_pad_desc *pad)
+{
+	int ret = -1, entity_id;
+
+	if (mdev == NULL || entity_name == NULL || pad == NULL)
+		return -EINVAL;
+
+	ret = entity_get_id_by_name(mdev, entity_name, &entity_id);
+	if (ret < 0)
+		return ret;
+
+	pad->entity = entity_id;
+	pad->index = pad_id;
+
+	return 0;
+}
+
+static int same_link(struct media_link_desc *link1,
+			struct media_link_desc *link2)
+{
+	if (link1 == NULL || link2 == NULL)
+		return 0;
+
+	if (link1->source.entity == link2->source.entity &&
+	    link1->source.index == link2->source.index &&
+	    link1->sink.entity == link2->sink.entity &&
+	    link1->sink.index == link2->sink.index)
+		return 1;
+
+	return 0;
+}
+
+static int link_enabled(struct media_device *mdev,
+			struct media_link_desc *link)
+{
+	struct media_link_desc *cur_link;
+	int i, j;
+
+	if (mdev == NULL || link == NULL)
+		return 0;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    same_link(link, cur_link)) {
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int get_entity_by_pad(struct media_device *mdev,
+				struct media_pad_desc *pad,
+				struct media_entity **entity)
+{
+	int i;
+
+	if (mdev == NULL || pad == NULL || entity == NULL)
+		return -EINVAL;
+
+	    for (i = 0; i < mdev->num_entities; ++i) {
+		if (pad->entity == mdev->entities[i].id) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int setup_config_links(struct media_device *mdev,
+				struct libv4l_media_link_conf *links)
+{
+	struct media_link_desc new_link, *colliding_link;
+	struct media_entity *entity;
+	int i, ret;
+
+	if (mdev == NULL || links == NULL)
+		return -EINVAL;
+
+	while (links) {
+		ret = get_v4l2_pad(mdev, links->source_entity,
+				   links->source_pad, &new_link.source);
+		if (ret < 0)
+			return ret;
+		ret = get_v4l2_pad(mdev, links->sink_entity,
+				   links->sink_pad, &new_link.sink);
+		if (ret < 0)
+			return ret;
+
+		if (link_enabled(mdev, &new_link)) {
+			print_link_log("Link already enabled", mdev,
+				       &new_link);
+
+			links = links->next;
+			continue;
+		}
+
+		ret = get_entity_by_pad(mdev, &new_link.sink, &entity);
+		if (ret < 0)
+			return ret;
+
+		/* Disable all links occupying sink pads of the entity */
+		for (i = 0; i < entity->num_pads; ++i) {
+			if (entity->pads[i].flags & MEDIA_PAD_FL_SINK) {
+				if (pad_busy(mdev, &entity->pads[i],
+							&colliding_link)) {
+					ret = disable_link(mdev,
+							colliding_link);
+					if (ret < 0)
+						return ret;
+				}
+			}
+		}
+
+		new_link.flags = MEDIA_LNK_FL_ENABLED;
+
+		print_link_log("Linking entities", mdev, &new_link);
+
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_SETUP_LINK,
+			    &new_link);
+		if (ret < 0)
+			return ret;
+
+		V4L2_EXYNOS4_LOG("Link has been set up successfuly.");
+
+		links = links->next;
+	}
+
+	return 0;
+}
+
+static struct media_entity *get_entity_by_name(struct media_device *mdev,
+						char *name)
+{
+	int i;
+
+	for (i = 0; i < mdev->num_entities; ++i)
+		if (!strcmp(mdev->entities[i].name, name))
+			return &mdev->entities[i];
+
+	return NULL;
+}
+
+/*
+ * If there was an entry for the cid defined in the controls
+ * config then this function returns related entity. Otherwise
+ * NULL is returned.
+ */
+static struct media_entity *get_entity_by_cid(
+				struct libv4l_media_ctrl_conf *ctrl_cfg,
+				int cid)
+{
+	if (ctrl_cfg == NULL)
+		return NULL;
+
+	while (ctrl_cfg) {
+		if (ctrl_cfg->cid == cid)
+			return ctrl_cfg->entity;
+		ctrl_cfg = ctrl_cfg->next;
+	}
+
+	return NULL;
+}
+
+static int is_control_supported(struct media_device *mdev,
+			struct libv4l_media_ctrl_conf *ctrl_cfg)
+{
+	struct v4l2_query_ext_ctrl queryctrl;
+	struct media_entity *entity;
+
+	entity = get_entity_by_name(mdev, ctrl_cfg->entity_name);
+	if (entity == NULL)
+		return 0;
+
+	/* Iterate through control ids */
+
+	queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_CTRL;
+
+	while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
+		if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
+			continue;
+
+		if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
+			ctrl_cfg->cid = queryctrl.id &
+					~V4L2_CTRL_FLAG_NEXT_CTRL;
+			ctrl_cfg->entity = entity;
+
+			return 1;
+		}
+
+		queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_CTRL;
+	}
+
+	queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_COMPOUND;
+
+	while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
+		if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
+			continue;
+
+		if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
+			ctrl_cfg->cid = queryctrl.id &
+					~V4L2_CTRL_FLAG_NEXT_COMPOUND;
+			ctrl_cfg->entity = entity;
+
+			return 1;
+		}
+
+		queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_COMPOUND;
+	}
+
+	return 0;
+}
+
+static int validate_control_config(struct media_device *mdev,
+				struct libv4l_media_ctrl_conf *ctrl_cfg)
+{
+	if (mdev == NULL || ctrl_cfg == NULL)
+		return -EINVAL;
+
+	while (ctrl_cfg) {
+		if (!is_control_supported(mdev, ctrl_cfg)) {
+			V4L2_EXYNOS4_ERR("Control %s is unsupported on %s.",
+					 ctrl_cfg->control_name,
+					 ctrl_cfg->entity_name);
+			return -EINVAL;
+		}
+
+		ctrl_cfg = ctrl_cfg->next;
+	}
+
+	return 0;
+}
+
+static int get_entity_by_fd(struct media_device *mdev, int fd,
+				struct media_entity **entity)
+{
+	char node_name[32];
+	int i, ret;
+
+	if (mdev == NULL || entity == NULL)
+		return -EINVAL;
+
+	ret = get_node_by_fd(fd, node_name);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (strcmp(mdev->entities[i].node_name, node_name) == 0) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int get_pads_by_entity(struct media_entity *entity,
+				struct media_pad_desc **pads,
+				int *num_pads, unsigned int type)
+{
+	struct media_pad_desc *entity_pads;
+	int cnt_pads, i;
+
+	if (entity == NULL || pads == NULL || num_pads == NULL)
+		return -EINVAL;
+
+	entity_pads = malloc(sizeof(*entity_pads));
+	cnt_pads = 0;
+
+	for (i = 0; i < entity->num_pads; ++i) {
+		if (entity->pads[i].flags & type) {
+			entity_pads = realloc(entity_pads, (i + 1) *
+					      sizeof(*entity_pads));
+			entity_pads[cnt_pads++] = entity->pads[i];
+		}
+	}
+
+	if (cnt_pads == 0)
+		free(entity_pads);
+
+	*pads = entity_pads;
+	*num_pads = cnt_pads;
+
+	return 0;
+}
+
+static int get_src_entity_by_link(struct media_device *mdev,
+					struct media_link_desc *link,
+					struct media_entity **entity)
+{
+	int i;
+
+	if (mdev == NULL || link == NULL || entity == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (mdev->entities[i].id == link->source.entity) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int get_link_by_sink_pad(struct media_device *mdev,
+				struct media_pad_desc *pad,
+				struct media_link_desc **link)
+{
+	struct media_link_desc *cur_link = NULL;
+	struct media_entity *entity;
+	int i, j, ret;
+
+	if (mdev == NULL || pad == NULL || link == NULL)
+		return -EINVAL;
+
+	ret = get_entity_by_pad(mdev, pad, &entity);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    (cur_link->sink.entity == pad->entity) &&
+			    (cur_link->sink.index == pad->index)) {
+				*link = cur_link;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int get_link_by_source_pad(struct media_entity *entity,
+					struct media_pad_desc *pad,
+					struct media_link_desc **link)
+{
+	int i;
+
+	if (entity == NULL || pad == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_links; ++i) {
+		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
+		    (entity->links[i].source.index == pad->index)) {
+			*link = &entity->links[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int get_busy_pads_by_entity(struct media_device *mdev,
+		       struct media_entity *entity,
+		       struct media_pad_desc **busy_pads,
+		       int *num_busy_pads,
+		       unsigned int type)
+{
+	struct media_pad_desc *bpads, *pads;
+	struct media_link_desc *link;
+	int cnt_bpads = 0, num_pads, i, ret;
+
+	if (entity == NULL || busy_pads == NULL || num_busy_pads == NULL ||
+	    (type == MEDIA_PAD_FL_SINK && mdev == NULL))
+		return -EINVAL;
+
+	ret = get_pads_by_entity(entity, &pads, &num_pads, type);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (num_pads == 0)
+		goto done;
+
+	bpads = malloc(sizeof(*pads));
+	if (bpads == NULL)
+		goto error_ret;
+
+	for (i = 0; i < num_pads; ++i) {
+		if (type == MEDIA_PAD_FL_SINK)
+			ret = get_link_by_sink_pad(mdev, &pads[i], &link);
+		else
+			ret = get_link_by_source_pad(entity, &pads[i], &link);
+		if (ret == 0) {
+			bpads = realloc(bpads, (i + 1) *
+						sizeof(*bpads));
+			bpads[cnt_bpads++] = pads[i];
+		}
+	}
+	if (num_pads > 0)
+		free(pads);
+
+	if (cnt_bpads == 0)
+		free(bpads);
+
+done:
+	*busy_pads = bpads;
+	*num_busy_pads = cnt_bpads;
+
+	return 0;
+
+error_ret:
+	return -EINVAL;
+}
+
+static int get_pad_by_index(struct media_pad_desc *pads, int num_pads,
+				int index, struct media_pad_desc *out_pad)
+
+{
+	int i;
+
+	if (pads == NULL || out_pad == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < num_pads; ++i) {
+		if (pads[i].index == index) {
+			*out_pad = pads[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int discover_pipeline_by_fd(struct media_device *mdev, int fd)
+{
+	struct media_entity *entity, *pipe_head = NULL;
+	struct media_pad_desc *sink_pads, sink_pad;
+	struct media_link_desc *link;
+	int num_sink_pads, prev_link_src_pad = -1, ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	/* get sink pipeline entity */
+	ret = get_entity_by_fd(mdev, fd, &entity);
+	if (ret < 0)
+		return ret;
+
+	if (entity == NULL)
+		return -EINVAL;
+
+	entity->fd = fd;
+
+	for (;;) {
+		if (pipe_head == NULL) {
+			pipe_head = entity;
+		} else {
+			entity->next = pipe_head;
+			pipe_head = entity;
+		}
+
+		entity->src_pad_id = prev_link_src_pad;
+		ret = get_busy_pads_by_entity(mdev, entity,
+					     &sink_pads,
+					     &num_sink_pads,
+					     MEDIA_PAD_FL_SINK);
+		if (ret < 0)
+			return ret;
+
+		/* check if pipeline source entity has been reached */
+		if (num_sink_pads > 1) {
+			/* Case for two parallel active links */
+			ret = get_pad_by_index(sink_pads, num_sink_pads, 0,
+							&sink_pad);
+			if (ret < 0)
+				return ret;
+		} else if (num_sink_pads == 1) {
+			sink_pad = sink_pads[0];
+		} else {
+			break;
+		}
+		if (num_sink_pads > 0)
+			free(sink_pads);
+
+		ret = get_link_by_sink_pad(mdev, &sink_pad,
+						   &link);
+
+		prev_link_src_pad = link->source.index;
+		entity->sink_pad_id = link->sink.index;
+
+		ret = get_src_entity_by_link(mdev, link, &entity);
+		if (ret || entity == NULL)
+			return ret;
+
+	}
+
+	mdev->pipeline = pipe_head;
+
+	return 0;
+}
+
+static int close_pipeline_subdevs(struct media_entity *pipeline)
+{
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	while (pipeline) {
+		close(pipeline->fd);
+		pipeline = pipeline->next;
+		if (pipeline->next == NULL)
+			break;
+	}
+
+	return 0;
+}
+
+static int open_pipeline_subdevs(struct media_entity *pipeline)
+{
+	struct media_entity *entity = pipeline;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	while (entity) {
+		entity->fd = open(entity->node_name, O_RDWR);
+		if (entity->fd < 0) {
+			V4L2_EXYNOS4_DBG("Could not open device %s",
+			    entity->node_name);
+			goto err_open_subdev;
+		}
+
+		entity = entity->next;
+		if (entity->next == NULL)
+			break;
+	}
+
+	return 0;
+
+err_open_subdev:
+	while (pipeline) {
+		if (pipeline == entity)
+			break;
+		close(pipeline->fd);
+		pipeline = pipeline->next;
+		if (pipeline->next == NULL)
+			break;
+	}
+
+	return -EINVAL;
+}
+
+static int verify_format(struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		V4L2_EXYNOS4_DBG("width mismatch")
+		return 0;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		V4L2_EXYNOS4_DBG("height mismatch")
+		return 0;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		V4L2_EXYNOS4_DBG("code mismatch")
+		return 0;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		V4L2_EXYNOS4_DBG("field mismatch")
+		return 0;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		V4L2_EXYNOS4_DBG("colorspace mismatch")
+		return 0;
+	}
+
+	return 1;
+}
+
+static int get_format_name(__u32 pix_code, int *fmt_id)
+{
+	int i;
+
+	if (fmt_id == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
+		if (mbus_codes[i].code == pix_code) {
+			*fmt_id = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int rgb_fmt(unsigned int pix_fmt)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rgb_px_fmt); ++i) {
+		if (rgb_px_fmt[i] == pix_fmt)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int yuv_fmt(unsigned int pix_fmt)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(yuv_px_fmt); ++i) {
+		if (yuv_px_fmt[i] == pix_fmt)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int jpeg_fmt(unsigned int pix_fmt)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(jpeg_px_fmt); ++i) {
+		if (jpeg_px_fmt[i] == pix_fmt)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int sensor_fmt(unsigned int pix_fmt)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sensor_px_fmt); ++i) {
+		if (sensor_px_fmt[i] == pix_fmt)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int select_mbus_codes_by_pix_fmt(unsigned int pix_fmt)
+{
+	int fmt_flags, i;
+
+	if (rgb_fmt(pix_fmt) || yuv_fmt(pix_fmt))
+		fmt_flags = RGB_PX_FMT | YUV_PX_FMT;
+	else if (jpeg_fmt(pix_fmt))
+		fmt_flags = JPEG_PX_FMT;
+	else if (sensor_fmt(pix_fmt))
+		fmt_flags = SENSOR_PX_FMT;
+	else
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i)
+		mbus_codes[i].supported = !!(mbus_codes[i].compat_pix_fmts
+					   & fmt_flags);
+
+	return 0;
+}
+
+static int enumerate_subdev_mbus_codes(struct media_entity *entity,
+			    int pad_id,
+			    struct v4l2_subdev_mbus_code_enum **fmt_enum,
+			    int *num_codes)
+{
+	struct v4l2_subdev_mbus_code_enum *temp_fmt_enum;
+	int i, code_id, ret;
+
+	if (entity == NULL || fmt_enum == NULL || num_codes == NULL)
+		return -EINVAL;
+
+	temp_fmt_enum = malloc(sizeof(*temp_fmt_enum));
+
+	for (i = 0;; ++i) {
+		temp_fmt_enum = realloc(temp_fmt_enum, (i + 1) *
+						sizeof(*temp_fmt_enum));
+		if (temp_fmt_enum == NULL)
+			goto err_enum_subdev;
+
+		memset(&temp_fmt_enum[i], 0, sizeof(*temp_fmt_enum));
+		temp_fmt_enum[i].pad = pad_id;
+		temp_fmt_enum[i].index = i;
+
+		ret = SYS_IOCTL(entity->fd,
+			    VIDIOC_SUBDEV_ENUM_MBUS_CODE, &temp_fmt_enum[i]);
+		if (ret < 0)
+			break;
+
+		ret = get_format_name(temp_fmt_enum[i].code, &code_id);
+		if (ret < 0)
+			goto err_enum_subdev;
+
+		V4L2_EXYNOS4_DBG("name: %s, pad: %d, format: %s, fmt_id: %x",
+		    entity->name,
+		    temp_fmt_enum[i].pad,
+		    mbus_codes[code_id].name, temp_fmt_enum[i].code);
+	}
+
+	*fmt_enum = temp_fmt_enum;
+	*num_codes = i + 1;
+
+	return 0;
+
+err_enum_subdev:
+	free(temp_fmt_enum);
+
+	return -EINVAL;
+}
+
+static int mark_unsupported_mbus_codes(
+				struct v4l2_subdev_mbus_code_enum *subdev_codes,
+				int num_subdev_codes)
+{
+	int i, j;
+
+	if (subdev_codes == NULL)
+		return -EINVAL;
+
+	/*
+	 * Mark mbus codes not present in the passed subdev_codes
+	 * array as unsupported, to prevent them from being selected
+	 * as the common mbus code for the whole pipeline.
+	 */
+	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
+		for (j = 0; j < num_subdev_codes; ++j) {
+			if (mbus_codes[i].code == subdev_codes[j].code)
+				break;
+		}
+		/* Don't take into account mbus codes once marked unsupported */
+		if (mbus_codes[i].supported)
+			mbus_codes[i].supported = (j != num_subdev_codes);
+	}
+
+	return 0;
+}
+
+static int negotiate_mbus_pix_code(struct media_device *mdev,
+					unsigned int pix_fmt,
+					struct mbus_code_meta_pkg *mbus_code)
+{
+	struct v4l2_subdev_mbus_code_enum *subdev_mbus_codes = NULL;
+	struct media_entity *entity;
+	int i, num_subdev_codes, ret;
+
+	if (mdev == NULL || mbus_code == NULL)
+		return -EINVAL;
+
+	entity = mdev->pipeline;
+
+	ret = select_mbus_codes_by_pix_fmt(pix_fmt);
+	if (ret < 0)
+		goto err_neg_mbus_code;
+
+	while (entity) {
+		ret = enumerate_subdev_mbus_codes(entity,
+						  entity->src_pad_id,
+						  &subdev_mbus_codes,
+						  &num_subdev_codes);
+		if (ret < 0)
+			return ret;
+
+		ret = mark_unsupported_mbus_codes(subdev_mbus_codes,
+						  num_subdev_codes);
+		if (ret < 0)
+			goto err_neg_mbus_code;
+
+		free(subdev_mbus_codes);
+
+		/* Negotiation should stop on FIMC-IS-ISP entity */
+		if (strcmp(entity->name, EXYNOS4_FIMC_IS_ISP) == 0)
+			break;
+
+		entity = entity->next;
+		/*
+		 * We should exit the loop if current entity
+		 * is pipeline's sink, as it is not a subdev.
+		 */
+		if (entity->next == NULL)
+			break;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
+		if (mbus_codes[i].supported) {
+			*mbus_code = mbus_codes[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+
+err_neg_mbus_code:
+	free(subdev_mbus_codes);
+
+	return -EINVAL;
+}
+
+static int has_pipeline_entity(struct media_entity *pipeline, char *entity)
+{
+	if (pipeline == NULL || entity == NULL)
+		return -EINVAL;
+
+	while (pipeline) {
+		if (!strcmp(pipeline->name, entity))
+			return 1;
+		pipeline = pipeline->next;
+	}
+
+	return 0;
+}
+
+static int adjust_format_to_fimc_is_isp(struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	if (mbus_fmt == NULL)
+		return -EINVAL;
+
+	mbus_fmt->width += 16;
+	mbus_fmt->height += 12;
+
+	return 0;
+}
+
+static int negotiate_pipeline_fmt(struct media_device *mdev,
+		       struct v4l2_format *dev_fmt,
+		       struct mbus_code_meta_pkg *mbus_code)
+{
+	struct media_entity *vid_pipe;
+	struct v4l2_subdev_format subdev_fmt = { 0 };
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 }, common_fmt;
+	int repeat_negotiation, cnt_negotiation = 0, ret;
+
+	if (mdev == NULL || dev_fmt == NULL || mbus_code == NULL)
+		return -EINVAL;
+
+	ret = select_mbus_codes_by_pix_fmt(dev_fmt->fmt.pix_mp.pixelformat);
+	if (ret < 0)
+		return ret;
+
+	vid_pipe = mdev->pipeline;
+
+	mbus_fmt.width = dev_fmt->fmt.pix_mp.width;
+	mbus_fmt.height = dev_fmt->fmt.pix_mp.height;
+	mbus_fmt.field = dev_fmt->fmt.pix_mp.field;
+	mbus_fmt.colorspace = dev_fmt->fmt.pix_mp.colorspace;
+
+	subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
+
+	if (has_pipeline_entity(vid_pipe, EXYNOS4_FIMC_IS_ISP)) {
+		ret = adjust_format_to_fimc_is_isp(&mbus_fmt);
+		if (ret < 0)
+			return ret;
+	}
+
+	subdev_fmt.format = mbus_fmt;
+
+	for (;;) {
+		repeat_negotiation = 0;
+		vid_pipe = mdev->pipeline;
+
+		subdev_fmt.pad = vid_pipe->src_pad_id;
+
+		ret = SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_S_FMT,
+			    &subdev_fmt);
+		if (ret < 0)
+			return ret;
+
+		common_fmt = subdev_fmt.format;
+		vid_pipe->subdev_fmt = subdev_fmt;
+
+		vid_pipe = mdev->pipeline->next;
+
+		while (vid_pipe) {
+			subdev_fmt.pad = vid_pipe->sink_pad_id;
+
+			/* Set format on the entity src pad */
+			ret =
+			    SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_S_FMT,
+				  &subdev_fmt);
+			if (ret < 0)
+				return ret;
+
+			if (!verify_format(&subdev_fmt.format, &common_fmt)) {
+				repeat_negotiation = 1;
+				break;
+			}
+
+			vid_pipe->subdev_fmt = subdev_fmt;
+
+			/*
+			 * Do not check format on FIMC.[n] source pad
+			 * and stop negotiation.
+			 */
+			if (!strncmp(vid_pipe->name,
+					EXYNOS4_FIMC_PREFIX,
+					strlen(EXYNOS4_FIMC_PREFIX)))
+				break;
+
+			subdev_fmt.pad = vid_pipe->src_pad_id;
+
+			/* Get format on the entity sink pad */
+			ret =
+			    SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_G_FMT,
+				  &subdev_fmt);
+			if (ret < 0)
+				return -EINVAL;
+
+			if (!strcmp(vid_pipe->name,
+						EXYNOS4_FIMC_IS_ISP)) {
+				common_fmt.code = subdev_fmt.format.code;
+				common_fmt.colorspace =
+						subdev_fmt.format.colorspace;
+				common_fmt.width -= 16;
+				common_fmt.height -= 12;
+			}
+			/* Bring back source pad id to the subdev format */
+			subdev_fmt.pad = vid_pipe->sink_pad_id;
+
+			if (!verify_format(&subdev_fmt.format, &common_fmt)) {
+				repeat_negotiation = 1;
+				break;
+			}
+
+			vid_pipe = vid_pipe->next;
+			if (vid_pipe->next == NULL)
+				break;
+		}
+
+		if (!repeat_negotiation) {
+			break;
+		} else if (++cnt_negotiation > MAX_FMT_NEGO_NUM) {
+			V4L2_EXYNOS4_DBG("Pipeline format negotiation failed!");
+			return -EINVAL;
+		}
+	}
+
+	dev_fmt->fmt.pix_mp.width = subdev_fmt.format.width;
+	dev_fmt->fmt.pix_mp.height = subdev_fmt.format.height;
+	dev_fmt->fmt.pix_mp.field = subdev_fmt.format.field;
+	dev_fmt->fmt.pix_mp.colorspace = subdev_fmt.format.colorspace;
+
+	return 0;
+}
+
+static int try_set_subdev_fmt(struct media_device *mdev,
+		   struct v4l2_format *dev_fmt,
+		   struct mbus_code_meta_pkg *mbus_code)
+{
+	int ret;
+
+	if (mdev == NULL || dev_fmt == NULL || mbus_code == NULL)
+		return -EINVAL;
+
+	ret = negotiate_mbus_pix_code(mdev,
+				      dev_fmt->fmt.pix_mp.pixelformat,
+				      mbus_code);
+	if (ret < 0)
+		return ret;
+
+	V4L2_EXYNOS4_DBG("Negotiated mbus code: %s", mbus_code->name);
+
+	ret = negotiate_pipeline_fmt(mdev, dev_fmt, mbus_code);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int set_subdev_fmt(struct media_entity *pipeline,
+				struct v4l2_format *dev_fmt,
+				struct mbus_code_meta_pkg *mbus_code)
+{
+	struct v4l2_subdev_format subdev_fmt = { 0 };
+	int ret;
+
+	if (pipeline == NULL || dev_fmt == NULL || mbus_code == NULL)
+		return -EINVAL;
+
+	while (pipeline) {
+		subdev_fmt = pipeline->subdev_fmt;
+		subdev_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_SUBDEV_S_FMT,
+			    &subdev_fmt);
+		if (ret < 0)
+			return ret;
+
+		pipeline = pipeline->next;
+		if (pipeline->next == NULL)
+			break;
+	}
+
+	/* seek for pipeline sink entity */
+	while (pipeline->next)
+		pipeline = pipeline->next;
+
+	ret = SYS_IOCTL(pipeline->fd, VIDIOC_S_FMT, dev_fmt);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int convert_type(int type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	default:
+		return type;
+	}
+}
+
+static int set_fmt_ioctl(struct exynos4_camera_plugin *plugin,
+			 unsigned long int cmd,
+			 struct v4l2_format *arg,
+			 enum v4l2_subdev_format_whence set_mode)
+{
+	struct v4l2_format fmt = { 0 };
+	struct v4l2_format *org = arg;
+	struct mbus_code_meta_pkg mbus_code = { 0 };
+	int ret;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	fmt.type = convert_type(arg->type);
+	if (fmt.type != arg->type) {
+		fmt.fmt.pix_mp.width = org->fmt.pix.width;
+		fmt.fmt.pix_mp.height = org->fmt.pix.height;
+		fmt.fmt.pix_mp.pixelformat = org->fmt.pix.pixelformat;
+		fmt.fmt.pix_mp.field = org->fmt.pix.field;
+		fmt.fmt.pix_mp.colorspace = org->fmt.pix.colorspace;
+		fmt.fmt.pix_mp.num_planes = 1;
+		fmt.fmt.pix_mp.plane_fmt[0].bytesperline =
+						org->fmt.pix.bytesperline;
+		fmt.fmt.pix_mp.plane_fmt[0].sizeimage = org->fmt.pix.sizeimage;
+	} else {
+		fmt = *org;
+	}
+
+	ret = try_set_subdev_fmt(&plugin->mdev, &fmt, &mbus_code);
+	if (ret < 0)
+		return ret;
+
+	if (set_mode == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = set_subdev_fmt(plugin->mdev.pipeline, &fmt, &mbus_code);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (fmt.type != arg->type) {
+		org->fmt.pix.width = fmt.fmt.pix_mp.width;
+		org->fmt.pix.height = fmt.fmt.pix_mp.height;
+		org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+		org->fmt.pix.field = fmt.fmt.pix_mp.field;
+		org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+		org->fmt.pix.bytesperline =
+				fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+		org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+	} else {
+		*org = fmt;
+	}
+
+	return 0;
+}
+
+static int get_fmt_ioctl(struct exynos4_camera_plugin *plugin,
+			 unsigned long int cmd,
+			 struct v4l2_format *arg)
+{
+	struct v4l2_format fmt = { 0 };
+	struct v4l2_format *org = arg;
+	int ret;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	fmt.type = convert_type(arg->type);
+
+	if (fmt.type == arg->type)
+		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
+
+	ret = SYS_IOCTL(plugin->vid_fd, cmd, &fmt);
+	if (ret < 0)
+		return ret;
+
+	org->fmt.pix.width = fmt.fmt.pix_mp.width;
+	org->fmt.pix.height = fmt.fmt.pix_mp.height;
+	org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+	org->fmt.pix.field = fmt.fmt.pix_mp.field;
+	org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+	org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+	org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+
+	/*
+	 * If the device doesn't support just one plane, there's
+	 * nothing we can do, except return an error condition.
+	 */
+	if (fmt.fmt.pix_mp.num_planes > 1) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	return ret;
+}
+
+static int enum_fmt_ioctl(struct exynos4_camera_plugin *plugin,
+			  unsigned long int cmd,
+			  struct v4l2_fmtdesc *arg)
+{
+	struct v4l2_fmtdesc efmt = *arg;
+	struct v4l2_fmtdesc *org = arg;
+	int ret;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	efmt.type = convert_type(arg->type);
+
+	if (efmt.type == arg->type)
+		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
+
+	ret = SYS_IOCTL(plugin->vid_fd, cmd, &efmt);
+	if (ret < 0)
+		return ret;
+
+	efmt.type = org->type;
+	*org = efmt;
+
+	return ret;
+}
+
+static int buf_ioctl(struct exynos4_camera_plugin *plugin,
+		     unsigned long int cmd,
+		     struct v4l2_buffer *arg)
+{
+	struct v4l2_buffer buf = *arg;
+	struct v4l2_plane plane = { 0 };
+	int ret;
+
+	buf.type = convert_type(arg->type);
+
+	if (buf.type == arg->type)
+		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
+
+	memcpy(&plane.m, &arg->m, sizeof(plane.m));
+	plane.length = arg->length;
+	plane.bytesused = arg->bytesused;
+
+	buf.m.planes = &plane;
+	buf.length = 1;
+
+	ret = SYS_IOCTL(plugin->vid_fd, cmd, &buf);
+
+	arg->index = buf.index;
+	arg->memory = buf.memory;
+	arg->flags = buf.flags;
+	arg->field = buf.field;
+	arg->timestamp = buf.timestamp;
+	arg->timecode = buf.timecode;
+	arg->sequence = buf.sequence;
+	arg->length = buf.m.planes[0].length;
+	arg->m.offset = buf.m.planes[0].m.mem_offset;
+	arg->bytesused = buf.m.planes[0].bytesused;
+
+	return ret;
+}
+
+static int querycap_ioctl(struct exynos4_camera_plugin *plugin,
+			  struct v4l2_capability *arg)
+{
+	int ret;
+
+	ret = SYS_IOCTL(plugin->vid_fd, VIDIOC_QUERYCAP, arg);
+
+	if (arg->capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+		arg->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
+
+	return ret;
+}
+
+static int ctrl_ioctl(struct exynos4_camera_plugin *plugin, int request,
+			struct v4l2_control *arg)
+{
+	struct media_entity *pipeline = plugin->mdev.pipeline;
+	struct v4l2_control ctrl = *arg, gctrl = *arg;
+	struct v4l2_queryctrl queryctrl;
+	struct media_entity *entity;
+	int ret = 0;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	/*
+	 * The control has to be reset to the default value
+	 * on all of the pipeline entities, prior setting a new
+	 * value. This is required in cases when the contol config
+	 * is changed between subsequent calls to VIDIOC_S_CTRL,
+	 * to avoid the situation when a control is set on more
+	 * than one sub-device.
+	 */
+	if (request == VIDIOC_S_CTRL) {
+		while (pipeline) {
+			queryctrl.id = (ctrl.id - 1) | V4L2_CTRL_FLAG_NEXT_CTRL;
+
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYCTRL,
+								&queryctrl);
+			if (ret < 0 || queryctrl.id != ctrl.id) {
+				pipeline = pipeline->next;
+				continue;
+			}
+
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_G_CTRL, &gctrl);
+			if (ret < 0)
+				return -EINVAL;
+
+			if (gctrl.value != queryctrl.default_value) {
+				gctrl.value = queryctrl.default_value;
+				ret = SYS_IOCTL(pipeline->fd,
+						VIDIOC_S_CTRL, &gctrl);
+				if (ret < 0)
+					return -EINVAL;
+			}
+
+			pipeline = pipeline->next;
+		}
+	}
+
+	entity = get_entity_by_cid(plugin->config.controls, ctrl.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, request, &ctrl);
+		V4L2_EXYNOS4_DBG("Setting config control %x succeeded on %s\n",
+				 ctrl.id,
+				 entity->name);
+		goto exit;
+	}
+
+	V4L2_EXYNOS4_DBG("No config for control id %x\n", ctrl.id);
+
+	/* Walk the pipeline until the request succeeds */
+	pipeline = plugin->mdev.pipeline;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, request, &ctrl);
+		if (!ret) {
+			V4L2_EXYNOS4_DBG("Setting control %x succeeded on %s\n",
+					 ctrl.id,
+					 pipeline->name);
+			goto exit;
+		}
+
+		pipeline = pipeline->next;
+	}
+
+exit:
+	*arg = ctrl;
+	return ret;
+}
+
+static void *
+plugin_init(int fd)
+{
+	struct v4l2_capability cap;
+	struct exynos4_camera_plugin plugin, *ret_plugin = NULL;
+	char *media_entity_name;
+	struct media_device *mdev = &plugin.mdev;
+	int ret;
+
+	memset(&plugin, 0, sizeof(plugin));
+
+	memset(&cap, 0, sizeof(cap));
+	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Failed to query video capabilities.");
+		return NULL;
+	}
+
+	/* Get media node for the device */
+	ret = get_media_node(mdev, fd, &media_entity_name);
+	if (ret < 0)
+		return NULL;
+
+	/* Check if video entity is of capture type */
+	if (!capture_entity(media_entity_name))
+		return NULL;
+
+	ret = libv4l_media_conf_read(EXYNOS4_CAPTURE_CONF, &plugin.config);
+	if (ret < 0)
+		return NULL;
+
+	ret = setup_config_links(mdev, plugin.config.links);
+	/* Release links as they will not be used anymore */
+	libv4l_media_conf_release_links(plugin.config.links);
+
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Video entities linking failed.");
+		return NULL;
+	}
+
+	/* refresh device topology data after linking */
+	release_entities(mdev);
+
+	ret = get_device_topology(mdev);
+
+	/* close media device fd as it won't be longer required */
+	close(mdev->media_fd);
+
+	if (ret < 0)
+		goto err_get_dev_topology;
+
+	/* discover a pipeline for the capture device */
+	ret = discover_pipeline_by_fd(mdev, fd);
+	if (ret < 0)
+		goto err_discover_pipeline;
+
+	ret = open_pipeline_subdevs(mdev->pipeline);
+	if (ret < 0)
+		goto err_discover_pipeline;
+
+
+	if (plugin.config.controls) {
+		ret = validate_control_config(mdev,
+						plugin.config.controls);
+		if (ret < 0)
+			goto err_validate_controls;
+	}
+
+	/* Allocate and initialize private data */
+	ret_plugin = calloc(1, sizeof(*ret_plugin));
+	if (!ret_plugin)
+		goto err_validate_controls;
+
+	plugin.vid_fd = fd;
+
+	*ret_plugin = plugin;
+	V4L2_EXYNOS4_DBG("Initialized exynos4-camera plugin.");
+
+	return ret_plugin;
+
+err_validate_controls:
+	close_pipeline_subdevs(mdev->pipeline);
+err_discover_pipeline:
+	release_entities(mdev);
+err_get_dev_topology:
+	libv4l_media_conf_release_controls(plugin.config.controls);
+	return NULL;
+}
+
+static void plugin_close(void *dev_ops_priv)
+{
+	struct exynos4_camera_plugin *plugin;
+	struct media_device *mdev;
+
+	if (dev_ops_priv == NULL)
+		return;
+
+	plugin = (struct exynos4_camera_plugin *) dev_ops_priv;
+	mdev = &plugin->mdev;
+
+	close_pipeline_subdevs(mdev->pipeline);
+	release_entities(mdev);
+	libv4l_media_conf_release_controls(plugin->config.controls);
+
+	free(plugin);
+}
+
+static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int cmd,
+							void *arg)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	switch (cmd) {
+	case VIDIOC_S_CTRL:
+	case VIDIOC_G_CTRL:
+		return ctrl_ioctl(plugin, VIDIOC_S_CTRL, arg);
+	case VIDIOC_TRY_FMT:
+		return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
+				     V4L2_SUBDEV_FORMAT_TRY);
+	case VIDIOC_S_FMT:
+		return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
+				     V4L2_SUBDEV_FORMAT_ACTIVE);
+	case VIDIOC_G_FMT:
+		return get_fmt_ioctl(plugin, VIDIOC_G_FMT, arg);
+	case VIDIOC_ENUM_FMT:
+		return enum_fmt_ioctl(plugin, VIDIOC_ENUM_FMT, arg);
+	case VIDIOC_QUERYCAP:
+		return querycap_ioctl(plugin, arg);
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_PREPARE_BUF:
+		return buf_ioctl(plugin, cmd, arg);
+	case VIDIOC_REQBUFS:
+		return SIMPLE_CONVERT_IOCTL(fd, cmd, arg,
+					    v4l2_requestbuffers);
+	case VIDIOC_STREAMON:
+	case VIDIOC_STREAMOFF:
+		{
+			int *arg_type = (int *) arg;
+			int type;
+
+			type = convert_type(*arg_type);
+
+			if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+			    type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+				V4L2_EXYNOS4_ERR("Invalid buffer type.");
+				return -EINVAL;
+			}
+
+			return SYS_IOCTL(fd, cmd, &type);
+		}
+
+	default:
+		return SYS_IOCTL(fd, cmd, arg);
+	}
+}
+
+PLUGIN_PUBLIC const struct libv4l_dev_ops libv4l2_plugin = {
+	.init = &plugin_init,
+	.close = &plugin_close,
+	.ioctl = &plugin_ioctl,
+};
-- 
1.7.9.5

