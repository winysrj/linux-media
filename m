Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56090 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbeECOxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 06/28] v4l2-dev: lock req_queue_mutex
Date: Thu,  3 May 2018 16:52:56 +0200
Message-Id: <20180503145318.128315-7-hverkuil@xs4all.nl>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

We need to serialize streamon/off with queueing new requests.
These ioctls may trigger the cancellation of a streaming
operation, and that should not be mixed with queuing a new
request at the same time.

Also TRY/S_EXT_CTRLS needs this lock to correctly serialize
with MEDIA_REQUEST_IOC_QUEUE.

Finally close() needs this lock since that too can trigger the
cancellation of a streaming operation.

We take the req_queue_mutex here before any other locks since
it is a very high-level lock.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 37 +++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1d0b2208e8fb..b1c9efc0ecc4 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -353,13 +353,36 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	if (vdev->fops->unlocked_ioctl) {
 		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
+		struct mutex *queue_lock = NULL;
 
-		if (lock && mutex_lock_interruptible(lock))
+		/*
+		 * We need to serialize streamon/off with queueing new requests.
+		 * These ioctls may trigger the cancellation of a streaming
+		 * operation, and that should not be mixed with queueing a new
+		 * request at the same time.
+		 *
+		 * Also TRY/S_EXT_CTRLS needs this lock to correctly serialize
+		 * with MEDIA_REQUEST_IOC_QUEUE.
+		 */
+		if (vdev->v4l2_dev->mdev &&
+		    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF ||
+		     cmd == VIDIOC_S_EXT_CTRLS || cmd == VIDIOC_TRY_EXT_CTRLS))
+			queue_lock = &vdev->v4l2_dev->mdev->req_queue_mutex;
+
+		if (queue_lock && mutex_lock_interruptible(queue_lock))
+			return -ERESTARTSYS;
+
+		if (lock && mutex_lock_interruptible(lock)) {
+			if (queue_lock)
+				mutex_unlock(queue_lock);
 			return -ERESTARTSYS;
+		}
 		if (video_is_registered(vdev))
 			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
 		if (lock)
 			mutex_unlock(lock);
+		if (queue_lock)
+			mutex_unlock(queue_lock);
 	} else
 		ret = -ENOTTY;
 
@@ -442,8 +465,20 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	struct video_device *vdev = video_devdata(filp);
 	int ret = 0;
 
+	/*
+	 * We need to serialize the release() with queueing new requests.
+	 * The release() may trigger the cancellation of a streaming
+	 * operation, and that should not be mixed with queueing a new
+	 * request at the same time.
+	 */
+	if (vdev->v4l2_dev->mdev)
+		mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+
 	if (vdev->fops->release)
 		ret = vdev->fops->release(filp);
+
+	if (vdev->v4l2_dev->mdev)
+		mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		printk(KERN_DEBUG "%s: release\n",
 			video_device_node_name(vdev));
-- 
2.17.0
