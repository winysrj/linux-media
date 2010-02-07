Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52395 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab0BGSj5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:39:57 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v2 7/7] V4L: Events: Support all events
Date: Sun,  7 Feb 2010 20:40:47 +0200
Message-Id: <1265568047-31073-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6F0922.9070206@maxwell.research.nokia.com>
References: <4B6F0922.9070206@maxwell.research.nokia.com>
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
index cd744d0..131bab7 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -133,6 +133,14 @@ static struct v4l2_subscribed_event *__v4l2_event_subscribed(
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
@@ -212,6 +220,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	/* Allow subscribing to valid events only. */
 	if (sub->type < V4L2_EVENT_PRIVATE_START)
 		switch (sub->type) {
+		case V4L2_EVENT_ALL:
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -252,7 +262,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	sev = __v4l2_event_subscribed(fh, sub->type);
 
-	if (sev == NULL) {
+	if (sev == NULL ||
+	    (sub->type != V4L2_EVENT_ALL && sev->type == V4L2_EVENT_ALL)) {
 		spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
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

