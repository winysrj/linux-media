Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25174 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0BFSCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 13:02:24 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com,
	iivanov@mm-sol.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 2/8] V4L: File handles: Add refcount to v4l2_fh
Date: Sat,  6 Feb 2010 20:02:05 +0200
Message-Id: <1265479331-20595-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B6DAE5A.5090508@maxwell.research.nokia.com>
References: <4B6DAE5A.5090508@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-fh.c |   16 +++++++++++++---
 include/media/v4l2-fh.h       |    7 ++++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 48bd32f..1728e1c 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -25,22 +25,32 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 
-int v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh)
+void v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh)
 {
 	unsigned long flags;
 
+	spin_lock_init(&fh->lock);
+	atomic_set(&fh->refcount, 1);
+
 	spin_lock_irqsave(&vdev->fhs.lock, flags);
 	list_add(&fh->list, &vdev->fhs.list);
 	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_new);
 
+int v4l2_fh_get(struct video_device *vdev, struct v4l2_fh *fh)
+{
+	return !atomic_add_unless(&fh->refcount, 1, 0);
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_get);
+
 void v4l2_fh_put(struct video_device *vdev, struct v4l2_fh *fh)
 {
 	unsigned long flags;
 
+	if (atomic_dec_return(&fh->refcount))
+		return;
+
 	spin_lock_irqsave(&vdev->fhs.lock, flags);
 	list_del(&fh->list);
 	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index b9e277c..51d6508 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,8 +28,12 @@
 #include <linux/types.h>
 #include <linux/list.h>
 
+#include <asm/atomic.h>
+
 struct v4l2_fh {
 	struct list_head	list;
+	atomic_t		refcount;
+	spinlock_t		lock;
 };
 
 /* File handle related data for video_device. */
@@ -42,7 +46,8 @@ struct v4l2_fhs {
 
 struct video_device;
 
-int v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh);
+void v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh);
+int v4l2_fh_get(struct video_device *vdev, struct v4l2_fh *fh);
 void v4l2_fh_put(struct video_device *vdev, struct v4l2_fh *fh);
 void v4l2_fh_init(struct video_device *vdev);
 
-- 
1.5.6.5

