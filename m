Return-path: <mchehab@gaivota>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2440 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0L2VnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:17 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhCuw002049
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:16 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <82612284712306ca50a34849688ba4c51f97b7f2.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:11 +0100
Subject: [PATCH 04/10] [RFC] v4l2-dev: add and support flag V4L2_FH_USE_PRIO.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Flag V4L2_FH_USE_PRIO is set if we can safely store the priority level
in file->private_data. Support this flag for the open and release file
operations.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c |   23 +++++++++++++++++++++--
 include/media/v4l2-dev.h       |    6 ++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index c8f6ae1..96ec954 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -380,6 +380,15 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
+
+	if (test_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags)) {
+		enum v4l2_priority prio =
+			(enum v4l2_priority)filp->private_data;
+
+		v4l2_prio_open(vdev->prio, &prio);
+		filp->private_data = (void *)prio;
+	}
+
 	if (vdev->fops->open) {
 		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
 			ret = -ERESTARTSYS;
@@ -404,8 +413,13 @@ err:
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = 0;
 
+	if (test_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags)) {
+		enum v4l2_priority prio =
+			(enum v4l2_priority)filp->private_data;
+
+		v4l2_prio_close(vdev->prio, prio);
+	}
 	if (vdev->fops->release) {
 		if (vdev->lock)
 			mutex_lock(vdev->lock);
@@ -417,7 +431,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
-	return ret;
+	return 0;
 }
 
 static const struct file_operations v4l2_fops = {
@@ -612,6 +626,11 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	vdev->index = get_index(vdev);
 	mutex_unlock(&videodev_lock);
 
+	/* Determine if we can store v4l2_priority in file->private_data */
+	if (vdev->fops->open == NULL && vdev->fops->release == NULL &&
+	    vdev->prio != NULL)
+		set_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags);
+
 	/* Part 3: Initialize the character device */
 	vdev->cdev = cdev_alloc();
 	if (vdev->cdev == NULL) {
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 15dd756..045dffa 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -32,7 +32,13 @@ struct v4l2_ctrl_handler;
    Drivers can clear this flag if they want to block all future
    device access. It is cleared by video_unregister_device. */
 #define V4L2_FL_REGISTERED	(0)
+/* Flag to mark that the driver stores a pointer to struct v4l2_fh in
+   file->private_data. Is automatically detected. */
 #define V4L2_FL_USES_V4L2_FH	(1)
+/* Flag to mark that the driver stores the local v4l2_priority in
+   file->private_data. Will be set if open and release are both NULL.
+   Drivers can also set it manually. */
+#define V4L2_FL_USES_V4L2_PRIO	(2)
 
 /* Priority helper functions */
 
-- 
1.6.4.2

