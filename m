Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:53318 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbdJTVug (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:36 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 04/17] WIP: [media] v4l2: add v4l2_event_queue_fh_with_cb()
Date: Fri, 20 Oct 2017 19:49:59 -0200
Message-Id: <20171020215012.20646-5-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

For some type of events we may require the event user in the
kernel to run some operation when DQ_EVENT() is called.
V4L2_EVENT_OUT_FENCE is the first user of this mechanism as it needs
to call v4l2 core back to install a file descriptor.

This is WIP, I believe we are able to come up with better ways to do it,
but as that is not the main part of the patchset I'll keep it like
this for now.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/v4l2-event.c | 31 +++++++++++++++++++++++++++----
 include/media/v4l2-event.h           |  7 +++++++
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 313ee9d1f9ee..6274e3e174e0 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -58,6 +58,9 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
+	if (kev->prepare)
+		kev->prepare(kev->data);
+
 	return 0;
 }
 
@@ -104,8 +107,11 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	return NULL;
 }
 
-static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
-		const struct timespec *ts)
+static void __v4l2_event_queue_fh_with_cb(struct v4l2_fh *fh,
+					  const struct v4l2_event *ev,
+					  const struct timespec *ts,
+					  void (*prepare)(void *data),
+					  void *data)
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
@@ -155,6 +161,8 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	kev->event.id = ev->id;
 	kev->event.timestamp = *ts;
 	kev->event.sequence = fh->sequence;
+	kev->prepare = prepare;
+	kev->data = data;
 	sev->in_use++;
 	list_add_tail(&kev->list, &fh->available);
 
@@ -177,7 +185,7 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list)
-		__v4l2_event_queue_fh(fh, ev, &timestamp);
+		__v4l2_event_queue_fh_with_cb(fh, ev, &timestamp, NULL, NULL);
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
@@ -191,11 +199,26 @@ void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
 	ktime_get_ts(&timestamp);
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	__v4l2_event_queue_fh_with_cb(fh, ev, &timestamp, NULL, NULL);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
 
+void v4l2_event_queue_fh_with_cb(struct v4l2_fh *fh,
+				 const struct v4l2_event *ev,
+				 void (*prepare)(void *data), void *data)
+{
+	unsigned long flags;
+	struct timespec timestamp;
+
+	ktime_get_ts(&timestamp);
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	__v4l2_event_queue_fh_with_cb(fh, ev, &timestamp, prepare, data);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_queue_fh_with_cb);
+
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
 	return fh->navailable;
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 2b794f2ad824..dc770257811e 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -68,11 +68,14 @@ struct video_device;
  * @list:	List node for the v4l2_fh->available list.
  * @sev:	Pointer to parent v4l2_subscribed_event.
  * @event:	The event itself.
+ * @prepare:	Callback to prepare the event only at DQ_EVENT() time.
  */
 struct v4l2_kevent {
 	struct list_head	list;
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_event	event;
+	void (*prepare)(void *data);
+	void *data;
 };
 
 /**
@@ -160,6 +163,10 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
  */
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 
+void v4l2_event_queue_fh_with_cb(struct v4l2_fh *fh,
+				 const struct v4l2_event *ev,
+				 void (*prepare)(void *data), void *data);
+
 /**
  * v4l2_event_pending - Check if an event is available
  *
-- 
2.13.6
