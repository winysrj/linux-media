Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1418 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0KNNWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:14 -0500
Message-Id: <a1d7a499591515e1746a02af64dfff5a95089a46.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:22:13 +0100
Subject: [RFC PATCH 1/8] v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Where reasonable use mutex_lock_interruptible instead of mutex_lock.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c |   44 +++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7978..8eb0756 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -191,8 +191,12 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 
 	if (!vdev->fops->read)
 		return -EINVAL;
-	if (vdev->lock)
-		mutex_lock(vdev->lock);
+	if (vdev->lock) {
+		int res = mutex_lock_interruptible(vdev->lock);
+
+		if (res)
+			return res;
+	}
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
 	if (vdev->lock)
@@ -208,8 +212,12 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 
 	if (!vdev->fops->write)
 		return -EINVAL;
-	if (vdev->lock)
-		mutex_lock(vdev->lock);
+	if (vdev->lock) {
+		int res = mutex_lock_interruptible(vdev->lock);
+
+		if (res)
+			return res;
+	}
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
 	if (vdev->lock)
@@ -224,8 +232,8 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 
 	if (!vdev->fops->poll)
 		return ret;
-	if (vdev->lock)
-		mutex_lock(vdev->lock);
+	if (vdev->lock && mutex_lock_interruptible(vdev->lock))
+		return ret;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->poll(filp, poll);
 	if (vdev->lock)
@@ -239,8 +247,12 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int ret = -ENODEV;
 
 	if (vdev->fops->unlocked_ioctl) {
-		if (vdev->lock)
-			mutex_lock(vdev->lock);
+		if (vdev->lock) {
+			int res = mutex_lock_interruptible(vdev->lock);
+
+			if (res)
+				return res;
+		}
 		if (video_is_registered(vdev))
 			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
 		if (vdev->lock)
@@ -264,8 +276,12 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 
 	if (!vdev->fops->mmap)
 		return ret;
-	if (vdev->lock)
-		mutex_lock(vdev->lock);
+	if (vdev->lock) {
+		int res = mutex_lock_interruptible(vdev->lock);
+
+		if (res)
+			return res;
+	}
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
 	if (vdev->lock)
@@ -291,8 +307,11 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
 	if (vdev->fops->open) {
-		if (vdev->lock)
-			mutex_lock(vdev->lock);
+		if (vdev->lock) {
+			ret = mutex_lock_interruptible(vdev->lock);
+			if (ret)
+				goto err;
+		}
 		if (video_is_registered(vdev))
 			ret = vdev->fops->open(filp);
 		else
@@ -301,6 +320,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			mutex_unlock(vdev->lock);
 	}
 
+err:
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
-- 
1.7.0.4

