Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55754 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0BIS1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 13:27:07 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v3 6/7] V4L: Events: Sequence numbers
Date: Tue,  9 Feb 2010 20:26:49 +0200
Message-Id: <1265740010-24144-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265740010-24144-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B71A8DF.8070907@maxwell.research.nokia.com>
 <1265740010-24144-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265740010-24144-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   15 ++++++++++++---
 include/media/v4l2-event.h       |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index eeaba4c..3a4065a 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -93,6 +93,7 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_events)
 
 	atomic_set(&fh->events->navailable, 0);
 	atomic_set(&fh->events->max_events, max_events);
+	atomic_set(&fh->events->sequence, -1);
 
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
@@ -170,15 +171,23 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
 	list_for_each_entry(fh, &vdev->fh_list, list) {
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
index a9d0333..3b69582 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -50,6 +50,7 @@ struct v4l2_events {
 	atomic_t                navailable;
 	atomic_t		max_events; /* Never allocate more. */
 	struct list_head	free; /* Events ready for use */
+	atomic_t                sequence;
 };
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-- 
1.5.6.5

