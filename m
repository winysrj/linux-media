Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45464 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752755AbeFDLrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv15 07/35] v4l2-dev: lock req_queue_mutex
Date: Mon,  4 Jun 2018 13:46:20 +0200
Message-Id: <20180604114648.26159-8-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
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

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 13 +++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c | 22 +++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 4ffd7d60a901..d23e82ab1e27 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -444,8 +444,21 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	struct video_device *vdev = video_devdata(filp);
 	int ret = 0;
 
+	/*
+	 * We need to serialize the release() with queueing new requests.
+	 * The release() may trigger the cancellation of a streaming
+	 * operation, and that should not be mixed with queueing a new
+	 * request at the same time.
+	 */
+	if (v4l2_device_supports_requests(vdev->v4l2_dev))
+		mutex_lock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+
 	if (vdev->fops->release)
 		ret = vdev->fops->release(filp);
+
+	if (v4l2_device_supports_requests(vdev->v4l2_dev))
+		mutex_unlock(&vdev->v4l2_dev->mdev->req_queue_mutex);
+
 	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		dprintk("%s: release\n",
 			video_device_node_name(vdev));
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 965fd301f617..27a893aa0664 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2714,6 +2714,7 @@ static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
+	struct mutex *req_queue_lock = NULL;
 	struct mutex *lock; /* ioctl serialization mutex */
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool write_only = false;
@@ -2733,10 +2734,27 @@ static long __video_do_ioctl(struct file *file,
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
 		vfh = file->private_data;
 
+	/*
+	 * We need to serialize streamon/off with queueing new requests.
+	 * These ioctls may trigger the cancellation of a streaming
+	 * operation, and that should not be mixed with queueing a new
+	 * request at the same time.
+	 */
+	if (v4l2_device_supports_requests(vfd->v4l2_dev) &&
+	    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF)) {
+		req_queue_lock = &vfd->v4l2_dev->mdev->req_queue_mutex;
+
+		if (req_queue_lock && mutex_lock_interruptible(req_queue_lock))
+			return -ERESTARTSYS;
+	}
+
 	lock = v4l2_ioctl_get_lock(vfd, cmd);
 
-	if (lock && mutex_lock_interruptible(lock))
+	if (lock && mutex_lock_interruptible(lock)) {
+		if (req_queue_lock)
+			mutex_unlock(req_queue_lock);
 		return -ERESTARTSYS;
+	}
 
 	if (!video_is_registered(vfd)) {
 		ret = -ENODEV;
@@ -2795,6 +2813,8 @@ static long __video_do_ioctl(struct file *file,
 unlock:
 	if (lock)
 		mutex_unlock(lock);
+	if (req_queue_lock)
+		mutex_unlock(req_queue_lock);
 	return ret;
 }
 
-- 
2.17.0
