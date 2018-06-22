Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51508 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934362AbeFVDyJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 23:54:09 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v6 04/17] omap3isp: Add vb2_queue lock
Date: Fri, 22 Jun 2018 00:53:58 -0300
Message-Id: <20180622035358.28649-1-ezequiel@collabora.com>
In-Reply-To: <20180620174255.20304-1-ezequiel@collabora.com>
References: <20180620174255.20304-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_queue locks is now mandatory. Add it, remove driver ad-hoc locks,
and implement wait_{prepare, finish}.

Also, remove stream_lock mutex. Since the ioctls operations
are now protected by the queue mutex, the stream_lock mutex is
not needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 65 ++++------------------
 drivers/media/platform/omap3isp/ispvideo.h |  1 -
 2 files changed, 11 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9d228eac24ea..f835aeb9ddc5 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -496,6 +496,8 @@ static const struct vb2_ops isp_video_queue_ops = {
 	.buf_prepare = isp_video_buffer_prepare,
 	.buf_queue = isp_video_buffer_queue,
 	.start_streaming = isp_video_start_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 /*
@@ -628,11 +630,8 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
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
@@ -909,13 +908,8 @@ isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
-	int ret;
-
-	mutex_lock(&video->queue_lock);
-	ret = vb2_reqbufs(&vfh->queue, rb);
-	mutex_unlock(&video->queue_lock);
 
-	return ret;
+	return vb2_reqbufs(&vfh->queue, rb);
 }
 
 static int
@@ -923,13 +917,8 @@ isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
-	int ret;
 
-	mutex_lock(&video->queue_lock);
-	ret = vb2_querybuf(&vfh->queue, b);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
+	return vb2_querybuf(&vfh->queue, b);
 }
 
 static int
@@ -937,13 +926,8 @@ isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
-	int ret;
 
-	mutex_lock(&video->queue_lock);
-	ret = vb2_qbuf(&vfh->queue, b);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
+	return vb2_qbuf(&vfh->queue, b);
 }
 
 static int
@@ -951,13 +935,8 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
-	int ret;
 
-	mutex_lock(&video->queue_lock);
-	ret = vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
-	mutex_unlock(&video->queue_lock);
-
-	return ret;
+	return vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
 }
 
 static int isp_video_check_external_subdevs(struct isp_video *video,
@@ -1096,8 +1075,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
@@ -1106,7 +1083,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
 	if (ret)
-		goto err_enum_init;
+		return ret;
 
 	/* TODO: Implement PM QoS */
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
@@ -1158,14 +1135,10 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
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
@@ -1184,9 +1157,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
-err_enum_init:
-	mutex_unlock(&video->stream_lock);
-
 	return ret;
 }
 
@@ -1203,15 +1173,10 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
 	/* Make sure we're not streaming yet. */
-	mutex_lock(&video->queue_lock);
 	streaming = vb2_is_streaming(&vfh->queue);
-	mutex_unlock(&video->queue_lock);
-
 	if (!streaming)
-		goto done;
+		return 0;
 
 	/* Update the pipeline state. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1229,19 +1194,13 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
 	omap3isp_video_cancel_stream(video);
 
-	mutex_lock(&video->queue_lock);
 	vb2_streamoff(&vfh->queue, type);
-	mutex_unlock(&video->queue_lock);
 	video->queue = NULL;
 	video->error = false;
 
 	/* TODO: Implement PM QoS */
 	media_pipeline_stop(&video->video.entity);
-
 	media_entity_enum_cleanup(&pipe->ent_enum);
-
-done:
-	mutex_unlock(&video->stream_lock);
 	return 0;
 }
 
@@ -1333,6 +1292,7 @@ static int isp_video_open(struct file *file)
 	queue->buf_struct_size = sizeof(struct isp_buffer);
 	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	queue->dev = video->isp->dev;
+	queue->lock = &video->queue_lock;
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
@@ -1363,10 +1323,9 @@ static int isp_video_release(struct file *file)
 	struct v4l2_fh *vfh = file->private_data;
 	struct isp_video_fh *handle = to_isp_video_fh(vfh);
 
+	mutex_lock(&video->queue_lock);
 	/* Disable streaming and free the buffers queue resources. */
 	isp_video_streamoff(file, vfh, video->type);
-
-	mutex_lock(&video->queue_lock);
 	vb2_queue_release(&handle->queue);
 	mutex_unlock(&video->queue_lock);
 
@@ -1449,7 +1408,6 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	atomic_set(&video->active, 0);
 
 	spin_lock_init(&video->pipe.lock);
-	mutex_init(&video->stream_lock);
 	mutex_init(&video->queue_lock);
 	spin_lock_init(&video->irqlock);
 
@@ -1474,7 +1432,6 @@ void omap3isp_video_cleanup(struct isp_video *video)
 {
 	media_entity_cleanup(&video->video.entity);
 	mutex_destroy(&video->queue_lock);
-	mutex_destroy(&video->stream_lock);
 	mutex_destroy(&video->mutex);
 }
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index f6a2082b4a0a..5a8fba85e0eb 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -167,7 +167,6 @@ struct isp_video {
 
 	/* Pipeline state */
 	struct isp_pipeline pipe;
-	struct mutex stream_lock;	/* pipeline and stream states */
 	bool error;
 
 	/* Video buffers queue */
-- 
2.17.1
