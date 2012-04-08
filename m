Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab2DHP5y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:54 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 07/10] uvcvideo: Add support for control events
Date: Sun,  8 Apr 2012 17:59:51 +0200
Message-Id: <1333900794-1932-8-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |  120 +++++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvc_v4l2.c |   43 ++++++++++---
 drivers/media/video/uvc/uvcvideo.h |   20 ++++--
 3 files changed, 169 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 0c27cc1..bc837a4 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <media/v4l2-ctrls.h>
 
 #include "uvcvideo.h"
 
@@ -1102,6 +1103,116 @@ done:
 	return ret;
 }
 
+/* --------------------------------------------------------------------------
+ * Ctrl event handling
+ */
+
+static void uvc_ctrl_fill_event(struct uvc_video_chain *chain,
+	struct v4l2_event *ev,
+	struct uvc_control *ctrl,
+	struct uvc_control_mapping *mapping,
+	s32 value, u32 changes)
+{
+	struct v4l2_queryctrl v4l2_ctrl;
+
+	__uvc_query_v4l2_ctrl(chain, ctrl, mapping, &v4l2_ctrl);
+
+	memset(ev->reserved, 0, sizeof(ev->reserved));
+	ev->type = V4L2_EVENT_CTRL;
+	ev->id = v4l2_ctrl.id;
+	ev->u.ctrl.value = value;
+	ev->u.ctrl.changes = changes;
+	ev->u.ctrl.type = v4l2_ctrl.type;
+	ev->u.ctrl.flags = v4l2_ctrl.flags;
+	ev->u.ctrl.minimum = v4l2_ctrl.minimum;
+	ev->u.ctrl.maximum = v4l2_ctrl.maximum;
+	ev->u.ctrl.step = v4l2_ctrl.step;
+	ev->u.ctrl.default_value = v4l2_ctrl.default_value;
+}
+
+static void uvc_ctrl_send_event(struct uvc_fh *handle,
+	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
+	s32 value, u32 changes)
+{
+	struct v4l2_subscribed_event *sev;
+	struct v4l2_event ev;
+
+	if (list_empty(&mapping->ev_subs))
+		return;
+
+	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
+
+	list_for_each_entry(sev, &mapping->ev_subs, node)
+		if (sev->fh && (sev->fh != &handle->vfh ||
+		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
+			v4l2_event_queue_fh(sev->fh, &ev);
+}
+
+static void uvc_ctrl_send_events(struct uvc_fh *handle,
+	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+{
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	unsigned int i;
+
+	for (i = 0; i < xctrls_count; ++i) {
+		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
+		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
+				    V4L2_EVENT_CTRL_CH_VALUE);
+	}
+}
+
+static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev)
+{
+	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	int ret;
+
+	ret = mutex_lock_interruptible(&handle->chain->ctrl_mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	ctrl = uvc_find_control(handle->chain, sev->id, &mapping);
+	if (ctrl == NULL) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	list_add_tail(&sev->node, &mapping->ev_subs);
+	if (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL) {
+		struct v4l2_event ev;
+		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
+		s32 val = 0;
+
+		if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
+			changes |= V4L2_EVENT_CTRL_CH_VALUE;
+
+		uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, val,
+				    changes);
+		v4l2_event_queue_fh(sev->fh, &ev);
+	}
+
+done:
+	mutex_unlock(&handle->chain->ctrl_mutex);
+	return ret;
+}
+
+static void uvc_ctrl_del_event(struct v4l2_subscribed_event *sev)
+{
+	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
+
+	mutex_lock(&handle->chain->ctrl_mutex);
+	list_del(&sev->node);
+	mutex_unlock(&handle->chain->ctrl_mutex);
+}
+
+const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops = {
+	.add = uvc_ctrl_add_event,
+	.del = uvc_ctrl_del_event,
+	.replace = v4l2_ctrl_replace,
+	.merge = v4l2_ctrl_merge,
+};
 
 /* --------------------------------------------------------------------------
  * Control transactions
@@ -1179,8 +1290,11 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 	return 0;
 }
 
-int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback)
+int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
+		      const struct v4l2_ext_control *xctrls,
+		      unsigned int xctrls_count)
 {
+	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_entity *entity;
 	int ret = 0;
 
@@ -1191,6 +1305,8 @@ int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback)
 			goto done;
 	}
 
+	if (!rollback)
+		uvc_ctrl_send_events(handle, xctrls, xctrls_count);
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
@@ -1662,6 +1778,8 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 	if (map == NULL)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&map->ev_subs);
+
 	size = sizeof(*mapping->menu_info) * mapping->menu_count;
 	map->menu_info = kmemdup(mapping->menu_info, size, GFP_KERNEL);
 	if (map->menu_info == NULL) {
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 8db90ef..edc81aa 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -25,6 +25,8 @@
 #include <linux/atomic.h>
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 
 #include "uvcvideo.h"
@@ -505,6 +507,8 @@ static int uvc_v4l2_open(struct file *file)
 		}
 	}
 
+	v4l2_fh_init(&handle->vfh, stream->vdev);
+	v4l2_fh_add(&handle->vfh);
 	handle->chain = stream->chain;
 	handle->stream = stream;
 	handle->state = UVC_HANDLE_PASSIVE;
@@ -528,6 +532,8 @@ static int uvc_v4l2_release(struct file *file)
 
 	/* Release the file handle. */
 	uvc_dismiss_privileges(handle);
+	v4l2_fh_del(&handle->vfh);
+	v4l2_fh_exit(&handle->vfh);
 	kfree(handle);
 	file->private_data = NULL;
 
@@ -584,7 +590,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return ret;
 
 		ret = uvc_ctrl_get(chain, &xctrl);
-		uvc_ctrl_rollback(chain);
+		uvc_ctrl_rollback(handle);
 		if (ret >= 0)
 			ctrl->value = xctrl.value;
 		break;
@@ -605,10 +611,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 		ret = uvc_ctrl_set(chain, &xctrl);
 		if (ret < 0) {
-			uvc_ctrl_rollback(chain);
+			uvc_ctrl_rollback(handle);
 			return ret;
 		}
-		ret = uvc_ctrl_commit(chain);
+		ret = uvc_ctrl_commit(handle, &xctrl, 1);
 		if (ret == 0)
 			ctrl->value = xctrl.value;
 		break;
@@ -630,13 +636,13 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			ret = uvc_ctrl_get(chain, ctrl);
 			if (ret < 0) {
-				uvc_ctrl_rollback(chain);
+				uvc_ctrl_rollback(handle);
 				ctrls->error_idx = i;
 				return ret;
 			}
 		}
 		ctrls->error_idx = 0;
-		ret = uvc_ctrl_rollback(chain);
+		ret = uvc_ctrl_rollback(handle);
 		break;
 	}
 
@@ -654,7 +660,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			ret = uvc_ctrl_set(chain, ctrl);
 			if (ret < 0) {
-				uvc_ctrl_rollback(chain);
+				uvc_ctrl_rollback(handle);
 				ctrls->error_idx = i;
 				return ret;
 			}
@@ -663,9 +669,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		ctrls->error_idx = 0;
 
 		if (cmd == VIDIOC_S_EXT_CTRLS)
-			ret = uvc_ctrl_commit(chain);
+			ret = uvc_ctrl_commit(handle,
+					      ctrls->controls, ctrls->count);
 		else
-			ret = uvc_ctrl_rollback(chain);
+			ret = uvc_ctrl_rollback(handle);
 		break;
 	}
 
@@ -990,6 +997,26 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return uvc_video_enable(stream, 0);
 	}
 
+	case VIDIOC_SUBSCRIBE_EVENT:
+	{
+		struct v4l2_event_subscription *sub = arg;
+
+		switch (sub->type) {
+		case V4L2_EVENT_CTRL:
+			return v4l2_event_subscribe(&handle->vfh, sub, 0,
+						    &uvc_ctrl_sub_ev_ops);
+		default:
+			return -EINVAL;
+		}
+	}
+
+	case VIDIOC_UNSUBSCRIBE_EVENT:
+		return v4l2_event_unsubscribe(&handle->vfh, arg);
+
+	case VIDIOC_DQEVENT:
+		return v4l2_event_dequeue(&handle->vfh, arg,
+					  file->f_flags & O_NONBLOCK);
+
 	/* Analog video standards make no sense for digital cameras. */
 	case VIDIOC_ENUMSTD:
 	case VIDIOC_QUERYSTD:
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 67f88d8..e43deb7 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -13,6 +13,8 @@
 #include <linux/videodev2.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fh.h>
 #include <media/videobuf2-core.h>
 
 /* --------------------------------------------------------------------------
@@ -153,6 +155,7 @@ struct uvc_control_info {
 
 struct uvc_control_mapping {
 	struct list_head list;
+	struct list_head ev_subs;
 
 	struct uvc_control_info *ctrl;
 
@@ -524,6 +527,7 @@ enum uvc_handle_state {
 };
 
 struct uvc_fh {
+	struct v4l2_fh vfh;
 	struct uvc_video_chain *chain;
 	struct uvc_streaming *stream;
 	enum uvc_handle_state state;
@@ -643,6 +647,8 @@ extern int uvc_status_suspend(struct uvc_device *dev);
 extern int uvc_status_resume(struct uvc_device *dev);
 
 /* Controls */
+extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
+
 extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		struct v4l2_queryctrl *v4l2_ctrl);
 extern int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
@@ -655,14 +661,18 @@ extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 extern int uvc_ctrl_resume_device(struct uvc_device *dev);
 
 extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
-extern int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback);
-static inline int uvc_ctrl_commit(struct uvc_video_chain *chain)
+extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
+			const struct v4l2_ext_control *xctrls,
+			unsigned int xctrls_count);
+static inline int uvc_ctrl_commit(struct uvc_fh *handle,
+			const struct v4l2_ext_control *xctrls,
+			unsigned int xctrls_count)
 {
-	return __uvc_ctrl_commit(chain, 0);
+	return __uvc_ctrl_commit(handle, 0, xctrls, xctrls_count);
 }
-static inline int uvc_ctrl_rollback(struct uvc_video_chain *chain)
+static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 {
-	return __uvc_ctrl_commit(chain, 1);
+	return __uvc_ctrl_commit(handle, 1, NULL, 0);
 }
 
 extern int uvc_ctrl_get(struct uvc_video_chain *chain,
-- 
1.7.9.3

