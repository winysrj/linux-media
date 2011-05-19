Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:33002 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab1ESMgf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:36:35 -0400
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [libv4l-mcplugin PATCH 3/3] Add libv4l2 media controller plugin interface files
Date: Thu, 19 May 2011 15:36:12 +0300
Message-Id: <8bdf58a1bb2b7b095faf72e1ca40291b14bb1541.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
References: <cover.1305804894.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add interface functions init(), close() and ioctl(), called by libv4l2.

Signed-off-by: Yordan Kamenov <ykamenov@mm-sol.com>
---
 libv4l2plugin-omap3mc.c |  241 +++++++++++++++++++++++++++++++++++++++++++++++
 libv4l2plugin-omap3mc.h |   91 ++++++++++++++++++
 2 files changed, 332 insertions(+), 0 deletions(-)
 create mode 100644 libv4l2plugin-omap3mc.c
 create mode 100644 libv4l2plugin-omap3mc.h

diff --git a/libv4l2plugin-omap3mc.c b/libv4l2plugin-omap3mc.c
new file mode 100644
index 0000000..e5b5ef0
--- /dev/null
+++ b/libv4l2plugin-omap3mc.c
@@ -0,0 +1,241 @@
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
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <glob.h>
+#include <linux/videodev2.h>
+#include <mediactl/media.h>
+
+#include "libv4l2-plugin.h"
+#include "libv4l2plugin-omap3mc.h"
+#include "paths.h"
+#include "operations.h"
+
+#if __GNUC__ >= 4
+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
+#define PLUGIN_HIDDEN __attribute__ ((visibility("hidden")))
+#else
+#define PLUGIN_PUBLIC
+#define PLUGIN_HIDDEN
+#endif
+
+/* Check if /dev/media0 is already open*/
+int media_in_use()
+{
+	int glob_ret, file, ret = 0;
+	glob_t globbuf;
+	ssize_t link_len;
+	char file_name[16];
+
+	glob_ret = glob("/proc/self/fd/*", 0, NULL, &globbuf);
+
+	if (glob_ret == GLOB_NOSPACE)
+		return ret;
+
+	if (glob_ret == GLOB_ABORTED || glob_ret == GLOB_NOMATCH)
+		goto leave;
+
+	for (file = 0; file < globbuf.gl_pathc; file++) {
+		link_len = readlink(globbuf.gl_pathv[file],
+					file_name, strlen(MEDIA_DEVICE));
+		if (link_len == strlen(MEDIA_DEVICE))
+			file_name[link_len] = '\0';
+		else
+			continue;
+
+		if (!strncmp(file_name, MEDIA_DEVICE, strlen(MEDIA_DEVICE))) {
+			ret = 1;
+			break;
+		}
+	}
+
+leave:
+	globfree(&globbuf);
+
+	return ret;
+}
+
+PLUGIN_HIDDEN void * omap3mc_init(int fd)
+{
+	int ret = -1, primary;
+	struct omap3mcplugin *plugin;
+	const struct capture_pipeline *pipe = NULL;
+	struct sub_module *dst_sub_module = NULL;
+	char link_path[20];
+	ssize_t link_len;
+	char file[VIDEO_NODE_LENGTH + 1];
+
+	/* Get filename from fd */
+	sprintf(link_path, "/proc/self/fd/%d", fd);
+	link_len = readlink(link_path, file, VIDEO_NODE_LENGTH);
+	if (link_len == VIDEO_NODE_LENGTH)
+		link_path[link_len] = '\0';
+	else
+		return NULL;
+
+	/* FIXME: What we do if the application is aware of video nodes
+	   and tries to open() real /dev/video0 (CSI2 capture) */
+	if (strncmp(file, VIDEO_PRIMARY, strlen(VIDEO_PRIMARY)) == 0)
+		primary = 1;
+	else if (strncmp(file, VIDEO_SECONDARY, strlen(VIDEO_SECONDARY)) == 0)
+		primary = 0;
+	else
+		return NULL;
+
+	if (media_in_use())
+		return NULL;
+
+	plugin = calloc(1, sizeof(*plugin));
+	if (plugin == NULL)
+		return NULL;
+
+	plugin->media = media_open(MEDIA_DEVICE, 1);
+	if (plugin->media == NULL) {
+		free(plugin);
+		return NULL;
+	}
+
+	pipe = pipe_sensor_yuv(primary);
+
+	if (pipe)
+		plugin->path = path_allocate(plugin->media, pipe);
+
+	if (plugin->path)
+		dst_sub_module = path_destination_submodule(plugin->path);
+
+	if (dst_sub_module)
+		ret = path_power_on(plugin->path, fd);
+
+	if (ret == 0)
+		ret = path_connect_entities(plugin->media, plugin->path);
+
+	plugin->fd = dst_sub_module->entity->fd;
+
+	if (ret != 0) {
+		path_disconnect_entities(plugin->media, plugin->path);
+		path_power_off(plugin->path);
+
+		media_close(plugin->media);
+		free(plugin);
+		plugin = NULL;
+	}
+
+	return plugin;
+}
+
+PLUGIN_HIDDEN void omap3mc_close(void *dev_ops_priv)
+{
+	struct omap3mcplugin *plugin;
+
+	if (dev_ops_priv == NULL)
+		return;
+
+	plugin = (struct omap3mcplugin *)dev_ops_priv;
+
+	path_disconnect_entities(plugin->media, plugin->path);
+	path_power_off(plugin->path);
+
+	media_close(plugin->media);
+
+	free(plugin);
+}
+
+PLUGIN_HIDDEN int omap3mc_ioctl(void *dev_ops_priv, int fd,
+						unsigned long int request, void *arg)
+{
+	int ret = -1;
+	struct omap3mcplugin *plugin;
+
+	plugin = (struct omap3mcplugin *)dev_ops_priv;
+
+	switch (request) {
+	case VIDIOC_STREAMON:
+		ret = mc_vidioc_streamon(plugin, request, arg);
+		break;
+	case VIDIOC_STREAMOFF:
+		ret = mc_vidioc_streamoff(plugin, request, arg);
+		break;
+	case VIDIOC_S_FMT:
+		ret = mc_vidioc_s_fmt(plugin, request, arg);
+		break;
+	case VIDIOC_G_FMT:
+		ret = mc_vidioc_g_fmt(plugin, request, arg);
+		break;
+	case VIDIOC_TRY_FMT:
+		ret = mc_vidioc_try_fmt(plugin, request, arg);
+		break;
+	case VIDIOC_S_CROP:
+		ret = mc_vidioc_s_crop(plugin, request, arg);
+		break;
+	case VIDIOC_G_CROP:
+		ret = mc_vidioc_g_crop(plugin, request, arg);
+		break;
+	case VIDIOC_QUERYCTRL:
+		ret = mc_vidioc_queryctrl(plugin, request, arg);
+		break;
+	case VIDIOC_G_CTRL:
+		ret = mc_vidioc_g_ctrl(plugin, request, arg);
+		break;
+	case VIDIOC_S_CTRL:
+		ret = mc_vidioc_s_ctrl(plugin, request, arg);
+		break;
+	case VIDIOC_QUERYCAP:
+		ret = mc_vidioc_querycap(plugin, request, arg);
+		break;
+	case VIDIOC_ENUM_FMT:
+		ret = mc_vidioc_enum_fmt(plugin, request, arg);
+		break;
+	case VIDIOC_ENUM_FRAMESIZES:
+		ret = mc_vidioc_enum_framesizes(plugin, request, arg);
+		break;
+	case VIDIOC_ENUM_FRAMEINTERVALS:
+		ret = mc_vidioc_enum_frameintervals(plugin, request, arg);
+		break;
+	case VIDIOC_REQBUFS:
+		ret = mc_vidioc_reqbufs(plugin, request, arg);
+		break;
+	case VIDIOC_QUERYBUF:
+		ret = mc_vidioc_querybuf(plugin, request, arg);
+		break;
+	case VIDIOC_QBUF:
+		ret = mc_vidioc_qbuf(plugin, request, arg);
+		break;
+	case VIDIOC_DQBUF:
+		ret = mc_vidioc_dqbuf(plugin, request, arg);
+		break;
+	default:
+		errno = EINVAL;
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+PLUGIN_PUBLIC const struct libv4l2_dev_ops libv4l2_plugin = {
+	.init = &omap3mc_init,
+	.close = &omap3mc_close,
+	.ioctl = &omap3mc_ioctl,
+	.read = NULL
+};
diff --git a/libv4l2plugin-omap3mc.h b/libv4l2plugin-omap3mc.h
new file mode 100644
index 0000000..430df96
--- /dev/null
+++ b/libv4l2plugin-omap3mc.h
@@ -0,0 +1,91 @@
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
+#ifndef __LIBV4L2PLUGIN_OMAP3MC_H__
+#define __LIBV4L2PLUGIN_OMAP3MC_H__
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <mediactl/media.h>
+
+#include "sl_list.h"
+
+#define SYS_OPEN(file, oflag, mode) \
+	syscall(SYS_open, (const char *)(file), (int)(oflag), (mode_t)(mode))
+#define SYS_CLOSE(fd) \
+	syscall(SYS_close, (int)(fd))
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+
+#define VIDEO_PRIMARY "/dev/video0"
+#define VIDEO_SECONDARY "/dev/video1"
+#define VIDEO_NODE_LENGTH 11
+#define MEDIA_DEVICE "/dev/media0"
+
+#define PIPELINE_MAX_ELEMENTS 32
+#define SUBDEVICE_MAX_NAME_LEN 32
+#define PIXELFMT_MAX_ELEMENTS 10
+
+#define MC_PLUGIN_VERBOSE
+#ifdef MC_PLUGIN_VERBOSE
+#define MC_PLUGIN_PRINTF(str,args...) \
+			printf("%s():%d: " str, __FUNCTION__,__LINE__,##args)
+#endif
+
+
+
+/* pixel formats */
+enum mc_plugin_pixelformat {
+	MC_PLUGIN_PIX_FMT_INVALID = 0,
+	MC_PLUGIN_PIX_FMT_BAYER8_SBGGR,
+	MC_PLUGIN_PIX_FMT_BAYER8_SGBRG,
+	MC_PLUGIN_PIX_FMT_BAYER8_SGRBG,
+	MC_PLUGIN_PIX_FMT_BAYER10_SGRBG,
+	MC_PLUGIN_PIX_FMT_BAYER10_SRGGB,
+	MC_PLUGIN_PIX_FMT_BAYER10_SBGGR,
+	MC_PLUGIN_PIX_FMT_BAYER10_SGBRG,
+	MC_PLUGIN_PIX_FMT_BAYER10DPCM8_SGRBG,
+	MC_PLUGIN_PIX_FMT_YUYV,
+	MC_PLUGIN_PIX_FMT_UYVY
+};
+
+struct capture_pipeline {
+	char path[PIPELINE_MAX_ELEMENTS][SUBDEVICE_MAX_NAME_LEN];
+	enum mc_plugin_pixelformat in_pixfmt[PIXELFMT_MAX_ELEMENTS];
+	enum mc_plugin_pixelformat out_pixfmt[PIXELFMT_MAX_ELEMENTS];
+};
+
+struct ipipe_descriptor {
+	const struct capture_pipeline *pipe;
+	struct list_head container;
+};
+struct sub_module {
+	struct media_entity *entity;
+	struct list_head list;
+};
+
+
+struct omap3mcplugin {
+	struct media_device *media;
+	struct ipipe_descriptor *path;
+	int fd;
+};
+
+#endif /* __LIBV4L2PLUGIN_OMAP3MC_H__ */
-- 
1.7.3.1

