Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25163 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0BFSCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:22 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 8/8] V4L: Events: Support all events
Date: Sat,  6 Feb 2010 20:02:11 +0200
Message-Id: <1265479331-20595-8-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for subscribing all events with a special id V4L2_EVENT_ALL. If
V4L2_EVENT_ALL is subscribed, no other events may be subscribed. Otherwise
V4L2_EVENT_ALL is considered just as any other event.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   13 ++++++++++++-
 include/linux/videodev2.h        |    1 +
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 7446b3d..685edd6 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -156,6 +156,14 @@ static struct v4l2_subscribed_event *__v4l2_kevent_subscribed(
 	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
 
+	if (list_empty(&events->subscribed))
+		return NULL;
+
+	sev = list_entry(events->subscribed.next,
+			 struct v4l2_subscribed_event, list);
+	if (sev->type == V4L2_EVENT_ALL)
+		return sev;
+
 	list_for_each_entry(sev, &events->subscribed, list) {
 		if (sev->type == type)
 			return sev;
@@ -267,6 +275,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	/* Allow subscribing to valid events only. */
 	if (sub->type < V4L2_EVENT_PRIVATE_START)
 		switch (sub->type) {
+		case V4L2_EVENT_ALL:
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -307,7 +317,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	sev = __v4l2_kevent_subscribed(fh, sub->type);
 
-	if (sev == NULL) {
+	if (sev == NULL ||
+	    (sub->type != V4L2_EVENT_ALL && sev->type == V4L2_EVENT_ALL)) {
 		spin_unlock_irqrestore(&fh->lock, flags);
 		return -EINVAL;
 	}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a19ae89..9ae9a1c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1553,6 +1553,7 @@ struct v4l2_event_subscription {
 	__u32		reserved[7];
 };
 
+#define V4L2_EVENT_ALL				0
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /*
-- 
1.5.6.5

