Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47772 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932176AbcJMOUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 10:20:44 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEZ02YCCP55Q4D0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Oct 2016 23:19:53 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils 7/7 v7.1] Add a libv4l plugin for Exynos4 camera
Date: Thu, 13 Oct 2016 16:19:23 +0200
Message-id: <1476368363-18841-1-git-send-email-j.anaszewski@samsung.com>
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
 lib/libv4l-exynos4-camera/Makefile.am             |   19 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c | 1335 +++++++++++++++++++++
 4 files changed, 1360 insertions(+)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c

diff --git a/configure.ac b/configure.ac
index 8447f05..692718a 100644
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
index a105c95..b5e52db 100644
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
 if WITH_LIBDVBV5
 SUBDIRS += \
 	libdvbv5
diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
new file mode 100644
index 0000000..c38b7f6
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/Makefile.am
@@ -0,0 +1,19 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
+endif
+
+media-bus-format-names.h: ../../include/linux/media-bus-format.h
+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \
+	< $< > $@
+
+media-bus-format-codes.h: ../../include/linux/media-bus-format.h
+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*#define //; /FIXED/ d; s/\t.*//; s/.*/ &,/;' \
+	< $< > $@
+
+BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h
+CLEANFILES = $(BUILT_SOURCES)
+
+nodist_libv4l_exynos4_camera_la_SOURCES = $(BUILT_SOURCES)
+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c ../../utils/media-ctl/libmediactl.c ../../utils/media-ctl/libv4l2subdev.c ../../utils/media-ctl/mediatext.c
+libv4l_exynos4_camera_la_CFLAGS = -fvisibility=hidden -std=gnu99
+libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
diff --git a/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
new file mode 100644
index 0000000..c2c4c6e
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
@@ -0,0 +1,1335 @@
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
+#include <linux/types.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../../utils/media-ctl/mediactl.h"
+#include "../../utils/media-ctl/mediatext.h"
+#include "../../utils/media-ctl/v4l2subdev.h"
+#include "libv4l-plugin.h"
+
+#define DEBUG
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
+#define VIDIOC_CTRL(type)				\
+	((type) == VIDIOC_S_CTRL ? "VIDIOC_S_CTRL" :	\
+				   "VIDIOC_G_CTRL")
+
+#define VIDIOC_EXT_CTRL(type)					\
+	((type) == VIDIOC_S_EXT_CTRLS ?                         \
+		"VIDIOC_S_EXT_CTRLS"    :                       \
+		((type) == VIDIOC_G_EXT_CTRLS ?                \
+				"VIDIOC_G_EXT_CTRLS" :      \
+				"VIDIOC_TRY_EXT_CTRLS"))
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
+#define EXYNOS4_FIMC_DRV	"exynos4-fimc"
+#define EXYNOS4_FIMC_LITE_DRV	"exynos-fimc-lit"
+#define EXYNOS4_FIMC_IS_ISP_DRV	"exynos4-fimc-is"
+#define EXYNOS4_CAPTURE_CONF	"/var/lib/libv4l/exynos4_capture_conf"
+#define EXYNOS4_FIMC_IS_ISP	"FIMC-IS-ISP"
+#define EXYNOS4_S5K6A3		"S5K6A3"
+#define EXYNOS4_FIMC_LITE_PREFIX "FIMC-LITE."
+#define EXYNOS4_FIMC_PREFIX	"FIMC."
+#define EXYNOS4_MAX_FMT_NEGO_NUM 50
+#define EXYNOS4_MAX_PIPELINE_LEN 7
+
+struct media_device;
+struct media_entity;
+
+/*
+ * struct pipeline_entity - linked media device pipeline
+ * @entity:		linked entity
+ * @sink_pad:		inbound link pad of the entity
+ * @src_pad:		outbound link pad of the entity
+ */
+struct pipeline_entity {
+	struct media_entity *entity;
+	struct media_pad *sink_pad;
+	struct media_pad *src_pad;
+};
+
+/*
+ * struct media_entity_to_cid - entity to control map
+ * @entity:		media entity
+ * @sink_pad:		inbound link pad of the entity
+ * @src_pad:		outbound link pad of the entity
+ */
+struct media_entity_to_cid {
+	struct media_entity *entity;
+	union {
+		struct v4l2_queryctrl queryctrl;
+		struct v4l2_query_ext_ctrl query_ext_ctrl;
+	};
+};
+
+/*
+ * struct exynos4_camera_plugin - libv4l exynos4 camera plugin
+ * @media:		media device comprising the opened video device
+ * @pipeline:		video pipeline, element 0 is the source entity
+ * @pipeline_len:	length of the video pipeline
+ */
+struct exynos4_camera_plugin {
+	struct media_device *media;
+	struct pipeline_entity pipeline[EXYNOS4_MAX_PIPELINE_LEN];
+	unsigned int pipeline_len;
+};
+
+/* -----------------------------------------------------------------------------
+ * Pipeline operations
+ */
+
+/**
+ * @brief Discover video pipeline for given sink entity
+ * @param plugin - this plugin.
+ * @param entity - sink entity of the pipeline.
+ *
+ * Discover the video pipeline, by walking starting from the
+ * sink entity upwards until a source entity is encountered.
+ *
+ * @return 0 if the sensor entity was detected,
+ * 	   or negative error code on failure.
+ */
+static int discover_pipeline_by_entity(struct exynos4_camera_plugin *plugin,
+				       struct media_entity *entity)
+{
+	struct pipeline_entity reverse_pipeline[EXYNOS4_MAX_PIPELINE_LEN];
+	struct media_pad *src_pad;
+	struct media_link *link = NULL, *backlinks[2];
+	unsigned int num_backlinks, cur_pipe_pos = 0;
+	int i, j;
+	int ret;
+
+	if (entity == NULL)
+		return -EINVAL;
+
+	for (;;) {
+		/* Cache the recently discovered entity. */
+		reverse_pipeline[cur_pipe_pos].entity = entity;
+
+		/* Cache the source pad used for linking the entity. */
+		if (link)
+			reverse_pipeline[cur_pipe_pos].src_pad = link->source;
+
+		ret = media_entity_get_backlinks(entity, backlinks,
+						 &num_backlinks);
+		if (ret < 0)
+			return ret;
+
+		/* Check if pipeline source entity has been reached. */
+		if (num_backlinks > 2) {
+			V4L2_EXYNOS4_DBG("Unexpected number of busy sink pads (%d)",
+					 num_backlinks);
+			return -EINVAL;
+		} else if (num_backlinks == 2) {
+			/*
+			 * Allow two active pads only in case of
+			 * S5C73M3-OIF entity.
+			 */
+			if (strcmp(media_entity_get_info(entity)->name,
+				   "S5C73M3-OIF")) {
+				V4L2_EXYNOS4_DBG("Ambiguous media device topology: "
+						 "two busy sink pads");
+				return -EINVAL;
+			}
+			/*
+			 * Two active links are allowed betwen S5C73M3-OIF and
+			 * S5C73M3 entities. In such a case route through the
+			 * pad with id == 0 has to be chosen.
+			 */
+			link = NULL;
+			for (i = 0; i < num_backlinks; i++)
+				if (backlinks[i]->sink->index == 0)
+					link = backlinks[i];
+			if (link == NULL)
+				return -EINVAL;
+		} else if (num_backlinks == 1) {
+			link = backlinks[0];
+		} else {
+			reverse_pipeline[cur_pipe_pos].sink_pad = NULL;
+			break;
+		}
+
+		/* Cache the sink pad used for linking the entity. */
+		reverse_pipeline[cur_pipe_pos].sink_pad = link->sink;
+
+		V4L2_EXYNOS4_DBG("Discovered sink pad %d for the %s entity",
+				 reverse_pipeline[cur_pipe_pos].sink_pad->index,
+				 media_entity_get_info(entity)->name);
+
+		src_pad = media_entity_remote_source(link->sink);
+		if (!src_pad)
+			return -EINVAL;
+
+		entity = src_pad->entity;
+		if (++cur_pipe_pos == EXYNOS4_MAX_PIPELINE_LEN)
+			return -EINVAL;
+	}
+
+	/*
+	 * Reorder discovered pipeline elements so that the sensor
+	 * entity was the pipeline head.
+	 */
+	j = 0;
+	for (i = cur_pipe_pos; i >= 0; i--)
+		plugin->pipeline[j++] = reverse_pipeline[i];
+
+	plugin->pipeline_len = j;
+
+	return 0;
+}
+
+/**
+ * @brief Check if the entity belongs to the plugin video pipeline
+ * @param plugin - this plugin.
+ * @param entity_name - name of the entity to look for.
+ *
+ * Check if the entity belongs to the pipeline whose sink element
+ * is the video device represented by the file descriptor passed
+ * to plugin_init().
+ *
+ * @return True if the entity belongs to the pipeline,
+ *         and false otherwise.
+ */
+static bool has_pipeline_entity(struct exynos4_camera_plugin *plugin,
+				char *entity_name)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	unsigned int i;
+
+	if (pipeline == NULL || entity_name == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < plugin->pipeline_len; i++) {
+		entity = pipeline[i].entity;
+		if (!strncmp(media_entity_get_info(entity)->name, entity_name,
+			     strlen(entity_name)))
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * @brief Adjust mbus format to FIMC_IS_ISP limitations.
+ * @param mbus_fmt - format to adjust.
+ *
+ * FIMC_IS_ISP shears the video frame off, effectively the format set
+ * on the preceding entities has to be suitably greater to achieve
+ * the frame size requested by the user.
+ *
+ * Also the miminum frame size supported by FIMC_IS_ISP is 128x128.
+ */
+static void adjust_format_to_fimc_is_isp(struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	mbus_fmt->width = max(128, mbus_fmt->width);
+	mbus_fmt->height = max(128, mbus_fmt->height);
+
+	mbus_fmt->width += 16;
+	mbus_fmt->height += 12;
+}
+
+/**
+ * @brief Negotiate format acceptable for all pipeline entities.
+ * @param plugin - this plugin.
+ * @param dev_fmt - requested video device format.
+ *
+ * Negotiate common format acceptable by all the pipeline entities,
+ * that is closest to the requested one.
+ *
+ * @return 0 if the negotiation succeeded,
+ * 	   or negative error code on failure.
+ */
+static int negotiate_pipeline_fmt(struct exynos4_camera_plugin *plugin,
+				  struct v4l2_format *dev_fmt)
+{
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 }, common_fmt;
+	int repeat_negotiation, cnt_negotiation = 0, ret, pad_id, i;
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	enum v4l2_subdev_fmt_mismatch fmt_err;
+	struct media_entity *entity;
+
+	if (pipeline == NULL || dev_fmt == NULL)
+		return -EINVAL;
+
+	mbus_fmt.width = dev_fmt->fmt.pix_mp.width;
+	mbus_fmt.height = dev_fmt->fmt.pix_mp.height;
+	mbus_fmt.field = dev_fmt->fmt.pix_mp.field;
+	mbus_fmt.colorspace = dev_fmt->fmt.pix_mp.colorspace;
+
+	if (has_pipeline_entity(plugin, EXYNOS4_FIMC_IS_ISP))
+		adjust_format_to_fimc_is_isp(&mbus_fmt);
+
+	V4L2_EXYNOS4_DBG("Begin pipeline format negotiation...");
+
+	for (;;) {
+		repeat_negotiation = 0;
+		entity = pipeline[0].entity;
+
+		pad_id = pipeline[0].src_pad->index;
+
+		V4L2_EXYNOS4_DBG("Setting format on the source entity pad %s:%d",
+				 media_entity_get_info(entity)->name, pad_id);
+
+		ret = v4l2_subdev_set_format(entity, &mbus_fmt,
+					     pad_id, V4L2_SUBDEV_FORMAT_TRY);
+		if (ret < 0)
+			return ret;
+
+		V4L2_EXYNOS4_DBG("Format set on the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+				 media_entity_get_info(entity)->name, pad_id,
+				 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+				 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+				 mbus_fmt.width, mbus_fmt.height);
+
+		common_fmt = mbus_fmt;
+
+		/* Stop iterating on last but one entity as it is not a sub-device. */
+		for (i = 1; i < plugin->pipeline_len - 1; i++) {
+			entity = pipeline[i].entity;
+
+			pad_id = pipeline[i].sink_pad->index;
+
+			V4L2_EXYNOS4_DBG("Setting format on the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+					 media_entity_get_info(entity)->name, pad_id,
+					 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+					 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+					 mbus_fmt.width, mbus_fmt.height);
+
+			/* Set format on the entity sink pad. */
+			ret = v4l2_subdev_set_format(entity, &mbus_fmt, pad_id,
+							V4L2_SUBDEV_FORMAT_TRY);
+			if (ret < 0)
+				return ret;
+
+			fmt_err = v4l2_subdev_format_compare(&mbus_fmt, &common_fmt);
+			if (fmt_err) {
+				if (fmt_err == FMT_MISMATCH_WIDTH &&
+				     !strncmp(media_entity_get_info(entity)->name,
+					      EXYNOS4_FIMC_LITE_PREFIX,
+					      strlen(EXYNOS4_FIMC_LITE_PREFIX))) {
+					/*
+					 * Align width downwards, according to the FIMC-LITE
+					 * width step. Otherwise pipeline format negotiation
+					 * wouldn't succeed for widths excessing maximum sensor
+					 * frame width, which is probed by GStreamer, no matter
+					 * what actual frame size is to be set.
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
+			if (!strncmp(media_entity_get_info(entity)->name,
+				     EXYNOS4_FIMC_PREFIX,
+				     strlen(EXYNOS4_FIMC_PREFIX)))
+				break;
+
+			pad_id = pipeline[i].src_pad->index;
+
+			/* Get format on the entity src pad */
+			ret = v4l2_subdev_get_format(entity, &mbus_fmt, pad_id,
+							V4L2_SUBDEV_FORMAT_TRY);
+			if (ret < 0)
+				return -EINVAL;
+
+			V4L2_EXYNOS4_DBG("Format propagated to the pad %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+					 media_entity_get_info(entity)->name, pad_id,
+					 v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+					 v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+					 mbus_fmt.width, mbus_fmt.height);
+
+			if (!strcmp(media_entity_get_info(entity)->name,
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
+		}
+
+		if (!repeat_negotiation) {
+			break;
+		} else if (++cnt_negotiation > EXYNOS4_MAX_FMT_NEGO_NUM) {
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
+/**
+ * @brief Apply previously negotiated pipeline format
+ * @param plugin - this plugin.
+ *
+ * Apply the format, previously negotiated with negotiate_pipeline_fmt(),
+ * on all the pipeline v4l2 sub-devices.
+ *
+ * @return 0 if the format was successfuly applied,
+ * 	   or negative error code on failure.
+ */
+static int apply_pipeline_fmt(struct exynos4_camera_plugin *plugin,
+			      struct v4l2_format *fmt)
+{
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 };
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	struct media_pad *pad;
+	unsigned int i;
+	int ret;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < plugin->pipeline_len - 1; i++) {
+		entity = pipeline[i].entity;
+		/*
+		 * Source entity is linked only through a source pad
+		 * and this pad should be used for setting the format.
+		 * For other entities set the format on a sink pad.
+		 */
+		pad = pipeline[i].sink_pad ? pipeline[i].sink_pad :
+					pipeline[i].src_pad;
+		if (pad == NULL)
+			return -EINVAL;
+
+		ret = v4l2_subdev_get_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_TRY);
+
+		if (ret < 0)
+			return ret;
+
+		V4L2_EXYNOS4_DBG("VIDIOC_SUBDEV_G_FMT %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+			  media_entity_get_info(entity)->name, pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+			  mbus_fmt.width, mbus_fmt.height);
+
+		ret = v4l2_subdev_set_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_ACTIVE);
+		if (ret < 0)
+			return ret;
+
+		V4L2_EXYNOS4_DBG("VIDIOC_SUBDEV_S_FMT %s:%d: mcode: %s, cs: %s, w: %d, h: %d",
+			  media_entity_get_info(entity)->name, pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  v4l2_subdev_colorspace_to_string(mbus_fmt.colorspace),
+			  mbus_fmt.width, mbus_fmt.height);
+	}
+
+	/*
+	 * Sink entity represents /dev/videoN node and is not
+	 * a sub-device. Nonetheless because it has associated
+	 * file descriptor and can expose v4l2-controls the
+	 * v4l2-subdev structure is used for caching the
+	 * related data.
+	 */
+	struct v4l2_subdev *sd =
+		media_entity_get_v4l2_subdev(pipeline[i].entity);
+	if (!sd)
+		return -EINVAL;
+
+	ret = SYS_IOCTL(sd->fd, VIDIOC_S_FMT, fmt);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * @brief Open all v4l2 sub-devices associated with pipeline entities
+ * @param plugin - this plugin.
+ *
+ * Open all v4l2 sub-devices associated with the entities of the pipeline
+ * discovered with discover_pipeline_by_entity().
+ *
+ * @return 0 if all v4l2 sub-devices were opened successfuly,
+ * 	   or negative error code on failure.
+ */
+static int open_pipeline(struct exynos4_camera_plugin *plugin)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	unsigned int i;
+	int ret;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	/*
+	 * Stop walking the pipeline on the last but one entity, because
+	 * the sink entity was already opened by libv4l2 core.
+	 */
+	for (i = 0; i < plugin->pipeline_len - 1; i++) {
+		entity = pipeline[i].entity;
+		V4L2_EXYNOS4_DBG("Opening sub-device: %s",
+				 media_entity_get_info(entity)->name);
+		ret = v4l2_subdev_open(entity);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * @brief Check if there was a v4l2_ctrl binding defined for the entity
+ * @param entity - media entity.
+ * @param ctrl_id - v4l2 control identifier.
+ *
+ * Check if there was a v4l2-ctrl-binding entry defined for the entity.
+ *
+ * @return true if the binding exists, false otherwise.
+ */
+static bool has_v4l2_ctrl_binding(struct media_entity *entity,
+				       int ctrl_id)
+{
+	struct v4l2_subdev *sd = media_entity_get_v4l2_subdev(entity);
+	int i;
+
+	if (!sd)
+		return false;
+
+	for (i = 0; i < sd->num_v4l2_ctrl_bindings; ++i)
+		if (sd->v4l2_ctrl_bindings[i] == ctrl_id)
+			return true;
+
+	return false;
+}
+
+/**
+ * @brief Get the first pipeline entity with matching v4l2-ctrl-binding.
+ * @param plugin - this plugin.
+ * @param cid - v4l2-control identifier.
+ *
+ * Get the first pipeline entity for which v4l2-control-binding
+ * with given cid was defined.
+ *
+ * @return associated entity if defined, or NULL if no matching
+ *         v4l2-ctrl-binding was defined for any entity
+ *         in the pipeline.
+ */
+static struct media_entity *get_pipeline_entity_by_cid(
+				struct exynos4_camera_plugin *plugin,
+				int cid)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	unsigned int i;
+
+	if (pipeline == NULL)
+		return NULL;
+
+	for (i = 0; i < plugin->pipeline_len; i++) {
+		entity = pipeline[i].entity;
+		if (has_v4l2_ctrl_binding(entity, cid))
+			return entity;
+	}
+
+	return NULL;
+}
+
+/**
+ * @brief Check if the entity is of capture type
+ * @param entity_name - name of the entity to check
+ *
+ * Check if the entity name ends with a "capture", which
+ * gives a hint that it is of capture type.
+ *
+ * @return True if the entity name ends with a "capture"
+ *         string, and false otherwise.
+ */
+static bool is_capture_entity(const char *entity_name)
+{
+	const char capture_segment[] = "capture";
+	int cap_segment_pos;
+
+	if (entity_name == NULL)
+		return false;
+
+	cap_segment_pos = strlen(entity_name) - strlen(capture_segment);
+
+	if (strcmp(entity_name + cap_segment_pos, capture_segment) == 0)
+		return true;
+
+	return false;
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
+/* -----------------------------------------------------------------------------
+ * Ioctl handlers
+ */
+
+static int set_fmt_ioctl(struct exynos4_camera_plugin *plugin,
+				unsigned long int cmd,
+				struct v4l2_format *arg,
+				enum v4l2_subdev_format_whence set_mode)
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
+	ret = negotiate_pipeline_fmt(plugin, &fmt);
+	if (ret < 0)
+		return ret;
+
+	if (set_mode == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = apply_pipeline_fmt(plugin, &fmt);
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
+int ctrl_ioctl(struct exynos4_camera_plugin *plugin,
+	       unsigned long int request, struct v4l2_control *arg)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	struct v4l2_control ctrl = *arg;
+	struct v4l2_queryctrl queryctrl = { 0 };
+	bool ctrl_found = false;
+	int i, ret;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	/*
+	 * The control has to be reset to the default value
+	 * on all of the pipeline entities, prior setting a new
+	 * value. This is required in cases when the control config
+	 * is changed between subsequent calls to VIDIOC_S_CTRL,
+	 * to avoid the situation when a control is set on more
+	 * than one sub-device.
+	 */
+	if (request == VIDIOC_S_CTRL) {
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			struct v4l2_control ctrl_def = ctrl;
+
+			entity = pipeline[i].entity;
+
+			queryctrl.id = ctrl.id;
+
+			/* query default control value */
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_QUERYCTRL, &queryctrl);
+			if (ret < 0)
+				continue;
+
+			ctrl_found = true;
+
+			if (queryctrl.type & V4L2_CTRL_TYPE_BUTTON)
+				break;
+
+			ctrl_def.value = queryctrl.default_value;
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_S_CTRL, &ctrl_def);
+			if (ret < 0)
+				return -EINVAL;
+		}
+
+		if (!ctrl_found) {
+			ret = -EINVAL;
+			goto exit;
+		}
+	}
+
+	entity = get_pipeline_entity_by_cid(plugin, ctrl.id);
+
+	if (entity) {
+		ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+				request, &ctrl);
+	} else {
+		/* Walk the pipeline until the request succeeds */
+		ret = -ENOENT;
+
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			entity = pipeline[i].entity;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					request, &ctrl);
+			if (!ret)
+				break;
+		}
+	}
+
+exit:
+	*arg = ctrl;
+
+	V4L2_EXYNOS4_DBG("%s [id: 0x%8.8x, name: %s, entity: %s, val: %d] (%d)",
+		VIDIOC_CTRL(request), ctrl.id, ret ? NULL : queryctrl.name,
+		entity ? media_entity_get_info(entity)->name : NULL,
+		ctrl.value, ret);
+
+	return ret;
+}
+
+static int single_ext_ctrl_ioctl(struct exynos4_camera_plugin *plugin,
+				 unsigned long int request,
+				 struct v4l2_ext_controls *arg)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	struct v4l2_ext_controls ctrls = *arg;
+	struct v4l2_ext_control *ctrl = &ctrls.controls[0];
+	struct v4l2_query_ext_ctrl queryctrl;
+	bool ctrl_found = 0;
+	int i, ret = -EINVAL;
+
+	/*
+	 * The control has to be reset to the default value
+	 * on all of the pipeline entities, prior setting a new
+	 * value. This is required in cases when the control config
+	 * is changed between subsequent calls to VIDIOC_S_EXT_CTRLS,
+	 * to avoid the situation when a control is set on more
+	 * than one sub-device.
+	 */
+	if (request == VIDIOC_S_EXT_CTRLS) {
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			struct v4l2_ext_controls ctrls_def = ctrls;
+			struct v4l2_ext_control *ctrl_def = &ctrls_def.controls[0];
+
+			entity = pipeline[i].entity;
+
+			queryctrl.id = ctrl->id;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_QUERY_EXT_CTRL, &queryctrl);
+			if (ret < 0)
+				continue;
+
+			ctrl_found = true;
+
+			if (queryctrl.type & V4L2_CTRL_TYPE_BUTTON)
+				break;
+
+			ctrl_def->value64 = queryctrl.default_value;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_S_EXT_CTRLS, &ctrls_def);
+			if (ret < 0)
+				return -EINVAL;
+		}
+
+		if (!ctrl_found) {
+			ret = -EINVAL;
+			goto exit;
+		}
+	}
+
+	entity = get_pipeline_entity_by_cid(plugin, ctrl->id);
+
+	if (entity) {
+		ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+				request, &ctrls);
+	} else {
+		/* Walk the pipeline until the request succeeds */
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			entity = pipeline[i].entity;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					request, &ctrls);
+			if (!ret)
+				break;
+		}
+	}
+
+exit:
+	*arg = ctrls;
+
+	V4L2_EXYNOS4_DBG("%s [id: 0x%8.8x, name: %s, entity: %s, val: %lld] (%d)",
+		VIDIOC_EXT_CTRL(request), ctrl->id, ret ? NULL : queryctrl.name,
+		entity ? media_entity_get_info(entity)->name : NULL,
+		(long long) ctrl->id & V4L2_CTRL_TYPE_INTEGER64 ?
+			ctrl->value64 : ctrl->value, ret);
+
+	return ret;
+}
+
+int ext_ctrl_ioctl(struct exynos4_camera_plugin *plugin,
+		   unsigned long int request,
+		   struct v4l2_ext_controls *arg)
+{
+	struct v4l2_ext_controls out_ctrls = *arg, ctrls = *arg;
+	int ret = -EINVAL, i;
+
+	ctrls.count = 1;
+
+	/*
+	 * Split cluster to individual ioctl calls for each control
+	 * from the array, to make possible redirection of every
+	 * single control to different sub-device, according to the
+	 * configuration settings.
+	 */
+	for (i = 0; i < arg->count; ++i) {
+		ctrls.controls = &arg->controls[i];
+
+		ret = single_ext_ctrl_ioctl(plugin, request, &ctrls);
+		out_ctrls.controls[i] = ctrls.controls[i];
+		if (ret < 0) {
+			if (ctrls.error_idx == 1)
+				out_ctrls.error_idx = ctrls.count;
+			else
+				out_ctrls.error_idx = i;
+			break;
+		}
+	}
+
+	*arg = out_ctrls;
+	return ret;
+}
+
+int sort_ctrls(const void * a, const void * b)
+{
+	const struct media_entity_to_cid *ctrl_a = a, *ctrl_b = b;
+
+	return ctrl_a->queryctrl.id - ctrl_b->queryctrl.id;
+}
+
+int queryctrl_ioctl(struct exynos4_camera_plugin *plugin,
+		    struct v4l2_queryctrl *arg)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity, *target_entity = NULL;
+	struct v4l2_queryctrl queryctrl = *arg;
+	struct media_entity_to_cid *ctrls_found = NULL;
+	int i, ret = -EINVAL, num_ctrls = 0;
+
+	/*
+	 * If id is or'ed with V4L2_CTRL_FLAG_NEXT_CTRL then the control to
+	 * be found is the one with the next lowest id among all entities
+	 * in the pipeline.
+	 */
+	if (queryctrl.id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		ctrls_found = malloc(sizeof(*ctrls_found));
+
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			entity = pipeline[i].entity;
+
+			queryctrl = *arg;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_QUERYCTRL, &queryctrl);
+			if (!ret) {
+				ctrls_found = realloc(ctrls_found,
+					sizeof(*ctrls_found) * (num_ctrls + 1));
+				ctrls_found[num_ctrls].queryctrl = queryctrl;
+				ctrls_found[num_ctrls].entity = entity;
+				++num_ctrls;
+			}
+		}
+	}
+
+	if (num_ctrls > 0) {
+		qsort(ctrls_found, num_ctrls, sizeof(*ctrls_found),
+		      sort_ctrls);
+
+		queryctrl = ctrls_found[0].queryctrl;
+		target_entity = ctrls_found[0].entity;
+	} else {
+		ret = -EINVAL;
+		entity = NULL;
+		goto done;
+	}
+
+	entity = get_pipeline_entity_by_cid(plugin, queryctrl.id);
+	if (entity)
+		target_entity = entity;
+
+	ret = SYS_IOCTL(media_entity_get_v4l2_subdev(target_entity)->fd,
+			VIDIOC_QUERYCTRL, &queryctrl);
+
+done:
+	if (ctrls_found)
+		free(ctrls_found);
+
+	V4L2_EXYNOS4_DBG(
+		"VIDIOC_QUERYCTRL [id: 0x%8.8x, name: %s, entity: %s] (%d)",
+		ret ? arg->id : queryctrl.id, ret ? NULL : queryctrl.name,
+		target_entity ? media_entity_get_info(target_entity)->name :
+			NULL, ret);
+
+	*arg = queryctrl;
+
+	return ret;
+}
+
+int query_ext_ctrl_ioctl(struct exynos4_camera_plugin *plugin,
+			 struct v4l2_query_ext_ctrl *arg)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity, *target_entity = NULL;
+	struct v4l2_query_ext_ctrl query_ext_ctrl = *arg;
+	struct media_entity_to_cid *ctrls_found = NULL;
+	int i, ret = -EINVAL, num_ctrls = 0;
+
+	/*
+	 * If id is or'ed with V4L2_CTRL_FLAG_NEXT_CTRL then the control to
+	 * be found is the one with the next lowest id among all entities
+	 * in the pipeline.
+	 */
+	if (query_ext_ctrl.id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		ctrls_found = malloc(sizeof(*ctrls_found));
+
+		for (i = 0; i < plugin->pipeline_len; i++) {
+			entity = pipeline[i].entity;
+
+			query_ext_ctrl = *arg;
+
+			ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+					VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl.id);
+			if (!ret) {
+				ctrls_found = realloc(ctrls_found,
+					sizeof(*ctrls_found) * (num_ctrls + 1));
+				ctrls_found[num_ctrls].query_ext_ctrl =
+								query_ext_ctrl;
+				ctrls_found[num_ctrls].entity = entity;
+				++num_ctrls;
+			}
+		}
+	}
+
+	if (num_ctrls > 0) {
+		qsort(ctrls_found, num_ctrls, sizeof(*ctrls_found),
+		      sort_ctrls);
+
+		query_ext_ctrl = ctrls_found[0].query_ext_ctrl;
+		target_entity = ctrls_found[0].entity;
+	} else {
+		ret = -EINVAL;
+		entity = NULL;
+		goto done;
+	}
+
+	entity = get_pipeline_entity_by_cid(plugin, query_ext_ctrl.id);
+	if (entity)
+		target_entity = entity;
+
+	ret = SYS_IOCTL(media_entity_get_v4l2_subdev(target_entity)->fd,
+			VIDIOC_QUERYCTRL, &query_ext_ctrl);
+
+done:
+	if (ctrls_found)
+		free(ctrls_found);
+
+	V4L2_EXYNOS4_DBG(
+		"VIDIOC_QUERY_EXT_CTRL [id: 0x%8.8x, name: %s, entity: %s] (%d)",
+		ret ? arg->id : query_ext_ctrl.id,
+		ret ? NULL : query_ext_ctrl.name,
+		target_entity ? media_entity_get_info(target_entity)->name :
+				NULL, ret);
+
+	*arg = query_ext_ctrl;
+
+	return ret;
+}
+
+int querymenu_ioctl(struct exynos4_camera_plugin *plugin,
+		    struct v4l2_querymenu *arg)
+{
+	struct pipeline_entity *pipeline = plugin->pipeline;
+	struct media_entity *entity;
+	struct v4l2_querymenu querymenu = *arg;
+	int i, ret = -EINVAL;
+
+	entity = get_pipeline_entity_by_cid(plugin, querymenu.id);
+	if (entity) {
+		ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+			        VIDIOC_QUERYMENU, &querymenu);
+		goto exit;
+	}
+
+	for (i = 0; i < plugin->pipeline_len; i++) {
+		entity = pipeline[i].entity;
+
+		ret = SYS_IOCTL(media_entity_get_v4l2_subdev(entity)->fd,
+				VIDIOC_QUERYMENU, &querymenu);
+		if (!ret)
+			break;
+	}
+
+exit:
+	*arg = querymenu;
+
+	V4L2_EXYNOS4_DBG(
+		"VIDIOC_QUERYMENU [id: 0x%8.8x, name: %s, entity: %s] (%d)",
+		querymenu.id, ret ? NULL : querymenu.name,
+		entity ? media_entity_get_info(entity)->name : NULL, ret);
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
+	/*
+	 * Create a representation of the media device
+	 * containing the opened video device.
+	 */
+	media = media_device_new_by_subdev_fd(fd, &sink_entity);
+	if (media == NULL) {
+		V4L2_EXYNOS4_ERR("Failed to create media device.");
+		return NULL;
+	}
+
+#ifdef DEBUG
+	media_debug_set_handler(media, (void (*)(void *, ...))fprintf, stdout);
+#endif
+
+	sink_entity_name = media_entity_get_info(sink_entity)->name;
+
+	/* Check if video entity is of capture type, not m2m */
+	if (!is_capture_entity(sink_entity_name)) {
+		V4L2_EXYNOS4_ERR("Device not of capture type.");
+		goto err_get_sink_entity;
+	}
+
+	/*
+	 * Initialize sink_entity subdev fd with the one opened
+	 * by the libv4l core to avoid losing it on pipeline opening.
+	 */
+	v4l2_subdev_create_opened(sink_entity, fd);
+
+	/* Parse media configuration file and apply its settings */
+	ret = mediatext_parse_setup_config(media, EXYNOS4_CAPTURE_CONF);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Media config parser error.");
+		goto err_get_sink_entity;
+	}
+
+	/* Allocate private data */
+	plugin = calloc(1, sizeof(*plugin));
+	if (!plugin)
+		goto err_get_sink_entity;
+
+	plugin->media = media;
+
+	/*
+	 * Discover the pipeline of sub-devices from a camera sensor
+	 * to the opened video device.
+	 */
+	ret = discover_pipeline_by_entity(plugin, sink_entity);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error discovering video pipeline.");
+		goto err_discover_pipeline;
+	}
+
+	/* Open all sub-devices in the discovered pipeline */
+	ret = open_pipeline(plugin);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error opening video pipeline.");
+		goto err_discover_pipeline;
+	}
+
+	V4L2_EXYNOS4_LOG("Initialized exynos4-camera plugin.");
+
+	return plugin;
+
+err_discover_pipeline:
+	free(plugin);
+err_get_sink_entity:
+	if (media)
+		media_device_unref(media);
+	return NULL;
+}
+
+static void plugin_close(void *dev_ops_priv)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+
+	if (plugin == NULL)
+		return;
+
+	media_device_unref(plugin->media);
+
+	free(plugin);
+}
+
+static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int cmd,
+			void *arg)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	switch (cmd) {
+	case VIDIOC_S_CTRL:
+	case VIDIOC_G_CTRL:
+		return ctrl_ioctl(plugin, cmd, arg);
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+		return ext_ctrl_ioctl(plugin, cmd, arg);
+	case VIDIOC_QUERYCTRL:
+		return queryctrl_ioctl(plugin, arg);
+	case VIDIOC_QUERY_EXT_CTRL:
+		return query_ext_ctrl_ioctl(plugin, arg);
+	case VIDIOC_QUERYMENU:
+		return querymenu_ioctl(plugin, arg);
+	case VIDIOC_TRY_FMT:
+		return set_fmt_ioctl(plugin, cmd, arg,
+				     V4L2_SUBDEV_FORMAT_TRY);
+	case VIDIOC_S_FMT:
+		return set_fmt_ioctl(plugin, cmd, arg,
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
1.9.1

