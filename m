Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1280 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab1F1L0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/13] v4l2-event/ctrls/fh: allocate events per fh and per type instead of just per-fh
Date: Tue, 28 Jun 2011 13:25:55 +0200
Message-Id: <ec0f8d68039a80667b7cc5177a9d28f6da7a2e4a.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The driver had to decide how many events to allocate when the v4l2_fh struct
was created. It was possible to add more events afterwards, but there was no
way to ensure that you wouldn't miss important events if the event queue
would fill up for that filehandle.

In addition, once there were no more free events, any new events were simply
dropped on the floor.

For the control event in particular this made life very difficult since
control status/value changes could just be missed if the number of allocated
events and the speed at which the application read events was too low to keep
up with the number of generated events. The application would have no idea
what the latest state was for a control since it could have missed the latest
control change.

So this patch makes some major changes in how events are allocated. Instead
of allocating events per-filehandle they are now allocated when subscribing an
event. So for that particular event type N events (determined by the driver)
are allocated. Those events are reserved for that particular event type.
This ensures that you will not miss events for a particular type altogether.

In addition, if there are N events in use and a new event is raised, then
the oldest event is dropped and the new one is added. So the latest event
is always available.

This can be further improved by adding the ability to merge the state of
two events together, ensuring that no data is lost at all. This will be
added in the next patch.

This also makes it possible to allow the user to determine the number of
events that will be allocated. This is not implemented at the moment, but
would be trivial.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |    4 --
 drivers/media/video/ivtv/ivtv-ioctl.c   |    4 +-
 drivers/media/video/omap3isp/ispccdc.c  |    3 +-
 drivers/media/video/omap3isp/ispstat.c  |    3 +-
 drivers/media/video/v4l2-ctrls.c        |   18 ------
 drivers/media/video/v4l2-event.c        |   88 ++++++++++++-------------------
 drivers/media/video/v4l2-fh.c           |    4 +-
 drivers/media/video/v4l2-subdev.c       |    7 ---
 drivers/media/video/vivi.c              |    2 +-
 drivers/usb/gadget/uvc_v4l2.c           |   12 +----
 include/media/v4l2-ctrls.h              |   19 -------
 include/media/v4l2-event.h              |   18 +++++-
 include/media/v4l2-fh.h                 |    2 -
 include/media/v4l2-subdev.h             |    2 -
 14 files changed, 54 insertions(+), 132 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index e507766..5796262 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -957,10 +957,6 @@ static int ivtv_serialized_open(struct ivtv_stream *s, struct file *filp)
 		return -ENOMEM;
 	}
 	v4l2_fh_init(&item->fh, s->vdev);
-	if (s->type == IVTV_DEC_STREAM_TYPE_YUV ||
-	    s->type == IVTV_DEC_STREAM_TYPE_MPG) {
-		res = v4l2_event_alloc(&item->fh, 60);
-	}
 	if (res < 0) {
 		v4l2_fh_exit(&item->fh);
 		kfree(item);
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index a81b4be..99b2bdc 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1444,13 +1444,11 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscripti
 	switch (sub->type) {
 	case V4L2_EVENT_VSYNC:
 	case V4L2_EVENT_EOS:
-		break;
 	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subscribe_fh(fh, sub, 0);
+		return v4l2_event_subscribe(fh, sub, 0);
 	default:
 		return -EINVAL;
 	}
-	return v4l2_event_subscribe(fh, sub);
 }
 
 static int ivtv_log_status(struct file *file, void *fh)
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 39d501b..6766247 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1691,7 +1691,7 @@ static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 	if (sub->type != V4L2_EVENT_OMAP3ISP_HS_VS)
 		return -EINVAL;
 
-	return v4l2_event_subscribe(fh, sub);
+	return v4l2_event_subscribe(fh, sub, OMAP3ISP_CCDC_NEVENTS);
 }
 
 static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
@@ -2162,7 +2162,6 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, ccdc);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
-	sd->nevents = OMAP3ISP_CCDC_NEVENTS;
 
 	pads[CCDC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	pads[CCDC_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index b44cb68..8080659 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -1032,7 +1032,6 @@ static int isp_stat_init_entities(struct ispstat *stat, const char *name,
 	snprintf(subdev->name, V4L2_SUBDEV_NAME_SIZE, "OMAP3 ISP %s", name);
 	subdev->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
-	subdev->nevents = STAT_NEVENTS;
 	v4l2_set_subdevdata(subdev, stat);
 
 	stat->pad.flags = MEDIA_PAD_FL_SINK;
@@ -1050,7 +1049,7 @@ int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 	if (sub->type != stat->event_type)
 		return -EINVAL;
 
-	return v4l2_event_subscribe(fh, sub);
+	return v4l2_event_subscribe(fh, sub, STAT_NEVENTS);
 }
 
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 079f952..63a44fd 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1011,7 +1011,6 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	   insertion is an O(1) operation. */
 	if (list_empty(&hdl->ctrl_refs) || id > node2id(hdl->ctrl_refs.prev)) {
 		list_add_tail(&new_ref->node, &hdl->ctrl_refs);
-		hdl->nr_of_refs++;
 		goto insert_in_hash;
 	}
 
@@ -2050,20 +2049,3 @@ void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
 	v4l2_ctrl_unlock(ctrl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_del_event);
-
-int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
-			struct v4l2_event_subscription *sub, unsigned n)
-{
-	struct v4l2_ctrl_handler *hdl = fh->ctrl_handler;
-	int ret = 0;
-
-	if (!ret) {
-		if (hdl->nr_of_refs * 2 > n)
-			n = hdl->nr_of_refs * 2;
-		ret = v4l2_event_alloc(fh, n);
-	}
-	if (!ret)
-		ret = v4l2_event_subscribe(fh, sub);
-	return ret;
-}
-EXPORT_SYMBOL(v4l2_ctrl_subscribe_fh);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index dc68f60..9e325dd 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -30,44 +30,11 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
-
-int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
-{
-	unsigned long flags;
-
-	while (fh->nallocated < n) {
-		struct v4l2_kevent *kev;
-
-		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
-		if (kev == NULL)
-			return -ENOMEM;
-
-		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-		list_add_tail(&kev->list, &fh->free);
-		fh->nallocated++;
-		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(v4l2_event_alloc);
-
-#define list_kfree(list, type, member)				\
-	while (!list_empty(list)) {				\
-		type *hi;					\
-		hi = list_first_entry(list, type, member);	\
-		list_del(&hi->member);				\
-		kfree(hi);					\
-	}
-
-void v4l2_event_free(struct v4l2_fh *fh)
+static unsigned sev_pos(const struct v4l2_subscribed_event *sev, unsigned idx)
 {
-	list_kfree(&fh->free, struct v4l2_kevent, list);
-	list_kfree(&fh->available, struct v4l2_kevent, list);
-	v4l2_event_unsubscribe_all(fh);
+	idx += sev->first;
+	return idx >= sev->elems ? idx - sev->elems : idx;
 }
-EXPORT_SYMBOL_GPL(v4l2_event_free);
 
 static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 {
@@ -84,11 +51,13 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 	WARN_ON(fh->navailable == 0);
 
 	kev = list_first_entry(&fh->available, struct v4l2_kevent, list);
-	list_move(&kev->list, &fh->free);
+	list_del(&kev->list);
 	fh->navailable--;
 
 	kev->event.pending = fh->navailable;
 	*event = kev->event;
+	kev->sev->first = sev_pos(kev->sev, 1);
+	kev->sev->in_use--;
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
@@ -154,17 +123,24 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	fh->sequence++;
 
 	/* Do we have any free events? */
-	if (list_empty(&fh->free))
-		return;
+	if (sev->in_use == sev->elems) {
+		/* no, remove the oldest one */
+		kev = sev->events + sev_pos(sev, 0);
+		list_del(&kev->list);
+		sev->in_use--;
+		sev->first = sev_pos(sev, 1);
+		fh->navailable--;
+	}
 
 	/* Take one and fill it. */
-	kev = list_first_entry(&fh->free, struct v4l2_kevent, list);
+	kev = sev->events + sev_pos(sev, sev->in_use);
 	kev->event.type = ev->type;
 	kev->event.u = ev->u;
 	kev->event.id = ev->id;
 	kev->event.timestamp = *ts;
 	kev->event.sequence = fh->sequence;
-	list_move_tail(&kev->list, &fh->available);
+	sev->in_use++;
+	list_add_tail(&kev->list, &fh->available);
 
 	fh->navailable++;
 
@@ -209,38 +185,39 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub)
+			 struct v4l2_event_subscription *sub, unsigned elems)
 {
 	struct v4l2_subscribed_event *sev, *found_ev;
 	struct v4l2_ctrl *ctrl = NULL;
 	unsigned long flags;
+	unsigned i;
 
+	if (elems < 1)
+		elems = 1;
 	if (sub->type == V4L2_EVENT_CTRL) {
 		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
 		if (ctrl == NULL)
 			return -EINVAL;
 	}
 
-	sev = kzalloc(sizeof(*sev), GFP_KERNEL);
+	sev = kzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems, GFP_KERNEL);
 	if (!sev)
 		return -ENOMEM;
+	for (i = 0; i < elems; i++)
+		sev->events[i].sev = sev;
+	sev->type = sub->type;
+	sev->id = sub->id;
+	sev->flags = sub->flags;
+	sev->fh = fh;
+	sev->elems = elems;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
-	if (!found_ev) {
-		INIT_LIST_HEAD(&sev->list);
-		sev->type = sub->type;
-		sev->id = sub->id;
-		sev->fh = fh;
-		sev->flags = sub->flags;
-
+	if (!found_ev)
 		list_add(&sev->list, &fh->subscribed);
-	}
-
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
-	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
+	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
 	if (found_ev)
 		kfree(sev);
 	else if (ctrl)
@@ -250,7 +227,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 }
 EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 
-static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
+void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 {
 	struct v4l2_event_subscription sub;
 	struct v4l2_subscribed_event *sev;
@@ -271,6 +248,7 @@ static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 			v4l2_event_unsubscribe(fh, &sub);
 	} while (sev);
 }
+EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe_all);
 
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   struct v4l2_event_subscription *sub)
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 333b8c8..122822d 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -37,9 +37,7 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 	fh->prio = V4L2_PRIORITY_UNSET;
-
 	init_waitqueue_head(&fh->wait);
-	INIT_LIST_HEAD(&fh->free);
 	INIT_LIST_HEAD(&fh->available);
 	INIT_LIST_HEAD(&fh->subscribed);
 	fh->sequence = -1;
@@ -88,7 +86,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
-	v4l2_event_free(fh);
+	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 3b67a85..b7967c9 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -76,13 +76,6 @@ static int subdev_open(struct file *file)
 	}
 
 	v4l2_fh_init(&subdev_fh->vfh, vdev);
-
-	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
-		ret = v4l2_event_alloc(&subdev_fh->vfh, sd->nevents);
-		if (ret)
-			goto err;
-	}
-
 	v4l2_fh_add(&subdev_fh->vfh);
 	file->private_data = &subdev_fh->vfh;
 #if defined(CONFIG_MEDIA_CONTROLLER)
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 99dbaea..e52063f 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -998,7 +998,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 {
 	switch (sub->type) {
 	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subscribe_fh(fh, sub, 0);
+		return v4l2_event_subscribe(fh, sub, 0);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index 5582870..52f8f9e 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -124,18 +124,12 @@ uvc_v4l2_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_device *uvc = video_get_drvdata(vdev);
 	struct uvc_file_handle *handle;
-	int ret;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (handle == NULL)
 		return -ENOMEM;
 
 	v4l2_fh_init(&handle->vfh, vdev);
-
-	ret = v4l2_event_alloc(&handle->vfh, 8);
-	if (ret < 0)
-		goto error;
-
 	v4l2_fh_add(&handle->vfh);
 
 	handle->device = &uvc->video;
@@ -143,10 +137,6 @@ uvc_v4l2_open(struct file *file)
 
 	uvc_function_connect(uvc);
 	return 0;
-
-error:
-	v4l2_fh_exit(&handle->vfh);
-	return ret;
 }
 
 static int
@@ -308,7 +298,7 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
 			return -EINVAL;
 
-		return v4l2_event_subscribe(&handle->vfh, arg);
+		return v4l2_event_subscribe(&handle->vfh, arg, 2);
 	}
 
 	case VIDIOC_UNSUBSCRIBE_EVENT:
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 635adc2..d8123d9 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -171,7 +171,6 @@ struct v4l2_ctrl_ref {
   *		control is needed multiple times, so this is a simple
   *		optimization.
   * @buckets:	Buckets for the hashing. Allows for quick control lookup.
-  * @nr_of_refs: Total number of control references in the list.
   * @nr_of_buckets: Total number of buckets in the array.
   * @error:	The error code of the first failed control addition.
   */
@@ -181,7 +180,6 @@ struct v4l2_ctrl_handler {
 	struct list_head ctrl_refs;
 	struct v4l2_ctrl_ref *cached;
 	struct v4l2_ctrl_ref **buckets;
-	u16 nr_of_refs;
 	u16 nr_of_buckets;
 	int error;
 };
@@ -499,23 +497,6 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
 		struct v4l2_subscribed_event *sev);
 
-/** v4l2_ctrl_subscribe_fh() - Helper function that subscribes a control event.
-  * @fh:	The file handler that subscribed the control event.
-  * @sub:	The event to subscribe (type must be V4L2_EVENT_CTRL).
-  * @n:		How many events should be allocated? (Passed to v4l2_event_alloc).
-  *		Recommended to set to twice the number of controls plus whatever
-  *		is needed for other events. This function will set n to
-  *		max(n, 2 * fh->ctrl_handler->nr_of_refs).
-  *
-  * A helper function that initializes the fh for events, allocates the
-  * list of events and subscribes the control event.
-  *
-  * Typically called in the handler of VIDIOC_SUBSCRIBE_EVENT in the
-  * V4L2_EVENT_CTRL case.
-  */
-int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
-			struct v4l2_event_subscription *sub, unsigned n);
-
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index eda17f8..8d681e5 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -30,10 +30,15 @@
 #include <linux/wait.h>
 
 struct v4l2_fh;
+struct v4l2_subscribed_event;
 struct video_device;
 
 struct v4l2_kevent {
+	/* list node for the v4l2_fh->available list */
 	struct list_head	list;
+	/* pointer to parent v4l2_subscribed_event */
+	struct v4l2_subscribed_event *sev;
+	/* event itself */
 	struct v4l2_event	event;
 };
 
@@ -50,18 +55,25 @@ struct v4l2_subscribed_event {
 	struct v4l2_fh		*fh;
 	/* list node that hooks into the object's event list (if there is one) */
 	struct list_head	node;
+	/* the number of elements in the events array */
+	unsigned		elems;
+	/* the index of the events containing the oldest available event */
+	unsigned		first;
+	/* the number of queued events */
+	unsigned		in_use;
+	/* an array of elems events */
+	struct v4l2_kevent	events[];
 };
 
-int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-void v4l2_event_free(struct v4l2_fh *fh);
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 struct v4l2_event_subscription *sub);
+			 struct v4l2_event_subscription *sub, unsigned elems);
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   struct v4l2_event_subscription *sub);
+void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
 
 #endif /* V4L2_EVENT_H */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index bfc0457..52513c2 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -40,10 +40,8 @@ struct v4l2_fh {
 	/* Events */
 	wait_queue_head_t	wait;
 	struct list_head	subscribed; /* Subscribed events */
-	struct list_head	free; /* Events ready for use */
 	struct list_head	available; /* Dequeueable event */
 	unsigned int		navailable;
-	unsigned int		nallocated; /* Number of allocated events */
 	u32			sequence;
 };
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..e249f78 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -509,8 +509,6 @@ struct v4l2_subdev {
 	void *host_priv;
 	/* subdev device node */
 	struct video_device devnode;
-	/* number of events to be allocated on open */
-	unsigned int nevents;
 };
 
 #define media_entity_to_v4l2_subdev(ent) \
-- 
1.7.1

