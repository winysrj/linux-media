Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaDUM3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 20/26] omap3isp: Move queue mutex to isp_video structure
Date: Mon, 21 Apr 2014 14:29:06 +0200
Message-Id: <1398083352-8451-21-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares for the move to videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 102 ++++++++---------------------
 drivers/media/platform/omap3isp/ispqueue.h |   2 -
 drivers/media/platform/omap3isp/ispvideo.c |  72 ++++++++++++++++----
 drivers/media/platform/omap3isp/ispvideo.h |   1 +
 4 files changed, 86 insertions(+), 91 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 515ed94..dcd9446 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -660,7 +660,6 @@ int omap3isp_video_queue_init(struct isp_video_queue *queue,
 			      struct device *dev, unsigned int bufsize)
 {
 	INIT_LIST_HEAD(&queue->queue);
-	mutex_init(&queue->lock);
 	spin_lock_init(&queue->irqlock);
 
 	queue->type = type;
@@ -712,18 +711,12 @@ int omap3isp_video_queue_reqbufs(struct isp_video_queue *queue,
 
 	nbuffers = min_t(unsigned int, nbuffers, ISP_VIDEO_MAX_BUFFERS);
 
-	mutex_lock(&queue->lock);
-
 	ret = isp_video_queue_alloc(queue, nbuffers, size, rb->memory);
 	if (ret < 0)
-		goto done;
+		return ret;
 
 	rb->count = ret;
-	ret = 0;
-
-done:
-	mutex_unlock(&queue->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -738,24 +731,17 @@ int omap3isp_video_queue_querybuf(struct isp_video_queue *queue,
 				  struct v4l2_buffer *vbuf)
 {
 	struct isp_video_buffer *buf;
-	int ret = 0;
 
 	if (vbuf->type != queue->type)
 		return -EINVAL;
 
-	mutex_lock(&queue->lock);
-
-	if (vbuf->index >= queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (vbuf->index >= queue->count)
+		return -EINVAL;
 
 	buf = queue->buffers[vbuf->index];
 	isp_video_buffer_query(buf, vbuf);
 
-done:
-	mutex_unlock(&queue->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -776,27 +762,25 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 {
 	struct isp_video_buffer *buf;
 	unsigned long flags;
-	int ret = -EINVAL;
+	int ret;
 
 	if (vbuf->type != queue->type)
-		goto done;
-
-	mutex_lock(&queue->lock);
+		return -EINVAL;
 
 	if (vbuf->index >= queue->count)
-		goto done;
+		return -EINVAL;
 
 	buf = queue->buffers[vbuf->index];
 
 	if (vbuf->memory != buf->vbuf.memory)
-		goto done;
+		return -EINVAL;
 
 	if (buf->state != ISP_BUF_STATE_IDLE)
-		goto done;
+		return -EINVAL;
 
 	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
 	    vbuf->length < buf->vbuf.length)
-		goto done;
+		return -EINVAL;
 
 	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
 	    vbuf->m.userptr != buf->vbuf.m.userptr) {
@@ -808,7 +792,7 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 	if (!buf->prepared) {
 		ret = isp_video_buffer_prepare(buf);
 		if (ret < 0)
-			goto done;
+			return ret;
 		buf->prepared = 1;
 	}
 
@@ -823,11 +807,7 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 		spin_unlock_irqrestore(&queue->irqlock, flags);
 	}
 
-	ret = 0;
-
-done:
-	mutex_unlock(&queue->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -853,17 +833,13 @@ int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
 	if (vbuf->type != queue->type)
 		return -EINVAL;
 
-	mutex_lock(&queue->lock);
-
-	if (list_empty(&queue->queue)) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (list_empty(&queue->queue))
+		return -EINVAL;
 
 	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
 	ret = isp_video_buffer_wait(buf, nonblocking);
 	if (ret < 0)
-		goto done;
+		return ret;
 
 	list_del(&buf->stream);
 
@@ -871,9 +847,7 @@ int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
 	buf->state = ISP_BUF_STATE_IDLE;
 	vbuf->flags &= ~V4L2_BUF_FLAG_QUEUED;
 
-done:
-	mutex_unlock(&queue->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -890,10 +864,8 @@ int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
 	struct isp_video_buffer *buf;
 	unsigned long flags;
 
-	mutex_lock(&queue->lock);
-
 	if (queue->streaming)
-		goto done;
+		return 0;
 
 	queue->streaming = 1;
 
@@ -902,8 +874,6 @@ int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
 		queue->ops->buffer_queue(buf);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-done:
-	mutex_unlock(&queue->lock);
 	return 0;
 }
 
@@ -923,10 +893,8 @@ void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
 	unsigned long flags;
 	unsigned int i;
 
-	mutex_lock(&queue->lock);
-
 	if (!queue->streaming)
-		goto done;
+		return;
 
 	queue->streaming = 0;
 
@@ -942,9 +910,6 @@ void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	INIT_LIST_HEAD(&queue->queue);
-
-done:
-	mutex_unlock(&queue->lock);
 }
 
 /**
@@ -963,10 +928,8 @@ void omap3isp_video_queue_discard_done(struct isp_video_queue *queue)
 	struct isp_video_buffer *buf;
 	unsigned int i;
 
-	mutex_lock(&queue->lock);
-
 	if (!queue->streaming)
-		goto done;
+		return;
 
 	for (i = 0; i < queue->count; ++i) {
 		buf = queue->buffers[i];
@@ -974,9 +937,6 @@ void omap3isp_video_queue_discard_done(struct isp_video_queue *queue)
 		if (buf->state == ISP_BUF_STATE_DONE)
 			buf->state = ISP_BUF_STATE_ERROR;
 	}
-
-done:
-	mutex_unlock(&queue->lock);
 }
 
 static void isp_video_queue_vm_open(struct vm_area_struct *vma)
@@ -1014,26 +974,20 @@ int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
 	unsigned int i;
 	int ret = 0;
 
-	mutex_lock(&queue->lock);
-
 	for (i = 0; i < queue->count; ++i) {
 		buf = queue->buffers[i];
 		if ((buf->vbuf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
 			break;
 	}
 
-	if (i == queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (i == queue->count)
+		return -EINVAL;
 
 	size = vma->vm_end - vma->vm_start;
 
 	if (buf->vbuf.memory != V4L2_MEMORY_MMAP ||
-	    size != PAGE_ALIGN(buf->vbuf.length)) {
-		ret = -EINVAL;
-		goto done;
-	}
+	    size != PAGE_ALIGN(buf->vbuf.length))
+		return -EINVAL;
 
 	/* dma_mmap_coherent() uses vm_pgoff as an offset inside the buffer
 	 * while we used it to identify the buffer and want to map the whole
@@ -1043,16 +997,14 @@ int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
 
 	ret = dma_mmap_coherent(queue->dev, vma, buf->vaddr, buf->dma, size);
 	if (ret < 0)
-		goto done;
+		return ret;
 
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &isp_video_queue_vm_ops;
 	vma->vm_private_data = buf;
 	isp_video_queue_vm_open(vma);
 
-done:
-	mutex_unlock(&queue->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -1070,7 +1022,6 @@ unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
 	struct isp_video_buffer *buf;
 	unsigned int mask = 0;
 
-	mutex_lock(&queue->lock);
 	if (list_empty(&queue->queue)) {
 		mask |= POLLERR;
 		goto done;
@@ -1087,6 +1038,5 @@ unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
 	}
 
 done:
-	mutex_unlock(&queue->lock);
 	return mask;
 }
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 27189bb..ecff055 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -132,7 +132,6 @@ struct isp_video_queue_operations {
  * @bufsize: Size of a driver-specific buffer object
  * @count: Number of currently allocated buffers
  * @buffers: ISP video buffers
- * @lock: Mutex to protect access to the buffers, main queue and state
  * @irqlock: Spinlock to protect access to the IRQ queue
  * @streaming: Queue state, indicates whether the queue is streaming
  * @queue: List of all queued buffers
@@ -145,7 +144,6 @@ struct isp_video_queue {
 
 	unsigned int count;
 	struct isp_video_buffer *buffers[ISP_VIDEO_MAX_BUFFERS];
-	struct mutex lock;
 	spinlock_t irqlock;
 
 	unsigned int streaming:1;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a7ef081..12b0f8c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -555,8 +555,11 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 {
 	struct isp_buffer *buf = NULL;
 
-	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		mutex_lock(&video->queue_lock);
 		omap3isp_video_queue_discard_done(video->queue);
+		mutex_unlock(&video->queue_lock);
+	}
 
 	if (!list_empty(&video->dmaqueue)) {
 		buf = list_first_entry(&video->dmaqueue,
@@ -768,33 +771,57 @@ static int
 isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_reqbufs(&vfh->queue, rb);
+	mutex_unlock(&video->queue_lock);
 
-	return omap3isp_video_queue_reqbufs(&vfh->queue, rb);
+	return ret;
 }
 
 static int
 isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	int ret;
 
-	return omap3isp_video_queue_querybuf(&vfh->queue, b);
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_querybuf(&vfh->queue, b);
+	mutex_unlock(&video->queue_lock);
+
+	return ret;
 }
 
 static int
 isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_qbuf(&vfh->queue, b);
+	mutex_unlock(&video->queue_lock);
 
-	return omap3isp_video_queue_qbuf(&vfh->queue, b);
+	return ret;
 }
 
 static int
 isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_dqbuf(&vfh->queue, b,
+					 file->f_flags & O_NONBLOCK);
+	mutex_unlock(&video->queue_lock);
 
-	return omap3isp_video_queue_dqbuf(&vfh->queue, b,
-					  file->f_flags & O_NONBLOCK);
+	return ret;
 }
 
 static int isp_video_check_external_subdevs(struct isp_video *video,
@@ -997,7 +1024,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	INIT_LIST_HEAD(&video->dmaqueue);
 	atomic_set(&pipe->frame_number, -1);
 
+	mutex_lock(&video->queue_lock);
 	ret = omap3isp_video_queue_streamon(&vfh->queue);
+	mutex_unlock(&video->queue_lock);
 	if (ret < 0)
 		goto err_check_format;
 
@@ -1022,7 +1051,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_set_stream:
+	mutex_lock(&video->queue_lock);
 	omap3isp_video_queue_streamoff(&vfh->queue);
+	mutex_unlock(&video->queue_lock);
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
 err_pipeline_start:
@@ -1058,9 +1089,9 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	mutex_lock(&video->stream_lock);
 
 	/* Make sure we're not streaming yet. */
-	mutex_lock(&vfh->queue.lock);
+	mutex_lock(&video->queue_lock);
 	streaming = vfh->queue.streaming;
-	mutex_unlock(&vfh->queue.lock);
+	mutex_unlock(&video->queue_lock);
 
 	if (!streaming)
 		goto done;
@@ -1079,7 +1110,9 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	/* Stop the stream. */
 	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
+	mutex_lock(&video->queue_lock);
 	omap3isp_video_queue_streamoff(&vfh->queue);
+	mutex_unlock(&video->queue_lock);
 	video->queue = NULL;
 	video->streaming = 0;
 	video->error = false;
@@ -1201,9 +1234,9 @@ static int isp_video_release(struct file *file)
 	/* Disable streaming and free the buffers queue resources. */
 	isp_video_streamoff(file, vfh, video->type);
 
-	mutex_lock(&handle->queue.lock);
+	mutex_lock(&video->queue_lock);
 	omap3isp_video_queue_cleanup(&handle->queue);
-	mutex_unlock(&handle->queue.lock);
+	mutex_unlock(&video->queue_lock);
 
 	omap3isp_pipeline_pm_use(&video->video.entity, 0);
 
@@ -1220,16 +1253,27 @@ static int isp_video_release(struct file *file)
 static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
-	struct isp_video_queue *queue = &vfh->queue;
+	struct isp_video *video = video_drvdata(file);
+	int ret;
 
-	return omap3isp_video_queue_poll(queue, file, wait);
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_poll(&vfh->queue, file, wait);
+	mutex_unlock(&video->queue_lock);
+
+	return ret;
 }
 
 static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
+	struct isp_video *video = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&video->queue_lock);
+	ret = omap3isp_video_queue_mmap(&vfh->queue, vma);
+	mutex_unlock(&video->queue_lock);
 
-	return omap3isp_video_queue_mmap(&vfh->queue, vma);
+	return ret;
 }
 
 static struct v4l2_file_operations isp_video_fops = {
@@ -1279,6 +1323,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 
 	spin_lock_init(&video->pipe.lock);
 	mutex_init(&video->stream_lock);
+	mutex_init(&video->queue_lock);
 
 	/* Initialize the video device. */
 	if (video->ops == NULL)
@@ -1300,6 +1345,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 void omap3isp_video_cleanup(struct isp_video *video)
 {
 	media_entity_cleanup(&video->video.entity);
+	mutex_destroy(&video->queue_lock);
 	mutex_destroy(&video->stream_lock);
 	mutex_destroy(&video->mutex);
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4e19407..254e7d2 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -182,6 +182,7 @@ struct isp_video {
 
 	/* Video buffers queue */
 	struct isp_video_queue *queue;
+	struct mutex queue_lock;	/* protects the queue */
 	struct list_head dmaqueue;
 	enum isp_video_dmaqueue_flags dmaqueue_flags;
 
-- 
1.8.3.2

