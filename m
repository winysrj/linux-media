Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPQi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:38 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/6] v4l2-event: Add v4l2_subscribed_event_ops
Date: Mon, 31 Oct 2011 16:16:48 +0100
Message-Id: <1320074209-23473-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like with ctrl events, drivers may want to get called back on
listener add / remove for other event types too. Rather then special
casing all of this in subscribe / unsubscribe event it is better to
use ops for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/video4linux/v4l2-framework.txt |   28 +++++++++++++----
 drivers/media/video/ivtv/ivtv-ioctl.c        |    2 +-
 drivers/media/video/omap3isp/ispccdc.c       |    2 +-
 drivers/media/video/omap3isp/ispstat.c       |    2 +-
 drivers/media/video/pwc/pwc-v4l.c            |    2 +-
 drivers/media/video/v4l2-event.c             |   42 +++++++++++++++++++------
 drivers/media/video/vivi.c                   |    2 +-
 include/media/v4l2-event.h                   |   24 ++++++++++----
 8 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f8dcabf..16eb8af 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -930,21 +930,35 @@ fast.
 
 Useful functions:
 
-- v4l2_event_queue()
+void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 
   Queue events to video device. The driver's only responsibility is to fill
   in the type and the data fields. The other fields will be filled in by
   V4L2.
 
-- v4l2_event_subscribe()
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_subscribed_event_ops *ops)
 
   The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
   is able to produce events with specified event id. Then it calls
-  v4l2_event_subscribe() to subscribe the event. The last argument is the
-  size of the event queue for this event. If it is 0, then the framework
-  will fill in a default value (this depends on the event type).
+  v4l2_event_subscribe() to subscribe the event.
 
-- v4l2_event_unsubscribe()
+  The elems argument is the size of the event queue for this event. If it is 0,
+  then the framework will fill in a default value (this depends on the event
+  type).
+
+  The ops argument allows the driver to specify a number of callbacks:
+  * add:     called when a new listener gets added (subscribing to the same
+             event twice will only cause this callback to get called once)
+  * del:     called when a listener stops listening
+  * replace: replace event 'old' with event 'new'.
+  * merge:   merge event 'old' into event 'new'.
+  All 4 callbacks are optional, if you don't want to specify any callbacks
+  the ops argument itself maybe NULL.
+
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub)
 
   vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
   v4l2_event_unsubscribe() directly unless it wants to be involved in
@@ -953,7 +967,7 @@ Useful functions:
   The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
   drivers may want to handle this in a special way.
 
-- v4l2_event_pending()
+int v4l2_event_pending(struct v4l2_fh *fh)
 
   Returns the number of pending events. Useful when implementing poll.
 
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index ecafa69..9aec8a0 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1456,7 +1456,7 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscripti
 	case V4L2_EVENT_VSYNC:
 	case V4L2_EVENT_EOS:
 	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0);
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 40b141c..b6da736 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1700,7 +1700,7 @@ static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 	if (sub->id != 0)
 		return -EINVAL;
 
-	return v4l2_event_subscribe(fh, sub, OMAP3ISP_CCDC_NEVENTS);
+	return v4l2_event_subscribe(fh, sub, OMAP3ISP_CCDC_NEVENTS, NULL);
 }
 
 static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index 8080659..4f337a2 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -1049,7 +1049,7 @@ int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 	if (sub->type != stat->event_type)
 		return -EINVAL;
 
-	return v4l2_event_subscribe(fh, sub, STAT_NEVENTS);
+	return v4l2_event_subscribe(fh, sub, STAT_NEVENTS, NULL);
 }
 
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index 68e1323..7f159bf 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1138,7 +1138,7 @@ static int pwc_subscribe_event(struct v4l2_fh *fh,
 {
 	switch (sub->type) {
 	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0);
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 3d27300..c56dc35 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -131,14 +131,14 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 		sev->first = sev_pos(sev, 1);
 		fh->navailable--;
 		if (sev->elems == 1) {
-			if (sev->replace) {
-				sev->replace(&kev->event, ev);
+			if (sev->ops && sev->ops->replace) {
+				sev->ops->replace(&kev->event, ev);
 				copy_payload = false;
 			}
-		} else if (sev->merge) {
+		} else if (sev->ops && sev->ops->merge) {
 			struct v4l2_kevent *second_oldest =
 				sev->events + sev_pos(sev, 0);
-			sev->merge(&kev->event, &second_oldest->event);
+			sev->ops->merge(&kev->event, &second_oldest->event);
 		}
 	}
 
@@ -207,8 +207,14 @@ static void ctrls_merge(const struct v4l2_event *old, struct v4l2_event *new)
 	new->u.ctrl.changes |= old->u.ctrl.changes;
 }
 
+static const struct v4l2_subscribed_event_ops ctrl_ops = {
+	.replace = ctrls_replace,
+	.merge = ctrls_merge,
+};
+
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub, unsigned elems)
+			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_subscribed_event_ops *ops)
 {
 	struct v4l2_subscribed_event *sev, *found_ev;
 	struct v4l2_ctrl *ctrl = NULL;
@@ -236,9 +242,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->elems = elems;
+	sev->ops = ops;
 	if (ctrl) {
-		sev->replace = ctrls_replace;
-		sev->merge = ctrls_merge;
+		sev->ops = &ctrl_ops;
 	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
@@ -247,10 +253,22 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		list_add(&sev->list, &fh->subscribed);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
-	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
-	if (found_ev)
+	if (found_ev) {
 		kfree(sev);
-	else if (ctrl)
+		return 0; /* Already listening */
+	}
+
+	if (sev->ops && sev->ops->add) {
+		int ret = sev->ops->add(sev);
+		if (ret) {
+			sev->ops = NULL;
+			v4l2_event_unsubscribe(fh, sub);
+			return ret;
+		}
+	}
+
+	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
+	if (ctrl)
 		v4l2_ctrl_add_event(ctrl, sev);
 
 	return 0;
@@ -307,6 +325,10 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	}
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	if (sev && sev->ops && sev->ops->del)
+		sev->ops->del(sev);
+
 	if (sev && sev->type == V4L2_EVENT_CTRL) {
 		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
 
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index c25787d..74ebbad 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1013,7 +1013,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 {
 	switch (sub->type) {
 	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0);
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return -EINVAL;
 	}
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 5f14e88..88fa9a1 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -78,6 +78,19 @@ struct v4l2_kevent {
 	struct v4l2_event	event;
 };
 
+/** struct v4l2_subscribed_event_ops - Subscribed event operations.
+  * @add:	Optional callback, called when a new listener is added
+  * @del:	Optional callback, called when a listener stops listening
+  * @replace:	Optional callback that can replace event 'old' with event 'new'.
+  * @merge:	Optional callback that can merge event 'old' into event 'new'.
+  */
+struct v4l2_subscribed_event_ops {
+	int  (*add)(struct v4l2_subscribed_event *sev);
+	void (*del)(struct v4l2_subscribed_event *sev);
+	void (*replace)(struct v4l2_event *old, const struct v4l2_event *new);
+	void (*merge)(const struct v4l2_event *old, struct v4l2_event *new);
+};
+
 /** struct v4l2_subscribed_event - Internal struct representing a subscribed event.
   * @list:	List node for the v4l2_fh->subscribed list.
   * @type:	Event type.
@@ -85,8 +98,7 @@ struct v4l2_kevent {
   * @flags:	Copy of v4l2_event_subscription->flags.
   * @fh:	Filehandle that subscribed to this event.
   * @node:	List node that hooks into the object's event list (if there is one).
-  * @replace:	Optional callback that can replace event 'old' with event 'new'.
-  * @merge:	Optional callback that can merge event 'old' into event 'new'.
+  * @ops:	v4l2_subscribed_event_ops
   * @elems:	The number of elements in the events array.
   * @first:	The index of the events containing the oldest available event.
   * @in_use:	The number of queued events.
@@ -99,10 +111,7 @@ struct v4l2_subscribed_event {
 	u32			flags;
 	struct v4l2_fh		*fh;
 	struct list_head	node;
-	void			(*replace)(struct v4l2_event *old,
-					   const struct v4l2_event *new);
-	void			(*merge)(const struct v4l2_event *old,
-					 struct v4l2_event *new);
+	const struct v4l2_subscribed_event_ops *ops;
 	unsigned		elems;
 	unsigned		first;
 	unsigned		in_use;
@@ -115,7 +124,8 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub, unsigned elems);
+			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_subscribed_event_ops *ops);
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   struct v4l2_event_subscription *sub);
 void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
-- 
1.7.7

