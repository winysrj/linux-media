Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49195 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZLVQnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 11:43:31 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, iivanov@mm-sol.com,
	hverkuil@xs4all.nl, gururaj.nagendra@intel.com
Subject: [RFC v2 7/7] V4L: Events: Support all events
Date: Tue, 22 Dec 2009 18:43:11 +0200
Message-Id: <1261500191-9441-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1261500191-9441-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B30F713.8070004@maxwell.research.nokia.com>
 <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for subscribing V4L2_EVENT_ALL. After V4L2_EVENT_ALL is
subscribed, unsubscribing any event leads to unsubscription of all events.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index cc2bf57..95b3917 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -62,6 +62,22 @@ void v4l2_event_init_fh(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_init_fh);
 
+static void __v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
+{
+	struct v4l2_events *events = &fh->events;
+
+	while (!list_empty(&events->subscribed)) {
+		struct v4l2_subscribed_event *sub;
+
+		sub = list_entry(events->subscribed.next,
+				struct v4l2_subscribed_event, list);
+
+		list_del(&sub->list);
+
+		kfree(sub);
+	}
+}
+
 void v4l2_event_exit_fh(struct v4l2_fh *fh)
 {
 	struct v4l2_events *events = &fh->events;
@@ -77,16 +93,7 @@ void v4l2_event_exit_fh(struct v4l2_fh *fh)
 		kmem_cache_free(event_kmem, ev);
 	}
 
-	while (!list_empty(&events->subscribed)) {
-		struct v4l2_subscribed_event *sub;
-
-		sub = list_entry(events->subscribed.next,
-				struct v4l2_subscribed_event, list);
-
-		list_del(&sub->list);
-
-		kfree(sub);
-	}
+	__v4l2_event_unsubscribe_all(fh);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_exit_fh);
 
@@ -125,6 +132,11 @@ static struct v4l2_subscribed_event *__v4l2_event_subscribed(
 	struct v4l2_events *events = &fh->events;
 	struct v4l2_subscribed_event *ev;
 
+	ev = container_of(events->subscribed.next,
+			  struct v4l2_subscribed_event, list);
+	if (ev->type == V4L2_EVENT_ALL)
+		return ev;
+
 	list_for_each_entry(ev, &events->subscribed, list) {
 		if (ev->type == type)
 			return ev;
@@ -237,6 +249,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	INIT_LIST_HEAD(&ev->list);
 	ev->type = sub->type;
 
+	if (ev->type == V4L2_EVENT_ALL)
+		__v4l2_event_unsubscribe_all(fh);
 	list_add(&ev->list, &events->subscribed);
 
 out:
-- 
1.5.6.5

