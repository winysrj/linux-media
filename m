Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23370 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab0BVXBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:01:48 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	david.cohen@nokia.com
Subject: [PATCH v7 1/6] V4L: File handles
Date: Tue, 23 Feb 2010 01:01:36 +0200
Message-Id: <1266879701-9814-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B830CCA.8030909@maxwell.research.nokia.com>
References: <4B830CCA.8030909@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a list of v4l2_fh structures to every video_device.
It allows using file handle related information in V4L2. The event interface
is one example of such use.

Video device drivers should use the v4l2_fh pointer as their
file->private_data.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile   |    2 +-
 drivers/media/video/v4l2-dev.c |    4 ++
 drivers/media/video/v4l2-fh.c  |   66 ++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-dev.h       |    5 +++
 include/media/v4l2-fh.h        |   42 +++++++++++++++++++++++++
 5 files changed, 118 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/v4l2-fh.c
 create mode 100644 include/media/v4l2-fh.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 5163289..14bf69a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 7090699..65a7b30 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -421,6 +421,10 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	if (!vdev->release)
 		return -EINVAL;
 
+	/* v4l2_fh support */
+	spin_lock_init(&vdev->fh_lock);
+	INIT_LIST_HEAD(&vdev->fh_list);
+
 	/* Part 1: check device type */
 	switch (type) {
 	case VFL_TYPE_GRABBER:
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
new file mode 100644
index 0000000..93ea0af
--- /dev/null
+++ b/drivers/media/video/v4l2-fh.c
@@ -0,0 +1,66 @@
+/*
+ * v4l2-fh.c
+ *
+ * V4L2 file handles.
+ *
+ * Copyright (C) 2009--2010 Nokia Corporation.
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
+#include <linux/bitops.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+
+int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+{
+	fh->vdev = vdev;
+	INIT_LIST_HEAD(&fh->list);
+	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_init);
+
+void v4l2_fh_add(struct v4l2_fh *fh)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	list_add(&fh->list, &fh->vdev->fh_list);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_add);
+
+void v4l2_fh_del(struct v4l2_fh *fh)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	list_del_init(&fh->list);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_del);
+
+void v4l2_fh_exit(struct v4l2_fh *fh)
+{
+	if (fh->vdev == NULL)
+		return;
+
+	fh->vdev = NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_exit);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 2dee938..bebe44b 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -32,6 +32,7 @@ struct v4l2_device;
    Drivers can clear this flag if they want to block all future
    device access. It is cleared by video_unregister_device. */
 #define V4L2_FL_REGISTERED	(0)
+#define V4L2_FL_USES_V4L2_FH	(1)
 
 struct v4l2_file_operations {
 	struct module *owner;
@@ -77,6 +78,10 @@ struct video_device
 	/* attribute to differentiate multiple indices on one physical device */
 	int index;
 
+	/* V4L2 file handles */
+	spinlock_t		fh_lock; /* Lock for all v4l2_fhs */
+	struct list_head	fh_list; /* List of struct v4l2_fh */
+
 	int debug;			/* Activates debug level*/
 
 	/* Video standard vars */
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
new file mode 100644
index 0000000..410e86c
--- /dev/null
+++ b/include/media/v4l2-fh.h
@@ -0,0 +1,42 @@
+/*
+ * v4l2-fh.h
+ *
+ * V4L2 file handle.
+ *
+ * Copyright (C) 2009--2010 Nokia Corporation.
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
+#include <linux/list.h>
+
+struct video_device;
+
+struct v4l2_fh {
+	struct list_head	list;
+	struct video_device	*vdev;
+};
+
+int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
+void v4l2_fh_add(struct v4l2_fh *fh);
+void v4l2_fh_del(struct v4l2_fh *fh);
+void v4l2_fh_exit(struct v4l2_fh *fh);
+
+#endif /* V4L2_EVENT_H */
-- 
1.5.6.5

