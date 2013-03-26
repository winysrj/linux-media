Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15308 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3CZQGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:06:30 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 2/3] s5p-fimc: Use vb2 ioctl/fop helpers in FIMC capture
 driver
Date: Tue, 26 Mar 2013 17:06:05 +0100
Message-id: <1364313966-18868-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
References: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mmap/poll file operation and several ioctl handlers are replaced
with the vb2 helper functions. Some helpers are used indirectly
to maintain the buffer queue ownership.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |  153 +++++-------------------
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    9 +-
 2 files changed, 36 insertions(+), 126 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 257afc1..b05d97b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -454,24 +454,12 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
-static void fimc_lock(struct vb2_queue *vq)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_lock(&ctx->fimc_dev->lock);
-}
-
-static void fimc_unlock(struct vb2_queue *vq)
-{
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	mutex_unlock(&ctx->fimc_dev->lock);
-}
-
 static struct vb2_ops fimc_capture_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
-	.wait_prepare		= fimc_unlock,
-	.wait_finish		= fimc_lock,
+	.wait_prepare	 	= vb2_ops_wait_prepare,
+	.wait_finish	 	= vb2_ops_wait_finish,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
 };
@@ -530,7 +518,7 @@ static int fimc_capture_open(struct file *file)
 		goto unlock;
 	}
 
-	if (++fimc->vid_cap.refcnt == 1) {
+	if (v4l2_fh_is_singular_file(file)) {
 		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vid_cap.vfd.entity, true);
 
@@ -543,8 +531,9 @@ static int fimc_capture_open(struct file *file)
 		if (ret < 0) {
 			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			pm_runtime_put_sync(&fimc->pdev->dev);
-			fimc->vid_cap.refcnt--;
 			v4l2_fh_release(file);
+		} else {
+			fimc->vid_cap.refcnt++;
 		}
 	}
 unlock:
@@ -553,7 +542,7 @@ unlock:
 	return ret;
 }
 
-static int fimc_capture_close(struct file *file)
+static int fimc_capture_release(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	int ret;
@@ -562,50 +551,20 @@ static int fimc_capture_close(struct file *file)
 
 	mutex_lock(&fimc->lock);
 
-	if (--fimc->vid_cap.refcnt == 0) {
+	if (v4l2_fh_is_singular_file(file)) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
+		fimc->vid_cap.refcnt--;
 	}
 
 	pm_runtime_put(&fimc->pdev->dev);
 
-	if (fimc->vid_cap.refcnt == 0) {
-		vb2_queue_release(&fimc->vid_cap.vbq);
+	if (v4l2_fh_is_singular_file(file))
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
-	}
-
-	ret = v4l2_fh_release(file);
-
-	mutex_unlock(&fimc->lock);
-	return ret;
-}
-
-static unsigned int fimc_capture_poll(struct file *file,
-				      struct poll_table_struct *wait)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-	int ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return POLL_ERR;
-
-	ret = vb2_poll(&fimc->vid_cap.vbq, file, wait);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
-}
-
-static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	ret = vb2_mmap(&fimc->vid_cap.vbq, vma);
+	ret = vb2_fop_release(file);
 	mutex_unlock(&fimc->lock);
 
 	return ret;
@@ -614,10 +573,10 @@ static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 static const struct v4l2_file_operations fimc_capture_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fimc_capture_open,
-	.release	= fimc_capture_close,
-	.poll		= fimc_capture_poll,
+	.release	= fimc_capture_release,
+	.poll		= vb2_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= fimc_capture_mmap,
+	.mmap		= vb2_fop_mmap,
 };
 
 /*
@@ -1247,7 +1206,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 			goto err_p_stop;
 	}
 
-	ret = vb2_streamon(&vc->vbq, type);
+	ret = vb2_ioctl_streamon(file, priv, type);
 	if (!ret)
 		return ret;
 
@@ -1262,7 +1221,7 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 	struct fimc_dev *fimc = video_drvdata(file);
 	int ret;
 
-	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
+	ret = vb2_ioctl_streamoff(file, priv, type);
 
 	if (ret == 0)
 		media_entity_pipeline_stop(&fimc->vid_cap.vfd.entity);
@@ -1274,59 +1233,14 @@ static int fimc_cap_reqbufs(struct file *file, void *priv,
 			    struct v4l2_requestbuffers *reqbufs)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret = vb2_reqbufs(&fimc->vid_cap.vbq, reqbufs);
+	int ret;
+
+	ret = vb2_ioctl_reqbufs(file, priv, reqbufs);
 
 	if (!ret)
 		fimc->vid_cap.reqbufs_count = reqbufs->count;
-	return ret;
-}
-
-static int fimc_cap_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-
-	return vb2_querybuf(&fimc->vid_cap.vbq, buf);
-}
-
-static int fimc_cap_qbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-
-	return vb2_qbuf(&fimc->vid_cap.vbq, buf);
-}
-
-static int fimc_cap_expbuf(struct file *file, void *priv,
-			  struct v4l2_exportbuffer *eb)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-
-	return vb2_expbuf(&fimc->vid_cap.vbq, eb);
-}
-
-static int fimc_cap_dqbuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-
-	return vb2_dqbuf(&fimc->vid_cap.vbq, buf, file->f_flags & O_NONBLOCK);
-}
-
-static int fimc_cap_create_bufs(struct file *file, void *priv,
-				struct v4l2_create_buffers *create)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
-
-	return vb2_create_bufs(&fimc->vid_cap.vbq, create);
-}
-
-static int fimc_cap_prepare_buf(struct file *file, void *priv,
-				struct v4l2_buffer *b)
-{
-	struct fimc_dev *fimc = video_drvdata(file);
 
-	return vb2_prepare_buf(&fimc->vid_cap.vbq, b);
+	return ret;
 }
 
 static int fimc_cap_g_selection(struct file *file, void *fh,
@@ -1425,14 +1339,12 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap_mplane	= fimc_cap_g_fmt_mplane,
 
 	.vidioc_reqbufs			= fimc_cap_reqbufs,
-	.vidioc_querybuf		= fimc_cap_querybuf,
-
-	.vidioc_qbuf			= fimc_cap_qbuf,
-	.vidioc_dqbuf			= fimc_cap_dqbuf,
-	.vidioc_expbuf			= fimc_cap_expbuf,
-
-	.vidioc_prepare_buf		= fimc_cap_prepare_buf,
-	.vidioc_create_bufs		= fimc_cap_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
 
 	.vidioc_streamon		= fimc_cap_streamon,
 	.vidioc_streamoff		= fimc_cap_streamoff,
@@ -1759,9 +1671,9 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
 {
 	struct video_device *vfd = &fimc->vid_cap.vfd;
-	struct fimc_vid_cap *vid_cap;
+	struct vb2_queue *q = &fimc->vid_cap.vbq;
 	struct fimc_ctx *ctx;
-	struct vb2_queue *q;
+	struct fimc_vid_cap *vid_cap;
 	int ret = -ENOMEM;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -1783,28 +1695,27 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vfd->v4l2_dev	= v4l2_dev;
 	vfd->minor	= -1;
 	vfd->release	= video_device_release_empty;
+	vfd->queue	= q;
 	vfd->lock	= &fimc->lock;
 
 	video_set_drvdata(vfd, fimc);
-
 	vid_cap = &fimc->vid_cap;
 	vid_cap->active_buf_cnt = 0;
-	vid_cap->reqbufs_count  = 0;
-	vid_cap->refcnt = 0;
+	vid_cap->reqbufs_count = 0;
+	vid_cap->ctx = ctx;
 
 	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
 	INIT_LIST_HEAD(&vid_cap->active_buf_q);
-	vid_cap->ctx = ctx;
 
-	q = &fimc->vid_cap.vbq;
 	memset(q, 0, sizeof(*q));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
-	q->drv_priv = fimc->vid_cap.ctx;
+	q->drv_priv = ctx;
 	q->ops = &fimc_capture_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &fimc->lock;
 
 	ret = vb2_queue_init(q);
 	if (ret)
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 2de56d3..163584d 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -671,16 +671,15 @@ static int fimc_m2m_open(struct file *file)
 	struct fimc_ctx *ctx;
 	int ret = -EBUSY;
 
-	dbg("pid: %d, state: 0x%lx, refcnt: %d",
-	    task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
+	pr_debug("pid: %d, state: %#lx\n", task_pid_nr(current), fimc->state);
 
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
 	/*
-	 * Return if the corresponding video capture node
-	 * is already opened.
+	 * Don't allow simultaneous open() of the mem-to-mem and the
+	 * capture video node that belong to same FIMC IP instance.
 	 */
-	if (fimc->vid_cap.refcnt > 0)
+	if (test_bit(ST_CAPT_BUSY, &fimc->state))
 		goto unlock;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-- 
1.7.9.5

