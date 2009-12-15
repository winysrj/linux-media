Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49529 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbZLOMUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 07:20:19 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	gururaj.nagendra@intel.com, mchehab@infradead.org,
	mkrufky@linuxtv.org, dheitmueller@kernellabs.com,
	iivanov@mm-sol.com, vimarsh.zutshi@nokia.com
Subject: [RFC 1/4] V4L: File handles
Date: Tue, 15 Dec 2009 14:19:48 +0200
Message-Id: <1260879591-14376-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B277D2A.7050201@maxwell.research.nokia.com>
References: <4B277D2A.7050201@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a list of v4l2_file_handle structures to every video_device.
It allows using file handle related information in V4L2. The event interface
is one example of such use.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile   |    2 +-
 drivers/media/video/v4l2-dev.c |    7 +++-
 drivers/media/video/v4l2-fh.c  |   95 ++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h       |    4 ++
 include/media/v4l2-fh.h        |   45 +++++++++++++++++++
 5 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/v4l2-fh.c
 create mode 100644 include/media/v4l2-fh.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a61e3f3..1947146 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 7090699..387a302 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -283,7 +283,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
-	if (vdev->fops->open)
+	ret = v4l2_file_handle_add(vdev, filp);
+	if (!ret && vdev->fops->open)
 		ret = vdev->fops->open(filp);
 
 	/* decrease the refcount in case of an error */
@@ -301,6 +302,8 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	if (vdev->fops->release)
 		vdev->fops->release(filp);
 
+	v4l2_file_handle_del(vdev, filp);
+
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
@@ -421,6 +424,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	if (!vdev->release)
 		return -EINVAL;
 
+	v4l2_file_handle_init(vdev);
+
 	/* Part 1: check device type */
 	switch (type) {
 	case VFL_TYPE_GRABBER:
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
new file mode 100644
index 0000000..52cb3b3
--- /dev/null
+++ b/drivers/media/video/v4l2-fh.c
@@ -0,0 +1,95 @@
+/*
+ * drivers/media/video/v4l2-fh.c
+ *
+ * V4L2 file handles.
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
+
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+
+static struct v4l2_file_handle *__v4l2_file_handle_get(
+	struct video_device *vdev, struct file *filp)
+{
+	struct v4l2_file_handle *fh;
+
+	list_for_each_entry(fh, &vdev->fh, list) {
+		if (fh->filp == filp)
+			return fh;
+	}
+
+	return NULL;
+}
+
+struct v4l2_file_handle *v4l2_file_handle_get(struct video_device *vdev,
+					      struct file *filp)
+{
+	struct v4l2_file_handle *fh;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+	fh = __v4l2_file_handle_get(vdev, filp);
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+
+	return fh;
+}
+EXPORT_SYMBOL_GPL(v4l2_file_handle_get);
+
+int v4l2_file_handle_add(struct video_device *vdev, struct file *filp)
+{
+	struct v4l2_file_handle *fh;
+	unsigned long flags;
+
+	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
+	if (!fh)
+		return -ENOMEM;
+
+	fh->filp = filp;
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+	list_add(&fh->list, &vdev->fh);
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_file_handle_add);
+
+void v4l2_file_handle_del(struct video_device *vdev, struct file *filp)
+{
+	struct v4l2_file_handle *fh = v4l2_file_handle_get(vdev, filp);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+	list_del(&fh->list);
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+
+	kfree(fh);
+}
+EXPORT_SYMBOL_GPL(v4l2_file_handle_del);
+
+void v4l2_file_handle_init(struct video_device *vdev)
+{
+	spin_lock_init(&vdev->fh_lock);
+	INIT_LIST_HEAD(&vdev->fh);
+}
+EXPORT_SYMBOL_GPL(v4l2_file_handle_init);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 2dee938..8eac93d 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
+#include <media/v4l2-fh.h>
+
 #define VIDEO_MAJOR	81
 
 #define VFL_TYPE_GRABBER	0
@@ -77,6 +79,8 @@ struct video_device
 	/* attribute to differentiate multiple indices on one physical device */
 	int index;
 
+	spinlock_t fh_lock;		/* Lock for file handle list */
+	struct list_head fh;		/* File handle list */
 	int debug;			/* Activates debug level*/
 
 	/* Video standard vars */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
new file mode 100644
index 0000000..5c9d08b
--- /dev/null
+++ b/include/media/v4l2-fh.h
@@ -0,0 +1,45 @@
+/*
+ * include/media/v4l2-fh.h
+ *
+ * V4L2 file handle.
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
+#ifndef V4L2_FH_H
+#define V4L2_FH_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct v4l2_file_handle {
+	struct list_head	list;
+	struct file		*filp;
+};
+
+struct video_device;
+
+struct v4l2_file_handle *v4l2_file_handle_get(struct video_device *vdev,
+					      struct file *filp);
+int __must_check v4l2_file_handle_add(struct video_device *vdev,
+				      struct file *filp);
+void v4l2_file_handle_del(struct video_device *vdev, struct file *filp);
+void v4l2_file_handle_init(struct video_device *vdev);
+
+#endif /* V4L2_EVENT_H */
-- 
1.5.6.5

