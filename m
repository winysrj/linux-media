Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:44123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932722AbeEHPHs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 11:07:48 -0400
Received: from axis700.grange ([87.78.226.14]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M9OMc-1fB4Y81C8M-00CeKO for
 <linux-media@vger.kernel.org>; Tue, 08 May 2018 17:07:46 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id C5D9F6180C
        for <linux-media@vger.kernel.org>; Tue,  8 May 2018 17:07:44 +0200 (CEST)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH v8 2/3] uvcvideo: send a control event when a Control Change interrupt arrives
Date: Tue,  8 May 2018 17:07:43 +0200
Message-Id: <1525792064-30836-3-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC defines a method of handling asynchronous controls, which sends a
USB packet over the interrupt pipe. This patch implements support for
such packets by sending a control event to the user. Since this can
involve USB traffic and, therefore, scheduling, this has to be done
in a work queue.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v8:

* avoid losing events by delaying the status URB resubmission until
  after completion of the current event
* extract control value calculation into __uvc_ctrl_get_value()
* do not proactively return EBUSY if the previous control hasn't
  completed yet, let the camera handle such cases
* multiple cosmetic changes

 drivers/media/usb/uvc/uvc_ctrl.c   | 166 ++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
 drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
 include/uapi/linux/uvcvideo.h      |   2 +
 5 files changed, 255 insertions(+), 44 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 2a213c8..796f86a 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 #include <linux/atomic.h>
 #include <media/v4l2-ctrls.h>
 
@@ -971,12 +972,30 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 	return 0;
 }
 
+static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
+				const u8 *data)
+{
+	s32 value = mapping->get(mapping, UVC_GET_CUR, data);
+
+	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		struct uvc_menu_info *menu = mapping->menu_info;
+		unsigned int i;
+
+		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+			if (menu->value == value) {
+				value = i;
+				break;
+			}
+		}
+	}
+
+	return value;
+}
+
 static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
 	s32 *value)
 {
-	struct uvc_menu_info *menu;
-	unsigned int i;
 	int ret;
 
 	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
@@ -993,18 +1012,8 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 		ctrl->loaded = 1;
 	}
 
-	*value = mapping->get(mapping, UVC_GET_CUR,
-		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
-
-	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
-		menu = mapping->menu_info;
-		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
-			if (menu->value == *value) {
-				*value = i;
-				break;
-			}
-		}
-	}
+	*value = __uvc_ctrl_get_value(mapping,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
 	return 0;
 }
@@ -1222,30 +1231,121 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
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
 		if (sev->fh != &handle->vfh ||
 		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
-		    (changes & V4L2_EVENT_CTRL_CH_FLAGS))
+		    (changes & V4L2_EVENT_CTRL_CH_FLAGS) || autoupdate)
 			v4l2_event_queue_fh(sev->fh, &ev);
 	}
 }
 
-static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
-	struct uvc_control *master, u32 slave_id,
-	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
+	struct uvc_video_chain *chain, struct uvc_control *master, u32 slave_id)
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
+	if (__uvc_ctrl_get(handle ? handle->chain : chain, ctrl, mapping,
+			   &val) == 0)
+		changes |= V4L2_EVENT_CTRL_CH_VALUE;
+
+	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
+}
+
+static void uvc_ctrl_status_event_work(struct work_struct *work)
+{
+	struct uvc_device *dev = container_of(work, struct uvc_device,
+					      async_ctrl.work);
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl = w->ctrl;
+	unsigned int i;
+	int ret;
+
+	mutex_lock(&w->chain->ctrl_mutex);
+
+	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
+		s32 value = __uvc_ctrl_get_value(mapping, w->data);
+
+		/*
+		 * So far none of the auto-update controls in the uvc_ctrls[]
+		 * table is mapped to a V4L control with slaves in the
+		 * uvc_ctrl_mappings[] list, so slave controls so far never have
+		 * handle == NULL, but this can change in the future
+		 */
+		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
+			if (!mapping->slave_ids[i])
+				break;
+
+			__uvc_ctrl_send_slave_event(ctrl->handle, w->chain,
+						ctrl, mapping->slave_ids[i]);
+		}
+
+		uvc_ctrl_send_event(ctrl->handle, ctrl, mapping, value,
+				    V4L2_EVENT_CTRL_CH_VALUE);
+	}
+
+	mutex_unlock(&w->chain->ctrl_mutex);
+
+	ctrl->handle = NULL;
+
+	/* Resubmit the URB. */
+	w->urb->interval = dev->int_ep->desc.bInterval;
+	ret = usb_submit_urb(w->urb, GFP_KERNEL);
+	if (ret < 0)
+		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+			   ret);
+}
+
+bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
+			   struct uvc_control *ctrl, const u8 *data)
+{
+	struct uvc_device *dev = chain->dev;
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	if (list_empty(&ctrl->info.mappings)) {
+		ctrl->handle = NULL;
+		return false;
+	}
+
+	w->data = data;
+	w->urb = urb;
+	w->chain = chain;
+	w->ctrl = ctrl;
+
+	schedule_work(&w->work);
+
+	return true;
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
@@ -1255,14 +1355,8 @@ static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
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
+	/* handle != NULL */
+	__uvc_ctrl_send_slave_event(handle, NULL, master, slave_id);
 }
 
 static void uvc_ctrl_send_events(struct uvc_fh *handle,
@@ -1277,6 +1371,10 @@ static void uvc_ctrl_send_events(struct uvc_fh *handle,
 	for (i = 0; i < xctrls_count; ++i) {
 		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
 
+		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+			/* Notification will be sent from an Interrupt event. */
+			continue;
+
 		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
 			if (!mapping->slave_ids[j])
 				break;
@@ -1472,9 +1570,10 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
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
@@ -1581,6 +1680,9 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	mapping->set(mapping, value,
 		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
+	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+		ctrl->handle = handle;
+
 	ctrl->dirty = 1;
 	ctrl->modified = 1;
 	return 0;
@@ -1612,7 +1714,9 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
 			    |  (data[0] & UVC_CONTROL_CAP_SET ?
 				UVC_CTRL_FLAG_SET_CUR : 0)
 			    |  (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-				UVC_CTRL_FLAG_AUTO_UPDATE : 0);
+				UVC_CTRL_FLAG_AUTO_UPDATE : 0)
+			    |  (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
+				UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
 
 	kfree(data);
 	return ret;
@@ -2173,6 +2277,8 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 	struct uvc_entity *entity;
 	unsigned int i;
 
+	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
+
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
@@ -2241,6 +2347,8 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
 	struct uvc_entity *entity;
 	unsigned int i;
 
+	cancel_work_sync(&dev->async_ctrl.work);
+
 	/* Free controls and control mappings for all entities. */
 	list_for_each_entry(entity, &dev->entities, list) {
 		for (i = 0; i < entity->ncontrols; ++i) {
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7b71041..a0f2fea 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -78,7 +78,24 @@ static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 /* --------------------------------------------------------------------------
  * Status interrupt endpoint
  */
-static void uvc_event_streaming(struct uvc_device *dev, u8 *data, int len)
+struct uvc_streaming_status {
+	u8	bStatusType;
+	u8	bOriginator;
+	u8	bEvent;
+	u8	bValue[];
+} __packed;
+
+struct uvc_control_status {
+	u8	bStatusType;
+	u8	bOriginator;
+	u8	bEvent;
+	u8	bSelector;
+	u8	bAttribute;
+	u8	bValue[];
+} __packed;
+
+static void uvc_event_streaming(struct uvc_device *dev,
+				struct uvc_streaming_status *status, int len)
 {
 	if (len < 3) {
 		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
@@ -86,31 +103,98 @@ static void uvc_event_streaming(struct uvc_device *dev, u8 *data, int len)
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
 
-static void uvc_event_control(struct uvc_device *dev, u8 *data, int len)
+#define UVC_CTRL_VALUE_CHANGE	0
+#define UVC_CTRL_INFO_CHANGE	1
+#define UVC_CTRL_FAILURE_CHANGE	2
+#define UVC_CTRL_MIN_CHANGE	3
+#define UVC_CTRL_MAX_CHANGE	4
+
+static struct uvc_control *uvc_event_entity_find_ctrl(struct uvc_entity *entity,
+						      u8 selector)
 {
-	char *attrs[3] = { "value", "info", "failure" };
+	struct uvc_control *ctrl;
+	unsigned int i;
+
+	for (i = 0, ctrl = entity->controls; i < entity->ncontrols; i++, ctrl++)
+		if (ctrl->info.selector == selector)
+			return ctrl;
 
-	if (len < 6 || data[2] != 0 || data[4] > 2) {
+	return NULL;
+}
+
+static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
+					const struct uvc_control_status *status,
+					struct uvc_video_chain **chain)
+{
+	list_for_each_entry((*chain), &dev->chains, list) {
+		struct uvc_entity *entity;
+		struct uvc_control *ctrl;
+
+		list_for_each_entry(entity, &(*chain)->entities, chain) {
+			if (entity->id != status->bOriginator)
+				continue;
+
+			ctrl = uvc_event_entity_find_ctrl(entity,
+							  status->bSelector);
+			if (ctrl && (!ctrl->handle ||
+				     ctrl->handle->chain == *chain))
+				return ctrl;
+		}
+	}
+
+	return NULL;
+}
+
+static bool uvc_event_control(struct urb *urb,
+			      const struct uvc_control_status *status, int len)
+{
+	static const char *attrs[] = { "value", "info", "failure", "min", "max" };
+	struct uvc_device *dev = urb->context;
+	struct uvc_video_chain *chain;
+	struct uvc_control *ctrl;
+
+	if (len < 6 || status->bEvent != 0 ||
+	    status->bAttribute >= ARRAY_SIZE(attrs)) {
 		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
 				"received.\n");
-		return;
+		return false;
 	}
 
 	uvc_trace(UVC_TRACE_STATUS, "Control %u/%u %s change len %d.\n",
-		data[1], data[3], attrs[data[4]], len);
+		  status->bOriginator, status->bSelector,
+		  attrs[status->bAttribute], len);
+
+	/* Find the control. */
+	ctrl = uvc_event_find_ctrl(dev, status, &chain);
+	if (!ctrl)
+		return false;
+
+	switch (status->bAttribute) {
+	case UVC_CTRL_VALUE_CHANGE:
+		return uvc_ctrl_status_event(urb, chain, ctrl, status->bValue);
+
+	case UVC_CTRL_INFO_CHANGE:
+	case UVC_CTRL_FAILURE_CHANGE:
+	case UVC_CTRL_MIN_CHANGE:
+	case UVC_CTRL_MAX_CHANGE:
+		break;
+	}
+
+	return false;
 }
 
 static void uvc_status_complete(struct urb *urb)
@@ -139,11 +223,15 @@ static void uvc_status_complete(struct urb *urb)
 	if (len > 0) {
 		switch (dev->status[0] & 0x0f) {
 		case UVC_STATUS_TYPE_CONTROL:
-			uvc_event_control(dev, dev->status, len);
+			if (uvc_event_control(urb,
+				(struct uvc_control_status *)dev->status, len))
+				/* The URB will be resubmitted in work context */
+				return;
 			break;
 
 		case UVC_STATUS_TYPE_STREAMING:
-			uvc_event_streaming(dev, dev->status, len);
+			uvc_event_streaming(dev,
+				(struct uvc_streaming_status *)dev->status, len);
 			break;
 
 		default:
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index bd32914..18a7384 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -994,7 +994,7 @@ static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
 	if (ret < 0)
 		return ret;
 
-	ret = uvc_ctrl_set(chain, &xctrl);
+	ret = uvc_ctrl_set(handle, &xctrl);
 	if (ret < 0) {
 		uvc_ctrl_rollback(handle);
 		return ret;
@@ -1069,7 +1069,7 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 		return ret;
 
 	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-		ret = uvc_ctrl_set(chain, ctrl);
+		ret = uvc_ctrl_set(handle, ctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
 			ctrls->error_idx = commit ? ctrls->count : i;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index be5cf17..0e5e920 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -12,6 +12,7 @@
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
 #include <linux/videodev2.h>
+#include <linux/workqueue.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
@@ -256,6 +257,8 @@ struct uvc_control {
 	   initialized:1;
 
 	u8 *uvc_data;
+
+	struct uvc_fh *handle;	/* Used for asynchronous event delivery */
 };
 
 struct uvc_format_desc {
@@ -600,6 +603,14 @@ struct uvc_device {
 	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
+
+	struct uvc_ctrl_work {
+		struct work_struct work;
+		struct urb *urb;
+		struct uvc_video_chain *chain;
+		struct uvc_control *ctrl;
+		const void *data;
+	} async_ctrl;
 };
 
 enum uvc_handle_state {
@@ -753,6 +764,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 int uvc_ctrl_init_device(struct uvc_device *dev);
 void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 int uvc_ctrl_restore_values(struct uvc_device *dev);
+bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
+			   struct uvc_control *ctrl, const u8 *data);
 
 int uvc_ctrl_begin(struct uvc_video_chain *chain);
 int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
@@ -770,7 +783,7 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 }
 
 int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
-int uvc_ctrl_set(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
+int uvc_ctrl_set(struct uvc_fh *handle, struct v4l2_ext_control *xctrl);
 
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		      struct uvc_xu_control_query *xqry);
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 020714d..f80f05b 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -28,6 +28,8 @@
 #define UVC_CTRL_FLAG_RESTORE		(1 << 6)
 /* Control can be updated by the camera. */
 #define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
+/* Control supports asynchronous reporting */
+#define UVC_CTRL_FLAG_ASYNCHRONOUS	(1 << 8)
 
 #define UVC_CTRL_FLAG_GET_RANGE \
 	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \
-- 
1.9.3
