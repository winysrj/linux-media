Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18258 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab0BSTWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:22:13 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH v5 4/6] V4L: Events: Add backend
Date: Fri, 19 Feb 2010 21:21:58 +0200
Message-Id: <1266607320-9974-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B7EE4A4.3080202@maxwell.research.nokia.com>
References: <4B7EE4A4.3080202@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add event handling backend to V4L2. The backend handles event subscription
and delivery to file handles. Event subscriptions are based on file handle.
Events may be delivered to all subscribed file handles on a device
independent of where they originate from.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile     |    3 +-
 drivers/media/video/v4l2-event.c |  286 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-fh.c    |    4 +
 include/media/v4l2-event.h       |   65 +++++++++
 include/media/v4l2-fh.h          |    2 +
 5 files changed, 359 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/v4l2-event.c
 create mode 100644 include/media/v4l2-event.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 14bf69a..b84abfe 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,8 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
+			v4l2-event.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
new file mode 100644
index 0000000..ab31cc6
--- /dev/null
+++ b/drivers/media/video/v4l2-event.c
@@ -0,0 +1,286 @@
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
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+
+#include <linux/sched.h>
+
+static int v4l2_event_init(struct v4l2_fh *fh)
+{
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
+	fh->events->sequence = -1;
+
+	return 0;
+}
+
+int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
+{
+	struct v4l2_events *events;
+	unsigned long flags;
+	int ret;
+
+	if (!fh->events) {
+		ret = v4l2_event_init(fh);
+		if (ret)
+			return ret;
+	}
+
+	events = fh->events;
+
+	while (events->nallocated < n) {
+		struct v4l2_kevent *kev;
+
+		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
+		if (kev == NULL)
+			return -ENOMEM;
+
+		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+		list_add_tail(&kev->list, &events->free);
+		events->nallocated++;
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
+void v4l2_event_free(struct v4l2_fh *fh)
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
+EXPORT_SYMBOL_GPL(v4l2_event_free);
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
+	WARN_ON(events->navailable == 0);
+
+	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
+	list_move(&kev->list, &events->free);
+	events->navailable--;
+
+	kev->event.pending = events->navailable;
+	*event = kev->event;
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
+
+static struct v4l2_subscribed_event *v4l2_event_subscribed(
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
+void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
+{
+	struct v4l2_fh *fh;
+	unsigned long flags;
+	struct timespec timestamp;
+
+	ktime_get_ts(&timestamp);
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+
+	list_for_each_entry(fh, &vdev->fh_list, list) {
+		struct v4l2_events *events = fh->events;
+		struct v4l2_kevent *kev;
+		u32 sequence;
+
+		/* Are we subscribed? */
+		if (!v4l2_event_subscribed(fh, ev->type))
+			continue;
+
+		/* Increase event sequence number on fh. */
+		events->sequence++;
+		sequence = events->sequence;
+
+		/* Do we have any free events? */
+		if (list_empty(&events->free))
+			continue;
+
+		/* Take one and fill it. */
+		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
+		kev->event.type = ev->type;
+		kev->event.u = ev->u;
+		kev->event.timestamp = timestamp;
+		kev->event.sequence = sequence;
+		list_move_tail(&kev->list, &events->available);
+
+		events->navailable++;
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
+	return fh->events->navailable;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_pending);
+
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub)
+{
+	struct v4l2_events *events = fh->events;
+	struct v4l2_subscribed_event *sev;
+	unsigned long flags;
+
+	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
+	if (!sev)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
+		INIT_LIST_HEAD(&sev->list);
+		sev->type = sub->type;
+
+		list_add(&sev->list, &events->subscribed);
+	}
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
+
+/* subscribe a zero-terminated array of events */
+int v4l2_event_subscribe_many(struct v4l2_fh *fh, const u32 *all)
+{
+	int ret;
+
+	for (; *all; all++) {
+		struct v4l2_event_subscription sub;
+
+		sub.type = *all;
+
+		ret = v4l2_event_subscribe(fh, &sub);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribe_many);
+
+static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
+{
+	struct v4l2_events *events = fh->events;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	while (!list_empty(&events->subscribed)) {
+		struct v4l2_subscribed_event *sev;
+
+		sev = list_first_entry(&events->subscribed,
+				       struct v4l2_subscribed_event, list);
+
+		list_del(&sev->list);
+		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+		kfree(sev);
+		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub)
+{
+	struct v4l2_subscribed_event *sev;
+	unsigned long flags;
+
+	if (sub->type == V4L2_EVENT_ALL) {
+		v4l2_event_unsubscribe_all(fh);
+		return 0;
+	}
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+
+	sev = v4l2_event_subscribed(fh, sub->type);
+	if (sev != NULL)
+		list_del(&sev->list);
+
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	if (sev != NULL)
+		kfree(sev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index c707930..3a9bc7d 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -25,11 +25,13 @@
 #include <linux/bitops.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
 	INIT_LIST_HEAD(&fh->list);
+	fh->events = NULL;
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_init);
@@ -60,5 +62,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 		return;
 
 	fh->vdev = NULL;
+
+	v4l2_event_free(fh);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
new file mode 100644
index 0000000..284d495
--- /dev/null
+++ b/include/media/v4l2-event.h
@@ -0,0 +1,65 @@
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
+	unsigned int		navailable;
+	struct list_head	free; /* Events ready for use */
+	unsigned int		nallocated; /* Number of allocated events */
+	u32			sequence;
+};
+
+int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
+void v4l2_event_free(struct v4l2_fh *fh);
+int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event);
+void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
+int v4l2_event_pending(struct v4l2_fh *fh);
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub);
+int v4l2_event_subscribe_many(struct v4l2_fh *fh, const u32 *all);
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub);
+
+#endif /* V4L2_EVENT_H */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 6b486aa..6c9df56 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,10 +28,12 @@
 #include <linux/list.h>
 
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

