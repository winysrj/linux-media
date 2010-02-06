Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19308 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BFSC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:26 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 1/8] V4L: File handles
Date: Sat,  6 Feb 2010 20:02:04 +0200
Message-Id: <1265479331-20595-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a list of v4l2_fh structures to every video_device.
It allows using file handle related information in V4L2. The event interface
is one example of such use.

Video device drivers should use the v4l2_fh pointer as their
file->private_data.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile   |    3 +-
 drivers/media/video/v4l2-dev.c |    2 +
 drivers/media/video/v4l2-fh.c  |   54 ++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h       |    5 +++
 include/media/v4l2-fh.h        |   49 ++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/v4l2-fh.c
 create mode 100644 include/media/v4l2-fh.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 6e75647..b888ad1 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,8 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o \
+			v4l2-fh.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 13a899d..d8c14a5 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -423,6 +423,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	if (!vdev->release)
 		return -EINVAL;
 
+	v4l2_fh_init(vdev);
+
 	/* Part 1: check device type */
 	switch (type) {
 	case VFL_TYPE_GRABBER:
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
new file mode 100644
index 0000000..48bd32f
--- /dev/null
+++ b/drivers/media/video/v4l2-fh.c
@@ -0,0 +1,54 @@
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
+int v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fhs.lock, flags);
+	list_add(&fh->list, &vdev->fhs.list);
+	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_new);
+
+void v4l2_fh_put(struct video_device *vdev, struct v4l2_fh *fh)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fhs.lock, flags);
+	list_del(&fh->list);
+	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_put);
+
+void v4l2_fh_init(struct video_device *vdev)
+{
+	spin_lock_init(&vdev->fhs.lock);
+	INIT_LIST_HEAD(&vdev->fhs.list);
+}
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 26d4e79..65d9dc8 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -18,6 +18,8 @@
 
 #include <media/media-entity.h>
 
+#include <media/v4l2-fh.h>
+
 #define VIDEO_MAJOR	81
 
 #define VFL_TYPE_GRABBER	0
@@ -82,6 +84,9 @@ struct video_device
 	/* attribute to differentiate multiple indices on one physical device */
 	int index;
 
+	/* V4L2 file handles */
+	struct v4l2_fhs	fhs;
+
 	int debug;			/* Activates debug level*/
 
 	/* Video standard vars */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
new file mode 100644
index 0000000..b9e277c
--- /dev/null
+++ b/include/media/v4l2-fh.h
@@ -0,0 +1,49 @@
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
+struct v4l2_fh {
+	struct list_head	list;
+};
+
+/* File handle related data for video_device. */
+struct v4l2_fhs {
+	/* Lock for file handle list */
+	spinlock_t		lock;
+	/* File handle list */
+	struct list_head	list;
+};
+
+struct video_device;
+
+int v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh);
+void v4l2_fh_put(struct video_device *vdev, struct v4l2_fh *fh);
+void v4l2_fh_init(struct video_device *vdev);
+
+#endif /* V4L2_EVENT_H */
-- 
1.5.6.5

