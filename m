Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53633 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753059AbeENL4N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:56:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [RFC PATCH 5/6] videobuf2: assume q->lock is always set
Date: Mon, 14 May 2018 13:56:01 +0200
Message-Id: <20180514115602.9791-6-hverkuil@xs4all.nl>
In-Reply-To: <20180514115602.9791-1-hverkuil@xs4all.nl>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Drop checks for q->lock. Drop calls to wait_finish/prepare, just lock/unlock
q->lock.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 .../media/common/videobuf2/videobuf2-core.c   | 21 ++++++---------
 .../media/common/videobuf2/videobuf2-v4l2.c   | 27 +++++--------------
 include/media/videobuf2-core.h                |  2 --
 3 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 3b89ec5e0b2f..8ca279a43549 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -462,8 +462,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	 * counters to the kernel log.
 	 */
 	if (q->num_buffers) {
-		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
-				  q->cnt_wait_prepare != q->cnt_wait_finish;
+		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming;
 
 		if (unbalanced || debug) {
 			pr_info("counters for queue %p:%s\n", q,
@@ -471,12 +470,8 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("     setup: %u start_streaming: %u stop_streaming: %u\n",
 				q->cnt_queue_setup, q->cnt_start_streaming,
 				q->cnt_stop_streaming);
-			pr_info("     wait_prepare: %u wait_finish: %u\n",
-				q->cnt_wait_prepare, q->cnt_wait_finish);
 		}
 		q->cnt_queue_setup = 0;
-		q->cnt_wait_prepare = 0;
-		q->cnt_wait_finish = 0;
 		q->cnt_start_streaming = 0;
 		q->cnt_stop_streaming = 0;
 	}
@@ -1484,10 +1479,10 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 
 		/*
 		 * We are streaming and blocking, wait for another buffer to
-		 * become ready or for streamoff. Driver's lock is released to
+		 * become ready or for streamoff. The queue's lock is released to
 		 * allow streamoff or qbuf to be called while waiting.
 		 */
-		call_void_qop(q, wait_prepare, q);
+		mutex_unlock(q->lock);
 
 		/*
 		 * All locks have been released, it is safe to sleep now.
@@ -1501,7 +1496,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 * We need to reevaluate both conditions again after reacquiring
 		 * the locks or return an error if one occurred.
 		 */
-		call_void_qop(q, wait_finish, q);
+		mutex_lock(q->lock);
 		if (ret) {
 			dprintk(1, "sleep was interrupted\n");
 			return ret;
@@ -2528,10 +2523,10 @@ static int vb2_thread(void *data)
 			vb = q->bufs[index++];
 			prequeue--;
 		} else {
-			call_void_qop(q, wait_finish, q);
+			mutex_lock(q->lock);
 			if (!threadio->stop)
 				ret = vb2_core_dqbuf(q, &index, NULL, 0);
-			call_void_qop(q, wait_prepare, q);
+			mutex_unlock(q->lock);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 			if (!ret)
 				vb = q->bufs[index];
@@ -2543,12 +2538,12 @@ static int vb2_thread(void *data)
 		if (vb->state != VB2_BUF_STATE_ERROR)
 			if (threadio->fnc(vb, threadio->priv))
 				break;
-		call_void_qop(q, wait_finish, q);
+		mutex_lock(q->lock);
 		if (copy_timestamp)
 			vb->timestamp = ktime_get_ns();
 		if (!threadio->stop)
 			ret = vb2_core_qbuf(q, vb->index, NULL);
-		call_void_qop(q, wait_prepare, q);
+		mutex_unlock(q->lock);
 		if (ret || threadio->stop)
 			break;
 	}
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 886a2d8d5c6c..7d2172468f72 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -852,9 +852,8 @@ EXPORT_SYMBOL_GPL(_vb2_fop_release);
 int vb2_fop_release(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 
-	return _vb2_fop_release(file, lock);
+	return _vb2_fop_release(file, vdev->queue->lock);
 }
 EXPORT_SYMBOL_GPL(vb2_fop_release);
 
@@ -862,12 +861,11 @@ ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 	int err = -EBUSY;
 
 	if (!(vdev->queue->io_modes & VB2_WRITE))
 		return -EINVAL;
-	if (lock && mutex_lock_interruptible(lock))
+	if (mutex_lock_interruptible(vdev->queue->lock))
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
@@ -876,8 +874,7 @@ ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
-	if (lock)
-		mutex_unlock(lock);
+	mutex_unlock(vdev->queue->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_write);
@@ -886,12 +883,11 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 	int err = -EBUSY;
 
 	if (!(vdev->queue->io_modes & VB2_READ))
 		return -EINVAL;
-	if (lock && mutex_lock_interruptible(lock))
+	if (mutex_lock_interruptible(vdev->queue->lock))
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
@@ -900,8 +896,7 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
-	if (lock)
-		mutex_unlock(lock);
+	mutex_unlock(vdev->queue->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_read);
@@ -910,17 +905,10 @@ __poll_t vb2_fop_poll(struct file *file, poll_table *wait)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *q = vdev->queue;
-	struct mutex *lock = q->lock ? q->lock : vdev->lock;
 	__poll_t res;
 	void *fileio;
 
-	/*
-	 * If this helper doesn't know how to lock, then you shouldn't be using
-	 * it but you should write your own.
-	 */
-	WARN_ON(!lock);
-
-	if (lock && mutex_lock_interruptible(lock))
+	if (mutex_lock_interruptible(q->lock))
 		return EPOLLERR;
 
 	fileio = q->fileio;
@@ -930,8 +918,7 @@ __poll_t vb2_fop_poll(struct file *file, poll_table *wait)
 	/* If fileio was started, then we have a new queue owner. */
 	if (!fileio && q->fileio)
 		q->owner = file->private_data;
-	if (lock)
-		mutex_unlock(lock);
+	mutex_unlock(q->lock);
 	return res;
 }
 EXPORT_SYMBOL_GPL(vb2_fop_poll);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f6818f732f34..d4e557b4f820 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -565,8 +565,6 @@ struct vb2_queue {
 	 * called. Used to check for unbalanced ops.
 	 */
 	u32				cnt_queue_setup;
-	u32				cnt_wait_prepare;
-	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
 	u32				cnt_stop_streaming;
 #endif
-- 
2.17.0
