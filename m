Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3251 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab1F1L0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/13] v4l2-ctrls/event: remove struct v4l2_ctrl_fh, instead use v4l2_subscribed_event
Date: Tue, 28 Jun 2011 13:25:54 +0200
Message-Id: <45c38fb3f55b993136692e1d900dacd6cd2d85ad.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_ctrl_fh struct connected v4l2_ctrl with v4l2_fh so the control
would know which filehandles subscribed to it. However, it is much easier
to use struct v4l2_subscribed_event directly for that and get rid of that
intermediate struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   50 ++++++++++++++-----------------------
 drivers/media/video/v4l2-event.c |   34 +++++++++----------------
 include/media/v4l2-ctrls.h       |   17 +++++-------
 include/media/v4l2-event.h       |    9 +++++++
 4 files changed, 47 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index f581910..079f952 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -581,15 +581,15 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 {
 	struct v4l2_event ev;
-	struct v4l2_ctrl_fh *pos;
+	struct v4l2_subscribed_event *sev;
 
-	if (list_empty(&ctrl->fhs))
+	if (list_empty(&ctrl->ev_subs))
 			return;
 	fill_event(&ev, ctrl, changes);
 
-	list_for_each_entry(pos, &ctrl->fhs, node)
-		if (pos->fh != fh)
-			v4l2_event_queue_fh(pos->fh, &ev);
+	list_for_each_entry(sev, &ctrl->ev_subs, node)
+		if (sev->fh && sev->fh != fh)
+			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
 /* Helper function: copy the current control value back to the caller */
@@ -867,7 +867,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 {
 	struct v4l2_ctrl_ref *ref, *next_ref;
 	struct v4l2_ctrl *ctrl, *next_ctrl;
-	struct v4l2_ctrl_fh *ctrl_fh, *next_ctrl_fh;
+	struct v4l2_subscribed_event *sev, *next_sev;
 
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
@@ -881,10 +881,8 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	/* Free all controls owned by the handler */
 	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
 		list_del(&ctrl->node);
-		list_for_each_entry_safe(ctrl_fh, next_ctrl_fh, &ctrl->fhs, node) {
-			list_del(&ctrl_fh->node);
-			kfree(ctrl_fh);
-		}
+		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
+			list_del(&sev->node);
 		kfree(ctrl);
 	}
 	kfree(hdl->buckets);
@@ -1084,7 +1082,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 
 	INIT_LIST_HEAD(&ctrl->node);
-	INIT_LIST_HEAD(&ctrl->fhs);
+	INIT_LIST_HEAD(&ctrl->ev_subs);
 	ctrl->handler = hdl;
 	ctrl->ops = ops;
 	ctrl->id = id;
@@ -2027,41 +2025,31 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
-void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
-		struct v4l2_ctrl_fh *ctrl_fh,
-		struct v4l2_event_subscription *sub)
+void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
+				struct v4l2_subscribed_event *sev)
 {
-	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, sub->id);
-
 	v4l2_ctrl_lock(ctrl);
-	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
+	list_add_tail(&sev->node, &ctrl->ev_subs);
 	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
-	    (sub->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
+	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
 		struct v4l2_event ev;
 
 		fill_event(&ev, ctrl, V4L2_EVENT_CTRL_CH_VALUE |
 			V4L2_EVENT_CTRL_CH_FLAGS);
-		v4l2_event_queue_fh(ctrl_fh->fh, &ev);
+		v4l2_event_queue_fh(sev->fh, &ev);
 	}
 	v4l2_ctrl_unlock(ctrl);
 }
-EXPORT_SYMBOL(v4l2_ctrl_add_fh);
+EXPORT_SYMBOL(v4l2_ctrl_add_event);
 
-void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
+void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
+				struct v4l2_subscribed_event *sev)
 {
-	struct v4l2_ctrl_fh *pos;
-
 	v4l2_ctrl_lock(ctrl);
-	list_for_each_entry(pos, &ctrl->fhs, node) {
-		if (pos->fh == fh) {
-			list_del(&pos->node);
-			kfree(pos);
-			break;
-		}
-	}
+	list_del(&sev->node);
 	v4l2_ctrl_unlock(ctrl);
 }
-EXPORT_SYMBOL(v4l2_ctrl_del_fh);
+EXPORT_SYMBOL(v4l2_ctrl_del_event);
 
 int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
 			struct v4l2_event_subscription *sub, unsigned n)
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 70fa82d..dc68f60 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -213,7 +213,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 {
 	struct v4l2_subscribed_event *sev, *found_ev;
 	struct v4l2_ctrl *ctrl = NULL;
-	struct v4l2_ctrl_fh *ctrl_fh = NULL;
 	unsigned long flags;
 
 	if (sub->type == V4L2_EVENT_CTRL) {
@@ -222,17 +221,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 			return -EINVAL;
 	}
 
-	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
+	sev = kzalloc(sizeof(*sev), GFP_KERNEL);
 	if (!sev)
 		return -ENOMEM;
-	if (ctrl) {
-		ctrl_fh = kzalloc(sizeof(*ctrl_fh), GFP_KERNEL);
-		if (!ctrl_fh) {
-			kfree(sev);
-			return -ENOMEM;
-		}
-		ctrl_fh->fh = fh;
-	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
@@ -241,22 +232,19 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		INIT_LIST_HEAD(&sev->list);
 		sev->type = sub->type;
 		sev->id = sub->id;
+		sev->fh = fh;
+		sev->flags = sub->flags;
 
 		list_add(&sev->list, &fh->subscribed);
-		sev = NULL;
 	}
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
 	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
-	if (ctrl) {
-		if (found_ev)
-			kfree(ctrl_fh);
-		else
-			v4l2_ctrl_add_fh(fh->ctrl_handler, ctrl_fh, sub);
-	}
-
-	kfree(sev);
+	if (found_ev)
+		kfree(sev);
+	else if (ctrl)
+		v4l2_ctrl_add_event(ctrl, sev);
 
 	return 0;
 }
@@ -298,15 +286,17 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
-	if (sev != NULL)
+	if (sev != NULL) {
 		list_del(&sev->list);
+		sev->fh = NULL;
+	}
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-	if (sev->type == V4L2_EVENT_CTRL) {
+	if (sev && sev->type == V4L2_EVENT_CTRL) {
 		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
 
 		if (ctrl)
-			v4l2_ctrl_del_fh(ctrl, fh);
+			v4l2_ctrl_del_event(ctrl, sev);
 	}
 
 	kfree(sev);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index de68a59..635adc2 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -31,6 +31,7 @@ struct v4l2_ctrl;
 struct video_device;
 struct v4l2_subdev;
 struct v4l2_event_subscription;
+struct v4l2_subscribed_event;
 struct v4l2_fh;
 
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
@@ -53,6 +54,7 @@ struct v4l2_ctrl_ops {
 
 /** struct v4l2_ctrl - The control structure.
   * @node:	The list node.
+  * @ev_subs:	The list of control event subscriptions.
   * @handler:	The handler that owns the control.
   * @cluster:	Point to start of cluster array.
   * @ncontrols:	Number of controls in cluster array.
@@ -108,7 +110,7 @@ struct v4l2_ctrl_ops {
 struct v4l2_ctrl {
 	/* Administrative fields */
 	struct list_head node;
-	struct list_head fhs;
+	struct list_head ev_subs;
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
 	unsigned ncontrols;
@@ -184,11 +186,6 @@ struct v4l2_ctrl_handler {
 	int error;
 };
 
-struct v4l2_ctrl_fh {
-	struct list_head node;
-	struct v4l2_fh *fh;
-};
-
 /** struct v4l2_ctrl_config - Control configuration structure.
   * @ops:	The control ops.
   * @id:	The control ID.
@@ -497,10 +494,10 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
 /* Internal helper functions that deal with control events. */
-void v4l2_ctrl_add_fh(struct v4l2_ctrl_handler *hdl,
-		struct v4l2_ctrl_fh *ctrl_fh,
-		struct v4l2_event_subscription *sub);
-void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
+void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
+		struct v4l2_subscribed_event *sev);
+void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
+		struct v4l2_subscribed_event *sev);
 
 /** v4l2_ctrl_subscribe_fh() - Helper function that subscribes a control event.
   * @fh:	The file handler that subscribed the control event.
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 042b893..eda17f8 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -38,9 +38,18 @@ struct v4l2_kevent {
 };
 
 struct v4l2_subscribed_event {
+	/* list node for the v4l2_fh->subscribed list */
 	struct list_head	list;
+	/* event type */
 	u32			type;
+	/* associated object ID (e.g. control ID) */
 	u32			id;
+	/* copy of v4l2_event_subscription->flags */
+	u32			flags;
+	/* filehandle that subscribed to this event */
+	struct v4l2_fh		*fh;
+	/* list node that hooks into the object's event list (if there is one) */
+	struct list_head	node;
 };
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-- 
1.7.1

