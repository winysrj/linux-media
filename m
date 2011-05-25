Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2743 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab1EYNeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Date: Wed, 25 May 2011 15:33:51 +0200
Message-Id: <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Whenever a control changes value or state an event is sent to anyone
that subscribed to it.

This functionality is useful for control panels but also for applications
that need to wait for (usually status) controls to change value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |  101 ++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-event.c |  126 +++++++++++++++++++++++++++-----------
 drivers/media/video/v4l2-fh.c    |    4 +-
 include/linux/videodev2.h        |   29 ++++++++-
 include/media/v4l2-ctrls.h       |   16 +++++-
 include/media/v4l2-event.h       |    2 +
 6 files changed, 237 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 3e0d8ab..e2a7ac7 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
 
 #define call_op(master, op) \
@@ -540,6 +541,44 @@ static bool type_is_int(const struct v4l2_ctrl *ctrl)
 	}
 }
 
+static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
+{
+	memset(ev->reserved, 0, sizeof(ev->reserved));
+	ev->type = V4L2_EVENT_CTRL;
+	ev->id = ctrl->id;
+	ev->u.ctrl.changes = changes;
+	ev->u.ctrl.type = ctrl->type;
+	ev->u.ctrl.flags = ctrl->flags;
+	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+		ev->u.ctrl.value64 = 0;
+	else
+		ev->u.ctrl.value64 = ctrl->cur.val64;
+	ev->u.ctrl.minimum = ctrl->minimum;
+	ev->u.ctrl.maximum = ctrl->maximum;
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU)
+		ev->u.ctrl.step = 1;
+	else
+		ev->u.ctrl.step = ctrl->step;
+	ev->u.ctrl.default_value = ctrl->default_value;
+}
+
+static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
+{
+	struct v4l2_event ev;
+	struct v4l2_ctrl_fh *pos;
+
+	if (list_empty(&ctrl->fhs))
+			return;
+	fill_event(&ev, ctrl, changes);
+
+	list_for_each_entry(pos, &ctrl->fhs, node) {
+		if (pos->fh == fh)
+			continue;
+		ev.u.ctrl.flags = ctrl->flags;
+		v4l2_event_queue_fh(pos->fh, &ev);
+	}
+}
+
 /* Helper function: copy the current control value back to the caller */
 static int cur_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
@@ -629,20 +668,30 @@ static int new_to_user(struct v4l2_ext_control *c,
 /* Copy the new value to the current value. */
 static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl)
 {
+	bool changed = false;
+
 	if (ctrl == NULL)
 		return;
 	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BUTTON:
+		changed = true;
+		break;
 	case V4L2_CTRL_TYPE_STRING:
 		/* strings are always 0-terminated */
+		changed = strcmp(ctrl->string, ctrl->cur.string);
 		strcpy(ctrl->cur.string, ctrl->string);
 		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
+		changed = ctrl->val64 != ctrl->cur.val64;
 		ctrl->cur.val64 = ctrl->val64;
 		break;
 	default:
+		changed = ctrl->val != ctrl->cur.val;
 		ctrl->cur.val = ctrl->val;
 		break;
 	}
+	if (changed)
+		send_event(fh, ctrl, V4L2_EVENT_CTRL_CH_VALUE);
 }
 
 /* Copy the current value to the new value */
@@ -787,6 +836,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 {
 	struct v4l2_ctrl_ref *ref, *next_ref;
 	struct v4l2_ctrl *ctrl, *next_ctrl;
+	struct v4l2_ctrl_fh *ctrl_fh, *next_ctrl_fh;
 
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
@@ -800,6 +850,10 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	/* Free all controls owned by the handler */
 	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
 		list_del(&ctrl->node);
+		list_for_each_entry_safe(ctrl_fh, next_ctrl_fh, &ctrl->fhs, node) {
+			list_del(&ctrl_fh->node);
+			kfree(ctrl_fh);
+		}
 		kfree(ctrl);
 	}
 	kfree(hdl->buckets);
@@ -1006,6 +1060,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 
 	INIT_LIST_HEAD(&ctrl->node);
+	INIT_LIST_HEAD(&ctrl->fhs);
 	ctrl->handler = hdl;
 	ctrl->ops = ops;
 	ctrl->id = id;
@@ -1147,6 +1202,9 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		/* Skip handler-private controls. */
 		if (ctrl->is_private)
 			continue;
+		/* And control classes */
+		if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+			continue;
 		ret = handler_new_ref(hdl, ctrl);
 		if (ret)
 			break;
@@ -1175,9 +1233,14 @@ EXPORT_SYMBOL(v4l2_ctrl_cluster);
 
 void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags)
 {
+	u32 old_flags;
+
 	if (ctrl == NULL)
 		return;
+	old_flags = ctrl->flags;
 	ctrl->flags = (ctrl->flags & ~clear_flags) | set_flags;
+	if (old_flags != ctrl->flags)
+		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_FLAGS);
 }
 EXPORT_SYMBOL(v4l2_ctrl_flags);
 
@@ -1898,3 +1961,41 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	return set_ctrl(NULL, ctrl, &val, false);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
+
+void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
+		struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub)
+{
+	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, sub->id);
+
+	if (ctrl->handler != hdl)
+		v4l2_ctrl_lock(ctrl);
+	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
+	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
+	    (sub->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
+		struct v4l2_event ev;
+
+		fill_event(&ev, ctrl, V4L2_EVENT_CTRL_CH_VALUE |
+			V4L2_EVENT_CTRL_CH_FLAGS);
+		v4l2_event_queue_fh(ctrl_fh->fh, &ev);
+	}
+	if (ctrl->handler != hdl)
+		v4l2_ctrl_unlock(ctrl);
+}
+EXPORT_SYMBOL(v4l2_ctrl_add_fh);
+
+void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
+{
+	struct v4l2_ctrl_fh *pos;
+
+	v4l2_ctrl_lock(ctrl);
+	list_for_each_entry(pos, &ctrl->fhs, node) {
+		if (pos->fh == fh) {
+			list_del(&pos->node);
+			kfree(pos);
+			break;
+		}
+	}
+	v4l2_ctrl_unlock(ctrl);
+}
+EXPORT_SYMBOL(v4l2_ctrl_del_fh);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 69fd343..5a4b8e0 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -25,10 +25,13 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
+
 int v4l2_event_init(struct v4l2_fh *fh)
 {
 	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
@@ -91,7 +94,7 @@ void v4l2_event_free(struct v4l2_fh *fh)
 
 	list_kfree(&events->free, struct v4l2_kevent, list);
 	list_kfree(&events->available, struct v4l2_kevent, list);
-	list_kfree(&events->subscribed, struct v4l2_subscribed_event, list);
+	v4l2_event_unsubscribe_all(fh);
 
 	kfree(events);
 	fh->events = NULL;
@@ -154,9 +157,9 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 }
 EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
 
-/* Caller must hold fh->event->lock! */
+/* Caller must hold fh->vdev->fh_lock! */
 static struct v4l2_subscribed_event *v4l2_event_subscribed(
-	struct v4l2_fh *fh, u32 type)
+		struct v4l2_fh *fh, u32 type, u32 id)
 {
 	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
@@ -164,13 +167,46 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	assert_spin_locked(&fh->vdev->fh_lock);
 
 	list_for_each_entry(sev, &events->subscribed, list) {
-		if (sev->type == type)
+		if (sev->type == type && sev->id == id)
 			return sev;
 	}
 
 	return NULL;
 }
 
+static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
+		const struct timespec *ts)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_subscribed_event *sev;
+	struct v4l2_kevent *kev;
+
+	/* Are we subscribed? */
+	sev = v4l2_event_subscribed(fh, ev->type, ev->id);
+	if (sev == NULL)
+		return;
+
+	/* Increase event sequence number on fh. */
+	events->sequence++;
+
+	/* Do we have any free events? */
+	if (list_empty(&events->free))
+		return;
+
+	/* Take one and fill it. */
+	kev = list_first_entry(&events->free, struct v4l2_kevent, list);
+	kev->event.type = ev->type;
+	kev->event.u = ev->u;
+	kev->event.id = ev->id;
+	kev->event.timestamp = *ts;
+	kev->event.sequence = events->sequence;
+	list_move_tail(&kev->list, &events->available);
+
+	events->navailable++;
+
+	wake_up_all(&events->wait);
+}
+
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
@@ -182,37 +218,26 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list) {
-		struct v4l2_events *events = fh->events;
-		struct v4l2_kevent *kev;
-
-		/* Are we subscribed? */
-		if (!v4l2_event_subscribed(fh, ev->type))
-			continue;
-
-		/* Increase event sequence number on fh. */
-		events->sequence++;
-
-		/* Do we have any free events? */
-		if (list_empty(&events->free))
-			continue;
-
-		/* Take one and fill it. */
-		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
-		kev->event.type = ev->type;
-		kev->event.u = ev->u;
-		kev->event.timestamp = timestamp;
-		kev->event.sequence = events->sequence;
-		list_move_tail(&kev->list, &events->available);
-
-		events->navailable++;
-
-		wake_up_all(&events->wait);
+		__v4l2_event_queue_fh(fh, ev, &timestamp);
 	}
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
+void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
+{
+	unsigned long flags;
+	struct timespec timestamp;
+
+	ktime_get_ts(&timestamp);
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
+
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
 	return fh->events->navailable;
@@ -223,7 +248,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub)
 {
 	struct v4l2_events *events = fh->events;
-	struct v4l2_subscribed_event *sev;
+	struct v4l2_subscribed_event *sev, *found_ev;
+	struct v4l2_ctrl *ctrl = NULL;
+	struct v4l2_ctrl_fh *ctrl_fh = NULL;
 	unsigned long flags;
 
 	if (fh->events == NULL) {
@@ -231,15 +258,31 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		return -ENOMEM;
 	}
 
+	if (sub->type == V4L2_EVENT_CTRL) {
+		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
+		if (ctrl == NULL)
+			return -EINVAL;
+	}
+
 	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
 	if (!sev)
 		return -ENOMEM;
+	if (ctrl) {
+		ctrl_fh = kzalloc(sizeof(*ctrl_fh), GFP_KERNEL);
+		if (!ctrl_fh) {
+			kfree(sev);
+			return -ENOMEM;
+		}
+		ctrl_fh->fh = fh;
+	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
-	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
+	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
+	if (!found_ev) {
 		INIT_LIST_HEAD(&sev->list);
 		sev->type = sub->type;
+		sev->id = sub->id;
 
 		list_add(&sev->list, &events->subscribed);
 		sev = NULL;
@@ -247,6 +290,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
+	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
+	if (!found_ev && ctrl)
+		v4l2_ctrl_add_fh(fh->ctrl_handler, ctrl_fh, sub);
+
 	kfree(sev);
 
 	return 0;
@@ -256,6 +303,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 {
 	struct v4l2_events *events = fh->events;
+	struct v4l2_event_subscription sub;
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
 
@@ -265,11 +313,13 @@ static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 		if (!list_empty(&events->subscribed)) {
 			sev = list_first_entry(&events->subscribed,
-				       struct v4l2_subscribed_event, list);
-			list_del(&sev->list);
+					struct v4l2_subscribed_event, list);
+			sub.type = sev->type;
+			sub.id = sev->id;
 		}
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-		kfree(sev);
+		if (sev)
+			v4l2_event_unsubscribe(fh, &sub);
 	} while (sev);
 }
 
@@ -286,11 +336,17 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
-	sev = v4l2_event_subscribed(fh, sub->type);
+	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
 	if (sev != NULL)
 		list_del(&sev->list);
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	if (sev->type == V4L2_EVENT_CTRL) {
+		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
+
+		if (ctrl)
+			v4l2_ctrl_del_fh(ctrl, fh);
+	}
 
 	kfree(sev);
 
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 8635011..c6aef84 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -93,10 +93,8 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
-
-	fh->vdev = NULL;
-
 	v4l2_event_free(fh);
+	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ac59361..ea4a0fb 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1792,6 +1792,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_ALL				0
 #define V4L2_EVENT_VSYNC			1
 #define V4L2_EVENT_EOS				2
+#define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
@@ -1800,21 +1801,45 @@ struct v4l2_event_vsync {
 	__u8 field;
 } __attribute__ ((packed));
 
+/* Payload for V4L2_EVENT_CTRL */
+#define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
+#define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
+
+struct v4l2_event_ctrl {
+	__u32 changes;
+	__u32 type;
+	union {
+		__s32 value;
+		__s64 value64;
+	};
+	__u32 flags;
+	__s32 minimum;
+	__s32 maximum;
+	__s32 step;
+	__s32 default_value;
+} __attribute__ ((packed));
+
 struct v4l2_event {
 	__u32				type;
 	union {
 		struct v4l2_event_vsync vsync;
+		struct v4l2_event_ctrl	ctrl;
 		__u8			data[64];
 	} u;
 	__u32				pending;
 	__u32				sequence;
 	struct timespec			timestamp;
-	__u32				reserved[9];
+	__u32				id;
+	__u32				reserved[8];
 };
 
+#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)
+
 struct v4l2_event_subscription {
 	__u32				type;
-	__u32				reserved[7];
+	__u32				id;
+	__u32				flags;
+	__u32				reserved[5];
 };
 
 /*
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 151bd2e..2b99f29 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -28,9 +28,10 @@
 /* forward references */
 struct v4l2_ctrl_handler;
 struct v4l2_ctrl;
-struct v4l2_fh;
 struct video_device;
 struct v4l2_subdev;
+struct v4l2_event_subscription;
+struct v4l2_fh;
 
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
   * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
@@ -98,6 +99,7 @@ struct v4l2_ctrl_ops {
 struct v4l2_ctrl {
 	/* Administrative fields */
 	struct list_head node;
+	struct list_head fhs;
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
 	unsigned ncontrols;
@@ -169,6 +171,11 @@ struct v4l2_ctrl_handler {
 	int error;
 };
 
+struct v4l2_ctrl_fh {
+	struct list_head node;
+	struct v4l2_fh *fh;
+};
+
 /** struct v4l2_ctrl_config - Control configuration structure.
   * @ops:	The control ops.
   * @id:	The control ID.
@@ -379,6 +386,7 @@ struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
   * @set_flags:	Set these flags.
   *
   * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL event will be generated afterwards.
   *
   * This function expects that the control handler is locked.
   */
@@ -390,6 +398,7 @@ void v4l2_ctrl_flags(struct v4l2_ctrl *ctrl, u32 clear_flags, u32 set_flags);
   * @set_flags:	Set these flags.
   *
   * This clears and sets flags. Does nothing if @ctrl == NULL.
+  * The V4L2_EVENT_CTRL event will be generated afterwards.
   *
   * This function expects that the control handler is unlocked and will lock
   * it before changing flags.
@@ -437,6 +446,11 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
+void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
+		struct v4l2_ctrl_fh *ctrl_fh,
+		struct v4l2_event_subscription *sub);
+void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
+
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 3b86177..45e9c1e 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -40,6 +40,7 @@ struct v4l2_kevent {
 struct v4l2_subscribed_event {
 	struct list_head	list;
 	u32			type;
+	u32			id;
 };
 
 struct v4l2_events {
@@ -58,6 +59,7 @@ void v4l2_event_free(struct v4l2_fh *fh);
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
+void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub);
-- 
1.7.1

