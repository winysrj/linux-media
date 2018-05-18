Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33392 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbeERSxv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:53:51 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 07/20] omap3isp: Add video_device and vb2_queue locks
Date: Fri, 18 May 2018 15:51:55 -0300
Message-Id: <20180518185208.17722-8-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_device and vb2_queue locks are now both
mandatory. Add them, remove driver ad-hoc locks,
and implement wait_{prepare, finish}.

To stay on the safe side, this commit uses a single mutex
for both locks. Better latency can be obtained by separating
these if needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 94 +++++-------------------------
 drivers/media/platform/omap3isp/ispvideo.h |  3 +-
 2 files changed, 15 insertions(+), 82 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9d228eac24ea..0e73f43ffa2d 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -292,10 +292,7 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 	fmt.pad = pad;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 
-	mutex_lock(&video->mutex);
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
-	mutex_unlock(&video->mutex);
-
 	if (ret)
 		return ret;
 
@@ -496,6 +493,8 @@ static const struct vb2_ops isp_video_queue_ops = {
 	.buf_prepare = isp_video_buffer_prepare,
 	.buf_queue = isp_video_buffer_queue,
 	.start_streaming = isp_video_start_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 /*
@@ -628,11 +627,8 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 {
 	struct isp_buffer *buf = NULL;
 
-	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		mutex_lock(&video->queue_lock);
+	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		vb2_discard_done(video->queue);
-		mutex_unlock(&video->queue_lock);
-	}
 
 	if (!list_empty(&video->dmaqueue)) {
 		buf = list_first_entry(&video->dmaqueue,
@@ -678,10 +674,7 @@ isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 	if (format->type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->mutex);
 	*format = vfh->format;
-	mutex_unlock(&video->mutex);
-
 	return 0;
 }
 
@@ -736,10 +729,7 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	isp_video_pix_to_mbus(&format->fmt.pix, &fmt);
 	isp_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
 
-	mutex_lock(&video->mutex);
 	vfh->format = *format;
-	mutex_unlock(&video->mutex);
-
 	return 0;
 }
 
@@ -859,9 +849,7 @@ isp_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 		return -EINVAL;
 
 	sdsel.pad = pad;
-	mutex_lock(&video->mutex);
 	ret = v4l2_subdev_call(subdev, pad, set_selection, NULL, &sdsel);
-	mutex_unlock(&video->mutex);
 	if (!ret)
 		sel->r = sdsel.r;
 
@@ -908,56 +896,32 @@ static int
 isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_reqbufs(&vfh->queue, rb);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_reqbufs(&vfh->queue, rb);
 }
 
 static int
 isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_querybuf(&vfh->queue, b);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_querybuf(&vfh->queue, b);
 }
 
 static int
 isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_qbuf(&vfh->queue, b);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_qbuf(&vfh->queue, b);
 }
 
 static int
 isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
-	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
 }
 
 static int isp_video_check_external_subdevs(struct isp_video *video,
@@ -1096,8 +1060,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
@@ -1106,7 +1068,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
 	if (ret)
-		goto err_enum_init;
+		return ret;
 
 	/* TODO: Implement PM QoS */
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
@@ -1158,14 +1120,10 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	atomic_set(&pipe->frame_number, -1);
 	pipe->field = vfh->format.fmt.pix.field;
 
-	mutex_lock(&video->queue_lock);
 	ret = vb2_streamon(&vfh->queue, type);
-	mutex_unlock(&video->queue_lock);
 	if (ret < 0)
 		goto err_check_format;
 
-	mutex_unlock(&video->stream_lock);
-
 	return 0;
 
 err_check_format:
@@ -1183,10 +1141,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->queue = NULL;
 
 	media_entity_enum_cleanup(&pipe->ent_enum);
-
-err_enum_init:
-	mutex_unlock(&video->stream_lock);
-
 	return ret;
 }
 
@@ -1203,15 +1157,9 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
-	/* Make sure we're not streaming yet. */
-	mutex_lock(&video->queue_lock);
 	streaming = vb2_is_streaming(&vfh->queue);
-	mutex_unlock(&video->queue_lock);
-
 	if (!streaming)
-		goto done;
+		return 0;
 
 	/* Update the pipeline state. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1229,9 +1177,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
 	omap3isp_video_cancel_stream(video);
 
-	mutex_lock(&video->queue_lock);
 	vb2_streamoff(&vfh->queue, type);
-	mutex_unlock(&video->queue_lock);
 	video->queue = NULL;
 	video->error = false;
 
@@ -1240,8 +1186,6 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
-done:
-	mutex_unlock(&video->stream_lock);
 	return 0;
 }
 
@@ -1333,6 +1277,7 @@ static int isp_video_open(struct file *file)
 	queue->buf_struct_size = sizeof(struct isp_buffer);
 	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	queue->dev = video->isp->dev;
+	queue->lock = &video->v4l_lock;
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
@@ -1366,9 +1311,7 @@ static int isp_video_release(struct file *file)
 	/* Disable streaming and free the buffers queue resources. */
 	isp_video_streamoff(file, vfh, video->type);
 
-	mutex_lock(&video->queue_lock);
 	vb2_queue_release(&handle->queue);
-	mutex_unlock(&video->queue_lock);
 
 	v4l2_pipeline_pm_use(&video->video.entity, 0);
 
@@ -1386,14 +1329,8 @@ static int isp_video_release(struct file *file)
 static __poll_t isp_video_poll(struct file *file, poll_table *wait)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
-	struct isp_video *video = video_drvdata(file);
-	__poll_t ret;
 
-	mutex_lock(&video->queue_lock);
-	ret = vb2_poll(&vfh->queue, file, wait);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
+	return vb2_poll(&vfh->queue, file, wait);
 }
 
 static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1445,12 +1382,10 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	if (ret < 0)
 		return ret;
 
-	mutex_init(&video->mutex);
 	atomic_set(&video->active, 0);
 
+	mutex_init(&video->v4l_lock);
 	spin_lock_init(&video->pipe.lock);
-	mutex_init(&video->stream_lock);
-	mutex_init(&video->queue_lock);
 	spin_lock_init(&video->irqlock);
 
 	/* Initialize the video device. */
@@ -1460,6 +1395,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	video->video.fops = &isp_video_fops;
 	snprintf(video->video.name, sizeof(video->video.name),
 		 "OMAP3 ISP %s %s", name, direction);
+	video->video.lock = &video->v4l_lock;
 	video->video.vfl_type = VFL_TYPE_GRABBER;
 	video->video.release = video_device_release_empty;
 	video->video.ioctl_ops = &isp_video_ioctl_ops;
@@ -1473,9 +1409,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 void omap3isp_video_cleanup(struct isp_video *video)
 {
 	media_entity_cleanup(&video->video.entity);
-	mutex_destroy(&video->queue_lock);
-	mutex_destroy(&video->stream_lock);
-	mutex_destroy(&video->mutex);
+	mutex_destroy(&video->v4l_lock);
 }
 
 int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index f6a2082b4a0a..de6201034960 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -153,7 +153,7 @@ struct isp_video {
 	enum v4l2_buf_type type;
 	struct media_pad pad;
 
-	struct mutex mutex;		/* format and crop settings */
+	struct mutex v4l_lock;
 	atomic_t active;
 
 	struct isp_device *isp;
@@ -172,7 +172,6 @@ struct isp_video {
 
 	/* Video buffers queue */
 	struct vb2_queue *queue;
-	struct mutex queue_lock;	/* protects the queue */
 	spinlock_t irqlock;		/* protects dmaqueue */
 	struct list_head dmaqueue;
 	enum isp_video_dmaqueue_flags dmaqueue_flags;
-- 
2.16.3
