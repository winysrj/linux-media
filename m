Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55760 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0BIS1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 13:27:08 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v3 5/7] V4L: Events: Count event queue length
Date: Tue,  9 Feb 2010 20:26:48 +0200
Message-Id: <1265740010-24144-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265740010-24144-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B71A8DF.8070907@maxwell.research.nokia.com>
 <1265740010-24144-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the count field properly by setting it to exactly to number of
further available events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   27 +++++++++++++++------------
 include/media/v4l2-event.h       |    6 +++++-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9f5be94..eeaba4c 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -36,6 +36,9 @@ int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 	for (; n > 0; n--) {
 		struct v4l2_kevent *kev;
 
+		if (atomic_read(&events->max_events) <= 0)
+			return -ENOMEM;
+
 		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
 		if (kev == NULL)
 			return -ENOMEM;
@@ -43,9 +46,10 @@ int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 		list_add_tail(&kev->list, &events->free);
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+		atomic_dec(&events->max_events);
 	}
 
-	return n;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_alloc);
 
@@ -73,7 +77,7 @@ void v4l2_event_exit(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_exit);
 
-int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
+int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_events)
 {
 	int ret;
 
@@ -87,6 +91,9 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->available);
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
+	atomic_set(&fh->events->navailable, 0);
+	atomic_set(&fh->events->max_events, max_events);
+
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
 		v4l2_event_exit(fh);
@@ -108,10 +115,12 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 		return -ENOENT;
 	}
 
+	BUG_ON(&events->navailable == 0);
+
 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
 	list_move(&kev->list, &events->free);
 
-	kev->event.count = !list_empty(&events->available);
+	kev->event.count = atomic_dec_return(&events->navailable);
 
 	*event = kev->event;
 
@@ -172,6 +181,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		kev->event = *ev;
 		list_move_tail(&kev->list, &events->available);
 
+		atomic_inc(&events->navailable);
+
 		wake_up_all(&events->wait);
 	}
 
@@ -181,15 +192,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
-	struct v4l2_events *events = fh->events;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	ret = !list_empty(&events->available);
-	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-
-	return ret;
+	return atomic_read(&fh->events->navailable);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 580c9d4..a9d0333 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -28,6 +28,8 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#include <asm/atomic.h>
+
 struct v4l2_fh;
 struct video_device;
 
@@ -45,11 +47,13 @@ struct v4l2_events {
 	wait_queue_head_t	wait;
 	struct list_head	subscribed; /* Subscribed events */
 	struct list_head	available; /* Dequeueable event */
+	atomic_t                navailable;
+	atomic_t		max_events; /* Never allocate more. */
 	struct list_head	free; /* Events ready for use */
 };
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-int v4l2_event_init(struct v4l2_fh *fh, unsigned int n);
+int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_alloc);
 void v4l2_event_exit(struct v4l2_fh *fh);
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event);
 struct v4l2_subscribed_event *v4l2_event_subscribed(
-- 
1.5.6.5

