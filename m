Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41855 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab0BGSjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:39:55 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v2 5/7] V4L: Events: Count event queue length
Date: Sun,  7 Feb 2010 20:40:45 +0200
Message-Id: <1265568047-31073-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6F0922.9070206@maxwell.research.nokia.com>
References: <4B6F0922.9070206@maxwell.research.nokia.com>
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
index 6d57324..a95cde0 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -88,6 +88,8 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->available);
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
+	atomic_set(&fh->events->navailable, 0);
+
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
 		v4l2_event_exit(fh);
@@ -109,10 +111,12 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 		return -ENOENT;
 	}
 
+	BUG_ON(&events->navailable == 0);
+
 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
 	list_move(&kev->list, &events->free);
 
-	kev->event.count = !list_empty(&events->available);
+	kev->event.count = atomic_dec_return(&events->navailable);
 
 	*event = kev->event;
 
@@ -173,6 +177,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		kev->event = *ev;
 		list_move_tail(&kev->list, &events->available);
 
+		atomic_inc(&events->navailable);
+
 		wake_up_all(&events->wait);
 	}
 
@@ -182,15 +188,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
 int v4l2_event_pending(struct v4l2_fh *fh)
 {
-	struct v4l2_events *events = fh->events;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&fh->vdev->fhs.lock, flags);
-	ret = !list_empty(&events->available);
-	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
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

