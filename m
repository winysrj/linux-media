Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35675 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3JBNot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 09:44:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are subscribed
Date: Wed,  2 Oct 2013 16:45:16 +0300
Message-Id: <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dequeueing events was is entirely possible even if none are subscribed,
leading to sleeping indefinitely. Fix this by returning -ENOENT when no
events are subscribed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-event.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index b53897e..553a800 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -77,10 +77,17 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		mutex_unlock(fh->vdev->lock);
 
 	do {
-		ret = wait_event_interruptible(fh->wait,
-					       fh->navailable != 0);
+		bool subscribed;
+		ret = wait_event_interruptible(
+			fh->wait,
+			fh->navailable != 0 ||
+			!(subscribed = v4l2_event_has_subscribed(fh)));
 		if (ret < 0)
 			break;
+		if (!subscribed) {
+			ret = -EIO;
+			break;
+		}
 
 		ret = __v4l2_event_dequeue(fh, event);
 	} while (ret == -ENOENT);
-- 
1.8.3.2

