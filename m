Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43196 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0BJO7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 09:59:08 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v4 5/7] V4L: Events: Count event queue length
Date: Wed, 10 Feb 2010 16:58:07 +0200
Message-Id: <1265813889-17847-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B72C965.7040204@maxwell.research.nokia.com>
 <1265813889-17847-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the count field properly by setting it to exactly to number of
further available events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   29 +++++++++++++++++------------
 include/media/v4l2-event.h       |    6 +++++-
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index d13c1e9..bbdc149 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -41,7 +41,13 @@ int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 			return -ENOMEM;
 
 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+		if (events->max_alloc == 0) {
+			spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+			kfree(kev);
+			return -ENOMEM;
+		}
 		list_add_tail(&kev->list, &events->free);
+		events->max_alloc--;
 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 	}
 
@@ -73,7 +79,7 @@ void v4l2_event_exit(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_exit);
 
-int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
+int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_alloc)
 {
 	int ret;
 
@@ -87,6 +93,9 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->available);
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
+	fh->events->navailable = 0;
+	fh->events->max_alloc = max_alloc;
+
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
 		v4l2_event_exit(fh);
@@ -108,11 +117,13 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 		return -ENOENT;
 	}
 
+	WARN_ON(&events->navailable == 0);
+
 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
 	list_move(&kev->list, &events->free);
+	events->navailable--;
 
-	kev->event.count = !list_empty(&events->available);
-
+	kev->event.count = events->navailable;
 	*event = kev->event;
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
@@ -175,6 +186,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		kev->event = *ev;
 		list_move_tail(&kev->list, &events->available);
 
+		events->navailable++;
+
 		wake_up_all(&events->wait);
 	}
 
@@ -184,15 +197,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 
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
+	return fh->events->navailable;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 580c9d4..671c8f7 100644
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
+	unsigned int		navailable;
+	unsigned int		max_alloc; /* Never allocate more. */
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

