Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34156 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726624AbeILN4H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 09:56:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] v4l: event: Prevent freeing event subscriptions while accessed
Date: Wed, 12 Sep 2018 11:52:32 +0300
Message-Id: <20180912085232.26950-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
---
Hi folks,

I noticed this while working to add support for media events. This seems
like material for the stable trees.

 drivers/media/v4l2-core/v4l2-event.c | 35 ++++++++++++++++++-----------------
 drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
 include/media/v4l2-fh.h              |  4 ++++
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 127fe6eb91d9..74161f79e4d3 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -115,14 +115,6 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
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
 
@@ -208,6 +200,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	struct v4l2_subscribed_event *sev, *found_ev;
 	unsigned long flags;
 	unsigned i;
+	int ret = 0;
 
 	if (sub->type == V4L2_EVENT_ALL)
 		return -EINVAL;
@@ -225,31 +218,35 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->ops = ops;
+	sev->elems = elems;
+
+	mutex_lock(&fh->mutex);
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
-	if (!found_ev)
-		list_add(&sev->list, &fh->subscribed);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 
 	if (found_ev) {
+		/* Already listening */
 		kvfree(sev);
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
+			kvfree(sev);
+			goto out_unlock;
 		}
 	}
 
 	/* Mark as ready for use */
-	sev->elems = elems;
+	list_add(&sev->list, &fh->subscribed);
 
-	return 0;
+out_unlock:
+	mutex_unlock(&fh->mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
 
@@ -288,6 +285,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 		return 0;
 	}
 
+	mutex_lock(&fh->mutex);
+
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
@@ -305,6 +304,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	if (sev && sev->ops && sev->ops->del)
 		sev->ops->del(sev);
 
+	mutex_unlock(&fh->mutex);
+
 	kvfree(sev);
 
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index 3895999bf880..b017dafde907 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -45,6 +45,7 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	INIT_LIST_HEAD(&fh->available);
 	INIT_LIST_HEAD(&fh->subscribed);
 	fh->sequence = -1;
+	mutex_init(&fh->mutex);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
 
@@ -90,6 +91,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 		return;
 	v4l_disable_media_source(fh->vdev);
 	v4l2_event_unsubscribe_all(fh);
+	mutex_destroy(&fh->mutex);
 	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index ea73fef8bdc0..1be45a5f6383 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -42,6 +42,9 @@ struct v4l2_ctrl_handler;
  * @available: list of events waiting to be dequeued
  * @navailable: number of available events at @available list
  * @sequence: event sequence number
+ * @mutex: hold event subscriptions during subscribing;
+ *	   guarantee that the add and del event callbacks are orderly called
+ *
  * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
  */
 struct v4l2_fh {
@@ -56,6 +59,7 @@ struct v4l2_fh {
 	struct list_head	available;
 	unsigned int		navailable;
 	u32			sequence;
+	struct mutex		mutex;
 
 #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
 	struct v4l2_m2m_ctx	*m2m_ctx;
-- 
2.11.0
