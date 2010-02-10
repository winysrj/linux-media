Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:43893 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0BJO6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 09:58:33 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: [PATCH v4 3/7] V4L: Events: Add backend
Date: Wed, 10 Feb 2010 16:58:05 +0200
Message-Id: <1265813889-17847-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B72C965.7040204@maxwell.research.nokia.com>
 <1265813889-17847-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1265813889-17847-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add event handling backend to V4L2. The backend handles event subscription
and delivery to file handles. Event subscriptions are based on file handle.
Events may be delivered to all subscribed file handles on a device
independent of where they originate from.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |  261 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-fh.c    |    4 +
 include/media/v4l2-event.h       |   64 +++++++++
 include/media/v4l2-fh.h          |    2 +
 4 files changed, 331 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/v4l2-event.c
 create mode 100644 include/media/v4l2-event.h

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
new file mode 100644
index 0000000..d13c1e9
--- /dev/null
+++ b/drivers/media/video/v4l2-event.c
@@ -0,0 +1,261 @@
+/*
+ * drivers/media/video/v4l2-event.c
+ *
+ * V4L2 events.
+ *
+ * Copyright (C) 2009 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-event.h>
+
+#include <linux/sched.h>
+
+/* In error case, return number of events *not* allocated. */
+int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
+{
+	struct v4l2_events *events = fh->events;
+	unsigned long flags;
+
+	for (; n > 0; n--) {
+		struct v4l2_kevent *kev;
+
+		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
+		if (kev == NULL)
+			return -ENOMEM;
+
+		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+		list_add_tail(&kev->list, &events->free);
+		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_alloc);
+
+#define list_kfree(list, type, member)				\
+	while (!list_empty(list)) {				\
+		type *hi;					\
+		hi = list_first_entry(list, type, member);	\
+		list_del(&hi->member);				\
+		kfree(hi);					\
+	}
+
+void v4l2_event_exit(struct v4l2_fh *fh)
+{
+	struct v4l2_events *events = fh->events;
+
+	if (!events)
+		return;
+
+	list_kfree(&events->free, struct v4l2_kevent, list);
+	list_kfree(&events->available, struct v4l2_kevent, list);
+	list_kfree(&events->subscribed, struct v4l2_subscribed_event, list);
+
+	kfree(events);
+	fh->events = NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_exit);
+
+int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
+{
+	int ret;
+
+	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
+	if (fh->events == NULL)
+		return -ENOMEM;
+
+	init_waitqueue_head(&fh->events->wait);
+
+	INIT_LIST_HEAD(&fh->events->free);
+	INIT_LIST_HEAD(&fh->events->available);
+	INIT_LIST_HEAD(&fh->events->subscribed);
+
+	ret = v4l2_event_alloc(fh, n);
+	if (ret < 0)
+		v4l2_event_exit(fh);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_init);
+
+int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_kevent *kev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	if (list_empty(&events->available)) {
+		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+		return -ENOENT;
+	}
+
+	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
+	list_move(&kev->list, &events->free);
+
+	kev->event.count = !list_empty(&events->available);
+
+	*event = kev->event;
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
+
+static struct v4l2_subscribed_event *__v4l2_event_subscribed(
+	struct v4l2_fh *fh, u32 type)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_subscribed_event *sev;
+
+	list_for_each_entry(sev, &events->subscribed, list) {
+		if (sev->type == type)
+			return sev;
+	}
+
+	return NULL;
+}
+
+struct v4l2_subscribed_event *v4l2_event_subscribed(
+	struct v4l2_fh *fh, u32 type)
+{
+	struct v4l2_subscribed_event *sev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	sev = __v4l2_event_subscribed(fh, type);
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return sev;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribed);
+
+void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
+{
+	struct v4l2_fh *fh;
+	unsigned long flags;
+
+	if (!ev->timestamp.tv_sec && !ev->timestamp.tv_nsec)
+		ktime_get_ts(&ev->timestamp);
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+
+	list_for_each_entry(fh, &vdev->fh_list, list) {
+		struct v4l2_events *events = fh->events;
+		struct v4l2_kevent *kev;
+
+		/* Do we have any free events and are we subscribed? */
+		if (list_empty(&events->free) ||
+		    !__v4l2_event_subscribed(fh, ev->type))
+			continue;
+
+		/* Take one and fill it. */
+		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
+		kev->event = *ev;
+		list_move_tail(&kev->list, &events->available);
+
+		wake_up_all(&events->wait);
+	}
+
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_queue);
+
+int v4l2_event_pending(struct v4l2_fh *fh)
+{
+	struct v4l2_events *events = fh->events;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	ret = !list_empty(&events->available);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_pending);
+
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_subscribed_event *sev;
+	unsigned long flags;
+	int ret = 0;
+
+	/* Allow subscribing to valid events only. */
+	if (sub->type < V4L2_EVENT_PRIVATE_START)
+		switch (sub->type) {
+		default:
+			return -EINVAL;
+		}
+
+	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
+	if (!sev)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	if (__v4l2_event_subscribed(fh, sub->type) != NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&sev->list);
+	sev->type = sub->type;
+
+	list_add(&sev->list, &events->subscribed);
+
+out:
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	if (ret)
+		kfree(sev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
+
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub)
+{
+	struct v4l2_subscribed_event *sev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	sev = __v4l2_event_subscribed(fh, sub->type);
+
+	if (sev == NULL) {
+		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+		return -EINVAL;
+	}
+
+	list_del(&sev->list);
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 3c1cea2..7c13f5b 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -24,6 +24,7 @@
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
@@ -54,6 +55,9 @@ EXPORT_SYMBOL_GPL(v4l2_fh_del);
 void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	BUG_ON(fh->vdev == NULL);
+
+	v4l2_event_exit(fh);
+
 	fh->vdev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
new file mode 100644
index 0000000..580c9d4
--- /dev/null
+++ b/include/media/v4l2-event.h
@@ -0,0 +1,64 @@
+/*
+ * include/media/v4l2-event.h
+ *
+ * V4L2 events.
+ *
+ * Copyright (C) 2009 Nokia Corporation.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef V4L2_EVENT_H
+#define V4L2_EVENT_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+struct v4l2_fh;
+struct video_device;
+
+struct v4l2_kevent {
+	struct list_head	list;
+	struct v4l2_event	event;
+};
+
+struct v4l2_subscribed_event {
+	struct list_head	list;
+	u32			type;
+};
+
+struct v4l2_events {
+	wait_queue_head_t	wait;
+	struct list_head	subscribed; /* Subscribed events */
+	struct list_head	available; /* Dequeueable event */
+	struct list_head	free; /* Events ready for use */
+};
+
+int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
+int v4l2_event_init(struct v4l2_fh *fh, unsigned int n);
+void v4l2_event_exit(struct v4l2_fh *fh);
+int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event);
+struct v4l2_subscribed_event *v4l2_event_subscribed(
+	struct v4l2_fh *fh, u32 type);
+void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev);
+int v4l2_event_pending(struct v4l2_fh *fh);
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub);
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub);
+
+#endif /* V4L2_EVENT_H */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 2e88031..6d03a1e 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -31,10 +31,12 @@
 #include <asm/atomic.h>
 
 struct video_device;
+struct v4l2_events;
 
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
+	struct v4l2_events      *events; /* events, pending and subscribed */
 };
 
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
-- 
1.5.6.5

