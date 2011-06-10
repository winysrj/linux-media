Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49667 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab1FJShL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:11 -0400
Date: Fri, 10 Jun 2011 20:36:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 09/19] s5p-fimc: Conversion to use struct v4l2_fh
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-10-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a prerequisite for the patch converting the driver to use
the control framework. As the capture driver does not use per file
handle contexts, two separate ioctl handlers are created for it
(vidioc_try_fmt_mplane, and vidioc_g_fmt_mplane) so there is no
handlers shared between the memory-to-memory and capture video node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  114 ++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.c    |  174 +++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   10 +-
 3 files changed, 164 insertions(+), 134 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index d4a4c86..05e95da 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -263,7 +263,10 @@ static struct vb2_ops fimc_capture_qops = {
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret = 0;
+	int ret = v4l2_fh_open(file);
+
+	if (ret)
+		return ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
@@ -272,11 +275,12 @@ static int fimc_capture_open(struct file *file)
 		return -EBUSY;
 
 	ret = pm_runtime_get_sync(&fimc->pdev->dev);
-	if (ret)
+	if (ret < 0) {
+		v4l2_fh_release(file);
 		return ret;
+	}
 
 	++fimc->vid_cap.refcnt;
-	file->private_data = fimc->vid_cap.ctx;
 
 	return 0;
 }
@@ -294,22 +298,20 @@ static int fimc_capture_close(struct file *file)
 
 	pm_runtime_put_sync(&fimc->pdev->dev);
 
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static unsigned int fimc_capture_poll(struct file *file,
 				      struct poll_table_struct *wait)
 {
-	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
 
 	return vb2_poll(&fimc->vid_cap.vbq, file, wait);
 }
 
 static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
 
 	return vb2_mmap(&fimc->vid_cap.vbq, vma);
 }
@@ -327,8 +329,7 @@ static const struct v4l2_file_operations fimc_capture_fops = {
 static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 					struct v4l2_capability *cap)
 {
-	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
 
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
@@ -376,20 +377,41 @@ static int sync_capture_fmt(struct fimc_ctx *ctx)
 	return 0;
 }
 
+static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	return fimc_fill_format(&ctx->d_frame, f);
+}
+
+static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+
+	return fimc_try_fmt_mplane(ctx, f);
+}
+
 static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct fimc_frame *frame;
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_pix_format_mplane *pix;
+	struct fimc_frame *frame;
 	int ret;
 	int i;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
+	ret = fimc_try_fmt_mplane(ctx, f);
 	if (ret)
 		return ret;
 
@@ -431,7 +453,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = video_drvdata(file);
 
 	if (i->index != 0)
 		return -EINVAL;
@@ -455,8 +477,8 @@ static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 
 	if (fimc_capture_active(fimc) || !fimc->vid_cap.sd)
 		return -EBUSY;
@@ -472,8 +494,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_dev *fimc = video_drvdata(file);
 
 	return vb2_streamoff(&fimc->vid_cap.vbq, type);
 }
@@ -481,47 +502,43 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 static int fimc_cap_reqbufs(struct file *file, void *priv,
 			    struct v4l2_requestbuffers *reqbufs)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
-	int ret;
-
+	struct fimc_dev *fimc = video_drvdata(file);
+	int ret = vb2_reqbufs(&fimc->vid_cap.vbq, reqbufs);
 
-	ret = vb2_reqbufs(&cap->vbq, reqbufs);
 	if (!ret)
-		cap->reqbufs_count = reqbufs->count;
-
+		fimc->vid_cap.reqbufs_count = reqbufs->count;
 	return ret;
 }
 
 static int fimc_cap_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
+	struct fimc_dev *fimc = video_drvdata(file);
 
-	return vb2_querybuf(&cap->vbq, buf);
+	return vb2_querybuf(&fimc->vid_cap.vbq, buf);
 }
 
 static int fimc_cap_qbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
-	return vb2_qbuf(&cap->vbq, buf);
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_qbuf(&fimc->vid_cap.vbq, buf);
 }
 
 static int fimc_cap_dqbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
-	return vb2_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
-		file->f_flags & O_NONBLOCK);
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_dqbuf(&fimc->vid_cap.vbq, buf, file->f_flags & O_NONBLOCK);
 }
 
 static int fimc_cap_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
+			   struct v4l2_control *ctrl)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	int ret = -EINVAL;
 
 	/* Allow any controls but 90/270 rotation while streaming */
@@ -544,14 +561,12 @@ static int fimc_cap_s_ctrl(struct file *file, void *priv,
 static int fimc_cap_cropcap(struct file *file, void *fh,
 			    struct v4l2_cropcap *cr)
 {
-	struct fimc_frame *f;
-	struct fimc_ctx *ctx = fh;
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
 
 	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	f = &ctx->s_frame;
-
 	cr->bounds.left		= 0;
 	cr->bounds.top		= 0;
 	cr->bounds.width	= f->o_width;
@@ -563,10 +578,8 @@ static int fimc_cap_cropcap(struct file *file, void *fh,
 
 static int fimc_cap_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
-	struct fimc_frame *f;
-	struct fimc_ctx *ctx = file->private_data;
-
-	f = &ctx->s_frame;
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
 
 	cr->c.left	= f->offs_h;
 	cr->c.top	= f->offs_v;
@@ -576,12 +589,11 @@ static int fimc_cap_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	return 0;
 }
 
-static int fimc_cap_s_crop(struct file *file, void *fh,
-			       struct v4l2_crop *cr)
+static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_frame *f;
-	struct fimc_ctx *ctx = file->private_data;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret = -EINVAL;
 
 	if (fimc_capture_active(fimc))
@@ -619,9 +631,9 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_querycap		= fimc_vidioc_querycap_capture,
 
 	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
-	.vidioc_try_fmt_vid_cap_mplane	= fimc_vidioc_try_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_cap_try_fmt_mplane,
 	.vidioc_s_fmt_vid_cap_mplane	= fimc_cap_s_fmt_mplane,
-	.vidioc_g_fmt_vid_cap_mplane	= fimc_vidioc_g_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_cap_g_fmt_mplane,
 
 	.vidioc_reqbufs			= fimc_cap_reqbufs,
 	.vidioc_querybuf		= fimc_cap_querybuf,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b4387d7..4238466 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -773,10 +773,10 @@ static struct vb2_ops fimc_qops = {
 	.stop_streaming	 = stop_streaming,
 };
 
-static int fimc_m2m_querycap(struct file *file, void *priv,
-			   struct v4l2_capability *cap)
+static int fimc_m2m_querycap(struct file *file, void *fh,
+			     struct v4l2_capability *cap)
 {
-	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
@@ -805,42 +805,41 @@ int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
-int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
-			     struct v4l2_format *f)
+int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 {
-	struct fimc_ctx *ctx = priv;
-	struct fimc_frame *frame;
-	struct v4l2_pix_format_mplane *pixm;
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
 	int i;
 
-	frame = ctx_get_frame(ctx, f->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	pixm = &f->fmt.pix_mp;
-
-	pixm->width		= frame->width;
-	pixm->height		= frame->height;
+	pixm->width		= frame->o_width;
+	pixm->height		= frame->o_height;
 	pixm->field		= V4L2_FIELD_NONE;
 	pixm->pixelformat	= frame->fmt->fourcc;
 	pixm->colorspace	= V4L2_COLORSPACE_JPEG;
 	pixm->num_planes	= frame->fmt->memplanes;
 
 	for (i = 0; i < pixm->num_planes; ++i) {
-		int bpl = frame->o_width;
-
+		int bpl = frame->f_width;
 		if (frame->fmt->colplanes == 1) /* packed formats */
 			bpl = (bpl * frame->fmt->depth[0]) / 8;
-
 		pixm->plane_fmt[i].bytesperline = bpl;
-
 		pixm->plane_fmt[i].sizeimage = (frame->o_width *
 			frame->o_height * frame->fmt->depth[i]) / 8;
 	}
-
 	return 0;
 }
 
+static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_frame *frame = ctx_get_frame(ctx, f->type);
+
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	return fimc_fill_format(frame, f);
+}
+
 struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask)
 {
 	struct fimc_fmt *fmt;
@@ -871,11 +870,8 @@ struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
 	return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
 }
 
-
-int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
-			       struct v4l2_format *f)
+int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 {
-	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct samsung_fimc_variant *variant = fimc->variant;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
@@ -954,17 +950,25 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
-static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
+static int fimc_m2m_try_fmt_mplane(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
+	return fimc_try_fmt_mplane(ctx, f);
+}
+
+static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct vb2_queue *vq;
 	struct fimc_frame *frame;
 	struct v4l2_pix_format_mplane *pix;
 	int i, ret = 0;
 
-	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
+	ret = fimc_try_fmt_mplane(ctx, f);
 	if (ret)
 		return ret;
 
@@ -975,15 +979,10 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 		return -EBUSY;
 	}
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		frame = &ctx->s_frame;
-	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+	else
 		frame = &ctx->d_frame;
-	} else {
-		v4l2_err(fimc->m2m.vfd,
-			 "Wrong buffer/video queue type (%d)\n", f->type);
-		return -EINVAL;
-	}
 
 	pix = &f->fmt.pix_mp;
 	frame->fmt = find_format(f, FMT_FLAGS_M2M);
@@ -1015,39 +1014,42 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
-static int fimc_m2m_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *reqbufs)
+static int fimc_m2m_reqbufs(struct file *file, void *fh,
+			    struct v4l2_requestbuffers *reqbufs)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
-static int fimc_m2m_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
+static int fimc_m2m_querybuf(struct file *file, void *fh,
+			     struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
 	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
 }
 
-static int fimc_m2m_qbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
+static int fimc_m2m_qbuf(struct file *file, void *fh,
+			 struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
-static int fimc_m2m_dqbuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
+static int fimc_m2m_dqbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
 
-static int fimc_m2m_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
+static int fimc_m2m_streamon(struct file *file, void *fh,
+			     enum v4l2_buf_type type)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 
 	/* The source and target color format need to be set */
 	if (V4L2_TYPE_IS_OUTPUT(type)) {
@@ -1060,17 +1062,19 @@ static int fimc_m2m_streamon(struct file *file, void *priv,
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
 
-static int fimc_m2m_streamoff(struct file *file, void *priv,
+static int fimc_m2m_streamoff(struct file *file, void *fh,
 			    enum v4l2_buf_type type)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
-int fimc_vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
+int fimc_vidioc_queryctrl(struct file *file, void *fh,
+			  struct v4l2_queryctrl *qc)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
+	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct v4l2_queryctrl *c;
 	int ret = -EINVAL;
 
@@ -1087,10 +1091,9 @@ int fimc_vidioc_queryctrl(struct file *file, void *priv,
 	return ret;
 }
 
-int fimc_vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
+int fimc_vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	switch (ctrl->id) {
@@ -1183,10 +1186,10 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 	return 0;
 }
 
-static int fimc_m2m_s_ctrl(struct file *file, void *priv,
+static int fimc_m2m_s_ctrl(struct file *file, void *fh,
 			   struct v4l2_control *ctrl)
 {
-	struct fimc_ctx *ctx = priv;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	int ret = 0;
 
 	ret = check_ctrl_val(ctx, ctrl);
@@ -1198,10 +1201,10 @@ static int fimc_m2m_s_ctrl(struct file *file, void *priv,
 }
 
 static int fimc_m2m_cropcap(struct file *file, void *fh,
-			struct v4l2_cropcap *cr)
+			    struct v4l2_cropcap *cr)
 {
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_frame *frame;
-	struct fimc_ctx *ctx = fh;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
@@ -1218,8 +1221,8 @@ static int fimc_m2m_cropcap(struct file *file, void *fh,
 
 static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_frame *frame;
-	struct fimc_ctx *ctx = file->private_data;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
@@ -1297,7 +1300,7 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 
 static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
-	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *f;
 	int ret;
@@ -1344,11 +1347,11 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
 	.vidioc_enum_fmt_vid_out_mplane	= fimc_vidioc_enum_fmt_mplane,
 
-	.vidioc_g_fmt_vid_cap_mplane	= fimc_vidioc_g_fmt_mplane,
-	.vidioc_g_fmt_vid_out_mplane	= fimc_vidioc_g_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_m2m_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= fimc_m2m_g_fmt_mplane,
 
-	.vidioc_try_fmt_vid_cap_mplane	= fimc_vidioc_try_fmt_mplane,
-	.vidioc_try_fmt_vid_out_mplane	= fimc_vidioc_try_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_m2m_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= fimc_m2m_try_fmt_mplane,
 
 	.vidioc_s_fmt_vid_cap_mplane	= fimc_m2m_s_fmt_mplane,
 	.vidioc_s_fmt_vid_out_mplane	= fimc_m2m_s_fmt_mplane,
@@ -1404,7 +1407,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 static int fimc_m2m_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx = NULL;
+	struct fimc_ctx *ctx;
+	int ret;
 
 	dbg("pid: %d, state: 0x%lx, refcnt: %d",
 		task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
@@ -1419,13 +1423,18 @@ static int fimc_m2m_open(struct file *file)
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+	ret = v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
+	if (ret)
+		goto error;
+
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
 
-	file->private_data = ctx;
 	ctx->fimc_dev = fimc;
 	/* Default color format */
 	ctx->s_frame.fmt = &fimc_formats[0];
 	ctx->d_frame.fmt = &fimc_formats[0];
-	/* Setup the device context for mem2mem mode. */
+	/* Setup the device context for memory-to-memory mode */
 	ctx->state = FIMC_CTX_M2M;
 	ctx->flags = 0;
 	ctx->in_path = FIMC_DMA;
@@ -1434,26 +1443,33 @@ static int fimc_m2m_open(struct file *file)
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
-		int err = PTR_ERR(ctx->m2m_ctx);
-		kfree(ctx);
-		return err;
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error_fh;
 	}
 
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
-
 	return 0;
+
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+error:
+	kfree(ctx);
+	return ret;
 }
 
 static int fimc_m2m_release(struct file *file)
 {
-	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	dbg("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
 
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_M2M_RUN, &fimc->state);
@@ -1462,9 +1478,9 @@ static int fimc_m2m_release(struct file *file)
 }
 
 static unsigned int fimc_m2m_poll(struct file *file,
-				     struct poll_table_struct *wait)
+				  struct poll_table_struct *wait)
 {
-	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
 
 	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
@@ -1472,7 +1488,7 @@ static unsigned int fimc_m2m_poll(struct file *file,
 
 static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_ctx *ctx = fh_to_ctx(file->private_data);
 
 	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 23aaa8c..4b37939 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -456,6 +456,7 @@ struct fimc_dev {
  * @state:		flags to keep track of user configuration
  * @fimc_dev:		the FIMC device this context applies to
  * @m2m_ctx:		memory-to-memory device context
+ * @fh:			v4l2 file handle
  */
 struct fimc_ctx {
 	spinlock_t		slock;
@@ -475,8 +476,11 @@ struct fimc_ctx {
 	u32			state;
 	struct fimc_dev		*fimc_dev;
 	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct v4l2_fh		fh;
 };
 
+#define fh_to_ctx(__fh) container_of(__fh, struct fimc_ctx, fh)
+
 static inline bool fimc_capture_active(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -628,18 +632,16 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
-int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
-			     struct v4l2_format *f);
-int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
-			       struct v4l2_format *f);
 int fimc_vidioc_queryctrl(struct file *file, void *priv,
 			  struct v4l2_queryctrl *qc);
 int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 		       struct v4l2_control *ctrl);
 
+int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f);
 int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr);
 int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl);
 int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl);
+int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
 
 struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
 struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
-- 
1.7.5.4

