Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/11] [media] v4l2-event.h: document all functions
Date: Fri, 22 Jul 2016 12:02:59 -0300
Message-Id: <84f5599956c7055e4fcb1df8fc48158a15f5b800.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several functions weren't documented. Document them all.

While here, makes checkpatch.pl happy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-event.h | 125 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 113 insertions(+), 12 deletions(-)

diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 9792f906423b..ca854203b8b9 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -73,14 +73,15 @@ struct video_device;
  * @list:	List node for the v4l2_fh->available list.
  * @sev:	Pointer to parent v4l2_subscribed_event.
  * @event:	The event itself.
-  */
+ */
 struct v4l2_kevent {
 	struct list_head	list;
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_event	event;
 };
 
-/** struct v4l2_subscribed_event_ops - Subscribed event operations.
+/**
+ * struct v4l2_subscribed_event_ops - Subscribed event operations.
  *
  * @add:	Optional callback, called when a new listener is added
  * @del:	Optional callback, called when a listener stops listening
@@ -88,20 +89,23 @@ struct v4l2_kevent {
  * @merge:	Optional callback that can merge event 'old' into event 'new'.
  */
 struct v4l2_subscribed_event_ops {
-	int  (*add)(struct v4l2_subscribed_event *sev, unsigned elems);
+	int  (*add)(struct v4l2_subscribed_event *sev, unsigned int elems);
 	void (*del)(struct v4l2_subscribed_event *sev);
 	void (*replace)(struct v4l2_event *old, const struct v4l2_event *new);
 	void (*merge)(const struct v4l2_event *old, struct v4l2_event *new);
 };
 
 /**
- * struct v4l2_subscribed_event - Internal struct representing a subscribed event.
+ * struct v4l2_subscribed_event - Internal struct representing a subscribed
+ *		event.
+ *
  * @list:	List node for the v4l2_fh->subscribed list.
  * @type:	Event type.
  * @id:	Associated object ID (e.g. control ID). 0 if there isn't any.
  * @flags:	Copy of v4l2_event_subscription->flags.
  * @fh:	Filehandle that subscribed to this event.
- * @node:	List node that hooks into the object's event list (if there is one).
+ * @node:	List node that hooks into the object's event list
+ *		(if there is one).
  * @ops:	v4l2_subscribed_event_ops
  * @elems:	The number of elements in the events array.
  * @first:	The index of the events containing the oldest available event.
@@ -116,27 +120,124 @@ struct v4l2_subscribed_event {
 	struct v4l2_fh		*fh;
 	struct list_head	node;
 	const struct v4l2_subscribed_event_ops *ops;
-	unsigned		elems;
-	unsigned		first;
-	unsigned		in_use;
+	unsigned int		elems;
+	unsigned int		first;
+	unsigned int		in_use;
 	struct v4l2_kevent	events[];
 };
 
+/**
+ * v4l2_event_dequeue - Dequeue events from video device.
+ *
+ * @fh: pointer to struct v4l2_fh
+ * @event: pointer to struct v4l2_event
+ * @nonblocking: if not zero, waits for an event to arrive
+ */
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
+
+/**
+ * v4l2_event_queue - Queue events to video device.
+ *
+ * @vdev: pointer to &struct video_device
+ * @ev: pointer to &struct v4l2_event
+ *
+ * The event will be queued for all &struct v4l2_fh file handlers.
+ *
+ * .. note::
+ *    The driver's only responsibility is to fill in the type and the data
+ *    fields.The other fields will be filled in by  V4L2.
+ */
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
+
+/**
+ * v4l2_event_queue_fh - Queue events to video device.
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @ev: pointer to &struct v4l2_event
+ *
+ *
+ * The event will be queued only for the specified &struct v4l2_fh file handler.
+ *
+ * .. note::
+ *    The driver's only responsibility is to fill in the type and the data
+ *    fields.The other fields will be filled in by  V4L2.
+ */
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
+
+/**
+ * v4l2_event_pending - Check if an event is available
+ *
+ * @fh: pointer to &struct v4l2_fh
+ *
+ * Returns the number of pending events.
+ */
 int v4l2_event_pending(struct v4l2_fh *fh);
+
+/**
+ * v4l2_event_subscribe - Subscribes to an event
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ * @elems: size of the events queue
+ * @ops: pointer to &v4l2_subscribed_event_ops
+ *
+ * .. note::
+ *
+ *    if @elems is zero, the framework will fill in a default value,
+ *    with is currently 1 element.
+ */
 int v4l2_event_subscribe(struct v4l2_fh *fh,
-			 const struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_event_subscription *sub,
+			 unsigned int elems,
 			 const struct v4l2_subscribed_event_ops *ops);
+/**
+ * v4l2_event_unsubscribe - Unsubscribes to an event
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ */
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   const struct v4l2_event_subscription *sub);
+/**
+ * v4l2_event_unsubscribe_all - Unsubscribes to all events
+ *
+ * @fh: pointer to &struct v4l2_fh
+ */
 void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
-int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+
+/**
+ * v4l2_event_subdev_unsubscribe - Subdev variant of v4l2_event_unsubscribe()
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @fh: pointer to &struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ *
+ * .. note::
+ *
+ *	This function should be used for the &struct v4l2_subdev_core_ops
+ *	%unsubscribe_event field.
+ */
+int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd,
+				  struct v4l2_fh *fh,
 				  struct v4l2_event_subscription *sub);
+/**
+ * v4l2_src_change_event_subscribe -
+ *
+ * @fh: pointer to struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ */
 int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
-				const struct v4l2_event_subscription *sub);
+				    const struct v4l2_event_subscription *sub);
+/**
+ * v4l2_src_change_event_subdev_subscribe - Variant of v4l2_event_subscribe(),
+ *	meant to subscribe only events of the type %V4L2_EVENT_SOURCE_CHANGE.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @fh: pointer to &struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ */
 int v4l2_src_change_event_subdev_subscribe(struct v4l2_subdev *sd,
-		struct v4l2_fh *fh, struct v4l2_event_subscription *sub);
+					   struct v4l2_fh *fh,
+					   struct v4l2_event_subscription *sub);
 #endif /* V4L2_EVENT_H */
-- 
2.7.4

