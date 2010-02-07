Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52382 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab0BGSju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:39:50 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v2 6/7] V4L: Events: Sequence numbers
Date: Sun,  7 Feb 2010 20:40:46 +0200
Message-Id: <1265568047-31073-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6F0922.9070206@maxwell.research.nokia.com>
References: <4B6F0922.9070206@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   15 ++++++++++++---
 include/media/v4l2-event.h       |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index a95cde0..cd744d0 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -89,6 +89,7 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
 	INIT_LIST_HEAD(&fh->events->subscribed);
 
 	atomic_set(&fh->events->navailable, 0);
+	atomic_set(&fh->events->sequence, -1);
 
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
@@ -166,15 +167,23 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 	list_for_each_entry(fh, &vdev->fhs.list, list) {
 		struct v4l2_events *events = fh->events;
 		struct v4l2_kevent *kev;
+		u32 sequence;
 
-		/* Do we have any free events and are we subscribed? */
-		if (list_empty(&events->free) ||
-		    !__v4l2_event_subscribed(fh, ev->type))
+		/* Are we subscribed? */
+		if (!__v4l2_event_subscribed(fh, ev->type))
+			continue;
+
+		/* Increase event sequence number on fh. */
+		sequence = atomic_inc_return(&events->sequence);
+
+		/* Do we have any free events? */
+		if (list_empty(&events->free))
 			continue;
 
 		/* Take one and fill it. */
 		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
 		kev->event = *ev;
+		kev->event.sequence = sequence;
 		list_move_tail(&kev->list, &events->available);
 
 		atomic_inc(&events->navailable);
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

