Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4176 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1FNPWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:22:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/8] v4l2-events/fh: merge v4l2_events into v4l2_fh
Date: Tue, 14 Jun 2011 17:22:26 +0200
Message-Id: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
In-Reply-To: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drivers that supported events used to be rare, but now that controls can also
raise events this will become much more common since almost all drivers have
controls.

This means that keeping struct v4l2_events as a separate struct make no more
sense. Merging it into struct v4l2_fh simplifies things substantially as it
is now an integral part of the filehandle struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |    6 +-
 drivers/media/video/v4l2-ctrls.c        |    2 -
 drivers/media/video/v4l2-event.c        |   93 ++++++++----------------------
 drivers/media/video/v4l2-fh.c           |   17 ++----
 drivers/media/video/v4l2-subdev.c       |   10 +---
 drivers/media/video/vivi.c              |    2 +-
 drivers/usb/gadget/uvc_v4l2.c           |   10 +---
 include/media/v4l2-event.h              |   11 ----
 include/media/v4l2-fh.h                 |   13 +++-
 9 files changed, 49 insertions(+), 115 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 75c0354..e507766 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -722,8 +722,8 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 
 	/* If there are subscribed events, then only use the new event
 	   API instead of the old video.h based API. */
-	if (!list_empty(&id->fh.events->subscribed)) {
-		poll_wait(filp, &id->fh.events->wait, wait);
+	if (!list_empty(&id->fh.subscribed)) {
+		poll_wait(filp, &id->fh.wait, wait);
 		/* Turn off the old-style vsync events */
 		clear_bit(IVTV_F_I_EV_VSYNC_ENABLED, &itv->i_flags);
 		if (v4l2_event_pending(&id->fh))
@@ -761,7 +761,7 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	if (v4l2_event_pending(&id->fh))
 		res |= POLLPRI;
 	else
-		poll_wait(filp, &id->fh.events->wait, wait);
+		poll_wait(filp, &id->fh.wait, wait);
 
 	if (s->q_full.length || s->q_io.length)
 		return res | POLLIN | POLLRDNORM;
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index d084cea..f581910 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2069,8 +2069,6 @@ int v4l2_ctrl_subscribe_fh(struct v4l2_fh *fh,
 	struct v4l2_ctrl_handler *hdl = fh->ctrl_handler;
 	int ret = 0;
 
-	if (!fh->events)
-		ret = v4l2_event_init(fh);
 	if (!ret) {
 		if (hdl->nr_of_refs * 2 > n)
 			n = hdl->nr_of_refs * 2;
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 670f2f8..70fa82d 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -32,35 +32,11 @@
 
 static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
 
-int v4l2_event_init(struct v4l2_fh *fh)
-{
-	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
-	if (fh->events == NULL)
-		return -ENOMEM;
-
-	init_waitqueue_head(&fh->events->wait);
-
-	INIT_LIST_HEAD(&fh->events->free);
-	INIT_LIST_HEAD(&fh->events->available);
-	INIT_LIST_HEAD(&fh->events->subscribed);
-
-	fh->events->sequence = -1;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(v4l2_event_init);
-
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 {
-	struct v4l2_events *events = fh->events;
 	unsigned long flags;
 
-	if (!events) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
-	while (events->nallocated < n) {
+	while (fh->nallocated < n) {
 		struct v4l2_kevent *kev;
 
 		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
@@ -68,8 +44,8 @@ int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 			return -ENOMEM;
 
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-		list_add_tail(&kev->list, &events->free);
-		events->nallocated++;
+		list_add_tail(&kev->list, &fh->free);
+		fh->nallocated++;
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 	}
 
@@ -87,40 +63,31 @@ EXPORT_SYMBOL_GPL(v4l2_event_alloc);
 
 void v4l2_event_free(struct v4l2_fh *fh)
 {
-	struct v4l2_events *events = fh->events;
-
-	if (!events)
-		return;
-
-	list_kfree(&events->free, struct v4l2_kevent, list);
-	list_kfree(&events->available, struct v4l2_kevent, list);
+	list_kfree(&fh->free, struct v4l2_kevent, list);
+	list_kfree(&fh->available, struct v4l2_kevent, list);
 	v4l2_event_unsubscribe_all(fh);
-
-	kfree(events);
-	fh->events = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_free);
 
 static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 {
-	struct v4l2_events *events = fh->events;
 	struct v4l2_kevent *kev;
 	unsigned long flags;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
-	if (list_empty(&events->available)) {
+	if (list_empty(&fh->available)) {
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 		return -ENOENT;
 	}
 
-	WARN_ON(events->navailable == 0);
+	WARN_ON(fh->navailable == 0);
 
-	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
-	list_move(&kev->list, &events->free);
-	events->navailable--;
+	kev = list_first_entry(&fh->available, struct v4l2_kevent, list);
+	list_move(&kev->list, &fh->free);
+	fh->navailable--;
 
-	kev->event.pending = events->navailable;
+	kev->event.pending = fh->navailable;
 	*event = kev->event;
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
@@ -131,7 +98,6 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking)
 {
-	struct v4l2_events *events = fh->events;
 	int ret;
 
 	if (nonblocking)
@@ -142,8 +108,8 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		mutex_unlock(fh->vdev->lock);
 
 	do {
-		ret = wait_event_interruptible(events->wait,
-					       events->navailable != 0);
+		ret = wait_event_interruptible(fh->wait,
+					       fh->navailable != 0);
 		if (ret < 0)
 			break;
 
@@ -161,12 +127,11 @@ EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
 static struct v4l2_subscribed_event *v4l2_event_subscribed(
 		struct v4l2_fh *fh, u32 type, u32 id)
 {
-	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
 
 	assert_spin_locked(&fh->vdev->fh_lock);
 
-	list_for_each_entry(sev, &events->subscribed, list) {
+	list_for_each_entry(sev, &fh->subscribed, list) {
 		if (sev->type == type && sev->id == id)
 			return sev;
 	}
@@ -177,7 +142,6 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
 		const struct timespec *ts)
 {
-	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
 
@@ -187,24 +151,24 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 		return;
 
 	/* Increase event sequence number on fh. */
-	events->sequence++;
+	fh->sequence++;
 
 	/* Do we have any free events? */
-	if (list_empty(&events->free))
+	if (list_empty(&fh->free))
 		return;
 
 	/* Take one and fill it. */
-	kev = list_first_entry(&events->free, struct v4l2_kevent, list);
+	kev = list_first_entry(&fh->free, struct v4l2_kevent, list);
 	kev->event.type = ev->type;
 	kev->event.u = ev->u;
 	kev->event.id = ev->id;
 	kev->event.timestamp = *ts;
-	kev->event.sequence = events->sequence;
-	list_move_tail(&kev->list, &events->available);
+	kev->event.sequence = fh->sequence;
+	list_move_tail(&kev->list, &fh->available);
 
-	events->navailable++;
+	fh->navailable++;
 
-	wake_up_all(&events->wait);
+	wake_up_all(&fh->wait);
 }
 
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
@@ -240,24 +204,18 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
 
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
-	return fh->events->navailable;
+	return fh->navailable;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub)
 {
-	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev, *found_ev;
 	struct v4l2_ctrl *ctrl = NULL;
 	struct v4l2_ctrl_fh *ctrl_fh = NULL;
 	unsigned long flags;
 
-	if (fh->events == NULL) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
 	if (sub->type == V4L2_EVENT_CTRL) {
 		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
 		if (ctrl == NULL)
@@ -284,7 +242,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		sev->type = sub->type;
 		sev->id = sub->id;
 
-		list_add(&sev->list, &events->subscribed);
+		list_add(&sev->list, &fh->subscribed);
 		sev = NULL;
 	}
 
@@ -306,7 +264,6 @@ EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 
 static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 {
-	struct v4l2_events *events = fh->events;
 	struct v4l2_event_subscription sub;
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
@@ -315,8 +272,8 @@ static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
 		sev = NULL;
 
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-		if (!list_empty(&events->subscribed)) {
-			sev = list_first_entry(&events->subscribed,
+		if (!list_empty(&fh->subscribed)) {
+			sev = list_first_entry(&fh->subscribed,
 					struct v4l2_subscribed_event, list);
 			sub.type = sev->type;
 			sub.id = sev->id;
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index c6aef84..333b8c8 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -29,7 +29,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 
-int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
 	/* Inherit from video_device. May be overridden by the driver. */
@@ -38,16 +38,11 @@ int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 	fh->prio = V4L2_PRIORITY_UNSET;
 
-	/*
-	 * fh->events only needs to be initialized if the driver
-	 * supports the VIDIOC_SUBSCRIBE_EVENT ioctl.
-	 */
-	if (vdev->ioctl_ops && vdev->ioctl_ops->vidioc_subscribe_event)
-		return v4l2_event_init(fh);
-
-	fh->events = NULL;
-
-	return 0;
+	init_waitqueue_head(&fh->wait);
+	INIT_LIST_HEAD(&fh->free);
+	INIT_LIST_HEAD(&fh->available);
+	INIT_LIST_HEAD(&fh->subscribed);
+	fh->sequence = -1;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
 
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index fd5dcca..3b67a85 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -75,15 +75,9 @@ static int subdev_open(struct file *file)
 		return ret;
 	}
 
-	ret = v4l2_fh_init(&subdev_fh->vfh, vdev);
-	if (ret)
-		goto err;
+	v4l2_fh_init(&subdev_fh->vfh, vdev);
 
 	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
-		ret = v4l2_event_init(&subdev_fh->vfh);
-		if (ret)
-			goto err;
-
 		ret = v4l2_event_alloc(&subdev_fh->vfh, sd->nevents);
 		if (ret)
 			goto err;
@@ -297,7 +291,7 @@ static unsigned int subdev_poll(struct file *file, poll_table *wait)
 	if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
 		return POLLERR;
 
-	poll_wait(file, &fh->events->wait, wait);
+	poll_wait(file, &fh->wait, wait);
 
 	if (v4l2_event_pending(fh))
 		return POLLPRI;
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index f4f599a..99dbaea 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1051,7 +1051,7 @@ vivi_poll(struct file *file, struct poll_table_struct *wait)
 	if (v4l2_event_pending(fh))
 		res |= POLLPRI;
 	else
-		poll_wait(file, &fh->events->wait, wait);
+		poll_wait(file, &fh->wait, wait);
 	return res;
 }
 
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index 5e807f0..5582870 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -130,13 +130,7 @@ uvc_v4l2_open(struct file *file)
 	if (handle == NULL)
 		return -ENOMEM;
 
-	ret = v4l2_fh_init(&handle->vfh, vdev);
-	if (ret < 0)
-		goto error;
-
-	ret = v4l2_event_init(&handle->vfh);
-	if (ret < 0)
-		goto error;
+	v4l2_fh_init(&handle->vfh, vdev);
 
 	ret = v4l2_event_alloc(&handle->vfh, 8);
 	if (ret < 0)
@@ -354,7 +348,7 @@ uvc_v4l2_poll(struct file *file, poll_table *wait)
 	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
 	unsigned int mask = 0;
 
-	poll_wait(file, &handle->vfh.events->wait, wait);
+	poll_wait(file, &handle->vfh.wait, wait);
 	if (v4l2_event_pending(&handle->vfh))
 		mask |= POLLPRI;
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 45e9c1e..042b893 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -43,17 +43,6 @@ struct v4l2_subscribed_event {
 	u32			id;
 };
 
-struct v4l2_events {
-	wait_queue_head_t	wait;
-	struct list_head	subscribed; /* Subscribed events */
-	struct list_head	free; /* Events ready for use */
-	struct list_head	available; /* Dequeueable event */
-	unsigned int		navailable;
-	unsigned int		nallocated; /* Number of allocated events */
-	u32			sequence;
-};
-
-int v4l2_event_init(struct v4l2_fh *fh);
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
 void v4l2_event_free(struct v4l2_fh *fh);
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index d247111..bfc0457 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -29,15 +29,22 @@
 #include <linux/list.h>
 
 struct video_device;
-struct v4l2_events;
 struct v4l2_ctrl_handler;
 
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
-	struct v4l2_events      *events; /* events, pending and subscribed */
 	struct v4l2_ctrl_handler *ctrl_handler;
 	enum v4l2_priority	prio;
+
+	/* Events */
+	wait_queue_head_t	wait;
+	struct list_head	subscribed; /* Subscribed events */
+	struct list_head	free; /* Events ready for use */
+	struct list_head	available; /* Dequeueable event */
+	unsigned int		navailable;
+	unsigned int		nallocated; /* Number of allocated events */
+	u32			sequence;
 };
 
 /*
@@ -46,7 +53,7 @@ struct v4l2_fh {
  * from driver's v4l2_file_operations->open() handler if the driver
  * uses v4l2_fh.
  */
-int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
+void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
 /*
  * Add the fh to the list of file handles on a video_device. The file
  * handle must be initialised first.
-- 
1.7.1

