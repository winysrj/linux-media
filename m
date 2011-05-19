Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:32997 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab1ESMgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:36:32 -0400
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [libv4l-mcplugin PATCH 2/3] Add files for v4l operations
Date: Thu, 19 May 2011 15:36:11 +0300
Message-Id: <dae3be20856f2597bfcfa5dca7f4e518ae7eac44.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add files with implementation of v4l ioctls.

Signed-off-by: Yordan Kamenov <ykamenov@mm-sol.com>
---
 operations.c |  611 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 operations.h |   44 +++++
 2 files changed, 655 insertions(+), 0 deletions(-)
 create mode 100644 operations.c
 create mode 100644 operations.h

diff --git a/operations.c b/operations.c
new file mode 100644
index 0000000..307785f
--- /dev/null
+++ b/operations.c
@@ -0,0 +1,611 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contact: Yordan Kamenov <ykamenov@mm-sol.com>
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
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#include <stdarg.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <stddef.h>
+
+#include <linux/v4l2-subdev.h>
+
+#include "sl_list.h"
+#include "operations.h"
+#include "paths.h"
+
+#define CHECK_DST_SUBMODULE(dst_sm, error_msg) {\
+	if ((dst_sm) == NULL) {\
+		MC_PLUGIN_PRINTF(error_msg);\
+		errno = EBADF;\
+		return -1;\
+	}\
+}
+
+int mc_vidioc_streamon(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct sub_module *dst_sub_module = NULL;
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "streamon failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_STREAMON, &type);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("streamon: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_streamoff(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct sub_module *dst_sub_module = NULL;
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "streamoff failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_STREAMOFF, &type);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("streamoff: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_s_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int pix_count, res_count, found = 0, ret = -1;
+	enum mc_plugin_pixelformat src_pixfmt, dst_pixfmt, temp_pixfmt;
+	struct v4l2_rect src_res, dst_res;
+	const int max_rect = 10;
+	struct v4l2_rect res[max_rect];
+	struct v4l2_format *arg;
+	va_list ap;
+	enum mc_plugin_pixelformat pixfmt;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_format *);
+	va_end(ap);
+
+	pixfmt = pixel_v4l_to_mc_plugin(arg->fmt.pix.pixelformat);
+
+	/* Check if destionation format is supported from pipeline */
+	for (pix_count = 0;
+		 MC_PLUGIN_PIX_FMT_INVALID != plugin->path->pipe->out_pixfmt[pix_count];
+		 pix_count++)
+		if (pixfmt == plugin->path->pipe->out_pixfmt[pix_count]) {
+			dst_pixfmt = pixfmt;
+			ret = 0;
+			break;
+		}
+
+	if (ret < 0) {
+		MC_PLUGIN_PRINTF("Destination format not supported\n");
+		errno = EINVAL;
+		return ret;
+	}
+
+	for (pix_count = 0;
+		 MC_PLUGIN_PIX_FMT_INVALID != plugin->path->pipe->in_pixfmt[pix_count];
+		 pix_count++) {
+
+		memset(res, 0x0, sizeof(res));
+		src_pixfmt = plugin->path->pipe->in_pixfmt[pix_count];
+		temp_pixfmt = src_pixfmt;
+
+		ret = path_enum_src_framesizes(plugin, &src_pixfmt, res, max_rect);
+
+		/* Find Best capture resolution */
+		for (res_count = 0; res_count < max_rect; res_count++) {
+
+			src_res = res[res_count];
+			dst_res.width = arg->fmt.pix.width;
+			dst_res.height = arg->fmt.pix.height;
+
+			/* If width and height are not valid we reach end of resolutions */
+			if (0 == res[res_count].width && 0 == res[res_count].height)
+				break;
+
+			ret = path_set_resolution(plugin, &src_res, &src_pixfmt,
+										&dst_res, &dst_pixfmt);
+			if (ret < 0) {
+				MC_PLUGIN_PRINTF("Set Resolution fail!\n");
+				break;
+			}
+
+			if (dst_res.width == arg->fmt.pix.width &&
+				dst_res.height == arg->fmt.pix.height &&
+				temp_pixfmt == src_pixfmt) {
+				/* Capture resolution found */
+				found = 1;
+				break;
+			}
+		}
+
+		if (1 == found)
+			break;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_g_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_format *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_format *);
+	va_end(ap);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "get format failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_G_FMT, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("get format: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_try_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int pix_count, res_count, found = 0, ret = -1;
+	enum mc_plugin_pixelformat src_pixfmt, dst_pixfmt, temp_pixfmt;
+	struct v4l2_rect src_res, dst_res;
+	const int max_rect = 10;
+	struct v4l2_rect res[max_rect];
+	struct v4l2_format *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_format *);
+	va_end(ap);
+
+	enum mc_plugin_pixelformat pixfmt = pixel_v4l_to_mc_plugin(arg->fmt.pix.pixelformat);
+
+	/* Check if destionation format is supported from pipeline */
+	for (pix_count = 0;
+		 MC_PLUGIN_PIX_FMT_INVALID != plugin->path->pipe->out_pixfmt[pix_count];
+		 pix_count++)
+		if (pixfmt == plugin->path->pipe->out_pixfmt[pix_count]) {
+			dst_pixfmt = pixfmt;
+			ret = 0;
+			break;
+		}
+
+	if (ret < 0) {
+		MC_PLUGIN_PRINTF("Destination format not supported\n");
+		errno = EINVAL;
+		return ret;
+	}
+
+	for (pix_count = 0;
+		 MC_PLUGIN_PIX_FMT_INVALID != plugin->path->pipe->in_pixfmt[pix_count];
+		 pix_count++) {
+
+		memset(res, 0x0, sizeof(res));
+		src_pixfmt = plugin->path->pipe->in_pixfmt[pix_count];
+		temp_pixfmt = src_pixfmt;
+
+		ret = path_enum_src_framesizes(plugin, &src_pixfmt, res, max_rect);
+
+		/* Find Best capture resolution */
+		for (res_count = 0; res_count < max_rect; res_count++) {
+
+			src_res = res[res_count];
+			dst_res.width = arg->fmt.pix.width;
+			dst_res.height = arg->fmt.pix.height;
+
+			/* If width and height are not valid we reach end of resolutions */
+			if (0 == res[res_count].width && 0 == res[res_count].height)
+				break;
+
+			ret = path_try_resolution(plugin, &src_res, &src_pixfmt,
+										&dst_res, &dst_pixfmt);
+			if (ret < 0) {
+				MC_PLUGIN_PRINTF("Set Resolution fail!\n");
+				break;
+			}
+
+			if (dst_res.width == arg->fmt.pix.width &&
+				dst_res.height == arg->fmt.pix.height &&
+				temp_pixfmt == src_pixfmt) {
+				/* Capture resolution found */
+				found = 1;
+				break;
+			}
+		}
+
+		if (1 == found)
+			break;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_s_crop(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_subdev_crop s_crop;
+	struct v4l2_crop *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_crop *);
+	va_end(ap);
+
+	memset (&s_crop, 0, sizeof (s_crop));
+	s_crop.pad = 0;    /* It has only one sink pad */
+	s_crop.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	s_crop.rect.top = arg->c.top;
+	s_crop.rect.left = arg->c.left;
+	s_crop.rect.width = arg->c.width;
+	s_crop.rect.height = arg->c.height;
+
+	ret = SYS_IOCTL(plugin->fd, VIDIOC_SUBDEV_S_CROP, &s_crop);
+	if (ret < 0) {
+		MC_PLUGIN_PRINTF("set crop: %s\n", strerror(errno));
+	} else {
+		arg->c.top = s_crop.rect.top;
+		arg->c.left = s_crop.rect.left;
+		arg->c.width = s_crop.rect.width;
+		arg->c.height = s_crop.rect.height;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_g_crop(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_subdev_crop g_crop;
+	struct v4l2_crop *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_crop *);
+	va_end(ap);
+
+	memset (&g_crop, 0, sizeof (g_crop));
+	g_crop.pad = 0;    /* It has only one sink pad */
+	g_crop.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+
+	ret = SYS_IOCTL(plugin->fd, VIDIOC_SUBDEV_G_CROP, &g_crop);
+	if (ret < 0) {
+		MC_PLUGIN_PRINTF("get crop: %s\n", strerror(errno));
+	} else {
+		arg->c.top = g_crop.rect.top;
+		arg->c.left = g_crop.rect.left;
+		arg->c.width = g_crop.rect.width;
+		arg->c.height = g_crop.rect.height;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_queryctrl(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct sub_module *sub_mod;
+	struct v4l2_queryctrl *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_queryctrl *);
+	va_end(ap);
+
+	list_for_each_entry(sub_mod, &plugin->path->container, list) {
+		ret = SYS_IOCTL(sub_mod->entity->fd, VIDIOC_QUERYCTRL, arg);
+		if (ret == 0)
+			break;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_g_ctrl(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct sub_module *sub_mod;
+	struct v4l2_control *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_control *);
+	va_end(ap);
+
+	list_for_each_entry(sub_mod, &plugin->path->container, list) {
+		ret = SYS_IOCTL(sub_mod->entity->fd, VIDIOC_G_CTRL, arg);
+		if (ret == 0)
+			break;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_s_ctrl(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct sub_module *sub_mod;
+	struct v4l2_control *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_control *);
+	va_end(ap);
+
+	list_for_each_entry(sub_mod, &plugin->path->container, list) {
+		ret = SYS_IOCTL(sub_mod->entity->fd, VIDIOC_S_CTRL, arg);
+		if (ret == 0)
+			break;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_querycap(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_capability *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_capability *);
+	va_end(ap);
+
+	ret = SYS_IOCTL(plugin->fd, VIDIOC_QUERYCAP, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("query capabilities: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_enum_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_fmtdesc *arg;
+	va_list ap;
+	struct v4l2_subdev_mbus_code_enum mbus_format;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_fmtdesc *);
+	va_end(ap);
+
+	mbus_format.pad = 0;
+	mbus_format.index = arg->index;
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "enum fmt failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_format);
+	if (ret == 0) {
+		arg->flags = 0;
+		arg->pixelformat = pixel_mc_plugin_to_v4l(mbus_format.code);
+	}
+
+	return ret;
+}
+
+int mc_vidioc_enum_framesizes(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_frmsizeenum *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_frmsizeenum *);
+	va_end(ap);
+
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "enum framesizes\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_ENUM_FRAMESIZES, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("enum framesizes: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_enum_frameintervals(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct media_entity *source, *sink;
+	struct media_link *link;
+	struct v4l2_subdev_frame_interval_enum e_interval;
+	const char *sink_name, *source_name;
+	struct v4l2_frmivalenum *arg;
+	va_list ap;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_frmivalenum *);
+	va_end(ap);
+
+	source_name = plugin->path->pipe->path[0];
+	sink_name = plugin->path->pipe->path[1];
+
+	source = media_get_entity_by_name(plugin->media, source_name, strlen(source_name));
+	sink = media_get_entity_by_name(plugin->media, sink_name, strlen(sink_name));
+
+	if ((NULL == sink) || (NULL == source)) {
+		MC_PLUGIN_PRINTF("Error finding entities\n");
+		errno = EBADF;
+		return -1;
+	}
+
+	link = media_find_link(plugin->media, source, sink);
+
+	if (NULL == link) {
+		MC_PLUGIN_PRINTF("No link present between source and sink\n");
+		errno = EBADF;
+		return -1;
+	}
+
+	e_interval.index = arg->index;
+	e_interval.code = arg->pixel_format;
+	e_interval.width = arg->width;
+	e_interval.height = arg->height;
+	e_interval.pad = link->source->index;
+
+	ret = SYS_IOCTL(source->fd, VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL, &e_interval);
+	if (ret == 0) {
+		arg->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+		arg->discrete.numerator = e_interval.interval.numerator;
+		arg->discrete.denominator = e_interval.interval.denominator;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_reqbufs(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_requestbuffers *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_requestbuffers *);
+	va_end(ap);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "request buffer failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_REQBUFS, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("request buffer: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_querybuf(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_buffer *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_buffer *);
+	va_end(ap);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "query failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_QUERYBUF, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("query buffer: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_qbuf(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_buffer *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_buffer *);
+	va_end(ap);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "queue buffer failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_QBUF, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("queue buffer: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
+
+int mc_vidioc_dqbuf(struct omap3mcplugin *plugin, unsigned long int request, ...)
+{
+	int ret = -1;
+	struct v4l2_buffer *arg;
+	va_list ap;
+	struct sub_module *dst_sub_module = NULL;
+
+	va_start(ap, request);
+	arg = va_arg(ap, struct v4l2_buffer *);
+	va_end(ap);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	CHECK_DST_SUBMODULE(dst_sub_module, "dequeue failed\n");
+
+	ret = SYS_IOCTL(dst_sub_module->entity->fd, VIDIOC_DQBUF, arg);
+	if (ret) {
+		int saved_err = errno;
+		MC_PLUGIN_PRINTF("dequeue buffer: %s\n", strerror(errno));
+		errno = saved_err;
+	}
+
+	return ret;
+}
diff --git a/operations.h b/operations.h
new file mode 100644
index 0000000..62129c0
--- /dev/null
+++ b/operations.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contact: Yordan Kamenov <ykamenov@mm-sol.com>
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
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#ifndef __OPERATIONS_H__
+#define __OPERATIONS_H__
+
+#include "libv4l2plugin-omap3mc.h"
+
+int mc_vidioc_streamon(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_streamoff(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_s_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_g_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_try_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_s_crop(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_g_crop(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_queryctrl(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_g_ctrl(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_s_ctrl(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_querycap(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_enum_fmt(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_enum_framesizes(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_enum_frameintervals(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_reqbufs(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_querybuf(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_qbuf(struct omap3mcplugin *plugin, unsigned long int request, ...);
+int mc_vidioc_dqbuf(struct omap3mcplugin *plugin, unsigned long int request, ...);
+
+#endif /* __OPERATIONS_H__ */
-- 
1.7.3.1

