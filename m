Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49667 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab1FJShP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:15 -0400
Date: Fri, 10 Jun 2011 20:36:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 14/19] s5p-fimc: Convert to use video pipeline operations
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-15-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add format negotiation routine for sensor subdevs not exposing
a device node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  180 +++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.c    |   26 +++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    7 +-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    8 +-
 4 files changed, 137 insertions(+), 84 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 896b3b9..e1b1d12 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -75,11 +75,9 @@ static int fimc_start_capture(struct fimc_dev *fimc)
 
 static int fimc_stop_capture(struct fimc_dev *fimc)
 {
-	unsigned long flags;
-	struct fimc_vid_cap *cap;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
-
-	cap = &fimc->vid_cap;
+	unsigned long flags;
 
 	if (!fimc_capture_active(fimc))
 		return 0;
@@ -93,11 +91,10 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 			   !test_bit(ST_CAPT_SHUT, &fimc->state),
 			   FIMC_SHUTDOWN_TIMEOUT);
 
-	v4l2_subdev_call(cap->sd, video, s_stream, 0);
-
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
-			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM);
+			 1 << ST_CAPT_SHUT | 1 << ST_CAPT_STREAM |
+			 1 << ST_CAPT_ISP_STREAM);
 
 	fimc->vid_cap.active_buf_cnt = 0;
 
@@ -113,9 +110,9 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
-
 	dbg("state: 0x%lx", fimc->state);
-	return 0;
+
+	return fimc_pipeline_s_stream(fimc, 0);
 }
 
 int fimc_capture_suspend(struct fimc_dev *fimc)
@@ -219,10 +216,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_buffer *buf
 		= container_of(vb, struct fimc_vid_buffer, vb);
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	unsigned long flags;
 	int min_bufs;
@@ -249,9 +246,14 @@ static void buffer_queue(struct vb2_buffer *vb)
 	min_bufs = vid_cap->reqbufs_count > 1 ? 2 : 1;
 
 	if (vid_cap->active_buf_cnt >= min_bufs &&
-	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
+	    !test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
 		fimc_activate_capture(ctx);
+		spin_unlock_irqrestore(&fimc->slock, flags);
 
+		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
+			fimc_pipeline_s_stream(fimc, 1);
+		return;
+	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
@@ -314,15 +316,19 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
-	ret = pm_runtime_get_sync(&fimc->pdev->dev);
-	if (ret < 0) {
-		v4l2_fh_release(file);
-		return ret;
-	}
+	pm_runtime_get_sync(&fimc->pdev->dev);
 
-	if (++fimc->vid_cap.refcnt == 1)
+	if (++fimc->vid_cap.refcnt == 1) {
+		ret = fimc_pipeline_initialize(fimc,
+			       &fimc->vid_cap.vfd->entity, true);
+		if (ret < 0) {
+			pm_runtime_put_sync(&fimc->pdev->dev);
+			fimc->vid_cap.refcnt--;
+			v4l2_fh_release(file);
+			return ret;
+		}
 		ret = fimc_capture_ctrls_create(fimc);
-
+	}
 	return ret;
 }
 
@@ -334,10 +340,10 @@ static int fimc_capture_close(struct file *file)
 
 	if (--fimc->vid_cap.refcnt == 0) {
 		fimc_stop_capture(fimc);
+		fimc_pipeline_shutdown(fimc);
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
 		vb2_queue_release(&fimc->vid_cap.vbq);
 	}
-
 	pm_runtime_put_sync(&fimc->pdev->dev);
 	return v4l2_fh_release(file);
 }
@@ -398,39 +404,69 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
-/* Synchronize formats of the camera interface input and attached  sensor. */
-static int sync_capture_fmt(struct fimc_ctx *ctx)
+/**
+ * fimc_pipeline_try_or_set_fmt - negotiate and/or set formats at pipeline
+ *                                elements
+ * @ctx: FIMC capture context
+ * @ff: pixel format to verify (width/height/fmt)
+ * @mfmt: if NULL format is only tried on subdevs, if not NULL format
+ *        will be set on subdevs and returned in @mfmt
+ */
+static int fimc_pipeline_try_or_set_fmt(struct fimc_ctx *ctx,
+					struct fimc_frame *ff,
+					struct v4l2_mbus_framefmt *mfmt)
 {
-	struct fimc_frame *frame = &ctx->s_frame;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_mbus_framefmt *fmt = &fimc->vid_cap.fmt;
-	int ret;
-
-	fmt->width  = ctx->d_frame.o_width;
-	fmt->height = ctx->d_frame.o_height;
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_subdev *csis = fimc->pipeline.csis;
+	struct v4l2_subdev_format sfmt;
+	struct v4l2_mbus_framefmt *mf = &sfmt.format;
+	struct fimc_fmt *ffmt;
+	int ret, i = 0;
+
+	if (!sd)
+		return -ENXIO;
 
-	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_mbus_fmt, fmt);
-	if (ret == -ENOIOCTLCMD) {
-		err("s_mbus_fmt failed");
-		return ret;
-	}
-	dbg("w: %d, h: %d, code= %d", fmt->width, fmt->height, fmt->code);
+	/* Configure pipeline formats only for sensors without a device node. */
+	if (subdev_has_devnode(sd))
+		return 0;
 
-	frame->fmt = fimc_find_format(NULL, fmt, FMT_FLAGS_CAM, -1);
-	if (!frame->fmt) {
-		err("fimc source format not found\n");
-		return -EINVAL;
+	memset(&sfmt, 0, sizeof(sfmt));
+	mf->width  = ff->width;
+	mf->height = ff->height;
+	mf->code   = -1;
+
+	dbg("code: 0x%x. %dx%d, dst: %dx%d", mf->code, mf->width, mf->height,
+	    ff->width, ff->height);
+
+	sfmt.which = mfmt ? V4L2_SUBDEV_FORMAT_ACTIVE : V4L2_SUBDEV_FORMAT_TRY;
+	while (ff->fmt->mbus_code != mf->code) {
+		if (mf->code != -1) {
+			ffmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, i++);
+			if(!ffmt)
+				return -EINVAL;
+		} else {
+			ffmt = ff->fmt;
+		}
+		mf->code = ffmt->mbus_code;
+		if (csis) {
+			ret = v4l2_subdev_call(csis, pad, set_fmt, NULL, &sfmt);
+			if (mf->code != ffmt->mbus_code ||
+			    mf->width != ff->width ||
+			    mf->width != ff->width)
+				continue;
+		}
+		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &sfmt);
+		if (ret)
+			return ret;
+		if (mf->code == ffmt->mbus_code &&
+		    mf->width == ff->width &&
+		    mf->width == ff->width)
+			break;
 	}
-
-	frame->f_width	= fmt->width;
-	frame->f_height = fmt->height;
-	frame->width	= fmt->width;
-	frame->height	= fmt->height;
-	frame->o_width	= fmt->width;
-	frame->o_height = fmt->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
-
+	dbg("code: 0x%x, %dx%d", mf->code, mf->width, mf->height);
+	if (mfmt)
+		*mfmt = *mf;
 	return 0;
 }
 
@@ -460,6 +496,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.mf;
 	struct v4l2_pix_format_mplane *pix;
 	struct fimc_frame *frame;
 	int ret;
@@ -488,20 +525,23 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 			(pix->width * pix->height * frame->fmt->depth[i]) >> 3;
 	}
 
-	/* Output DMA frame pixel size and offsets. */
-	frame->f_width = pix->plane_fmt[0].bytesperline * 8
-			/ frame->fmt->depth[0];
-	frame->f_height = pix->height;
-	frame->width	= pix->width;
-	frame->height	= pix->height;
-	frame->o_width	= pix->width;
-	frame->o_height = pix->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
-
-	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
+	fimc_fill_frame(frame, f);
+	ctx->state |= FIMC_DST_FMT;
 
-	ret = sync_capture_fmt(ctx);
+	fimc_md_graph_lock(fimc);
+	ret = fimc_pipeline_try_or_set_fmt(ctx, frame, mf);
+	fimc_md_graph_unlock(fimc);
+	if (!ret) {
+		frame 		= &ctx->s_frame;
+		frame->f_width	= mf->width;
+		frame->f_height	= mf->height;
+		frame->o_width	= mf->width;
+		frame->o_height	= mf->height;
+		frame->width	= mf->width;
+		frame->height	= mf->height;
+		frame->offs_h	= 0;
+		frame->offs_v	= 0;
+	}
 	return ret;
 }
 
@@ -509,12 +549,14 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
 
 	if (i->index != 0)
 		return -EINVAL;
 
-
 	i->type = V4L2_INPUT_TYPE_CAMERA;
+	if (sd)
+		strlcpy(i->name, sd->name, sizeof(i->name));
 	return 0;
 }
 
@@ -534,14 +576,16 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_pipeline *p = &fimc->pipeline;
 
-	if (fimc_capture_active(fimc) || !fimc->vid_cap.sd)
+	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
 	if (!(ctx->state & FIMC_DST_FMT)) {
 		v4l2_err(fimc->vid_cap.vfd, "Format is not set\n");
 		return -EINVAL;
 	}
+	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
 
 	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
@@ -550,8 +594,13 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	int ret;
 
-	return vb2_streamoff(&fimc->vid_cap.vbq, type);
+	ret = vb2_streamoff(&fimc->vid_cap.vbq, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&sd->entity);
+	return ret;
 }
 
 static int fimc_cap_reqbufs(struct file *file, void *priv,
@@ -657,7 +706,6 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	return 0;
 }
 
-
 static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_querycap		= fimc_vidioc_querycap_capture,
 
@@ -763,8 +811,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	vid_cap->active_buf_cnt = 0;
 	vid_cap->reqbufs_count  = 0;
 	vid_cap->refcnt = 0;
-	/* Default color format for image sensor */
-	vid_cap->fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
 
 	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
 	INIT_LIST_HEAD(&vid_cap->active_buf_q);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 49ada07..e944fc4 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -897,6 +897,21 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 	return 0;
 }
 
+void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+
+	frame->f_width  = pixm->plane_fmt[0].bytesperline * 8 /
+				frame->fmt->depth[0];
+	frame->f_height	= pixm->height;
+	frame->width    = pixm->width;
+	frame->height   = pixm->height;
+	frame->o_width  = pixm->width;
+	frame->o_height = pixm->height;
+	frame->offs_h   = 0;
+	frame->offs_v   = 0;
+}
+
 static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -1063,15 +1078,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 			(pix->width * pix->height * frame->fmt->depth[i]) / 8;
 	}
 
-	frame->f_width	= pix->plane_fmt[0].bytesperline * 8 /
-		frame->fmt->depth[0];
-	frame->f_height	= pix->height;
-	frame->width	= pix->width;
-	frame->height	= pix->height;
-	frame->o_width	= pix->width;
-	frame->o_height = pix->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
+	fimc_fill_frame(frame, f);
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
@@ -1578,7 +1585,6 @@ static int fimc_probe(struct platform_device *pdev)
 
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
-
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 14a24bb..57d347f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -43,6 +43,7 @@
 #define SCALER_MAX_HRATIO	64
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
+#define FIMC_CAMIF_MAX_HEIGHT	0x2000
 
 /* indices to the clocks array */
 enum {
@@ -61,6 +62,7 @@ enum fimc_dev_flags {
 	ST_CAPT_PEND,
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
+	ST_CAPT_ISP_STREAM,
 	ST_CAPT_SHUT,
 	ST_CAPT_INUSE,
 	ST_CAPT_APPLY_CFG,
@@ -293,7 +295,6 @@ struct fimc_m2m_device {
  * struct fimc_vid_cap - camera capture device information
  * @ctx: hardware context data
  * @vfd: video device node for camera capture mode
- * @sd: pointer to camera sensor subdevice currently in use
  * @vd_pad: fimc video capture node pad
  * @fmt: Media Bus format configured at selected image sensor
  * @pending_buf_q: the pending buffer queue head
@@ -311,9 +312,8 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
-	struct v4l2_subdev		*sd;;
 	struct media_pad		vd_pad;
-	struct v4l2_mbus_framefmt	fmt;
+	struct v4l2_mbus_framefmt	mf;
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
 	struct vb2_queue		vbq;
@@ -661,6 +661,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
+void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
 
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 50937b4..a1fff02 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -572,7 +572,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 
 	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
 		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
-			if (fimc->vid_cap.fmt.code == pix_desc[i].pixelcode) {
+			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
 				cfg = pix_desc[i].cisrcfmt;
 				bus_width = pix_desc[i].bus_width;
 				break;
@@ -582,7 +582,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		if (i == ARRAY_SIZE(pix_desc)) {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Camera color format not supported: %d\n",
-				 fimc->vid_cap.fmt.code);
+				 fimc->vid_cap.mf.code);
 			return -EINVAL;
 		}
 
@@ -642,12 +642,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
-		if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
+		if (vid_cap->mf.code == V4L2_MBUS_FMT_VYUY8_2X8) {
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
 		} else {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Not supported camera pixel format: %d",
-				 vid_cap->fmt.code);
+				 vid_cap->mf.code);
 			return -EINVAL;
 		}
 		tmp |= (cam->csi_data_align == 32) << 8;
-- 
1.7.5.4

