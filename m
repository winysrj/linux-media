Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26019 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaKUQP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:28 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE00A12D5RN8C0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:15:27 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 10/11] mediactl: Add media device ioctl API
Date: Fri, 21 Nov 2014 17:14:39 +0100
Message-id: <1416586480-19982-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
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
 utils/media-ctl/libv4l2media_ioctl.c |  325 ++++++++++++++++++++++++++++++++++
 utils/media-ctl/libv4l2media_ioctl.h |   40 +++++
 3 files changed, 366 insertions(+), 1 deletion(-)
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
index 0000000..f2498e5
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.c
@@ -0,0 +1,325 @@
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
+#include <unistd.h>
+#include <linux/videodev2.h>
+#include <sys/syscall.h>
+
+#include "libv4l2media_ioctl.h"
+#include "../../utils/media-ctl/v4l2subdev.h"
+#include "mediactl-priv.h"
+#include "mediactl.h"
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+int media_ioctl_ctrl(struct media_device *media, int request,
+			struct v4l2_control *arg)
+{
+	struct media_entity *entity = media->pipeline;
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
+		while (entity) {
+			queryctrl.id = ctrl.id;
+
+			ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYCTRL,
+								&queryctrl);
+			if (ret < 0) {
+				entity = entity->next;
+				continue;
+			}
+
+			ctrl.value = queryctrl.default_value;
+			ret = SYS_IOCTL(entity->sd->fd, VIDIOC_S_CTRL, &ctrl);
+			if (ret < 0)
+				return -EINVAL;
+
+			entity = entity->next;
+		}
+
+		ctrl.value = arg->value;
+	}
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, ctrl.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrl);
+		media_dbg(media, "Ioctl result for user control 0x%8.8x on %s: %d\n",
+			  ctrl.id, entity->info.name, ret);
+		goto exit;
+	}
+
+	media_dbg(media, "No config for control id 0x%8.8x\n", ctrl.id);
+
+	/* Walk the pipeline until the request succeeds */
+	entity = media->pipeline;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrl);
+		if (!ret) {
+			media_dbg(media, "Ioctl succeeded for user control 0x%8.8x on %s\n",
+				  ctrl.id, entity->info.name);
+			goto exit;
+		}
+
+		entity = entity->next;
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
+	struct media_entity *entity = media->pipeline;
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
+		while (entity) {
+			queryctrl.id = ctrl->id;
+
+			ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERY_EXT_CTRL,
+								&queryctrl);
+			if (ret < 0) {
+				entity = entity->next;
+				continue;
+			}
+
+			ctrl->value64 = queryctrl.default_value;
+
+			ret = SYS_IOCTL(entity->sd->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+			if (ret < 0)
+				return -EINVAL;
+
+			entity = entity->next;
+		}
+
+		ctrl->value64 = arg->controls[0].value64;
+	}
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, ctrl->id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrls);
+		media_dbg(media, "Ioctl result for extended control 0x%8.8x on %s: %d\n",
+			  ctrl->id, entity->info.name, ret);
+		goto exit;
+	}
+
+	media_dbg(media, "No config for control id 0x%8.8x\n", ctrl->id);
+
+	/* Walk the pipeline until the request succeeds */
+	entity = media->pipeline;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrls);
+		if (!ret) {
+			media_dbg(media, "Ioctl succeeded for extended control 0x%8.8x on %s\n",
+				  ctrl->id, entity->info.name);
+			goto exit;
+		}
+
+
+		entity = entity->next;
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
+	struct media_entity *entity = media->pipeline, *target_ent;
+	struct v4l2_queryctrl queryctrl = *arg;
+	int ret = -EINVAL;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYCTRL, &queryctrl);
+		if (!ret) {
+			/*
+			 * Control id might be or'ed with V4L2_CTRL_FLAG_NEXT_CTRL,
+			 * therefore the check for the config settings must be
+			 * done no sooner than after first successful ioctl execution
+			 * on a pipeline sub-device.
+			 */
+			target_ent = v4l2_subdev_get_pipeline_entity_by_cid(media, queryctrl.id);
+
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (target_ent) {
+				media_dbg(media, "Queryctrl: \"%s\" control found in the config\n",
+					  queryctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (target_ent != entity)
+					ret = SYS_IOCTL(target_ent->sd->fd, VIDIOC_QUERYCTRL, &queryctrl);
+			}
+
+			media_dbg(media, "Queryctrl: \"%s\" control on %s (%d)\n",
+				  queryctrl.name, target_ent ? target_ent->info.name :
+							entity->info.name,
+							ret);
+			break;
+		}
+
+		entity = entity->next;
+	}
+
+	*arg = queryctrl;
+	return ret;
+}
+
+int media_ioctl_query_ext_ctrl(struct media_device *media,
+				struct v4l2_query_ext_ctrl *arg)
+{
+	struct media_entity *entity = media->pipeline, *target_ent;
+	struct v4l2_query_ext_ctrl query_ext_ctrl = *arg;
+	int ret = -EINVAL;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERY_EXT_CTRL, &query_ext_ctrl);
+		if (!ret) {
+			/*
+			 * Control id might be or'ed with V4L2_CTRL_FLAG_NEXT_CTRL,
+			 * therefore the check for the config settings must be
+			 * done no sooner than after first successful ioctl execution
+			 * on a pipeline sub-device.
+			 */
+			target_ent = v4l2_subdev_get_pipeline_entity_by_cid(media, query_ext_ctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (target_ent) {
+				media_dbg(media, "Query ext control: \"%s\" found in config\n",
+					  query_ext_ctrl.name);
+				/* Check if the control hasn't been already queried */
+				if (target_ent != entity)
+					ret = SYS_IOCTL(target_ent->sd->fd, VIDIOC_QUERY_EXT_CTRL,
+							&query_ext_ctrl);
+			}
+
+			media_dbg(media, "Query ext control: \"%s\" on %s (%d)\n",
+				  query_ext_ctrl.name, target_ent ?
+							target_ent->info.name :
+							entity->info.name,
+							ret);
+			break;
+		}
+
+		entity = entity->next;
+	}
+
+	*arg = query_ext_ctrl;
+	return ret;
+}
+
+int media_ioctl_querymenu(struct media_device *media,
+				struct v4l2_querymenu *arg)
+{
+	struct media_entity *entity = media->pipeline;
+	struct v4l2_querymenu querymenu = *arg;
+	int ret = -EINVAL;
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, querymenu.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYMENU, &querymenu);
+		media_dbg(media, "Querymenu result for the control 0x%8.8x on %s: %d\n",
+			  querymenu.id, entity->info.name, ret);
+		goto exit;
+	}
+
+	entity = media->pipeline;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYMENU, &querymenu);
+		if (!ret) {
+			media_dbg(media, "Querymenu succeeded for the control 0x%8.8x on %s\n",
+				  querymenu.id, entity->info.name);
+			goto exit;
+		}
+
+		entity = entity->next;
+	}
+
+exit:
+	*arg = querymenu;
+	return ret;
+}
diff --git a/utils/media-ctl/libv4l2media_ioctl.h b/utils/media-ctl/libv4l2media_ioctl.h
new file mode 100644
index 0000000..08547d4
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.h
@@ -0,0 +1,40 @@
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
+
+struct media_device;
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

