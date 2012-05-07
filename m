Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab2EGTUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 02/23] v4l2-dev: make it possible to skip locking for non ioctl fops
Date: Mon,  7 May 2012 21:01:13 +0200
Message-Id: <1336417294-4566-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like with some ioctls some drivers may want to prevent the core from
taking the V4L2 core lock on other fops.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/video4linux/v4l2-framework.txt |    7 ++--
 drivers/media/video/v4l2-dev.c               |   45 ++++++++++++++------------
 include/media/v4l2-dev.h                     |    4 +++
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 4b9b407..c2e6591 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -621,8 +621,11 @@ v4l2_file_operations and locking
 
 You can set a pointer to a mutex_lock in struct video_device. Usually this
 will be either a top-level mutex or a mutex per device node. By default this
-lock will be used for each file operation and ioctl, but you can disable
-locking for selected ioctls by calling:
+lock will be used for each file operation and ioctl, you can disable this
+for all non ioctl operations by setting the V4L2_FL_DONT_USE_LOCK flag, e.g.:
+	set_bit(V4L2_FL_DONT_USE_LOCK, &vdev->flags);
+
+For ioctls you can disable locking for selected ioctls by calling:
 
 	void v4l2_dont_use_lock(struct video_device *vdev, unsigned int cmd);
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index a51a061..eb20f0b 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -274,12 +274,12 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 
 	if (!vdev->fops->read)
 		return -EINVAL;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (vdev->fops_lock && mutex_lock_interruptible(vdev->fops_lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if (vdev->lock)
-		mutex_unlock(vdev->lock);
+	if (vdev->fops_lock)
+		mutex_unlock(vdev->fops_lock);
 	return ret;
 }
 
@@ -291,12 +291,12 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 
 	if (!vdev->fops->write)
 		return -EINVAL;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (vdev->fops_lock && mutex_lock_interruptible(vdev->fops_lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if (vdev->lock)
-		mutex_unlock(vdev->lock);
+	if (vdev->fops_lock)
+		mutex_unlock(vdev->fops_lock);
 	return ret;
 }
 
@@ -307,12 +307,12 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 
 	if (!vdev->fops->poll)
 		return DEFAULT_POLLMASK;
-	if (vdev->lock)
-		mutex_lock(vdev->lock);
+	if (vdev->fops_lock)
+		mutex_lock(vdev->fops_lock);
 	if (video_is_registered(vdev))
 		ret = vdev->fops->poll(filp, poll);
-	if (vdev->lock)
-		mutex_unlock(vdev->lock);
+	if (vdev->fops_lock)
+		mutex_unlock(vdev->fops_lock);
 	return ret;
 }
 
@@ -399,12 +399,12 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 
 	if (!vdev->fops->mmap)
 		return ret;
-	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+	if (vdev->fops_lock && mutex_lock_interruptible(vdev->fops_lock))
 		return -ERESTARTSYS;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->lock)
-		mutex_unlock(vdev->lock);
+	if (vdev->fops_lock)
+		mutex_unlock(vdev->fops_lock);
 	return ret;
 }
 
@@ -426,7 +426,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
 	if (vdev->fops->open) {
-		if (vdev->lock && mutex_lock_interruptible(vdev->lock)) {
+		if (vdev->fops_lock &&
+				mutex_lock_interruptible(vdev->fops_lock)) {
 			ret = -ERESTARTSYS;
 			goto err;
 		}
@@ -434,8 +435,8 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = vdev->fops->open(filp);
 		else
 			ret = -ENODEV;
-		if (vdev->lock)
-			mutex_unlock(vdev->lock);
+		if (vdev->fops_lock)
+			mutex_unlock(vdev->fops_lock);
 	}
 
 err:
@@ -452,11 +453,11 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	int ret = 0;
 
 	if (vdev->fops->release) {
-		if (vdev->lock)
-			mutex_lock(vdev->lock);
+		if (vdev->fops_lock)
+			mutex_lock(vdev->fops_lock);
 		vdev->fops->release(filp);
-		if (vdev->lock)
-			mutex_unlock(vdev->lock);
+		if (vdev->fops_lock)
+			mutex_unlock(vdev->fops_lock);
 	}
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
@@ -601,6 +602,10 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		if (vdev->prio == NULL)
 			vdev->prio = &vdev->v4l2_dev->prio;
 	}
+	if (test_bit(V4L2_FL_DONT_USE_LOCK, &vdev->flags))
+		vdev->fops_lock = NULL;
+	else
+		vdev->fops_lock = vdev->lock;
 
 	/* Part 2: find a free minor, device node number and device index. */
 #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 0da84dc..fa80124 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -39,6 +39,9 @@ struct v4l2_ctrl_handler;
 #define V4L2_FL_USES_V4L2_FH	(1)
 /* Use the prio field of v4l2_fh for core priority checking */
 #define V4L2_FL_USE_FH_PRIO	(2)
+/* Don't take the lock for all fops, except ioctl. For ioctls the lock can be
+   disabled on a per ioctl basis by calling v4l2_dont_use_lock. */
+#define V4L2_FL_DONT_USE_LOCK	(3)
 
 /* Priority helper functions */
 
@@ -130,6 +133,7 @@ struct video_device
 	/* serialization lock */
 	DECLARE_BITMAP(dont_use_lock, BASE_VIDIOC_PRIVATE);
 	struct mutex *lock;
+	struct mutex *fops_lock;	/* Internal v4l2-vdev usage only */
 };
 
 #define media_entity_to_video_device(__e) \
-- 
1.7.10

