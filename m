Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53813 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753578AbdLMPe5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 10:34:57 -0500
Received: from axis700.grange ([84.44.207.202]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M7HGA-1fDHfF2hsc-00x4SI for
 <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 16:34:55 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 44DA861A82
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 16:34:54 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2 v6] uvcvideo: send a control event when a Control Change interrupt arrives
Date: Wed, 13 Dec 2017 16:34:52 +0100
Message-Id: <1513179293-17324-2-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1513179293-17324-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1513179293-17324-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC defines a method of handling asynchronous controls, which sends a
USB packet over the interrupt pipe. This patch implements support for
such packets by sending a control event to the user. Since this can
involve USB traffic and, therefore, scheduling, this has to be done
in a work queue.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++++++++++----
 drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
 drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
 include/uapi/linux/uvcvideo.h      |   2 +
 5 files changed, 269 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 20397ab..2a592c2 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 #include <linux/atomic.h>
 #include <media/v4l2-ctrls.h>
 
@@ -1222,30 +1223,134 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_event ev;
+	bool autoupdate;
 
 	if (list_empty(&mapping->ev_subs))
 		return;
 
+	if (!handle) {
+		autoupdate = true;
+		sev = list_first_entry(&mapping->ev_subs,
+				       struct v4l2_subscribed_event, node);
+		handle = container_of(sev->fh, struct uvc_fh, vfh);
+	} else {
+		autoupdate = false;
+	}
+
 	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
 
 	list_for_each_entry(sev, &mapping->ev_subs, node) {
 		if (sev->fh && (sev->fh != &handle->vfh ||
 		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
-		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
+		    (changes & V4L2_EVENT_CTRL_CH_FLAGS) || autoupdate))
 			v4l2_event_queue_fh(sev->fh, &ev);
 	}
 }
 
-static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
-	struct uvc_control *master, u32 slave_id,
-	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
+				struct uvc_control *master, u32 slave_id)
 {
 	struct uvc_control_mapping *mapping = NULL;
 	struct uvc_control *ctrl = NULL;
 	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
-	unsigned int i;
 	s32 val = 0;
 
+	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
+	if (ctrl == NULL)
+		return;
+
+	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
+		changes |= V4L2_EVENT_CTRL_CH_VALUE;
+
+	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
+}
+
+static void uvc_ctrl_status_event_work(struct work_struct *work)
+{
+	struct uvc_device *dev = container_of(work, struct uvc_device,
+					      async_ctrl.work);
+	struct uvc_video_chain *chain;
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	struct uvc_fh *handle;
+	__u8 *data;
+	unsigned int i;
+
+	spin_lock_irq(&w->lock);
+	data = w->data;
+	w->data = NULL;
+	chain = w->chain;
+	ctrl = w->ctrl;
+	handle = ctrl->handle;
+	ctrl->handle = NULL;
+	spin_unlock_irq(&w->lock);
+
+	if (mutex_lock_interruptible(&chain->ctrl_mutex))
+		goto free;
+
+	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
+		s32 value = mapping->get(mapping, UVC_GET_CUR, data);
+
+		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
+			if (!mapping->slave_ids[i])
+				break;
+
+			__uvc_ctrl_send_slave_event(handle, ctrl,
+						    mapping->slave_ids[i]);
+		}
+
+		if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+			struct uvc_menu_info *menu = mapping->menu_info;
+			unsigned int i;
+
+			for (i = 0; i < mapping->menu_count; ++i, ++menu)
+				if (menu->value == value) {
+					value = i;
+					break;
+				}
+		}
+
+		uvc_ctrl_send_event(handle, ctrl, mapping, value,
+				    V4L2_EVENT_CTRL_CH_VALUE);
+	}
+
+	mutex_unlock(&chain->ctrl_mutex);
+
+free:
+	kfree(data);
+}
+
+void uvc_ctrl_status_event(struct uvc_video_chain *chain,
+			   struct uvc_control *ctrl, __u8 *data, size_t len)
+{
+	struct uvc_device *dev = chain->dev;
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	if (list_empty(&ctrl->info.mappings))
+		return;
+
+	spin_lock(&w->lock);
+	if (w->data)
+		/* A previous event work hasn't run yet, we lose 1 event */
+		kfree(w->data);
+
+	w->data = kmalloc(len, GFP_ATOMIC);
+	if (w->data) {
+		memcpy(w->data, data, len);
+		w->chain = chain;
+		w->ctrl = ctrl;
+		schedule_work(&w->work);
+	}
+	spin_unlock(&w->lock);
+}
+
+static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
+	struct uvc_control *master, u32 slave_id,
+	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+{
+	unsigned int i;
+
 	/*
 	 * We can skip sending an event for the slave if the slave
 	 * is being modified in the same transaction.
@@ -1255,14 +1360,7 @@ static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
 			return;
 	}
 
-	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
-	if (ctrl == NULL)
-		return;
-
-	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
-		changes |= V4L2_EVENT_CTRL_CH_VALUE;
-
-	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
+	__uvc_ctrl_send_slave_event(handle, master, slave_id);
 }
 
 static void uvc_ctrl_send_events(struct uvc_fh *handle,
@@ -1277,6 +1375,10 @@ static void uvc_ctrl_send_events(struct uvc_fh *handle,
 	for (i = 0; i < xctrls_count; ++i) {
 		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
 
+		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+			/* Notification will be sent from an Interrupt event */
+			continue;
+
 		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
 			if (!mapping->slave_ids[j])
 				break;
@@ -1472,9 +1574,10 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
 }
 
-int uvc_ctrl_set(struct uvc_video_chain *chain,
+int uvc_ctrl_set(struct uvc_fh *handle,
 	struct v4l2_ext_control *xctrl)
 {
+	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
 	s32 value;
@@ -1488,6 +1591,25 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 		return -EINVAL;
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
 		return -EACCES;
+	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
+		if (ctrl->handle)
+			/*
+			 * We have already sent this control to the camera
+			 * recently and are currently waiting for a completion
+			 * notification. The camera might already have completed
+			 * its processing and is ready to accept a new control
+			 * or it's still busy processing. If we send a new
+			 * instance of this control now, in the former case the
+			 * camera will process this one too and we'll get
+			 * completions for both, but we will only deliver an
+			 * event for one of them back to the user. In the latter
+			 * case the camera will reply with a STALL. It's easier
+			 * and more reliable to return an error now and let the
+			 * user retry.
+			 */
+			return -EBUSY;
+		ctrl->handle = handle;
+	}
 
 	/* Clamp out of range values. */
 	switch (mapping->v4l2_type) {
@@ -1676,7 +1798,9 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 		    | (data[0] & UVC_CONTROL_CAP_SET ?
 		       UVC_CTRL_FLAG_SET_CUR : 0)
 		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
+		       UVC_CTRL_FLAG_AUTO_UPDATE : 0)
+		    | (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
+		       UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
 
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
@@ -2131,6 +2255,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 	if (!ctrl->initialized)
 		return;
 
+	/* Temporarily abuse DATA_CURRENT buffer to avoid 1 byte allocation */
+	if (!uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
+			    dev->intfnum, info->selector,
+			    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), 1) &&
+	    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT)[0] & 0x10)
+		ctrl->info.flags |= UVC_CTRL_FLAG_ASYNCHRONOUS;
+
 	for (; mapping < mend; ++mapping) {
 		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
 		    ctrl->info.selector == mapping->selector)
@@ -2146,6 +2277,9 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 	struct uvc_entity *entity;
 	unsigned int i;
 
+	spin_lock_init(&dev->async_ctrl.lock);
+	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
+
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
@@ -2214,6 +2348,8 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
 	struct uvc_entity *entity;
 	unsigned int i;
 
+	cancel_work_sync(&dev->async_ctrl.work);
+
 	/* Free controls and control mappings for all entities. */
 	list_for_each_entry(entity, &dev->entities, list) {
 		for (i = 0; i < entity->ncontrols; ++i) {
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 1ef20e7..440a7be 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -78,7 +78,24 @@ static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 /* --------------------------------------------------------------------------
  * Status interrupt endpoint
  */
-static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
+struct uvc_streaming_status {
+	__u8	bStatusType;
+	__u8	bOriginator;
+	__u8	bEvent;
+	__u8	bValue[];
+} __packed;
+
+struct uvc_control_status {
+	__u8	bStatusType;
+	__u8	bOriginator;
+	__u8	bEvent;
+	__u8	bSelector;
+	__u8	bAttribute;
+	__u8	bValue[];
+} __packed;
+
+static void uvc_event_streaming(struct uvc_device *dev,
+				struct uvc_streaming_status *status, int len)
 {
 	if (len < 3) {
 		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
@@ -86,31 +103,101 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 		return;
 	}
 
-	if (data[2] == 0) {
+	if (status->bEvent == 0) {
 		if (len < 4)
 			return;
 		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
-			data[1], data[3] ? "pressed" : "released", len);
-		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
+			  status->bOriginator,
+			  status->bValue[0] ? "pressed" : "released", len);
+		uvc_input_report_key(dev, KEY_CAMERA, status->bValue[0]);
 	} else {
 		uvc_trace(UVC_TRACE_STATUS,
 			  "Stream %u error event %02x len %d.\n",
-			  data[1], data[2], len);
+			  status->bOriginator, status->bEvent, len);
 	}
 }
 
-static void uvc_event_control(struct uvc_device *dev, __u8 *data, int len)
+#define UVC_CTRL_VALUE_CHANGE	0
+#define UVC_CTRL_INFO_CHANGE	1
+#define UVC_CTRL_FAILURE_CHANGE	2
+#define UVC_CTRL_MIN_CHANGE	3
+#define UVC_CTRL_MAX_CHANGE	4
+
+static struct uvc_control *uvc_event_entity_ctrl(struct uvc_entity *entity,
+					       __u8 selector)
+{
+	struct uvc_control *ctrl;
+	unsigned int i;
+
+	for (i = 0, ctrl = entity->controls; i < entity->ncontrols; i++, ctrl++)
+		if (ctrl->info.selector == selector)
+			return ctrl;
+
+	return NULL;
+}
+
+static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
+					struct uvc_control_status *status,
+					struct uvc_video_chain **chain)
+{
+	list_for_each_entry((*chain), &dev->chains, list) {
+		struct uvc_entity *entity;
+		struct uvc_control *ctrl;
+
+		list_for_each_entry(entity, &(*chain)->entities, chain) {
+			if (entity->id == status->bOriginator) {
+				ctrl = uvc_event_entity_ctrl(entity,
+							     status->bSelector);
+				/*
+				 * Some buggy cameras send asynchronous Control
+				 * Change events for control, other than the
+				 * ones, that had been changed, even though the
+				 * AutoUpdate flag isn't set for the control.
+				 */
+				if (ctrl && (!ctrl->handle ||
+					     ctrl->handle->chain == *chain))
+					return ctrl;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void uvc_event_control(struct uvc_device *dev,
+			      struct uvc_control_status *status, int len)
 {
-	char *attrs[3] = { "value", "info", "failure" };
+	struct uvc_video_chain *chain;
+	struct uvc_control *ctrl;
+	char *attrs[] = { "value", "info", "failure", "min", "max" };
 
-	if (len < 6 || data[2] != 0 || data[4] > 2) {
+	if (len < 6 || status->bEvent != 0 ||
+	    status->bAttribute >= ARRAY_SIZE(attrs)) {
 		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
 				"received.\n");
 		return;
 	}
 
 	uvc_trace(UVC_TRACE_STATUS, "Control %u/%u %s change len %d.\n",
-		data[1], data[3], attrs[data[4]], len);
+		  status->bOriginator, status->bSelector,
+		  attrs[status->bAttribute], len);
+
+	/* Find the control. */
+	ctrl = uvc_event_find_ctrl(dev, status, &chain);
+	if (!ctrl)
+		return;
+
+	switch (status->bAttribute) {
+	case UVC_CTRL_VALUE_CHANGE:
+		uvc_ctrl_status_event(chain, ctrl, status->bValue, len -
+				      offsetof(struct uvc_control_status, bValue));
+		break;
+	case UVC_CTRL_INFO_CHANGE:
+	case UVC_CTRL_FAILURE_CHANGE:
+	case UVC_CTRL_MIN_CHANGE:
+	case UVC_CTRL_MAX_CHANGE:
+		break;
+	}
 }
 
 static void uvc_status_complete(struct urb *urb)
@@ -139,11 +226,13 @@ static void uvc_status_complete(struct urb *urb)
 	if (len > 0) {
 		switch (dev->status[0] & 0x0f) {
 		case UVC_STATUS_TYPE_CONTROL:
-			uvc_event_control(dev, dev->status, len);
+			uvc_event_control(dev,
+				(struct uvc_control_status *)dev->status, len);
 			break;
 
 		case UVC_STATUS_TYPE_STREAMING:
-			uvc_event_streaming(dev, dev->status, len);
+			uvc_event_streaming(dev,
+				(struct uvc_streaming_status *)dev->status, len);
 			break;
 
 		default:
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 5e03239..40863eb 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -966,7 +966,7 @@ static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
 	if (ret < 0)
 		return ret;
 
-	ret = uvc_ctrl_set(chain, &xctrl);
+	ret = uvc_ctrl_set(handle, &xctrl);
 	if (ret < 0) {
 		uvc_ctrl_rollback(handle);
 		return ret;
@@ -1041,7 +1041,7 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 		return ret;
 
 	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-		ret = uvc_ctrl_set(chain, ctrl);
+		ret = uvc_ctrl_set(handle, ctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
 			ctrls->error_idx = commit ? ctrls->count : i;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b65e86b..3fa089f 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -11,6 +11,7 @@
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
 #include <linux/videodev2.h>
+#include <linux/workqueue.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
@@ -255,6 +256,8 @@ struct uvc_control {
 	     initialized:1;
 
 	__u8 *uvc_data;
+
+	struct uvc_fh *handle;	/* Used for asynchronous event delivery */
 };
 
 struct uvc_format_desc {
@@ -599,6 +602,14 @@ struct uvc_device {
 	__u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
+
+	struct uvc_ctrl_work {
+		struct work_struct work;
+		struct uvc_video_chain *chain;
+		struct uvc_control *ctrl;
+		spinlock_t lock;
+		void *data;
+	} async_ctrl;
 };
 
 enum uvc_handle_state {
@@ -754,6 +765,8 @@ extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 extern int uvc_ctrl_init_device(struct uvc_device *dev);
 extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 extern int uvc_ctrl_restore_values(struct uvc_device *dev);
+extern void uvc_ctrl_status_event(struct uvc_video_chain *chain,
+		struct uvc_control *ctrl, __u8 *data, size_t len);
 
 extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
 extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
@@ -772,7 +785,7 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 
 extern int uvc_ctrl_get(struct uvc_video_chain *chain,
 		struct v4l2_ext_control *xctrl);
-extern int uvc_ctrl_set(struct uvc_video_chain *chain,
+extern int uvc_ctrl_set(struct uvc_fh *handle,
 		struct v4l2_ext_control *xctrl);
 
 extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 8381ca7c..ee0a5ec 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -27,6 +27,8 @@
 #define UVC_CTRL_FLAG_RESTORE		(1 << 6)
 /* Control can be updated by the camera. */
 #define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
+/* Control supports asynchronous reporting */
+#define UVC_CTRL_FLAG_ASYNCHRONOUS	(1 << 8)
 
 #define UVC_CTRL_FLAG_GET_RANGE \
 	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \
-- 
1.9.3
