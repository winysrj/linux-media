Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19297 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab0BFSCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:21 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 7/8] V4L: Events: Sequence numbers
Date: Sat,  6 Feb 2010 20:02:10 +0200
Message-Id: <1265479331-20595-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |    6 ++++++
 include/media/v4l2-event.h       |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index b921229..7446b3d 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -108,6 +108,7 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
 	atomic_set(&fh->events->navailable, 0);
+	atomic_set(&fh->events->sequence, -1);
 
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
@@ -190,6 +191,7 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 	list_for_each_entry(fh, &vdev->fhs.list, list) {
 		struct v4l2_events *events = fh->events;
 		struct v4l2_kevent *kev;
+		u32 sequence;
 
 		/* Is it subscribed? */
 		if (!v4l2_event_subscribed(fh, ev->type))
@@ -209,6 +211,9 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		}
 		put_me = fh;
 
+		/* Increase event sequence number on fh. */
+		sequence = atomic_inc_return(&events->sequence);
+
 		/* Do we have any free events? */
 		spin_lock_irqsave(&fh->lock, flags);
 		if (list_empty(&events->free)) {
@@ -223,6 +228,7 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 		spin_unlock_irqrestore(&fh->lock, flags);
 
 		kev->event = *ev;
+		kev->event.sequence = sequence;
 
 		/* And add to the available list. */
 		spin_lock_irqsave(&fh->lock, flags);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 282d215..3db0c3b 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -49,6 +49,7 @@ struct v4l2_events {
 	struct list_head	available; /* Dequeueable event */
 	atomic_t                navailable;
 	struct list_head	free; /* Events ready for use */
+	atomic_t                sequence;
 };
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-- 
1.5.6.5

