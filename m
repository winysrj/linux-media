Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2869 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1ACSba (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:30 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuV006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:29 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 04/10] v4l2-dev/fh: add v4l2_fh_open and v4l2_fh_release helper functions
Date: Mon,  3 Jan 2011 19:31:09 +0100
Message-Id: <49630cc01154111a1264e6eea25d79558b04a891.1294078230.git.hverkuil@xs4all.nl>
In-Reply-To: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
References: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add two new functions: v4l2_fh_open allocates and initializes a struct v4l2_fh
based on a struct file pointer and v4l2_fh_release releases and frees a struct
v4l2_fh.

These functions are also called if the v4l2_file_operations struct provides
neither open nor release functions.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c |   19 +++++++++++++++----
 drivers/media/video/v4l2-fh.c  |   26 ++++++++++++++++++++++++++
 include/media/v4l2-fh.h        |   16 ++++++++++++++++
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index c8f6ae1..e4fe644 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -31,6 +31,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
 
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
@@ -367,6 +368,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev;
+	int (*open)(struct file *);
 	int ret = 0;
 
 	/* Check if the video device is available */
@@ -380,13 +382,17 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
-	if (vdev->fops->open) {
+	if (vdev->fops->open)
+		open = vdev->fops->open;
+	else if (!vdev->fops->release)
+		open = v4l2_fh_open;
+	if (open) {
 		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
 			ret = -ERESTARTSYS;
 			goto err;
 		}
 		if (video_is_registered(vdev))
-			ret = vdev->fops->open(filp);
+			ret = open(filp);
 		else
 			ret = -ENODEV;
 		if (vdev->lock)
@@ -404,12 +410,17 @@ err:
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
+	int (*release)(struct file *);
 	int ret = 0;
 
-	if (vdev->fops->release) {
+	if (vdev->fops->release)
+		release = vdev->fops->release;
+	else if (!vdev->fops->open)
+		release = v4l2_fh_release;
+	if (release) {
 		if (vdev->lock)
 			mutex_lock(vdev->lock);
-		vdev->fops->release(filp);
+		release(filp);
 		if (vdev->lock)
 			mutex_unlock(vdev->lock);
 	}
diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 78a1608..133c68d 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/slab.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
@@ -60,6 +61,20 @@ void v4l2_fh_add(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_add);
 
+int v4l2_fh_open(struct file *filp)
+{
+	struct video_device *vdev = video_devdata(filp);
+	struct v4l2_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+
+	if (fh == NULL)
+		return -ENOMEM;
+	filp->private_data = fh;
+	v4l2_fh_init(fh, vdev);
+	v4l2_fh_add(fh);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_open);
+
 void v4l2_fh_del(struct v4l2_fh *fh)
 {
 	unsigned long flags;
@@ -81,3 +96,14 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 	v4l2_event_free(fh);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_exit);
+
+int v4l2_fh_release(struct file *filp)
+{
+	struct v4l2_fh *fh = filp->private_data;
+
+	v4l2_fh_del(fh);
+	v4l2_fh_exit(fh);
+	kfree(fh);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_release);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 5fc5ba9..e80a101 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -51,8 +51,16 @@ int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
  */
 void v4l2_fh_add(struct v4l2_fh *fh);
 /*
+ * Can be used as the open() op of v4l2_file_operations.
+ * It allocates a v4l2_fh and inits and adds it to the video_device associated
+ * with the file pointer.
+ */
+int v4l2_fh_open(struct file *filp);
+/*
  * Remove file handle from the list of file handles. Must be called in
  * v4l2_file_operations->release() handler if the driver uses v4l2_fh.
+ * The core will call this also if neither open() nor release() was
+ * specified in v4l2_file_operations.
  */
 void v4l2_fh_del(struct v4l2_fh *fh);
 /*
@@ -62,5 +70,13 @@ void v4l2_fh_del(struct v4l2_fh *fh);
  * driver uses v4l2_fh.
  */
 void v4l2_fh_exit(struct v4l2_fh *fh);
+/*
+ * Can be used as the release() op of v4l2_file_operations.
+ * It deletes and exits the v4l2_fh associated with the file pointer and
+ * frees it.
+ * The core will call this also if neither open() nor release() was
+ * specified in v4l2_file_operations.
+ */
+int v4l2_fh_release(struct file *filp);
 
 #endif /* V4L2_EVENT_H */
-- 
1.7.0.4

