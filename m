Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3381 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0EIT1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:47 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JReqx084589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:45 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <32667ffc68c4ff35e1a5693f79ca429c427cc4f0.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:16 +0200
Subject: [PATCH 4/7] [RFC] v4l2-dev: add and support flag V4L2_FH_USE_PRIO.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Flag V4L2_FH_USE_PRIO is set if we can safely store the priority level
in file->private_data. Support this flag for the open and release file
operations.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c |   23 +++++++++++++++++++++--
 include/media/v4l2-dev.h       |    6 ++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..fd536ff 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -283,6 +283,15 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
+
+	if (test_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags)) {
+		enum v4l2_priority prio =
+			(enum v4l2_priority)filp->private_data;
+
+		v4l2_prio_open(&vdev->v4l2_dev->prio, &prio);
+		filp->private_data = (void *)prio;
+	}
+
 	if (vdev->fops->open)
 		ret = vdev->fops->open(filp);
 
@@ -296,15 +305,20 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = 0;
 
+	if (test_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags)) {
+		enum v4l2_priority prio =
+			(enum v4l2_priority)filp->private_data;
+
+		v4l2_prio_close(&vdev->v4l2_dev->prio, prio);
+	}
 	if (vdev->fops->release)
 		vdev->fops->release(filp);
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
-	return ret;
+	return 0;
 }
 
 static const struct file_operations v4l2_unlocked_fops = {
@@ -515,6 +529,11 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	vdev->index = get_index(vdev);
 	mutex_unlock(&videodev_lock);
 
+	/* Determine if we can store v4l2_priority in file->private_data */
+	if (vdev->fops->open == NULL && vdev->fops->release == NULL &&
+	    vdev->v4l2_dev != NULL)
+		set_bit(V4L2_FL_USES_V4L2_PRIO, &vdev->flags);
+
 	/* Part 3: Initialize the character device */
 	vdev->cdev = cdev_alloc();
 	if (vdev->cdev == NULL) {
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index bebe44b..a116bc5 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -32,7 +32,13 @@ struct v4l2_device;
    Drivers can clear this flag if they want to block all future
    device access. It is cleared by video_unregister_device. */
 #define V4L2_FL_REGISTERED	(0)
+/* Flag to mark that the driver stores a pointer to struct v4l2_fh in
+   file->private_data. Is automatically detected. */
 #define V4L2_FL_USES_V4L2_FH	(1)
+/* Flag to mark that the driver stores the local v4l2_priority in
+   file->private_data. Will be used if open and release are both NULL.
+   Drivers can also set it manually. */
+#define V4L2_FL_USES_V4L2_PRIO	(2)
 
 struct v4l2_file_operations {
 	struct module *owner;
-- 
1.6.4.2

