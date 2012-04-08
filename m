Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2DHP5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:48 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 03/10] v4l2-ctrls: Use v4l2_subscribed_event_ops
Date: Sun,  8 Apr 2012 17:59:47 +0200
Message-Id: <1333900794-1932-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 +-
 drivers/media/video/v4l2-ctrls.c      |   58 ++++++++++++++++++++++++++-------
 drivers/media/video/v4l2-event.c      |   39 ----------------------
 include/media/v4l2-ctrls.h            |    7 ++--
 4 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 5b41e5b..0c9cf0d 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1468,8 +1468,9 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscripti
 	switch (sub->type) {
 	case V4L2_EVENT_VSYNC:
 	case V4L2_EVENT_EOS:
-	case V4L2_EVENT_CTRL:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	case V4L2_EVENT_CTRL:
+		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 7023e6d..2a44355 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2381,10 +2381,22 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
-void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
-				struct v4l2_subscribed_event *sev)
+static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
 {
-	v4l2_ctrl_lock(ctrl);
+	struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
+	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl *ctrl;
+	int ret = 0;
+
+	mutex_lock(&hdl->lock);
+
+	ref = find_ref(hdl, sev->id);
+	if (!ref) {
+		ret = -EINVAL;
+		goto leave;
+	}
+	ctrl = ref->ctrl;
+
 	list_add_tail(&sev->node, &ctrl->ev_subs);
 	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
 	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
@@ -2396,18 +2408,42 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 		fill_event(&ev, ctrl, changes);
 		v4l2_event_queue_fh(sev->fh, &ev);
 	}
-	v4l2_ctrl_unlock(ctrl);
+leave:
+	mutex_unlock(&hdl->lock);
+	return ret;
 }
-EXPORT_SYMBOL(v4l2_ctrl_add_event);
 
-void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
-				struct v4l2_subscribed_event *sev)
+static void v4l2_ctrl_del_event(struct v4l2_subscribed_event *sev)
 {
-	v4l2_ctrl_lock(ctrl);
+	struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
+
+	mutex_lock(&hdl->lock);
 	list_del(&sev->node);
-	v4l2_ctrl_unlock(ctrl);
+	mutex_unlock(&hdl->lock);
 }
-EXPORT_SYMBOL(v4l2_ctrl_del_event);
+
+void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new)
+{
+	u32 old_changes = old->u.ctrl.changes;
+
+	old->u.ctrl = new->u.ctrl;
+	old->u.ctrl.changes |= old_changes;
+}
+EXPORT_SYMBOL(v4l2_ctrl_replace);
+
+void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new)
+{
+	new->u.ctrl.changes |= old->u.ctrl.changes;
+}
+EXPORT_SYMBOL(v4l2_ctrl_merge);
+
+const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops = {
+	.add = v4l2_ctrl_add_event,
+	.del = v4l2_ctrl_del_event,
+	.replace = v4l2_ctrl_replace,
+	.merge = v4l2_ctrl_merge,
+};
+EXPORT_SYMBOL(v4l2_ctrl_sub_ev_ops);
 
 int v4l2_ctrl_log_status(struct file *file, void *fh)
 {
@@ -2425,7 +2461,7 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 				struct v4l2_event_subscription *sub)
 {
 	if (sub->type == V4L2_EVENT_CTRL)
-		return v4l2_event_subscribe(fh, sub, 0, NULL);
+		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 0ba2dfa..60b4e2e 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -25,7 +25,6 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-ctrls.h>
 
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -203,30 +202,11 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
-static void ctrls_replace(struct v4l2_event *old, const struct v4l2_event *new)
-{
-	u32 old_changes = old->u.ctrl.changes;
-
-	old->u.ctrl = new->u.ctrl;
-	old->u.ctrl.changes |= old_changes;
-}
-
-static void ctrls_merge(const struct v4l2_event *old, struct v4l2_event *new)
-{
-	new->u.ctrl.changes |= old->u.ctrl.changes;
-}
-
-static const struct v4l2_subscribed_event_ops ctrl_ops = {
-	.replace = ctrls_replace,
-	.merge = ctrls_merge,
-};
-
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub, unsigned elems,
 			 const struct v4l2_subscribed_event_ops *ops)
 {
 	struct v4l2_subscribed_event *sev, *found_ev;
-	struct v4l2_ctrl *ctrl = NULL;
 	unsigned long flags;
 	unsigned i;
 
@@ -235,11 +215,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 
 	if (elems < 1)
 		elems = 1;
-	if (sub->type == V4L2_EVENT_CTRL) {
-		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
-		if (ctrl == NULL)
-			return -EINVAL;
-	}
 
 	sev = kzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems, GFP_KERNEL);
 	if (!sev)
@@ -251,9 +226,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->ops = ops;
-	if (ctrl) {
-		sev->ops = &ctrl_ops;
-	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
@@ -275,10 +247,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		}
 	}
 
-	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
-	if (ctrl)
-		v4l2_ctrl_add_event(ctrl, sev);
-
 	/* Mark as ready for use */
 	sev->elems = elems;
 
@@ -338,13 +306,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	if (sev && sev->ops && sev->ops->del)
 		sev->ops->del(sev);
 
-	if (sev && sev->type == V4L2_EVENT_CTRL) {
-		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
-
-		if (ctrl)
-			v4l2_ctrl_del_event(ctrl, sev);
-	}
-
 	kfree(sev);
 
 	return 0;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 11e6756..fe82376 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -487,10 +487,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
 /* Internal helper functions that deal with control events. */
-void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
-		struct v4l2_subscribed_event *sev);
-void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
-		struct v4l2_subscribed_event *sev);
+extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
+void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
+void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new);
 
 /* Can be used as a vidioc_log_status function that just dumps all controls
    associated with the filehandle. */
-- 
1.7.9.3

