Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25181 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab0BFSC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:26 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 6/8] V4L: Events: Count event queue length
Date: Sat,  6 Feb 2010 20:02:09 +0200
Message-Id: <1265479331-20595-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the count field properly by setting it to exactly to number of
further available events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   18 ++++++++----------
 include/media/v4l2-event.h       |    3 +++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 7ae763f..b921229 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -107,6 +107,8 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->available);
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
+	atomic_set(&fh->events->navailable, 0);
+
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
 		v4l2_event_exit(fh);
@@ -128,10 +130,12 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 		return -ENOENT;
 	}
 
+	BUG_ON(&events->navailable == 0);
+
 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
 	list_del(&kev->list);
 
-	kev->event.count = !list_empty(&events->available);
+	kev->event.count = atomic_dec_return(&events->navailable);
 
 	spin_unlock_irqrestore(&fh->lock, flags);
 
@@ -225,6 +229,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		list_add_tail(&kev->list, &events->available);
 		spin_unlock_irqrestore(&fh->lock, flags);
 
+		atomic_inc(&events->navailable);
+
 		wake_up_all(&events->wait);
 
 		spin_lock_irqsave(&vdev->fhs.lock, flags);
@@ -240,15 +246,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
-	struct v4l2_events *events = fh->events;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&fh->lock, flags);
-	ret = !list_empty(&events->available);
-	spin_unlock_irqrestore(&fh->lock, flags);
-
-	return ret;
+	return atomic_read(&fh->events->navailable);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 580c9d4..282d215 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -28,6 +28,8 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#include <asm/atomic.h>
+
 struct v4l2_fh;
 struct video_device;
 
@@ -45,6 +47,7 @@ struct v4l2_events {
 	wait_queue_head_t	wait;
 	struct list_head	subscribed; /* Subscribed events */
 	struct list_head	available; /* Dequeueable event */
+	atomic_t                navailable;
 	struct list_head	free; /* Events ready for use */
 };
 
-- 
1.5.6.5

