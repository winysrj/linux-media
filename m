Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44860 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387572AbeKFBG4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 20:06:56 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: dave.stevenson@raspberrypi.org
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: event: Add subscription to list before calling "add" operation
Date: Mon,  5 Nov 2018 17:46:35 +0200
Message-Id: <20181105154635.10157-1-sakari.ailus@linux.intel.com>
In-Reply-To: <CAAoAYcOp+sxOkjDkXJDt8FCYXZqE2EgnDikF1M5PqvjnmQUq+Q@mail.gmail.com>
References: <CAAoAYcOp+sxOkjDkXJDt8FCYXZqE2EgnDikF1M5PqvjnmQUq+Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch ad608fbcf166 changed how events were subscribed to address an issue
elsewhere. As a side effect of that change, the "add" callback was called
before the event subscription was added to the list of subscribed events,
causing the first event (and possibly other events arriving soon
afterwards) to be lost.

Fix this by adding the subscription to the list before calling the "add"
callback, and clean up afterwards if that fails.

Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")

Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Dave, Hans,

This should address the issue.

The functions can (and probably should) be re-arranged later but let's get
the fix right first.

I haven't tested this using vivid yet as it crashes where I was testing
it. I'll see later if it works elsewhere but I'm sending the patch for
review in the meantime.

 drivers/media/v4l2-core/v4l2-event.c | 39 +++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index a3ef1f50a4b3..2b6651aeb89b 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -193,6 +193,22 @@ int v4l2_event_pending(struct v4l2_fh *fh)
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
@@ -232,18 +248,20 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		goto out_unlock;
 	}
 
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	list_add(&sev->list, &fh->subscribed);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
 	if (sev->ops && sev->ops->add) {
 		ret = sev->ops->add(sev, elems);
 		if (ret) {
+			spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+			__v4l2_event_unsubscribe(sev);
+			spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 			kvfree(sev);
-			goto out_unlock;
 		}
 	}
 
-	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	list_add(&sev->list, &fh->subscribed);
-	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-
 out_unlock:
 	mutex_unlock(&fh->subscribe_lock);
 
@@ -279,7 +297,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 {
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
-	int i;
 
 	if (sub->type == V4L2_EVENT_ALL) {
 		v4l2_event_unsubscribe_all(fh);
@@ -291,14 +308,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
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
