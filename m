Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20054 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbeKHVWR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 16:22:17 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        stable@vger.kernel.org (for 4.14 and up)
Subject: [PATCH v4.4 1/1] v4l: event: Add subscription to list before calling "add" operation
Date: Thu,  8 Nov 2018 13:46:32 +0200
Message-Id: <20181108114632.17194-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]

Patch ad608fbcf166 changed how events were subscribed to address an issue
elsewhere. As a side effect of that change, the "add" callback was called
before the event subscription was added to the list of subscribed events,
causing the first event queued by the add callback (and possibly other
events arriving soon afterwards) to be lost.

Fix this by adding the subscription to the list before calling the "add"
callback, and clean up afterwards if that fails.

Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")

Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org (for 4.14 and up)
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-event.c | 43 ++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index b47ac4e053d0e..f5c8a952f0aa3 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -197,6 +197,22 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
+static void __v4l2_event_unsubscribe(struct v4l2_subscribed_event *sev)
+{
+	struct v4l2_fh *fh = sev->fh;
+	unsigned int i;
+
+	lockdep_assert_held(&fh->subscribe_lock);
+	assert_spin_locked(&fh->vdev->fh_lock);
+
+	/* Remove any pending events for this subscription */
+	for (i = 0; i < sev->in_use; i++) {
+		list_del(&sev->events[sev_pos(sev, i)].list);
+		fh->navailable--;
+	}
+	list_del(&sev->list);
+}
+
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 const struct v4l2_event_subscription *sub, unsigned elems,
 			 const struct v4l2_subscribed_event_ops *ops)
@@ -228,27 +244,23 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
+	if (!found_ev)
+		list_add(&sev->list, &fh->subscribed);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
 	if (found_ev) {
 		/* Already listening */
 		kfree(sev);
-		goto out_unlock;
-	}
-
-	if (sev->ops && sev->ops->add) {
+	} else if (sev->ops && sev->ops->add) {
 		ret = sev->ops->add(sev, elems);
 		if (ret) {
+			spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+			__v4l2_event_unsubscribe(sev);
+			spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 			kfree(sev);
-			goto out_unlock;
 		}
 	}
 
-	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	list_add(&sev->list, &fh->subscribed);
-	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-
-out_unlock:
 	mutex_unlock(&fh->subscribe_lock);
 
 	return ret;
@@ -283,7 +295,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 {
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
-	int i;
 
 	if (sub->type == V4L2_EVENT_ALL) {
 		v4l2_event_unsubscribe_all(fh);
@@ -295,14 +306,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
-	if (sev != NULL) {
-		/* Remove any pending events for this subscription */
-		for (i = 0; i < sev->in_use; i++) {
-			list_del(&sev->events[sev_pos(sev, i)].list);
-			fh->navailable--;
-		}
-		list_del(&sev->list);
-	}
+	if (sev != NULL)
+		__v4l2_event_unsubscribe(sev);
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
-- 
2.11.0
