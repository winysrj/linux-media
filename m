Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbbCIVXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/18] marvell-ccic: use vb2 helpers and core locking
Date: Mon,  9 Mar 2015 22:22:14 +0100
Message-Id: <1425936143-5658-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the V4L2 core locking system instead of rolling your own. Switch to
the vb2 fop and ioctl helpers to get rid of a lot of code. This also made
it easy to add VB2_READ to the DMA modes, since you get read() for free
with vb2 and these helpers.

Finally remove the users field: this information is also available from
the core framework, no need to keep track of it in the driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 218 +++++-------------------
 drivers/media/platform/marvell-ccic/mcam-core.h |   1 -
 2 files changed, 43 insertions(+), 176 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 4d50182..b6b838f 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -971,7 +971,6 @@ static int mcam_cam_init(struct mcam_camera *cam)
 {
 	int ret;
 
-	mutex_lock(&cam->s_mutex);
 	if (cam->state != S_NOTREADY)
 		cam_warn(cam, "Cam init with device in funky state %d",
 				cam->state);
@@ -979,7 +978,6 @@ static int mcam_cam_init(struct mcam_camera *cam)
 	/* Get/set parameters? */
 	cam->state = S_IDLE;
 	mcam_ctlr_power_down(cam);
-	mutex_unlock(&cam->s_mutex);
 	return ret;
 }
 
@@ -1116,6 +1114,9 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 		INIT_LIST_HEAD(&cam->buffers);
 		return -EINVAL;
 	}
+	cam->frame_state.frames = 0;
+	cam->frame_state.singles = 0;
+	cam->frame_state.delivered = 0;
 	cam->sequence = 0;
 	/*
 	 * Videobuf2 sneakily hoards all the buffers and won't
@@ -1144,6 +1145,9 @@ static void mcam_vb_stop_streaming(struct vb2_queue *vq)
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	unsigned long flags;
 
+	cam_dbg(cam, "stop_streaming: %d frames, %d singles, %d delivered\n",
+			cam->frame_state.frames, cam->frame_state.singles,
+			cam->frame_state.delivered);
 	if (cam->state == S_BUFWAIT) {
 		/* They never gave us buffers */
 		cam->state = S_IDLE;
@@ -1256,7 +1260,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
 		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_contig;
 		cam->frame_complete = mcam_dma_contig_done;
 		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
@@ -1269,7 +1273,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
 		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
 		cam->vb_alloc_ctx_sg = vb2_dma_sg_init_ctx(cam->dev);
@@ -1284,7 +1288,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
 		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP;
+		vq->io_modes = VB2_MMAP | VB2_READ;
 		cam->dma_setup = mcam_ctlr_dma_vmalloc;
 		cam->frame_complete = mcam_vmalloc_done;
 #endif
@@ -1295,7 +1299,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
-	vb2_queue_release(&cam->vb_queue);
 #ifdef MCAM_MODE_DMA_CONTIG
 	if (cam->buffer_mode == B_DMA_contig)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
@@ -1312,81 +1315,6 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
  * The long list of V4L2 ioctl() operations.
  */
 
-static int mcam_vidioc_streamon(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamon(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_streamoff(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamoff(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
-		struct v4l2_requestbuffers *req)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_reqbufs(&cam->vb_queue, req);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_querybuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_querybuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_qbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_qbuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
 static int mcam_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *cap)
 {
@@ -1425,9 +1353,7 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	f = mcam_find_format(pix->pixelformat);
 	pix->pixelformat = f->pixelformat;
 	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
-	mutex_lock(&cam->s_mutex);
 	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
-	mutex_unlock(&cam->s_mutex);
 	v4l2_fill_pix_format(pix, &mbus_fmt);
 	switch (f->pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
@@ -1469,7 +1395,6 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	 * Now we start to change things for real, so let's do it
 	 * under lock.
 	 */
-	mutex_lock(&cam->s_mutex);
 	cam->pix_format = fmt->fmt.pix;
 	cam->mbus_code = f->mbus_code;
 
@@ -1483,7 +1408,6 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	}
 	mcam_set_config_needed(cam, 1);
 out:
-	mutex_unlock(&cam->s_mutex);
 	return ret;
 }
 
@@ -1538,9 +1462,7 @@ static int mcam_vidioc_g_parm(struct file *filp, void *priv,
 	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
-	mutex_lock(&cam->s_mutex);
 	ret = sensor_call(cam, video, g_parm, parms);
-	mutex_unlock(&cam->s_mutex);
 	parms->parm.capture.readbuffers = n_dma_bufs;
 	return ret;
 }
@@ -1551,9 +1473,7 @@ static int mcam_vidioc_s_parm(struct file *filp, void *priv,
 	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
-	mutex_lock(&cam->s_mutex);
 	ret = sensor_call(cam, video, s_parm, parms);
-	mutex_unlock(&cam->s_mutex);
 	parms->parm.capture.readbuffers = n_dma_bufs;
 	return ret;
 }
@@ -1573,9 +1493,7 @@ static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
 	if (f->pixelformat != sizes->pixel_format)
 		return -EINVAL;
 	fse.code = f->mbus_code;
-	mutex_lock(&cam->s_mutex);
 	ret = sensor_call(cam, pad, enum_frame_size, NULL, &fse);
-	mutex_unlock(&cam->s_mutex);
 	if (ret)
 		return ret;
 	if (fse.min_width == fse.max_width &&
@@ -1612,9 +1530,7 @@ static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
 	if (f->pixelformat != interval->pixel_format)
 		return -EINVAL;
 	fie.code = f->mbus_code;
-	mutex_lock(&cam->s_mutex);
 	ret = sensor_call(cam, pad, enum_frame_interval, NULL, &fie);
-	mutex_unlock(&cam->s_mutex);
 	if (ret)
 		return ret;
 	interval->type = V4L2_FRMIVAL_TYPE_DISCRETE;
@@ -1656,12 +1572,12 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_enum_input	= mcam_vidioc_enum_input,
 	.vidioc_g_input		= mcam_vidioc_g_input,
 	.vidioc_s_input		= mcam_vidioc_s_input,
-	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
-	.vidioc_querybuf	= mcam_vidioc_querybuf,
-	.vidioc_qbuf		= mcam_vidioc_qbuf,
-	.vidioc_dqbuf		= mcam_vidioc_dqbuf,
-	.vidioc_streamon	= mcam_vidioc_streamon,
-	.vidioc_streamoff	= mcam_vidioc_streamoff,
+	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
+	.vidioc_querybuf	= vb2_ioctl_querybuf,
+	.vidioc_qbuf		= vb2_ioctl_qbuf,
+	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
+	.vidioc_streamon	= vb2_ioctl_streamon,
+	.vidioc_streamoff	= vb2_ioctl_streamoff,
 	.vidioc_g_parm		= mcam_vidioc_g_parm,
 	.vidioc_s_parm		= mcam_vidioc_s_parm,
 	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
@@ -1681,26 +1597,19 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 static int mcam_v4l_open(struct file *filp)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
-	int ret = v4l2_fh_open(filp);
-
-	if (ret)
-		return ret;
+	int ret;
 
-	cam->frame_state.frames = 0;
-	cam->frame_state.singles = 0;
-	cam->frame_state.delivered = 0;
 	mutex_lock(&cam->s_mutex);
-	if (cam->users == 0) {
-		ret = mcam_setup_vb2(cam);
-		if (ret)
-			goto out;
+	ret = v4l2_fh_open(filp);
+	if (ret)
+		goto out;
+	if (v4l2_fh_is_singular_file(filp)) {
 		ret = mcam_ctlr_power_up(cam);
 		if (ret)
 			goto out;
 		__mcam_cam_reset(cam);
 		mcam_set_config_needed(cam, 1);
 	}
-	(cam->users)++;
 out:
 	mutex_unlock(&cam->s_mutex);
 	if (ret)
@@ -1712,15 +1621,12 @@ out:
 static int mcam_v4l_release(struct file *filp)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
+	bool last_open;
 
-	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
-			cam->frame_state.frames, cam->frame_state.singles,
-			cam->frame_state.delivered);
 	mutex_lock(&cam->s_mutex);
-	(cam->users)--;
-	if (cam->users == 0) {
-		mcam_ctlr_stop_dma(cam);
-		mcam_cleanup_vb2(cam);
+	last_open = v4l2_fh_is_singular_file(filp);
+	_vb2_fop_release(filp, NULL);
+	if (last_open) {
 		mcam_disable_mipi(cam);
 		mcam_ctlr_power_down(cam);
 		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
@@ -1728,58 +1634,16 @@ static int mcam_v4l_release(struct file *filp)
 	}
 
 	mutex_unlock(&cam->s_mutex);
-	v4l2_fh_release(filp);
 	return 0;
 }
 
-static ssize_t mcam_v4l_read(struct file *filp,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
-			filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static unsigned int mcam_v4l_poll(struct file *filp,
-		struct poll_table_struct *pt)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_poll(&cam->vb_queue, filp, pt);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_mmap(&cam->vb_queue, vma);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
 static const struct v4l2_file_operations mcam_v4l_fops = {
 	.owner = THIS_MODULE,
 	.open = mcam_v4l_open,
 	.release = mcam_v4l_release,
-	.read = mcam_v4l_read,
-	.poll = mcam_v4l_poll,
-	.mmap = mcam_v4l_mmap,
+	.read = vb2_fop_read,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1790,8 +1654,6 @@ static const struct v4l2_file_operations mcam_v4l_fops = {
  */
 static struct video_device mcam_v4l_template = {
 	.name = "mcam",
-	.tvnorms = V4L2_STD_NTSC_M,
-
 	.fops = &mcam_v4l_fops,
 	.ioctl_ops = &mcam_v4l_ioctl_ops,
 	.release = video_device_release_empty,
@@ -1950,13 +1812,21 @@ int mccic_register(struct mcam_camera *cam)
 	if (ret)
 		goto out_unregister;
 
+	ret = mcam_setup_vb2(cam);
+	if (ret)
+		goto out_unregister;
+
 	mutex_lock(&cam->s_mutex);
 	cam->vdev = mcam_v4l_template;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	cam->vdev.lock = &cam->s_mutex;
+	cam->vdev.queue = &cam->vb_queue;
 	video_set_drvdata(&cam->vdev, cam);
 	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto out;
+	if (ret) {
+		mutex_unlock(&cam->s_mutex);
+		goto out_unregister;
+	}
 
 	/*
 	 * If so requested, try to get our DMA buffers now.
@@ -1967,11 +1837,9 @@ int mccic_register(struct mcam_camera *cam)
 					" will try again later.");
 	}
 
-out:
-	if (ret)
-		v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	mutex_unlock(&cam->s_mutex);
-	return ret;
+	return 0;
+
 out_unregister:
 	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	v4l2_device_unregister(&cam->v4l2_dev);
@@ -1987,11 +1855,11 @@ void mccic_shutdown(struct mcam_camera *cam)
 	 * take it down again will wedge the machine, which is frowned
 	 * upon.
 	 */
-	if (cam->users > 0) {
+	if (!list_empty(&cam->vdev.fh_list)) {
 		cam_warn(cam, "Removing a device with users!\n");
 		mcam_ctlr_power_down(cam);
 	}
-	vb2_queue_release(&cam->vb_queue);
+	mcam_cleanup_vb2(cam);
 	if (cam->buffer_mode == B_vmalloc)
 		mcam_free_dma_bufs(cam);
 	video_unregister_device(&cam->vdev);
@@ -2007,7 +1875,7 @@ void mccic_shutdown(struct mcam_camera *cam)
 void mccic_suspend(struct mcam_camera *cam)
 {
 	mutex_lock(&cam->s_mutex);
-	if (cam->users > 0) {
+	if (!list_empty(&cam->vdev.fh_list)) {
 		enum mcam_state cstate = cam->state;
 
 		mcam_ctlr_stop_dma(cam);
@@ -2022,7 +1890,7 @@ int mccic_resume(struct mcam_camera *cam)
 	int ret = 0;
 
 	mutex_lock(&cam->s_mutex);
-	if (cam->users > 0) {
+	if (!list_empty(&cam->vdev.fh_list)) {
 		ret = mcam_ctlr_power_up(cam);
 		if (ret) {
 			mutex_unlock(&cam->s_mutex);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 46bc715..2847e06 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -146,7 +146,6 @@ struct mcam_camera {
 	struct v4l2_ctrl_handler ctrl_handler;
 	enum mcam_state state;
 	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
-	int users;			/* How many open FDs */
 
 	struct mcam_frame_state frame_state;	/* Frame state counter */
 	/*
-- 
2.1.4

