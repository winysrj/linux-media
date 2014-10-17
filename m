Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52285 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaJQOzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:55:20 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDL004CWG479300@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Oct 2014 23:55:19 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v2 3/4] Add wrappers for media device related ioctl calls.
Date: Fri, 17 Oct 2014 16:54:41 +0200
Message-id: <1413557682-20535-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some ioctl calls predestined for a media device have to
be separately executed on each sub-device of a pipeline
or redirected to the predefined one basing on the
configuration data. This patch adds wrappers that adjust
intercepted ioctl calls and execute them on every
required sub-device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 lib/include/libv4l2-mdev-ioctl.h |   45 ++++++
 lib/libv4l2/libv4l2-mdev-ioctl.c |  329 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 374 insertions(+)
 create mode 100644 lib/include/libv4l2-mdev-ioctl.h
 create mode 100644 lib/libv4l2/libv4l2-mdev-ioctl.c

diff --git a/lib/include/libv4l2-mdev-ioctl.h b/lib/include/libv4l2-mdev-ioctl.h
new file mode 100644
index 0000000..10326be
--- /dev/null
+++ b/lib/include/libv4l2-mdev-ioctl.h
@@ -0,0 +1,45 @@
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
+#ifndef __LIBV4L2_MDEV_IOCTL_H
+#define __LIBV4L2_MDEV_IOCTL_H
+
+#include <linux/videodev2.h>
+#include <libv4l2-mdev.h>
+
+int mdev_ioctl_set_fmt(struct media_device *mdev,
+			struct v4l2_format *fmt);
+
+int mdev_ioctl_ctrl(struct media_device *mdev, int request,
+			struct v4l2_control *arg);
+
+int mdev_ioctl_ext_ctrl(struct media_device *mdev, int request,
+			struct v4l2_ext_controls *arg);
+
+int mdev_ioctl_single_ext_ctrl(struct media_device *mdev,
+			int request, struct v4l2_ext_controls *arg);
+
+int mdev_ioctl_queryctrl(struct media_device *mdev,
+			struct v4l2_queryctrl *arg);
+
+int mdev_ioctl_query_ext_ctrl(struct media_device *mdev,
+			struct v4l2_query_ext_ctrl *arg);
+
+int mdev_ioctl_querymenu(struct media_device *mdev,
+			struct v4l2_querymenu *arg);
+
+#endif /* __LIBV4L2_MDEV_IOCTL_H */
diff --git a/lib/libv4l2/libv4l2-mdev-ioctl.c b/lib/libv4l2/libv4l2-mdev-ioctl.c
new file mode 100644
index 0000000..0347f37
--- /dev/null
+++ b/lib/libv4l2/libv4l2-mdev-ioctl.c
@@ -0,0 +1,329 @@
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
+#include <libv4l2-mdev-ioctl.h>
+
+int mdev_ioctl_set_fmt(struct media_device *mdev,
+				struct v4l2_format *fmt)
+{
+	struct v4l2_subdev_format sd_fmt = { 0 };
+	struct media_entity *pipeline = mdev->pipeline;
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
+int mdev_ioctl_ctrl(struct media_device *mdev, int request,
+			struct v4l2_control *arg)
+{
+	struct media_entity *pipeline = mdev->pipeline, *entity;
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
+	entity = mdev_conf_get_entity_by_cid(mdev->config.controls, ctrl.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, request, &ctrl);
+		V4L2_MDEV_DBG("Ioctl result for user control %x on %s: %d.",
+					ctrl.id, entity->name, ret);
+		goto exit;
+	}
+
+	V4L2_MDEV_DBG("No config for control id %x.", ctrl.id);
+
+	/* Walk the pipeline until the request succeeds */
+	pipeline = mdev->pipeline;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, request, &ctrl);
+		if (!ret) {
+			V4L2_MDEV_DBG("Ioctl succeeded for user control %x on %s.",
+						ctrl.id, pipeline->name);
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
+int mdev_ioctl_single_ext_ctrl(struct media_device *mdev,
+				int request, struct v4l2_ext_controls *arg)
+{
+	struct media_entity *pipeline = mdev->pipeline, *entity;
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
+	entity = mdev_conf_get_entity_by_cid(mdev->config.controls, ctrl->id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, request, &ctrls);
+		V4L2_MDEV_DBG("Ioctl result for extended control %x on %s: %d.",
+					ctrl->id, entity->name, ret);
+		goto exit;
+	}
+
+	V4L2_MDEV_DBG("No config for control id %x.", ctrl->id);
+
+	/* Walk the pipeline until the request succeeds */
+	pipeline = mdev->pipeline;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, request, &ctrls);
+		if (!ret) {
+			V4L2_MDEV_DBG("Ioctl succeeded for extended control %x on %s.",
+						ctrl->id, pipeline->name);
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
+int mdev_ioctl_ext_ctrl(struct media_device *mdev, int request,
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
+		ret = mdev_ioctl_single_ext_ctrl(mdev, request, &ctrls);
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
+int mdev_ioctl_queryctrl(struct media_device *mdev,
+				struct v4l2_queryctrl *arg)
+{
+	struct media_entity *pipeline = mdev->pipeline, *entity;
+	struct v4l2_queryctrl queryctrl = *arg;
+	int ret = -EINVAL;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYCTRL, &queryctrl);
+		if (!ret) {
+			entity = mdev_conf_get_entity_by_cid(mdev->config.controls,
+									queryctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (entity) {
+				V4L2_MDEV_DBG("Control \"%s\" found in config.", queryctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (entity->fd != pipeline->fd)
+					ret = SYS_IOCTL(entity->fd, VIDIOC_QUERYCTRL, &queryctrl);
+			}
+
+			V4L2_MDEV_DBG("Queryctrl ext control \"%s\" on %s (%d).",
+						queryctrl.name, entity ? entity->name :
+									 pipeline->name,
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
+int mdev_ioctl_query_ext_ctrl(struct media_device *mdev,
+				struct v4l2_query_ext_ctrl *arg)
+{
+	struct media_entity *pipeline = mdev->pipeline, *entity;
+	struct v4l2_query_ext_ctrl query_ext_ctrl = *arg;
+	int ret = -EINVAL;
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl);
+		if (!ret) {
+			entity = mdev_conf_get_entity_by_cid(mdev->config.controls,
+									query_ext_ctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (entity) {
+				V4L2_MDEV_DBG("Control \"%s\" found in config.", query_ext_ctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (entity->fd != pipeline->fd)
+					ret = SYS_IOCTL(entity->fd, VIDIOC_QUERYCTRL, &query_ext_ctrl);
+			}
+
+			V4L2_MDEV_DBG("Queryctrl ext control \"%s\" on %s (%d).",
+						query_ext_ctrl.name, entity ?
+									entity->name :
+									pipeline->name,
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
+int mdev_ioctl_querymenu(struct media_device *mdev,
+				struct v4l2_querymenu *arg)
+{
+	struct media_entity *pipeline = mdev->pipeline, *entity;
+	struct v4l2_querymenu querymenu = *arg;
+	int ret = -EINVAL;
+
+	entity = mdev_conf_get_entity_by_cid(mdev->config.controls, querymenu.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->fd, VIDIOC_QUERYMENU, &querymenu);
+		V4L2_MDEV_DBG("Querymenu result for the control %x on %s: %d.",
+					querymenu.id, entity->name, ret);
+		goto exit;
+	}
+
+	while (pipeline) {
+		ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYMENU, &querymenu);
+		if (!ret) {
+			V4L2_MDEV_DBG("Querymenu succeeded for the control %x on %s.",
+					querymenu.id, pipeline->name);
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
-- 
1.7.9.5

