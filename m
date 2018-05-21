Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:21564 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbeEUIzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 09/36] v4l2-dev: lock req_queue_mutex
Date: Mon, 21 May 2018 11:54:34 +0300
Message-Id: <20180521085501.16861-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

We need to serialize streamon/off with queueing new requests.
These ioctls may trigger the cancellation of a streaming
operation, and that should not be mixed with queuing a new
request at the same time.

Finally close() needs this lock since that too can trigger the
cancellation of a streaming operation.

We take the req_queue_mutex here before any other locks since
it is a very high-level lock.

[Sakari Ailus: No longer acquire req_queue_mutex for controls]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c4f4357e9ca41..8d4b55ac00f94 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -361,13 +361,35 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
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
+		    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF))
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
 
@@ -450,8 +472,20 @@ static int v4l2_release(struct inode *inode, struct file *filp)
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
 		dprintk("%s: release\n",
 			video_device_node_name(vdev));
-- 
2.11.0
