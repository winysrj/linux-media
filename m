Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46182 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaJQOzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:55:24 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDL00KS7G4BMS30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Oct 2014 23:55:23 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v2 4/4] Add a libv4l plugin for Exynos4 camera
Date: Fri, 17 Oct 2014 16:54:42 +0200
Message-id: <1413557682-20535-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plugin provides support for the media device on Exynos4 SoC.
It performs single plane <-> multi plane API conversion,
video pipeline linking and takes care of automatic data format
negotiation for the whole pipeline, after intercepting
VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 configure.ac                                      |    1 +
 lib/Makefile.am                                   |    5 +-
 lib/libv4l-exynos4-camera/Makefile.am             |    8 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  569 +++++++++++++++++++++
 lib/libv4l2/Makefile.am                           |    5 +-
 5 files changed, 585 insertions(+), 3 deletions(-)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
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
index 0000000..a83c3f2
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/Makefile.am
@@ -0,0 +1,8 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
+endif
+
+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c
+libv4l_exynos4_camera_la_CPPFLAGS = -fvisibility=hidden -std=gnu99
+libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
+libv4l_exynos4_camera_la_LIBADD = ../libv4l2/libv4l2-mdev.la
diff --git a/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
new file mode 100644
index 0000000..150c700
--- /dev/null
+++ b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
@@ -0,0 +1,569 @@
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
+#include <libv4l2-mdev.h>
+#include <libv4l2-mdev-ioctl.h>
+#include <libv4l2-media-conf-parser.h>
+#include <linux/types.h>
+#include <stdlib.h>
+#include <string.h>
+#include "libv4l-plugin.h"
+
+/*
+ * struct exynos4_camera_plugin - libv4l exynos4 camera plugin
+ * @mdev:		media device comprising the vid_fd related video device
+ */
+struct exynos4_camera_plugin {
+	struct media_device mdev;
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
+#define EXYNOS4_FIMC_DRV	"exynos4-fimc"
+#define EXYNOS4_FIMC_LITE_DRV	"exynos-fimc-lit"
+#define EXYNOS4_FIMC_IS_ISP_DRV	"exynos4-fimc-is"
+#define ENTITY_CAPTURE_SEGMENT	"capture"
+#define EXYNOS4_CAPTURE_CONF	"/var/lib/libv4l/exynos4_capture_conf"
+#define EXYNOS4_FIMC_IS_ISP	"FIMC-IS-ISP"
+#define EXYNOS4_FIMC_PREFIX	"FIMC."
+#define MAX_FMT_NEGO_NUM	50
+
+
+static int __capture_entity(char *name)
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
+	mbus_fmt->width += 16;
+	mbus_fmt->height += 12;
+
+	return 0;
+}
+
+static int negotiate_pipeline_fmt(struct media_entity *pipeline,
+				  struct v4l2_format *dev_fmt)
+{
+	struct media_entity *vid_pipe = pipeline;
+	struct v4l2_subdev_format subdev_fmt = { 0 };
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 }, common_fmt;
+	int repeat_negotiation, cnt_negotiation = 0, ret;
+
+	if (pipeline == NULL || dev_fmt == NULL)
+		return -EINVAL;
+
+	mbus_fmt.width = dev_fmt->fmt.pix_mp.width;
+	mbus_fmt.height = dev_fmt->fmt.pix_mp.height;
+	mbus_fmt.field = dev_fmt->fmt.pix_mp.field;
+	mbus_fmt.colorspace = dev_fmt->fmt.pix_mp.colorspace;
+
+	subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
+
+	if (mdev_has_pipeline_entity(vid_pipe, EXYNOS4_FIMC_IS_ISP)) {
+		ret = __adjust_format_to_fimc_is_isp(&mbus_fmt);
+		if (ret < 0)
+			return ret;
+	}
+
+	subdev_fmt.format = mbus_fmt;
+
+	for (;;) {
+		repeat_negotiation = 0;
+		vid_pipe = pipeline;
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
+		vid_pipe = vid_pipe->next;
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
+			if (!mdev_verify_format(&subdev_fmt.format, &common_fmt)) {
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
+			if (!mdev_verify_format(&subdev_fmt.format, &common_fmt)) {
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
+static int set_fmt_ioctl(struct media_device *mdev,
+			 unsigned long int cmd,
+			 struct v4l2_format *arg,
+			 enum v4l2_subdev_format_whence set_mode)
+{
+	struct v4l2_format fmt = { 0 };
+	struct v4l2_format *org = arg;
+	int ret;
+
+	fmt.type = convert_type(arg->type);
+	if (fmt.type != arg->type) {
+		fmt.fmt.pix_mp.width = org->fmt.pix.width;
+		fmt.fmt.pix_mp.height = org->fmt.pix.height;
+		fmt.fmt.pix_mp.pixelformat = org->fmt.pix.pixelformat;
+		fmt.fmt.pix_mp.field = org->fmt.pix.field;
+		fmt.fmt.pix_mp.colorspace = org->fmt.pix.colorspace;
+		fmt.fmt.pix_mp.num_planes = 1;
+		fmt.fmt.pix_mp.flags = org->fmt.pix.flags;
+		fmt.fmt.pix_mp.plane_fmt[0].bytesperline = org->fmt.pix.bytesperline;
+		fmt.fmt.pix_mp.plane_fmt[0].sizeimage = org->fmt.pix.sizeimage;
+	} else {
+		fmt = *org;
+	}
+
+	ret = negotiate_pipeline_fmt(mdev->pipeline, &fmt);
+	if (ret < 0)
+		return ret;
+
+	if (set_mode == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		ret = mdev_ioctl_set_fmt(mdev, &fmt);
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
+		org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+		org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+		org->fmt.pix.flags = fmt.fmt.pix_mp.flags;
+	} else {
+		*org = fmt;
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
+	struct v4l2_format *org = arg;
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
+	memset(&org->fmt.pix, 0, sizeof(org->fmt.pix));
+	org->fmt.pix.width = fmt.fmt.pix_mp.width;
+	org->fmt.pix.height = fmt.fmt.pix_mp.height;
+	org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+	org->fmt.pix.field = fmt.fmt.pix_mp.field;
+	org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+	org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+	org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+	org->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+	org->fmt.pix.flags = fmt.fmt.pix_mp.flags;
+
+	/*
+	 * If the device doesn't support just one plane, there's
+	 * nothing we can do, except return an error condition.
+	 */
+	if (fmt.fmt.pix_mp.num_planes > 1) {
+		errno = EINVAL;
+		return -1;
+	}
+
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
+static int querycap_ioctl(struct media_device *mdev,
+			  struct v4l2_capability *arg)
+{
+	int ret;
+
+	ret = SYS_IOCTL(mdev->vid_fd, VIDIOC_QUERYCAP, arg);
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
+        if (strcmp((char *) cap.driver, EXYNOS4_FIMC_DRV) &&
+	    strcmp((char *) cap.driver, EXYNOS4_FIMC_LITE_DRV) &&
+	    strcmp((char *) cap.driver, EXYNOS4_FIMC_IS_ISP_DRV)) {
+		V4L2_EXYNOS4_ERR("Not an Exynos4 device.");
+		return NULL;
+	}
+
+	/* Get media node for the device */
+	ret = mdev_get_media_node(mdev, fd, &media_entity_name);
+	if (ret < 0)
+		return NULL;
+
+	/* Check if video entity is of capture type, not m2m */
+	if (!__capture_entity(media_entity_name)) {
+		V4L2_EXYNOS4_ERR("Device not of capture type.");
+		close(mdev->media_fd);
+		return NULL;
+	}
+
+	ret = libv4l2_media_conf_read(EXYNOS4_CAPTURE_CONF, &mdev->config);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error reading media device configuration.");
+		close(mdev->media_fd);
+		return NULL;
+	}
+
+	ret = mdev_setup_config_links(mdev, mdev->config.links);
+	/* Release links as they will not be used anymore */
+	libv4l2_media_conf_release_links(mdev->config.links);
+
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Video entities linking failed.");
+		close(mdev->media_fd);
+		return NULL;
+	}
+
+	/* refresh device topology data after linking */
+	mdev_release_entities(mdev);
+
+	ret = mdev_get_device_topology(mdev);
+
+	/* close media device fd as it won't be longer required */
+	close(mdev->media_fd);
+
+	if (ret < 0)
+		goto err_get_dev_topology;
+
+	/* discover a pipeline for the capture device */
+	ret = mdev_discover_pipeline_by_fd(mdev, fd);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error discovering video pipeline.");
+		goto err_discover_pipeline;
+	}
+
+	ret = mdev_open_pipeline_subdevs(mdev->pipeline);
+	if (ret < 0) {
+		V4L2_EXYNOS4_ERR("Error opening video pipeline.");
+		goto err_discover_pipeline;
+	}
+
+	if (mdev->config.controls) {
+		ret = mdev_validate_control_config(mdev, mdev->config.controls);
+		if (ret < 0) {
+			V4L2_EXYNOS4_ERR("Error validating control configuration.");
+			goto err_validate_controls;
+		}
+	}
+
+	/* Allocate and initialize private data */
+	ret_plugin = calloc(1, sizeof(*ret_plugin));
+	if (!ret_plugin)
+		goto err_validate_controls;
+
+	mdev->vid_fd = fd;
+
+	V4L2_EXYNOS4_LOG("Initialized exynos4-camera plugin.");
+
+	*ret_plugin = plugin;
+
+	return ret_plugin;
+
+err_validate_controls:
+	mdev_close_pipeline_subdevs(mdev->pipeline);
+err_discover_pipeline:
+	mdev_release_entities(mdev);
+err_get_dev_topology:
+	libv4l2_media_conf_release_controls(mdev->config.controls);
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
+	mdev_close_pipeline_subdevs(mdev->pipeline);
+	mdev_release_entities(mdev);
+	libv4l2_media_conf_release_controls(mdev->config.controls);
+
+	free(plugin);
+}
+
+static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int cmd,
+							void *arg)
+{
+	struct exynos4_camera_plugin *plugin = dev_ops_priv;
+	struct media_device *mdev;
+
+	if (plugin == NULL || arg == NULL)
+		return -EINVAL;
+
+	mdev = &plugin->mdev;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	switch (cmd) {
+	case VIDIOC_S_CTRL:
+	case VIDIOC_G_CTRL:
+		return mdev_ioctl_ctrl(mdev, cmd, arg);
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+		return mdev_ioctl_ext_ctrl(mdev, cmd, arg);
+	case VIDIOC_QUERYCTRL:
+		return mdev_ioctl_queryctrl(mdev, arg);
+	case VIDIOC_QUERY_EXT_CTRL:
+		return mdev_ioctl_query_ext_ctrl(mdev, arg);
+	case VIDIOC_QUERYMENU:
+		return mdev_ioctl_querymenu(mdev, arg);
+	case VIDIOC_TRY_FMT:
+		return set_fmt_ioctl(mdev, cmd, arg,
+				     V4L2_SUBDEV_FORMAT_TRY);
+	case VIDIOC_S_FMT:
+		return set_fmt_ioctl(mdev, cmd, arg,
+				     V4L2_SUBDEV_FORMAT_ACTIVE);
+	case VIDIOC_G_FMT:
+		return get_fmt_ioctl(mdev->vid_fd, cmd, arg);
+	case VIDIOC_QUERYCAP:
+		return querycap_ioctl(mdev, arg);
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_PREPARE_BUF:
+		return buf_ioctl(mdev->vid_fd, cmd, arg);
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
diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
index c60f89b..868135a 100644
--- a/lib/libv4l2/Makefile.am
+++ b/lib/libv4l2/Makefile.am
@@ -2,6 +2,7 @@ if WITH_LIBV4L
 lib_LTLIBRARIES = libv4l2.la
 include_HEADERS = ../include/libv4l2.h ../include/libv4l-plugin.h
 pkgconfig_DATA = libv4l2.pc
+noinst_LTLIBRARIES = libv4l2-mdev.la
 LIBV4L2_VERSION = -version-info 0
 if WITH_V4L_WRAPPERS
 libv4l2priv_LTLIBRARIES = v4l2convert.la
@@ -12,7 +13,7 @@ install-exec-hook:
 
 endif
 else
-noinst_LTLIBRARIES = libv4l2.la
+noinst_LTLIBRARIES = libv4l2.la libv4l2-mdev.la
 endif
 
 libv4l2_la_SOURCES = libv4l2.c v4l2-plugin.c log.c libv4l2-priv.h
@@ -24,3 +25,5 @@ v4l2convert_la_SOURCES = v4l2convert.c
 v4l2convert_la_LIBADD = libv4l2.la
 v4l2convert_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
 v4l2convert_la_LIBTOOLFLAGS = --tag=disable-static
+
+libv4l2_mdev_la_SOURCES = libv4l2-mdev.c libv4l2-media-conf-parser.c ../include/libv4l2-mdev.h ../include/libv4l-media-conf-parser.h libv4l2-mdev-ioctl.c ../include/libv4l2-mdev-ioctl.h
-- 
1.7.9.5

