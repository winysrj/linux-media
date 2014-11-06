Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40344 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaKFKMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:24 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00GEV4CMMNC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:22 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 09/11] mediactl: Add media device ioctl API
Date: Thu, 06 Nov 2014 11:11:40 +0100
Message-id: <1415268702-23685-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ioctls executed on complex media devices need special
handling. E.g. S_FMT requires negotiation for the whole
pipeline of sub-devices. On the other hand some ioctls
need to be targeted for specific sub-devices. The API
being introduced address such requirements.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/Makefile.am          |    2 +-
 utils/media-ctl/libv4l2media_ioctl.c |  342 ++++++++++++++++++++++++++++++++++
 utils/media-ctl/libv4l2media_ioctl.h |   47 +++++
 3 files changed, 390 insertions(+), 1 deletion(-)
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.c
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.h

diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index 3e883e0..7f18624 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -1,6 +1,6 @@
 noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
 
-libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
+libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h libv4l2media_ioctl.c libv4l2media_ioctl.h
 libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
 libmediactl_la_LDFLAGS = -static $(LIBUDEV_LIBS)
 
diff --git a/utils/media-ctl/libv4l2media_ioctl.c b/utils/media-ctl/libv4l2media_ioctl.c
new file mode 100644
index 0000000..c2c5972
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.c
@@ -0,0 +1,342 @@
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
+#include <errno.h>
+#include <linux/videodev2.h>
+#include <sys/ioctl.h>
+
+#include "libv4l2media_ioctl.h"
+#include "mediactl.h"
+
+int media_ioctl_set_fmt(struct media_device *media,
+				struct v4l2_format *fmt)
+{
+	struct v4l2_subdev_format sd_fmt = { 0 };
+	struct media_entity *pipeline = media->pipeline;
+	int ret;
+
+	while (pipeline) {
+		sd_fmt = pipeline->subdev_fmt;
+		sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_SUBDEV_S_FMT,
+			    &sd_fmt);
+		if (ret < 0)
+			return ret;
+
+		pipeline = pipeline->next;
+
+		/* Last entity in the pipeline is not a sub-device */
+		if (pipeline->next == NULL)
+			break;
+	}
+
+	ret = SYS_IOCTL(pipeline->fd, VIDIOC_S_FMT, fmt);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int media_ioctl_ctrl(struct media_device *media, int request,
+			struct v4l2_control *arg)
+{
+	struct media_entity *pipeline = media->pipeline, *entity;
+	struct v4l2_control ctrl = *arg;
+	struct v4l2_queryctrl queryctrl;
+	int ret = -EINVAL;
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
+		while (pipeline) {
+			queryctrl.id = ctrl.id;
+
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYCTRL,
+								&queryctrl);
+			if (ret < 0) {
+				pipeline = pipeline->next;
+				continue;
+			}
+
+			ctrl.value = queryctrl.default_value;
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_S_CTRL, &ctrl);
+			if (ret < 0)
+				return -EINVAL;
+
+			pipeline = pipeline->next;
+		}
+
+		ctrl.value = arg->value;
+	}
+
+	entity = media_config_get_entity_by_cid(media, ctrl.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, request, &ctrl);
+		media_dbg(media, "Ioctl result for user control 0x%8.8x on %s: %d\n",
+					ctrl.id, entity->info.name, ret);
+		goto exit;
+	}
+
+	media_dbg(media, "No config for control id 0x%8.8x\n", ctrl.id);
+
+	/* Walk the pipeline until the request succeeds */
+	pipeline = media->pipeline;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, request, &ctrl);
+		if (!ret) {
+			media_dbg(media, "Ioctl succeeded for user control 0x%8.8x on %s\n",
+						ctrl.id, pipeline->info.name);
+			goto exit;
+		}
+
+		pipeline = pipeline->next;
+	}
+
+	media_dbg(media, "Setting control 0x%8.8x failed\n", ctrl.id);
+
+exit:
+	*arg = ctrl;
+	return ret;
+}
+
+static int media_ioctl_single_ext_ctrl(struct media_device *media,
+				int request, struct v4l2_ext_controls *arg)
+{
+	struct media_entity *pipeline = media->pipeline, *entity;
+	struct v4l2_ext_controls ctrls = *arg;
+	struct v4l2_ext_control *ctrl;
+	struct v4l2_query_ext_ctrl queryctrl;
+	int ret = -EINVAL;
+
+	ctrl = &ctrls.controls[0];
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
+		while (pipeline) {
+			queryctrl.id = ctrl->id;
+
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERY_EXT_CTRL,
+								&queryctrl);
+			if (ret < 0) {
+				pipeline = pipeline->next;
+				continue;
+			}
+
+			ctrl->value64 = queryctrl.default_value;
+
+			ret = SYS_IOCTL(pipeline->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+			if (ret < 0)
+				return -EINVAL;
+
+			pipeline = pipeline->next;
+		}
+
+		ctrl->value64 = arg->controls[0].value64;
+	}
+
+	entity = media_config_get_entity_by_cid(media, ctrl->id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, request, &ctrls);
+		media_dbg(media, "Ioctl result for extended control 0x%8.8x on %s: %d\n",
+					ctrl->id, entity->info.name, ret);
+		goto exit;
+	}
+
+	media_dbg(media, "No config for control id 0x%8.8x\n", ctrl->id);
+
+	/* Walk the pipeline until the request succeeds */
+	pipeline = media->pipeline;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, request, &ctrls);
+		if (!ret) {
+			media_dbg(media, "Ioctl succeeded for extended control 0x%8.8x on %s\n",
+						ctrl->id, pipeline->info.name);
+			goto exit;
+		}
+
+
+		pipeline = pipeline->next;
+	}
+
+exit:
+	*arg = ctrls;
+	return ret;
+}
+
+int media_ioctl_ext_ctrl(struct media_device *media, int request,
+			struct v4l2_ext_controls *arg)
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
+		ret = media_ioctl_single_ext_ctrl(media, request, &ctrls);
+		out_ctrls.controls[i] = ctrls.controls[i];
+		if (ret < 0) {
+			if (ctrls.error_idx == 1)
+				out_ctrls.error_idx = ctrls.count;
+			else
+				out_ctrls.error_idx = i;
+			goto exit;
+		}
+	}
+
+exit:
+	*arg = out_ctrls;
+	return ret;
+}
+
+int media_ioctl_queryctrl(struct media_device *media,
+				struct v4l2_queryctrl *arg)
+{
+	struct media_entity *pipeline = media->pipeline, *entity;
+	struct v4l2_queryctrl queryctrl = *arg;
+	int ret = -EINVAL;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYCTRL, &queryctrl);
+		if (!ret) {
+			/*
+			 * Control id might be or'ed with V4L2_CTRL_FLAG_NEXT_CTRL,
+			 * therefore the check for the config settings must be
+			 * done no sooner than after first successful ioctl execution
+			 * on a pipeline sub-device.
+			 */
+			entity = media_config_get_entity_by_cid(media, queryctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (entity) {
+				media_dbg(media, "Queryctrl: \"%s\" control found in the config\n", queryctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (entity->fd != pipeline->fd)
+					ret = SYS_IOCTL(entity->fd, VIDIOC_QUERYCTRL, &queryctrl);
+			}
+
+			media_dbg(media, "Queryctrl: \"%s\" control on %s (%d)\n",
+						queryctrl.name, entity ? entity->info.name :
+									 pipeline->info.name,
+									 ret);
+			break;
+		}
+
+		pipeline = pipeline->next;
+	}
+
+	*arg = queryctrl;
+	return ret;
+}
+
+int media_ioctl_query_ext_ctrl(struct media_device *media,
+				struct v4l2_query_ext_ctrl *arg)
+{
+	struct media_entity *pipeline = media->pipeline, *entity;
+	struct v4l2_query_ext_ctrl query_ext_ctrl = *arg;
+	int ret = -EINVAL;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl);
+		if (!ret) {
+			/*
+			 * Control id might be or'ed with V4L2_CTRL_FLAG_NEXT_CTRL,
+			 * therefore the check for the config settings must be
+			 * done no sooner than after first successful ioctl execution
+			 * on a pipeline sub-device.
+			 */
+			entity = media_config_get_entity_by_cid(media, query_ext_ctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (entity) {
+				media_dbg(media, "Query ext control: \"%s\" found in config\n", query_ext_ctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (entity->fd != pipeline->fd)
+					ret = SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl);
+			}
+
+			media_dbg(media, "Query ext control: \"%s\" on %s (%d)\n",
+						query_ext_ctrl.name, entity ?
+									entity->info.name :
+									pipeline->info.name,
+									ret);
+			break;
+		}
+
+		pipeline = pipeline->next;
+	}
+
+	*arg = query_ext_ctrl;
+	return ret;
+}
+
+int media_ioctl_querymenu(struct media_device *media,
+				struct v4l2_querymenu *arg)
+{
+	struct media_entity *pipeline = media->pipeline, *entity;
+	struct v4l2_querymenu querymenu = *arg;
+	int ret = -EINVAL;
+
+	entity = media_config_get_entity_by_cid(media, querymenu.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, VIDIOC_QUERYMENU, &querymenu);
+		media_dbg(media, "Querymenu result for the control 0x%8.8x on %s: %d\n",
+					querymenu.id, entity->info.name, ret);
+		goto exit;
+	}
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYMENU, &querymenu);
+		if (!ret) {
+			media_dbg(media, "Querymenu succeeded for the control 0x%8.8x on %s\n",
+					querymenu.id, pipeline->info.name);
+			goto exit;
+		}
+
+		pipeline = pipeline->next;
+	}
+
+exit:
+	*arg = querymenu;
+	return ret;
+}
diff --git a/utils/media-ctl/libv4l2media_ioctl.h b/utils/media-ctl/libv4l2media_ioctl.h
new file mode 100644
index 0000000..9e52c03
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.h
@@ -0,0 +1,47 @@
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
+#ifndef __LIBV4L2MEDIA_IOCTL_H
+#define __LIBV4L2MEDIA_IOCTL_H
+
+#include <linux/videodev2.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+#include "mediactl-priv.h"
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+int media_ioctl_set_fmt(struct media_device *media,
+			struct v4l2_format *fmt);
+
+int media_ioctl_ctrl(struct media_device *media, int request,
+			struct v4l2_control *arg);
+
+int media_ioctl_ext_ctrl(struct media_device *media, int request,
+			struct v4l2_ext_controls *arg);
+
+int media_ioctl_queryctrl(struct media_device *media,
+			struct v4l2_queryctrl *arg);
+
+int media_ioctl_query_ext_ctrl(struct media_device *media,
+			struct v4l2_query_ext_ctrl *arg);
+
+int media_ioctl_querymenu(struct media_device *media,
+			struct v4l2_querymenu *arg);
+
+#endif /* __LIBV4L2MEDIA_IOCTL_H */
-- 
1.7.9.5

