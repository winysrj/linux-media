Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:43888 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0BJO6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 09:58:30 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v4 6/7] V4L: Events: Sequence numbers
Date: Wed, 10 Feb 2010 16:58:08 +0200
Message-Id: <1265813889-17847-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B72C965.7040204@maxwell.research.nokia.com>
 <1265813889-17847-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add sequence numbers to events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   16 +++++++++++++---
 include/media/v4l2-event.h       |    1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index bbdc149..0af0de5 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -95,6 +95,7 @@ int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_alloc)
 
 	fh->events->navailable = 0;
 	fh->events->max_alloc = max_alloc;
+	fh->events->sequence = -1;
 
 	ret = v4l2_event_alloc(fh, n);
 	if (ret < 0)
@@ -175,15 +176,24 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
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
+		events->sequence++;
+		sequence = events->sequence;
+
+		/* Do we have any free events? */
+		if (list_empty(&events->free))
 			continue;
 
 		/* Take one and fill it. */
 		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
 		kev->event = *ev;
+		kev->event.sequence = sequence;
 		list_move_tail(&kev->list, &events->available);
 
 		events->navailable++;
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 671c8f7..5760597 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -50,6 +50,7 @@ struct v4l2_events {
 	unsigned int		navailable;
 	unsigned int		max_alloc; /* Never allocate more. */
 	struct list_head	free; /* Events ready for use */
+	u32			sequence;
 };
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
-- 
1.5.6.5

