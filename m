Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52858 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbcARQTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:19:09 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1501N24PBWDD20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:19:08 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 15/15] Add a libv4l plugin for Exynos4 camera
Date: Mon, 18 Jan 2016 17:17:40 +0100
Message-id: <1453133860-21571-16-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plugin provides support for the media device on Exynos4 SoC.
It performs single plane <-> multi plane API conversion,
video pipeline linking and takes care of automatic data format
negotiation for the whole pipeline, after intercepting
VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 configure.ac                                      |    1 +
 lib/Makefile.am                                   |    5 +
 lib/libv4l-exynos4-camera/Makefile.am             |    7 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  620 +++++++++++++++++++++
 4 files changed, 633 insertions(+)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c

diff --git a/configure.ac b/configure.ac
index 1b61f15..afc9e86 100644
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
index 351c7d3..1576d06 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -5,6 +5,11 @@ SUBDIRS = \
 	libv4l2rds \
 	libv4l-mplane
 
+if WITH_V4LUTILS
+SUBDIRS += \
+	libv4l-exynos4-camera
+endif
+
 if LINUX_OS
 SUBDIRS += \
 	libdvbv5
diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
new file mode 100644
index 0000000..23c60c6
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/Makefile.am
@@ -0,0 +1,7 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
+endif
+
+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c ../../utils/media-ctl/libmediactl.c ../../utils/media-ctl/libv4l2subdev.c ../../utils/media-ctl/libv4l2media_ioctl.c ../../utils/media-ctl/mediatext.c
+libv4l_exynos4_camera_la_CFLAGS = -fvisibility=hidden -std=gnu99
+libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
diff --git a/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
new file mode 100644
index 0000000..12ebda7
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
@@ -0,0 +1,620 @@
+/*
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
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
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/syscall.h>
+#include <linux/types.h>
+
+#include "../../utils/media-ctl/libv4l2media_ioctl.h"
+#include "../../utils/media-ctl/mediactl.h"
+#include "../../utils/media-ctl/mediatext.h"
+#include "../../utils/media-ctl/v4l2subdev.h"
+#include "libv4l-plugin.h"
+
+struct media_device;
+struct media_entity;
+
+/*
+ * struct exynos4_camera_plugin - libv4l exynos4 camera plugin
+ * @media:		media device comprising the vid_fd related video device
+ */
+struct exynos4_camera_plugin {
+	struct media_device *media;
+	struct media_entity *sink_entity;
+};
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
+#if HAVE_VISIBILITY
+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
+#else
+#define PLUGIN_PUBLIC
+#endif
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+#define SIMPLE_CONVERT_IOCTL(fd, cmd, arg, __struc) ({  \
+	int __ret;                                      \
+	struct __struc *req = arg;                      \
+	uint32_t type = req->type;                      \
+	req->type = convert_type(type);                 \
+	__ret = SYS_IOCTL(fd, cmd, arg);                \
+	req->type = type;                               \
+	__ret;                                          \
+	})
+
+#ifndef min
+#define min(a, b) (((a) < (b)) ? (a) : (b))
+#endif
+
+#ifndef max
+#define max(a, b) (((a) > (b)) ? (a) : (b))
+#endif
+
+
+#define EXYNOS4_FIMC_DRV	"exynos4-fimc"
+#define EXYNOS4_FIMC_LITE_DRV	"exynos-fimc-lit"
+#define EXYNOS4_FIMC_IS_ISP_DRV	"exynos4-fimc-is"
+#define ENTITY_CAPTURE_SEGMENT	"capture"
+#define EXYNOS4_CAPTURE_CONF	"/var/lib/libv4l/exynos4_capture_conf"
+#define EXYNOS4_FIMC_IS_ISP	"FIMC-IS-ISP"
+#define EXYNOS4_S5K6A3		"S5K6A3"
+#define EXYNOS4_FIMC_LITE	"FIMC-LITE."
+#define EXYNOS4_FIMC_PREFIX	"FIMC."
+#define MAX_FMT_NEGO_NUM	50
+
+
+static int __capture_entity(const char *name)
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
+static int __adjust_format_to_fimc_is_isp(struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	if (mbus_fmt == NULL)
+		return -EINVAL;
+
+	mbus_fmt->width = max(128, mbus_fmt->width);
+	mbus_fmt->height = max(128, mbus_fmt->height);
+
+	mbus_fmt->width += 16;
+	mbus_fmt->height += 12;
+
+	return 0;
+}
+
+static int negotiate_pipeline_fmt(struct media_entity *pipeline,
+				  struct v4l2_format *dev_fmt)
+{
+	struct media_entity *entity = pipeline;
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 }, common_fmt;
+	int repeat_negotiation, cnt_negotiation = 0, ret, pad_id;
+	enum v4l2_subdev_fmt_mismatch fmt_err;
+
+	if (pipeline == NULL || dev_fmt == NULL)
+		return -EINVAL;
+
+	mbus_fmt.width = dev_fmt->fmt.pix_mp.width;
+	mbus_fmt.height = dev_fmt->fmt.pix_mp.height;
+	mbus_fmt.field = dev_fmt->fmt.pix_mp.field;
+	mbus_fmt.colorspace = dev_fmt->fmt.pix_mp.colorspace;
+
+	if (media_has_pipeline_entity(entity, EXYNOS4_FIMC_IS_ISP)) {
+		ret = __adjust_format_to_fimc_is_isp(&mbus_fmt);
+		if (ret < 0)
+			return ret;
+	}
+
+	V4L2_EXYNOS4_DBG("Begin pipeline format negotiation...");
+
+	for (;;) {
+		repeat_negotiation = 0;
+		entity = pipeline;
+
+		pad_id = media_entity_get_src_pad_index(entity);
+
+		V4L2_EXYNOS4_DBG("Setting format on the source entity pad %s:%d",
+				 media_entity_get_name(entity), pad_id);
+
+		ret = v4l2_subdev_set_format(entity, &mbus_fmt,
+					     pad_id, V4L2_SUBDEV_FORMAT_TRY);
+		if (ret < 0)
+			return ret;
+
+		V4L2_EXYNOS4_DBG("Format set on the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+				 media_entity_get_name(entity), pad_id,
+				 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+				 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+				 mbus_fmt.width, mbus_fmt.height);
+
+		common_fmt = mbus_fmt;
+
+		entity = media_entity_get_next(entity);
+
+		while (entity) {
+			pad_id = media_entity_get_sink_pad_index(entity);
+
+			/* Set format on the entity sink pad */
+			V4L2_EXYNOS4_DBG("Setting format on the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+					 media_entity_get_name(entity), pad_id,
+					 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+					 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+					 mbus_fmt.width, mbus_fmt.height);
+
+			ret = v4l2_subdev_set_format(entity, &mbus_fmt, pad_id,
+							V4L2_SUBDEV_FORMAT_TRY);
+			if (ret < 0)
+				return ret;
+
+			fmt_err = v4l2_subdev_format_compare(&mbus_fmt, &common_fmt);
+			if (fmt_err) {
+				if (fmt_err == FMT_MISMATCH_WIDTH &&
+				     !strncmp(media_entity_get_name(entity),
+					      EXYNOS4_FIMC_LITE,
+					      strlen(EXYNOS4_FIMC_LITE))) {
+					/*
+					 * Align width downwards, according to the FIMC-LITE
+					 * width step. Otherwise pipeline format negotiation
+					 * wouldn't succeed for widths excessing maximum sensor
+					 * frame width, which is being probed by GStreamer,
+					 * no matter what actual frame size is to be set.
+					 */
+					mbus_fmt.width -= 8;
+				}
+				repeat_negotiation = 1;
+				break;
+			}
+
+			/*
+			 * Do not check format on FIMC.[n] source pad
+			 * and stop negotiation.
+			 */
+			if (!strncmp(media_entity_get_name(entity),
+				     EXYNOS4_FIMC_PREFIX,
+				     strlen(EXYNOS4_FIMC_PREFIX)))
+				break;
+
+			pad_id = media_entity_get_src_pad_index(entity);
+
+			/* Get format on the entity src pad */
+			ret = v4l2_subdev_get_format(entity, &mbus_fmt, pad_id,
+							V4L2_SUBDEV_FORMAT_TRY);
+			if (ret < 0)
+				return -EINVAL;
+
+			V4L2_EXYNOS4_DBG("Format propagated to the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+					 media_entity_get_name(entity), pad_id,
+					 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+					 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+					 mbus_fmt.width, mbus_fmt.height);
+
+			if (!strcmp(media_entity_get_name(entity),
+				    EXYNOS4_FIMC_IS_ISP)) {
+				common_fmt.code = mbus_fmt.code;
+				common_fmt.colorspace = mbus_fmt.colorspace;
+				common_fmt.width -= 16;
+				common_fmt.height -= 12;
+			}
+
+			if (v4l2_subdev_format_compare(&mbus_fmt, &common_fmt)) {
+				repeat_negotiation = 1;
+				break;
+			}
+
+			entity = media_entity_get_next(entity);
+
+			/*
+			 * Stop if this is last element in the
+			 * pipeline as it is not a sub-device.
+			 */
+			if (media_entity_get_next(entity) == NULL)
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
+	dev_fmt->fmt.pix_mp.width = mbus_fmt.width;
+	dev_fmt->fmt.pix_mp.height = mbus_fmt.height;
+	dev_fmt->fmt.pix_mp.field = mbus_fmt.field;
+	dev_fmt->fmt.pix_mp.colorspace = mbus_fmt.colorspace;
+
+	V4L2_EXYNOS4_DBG("Pipeline format successfuly negotiated");
+
+	return 0;
+}
+
+static __u32 convert_type(__u32 type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	default:
+		return type;
+	}
+}
+
+static int set_fmt_ioctl(struct media_device *media,
+			 unsigned long int cmd,
+			 struct v4l2_format *arg,
+			 enum v4l2_subdev_format_whence set_mode)
+{
+	struct v4l2_format fmt = { 0 };
+	int ret;
+
+	fmt.type = convert_type(arg->type);
+	if (fmt.type != arg->type) {
+		fmt.fmt.pix_mp.width = arg->fmt.pix.width;
+		fmt.fmt.pix_mp.height = arg->fmt.pix.height;
+		fmt.fmt.pix_mp.pixelformat = arg->fmt.pix.pixelformat;
+		fmt.fmt.pix_mp.field = arg->fmt.pix.field;
+		fmt.fmt.pix_mp.colorspace = arg->fmt.pix.colorspace;
+		fmt.fmt.pix_mp.num_planes = 1;
+		fmt.fmt.pix_mp.flags = arg->fmt.pix.flags;
+		fmt.fmt.pix_mp.plane_fmt[0].bytesperline = arg->fmt.pix.bytesperline;
+		fmt.fmt.pix_mp.plane_fmt[0].sizeimage = arg->fmt.pix.sizeimage;
+	} else {
+		fmt = *arg;
+	}
+
+	ret = negotiate_pipeline_fmt(media_get_pipeline(media), &fmt);
+	if (ret < 0)
+		return ret;
+
+	if (set_mode == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = v4l2_subdev_apply_pipeline_fmt(media, &fmt);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (fmt.type != arg->type) {
+		arg->fmt.pix.width = fmt.fmt.pix_mp.width;
+		arg->fmt.pix.height = fmt.fmt.pix_mp.height;
+		arg->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+		arg->fmt.pix.field = fmt.fmt.pix_mp.field;
+		arg->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+		arg->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+		arg->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+		arg->fmt.pix.flags = fmt.fmt.pix_mp.flags;
+	} else {
+		*arg = fmt;
+	}
+
+	return 0;
+}
+
+static int get_fmt_ioctl(int fd,
+			 unsigned long int cmd,
+			 struct v4l2_format *arg)
+{
+	struct v4l2_format fmt = { 0 };
+	int ret;
+
+	fmt.type = convert_type(arg->type);
+
+	if (fmt.type == arg->type)
+		return SYS_IOCTL(fd, cmd, arg);
+
+	ret = SYS_IOCTL(fd, cmd, &fmt);
+	if (ret < 0)
+		return ret;
+
+	memset(&arg->fmt.pix, 0, sizeof(arg->fmt.pix));
+	arg->fmt.pix.width = fmt.fmt.pix_mp.width;
+	arg->fmt.pix.height = fmt.fmt.pix_mp.height;
+	arg->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+	arg->fmt.pix.field = fmt.fmt.pix_mp.field;
+	arg->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+	arg->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+	arg->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+	arg->fmt.pix.flags = fmt.fmt.pix_mp.flags;
+
+	return ret;
+}
+
+static int buf_ioctl(int fd,
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
+		return SYS_IOCTL(fd, cmd, arg);
+
+	memcpy(&plane.m, &arg->m, sizeof(plane.m));
+	plane.length = arg->length;
+	plane.bytesused = arg->bytesused;
+
+	buf.m.planes = &plane;
+	buf.length = 1;
+
+	ret = SYS_IOCTL(fd, cmd, &buf);
+
+	arg->index = buf.index;
+	arg->memory = buf.memory;
+	arg->flags = buf.flags;
+	arg->field = buf.field;
+	arg->timestamp = buf.timestamp;
+	arg->timecode = buf.timecode;
+	arg->sequence = buf.sequence;
+
+	arg->length = plane.length;
+	arg->bytesused = plane.bytesused;
+	memcpy(&arg->m, &plane.m, sizeof(arg->m));
+
+	return ret;
+}
+
+static int querycap_ioctl(int fd, struct v4l2_capability *arg)
+{
+	int ret;
+
+	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, arg);
+	if (ret < 0)
+		return ret;
+
+	arg->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	arg->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
+
+	return ret;
+}
+
+static void *plugin_init(int fd)
+{
+	struct v4l2_capability cap = { 0 };
+	struct exynos4_camera_plugin *plugin = NULL;
+	const char *sink_entity_name;
+	struct media_device *media;
+	struct media_entity *sink_entity;
+	char video_devname[32];
+	int ret;
+
+	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Failed to query video capabilities.");
+		return NULL;
+	}
+
+	/* Check if this is Exynos4 media device */
+	if (strcmp((char *) cap.driver, EXYNOS4_FIMC_DRV) &&
+	    strcmp((char *) cap.driver, EXYNOS4_FIMC_LITE_DRV) &&
+	    strcmp((char *) cap.driver, EXYNOS4_FIMC_IS_ISP_DRV)) {
+		V4L2_EXYNOS4_ERR("Not an Exynos4 media device.");
+		return NULL;
+	}
+
+	/* Obtain the node name of the opened device */
+	ret = media_get_devname_by_fd(fd, video_devname);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Failed to get video device node name.");
+		return NULL;
+	}
+
+	/*
+	 * Create the representation of a media device
+	 * containing the opened video device.
+	 */
+	media = media_device_new_by_entity_devname(video_devname);
+	if (media == NULL) {
+		V4L2_EXYNOS4_ERR("Failed to create media device.");
+		return NULL;
+	}
+
+#ifdef DEBUG
+	media_debug_set_handler(media, (void (*)(void *, ...))fprintf, stdout);
+#endif
+
+	/* Get the entity representing the opened video device node */
+	sink_entity = media_get_entity_by_devname(media, video_devname,
+						  strlen(video_devname));
+	if (sink_entity == NULL) {
+		V4L2_EXYNOS4_ERR("Failed to get sink entity name.");
+		goto err_get_sink_entity;
+	}
+
+	/*
+	 * Initialize sink_entity subdev fd with the one opened
+	 * by the libv4l core to avoid losing it on pipeline opening.
+	 */
+	v4l2_subdev_create_with_fd(sink_entity, fd);
+
+	sink_entity_name = media_entity_get_name(sink_entity);
+
+	/* Check if video entity is of capture type, not m2m */
+	if (!__capture_entity(sink_entity_name)) {
+		V4L2_EXYNOS4_ERR("Device not of capture type.");
+		goto err_get_sink_entity;
+	}
+
+	/* Parse media configuration file and apply its settings */
+	ret = mediatext_parse_setup_config(media, EXYNOS4_CAPTURE_CONF);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Media config parser error.");
+		goto err_get_sink_entity;
+	}
+
+	/*
+	 * Discover the pipeline of sub-devices from a camera sensor
+	 * to the opened video device.
+	 */
+	ret = media_discover_pipeline_by_entity(media, sink_entity);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error discovering video pipeline.");
+		goto err_get_sink_entity;
+	}
+
+	/* Open all sub-devices in the discovered pipeline */
+	ret = v4l2_subdev_open_pipeline(media);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error opening video pipeline.");
+		goto err_get_sink_entity;
+	}
+
+	/* Allocate private data */
+	plugin = calloc(1, sizeof(*plugin));
+	if (!plugin)
+		goto err_validate_controls;
+
+	plugin->media = media;
+	plugin->sink_entity = sink_entity;
+
+	V4L2_EXYNOS4_LOG("Initialized exynos4-camera plugin.");
+
+	return plugin;
+
+err_validate_controls:
+	v4l2_subdev_release(sink_entity, false);
+	v4l2_subdev_release_pipeline(media);
+err_get_sink_entity:
+	if (media)
+		media_device_unref(media);
+	return NULL;
+}
+
+static void plugin_close(void *dev_ops_priv)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+	struct media_device *media;
+
+	if (plugin == NULL)
+		return;
+
+	/* release sink entity sub-device, but don't close fd */
+	v4l2_subdev_release(plugin->sink_entity, false);
+
+	media = plugin->media;
+	v4l2_subdev_release_pipeline(media);
+	media_device_unref(media);
+
+	free(plugin);
+}
+
+static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int cmd,
+							void *arg)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+	struct media_device *media;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	media = plugin->media;
+
+	if (media == NULL)
+		return -EINVAL;
+
+	switch (cmd) {
+	case VIDIOC_S_CTRL:
+	case VIDIOC_G_CTRL:
+		return media_ioctl_ctrl(media, cmd, arg);
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+		return media_ioctl_ext_ctrl(media, cmd, arg);
+	case VIDIOC_QUERYCTRL:
+		return media_ioctl_queryctrl(media, arg);
+	case VIDIOC_QUERY_EXT_CTRL:
+		return media_ioctl_query_ext_ctrl(media, arg);
+	case VIDIOC_QUERYMENU:
+		return media_ioctl_querymenu(media, arg);
+	case VIDIOC_TRY_FMT:
+		return set_fmt_ioctl(media, cmd, arg,
+				     V4L2_SUBDEV_FORMAT_TRY);
+	case VIDIOC_S_FMT:
+		return set_fmt_ioctl(media, cmd, arg,
+				     V4L2_SUBDEV_FORMAT_ACTIVE);
+	case VIDIOC_G_FMT:
+		return get_fmt_ioctl(fd, cmd, arg);
+	case VIDIOC_QUERYCAP:
+		return querycap_ioctl(fd, arg);
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_PREPARE_BUF:
+		return buf_ioctl(fd, cmd, arg);
+	case VIDIOC_REQBUFS:
+		return SIMPLE_CONVERT_IOCTL(fd, cmd, arg,
+					    v4l2_requestbuffers);
+	case VIDIOC_ENUM_FMT:
+		return SIMPLE_CONVERT_IOCTL(fd, cmd, arg, v4l2_fmtdesc);
+	case VIDIOC_CROPCAP:
+		return SIMPLE_CONVERT_IOCTL(fd, cmd, arg, v4l2_cropcap);
+	case VIDIOC_STREAMON:
+	case VIDIOC_STREAMOFF:
+		{
+			int *arg_type = (int *) arg;
+			__u32 type;
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

