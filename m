Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49538 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbZLOMUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 07:20:22 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	gururaj.nagendra@intel.com, mchehab@infradead.org,
	mkrufky@linuxtv.org, dheitmueller@kernellabs.com,
	iivanov@mm-sol.com, vimarsh.zutshi@nokia.com
Subject: [RFC 4/4] V4L: Events: Add backend
Date: Tue, 15 Dec 2009 14:19:51 +0200
Message-Id: <1260879591-14376-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1260879591-14376-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B277D2A.7050201@maxwell.research.nokia.com>
 <1260879591-14376-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1260879591-14376-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1260879591-14376-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add event handling backend to V4L2. The backend handles event subscription
and delivery to file handles. Event subscriptions are based on file handle.
Events may be delivered to all subscribed file handles on a device
independent of where they originate from.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile     |    3 +-
 drivers/media/video/v4l2-event.c |  254 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-fh.c    |    9 ++
 include/media/v4l2-event.h       |   73 +++++++++++
 include/media/v4l2-fh.h          |    3 +
 5 files changed, 341 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/v4l2-event.c
 create mode 100644 include/media/v4l2-event.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 1947146..dd6a853 100644
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
index 0000000..91c3acc
--- /dev/null
+++ b/drivers/media/video/v4l2-event.c
@@ -0,0 +1,254 @@
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
+static struct kmem_cache *event_kmem;
+
+static void v4l2_event_kmem_ctor(void *ptr)
+{
+	struct _v4l2_event *ev = ptr;
+
+	INIT_LIST_HEAD(&ev->list);
+}
+
+int v4l2_event_init(struct v4l2_events *events)
+{
+	if (!event_kmem)
+		event_kmem = kmem_cache_create("event_kmem",
+					       sizeof(struct _v4l2_event), 0,
+					       SLAB_HWCACHE_ALIGN,
+					       &v4l2_event_kmem_ctor);
+
+	if (!event_kmem)
+		return -ENOMEM;
+
+	init_waitqueue_head(&events->wait);
+	spin_lock_init(&events->lock);
+
+	INIT_LIST_HEAD(&events->available);
+	INIT_LIST_HEAD(&events->subscribed);
+
+	return 0;
+};
+EXPORT_SYMBOL_GPL(v4l2_event_init);
+
+void v4l2_event_exit(struct v4l2_events *events)
+{
+	while (!list_empty(&events->available)) {
+		struct _v4l2_event *ev;
+
+		ev = list_entry(events->available.next,
+				struct _v4l2_event, list);
+
+		list_del(&ev->list);
+
+		kmem_cache_free(event_kmem, ev);
+	}
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
+EXPORT_SYMBOL_GPL(v4l2_event_exit);
+
+int v4l2_event_dequeue(struct v4l2_events *events, struct v4l2_event *event)
+{
+	struct _v4l2_event *ev;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&events->lock, flags);
+
+	if (list_empty(&events->available)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ev = list_first_entry(&events->available, struct _v4l2_event, list);
+	list_del(&ev->list);
+
+	ev->event.count = !list_empty(&events->available);
+
+	memcpy(event, &ev->event, sizeof(ev->event));
+
+	kmem_cache_free(event_kmem, ev);
+
+out:
+
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
+
+static struct _v4l2_event *v4l2_event_queue_get(struct v4l2_events *events)
+{
+	return kmem_cache_alloc(event_kmem, GFP_KERNEL | GFP_ATOMIC);
+}
+
+static void v4l2_event_queue_put(struct v4l2_events *events,
+				 struct _v4l2_event *ev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events->lock, flags);
+
+	list_add(&ev->list, &events->available);
+
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	wake_up_all(&events->wait);
+}
+
+static struct v4l2_subscribed_event *__v4l2_event_subscribed(
+	struct v4l2_events *events, u32 type)
+{
+	struct v4l2_subscribed_event *ev;
+
+	list_for_each_entry(ev, &events->subscribed, list) {
+		if (ev->type == type)
+			return ev;
+	}
+
+	return NULL;
+}
+
+struct v4l2_subscribed_event *v4l2_event_subscribed(
+	struct v4l2_events *events, u32 type)
+{
+	struct v4l2_subscribed_event *ev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&events->lock, flags);
+
+	ev = __v4l2_event_subscribed(events, type);
+
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	return ev;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribed);
+
+void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
+{
+	struct v4l2_file_handle *fh;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+
+	list_for_each_entry(fh, &vdev->fh, list) {
+		struct _v4l2_event *_ev;
+
+		if (!v4l2_event_subscribed(&fh->events, ev->type))
+			continue;
+
+		_ev = v4l2_event_queue_get(&fh->events);
+		if (!_ev)
+			continue;
+
+		_ev->event = *ev;
+		v4l2_event_queue_put(&fh->events, _ev);
+
+		printk(KERN_ALERT "deliver to some fh\n");
+	}
+
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_queue);
+
+int v4l2_event_pending(struct v4l2_events *events)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&events->lock, flags);
+	ret = list_empty(&events->available);
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_pending);
+
+int v4l2_event_subscribe(struct v4l2_events *events,
+			 struct v4l2_event_subscription *sub)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct v4l2_subscribed_event *ev;
+
+	ev = kmalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&events->lock, flags);
+
+	if (__v4l2_event_subscribed(events, sub->type) != NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&ev->list);
+	ev->type = sub->type;
+
+	list_add(&ev->list, &events->subscribed);
+
+out:
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	if (ret)
+		kfree(ev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
+
+int v4l2_event_unsubscribe(struct v4l2_events *events,
+			   struct v4l2_event_subscription *sub)
+{
+	struct v4l2_subscribed_event *ev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&events->lock, flags);
+
+	ev = __v4l2_event_subscribed(events, sub->type);
+
+	if (ev != NULL)
+		list_del(&ev->list);
+
+	spin_unlock_irqrestore(&events->lock, flags);
+
+	return ev == NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 52cb3b3..a8d4318 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -59,6 +59,7 @@ int v4l2_file_handle_add(struct video_device *vdev, struct file *filp)
 {
 	struct v4l2_file_handle *fh;
 	unsigned long flags;
+	int ret;
 
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
 	if (!fh)
@@ -66,6 +67,12 @@ int v4l2_file_handle_add(struct video_device *vdev, struct file *filp)
 
 	fh->filp = filp;
 
+	ret = v4l2_event_init(&fh->events);
+	if (ret) {
+		kfree(fh);
+		return ret;
+	}
+
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 	list_add(&fh->list, &vdev->fh);
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
@@ -79,6 +86,8 @@ void v4l2_file_handle_del(struct video_device *vdev, struct file *filp)
 	struct v4l2_file_handle *fh = v4l2_file_handle_get(vdev, filp);
 	unsigned long flags;
 
+	v4l2_event_exit(&fh->events);
+
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 	list_del(&fh->list);
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
new file mode 100644
index 0000000..6984fea
--- /dev/null
+++ b/include/media/v4l2-event.h
@@ -0,0 +1,73 @@
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include <linux/videodev2.h>
+
+#define V4L2_MAX_EVENTS		1024 /* Ought to be enough for everyone. */
+
+struct video_device;
+
+struct _v4l2_event {
+	struct list_head	list;
+	struct v4l2_event	event;
+};
+
+struct v4l2_events {
+	spinlock_t		lock; /* Protect everything here. */
+	struct list_head	available;
+	wait_queue_head_t	wait;
+	struct list_head	subscribed; /* Subscribed events. */
+};
+
+struct v4l2_subscribed_event {
+	struct list_head	list;
+	u32			type;
+};
+
+int v4l2_event_init(struct v4l2_events *events);
+void v4l2_event_exit(struct v4l2_events *events);
+
+int v4l2_event_dequeue(struct v4l2_events *events, struct v4l2_event *event);
+
+struct v4l2_subscribed_event *v4l2_event_subscribed(struct v4l2_events *sub,
+						    u32 type);
+
+void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev);
+int v4l2_event_pending(struct v4l2_events *events);
+
+int v4l2_event_subscribe(struct v4l2_events *sub,
+			 struct v4l2_event_subscription *s);
+int v4l2_event_unsubscribe(struct v4l2_events *sub,
+			   struct v4l2_event_subscription *s);
+void v4l2_event_sub_init(struct v4l2_events *sub);
+void v4l2_event_sub_exit(struct v4l2_events *sub);
+
+#endif /* V4L2_EVENT_H */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 5c9d08b..6e92014 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,9 +28,12 @@
 #include <linux/types.h>
 #include <linux/list.h>
 
+#include <media/v4l2-event.h>
+
 struct v4l2_file_handle {
 	struct list_head	list;
 	struct file		*filp;
+	struct v4l2_events	events;	/* events, pending and subscribed */
 };
 
 struct video_device;
-- 
1.5.6.5

