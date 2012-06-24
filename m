Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3702 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2FXLiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:38:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 26/26] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:18 +0200
Message-Id: <49aab1463b170994122d23b6f50723b50e3dd18a.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All drivers that needed V4L2_FL_LOCK_ALL_FOPS have been converted,
so remove this flag altogether.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c |   64 ++++++++--------------------------------
 include/media/v4l2-dev.h       |    3 --
 2 files changed, 12 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5ccbd46..3f55170 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -270,52 +270,35 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = -ENODEV;
 
 	if (!vdev->fops->read)
 		return -EINVAL;
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
-	    mutex_lock_interruptible(vdev->lock))
-		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
-		ret = vdev->fops->read(filp, buf, sz, off);
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-		mutex_unlock(vdev->lock);
-	return ret;
+		return vdev->fops->read(filp, buf, sz, off);
+	return -ENODEV;
 }
 
 static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		size_t sz, loff_t *off)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = -ENODEV;
 
 	if (!vdev->fops->write)
 		return -EINVAL;
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
-	    mutex_lock_interruptible(vdev->lock))
-		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
-		ret = vdev->fops->write(filp, buf, sz, off);
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-		mutex_unlock(vdev->lock);
-	return ret;
+		return vdev->fops->write(filp, buf, sz, off);
+	return -ENODEV;
 }
 
 static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = POLLERR | POLLHUP;
 
 	if (!vdev->fops->poll)
 		return DEFAULT_POLLMASK;
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-		mutex_lock(vdev->lock);
 	if (video_is_registered(vdev))
-		ret = vdev->fops->poll(filp, poll);
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-		mutex_unlock(vdev->lock);
-	return ret;
+		return vdev->fops->poll(filp, poll);
+	return POLLERR | POLLHUP;
 }
 
 static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
@@ -397,18 +380,12 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = -ENODEV;
 
 	if (!vdev->fops->mmap)
-		return ret;
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
-	    mutex_lock_interruptible(vdev->lock))
-		return -ERESTARTSYS;
+		return -ENODEV;
 	if (video_is_registered(vdev))
-		ret = vdev->fops->mmap(filp, vm);
-	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-		mutex_unlock(vdev->lock);
-	return ret;
+		return vdev->fops->mmap(filp, vm);
+	return -ENODEV;
 }
 
 /* Override for the open function */
@@ -429,20 +406,12 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
 	if (vdev->fops->open) {
-		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
-		    mutex_lock_interruptible(vdev->lock)) {
-			ret = -ERESTARTSYS;
-			goto err;
-		}
 		if (video_is_registered(vdev))
 			ret = vdev->fops->open(filp);
 		else
 			ret = -ENODEV;
-		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-			mutex_unlock(vdev->lock);
 	}
 
-err:
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
@@ -453,19 +422,14 @@ err:
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = 0;
 
-	if (vdev->fops->release) {
-		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-			mutex_lock(vdev->lock);
+	if (vdev->fops->release)
 		vdev->fops->release(filp);
-		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
-			mutex_unlock(vdev->lock);
-	}
+
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
-	return ret;
+	return 0;
 }
 
 static const struct file_operations v4l2_fops = {
@@ -835,10 +799,6 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	WARN_ON(video_device[vdev->minor] != NULL);
 	vdev->index = get_index(vdev);
 	mutex_unlock(&videodev_lock);
-	/* if no lock was passed, then make sure the LOCK_ALL_FOPS bit is
-	   clear and warn if it wasn't. */
-	if (vdev->lock == NULL)
-		WARN_ON(test_and_clear_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags));
 
 	if (vdev->ioctl_ops)
 		determine_valid_ioctls(vdev);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index a056e6e..08aca24 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -39,9 +39,6 @@ struct v4l2_ctrl_handler;
 #define V4L2_FL_USES_V4L2_FH	(1)
 /* Use the prio field of v4l2_fh for core priority checking */
 #define V4L2_FL_USE_FH_PRIO	(2)
-/* If ioctl core locking is in use, then apply that also to all
-   file operations. Don't use this flag in new drivers! */
-#define V4L2_FL_LOCK_ALL_FOPS	(3)
 
 /* Priority helper functions */
 
-- 
1.7.10

