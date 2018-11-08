Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:16073 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeKHVjj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 16:39:39 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        #@punajuuri.localdomain, for@punajuuri.localdomain,
        4.14@punajuuri.localdomain, and@punajuuri.localdomain,
        up@punajuuri.localdomain
Subject: [PATCH v3.16 1/2] v4l: event: Prevent freeing event subscriptions while accessed
Date: Thu,  8 Nov 2018 14:03:49 +0200
Message-Id: <20181108120350.17266-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ upstream commit ad608fbcf166fec809e402d548761768f602702c ]

The event subscriptions are added to the subscribed event list while
holding a spinlock, but that lock is subsequently released while still
accessing the subscription object. This makes it possible to unsubscribe
the event --- and freeing the subscription object's memory --- while
the subscription object is simultaneously accessed.

Prevent this by adding a mutex to serialise the event subscription and
unsubscription. This also gives a guarantee to the callback ops that the
add op has returned before the del op is called.

This change also results in making the elems field less special:
subscriptions are only added to the event list once they are fully
initialised.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # for 4.14 and up
Fixes: c3b5b0241f62 ("V4L/DVB: V4L: Events: Add backend")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-event.c | 38 +++++++++++++++++++-----------------
 drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
 include/media/v4l2-fh.h              |  1 +
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 8761aab99de95..fcf65f131a2ac 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -119,14 +119,6 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	if (sev == NULL)
 		return;
 
-	/*
-	 * If the event has been added to the fh->subscribed list, but its
-	 * add op has not completed yet elems will be 0, treat this as
-	 * not being subscribed.
-	 */
-	if (!sev->elems)
-		return;
-
 	/* Increase event sequence number on fh. */
 	fh->sequence++;
 
@@ -209,6 +201,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	struct v4l2_subscribed_event *sev, *found_ev;
 	unsigned long flags;
 	unsigned i;
+	int ret = 0;
 
 	if (sub->type == V4L2_EVENT_ALL)
 		return -EINVAL;
@@ -226,31 +219,36 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->ops = ops;
+	sev->elems = elems;
+
+	mutex_lock(&fh->subscribe_lock);
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
-	if (!found_ev)
-		list_add(&sev->list, &fh->subscribed);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
 	if (found_ev) {
+		/* Already listening */
 		kfree(sev);
-		return 0; /* Already listening */
+		goto out_unlock;
 	}
 
 	if (sev->ops && sev->ops->add) {
-		int ret = sev->ops->add(sev, elems);
+		ret = sev->ops->add(sev, elems);
 		if (ret) {
-			sev->ops = NULL;
-			v4l2_event_unsubscribe(fh, sub);
-			return ret;
+			kfree(sev);
+			goto out_unlock;
 		}
 	}
 
-	/* Mark as ready for use */
-	sev->elems = elems;
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	list_add(&sev->list, &fh->subscribed);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
-	return 0;
+out_unlock:
+	mutex_unlock(&fh->subscribe_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 
@@ -289,6 +287,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 		return 0;
 	}
 
+	mutex_lock(&fh->subscribe_lock);
+
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
@@ -306,6 +306,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	if (sev && sev->ops && sev->ops->del)
 		sev->ops->del(sev);
 
+	mutex_unlock(&fh->subscribe_lock);
+
 	kfree(sev);
 
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index e57c002b41506..573ec2f192d44 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -42,6 +42,7 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	INIT_LIST_HEAD(&fh->available);
 	INIT_LIST_HEAD(&fh->subscribed);
 	fh->sequence = -1;
+	mutex_init(&fh->subscribe_lock);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
 
@@ -88,6 +89,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 	if (fh->vdev == NULL)
 		return;
 	v4l2_event_unsubscribe_all(fh);
+	mutex_destroy(&fh->subscribe_lock);
 	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 803516775162d..a2777a324e083 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -41,6 +41,7 @@ struct v4l2_fh {
 
 	/* Events */
 	wait_queue_head_t	wait;
+	struct mutex		subscribe_lock;
 	struct list_head	subscribed; /* Subscribed events */
 	struct list_head	available; /* Dequeueable event */
 	unsigned int		navailable;
-- 
2.11.0
