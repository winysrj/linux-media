Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53190 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbbBZQBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:01:03 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD004YNZ5QEGB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:01:02 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 12/14] mediactl: Add media device ioctl API
Date: Thu, 26 Feb 2015 16:59:22 +0100
Message-id: <1424966364-3647-13-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ioctls executed on complex media devices need special handling.
For instance some ioctls need to be targeted for specific sub-devices,
depending on the media device configuration. The APIs being introduced
address such requirements.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/Makefile.am          |    2 +-
 utils/media-ctl/libv4l2media_ioctl.c |  369 ++++++++++++++++++++++++++++++++++
 utils/media-ctl/libv4l2media_ioctl.h |   40 ++++
 3 files changed, 410 insertions(+), 1 deletion(-)
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
index 0000000..c324f01
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.c
@@ -0,0 +1,369 @@
+/*
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
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
+#include "mediactl-priv.h"
+#include "mediactl.h"
+#include "v4l2subdev.h"
+
+#define VIDIOC_CTRL(type)					\
+	((type) == VIDIOC_S_CTRL ? "VIDIOC_S_CTRL" :		\
+				   "VIDIOC_G_CTRL")
+
+#define VIDIOC_EXT_CTRL(type)					\
+	((type) == VIDIOC_S_EXT_CTRLS ? 			\
+		"VIDIOC_S_EXT_CTRLS"	:			\
+		 ((type) == VIDIOC_G_EXT_CTRLS ? 		\
+				    "VIDIOC_G_EXT_CTRLS" :	\
+				    "VIDIOC_TRY_EXT_CTRLS"))
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+
+int media_ioctl_ctrl(struct media_device *media, int request,
+		     struct v4l2_control *arg)
+{
+	struct media_entity *entity = media->pipeline;
+	struct v4l2_control ctrl = *arg;
+	struct v4l2_queryctrl queryctrl;
+	bool ctrl_found = 0;
+	int ret;
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
+					&queryctrl);
+			if (ret < 0) {
+				entity = entity->next;
+				continue;
+			}
+
+			ctrl_found = true;
+
+			if (queryctrl.type & V4L2_CTRL_TYPE_BUTTON)
+				break;
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
+	if (!ctrl_found) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, ctrl.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrl);
+		goto exit;
+	}
+
+	/* Walk the pipeline until the request succeeds */
+	entity = media->pipeline;
+
+	ret = -ENOENT;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrl);
+		if (!ret)
+			goto exit;
+
+		entity = entity->next;
+	}
+
+exit:
+	*arg = ctrl;
+
+	media_dbg(media, "%s [id: 0x%8.8x, entity: %s] (%d)\n",
+		  VIDIOC_CTRL(request), ctrl.id,
+		  entity ? entity->info.name : NULL, ret);
+
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
+	bool ctrl_found = 0;
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
+					&queryctrl);
+			if (ret < 0) {
+				entity = entity->next;
+				continue;
+			}
+
+			ctrl_found = true;
+
+			if (queryctrl.type & V4L2_CTRL_TYPE_BUTTON)
+				break;
+
+			ctrl->value64 = queryctrl.default_value;
+
+			ret = SYS_IOCTL(entity->sd->fd, VIDIOC_S_EXT_CTRLS,
+					&ctrls);
+			if (ret < 0)
+				return -EINVAL;
+
+			entity = entity->next;
+		}
+
+		ctrl->value64 = arg->controls[0].value64;
+	}
+
+	if (!ctrl_found) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, ctrl->id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrls);
+		goto exit;
+	}
+
+	/* Walk the pipeline until the request succeeds */
+	entity = media->pipeline;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, request, &ctrls);
+		if (!ret)
+			goto exit;
+
+		entity = entity->next;
+	}
+
+exit:
+	*arg = ctrls;
+
+	media_dbg(media, "%s [id: 0x%8.8x, entity: %s] (%d)\n",
+		  VIDIOC_EXT_CTRL(request), ctrl->id,
+		  entity ? entity->info.name : NULL, ret);
+
+	return ret;
+}
+
+int media_ioctl_ext_ctrl(struct media_device *media, int request,
+			 struct v4l2_ext_controls *arg)
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
+			  struct v4l2_queryctrl *arg)
+{
+	struct media_entity *entity = media->pipeline, *target_entity;
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
+			target_entity =
+				v4l2_subdev_get_pipeline_entity_by_cid(media,
+								queryctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (target_entity) {
+				/*
+				 * It might happen that pipeline head is the
+				 * target entity for the control - in such a
+				 * case preclude requering it.
+				 */
+				if (target_entity != entity)
+					ret = SYS_IOCTL(target_entity->sd->fd,
+							VIDIOC_QUERYCTRL,
+							&queryctrl);
+				entity = target_entity;
+			}
+
+			break;
+		}
+
+		entity = entity->next;
+	}
+
+	*arg = queryctrl;
+
+	media_dbg(media,
+		  "VIDIOC_QUERYCTRL [id: 0x%8.8x, entity: %s] (%d)\n",
+		  queryctrl.id, entity ? entity->info.name : NULL, ret);
+
+	return ret;
+}
+
+int media_ioctl_query_ext_ctrl(struct media_device *media,
+			       struct v4l2_query_ext_ctrl *arg)
+{
+	struct media_entity *entity = media->pipeline, *target_entity;
+	struct v4l2_query_ext_ctrl query_ext_ctrl = *arg;
+	int ret = -EINVAL;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERY_EXT_CTRL,
+				&query_ext_ctrl);
+		if (!ret) {
+			/*
+			 * Passed query_ext_ctrl.id id might be or'ed with
+			 * V4L2_CTRL_FLAG_NEXT_CTRL, therefore the check for
+			 * existence of the related configuration must be
+			 * done no sooner than after first successful ioctl
+			 * execution on a pipeline sub-device.
+			 */
+			target_entity =
+				v4l2_subdev_get_pipeline_entity_by_cid(media,
+								query_ext_ctrl.id);
+			/*
+			 * If the control is in the config, then
+			 * query the associated sub-device.
+			 */
+			if (target_entity) {
+				/*
+				 * It might happen that pipeline head is the
+				 * target entity for the control - in such a
+				 * case preclude requering it.
+				 */
+				if (target_entity != entity)
+					ret = SYS_IOCTL(target_entity->sd->fd,
+							VIDIOC_QUERY_EXT_CTRL,
+							&query_ext_ctrl);
+				entity = target_entity;
+			}
+
+			break;
+		}
+
+		entity = entity->next;
+	}
+
+	*arg = query_ext_ctrl;
+
+	media_dbg(media,
+		  "VIDIOC_QUERY_EXT_CTRL [id: 0x%8.8x, entity: %s] (%d)\n",
+		  query_ext_ctrl.id, entity ? entity->info.name : NULL, ret);
+
+	return ret;
+}
+
+int media_ioctl_querymenu(struct media_device *media,
+			  struct v4l2_querymenu *arg)
+{
+	struct media_entity *entity = media->pipeline;
+	struct v4l2_querymenu querymenu = *arg;
+	int ret = -EINVAL;
+
+	entity = v4l2_subdev_get_pipeline_entity_by_cid(media, querymenu.id);
+	if (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYMENU, &querymenu);
+		goto exit;
+	}
+
+	entity = media->pipeline;
+
+	while (entity) {
+		ret = SYS_IOCTL(entity->sd->fd, VIDIOC_QUERYMENU, &querymenu);
+		if (!ret)
+			goto exit;
+
+		entity = entity->next;
+	}
+
+exit:
+	*arg = querymenu;
+
+	media_dbg(media, "VIDIOC_QUERYMENU [id: 0x%8.8x, entity: %s] (%d)\n",
+		  querymenu.id, entity ? entity->info.name : NULL, ret);
+
+	return ret;
+}
diff --git a/utils/media-ctl/libv4l2media_ioctl.h b/utils/media-ctl/libv4l2media_ioctl.h
new file mode 100644
index 0000000..2841c09
--- /dev/null
+++ b/utils/media-ctl/libv4l2media_ioctl.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
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

