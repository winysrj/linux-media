Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15311 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3CZQGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:06:33 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 3/3] s5p-fimc: Use vb2 ioctl helpers in fimc-lite
Date: Tue, 26 Mar 2013 17:06:06 +0100
Message-id: <1364313966-18868-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
References: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace some ioctl, file and video buffer queue operation handlers
with the videobuf2 helpers. This allows to get rid of significant
amount of boilerplate.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |  170 +++++++--------------------
 1 file changed, 45 insertions(+), 125 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 40733e0..187d9f6 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -425,24 +425,12 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
-static void fimc_lock(struct vb2_queue *vq)
-{
-	struct fimc_lite *fimc = vb2_get_drv_priv(vq);
-	mutex_lock(&fimc->lock);
-}
-
-static void fimc_unlock(struct vb2_queue *vq)
-{
-	struct fimc_lite *fimc = vb2_get_drv_priv(vq);
-	mutex_unlock(&fimc->lock);
-}
-
 static const struct vb2_ops fimc_lite_qops = {
 	.queue_setup	 = queue_setup,
 	.buf_prepare	 = buffer_prepare,
 	.buf_queue	 = buffer_queue,
-	.wait_prepare	 = fimc_unlock,
-	.wait_finish	 = fimc_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming	 = stop_streaming,
 };
@@ -467,99 +455,69 @@ static int fimc_lite_open(struct file *file)
 	mutex_lock(&fimc->lock);
 	if (atomic_read(&fimc->out_path) != FIMC_IO_DMA) {
 		ret = -EBUSY;
-		goto done;
+		goto unlock;
 	}
 
 	set_bit(ST_FLITE_IN_USE, &fimc->state);
 	ret = pm_runtime_get_sync(&fimc->pdev->dev);
 	if (ret < 0)
-		goto done;
+		goto unlock;
 
 	ret = v4l2_fh_open(file);
 	if (ret < 0)
-		goto done;
+		goto err_pm;
 
-	if (++fimc->ref_count == 1 &&
-	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
-		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
-					 &fimc->vfd.entity, true);
-		if (ret < 0) {
-			pm_runtime_put_sync(&fimc->pdev->dev);
-			fimc->ref_count--;
-			v4l2_fh_release(file);
-			clear_bit(ST_FLITE_IN_USE, &fimc->state);
-		}
+	if (!v4l2_fh_is_singular_file(file) ||
+	    atomic_read(&fimc->out_path) != FIMC_IO_DMA)
+		goto unlock;
 
+	ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
+						me, true);
+	if (!ret) {
 		fimc_lite_clear_event_counters(fimc);
+		fimc->ref_count++;
+		goto unlock;
 	}
-done:
+
+	v4l2_fh_release(file);
+err_pm:
+	pm_runtime_put_sync(&fimc->pdev->dev);
+	clear_bit(ST_FLITE_IN_USE, &fimc->state);
+unlock:
 	mutex_unlock(&fimc->lock);
 	mutex_unlock(&me->parent->graph_mutex);
 	return ret;
 }
 
-static int fimc_lite_close(struct file *file)
+static int fimc_lite_release(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	int ret;
 
 	mutex_lock(&fimc->lock);
 
-	if (--fimc->ref_count == 0 &&
+	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
-		clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
+		fimc->ref_count--;
 	}
 
+	vb2_fop_release(file);
 	pm_runtime_put(&fimc->pdev->dev);
+	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 
-	if (fimc->ref_count == 0)
-		vb2_queue_release(&fimc->vb_queue);
-
-	ret = v4l2_fh_release(file);
-
-	mutex_unlock(&fimc->lock);
-	return ret;
-}
-
-static unsigned int fimc_lite_poll(struct file *file,
-				   struct poll_table_struct *wait)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return POLL_ERR;
-
-	ret = vb2_poll(&fimc->vb_queue, file, wait);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
-}
-
-static int fimc_lite_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	ret = vb2_mmap(&fimc->vb_queue, vma);
 	mutex_unlock(&fimc->lock);
-
-	return ret;
+	return 0;
 }
 
 static const struct v4l2_file_operations fimc_lite_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fimc_lite_open,
-	.release	= fimc_lite_close,
-	.poll		= fimc_lite_poll,
+	.release	= fimc_lite_release,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= fimc_lite_mmap,
+	.mmap		= vb2_fop_mmap,
 };
 
 /*
@@ -720,7 +678,6 @@ static int fimc_lite_try_fmt_mplane(struct file *file, void *fh,
 				    struct v4l2_format *f)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-
 	return fimc_lite_try_fmt(fimc, &f->fmt.pix_mp, NULL);
 }
 
@@ -812,12 +769,15 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 		return ret;
 
 	ret = fimc_pipeline_validate(fimc);
-	if (ret) {
-		media_entity_pipeline_stop(entity);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_p_stop;
 
-	return vb2_streamon(&fimc->vb_queue, type);
+	ret = vb2_ioctl_streamon(file, priv, type);
+	if (!ret)
+		return ret;
+err_p_stop:
+	media_entity_pipeline_stop(entity);
+	return 0;
 }
 
 static int fimc_lite_streamoff(struct file *file, void *priv,
@@ -826,7 +786,7 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 	struct fimc_lite *fimc = video_drvdata(file);
 	int ret;
 
-	ret = vb2_streamoff(&fimc->vb_queue, type);
+	ret = vb2_ioctl_streamoff(file, priv, type);
 	if (ret == 0)
 		media_entity_pipeline_stop(&fimc->vfd.entity);
 	return ret;
@@ -839,53 +799,13 @@ static int fimc_lite_reqbufs(struct file *file, void *priv,
 	int ret;
 
 	reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
-	ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
+	ret = vb2_ioctl_reqbufs(file, priv, reqbufs);
 	if (!ret)
 		fimc->reqbufs_count = reqbufs->count;
 
 	return ret;
 }
 
-static int fimc_lite_querybuf(struct file *file, void *priv,
-			      struct v4l2_buffer *buf)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-
-	return vb2_querybuf(&fimc->vb_queue, buf);
-}
-
-static int fimc_lite_qbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-
-	return vb2_qbuf(&fimc->vb_queue, buf);
-}
-
-static int fimc_lite_dqbuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-
-	return vb2_dqbuf(&fimc->vb_queue, buf, file->f_flags & O_NONBLOCK);
-}
-
-static int fimc_lite_create_bufs(struct file *file, void *priv,
-				 struct v4l2_create_buffers *create)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-
-	return vb2_create_bufs(&fimc->vb_queue, create);
-}
-
-static int fimc_lite_prepare_buf(struct file *file, void *priv,
-				 struct v4l2_buffer *b)
-{
-	struct fimc_lite *fimc = video_drvdata(file);
-
-	return vb2_prepare_buf(&fimc->vb_queue, b);
-}
-
 /* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
 static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
 {
@@ -965,11 +885,11 @@ static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
 	.vidioc_g_selection		= fimc_lite_g_selection,
 	.vidioc_s_selection		= fimc_lite_s_selection,
 	.vidioc_reqbufs			= fimc_lite_reqbufs,
-	.vidioc_querybuf		= fimc_lite_querybuf,
-	.vidioc_prepare_buf		= fimc_lite_prepare_buf,
-	.vidioc_create_bufs		= fimc_lite_create_bufs,
-	.vidioc_qbuf			= fimc_lite_qbuf,
-	.vidioc_dqbuf			= fimc_lite_dqbuf,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
 	.vidioc_streamon		= fimc_lite_streamon,
 	.vidioc_streamoff		= fimc_lite_streamoff,
 };
@@ -1310,8 +1230,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	vfd->v4l2_dev = sd->v4l2_dev;
 	vfd->minor = -1;
 	vfd->release = video_device_release_empty;
-	vfd->lock = &fimc->lock;
-	fimc->ref_count = 0;
+	vfd->queue = q;
 	fimc->reqbufs_count = 0;
 
 	INIT_LIST_HEAD(&fimc->pending_buf_q);
@@ -1325,6 +1244,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	q->buf_struct_size = sizeof(struct flite_buffer);
 	q->drv_priv = fimc;
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &fimc->lock;
 
 	ret = vb2_queue_init(q);
 	if (ret < 0)
-- 
1.7.9.5

