Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29488 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0L2RdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 12:33:03 -0500
Date: Wed, 29 Dec 2010 18:32:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 06/15 v2] [media] s5p-fimc: Use v4l core mutex in ioctl and
 file operations
In-reply-to: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293643975-4528-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  208 ++++-----------------------
 drivers/media/video/s5p-fimc/fimc-core.c    |  115 ++++-----------
 2 files changed, 58 insertions(+), 265 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 8796f78..7d91dfd 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -407,29 +407,23 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	if (++fimc->vid_cap.refcnt == 1) {
 		ret = fimc_isp_subdev_init(fimc, -1);
 		if (ret) {
 			fimc->vid_cap.refcnt--;
-			ret = -EIO;
+			return -EIO;
 		}
 	}
 
 	file->private_data = fimc->vid_cap.ctx;
 
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return 0;
 }
 
 static int fimc_capture_close(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
 	if (--fimc->vid_cap.refcnt == 0) {
@@ -442,7 +436,6 @@ static int fimc_capture_close(struct file *file)
 		fimc_subdev_unregister(fimc);
 	}
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -451,30 +444,16 @@ static unsigned int fimc_capture_poll(struct file *file,
 {
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return POLLERR;
-
-	ret = vb2_poll(&fimc->vid_cap.vbq, file, wait);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
+	return vb2_poll(&fimc->vid_cap.vbq, file, wait);
 }
 
 static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
-	ret = vb2_mmap(&fimc->vid_cap.vbq, vma);
-	mutex_unlock(&fimc->lock);
-
-	return ret;
+	return vb2_mmap(&fimc->vid_cap.vbq, vma);
 }
 
 /* video device file operations */
@@ -556,13 +535,6 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	if (fimc_capture_active(fimc)) {
-		ret = -EBUSY;
-		goto sf_unlock;
-	}
 	if (vb2_is_streaming(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
 		return -EBUSY;
 
@@ -572,8 +544,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
 	if (!frame->fmt) {
 		err("fimc target format not found\n");
-		ret = -EINVAL;
-		goto sf_unlock;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < frame->fmt->colplanes; i++)
@@ -590,12 +561,9 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	frame->offs_h	= 0;
 	frame->offs_v	= 0;
 
-	ret = sync_capture_fmt(ctx);
-
 	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
 
-sf_unlock:
-	mutex_unlock(&fimc->lock);
+	ret = sync_capture_fmt(ctx);
 	return ret;
 }
 
@@ -624,21 +592,16 @@ static int fimc_cap_s_input(struct file *file, void *priv,
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct s3c_platform_fimc *pdata = fimc->pdata;
-	int ret;
 
 	if (fimc_capture_active(ctx->fimc_dev))
 		return -EBUSY;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	if (i >= FIMC_MAX_CAMIF_CLIENTS || !pdata->isp_info[i])
+		return -EINVAL;
 
-	if (i >= FIMC_MAX_CAMIF_CLIENTS || !pdata->isp_info[i]) {
-		ret = -EINVAL;
-		goto si_unlock;
-	}
 
 	if (fimc->vid_cap.sd) {
-		ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
+		int ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
 		if (ret)
 			err("s_power failed: %d", ret);
 	}
@@ -646,11 +609,7 @@ static int fimc_cap_s_input(struct file *file, void *priv,
 	/* Release the attached sensor subdevice. */
 	fimc_subdev_unregister(fimc);
 
-	ret = fimc_isp_subdev_init(fimc, i);
-
-si_unlock:
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return fimc_isp_subdev_init(fimc, i);
 }
 
 static int fimc_cap_g_input(struct file *file, void *priv,
@@ -666,112 +625,41 @@ static int fimc_cap_g_input(struct file *file, void *priv,
 static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
-	struct s3c_fimc_isp_info *isp_info;
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret = -EBUSY;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
 	if (fimc_capture_active(fimc) || !fimc->vid_cap.sd)
-		goto s_unlock;
+		return -EBUSY;
 
 	if (!(ctx->state & FIMC_DST_FMT)) {
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "Format is not set\n");
-		ret = -EINVAL;
-		goto s_unlock;
-	}
-
-	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
-	if (ret && ret != -ENOIOCTLCMD)
-		goto s_unlock;
-
-	ret = fimc_prepare_config(ctx, ctx->state);
-	if (ret)
-		goto s_unlock;
-
-	isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
-	fimc_hw_set_camera_type(fimc, isp_info);
-	fimc_hw_set_camera_source(fimc, isp_info);
-	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
-
-	if (ctx->state & FIMC_PARAMS) {
-		ret = fimc_set_scaler_info(ctx);
-		if (ret) {
-			err("Scaler setup error");
-			goto s_unlock;
-		}
-		fimc_hw_set_input_path(ctx);
-		fimc_hw_set_scaler(ctx);
-		fimc_hw_set_target_format(ctx);
-		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx);
+		return -EINVAL;
 	}
 
-	fimc_hw_set_output_path(ctx);
-	fimc_hw_set_out_dma(ctx);
-
-	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
-	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
-	fimc->vid_cap.active_buf_cnt = 0;
-	fimc->vid_cap.frame_count = 0;
-	fimc->vid_cap.buf_index = fimc_hw_get_frame_index(fimc);
-
-	set_bit(ST_CAPT_PEND, &fimc->state);
-	ret = vb2_streamon(&fimc->vid_cap.vbq, type);
-
-s_unlock:
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
 
 static int fimc_cap_streamoff(struct file *file, void *priv,
-			      enum v4l2_buf_type type)
+			    enum v4l2_buf_type type)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&fimc->slock, flags);
-	if (!fimc_capture_running(fimc) && !fimc_capture_pending(fimc)) {
-		spin_unlock_irqrestore(&fimc->slock, flags);
-		dbg("state: 0x%lx", fimc->state);
-		return -EINVAL;
-	}
-	spin_unlock_irqrestore(&fimc->slock, flags);
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
-	fimc_stop_capture(fimc);
-	ret = vb2_streamoff(&cap->vbq, type);
-
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return vb2_streamoff(&fimc->vid_cap.vbq, type);
 }
 
 static int fimc_cap_reqbufs(struct file *file, void *priv,
 			    struct v4l2_requestbuffers *reqbufs)
 {
 	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
 	int ret;
 
-	if (fimc_capture_active(ctx->fimc_dev))
-		return -EBUSY;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
 	ret = vb2_reqbufs(&cap->vbq, reqbufs);
 	if (!ret)
 		cap->reqbufs_count = reqbufs->count;
 
-	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
@@ -781,9 +669,6 @@ static int fimc_cap_querybuf(struct file *file, void *priv,
 	struct fimc_ctx *ctx = priv;
 	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
 
-	if (fimc_capture_active(ctx->fimc_dev))
-		return -EBUSY;
-
 	return vb2_querybuf(&cap->vbq, buf);
 }
 
@@ -791,33 +676,16 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
 	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_vid_cap *cap = &fimc->vid_cap;
-	int ret;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
-	ret = vb2_qbuf(&cap->vbq, buf);
-
-	mutex_unlock(&fimc->lock);
-	return ret;
+	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
+	return vb2_qbuf(&cap->vbq, buf);
 }
 
 static int fimc_cap_dqbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
 	struct fimc_ctx *ctx = priv;
-	int ret;
-
-	if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
-		return -ERESTARTSYS;
-
-	ret = vb2_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
+	return vb2_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
 		file->f_flags & O_NONBLOCK);
-
-	mutex_unlock(&ctx->fimc_dev->lock);
-	return ret;
 }
 
 static int fimc_cap_s_ctrl(struct file *file, void *priv,
@@ -826,9 +694,6 @@ static int fimc_cap_s_ctrl(struct file *file, void *priv,
 	struct fimc_ctx *ctx = priv;
 	int ret = -EINVAL;
 
-	if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
-		return -ERESTARTSYS;
-
 	/* Allow any controls but 90/270 rotation while streaming */
 	if (!fimc_capture_active(ctx->fimc_dev) ||
 	    ctrl->id != V4L2_CID_ROTATE ||
@@ -843,8 +708,6 @@ static int fimc_cap_s_ctrl(struct file *file, void *priv,
 	if (ret == -EINVAL)
 		ret = v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
 				       core, s_ctrl, ctrl);
-
-	mutex_unlock(&ctx->fimc_dev->lock);
 	return ret;
 }
 
@@ -853,13 +716,10 @@ static int fimc_cap_cropcap(struct file *file, void *fh,
 {
 	struct fimc_frame *f;
 	struct fimc_ctx *ctx = fh;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 	f = &ctx->s_frame;
 
 	cr->bounds.left		= 0;
@@ -868,7 +728,6 @@ static int fimc_cap_cropcap(struct file *file, void *fh,
 	cr->bounds.height	= f->o_height;
 	cr->defrect		= cr->bounds;
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -876,19 +735,14 @@ static int fimc_cap_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
 	struct fimc_frame *f;
 	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
 	f = &ctx->s_frame;
+
 	cr->c.left	= f->offs_h;
 	cr->c.top	= f->offs_v;
 	cr->c.width	= f->width;
 	cr->c.height	= f->height;
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -907,13 +761,10 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	if (!(ctx->state & FIMC_DST_FMT)) {
 		v4l2_err(&fimc->vid_cap.v4l2_dev,
 			 "Capture color format not set\n");
-		goto sc_unlock;
+		return -EINVAL; /* TODO: make sure this is the right value */
 	}
 
 	f = &ctx->s_frame;
@@ -921,17 +772,15 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
 	ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
 	if (ret) {
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
-	} else {
-		ret = 0;
-		f->offs_h = cr->c.left;
-		f->offs_v = cr->c.top;
-		f->width  = cr->c.width;
-		f->height = cr->c.height;
+		return ret;
 	}
 
-sc_unlock:
-	mutex_unlock(&fimc->lock);
-	return ret;
+	f->offs_h = cr->c.left;
+	f->offs_v = cr->c.top;
+	f->width  = cr->c.width;
+	f->height = cr->c.height;
+
+	return 0;
 }
 
 
@@ -1014,6 +863,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
+	vfd->lock	= &fimc->lock;
 	video_set_drvdata(vfd, fimc);
 
 	vid_cap = &fimc->vid_cap;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 3cad345..7899814 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -741,22 +741,17 @@ int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
 			     struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *frame;
 
 	frame = ctx_get_frame(ctx, f->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	f->fmt.pix.width	= frame->width;
 	f->fmt.pix.height	= frame->height;
 	f->fmt.pix.field	= V4L2_FIELD_NONE;
 	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -800,7 +795,8 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_fmt *fmt;
 	u32 max_width, mod_x, mod_y, mask;
-	int ret, i, is_output = 0;
+	int i, is_output = 0;
+
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->state & FIMC_CTX_CAP)
@@ -810,8 +806,6 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 	dbg("w: %d, h: %d", pix->width, pix->height);
 
 	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
@@ -819,13 +813,13 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	if (!fmt) {
 		v4l2_err(&fimc->m2m.v4l2_dev, "Fourcc format (0x%X) invalid.\n",
 			 pix->pixelformat);
-		goto tf_out;
+		return -EINVAL;
 	}
 
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = V4L2_FIELD_NONE;
 	else if (V4L2_FIELD_NONE != pix->field)
-		goto tf_out;
+		return -EINVAL;
 
 	if (is_output) {
 		max_width = variant->pix_limit->scaler_dis_w;
@@ -871,11 +865,7 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 		    pix->plane_fmt[i].sizeimage);
 	}
 
-	ret = 0;
-
-tf_out:
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return 0;
 }
 
 static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
@@ -888,45 +878,33 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	struct v4l2_pix_format_mplane *pix;
 	unsigned long flags;
 	int i, ret = 0;
+	u32 tmp;
 
 	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
 	if (ret)
 		return ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 
 	if (vb2_is_streaming(vq)) {
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "%s: queue (%d) busy\n",
-			 __func__, f->type);
-		ret = -EBUSY;
-		goto sf_out;
+		v4l2_err(&fimc->m2m.v4l2_dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
 	}
 
-	spin_lock_irqsave(&ctx->slock, flags);
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		frame = &ctx->s_frame;
-		ctx->state |= FIMC_SRC_FMT;
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		frame = &ctx->d_frame;
-		ctx->state |= FIMC_DST_FMT;
 	} else {
-		spin_unlock_irqrestore(&ctx->slock, flags);
 		v4l2_err(&fimc->m2m.v4l2_dev,
 			 "Wrong buffer/video queue type (%d)\n", f->type);
-		ret = -EINVAL;
-		goto sf_out;
+		return -EINVAL;
 	}
-	spin_unlock_irqrestore(&ctx->slock, flags);
 
 	pix = &f->fmt.pix_mp;
 	frame->fmt = find_format(f, FMT_FLAGS_M2M);
-	if (!frame->fmt) {
-		ret = -EINVAL;
-		goto sf_out;
-	}
+	if (!frame->fmt)
+		return -EINVAL;
 
 	for (i = 0; i < frame->fmt->colplanes; i++)
 		frame->payload[i] = pix->plane_fmt[i].bytesperline * pix->height;
@@ -942,14 +920,13 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	frame->offs_v	= 0;
 
 	spin_lock_irqsave(&ctx->slock, flags);
-	ctx->state |= FIMC_PARAMS;
+	tmp = (frame == &ctx->d_frame) ? FIMC_DST_FMT : FIMC_SRC_FMT;
+	ctx->state |= FIMC_PARAMS | tmp;
 	spin_unlock_irqrestore(&ctx->slock, flags);
 
 	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
-sf_out:
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return 0;
 }
 
 static int fimc_m2m_reqbufs(struct file *file, void *priv,
@@ -1014,11 +991,8 @@ int fimc_vidioc_queryctrl(struct file *file, void *priv,
 	}
 
 	if (ctx->state & FIMC_CTX_CAP) {
-		if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
-			return -ERESTARTSYS;
-		ret = v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
+		return v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
 					core, queryctrl, qc);
-		mutex_unlock(&ctx->fimc_dev->lock);
 	}
 	return ret;
 }
@@ -1028,10 +1002,6 @@ int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret = 0;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
@@ -1045,18 +1015,17 @@ int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 		break;
 	default:
 		if (ctx->state & FIMC_CTX_CAP) {
-			ret = v4l2_subdev_call(fimc->vid_cap.sd, core,
-				       g_ctrl, ctrl);
+			return v4l2_subdev_call(fimc->vid_cap.sd, core,
+						g_ctrl, ctrl);
 		} else {
 			v4l2_err(&fimc->m2m.v4l2_dev,
 				 "Invalid control\n");
-			ret = -EINVAL;
+			return -EINVAL;
 		}
 	}
 	dbg("ctrl->value= %d", ctrl->value);
 
-	mutex_unlock(&fimc->lock);
-	return ret;
+	return 0;
 }
 
 int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl)
@@ -1147,22 +1116,17 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 {
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = fh;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	cr->bounds.left		= 0;
 	cr->bounds.top		= 0;
 	cr->bounds.width	= frame->f_width;
 	cr->bounds.height	= frame->f_height;
 	cr->defrect		= cr->bounds;
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -1170,21 +1134,16 @@ static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	cr->c.left = frame->offs_h;
 	cr->c.top = frame->offs_v;
 	cr->c.width = frame->width;
 	cr->c.height = frame->height;
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -1264,9 +1223,6 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		&ctx->s_frame : &ctx->d_frame;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
-
 	spin_lock_irqsave(&ctx->slock, flags);
 	if (~ctx->state & (FIMC_SRC_FMT | FIMC_DST_FMT)) {
 		/* Check to see if scaling ratio is within supported range */
@@ -1276,8 +1232,8 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
 		if (ret) {
 			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
-			ret = -EINVAL;
-			goto scr_unlock;
+			spin_unlock_irqrestore(&ctx->slock, flags);
+			return -EINVAL;
 		}
 	}
 	ctx->state |= FIMC_PARAMS;
@@ -1287,9 +1243,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	f->width  = cr->c.width;
 	f->height = cr->c.height;
 
-scr_unlock:
 	spin_unlock_irqrestore(&ctx->slock, flags);
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -1360,10 +1314,6 @@ static int fimc_m2m_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = NULL;
-	int err = 0;
-
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
 
 	dbg("pid: %d, state: 0x%lx, refcnt: %d",
 		task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
@@ -1372,19 +1322,15 @@ static int fimc_m2m_open(struct file *file)
 	 * Return if the corresponding video capture node
 	 * is already opened.
 	 */
-	if (fimc->vid_cap.refcnt > 0) {
-		err = -EBUSY;
-		goto err_unlock;
-	}
+	if (fimc->vid_cap.refcnt > 0)
+		return -EBUSY;
 
 	fimc->m2m.refcnt++;
 	set_bit(ST_OUTDMA_RUN, &fimc->state);
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
-	if (!ctx) {
-		err = -ENOMEM;
-		goto err_unlock;
-	}
+	if (!ctx)
+		return -ENOMEM;
 
 	file->private_data = ctx;
 	ctx->fimc_dev = fimc;
@@ -1400,13 +1346,12 @@ static int fimc_m2m_open(struct file *file)
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
-		err = PTR_ERR(ctx->m2m_ctx);
+		int err = PTR_ERR(ctx->m2m_ctx);
 		kfree(ctx);
+		return err;
 	}
 
-err_unlock:
-	mutex_unlock(&fimc->lock);
-	return err;
+	return 0;
 }
 
 static int fimc_m2m_release(struct file *file)
@@ -1414,8 +1359,6 @@ static int fimc_m2m_release(struct file *file)
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
-	mutex_lock(&fimc->lock);
-
 	dbg("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
@@ -1424,7 +1367,6 @@ static int fimc_m2m_release(struct file *file)
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_OUTDMA_RUN, &fimc->state);
 
-	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
@@ -1490,6 +1432,7 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 	vfd->ioctl_ops	= &fimc_m2m_ioctl_ops;
 	vfd->minor	= -1;
 	vfd->release	= video_device_release;
+	vfd->lock	= &fimc->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s:m2m", dev_name(&pdev->dev));
 
-- 
1.7.2.3

