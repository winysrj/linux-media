Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:39625 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbBWUTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:19:43 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/3] media: omap3isp: ispvideo: drop driver specific isp_video_fh
Date: Mon, 23 Feb 2015 20:19:32 +0000
Message-Id: <1424722773-20131-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops driver specific isp_video_fh, as this
can be handled by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 128 +++++++++++------------------
 drivers/media/platform/omap3isp/ispvideo.h |  13 +--
 2 files changed, 49 insertions(+), 92 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 837018d..b648176 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -294,22 +294,22 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 }
 
 static int
-isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
+isp_video_check_format(struct isp_video *video)
 {
 	struct v4l2_format format;
 	int ret;
 
-	memcpy(&format, &vfh->format, sizeof(format));
+	memcpy(&format, &video->format, sizeof(format));
 	ret = __isp_video_get_format(video, &format);
 	if (ret < 0)
 		return ret;
 
-	if (vfh->format.fmt.pix.pixelformat != format.fmt.pix.pixelformat ||
-	    vfh->format.fmt.pix.height != format.fmt.pix.height ||
-	    vfh->format.fmt.pix.width != format.fmt.pix.width ||
-	    vfh->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
-	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage ||
-	    vfh->format.fmt.pix.field != format.fmt.pix.field)
+	if (video->format.fmt.pix.pixelformat != format.fmt.pix.pixelformat ||
+	    video->format.fmt.pix.height != format.fmt.pix.height ||
+	    video->format.fmt.pix.width != format.fmt.pix.width ||
+	    video->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
+	    video->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage ||
+	    video->format.fmt.pix.field != format.fmt.pix.field)
 		return -EINVAL;
 
 	return 0;
@@ -324,12 +324,11 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
-	struct isp_video *video = vfh->video;
+	struct isp_video *video = vb2_get_drv_priv(queue);
 
 	*num_planes = 1;
 
-	sizes[0] = vfh->format.fmt.pix.sizeimage;
+	sizes[0] = video->format.fmt.pix.sizeimage;
 	if (sizes[0] == 0)
 		return -EINVAL;
 
@@ -342,9 +341,8 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 
 static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
+	struct isp_video *video = vb2_get_drv_priv(buf->vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
-	struct isp_video *video = vfh->video;
 	dma_addr_t addr;
 
 	/* Refuse to prepare the buffer is the video node has registered an
@@ -363,7 +361,7 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
+	vb2_set_plane_payload(&buffer->vb, 0, video->format.fmt.pix.sizeimage);
 	buffer->dma = addr;
 
 	return 0;
@@ -380,9 +378,8 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
  */
 static void isp_video_buffer_queue(struct vb2_buffer *buf)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
+	struct isp_video *video = vb2_get_drv_priv(buf->vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
-	struct isp_video *video = vfh->video;
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	enum isp_pipeline_state state;
 	unsigned long flags;
@@ -573,7 +570,7 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 
 	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		mutex_lock(&video->queue_lock);
-		vb2_discard_done(video->queue);
+		vb2_discard_done(&video->queue);
 		mutex_unlock(&video->queue_lock);
 	}
 
@@ -615,14 +612,13 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 static int
 isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 
 	if (format->type != video->type)
 		return -EINVAL;
 
 	mutex_lock(&video->mutex);
-	*format = vfh->format;
+	*format = video->format;
 	mutex_unlock(&video->mutex);
 
 	return 0;
@@ -631,7 +627,6 @@ isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 static int
 isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	struct v4l2_mbus_framefmt fmt;
 
@@ -680,7 +675,7 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	isp_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
 
 	mutex_lock(&video->mutex);
-	vfh->format = *format;
+	video->format = *format;
 	mutex_unlock(&video->mutex);
 
 	return 0;
@@ -787,7 +782,6 @@ isp_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 static int
 isp_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 
 	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
@@ -797,7 +791,7 @@ isp_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 	memset(a, 0, sizeof(*a));
 	a->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
-	a->parm.output.timeperframe = vfh->timeperframe;
+	a->parm.output.timeperframe = video->timeperframe;
 
 	return 0;
 }
@@ -805,7 +799,6 @@ isp_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 static int
 isp_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 
 	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
@@ -815,7 +808,7 @@ isp_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 	if (a->parm.output.timeperframe.denominator == 0)
 		a->parm.output.timeperframe.denominator = 1;
 
-	vfh->timeperframe = a->parm.output.timeperframe;
+	video->timeperframe = a->parm.output.timeperframe;
 
 	return 0;
 }
@@ -823,12 +816,11 @@ isp_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
 static int
 isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_reqbufs(&vfh->queue, rb);
+	ret = vb2_reqbufs(&video->queue, rb);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -837,12 +829,11 @@ isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 static int
 isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_querybuf(&vfh->queue, b);
+	ret = vb2_querybuf(&video->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -851,12 +842,11 @@ isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 static int
 isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_qbuf(&vfh->queue, b);
+	ret = vb2_qbuf(&video->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -865,12 +855,11 @@ isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 static int
 isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(&video->queue, b, file->f_flags & O_NONBLOCK);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -1001,7 +990,6 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 static int
 isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	enum isp_pipeline_state state;
 	struct isp_pipeline *pipe;
@@ -1033,12 +1021,12 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
-	ret = isp_video_check_format(video, vfh);
+	ret = isp_video_check_format(video);
 	if (ret < 0)
 		goto err_check_format;
 
 	video->bpl_padding = ret;
-	video->bpl_value = vfh->format.fmt.pix.bytesperline;
+	video->bpl_value = video->format.fmt.pix.bytesperline;
 
 	ret = isp_video_get_graph_data(video, pipe);
 	if (ret < 0)
@@ -1065,15 +1053,14 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 * support the request limit.
 	 */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		pipe->max_timeperframe = vfh->timeperframe;
+		pipe->max_timeperframe = video->timeperframe;
 
-	video->queue = &vfh->queue;
 	INIT_LIST_HEAD(&video->dmaqueue);
 	atomic_set(&pipe->frame_number, -1);
-	pipe->field = vfh->format.fmt.pix.field;
+	pipe->field = video->format.fmt.pix.field;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_streamon(&vfh->queue, type);
+	ret = vb2_streamon(&video->queue, type);
 	mutex_unlock(&video->queue_lock);
 	if (ret < 0)
 		goto err_check_format;
@@ -1098,7 +1085,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 err_set_stream:
 	mutex_lock(&video->queue_lock);
-	vb2_streamoff(&vfh->queue, type);
+	vb2_streamoff(&video->queue, type);
 	mutex_unlock(&video->queue_lock);
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
@@ -1113,7 +1100,6 @@ err_pipeline_start:
 	 * free-running sensor.
 	 */
 	INIT_LIST_HEAD(&video->dmaqueue);
-	video->queue = NULL;
 
 	mutex_unlock(&video->stream_lock);
 	return ret;
@@ -1122,7 +1108,6 @@ err_pipeline_start:
 static int
 isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	enum isp_pipeline_state state;
@@ -1136,7 +1121,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	/* Make sure we're not streaming yet. */
 	mutex_lock(&video->queue_lock);
-	streaming = vb2_is_streaming(&vfh->queue);
+	streaming = vb2_is_streaming(&video->queue);
 	mutex_unlock(&video->queue_lock);
 
 	if (!streaming)
@@ -1159,9 +1144,8 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_video_cancel_stream(video);
 
 	mutex_lock(&video->queue_lock);
-	vb2_streamoff(&vfh->queue, type);
+	vb2_streamoff(&video->queue, type);
 	mutex_unlock(&video->queue_lock);
-	video->queue = NULL;
 	video->error = false;
 
 	if (video->isp->pdata->set_constraints)
@@ -1230,16 +1214,12 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 static int isp_video_open(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
-	struct isp_video_fh *handle;
 	struct vb2_queue *queue;
-	int ret = 0;
-
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (handle == NULL)
-		return -ENOMEM;
+	int ret;
 
-	v4l2_fh_init(&handle->vfh, &video->video);
-	v4l2_fh_add(&handle->vfh);
+	ret = v4l2_fh_open(file);
+	if (ret)
+		return ret;
 
 	/* If this is the first user, initialise the pipeline. */
 	if (omap3isp_get(video->isp) == NULL) {
@@ -1253,70 +1233,57 @@ static int isp_video_open(struct file *file)
 		goto done;
 	}
 
-	queue = &handle->queue;
+	queue = &video->queue;
 	queue->type = video->type;
 	queue->io_modes = VB2_MMAP | VB2_USERPTR;
-	queue->drv_priv = handle;
+	queue->drv_priv = video;
 	queue->ops = &isp_video_queue_ops;
 	queue->mem_ops = &vb2_dma_contig_memops;
 	queue->buf_struct_size = sizeof(struct isp_buffer);
 	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
-	ret = vb2_queue_init(&handle->queue);
+	ret = vb2_queue_init(queue);
 	if (ret < 0) {
 		omap3isp_put(video->isp);
 		goto done;
 	}
 
-	memset(&handle->format, 0, sizeof(handle->format));
-	handle->format.type = video->type;
-	handle->timeperframe.denominator = 1;
-
-	handle->video = video;
-	file->private_data = &handle->vfh;
+	memset(&video->format, 0, sizeof(video->format));
+	video->format.type = video->type;
+	video->timeperframe.denominator = 1;
 
 done:
-	if (ret < 0) {
-		v4l2_fh_del(&handle->vfh);
-		kfree(handle);
-	}
-
 	return ret;
 }
 
 static int isp_video_release(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
-	struct v4l2_fh *vfh = file->private_data;
-	struct isp_video_fh *handle = to_isp_video_fh(vfh);
+	int ret;
 
 	/* Disable streaming and free the buffers queue resources. */
-	isp_video_streamoff(file, vfh, video->type);
+	isp_video_streamoff(file, NULL, video->type);
 
 	mutex_lock(&video->queue_lock);
-	vb2_queue_release(&handle->queue);
+	vb2_queue_release(&video->queue);
 	mutex_unlock(&video->queue_lock);
 
 	omap3isp_pipeline_pm_use(&video->video.entity, 0);
 
-	/* Release the file handle. */
-	v4l2_fh_del(vfh);
-	kfree(handle);
-	file->private_data = NULL;
+	ret = _vb2_fop_release(file, NULL);
 
 	omap3isp_put(video->isp);
 
-	return 0;
+	return ret;
 }
 
 static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_poll(&vfh->queue, file, wait);
+	ret = vb2_poll(&video->queue, file, wait);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -1324,12 +1291,11 @@ static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 
 static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
 	struct isp_video *video = video_drvdata(file);
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_mmap(&vfh->queue, vma);
+	ret = vb2_mmap(&video->queue, vma);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..d960bbd 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -172,28 +172,19 @@ struct isp_video {
 
 	/* Video buffers queue */
 	void *alloc_ctx;
-	struct vb2_queue *queue;
+	struct vb2_queue queue;
 	struct mutex queue_lock;	/* protects the queue */
 	spinlock_t irqlock;		/* protects dmaqueue */
 	struct list_head dmaqueue;
 	enum isp_video_dmaqueue_flags dmaqueue_flags;
 
 	const struct isp_video_operations *ops;
-};
-
-#define to_isp_video(vdev)	container_of(vdev, struct isp_video, video)
 
-struct isp_video_fh {
-	struct v4l2_fh vfh;
-	struct isp_video *video;
-	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
 };
 
-#define to_isp_video_fh(fh)	container_of(fh, struct isp_video_fh, vfh)
-#define isp_video_queue_to_isp_video_fh(q) \
-				container_of(q, struct isp_video_fh, queue)
+#define to_isp_video(vdev)	container_of(vdev, struct isp_video, video)
 
 int omap3isp_video_init(struct isp_video *video, const char *name);
 void omap3isp_video_cleanup(struct isp_video *video);
-- 
2.1.0

