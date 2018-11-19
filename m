Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59207 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbeKSVcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 3/4] vb2 core: add new queue_setup_lock/unlock ops
Date: Mon, 19 Nov 2018 12:09:02 +0100
Message-Id: <20181119110903.24383-4-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-1-hverkuil@xs4all.nl>
References: <20181119110903.24383-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If queue->lock is different from the video_device lock, then
you need to serialize queue_setup with VIDIOC_S_FMT, and this
should be done by the driver.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 .../media/common/videobuf2/videobuf2-core.c   | 51 +++++++++++++------
 include/media/videobuf2-core.h                | 19 +++++++
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f7e7e633bcd7..269485920beb 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -465,7 +465,8 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	 */
 	if (q->num_buffers) {
 		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
-				  q->cnt_wait_prepare != q->cnt_wait_finish;
+				  q->cnt_wait_prepare != q->cnt_wait_finish ||
+				  q->cnt_queue_setup_lock != q->cnt_queue_setup_unlock;
 
 		if (unbalanced || debug) {
 			pr_info("counters for queue %p:%s\n", q,
@@ -473,10 +474,14 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("     setup: %u start_streaming: %u stop_streaming: %u\n",
 				q->cnt_queue_setup, q->cnt_start_streaming,
 				q->cnt_stop_streaming);
+			pr_info("     queue_setup_lock: %u queue_setup_unlock: %u\n",
+				q->cnt_queue_setup_lock, q->cnt_queue_setup_unlock);
 			pr_info("     wait_prepare: %u wait_finish: %u\n",
 				q->cnt_wait_prepare, q->cnt_wait_finish);
 		}
 		q->cnt_queue_setup = 0;
+		q->cnt_queue_setup_lock = 0;
+		q->cnt_queue_setup_unlock = 0;
 		q->cnt_wait_prepare = 0;
 		q->cnt_wait_finish = 0;
 		q->cnt_start_streaming = 0;
@@ -717,6 +722,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 	q->memory = memory;
+	call_void_qop(q, queue_setup_lock, q);
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -725,22 +731,27 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 		       plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	/* Check that driver has set sane values */
-	if (WARN_ON(!num_planes))
-		return -EINVAL;
+	if (WARN_ON(!num_planes)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	for (i = 0; i < num_planes; i++)
-		if (WARN_ON(!plane_sizes[i]))
-			return -EINVAL;
+		if (WARN_ON(!plane_sizes[i])) {
+			ret = -EINVAL;
+			goto unlock;
+		}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 
 	/*
@@ -775,19 +786,19 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		 */
 	}
 
-	mutex_lock(&q->mmap_lock);
 	q->num_buffers = allocated_buffers;
+	call_void_qop(q, queue_setup_unlock, q);
 
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
 		 * from q->num_buffers.
 		 */
+		mutex_lock(&q->mmap_lock);
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
 		return ret;
 	}
-	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Return the number of successfully allocated buffers
@@ -795,8 +806,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 */
 	*count = allocated_buffers;
 	q->waiting_for_buffers = !q->is_output;
-
 	return 0;
+
+unlock:
+	call_void_qop(q, queue_setup_unlock, q);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
@@ -813,10 +827,12 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -ENOBUFS;
 	}
 
+	call_void_qop(q, queue_setup_lock, q);
 	if (!q->num_buffers) {
 		if (q->waiting_in_dqbuf && *count) {
 			dprintk(1, "another dup()ped fd is waiting for a buffer\n");
-			return -EBUSY;
+			ret = -EBUSY;
+			goto unlock;
 		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
@@ -837,14 +853,15 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers,
 		       &num_planes, plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 
 	/*
@@ -869,19 +886,19 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		 */
 	}
 
-	mutex_lock(&q->mmap_lock);
 	q->num_buffers += allocated_buffers;
+	call_void_qop(q, queue_setup_unlock, q);
 
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
 		 * from q->num_buffers.
 		 */
+		mutex_lock(&q->mmap_lock);
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
 		return -ENOMEM;
 	}
-	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Return the number of successfully allocated buffers
@@ -890,6 +907,10 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	*count = allocated_buffers;
 
 	return 0;
+
+unlock:
+	call_void_qop(q, queue_setup_unlock, q);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 613f22910174..92861b6fe7f8 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -333,6 +333,20 @@ struct vb2_buffer {
  *			\*num_buffers are being allocated additionally to
  *			q->num_buffers. If either \*num_planes or the requested
  *			sizes are invalid callback must return %-EINVAL.
+ * @queue_setup_lock:	called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
+ *			to serialize @queue_setup with ioctls like
+ *			VIDIOC_S_FMT() that change the buffer size. Only
+ *			required if queue->lock differs from the mutex that is
+ *			used to serialize the ioctls that change the buffer
+ *			size. This callback should lock the ioctl serialization
+ *			mutex.
+ * @queue_setup_unlock:	called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
+ *			to serialize @queue_setup with ioctls like
+ *			VIDIOC_S_FMT() that change the buffer size. Only
+ *			required if queue->lock differs from the mutex that is
+ *			used to serialize the ioctls that change the buffer
+ *			size. This callback should unlock the ioctl
+ *			serialization mutex.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
@@ -403,10 +417,13 @@ struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], struct device *alloc_devs[]);
+	void (*queue_setup_lock)(struct vb2_queue *q);
+	void (*queue_setup_unlock)(struct vb2_queue *q);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
+
 	int (*buf_init)(struct vb2_buffer *vb);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	void (*buf_finish)(struct vb2_buffer *vb);
@@ -599,6 +616,8 @@ struct vb2_queue {
 	 * called. Used to check for unbalanced ops.
 	 */
 	u32				cnt_queue_setup;
+	u32				cnt_queue_setup_lock;
+	u32				cnt_queue_setup_unlock;
 	u32				cnt_wait_prepare;
 	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
-- 
2.19.1
