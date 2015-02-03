Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59957 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933862AbbBCMsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 07:48:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, isely@isely.net,
	pali.rohar@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] v4l2-core: remove the old .ioctl BKL replacement
Date: Tue,  3 Feb 2015 13:47:26 +0100
Message-Id: <1422967646-12223-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl>
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

To keep V4L2 drivers that did not yet convert to unlocked_ioctl happy,
the v4l2 core had a .ioctl file operation that took a V4L2 lock.

The last drivers are now converted to unlocked_ioctl, so all this
old code can now be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c    | 28 ----------------------------
 drivers/media/v4l2-core/v4l2-device.c |  1 -
 include/media/v4l2-dev.h              |  1 -
 include/media/v4l2-device.h           |  2 --
 4 files changed, 32 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 86bb93f..276a0d8 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -357,34 +357,6 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
 		if (lock)
 			mutex_unlock(lock);
-	} else if (vdev->fops->ioctl) {
-		/* This code path is a replacement for the BKL. It is a major
-		 * hack but it will have to do for those drivers that are not
-		 * yet converted to use unlocked_ioctl.
-		 *
-		 * All drivers implement struct v4l2_device, so we use the
-		 * lock defined there to serialize the ioctls.
-		 *
-		 * However, if the driver sleeps, then it blocks all ioctls
-		 * since the lock is still held. This is very common for
-		 * VIDIOC_DQBUF since that normally waits for a frame to arrive.
-		 * As a result any other ioctl calls will proceed very, very
-		 * slowly since each call will have to wait for the VIDIOC_QBUF
-		 * to finish. Things that should take 0.01s may now take 10-20
-		 * seconds.
-		 *
-		 * The workaround is to *not* take the lock for VIDIOC_DQBUF.
-		 * This actually works OK for videobuf-based drivers, since
-		 * videobuf will take its own internal lock.
-		 */
-		struct mutex *m = &vdev->v4l2_dev->ioctl_lock;
-
-		if (cmd != VIDIOC_DQBUF && mutex_lock_interruptible(m))
-			return -ERESTARTSYS;
-		if (video_is_registered(vdev))
-			ret = vdev->fops->ioctl(filp, cmd, arg);
-		if (cmd != VIDIOC_DQBUF)
-			mutex_unlock(m);
 	} else
 		ret = -ENOTTY;
 
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 015f92a..e4d40cf 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -37,7 +37,6 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 
 	INIT_LIST_HEAD(&v4l2_dev->subdevs);
 	spin_lock_init(&v4l2_dev->lock);
-	mutex_init(&v4l2_dev->ioctl_lock);
 	v4l2_prio_init(&v4l2_dev->prio);
 	kref_init(&v4l2_dev->ref);
 	get_device(dev);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 3e4fddf..acbcd2f 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -65,7 +65,6 @@ struct v4l2_file_operations {
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 #ifdef CONFIG_COMPAT
 	long (*compat_ioctl32) (struct file *, unsigned int, unsigned long);
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index ffb69da..9c58157 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -58,8 +58,6 @@ struct v4l2_device {
 	struct v4l2_ctrl_handler *ctrl_handler;
 	/* Device's priority state */
 	struct v4l2_prio_state prio;
-	/* BKL replacement mutex. Temporary solution only. */
-	struct mutex ioctl_lock;
 	/* Keep track of the references to this struct. */
 	struct kref ref;
 	/* Release function that is called when the ref count goes to 0. */
-- 
2.1.4

