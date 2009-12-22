Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49210 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZLVQnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 11:43:43 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, iivanov@mm-sol.com,
	hverkuil@xs4all.nl, gururaj.nagendra@intel.com
Subject: [RFC v2 5/7] V4L: Events: Limit event queue length
Date: Tue, 22 Dec 2009 18:43:09 +0200
Message-Id: <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B30F713.8070004@maxwell.research.nokia.com>
 <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limit event queue length to V4L2_MAX_EVENTS. If the queue is full any
further events will be dropped.

This patch also updates the count field properly, setting it to exactly to
number of further available events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   10 +++++++++-
 include/media/v4l2-event.h       |    5 +++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9fc0c81..72fdf7f 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -56,6 +56,8 @@ void v4l2_event_init_fh(struct v4l2_fh *fh)
 
 	INIT_LIST_HEAD(&events->available);
 	INIT_LIST_HEAD(&events->subscribed);
+
+	atomic_set(&events->navailable, 0);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_init_fh);
 
@@ -103,7 +105,8 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 	ev = list_first_entry(&events->available, struct _v4l2_event, list);
 	list_del(&ev->list);
 
-	ev->event.count = !list_empty(&events->available);
+	atomic_dec(&events->navailable);
+	ev->event.count = atomic_read(&events->navailable);
 
 	spin_unlock_irqrestore(&events->lock, flags);
 
@@ -159,6 +162,9 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		if (!v4l2_event_subscribed(fh, ev->type))
 			continue;
 
+		if (atomic_read(&fh->events.navailable) >= V4L2_MAX_EVENTS)
+			continue;
+
 		_ev = kmem_cache_alloc(event_kmem, GFP_ATOMIC);
 		if (!_ev)
 			continue;
@@ -169,6 +175,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		list_add_tail(&_ev->list, &fh->events.available);
 		spin_unlock(&fh->events.lock);
 
+		atomic_inc(&fh->events.navailable);
+
 		wake_up_all(&fh->events.wait);
 	}
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index b11de92..69305c6 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -28,6 +28,10 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#include <asm/atomic.h>
+
+#define V4L2_MAX_EVENTS		1024 /* Ought to be enough for everyone. */
+
 struct v4l2_fh;
 struct video_device;
 
@@ -39,6 +43,7 @@ struct _v4l2_event {
 struct v4l2_events {
 	spinlock_t		lock; /* Protect everything here. */
 	struct list_head	available;
+	atomic_t		navailable;
 	wait_queue_head_t	wait;
 	struct list_head	subscribed; /* Subscribed events. */
 };
-- 
1.5.6.5

