Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56610 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033098AbeEXUgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:36:51 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 02/20] v4l2-core: push taking ioctl mutex down to ioctl handler.
Date: Thu, 24 May 2018 17:35:02 -0300
Message-Id: <20180524203520.1598-3-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The ioctl serialization mutex (vdev->lock or q->lock for vb2 queues)
was taken at the highest level in v4l2-dev.c. This prevents more
fine-grained locking since at that level we cannot examine the ioctl
arguments, we can only do that after video_usercopy is called.

So push the locking down to __video_do_ioctl() and subdev_do_ioctl_lock().

This also allows us to make a few functions in v4l2-ioctl.c static and
video_usercopy() is no longer exported.

The locking scheme is not changed by this patch, just pushed down.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c    |  6 ------
 drivers/media/v4l2-core/v4l2-ioctl.c  | 17 ++++++++++++++---
 drivers/media/v4l2-core/v4l2-subdev.c | 17 ++++++++++++++++-
 include/media/v4l2-dev.h              |  9 ---------
 include/media/v4l2-ioctl.h            | 12 ------------
 5 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1d0b2208e8fb..baf8cd549128 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -352,14 +352,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int ret = -ENODEV;
 
 	if (vdev->fops->unlocked_ioctl) {
-		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
-
-		if (lock && mutex_lock_interruptible(lock))
-			return -ERESTARTSYS;
 		if (video_is_registered(vdev))
 			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
-		if (lock)
-			mutex_unlock(lock);
 	} else
 		ret = -ENOTTY;
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 63de1c7134cc..de1b868500f3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2634,14 +2634,14 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
-bool v4l2_is_known_ioctl(unsigned int cmd)
+static bool v4l2_is_known_ioctl(unsigned int cmd)
 {
 	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
 		return false;
 	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
 }
 
-struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
+static struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
 {
 	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
 		return vdev->lock;
@@ -2692,6 +2692,7 @@ static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
+	struct mutex *lock = v4l2_ioctl_get_lock(vfd, cmd);
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool write_only = false;
 	struct v4l2_ioctl_info default_info;
@@ -2710,6 +2711,14 @@ static long __video_do_ioctl(struct file *file,
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
 		vfh = file->private_data;
 
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+
+	if (!video_is_registered(vfd)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	if (v4l2_is_known_ioctl(cmd)) {
 		info = &v4l2_ioctls[_IOC_NR(cmd)];
 
@@ -2765,6 +2774,9 @@ static long __video_do_ioctl(struct file *file,
 		}
 	}
 
+unlock:
+	if (lock)
+		mutex_unlock(lock);
 	return ret;
 }
 
@@ -2954,7 +2966,6 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	kvfree(mbuf);
 	return err;
 }
-EXPORT_SYMBOL(video_usercopy);
 
 long video_ioctl2(struct file *file,
 	       unsigned int cmd, unsigned long arg)
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f9eed938d348..6a7f7f75dfd7 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -502,10 +502,25 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	return 0;
 }
 
+static long subdev_do_ioctl_lock(struct file *file, unsigned int cmd, void *arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->lock;
+	long ret = -ENODEV;
+
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (video_is_registered(vdev))
+		ret = subdev_do_ioctl(file, cmd, arg);
+	if (lock)
+		mutex_unlock(lock);
+	return ret;
+}
+
 static long subdev_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg)
 {
-	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
+	return video_usercopy(file, cmd, arg, subdev_do_ioctl_lock);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 4546958eeba0..3a0be40749bc 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -434,15 +434,6 @@ void video_device_release(struct video_device *vdev);
  */
 void video_device_release_empty(struct video_device *vdev);
 
-/**
- * v4l2_is_known_ioctl - Checks if a given cmd is a known V4L ioctl
- *
- * @cmd: ioctl command
- *
- * returns true if cmd is a known V4L2 ioctl
- */
-bool v4l2_is_known_ioctl(unsigned int cmd);
-
 /**
  * v4l2_disable_ioctl- mark that a given command isn't implemented.
  *	shouldn't use core locking
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index a7b3f7c75d62..a8dbf5b54b5c 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -658,18 +658,6 @@ void v4l_printk_ioctl(const char *prefix, unsigned int cmd);
 
 struct video_device;
 
-
-/**
- * v4l2_ioctl_get_lock - get the mutex (if any) that it is need to lock for
- *	a given command.
- *
- * @vdev: Pointer to struct &video_device.
- * @cmd: Ioctl name.
- *
- * .. note:: Internal use only. Should not be used outside V4L2 core.
- */
-struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned int cmd);
-
 /* names for fancy debug output */
 extern const char *v4l2_field_names[];
 extern const char *v4l2_type_names[];
-- 
2.16.3
