Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2354 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaCDKnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 12/18] vb2: only call start_streaming if sufficient buffers are queued
Date: Tue,  4 Mar 2014 11:42:20 +0100
Message-Id: <1393929746-39437-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In commit 02f142ecd24aaf891324ffba8527284c1731b561 support was added to
start_streaming to return -ENOBUFS if insufficient buffers were queued
for the DMA engine to start. The vb2 core would attempt calling
start_streaming again if another buffer would be queued up.

Later analysis uncovered problems with the queue management if start_streaming
would return an error: the buffers are enqueued to the driver before the
start_streaming op is called, so after an error they are never returned to
the vb2 core. The solution for this is to let the driver return them to
the vb2 core in case of an error while starting the DMA engine. However,
in the case of -ENOBUFS that would be weird: it is not a real error, it
just says that more buffers are needed. Requiring start_streaming to give
them back only to have them requeued again the next time the application
calls QBUF is inefficient.

This patch changes this mechanism: it adds a 'min_buffers_needed' field
to vb2_queue that drivers can set with the minimum number of buffers
required to start the DMA engine. The start_streaming op is only called
if enough buffers are queued. The -ENOBUFS handling has been dropped in
favor of this new method.

Drivers are expected to return buffers back to vb2 core with state QUEUED
if start_streaming would return an error. The vb2 core checks for this
and produces a warning if that didn't happen and it will forcefully
reclaim such buffers to ensure that the internal vb2 core state remains
consistent and all buffer-related resources have been correctly freed
and all op calls have been balanced.

__reqbufs() has been updated to check that at least min_buffers_needed
buffers could be allocated. If fewer buffers were allocated then __reqbufs
will free what was allocated and return -ENOMEM. Based on a suggestion from
Pawel Osciak.

__create_bufs() doesn't do that check, since the use of __create_bufs
assumes some advance scenario where the user might want more control.
Instead streamon will check if enough buffers were allocated to prevent
streaming with fewer than the minimum required number of buffers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpbe_display.c   |   6 +-
 drivers/media/platform/davinci/vpif_capture.c   |   7 +-
 drivers/media/platform/davinci/vpif_display.c   |   7 +-
 drivers/media/platform/s5p-tv/mixer_video.c     |   6 +-
 drivers/media/v4l2-core/videobuf2-core.c        | 146 ++++++++++++++++--------
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   3 +-
 include/media/videobuf2-core.h                  |  14 ++-
 7 files changed, 116 insertions(+), 73 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index b02aba4..9231e48 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -344,11 +344,6 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	int ret;
 
-	/* If buffer queue is empty, return error */
-	if (list_empty(&layer->dma_queue)) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
-		return -ENOBUFS;
-	}
 	/* Get the next frame from the buffer queue */
 	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
 				struct vpbe_disp_buffer, list);
@@ -1416,6 +1411,7 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 1;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 735ec47..9731ad4 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -272,13 +272,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long flags;
 	int ret;
 
-	/* If buffer queue is empty, return error */
 	spin_lock_irqsave(&common->irqlock, flags);
-	if (list_empty(&common->dma_queue)) {
-		spin_unlock_irqrestore(&common->irqlock, flags);
-		vpif_dbg(1, debug, "buffer queue is empty\n");
-		return -ENOBUFS;
-	}
 
 	/* Get the next frame from the buffer queue */
 	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
@@ -1024,6 +1018,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 1;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 9d115cd..af660f5 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -234,13 +234,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long flags;
 	int ret;
 
-	/* If buffer queue is empty, return error */
 	spin_lock_irqsave(&common->irqlock, flags);
-	if (list_empty(&common->dma_queue)) {
-		spin_unlock_irqrestore(&common->irqlock, flags);
-		vpif_err("buffer queue is empty\n");
-		return -ENOBUFS;
-	}
 
 	/* Get the next frame from the buffer queue */
 	common->next_frm = common->cur_frm =
@@ -984,6 +978,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 1;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index c5059ba..a1ce55f 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -946,11 +946,6 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	mxr_dbg(mdev, "%s\n", __func__);
 
-	if (count == 0) {
-		mxr_dbg(mdev, "no output buffers queued\n");
-		return -ENOBUFS;
-	}
-
 	/* block any changes in output configuration */
 	mxr_output_get(mdev);
 
@@ -1124,6 +1119,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 		.drv_priv = layer,
 		.buf_struct_size = sizeof(struct mxr_buffer),
 		.ops = &mxr_video_qops,
+		.min_buffers_needed = 1,
 		.mem_ops = &vb2_dma_contig_memops,
 	};
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 07cce7f..1f6eccf 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -805,6 +805,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Make sure the requested values and current defaults are sane.
 	 */
 	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
+	num_buffers = max_t(unsigned int, req->count, q->min_buffers_needed);
 	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
 	q->memory = req->memory;
@@ -828,9 +829,16 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	}
 
 	/*
+	 * There is no point in continuing if we can't allocate the minimum
+	 * number of buffers needed by this vb2_queue.
+	 */
+	if (allocated_buffers < q->min_buffers_needed)
+		ret = -ENOMEM;
+
+	/*
 	 * Check if driver can handle the allocated number of buffers.
 	 */
-	if (allocated_buffers < num_buffers) {
+	if (!ret && allocated_buffers < num_buffers) {
 		num_buffers = allocated_buffers;
 
 		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
@@ -1038,13 +1046,20 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
  * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
- *		or VB2_BUF_STATE_ERROR if the operation finished with an error
+ *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
+ *		If start_streaming fails then it should return buffers with state
+ *		VB2_BUF_STATE_QUEUED to put them back into the queue.
  *
  * This function should be called by the driver after a hardware operation on
  * a buffer is finished and the buffer may be returned to userspace. The driver
  * cannot use this buffer anymore until it is queued back to it by videobuf
  * by the means of buf_queue callback. Only buffers previously queued to the
  * driver by buf_queue can be passed to this function.
+ *
+ * While streaming a buffer can only be returned in state DONE or ERROR.
+ * The start_streaming op can also return them in case the DMA engine cannot
+ * be started for some reason. In that case the buffers should be returned with
+ * state QUEUED.
  */
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
@@ -1052,11 +1067,17 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	unsigned long flags;
 	unsigned int plane;
 
-	if (vb->state != VB2_BUF_STATE_ACTIVE)
+	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
 
-	if (state != VB2_BUF_STATE_DONE && state != VB2_BUF_STATE_ERROR)
-		return;
+	if (!q->start_streaming_called) {
+		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
+			state = VB2_BUF_STATE_QUEUED;
+	} else if (!WARN_ON(!q->start_streaming_called)) {
+		if (WARN_ON(state != VB2_BUF_STATE_DONE &&
+			    state != VB2_BUF_STATE_ERROR))
+			state = VB2_BUF_STATE_ERROR;
+	}
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -1075,10 +1096,14 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
 	vb->state = state;
-	list_add_tail(&vb->done_entry, &q->done_list);
+	if (state != VB2_BUF_STATE_QUEUED)
+		list_add_tail(&vb->done_entry, &q->done_list);
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
+	if (state == VB2_BUF_STATE_QUEUED)
+		return;
+
 	/* Inform any processes that may be waiting for buffers */
 	wake_up(&q->done_wq);
 }
@@ -1549,34 +1574,49 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
  *
- * If there are not enough buffers, then retry_start_streaming is set to
- * 1 and 0 is returned. The next time a buffer is queued and
- * retry_start_streaming is 1, this function will be called again to
- * retry starting the DMA engine.
+ * Attempt to start streaming. When this function is called there must be
+ * at least q->min_buffers_needed buffers queued up (i.e. the minimum
+ * number of buffers required for the DMA engine to function). If the
+ * @start_streaming op fails it is supposed to return all the driver-owned
+ * buffers back to vb2 in state QUEUED. Check if that happened and if
+ * not warn and reclaim them forcefully.
  */
 static int vb2_start_streaming(struct vb2_queue *q)
 {
+	struct vb2_buffer *vb;
 	int ret;
 
-	/* Tell the driver to start streaming */
-	ret = call_qop(q, start_streaming, q, atomic_read(&q->owned_by_drv_count));
-	if (ret)
-		fail_qop(q, start_streaming);
-
 	/*
-	 * If there are not enough buffers queued to start streaming, then
-	 * the start_streaming operation will return -ENOBUFS and you have to
-	 * retry when the next buffer is queued.
+	 * If any buffers were queued before streamon,
+	 * we can now pass them to driver for processing.
 	 */
-	if (ret == -ENOBUFS) {
-		dprintk(1, "qbuf: not enough buffers, retry when more buffers are queued.\n");
-		q->retry_start_streaming = 1;
+	list_for_each_entry(vb, &q->queued_list, queued_entry)
+		__enqueue_in_driver(vb);
+
+	/* Tell the driver to start streaming */
+	ret = call_qop(q, start_streaming, q,
+		       atomic_read(&q->owned_by_drv_count));
+	q->start_streaming_called = ret == 0;
+	if (!ret)
 		return 0;
+
+	fail_qop(q, start_streaming);
+	dprintk(1, "qbuf: driver refused to start streaming\n");
+	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
+		unsigned i;
+
+		/*
+		 * Forcefully reclaim buffers if the driver did not
+		 * correctly return them to vb2.
+		 */
+		for (i = 0; i < q->num_buffers; ++i) {
+			vb = q->bufs[i];
+			if (vb->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED);
+		}
+		/* Must be zero now */
+		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
-	if (ret)
-		dprintk(1, "qbuf: driver refused to start streaming\n");
-	else
-		q->retry_start_streaming = 0;
 	return ret;
 }
 
@@ -1612,19 +1652,27 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * dequeued in dqbuf.
 	 */
 	list_add_tail(&vb->queued_entry, &q->queued_list);
+	q->queued_count++;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
 	/*
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
-	if (q->streaming)
+	if (q->start_streaming_called)
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
 
-	if (q->retry_start_streaming) {
+	/*
+	 * If streamon has been called, and we haven't yet called
+	 * start_streaming() since not enough buffers were queued, and
+	 * we now have reached the minimum number of queued buffers,
+	 * then we can finally call start_streaming().
+	 */
+	if (q->streaming && !q->start_streaming_called &&
+	    q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
 		if (ret)
 			return ret;
@@ -1779,7 +1827,7 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
 		return -EINVAL;
 	}
 
-	if (!q->retry_start_streaming)
+	if (q->start_streaming_called)
 		wait_event(q->done_wq, !atomic_read(&q->owned_by_drv_count));
 	return 0;
 }
@@ -1840,6 +1888,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
+	q->queued_count--;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
@@ -1890,18 +1939,23 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
 
-	if (q->retry_start_streaming) {
-		q->retry_start_streaming = 0;
-		q->streaming = 0;
-	}
-
 	/*
 	 * Tell driver to stop all transactions and release all queued
 	 * buffers.
 	 */
-	if (q->streaming)
+	if (q->start_streaming_called)
 		call_qop(q, stop_streaming, q);
 	q->streaming = 0;
+	q->start_streaming_called = 0;
+	q->queued_count = 0;
+
+	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
+		for (i = 0; i < q->num_buffers; ++i)
+			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+		/* Must be zero now */
+		WARN_ON(atomic_read(&q->owned_by_drv_count));
+	}
 
 	/*
 	 * Remove all buffers from videobuf's list...
@@ -1937,7 +1991,6 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 
 static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	struct vb2_buffer *vb;
 	int ret;
 
 	if (type != q->type) {
@@ -1954,19 +2007,22 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		dprintk(1, "streamon: no buffers have been allocated\n");
 		return -EINVAL;
 	}
+	if (q->num_buffers < q->min_buffers_needed) {
+		dprintk(1, "streamon: need at least %u allocated buffers\n",
+				q->min_buffers_needed);
+		return -EINVAL;
+	}
 
 	/*
-	 * If any buffers were queued before streamon,
-	 * we can now pass them to driver for processing.
+	 * Tell driver to start streaming provided sufficient buffers
+	 * are available.
 	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
-		__enqueue_in_driver(vb);
-
-	/* Tell driver to start streaming. */
-	ret = vb2_start_streaming(q);
-	if (ret) {
-		__vb2_queue_cancel(q);
-		return ret;
+	if (q->queued_count >= q->min_buffers_needed) {
+		ret = vb2_start_streaming(q);
+		if (ret) {
+			__vb2_queue_cancel(q);
+			return ret;
+		}
 	}
 
 	q->streaming = 1;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 1f3b0f9..8c101cb 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1201,8 +1201,6 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long addr;
 	int ret;
 
-	if (count == 0)
-		return -ENOBUFS;
 	ret = mutex_lock_interruptible(&video->lock);
 	if (ret)
 		goto streamoff;
@@ -1327,6 +1325,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	q->type = req_buf->type;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = fh;
+	q->min_buffers_needed = 1;
 	q->ops = &video_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4f8dce2..8c9ab55 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -354,20 +354,24 @@ struct v4l2_fh;
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
  *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
+ * @min_buffers_needed: the minimum number of buffers needed before
+ *		start_streaming() can be called. Used when a DMA engine
+ *		cannot be started unless at least this number of buffers
+ *		have been queued into the driver.
  *
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
  * @queued_list: list of buffers currently queued from userspace
+ * @queued_count: number of buffers queued and ready for streaming.
  * @owned_by_drv_count: number of buffers owned by the driver
  * @done_list:	list of buffers ready to be dequeued to userspace
  * @done_lock:	lock to protect done_list list
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
  * @alloc_ctx:	memory type/allocator-specific contexts for each plane
  * @streaming:	current streaming state
- * @retry_start_streaming: start_streaming() was called, but there were not enough
- *		buffers queued. If set, then retry calling start_streaming when
- *		queuing a new buffer.
+ * @start_streaming_called: start_streaming() was called successfully and we
+ *		started streaming.
  * @fileio:	file io emulator internal data, used only if emulator is active
  */
 struct vb2_queue {
@@ -383,6 +387,7 @@ struct vb2_queue {
 	unsigned int			buf_struct_size;
 	u32				timestamp_type;
 	gfp_t				gfp_flags;
+	u32				min_buffers_needed;
 
 /* private: internal use only */
 	enum v4l2_memory		memory;
@@ -390,6 +395,7 @@ struct vb2_queue {
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
+	unsigned int			queued_count;
 
 	atomic_t			owned_by_drv_count;
 	struct list_head		done_list;
@@ -400,7 +406,7 @@ struct vb2_queue {
 	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
 
 	unsigned int			streaming:1;
-	unsigned int			retry_start_streaming:1;
+	unsigned int			start_streaming_called:1;
 
 	struct vb2_fileio_data		*fileio;
 
-- 
1.9.0

