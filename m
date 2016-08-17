Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34859
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbcHQS3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 14:29:21 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: [RFC PATCH 1/2] [media] vb2: defer sync buffers from vb2_buffer_done() with a workqueue
Date: Wed, 17 Aug 2016 14:28:56 -0400
Message-Id: <1471458537-16859-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
References: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_buffer_done() function can be called from interrupt context but it
currently calls the vb2 memory allocator .finish operation to sync buffers
and this can take a long time, so it's not suitable to be done there.

This patch defers part of the vb2_buffer_done() logic to a worker thread
to avoid doing the time consuming operation in interrupt context.

This will also allow to unmap the dmabuf as soon as possible once the buf
has been processed by the driver instead of waiting until user-space call
VIDIOC_DQBUF. Since the dmabuf unmap can sleep, it couldn't be done from
the vb2_buffer_done() function as it was before.

Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/v4l2-core/videobuf2-core.c | 81 +++++++++++++++++++++-----------
 include/media/videobuf2-core.h           |  5 ++
 2 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1dbd7beb71f0..14bed8acf3cf 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -315,6 +315,45 @@ static void __setup_offsets(struct vb2_buffer *vb)
 	}
 }
 
+static void vb2_done_work(struct work_struct *work)
+{
+	struct vb2_buffer *vb = container_of(work, struct vb2_buffer,
+					     done_work);
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned long flags;
+	unsigned int plane;
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+
+	spin_lock_irqsave(&q->done_lock, flags);
+	if (vb->state == VB2_BUF_STATE_QUEUED ||
+	    vb->state == VB2_BUF_STATE_REQUEUEING) {
+		vb->state = VB2_BUF_STATE_QUEUED;
+	} else {
+		/* Add the buffer to the done buffers list */
+		list_add_tail(&vb->done_entry, &q->done_list);
+	}
+	atomic_dec(&q->owned_by_drv_count);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	trace_vb2_buf_done(q, vb);
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_QUEUED:
+		break;
+	case VB2_BUF_STATE_REQUEUEING:
+		if (q->start_streaming_called)
+			__enqueue_in_driver(vb);
+		break;
+	default:
+		/* Inform any processes that may be waiting for buffers */
+		wake_up(&q->done_wq);
+		break;
+	}
+}
+
 /**
  * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
  * video buffer memory for all buffers/planes on the queue and initializes the
@@ -330,6 +369,10 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 	struct vb2_buffer *vb;
 	int ret;
 
+	q->vb2_workqueue = alloc_ordered_workqueue("vb2_wq", 0);
+	if (!q->vb2_workqueue)
+		return buffer;
+
 	for (buffer = 0; buffer < num_buffers; ++buffer) {
 		/* Allocate videobuf buffer structures */
 		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
@@ -344,6 +387,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		vb->index = q->num_buffers + buffer;
 		vb->type = q->type;
 		vb->memory = memory;
+		INIT_WORK(&vb->done_work, vb2_done_work);
+
 		for (plane = 0; plane < num_planes; ++plane) {
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
@@ -982,7 +1027,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
-	unsigned int plane;
 
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
@@ -1003,36 +1047,11 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-
 	spin_lock_irqsave(&q->done_lock, flags);
-	if (state == VB2_BUF_STATE_QUEUED ||
-	    state == VB2_BUF_STATE_REQUEUEING) {
-		vb->state = VB2_BUF_STATE_QUEUED;
-	} else {
-		/* Add the buffer to the done buffers list */
-		list_add_tail(&vb->done_entry, &q->done_list);
-		vb->state = state;
-	}
-	atomic_dec(&q->owned_by_drv_count);
+	vb->state = state;
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	trace_vb2_buf_done(q, vb);
-
-	switch (state) {
-	case VB2_BUF_STATE_QUEUED:
-		return;
-	case VB2_BUF_STATE_REQUEUEING:
-		if (q->start_streaming_called)
-			__enqueue_in_driver(vb);
-		return;
-	default:
-		/* Inform any processes that may be waiting for buffers */
-		wake_up(&q->done_wq);
-		break;
-	}
+	queue_work(q->vb2_workqueue, &vb->done_work);
 }
 EXPORT_SYMBOL_GPL(vb2_buffer_done);
 
@@ -1812,6 +1831,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (q->start_streaming_called)
 		call_void_qop(q, stop_streaming, q);
 
+	if (q->vb2_workqueue) {
+		flush_workqueue(q->vb2_workqueue);
+		destroy_workqueue(q->vb2_workqueue);
+		q->vb2_workqueue = NULL;
+	}
+
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * in stop_streaming(). See the stop_streaming() documentation in
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a4a9a55a0c42..dd765ef06cce 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -242,6 +242,9 @@ struct vb2_buffer {
 
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
+
+	struct work_struct	done_work;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these buffer-related ops are
@@ -523,6 +526,8 @@ struct vb2_queue {
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
 
+	struct workqueue_struct		*vb2_workqueue;
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
 	 * Counters for how often these queue-related ops are
-- 
2.5.5

