Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0L1RD2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:28 -0500
Date: Tue, 28 Dec 2010 18:03:10 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/15] [media] s5p-fimc: Conversion to multiplanar formats
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Conversion to multiplanar color formats and minor cleanup.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  114 ++++-----
 drivers/media/video/s5p-fimc/fimc-core.c    |  381 ++++++++++++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.h    |   36 ++--
 drivers/media/video/s5p-fimc/fimc-reg.c     |   14 +-
 4 files changed, 299 insertions(+), 246 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index f829844..a2368cf 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -268,34 +268,16 @@ static int stop_streaming(struct vb2_queue *q)
 	return fimc_stop_capture(fimc);
 }
 
-static unsigned int get_plane_size(struct fimc_frame *frame, unsigned int plane)
+static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 {
-	unsigned long size = 0;
-
-	if (!frame || plane > frame->fmt->buff_cnt - 1)
+	if (!fr || plane >= fr->fmt->memplanes)
 		return 0;
 
-	if (1 == frame->fmt->planes_cnt) {
-		size = (frame->width * frame->height * frame->fmt->depth) >> 3;
-	} else if (frame->fmt->planes_cnt <= 3) {
-		switch (plane) {
-		case 0:
-			size = frame->width * frame->height;
-			break;
-		case 1:
-		case 2:
-			if (S5P_FIMC_YCBCR420 == frame->fmt->color
-				&& 2 != frame->fmt->planes_cnt)
-				size = (frame->width * frame->height) >> 2;
-			else /* 422 */
-				size = (frame->width * frame->height) >> 1;
-			break;
-		}
-	} else {
-		size = 0;
-	}
+	dbg("%s: w: %d. h: %d. depth[%d]: %d",
+	    __func__, fr->width, fr->height, plane, fr->fmt->depth[plane]);
+
+	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
 
-	return size;
 }
 
 static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
@@ -303,25 +285,24 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
 		       void *allocators[])
 {
 	struct fimc_ctx *ctx = vq->drv_priv;
-	struct fimc_fmt *fmt =	fmt = ctx->d_frame.fmt;
-	struct fimc_frame *frame;
+	struct fimc_fmt *fmt = ctx->d_frame.fmt;
+	int i;
 
 	if (!fmt)
 		return -EINVAL;
 
-	*num_planes = fmt->buff_cnt;
+	*num_planes = fmt->memplanes;
 
 	dbg("%s, buffer count=%d, plane count=%d",
 	    __func__, *num_buffers, *num_planes);
-	
-	frame = ctx_get_frame(ctx, vq->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
 
-	sizes[0] = get_plane_size(frame, 0);
-	allocators[0] = ctx->fimc_dev->alloc_ctx;
+	for (i = 0; i < fmt->memplanes; i++) {
+		sizes[i] = get_plane_size(&ctx->d_frame, i);
+		dbg("plane: %u, plane_size: %lu", i, sizes[i]);
+		allocators[i] = ctx->fimc_dev->alloc_ctx;
+	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static int buffer_init(struct vb2_buffer *vb)
@@ -335,16 +316,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
-	struct fimc_frame *frame;
-	unsigned long size;
 	int i;
 
-	frame = ctx_get_frame(ctx, vq->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
+	if (!ctx->d_frame.fmt || vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
 
-	for (i = 0; i < frame->fmt->buff_cnt; i++) {
-		size = get_plane_size(frame, i);
+	for (i = 0; i < ctx->d_frame.fmt->memplanes; i++) {
+		unsigned long size = get_plane_size(&ctx->d_frame, i);
 
 		if (vb2_plane_size(vb, i) < size) {
 			v4l2_err(v4l2_dev, "User buffer too small (%ld < %ld)\n",
@@ -439,7 +417,6 @@ static int fimc_capture_close(struct file *file)
 
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
-
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
 	if (--fimc->vid_cap.refcnt == 0) {
@@ -507,7 +484,8 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
+			    V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 
 	return 0;
 }
@@ -548,19 +526,20 @@ static int sync_capture_fmt(struct fimc_ctx *ctx)
 	return 0;
 }
 
-static int fimc_cap_s_fmt(struct file *file, void *priv,
-			     struct v4l2_format *f)
+static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
+				 struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *frame;
-	struct v4l2_pix_format *pix;
+	struct v4l2_pix_format_mplane *pix;
 	int ret;
+	int i;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	ret = fimc_vidioc_try_fmt(file, priv, f);
+	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
 	if (ret)
 		return ret;
 
@@ -571,10 +550,12 @@ static int fimc_cap_s_fmt(struct file *file, void *priv,
 		ret = -EBUSY;
 		goto sf_unlock;
 	}
+	if (vb2_is_streaming(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
+		return -EBUSY;
 
 	frame = &ctx->d_frame;
 
-	pix = &f->fmt.pix;
+	pix = &f->fmt.pix_mp;
 	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
 	if (!frame->fmt) {
 		err("fimc target format not found\n");
@@ -582,14 +563,17 @@ static int fimc_cap_s_fmt(struct file *file, void *priv,
 		goto sf_unlock;
 	}
 
+	for (i = 0; i < frame->fmt->colplanes; i++)
+		frame->payload[i] = pix->plane_fmt[i].bytesperline * pix->height;
+
 	/* Output DMA frame pixel size and offsets. */
-	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
+	frame->f_width = pix->plane_fmt[0].bytesperline * 8
+			/ frame->fmt->depth[0];
 	frame->f_height = pix->height;
 	frame->width	= pix->width;
 	frame->height	= pix->height;
 	frame->o_width	= pix->width;
 	frame->o_height = pix->height;
-	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
 	frame->offs_h	= 0;
 	frame->offs_v	= 0;
 
@@ -757,7 +741,7 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 }
 
 static int fimc_cap_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *reqbufs)
+			    struct v4l2_requestbuffers *reqbufs)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -858,13 +842,13 @@ static int fimc_cap_cropcap(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fh;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
-	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
-
 	f = &ctx->s_frame;
+
 	cr->bounds.left		= 0;
 	cr->bounds.top		= 0;
 	cr->bounds.width	= f->o_width;
@@ -941,10 +925,10 @@ sc_unlock:
 static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_querycap		= fimc_vidioc_querycap_capture,
 
-	.vidioc_enum_fmt_vid_cap	= fimc_vidioc_enum_fmt,
-	.vidioc_try_fmt_vid_cap		= fimc_vidioc_try_fmt,
-	.vidioc_s_fmt_vid_cap		= fimc_cap_s_fmt,
-	.vidioc_g_fmt_vid_cap		= fimc_vidioc_g_fmt,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_vidioc_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= fimc_cap_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_vidioc_g_fmt_mplane,
 
 	.vidioc_reqbufs			= fimc_cap_reqbufs,
 	.vidioc_querybuf		= fimc_cap_querybuf,
@@ -968,6 +952,7 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_g_input			= fimc_cap_g_input,
 };
 
+/* fimc->lock must be already initialized */
 int fimc_register_capture_device(struct fimc_dev *fimc)
 {
 	struct v4l2_device *v4l2_dev = &fimc->vid_cap.v4l2_dev;
@@ -975,6 +960,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
 	struct v4l2_format f;
+	struct fimc_frame *fr;
 	struct vb2_queue *q;
 	int ret;
 
@@ -987,8 +973,12 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	ctx->out_path	 = FIMC_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
 
-	f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
-	ctx->d_frame.fmt = find_format(&f, FMT_FLAGS_M2M);
+	/* Default format of the output frames */
+	f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32;
+	fr = &ctx->d_frame;
+	fr->fmt = find_format(&f, FMT_FLAGS_M2M);
+	fr->width = fr->f_width = fr->o_width = 640;
+	fr->height = fr->f_height = fr->o_height = 480;
 
 	if (!v4l2_dev->name[0])
 		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
@@ -1018,7 +1008,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	vid_cap->active_buf_cnt = 0;
 	vid_cap->reqbufs_count  = 0;
 	vid_cap->refcnt = 0;
-	/* The default color format for image sensor. */
+	/* Default color format for image sensor */
 	vid_cap->fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
 
 	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
@@ -1028,7 +1018,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 
 	q = &fimc->vid_cap.vbq;
 	memset(q, 0, sizeof(*q));
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 65d25b3..3cad345 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -34,106 +34,130 @@ static char *fimc_clock_name[NUM_FIMC_CLOCKS] = { "sclk_fimc", "fimc" };
 
 static struct fimc_fmt fimc_formats[] = {
 	{
-		.name	= "RGB565",
-		.fourcc	= V4L2_PIX_FMT_RGB565X,
-		.depth	= 16,
-		.color	= S5P_FIMC_RGB565,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.mbus_code = V4L2_MBUS_FMT_RGB565_2X8_BE,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "RGB565",
+		.fourcc		= V4L2_PIX_FMT_RGB565X,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_RGB565,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "BGR666",
-		.fourcc	= V4L2_PIX_FMT_BGR666,
-		.depth	= 32,
-		.color	= S5P_FIMC_RGB666,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "BGR666",
+		.fourcc		= V4L2_PIX_FMT_BGR666,
+		.depth		= { 32 },
+		.color		= S5P_FIMC_RGB666,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name = "XRGB-8-8-8-8, 32 bpp",
-		.fourcc	= V4L2_PIX_FMT_RGB32,
-		.depth = 32,
-		.color	= S5P_FIMC_RGB888,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "XRGB-8-8-8-8, 32 bpp",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.depth		= { 32 },
+		.color		= S5P_FIMC_RGB888,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "YUV 4:2:2 packed, YCbYCr",
-		.fourcc	= V4L2_PIX_FMT_YUYV,
-		.depth	= 16,
-		.color	= S5P_FIMC_YCBYCR422,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.mbus_code = V4L2_MBUS_FMT_YUYV8_2X8,
-		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_YCBYCR422,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
-		.name	= "YUV 4:2:2 packed, CbYCrY",
-		.fourcc	= V4L2_PIX_FMT_UYVY,
-		.depth	= 16,
-		.color	= S5P_FIMC_CBYCRY422,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
-		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_CBYCRY422,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
-		.name	= "YUV 4:2:2 packed, CrYCbY",
-		.fourcc	= V4L2_PIX_FMT_VYUY,
-		.depth	= 16,
-		.color	= S5P_FIMC_CRYCBY422,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.mbus_code = V4L2_MBUS_FMT_VYUY8_2X8,
-		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
+		.name		= "YUV 4:2:2 packed, CrYCbY",
+		.fourcc		= V4L2_PIX_FMT_VYUY,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_CRYCBY422,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
-		.name	= "YUV 4:2:2 packed, YCrYCb",
-		.fourcc	= V4L2_PIX_FMT_YVYU,
-		.depth	= 16,
-		.color	= S5P_FIMC_YCRYCB422,
-		.buff_cnt = 1,
-		.planes_cnt = 1,
-		.mbus_code = V4L2_MBUS_FMT_YVYU8_2X8,
-		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_YCRYCB422,
+		.memplanes	= 1,
+		.colplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
-		.name	= "YUV 4:2:2 planar, Y/Cb/Cr",
-		.fourcc	= V4L2_PIX_FMT_YUV422P,
-		.depth	= 12,
-		.color	= S5P_FIMC_YCBCR422,
-		.buff_cnt = 1,
-		.planes_cnt = 3,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV422P,
+		.depth		= { 12 },
+		.color		= S5P_FIMC_YCBCR422,
+		.memplanes	= 1,
+		.colplanes	= 3,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "YUV 4:2:2 planar, Y/CbCr",
-		.fourcc	= V4L2_PIX_FMT_NV16,
-		.depth	= 16,
-		.color	= S5P_FIMC_YCBCR422,
-		.buff_cnt = 1,
-		.planes_cnt = 2,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "YUV 4:2:2 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV16,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_YCBCR422,
+		.memplanes	= 1,
+		.colplanes	= 2,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "YUV 4:2:2 planar, Y/CrCb",
-		.fourcc	= V4L2_PIX_FMT_NV61,
-		.depth	= 16,
-		.color	= S5P_FIMC_RGB565,
-		.buff_cnt = 1,
-		.planes_cnt = 2,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "YUV 4:2:2 planar, Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV61,
+		.depth		= { 16 },
+		.color		= S5P_FIMC_RGB565,
+		.memplanes	= 1,
+		.colplanes	= 2,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "YUV 4:2:0 planar, YCbCr",
-		.fourcc	= V4L2_PIX_FMT_YUV420,
-		.depth	= 12,
-		.color	= S5P_FIMC_YCBCR420,
-		.buff_cnt = 1,
-		.planes_cnt = 3,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "YUV 4:2:0 planar, YCbCr",
+		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.depth		= { 12 },
+		.color		= S5P_FIMC_YCBCR420,
+		.memplanes	= 1,
+		.colplanes	= 3,
+		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name	= "YUV 4:2:0 planar, Y/CbCr",
-		.fourcc	= V4L2_PIX_FMT_NV12,
-		.depth	= 12,
-		.color	= S5P_FIMC_YCBCR420,
-		.buff_cnt = 1,
-		.planes_cnt = 2,
-		.flags = FMT_FLAGS_M2M,
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12,
+		.depth		= { 12 },
+		.color		= S5P_FIMC_YCBCR420,
+		.memplanes	= 1,
+		.colplanes	= 2,
+		.flags		= FMT_FLAGS_M2M,
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.color		= S5P_FIMC_YCBCR420,
+		.depth		= { 8, 4 },
+		.memplanes	= 2,
+		.colplanes	= 2,
+		.flags		= FMT_FLAGS_M2M,
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420M,
+		.color		= S5P_FIMC_YCBCR420,
+		.depth		= { 8, 2, 2 },
+		.memplanes	= 3,
+		.colplanes	= 3,
+		.flags		= FMT_FLAGS_M2M,
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr, tiled",
+		.fourcc		= V4L2_PIX_FMT_NV12MT,
+		.color		= S5P_FIMC_YCBCR420,
+		.depth		= { 8, 4 },
+		.memplanes	= 2,
+		.colplanes	= 2,
+		.flags		= FMT_FLAGS_M2M,
 	},
 };
 
@@ -359,7 +383,7 @@ isr_unlock:
 	return IRQ_HANDLED;
 }
 
-/* The color format (planes_cnt, buff_cnt) must be already configured. */
+/* The color format (colplanes, memplanes) must be already configured. */
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr)
 {
@@ -371,13 +395,13 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 
 	pix_size = frame->width * frame->height;
 
-	dbg("buff_cnt= %d, planes_cnt= %d, frame->size= %d, pix_size= %d",
-		frame->fmt->buff_cnt, frame->fmt->planes_cnt,
-		frame->size, pix_size);
+	dbg("memplanes= %d, colplanes= %d, pix_size= %d",
+		frame->fmt->memplanes, frame->fmt->colplanes, pix_size);
+
+	paddr->y = vb2_dma_contig_plane_paddr(vb, 0);
 
-	if (frame->fmt->buff_cnt == 1) {
-		paddr->y = vb2_dma_contig_plane_paddr(vb, 0);
-		switch (frame->fmt->planes_cnt) {
+	if (frame->fmt->memplanes == 1) {
+		switch (frame->fmt->colplanes) {
 		case 1:
 			paddr->cb = 0;
 			paddr->cr = 0;
@@ -400,6 +424,12 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		default:
 			return -EINVAL;
 		}
+	} else {
+		if (frame->fmt->memplanes >= 2)
+			paddr->cb = vb2_dma_contig_plane_paddr(vb, 1);
+
+		if (frame->fmt->memplanes == 3)
+			paddr->cr = vb2_dma_contig_plane_paddr(vb, 2);
 	}
 
 	dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
@@ -454,10 +484,14 @@ static void fimc_set_yuv_order(struct fimc_ctx *ctx)
 static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
 	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	u32 i, depth = 0;
+
+	for (i = 0; i < f->fmt->colplanes; i++)
+		depth += f->fmt->depth[i];
 
 	f->dma_offset.y_h = f->offs_h;
 	if (!variant->pix_hoff)
-		f->dma_offset.y_h *= (f->fmt->depth >> 3);
+		f->dma_offset.y_h *= (depth >> 3);
 
 	f->dma_offset.y_v = f->offs_v;
 
@@ -468,7 +502,7 @@ static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	f->dma_offset.cr_v = f->offs_v;
 
 	if (!variant->pix_hoff) {
-		if (f->fmt->planes_cnt == 3) {
+		if (f->fmt->colplanes == 3) {
 			f->dma_offset.cb_h >>= 1;
 			f->dma_offset.cr_h >>= 1;
 		}
@@ -596,20 +630,31 @@ static void fimc_job_abort(void *priv)
 }
 
 static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-		       unsigned int *num_planes, unsigned long sizes[],
-		       void *allocators[])
+			    unsigned int *num_planes, unsigned long sizes[],
+			    void *allocators[])
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
-	struct fimc_frame *fr;
+	struct fimc_frame *f;
+	int i;
 
-	fr = ctx_get_frame(ctx, vq->type);
-	if (IS_ERR(fr))
-		return PTR_ERR(fr);
+	f = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
 
-	*num_planes = 1;
+	/*
+	 * Return number of non-contigous planes (plane buffers)
+	 * depending on the configured color format.
+	 */
+	if (f->fmt)
+		*num_planes = f->fmt->memplanes;
 
-	sizes[0] = (fr->width * fr->height * fr->fmt->depth) >> 3;
-	allocators[0] = ctx->fimc_dev->alloc_ctx;
+	for (i = 0; i < f->fmt->memplanes; i++) {
+		sizes[i] = (f->width * f->height * f->fmt->depth[i]) >> 3;
+		allocators[i] = ctx->fimc_dev->alloc_ctx;
+	}
+
+	if (*num_buffers == 0)
+		*num_buffers = 1;
 
 	return 0;
 }
@@ -618,18 +663,15 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_frame *frame;
+	int i;
 
 	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (vb2_plane_size(vb, 0) < frame->size) {
-		dbg("%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0), (long)frame->size);
-		return -EINVAL;
-	}
+	for (i = 0; i < frame->fmt->memplanes; i++)
+		vb2_set_plane_payload(vb, i, frame->payload[i]);
 
-	vb2_set_plane_payload(vb, 0, frame->size);
 	return 0;
 }
 
@@ -674,12 +716,13 @@ static int fimc_m2m_querycap(struct file *file, void *priv,
 	cap->bus_info[0] = 0;
 	cap->version = KERNEL_VERSION(1, 0, 0);
 	cap->capabilities = V4L2_CAP_STREAMING |
-		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 
 	return 0;
 }
 
-int fimc_vidioc_enum_fmt(struct file *file, void *priv,
+int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f)
 {
 	struct fimc_fmt *fmt;
@@ -694,7 +737,8 @@ int fimc_vidioc_enum_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-int fimc_vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
+			     struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -747,29 +791,28 @@ struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
 }
 
 
-int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
+			       struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct samsung_fimc_variant *variant = fimc->variant;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_fmt *fmt;
 	u32 max_width, mod_x, mod_y, mask;
-	int ret = -EINVAL, is_output = 0;
+	int ret, i, is_output = 0;
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->state & FIMC_CTX_CAP)
 			return -EINVAL;
 		is_output = 1;
-	} else if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	} else if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		return -EINVAL;
 	}
 
-	dbg("w: %d, h: %d, bpl: %d",
-	    pix->width, pix->height, pix->bytesperline);
-
 	if (mutex_lock_interruptible(&fimc->lock))
 		return -ERESTARTSYS;
+	dbg("w: %d, h: %d", pix->width, pix->height);
 
 	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
 	fmt = find_format(f, mask);
@@ -796,7 +839,7 @@ int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		mod_x = 6; /* 64 x 32 pixels tile */
 		mod_y = 5;
 	} else {
-		if (fimc->id == 1 && fimc->variant->pix_hoff)
+		if (fimc->id == 1 && variant->pix_hoff)
 			mod_y = fimc_fmt_is_rgb(fmt->color) ? 0 : 1;
 		else
 			mod_y = mod_x;
@@ -807,15 +850,26 @@ int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	v4l_bound_align_image(&pix->width, 16, max_width, mod_x,
 		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
 
-	if (pix->bytesperline == 0 ||
-	    (pix->bytesperline * 8 / fmt->depth) > pix->width)
-		pix->bytesperline = (pix->width * fmt->depth) >> 3;
+	pix->num_planes = fmt->memplanes;
+
+	for (i = 0; i < pix->num_planes; ++i) {
+		int bpl = pix->plane_fmt[i].bytesperline;
+
+		dbg("[%d] bpl: %d, depth: %d, w: %d, h: %d",
+		    i, bpl, fmt->depth[i], pix->width, pix->height);
+
+		if (!bpl || (bpl * 8 / fmt->depth[i]) > pix->width)
+			bpl = (pix->width * fmt->depth[0]) >> 3;
+
+		if (!pix->plane_fmt[i].sizeimage)
+			pix->plane_fmt[i].sizeimage = pix->height * bpl;
 
-	if (pix->sizeimage == 0)
-		pix->sizeimage = pix->height * pix->bytesperline;
+		pix->plane_fmt[i].bytesperline = bpl;
 
-	dbg("w: %d, h: %d, bpl: %d, depth: %d",
-	    pix->width, pix->height, pix->bytesperline, fmt->depth);
+		dbg("[%d]: bpl: %d, sizeimage: %d",
+		    i, pix->plane_fmt[i].bytesperline,
+		    pix->plane_fmt[i].sizeimage);
+	}
 
 	ret = 0;
 
@@ -824,18 +878,18 @@ tf_out:
 	return ret;
 }
 
-static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
+				 struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_device *v4l2_dev = &fimc->m2m.v4l2_dev;
 	struct vb2_queue *vq;
 	struct fimc_frame *frame;
-	struct v4l2_pix_format *pix;
+	struct v4l2_pix_format_mplane *pix;
 	unsigned long flags;
-	int ret = 0;
+	int i, ret = 0;
 
-	ret = fimc_vidioc_try_fmt(file, priv, f);
+	ret = fimc_vidioc_try_fmt_mplane(file, priv, f);
 	if (ret)
 		return ret;
 
@@ -845,35 +899,40 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 
 	if (vb2_is_streaming(vq)) {
-		v4l2_err(v4l2_dev, "%s: queue (%d) busy\n", __func__, f->type);
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "%s: queue (%d) busy\n",
+			 __func__, f->type);
 		ret = -EBUSY;
 		goto sf_out;
 	}
 
 	spin_lock_irqsave(&ctx->slock, flags);
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		frame = &ctx->s_frame;
 		ctx->state |= FIMC_SRC_FMT;
-	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		frame = &ctx->d_frame;
 		ctx->state |= FIMC_DST_FMT;
 	} else {
 		spin_unlock_irqrestore(&ctx->slock, flags);
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+		v4l2_err(&fimc->m2m.v4l2_dev,
 			 "Wrong buffer/video queue type (%d)\n", f->type);
 		ret = -EINVAL;
 		goto sf_out;
 	}
 	spin_unlock_irqrestore(&ctx->slock, flags);
 
-	pix = &f->fmt.pix;
+	pix = &f->fmt.pix_mp;
 	frame->fmt = find_format(f, FMT_FLAGS_M2M);
 	if (!frame->fmt) {
 		ret = -EINVAL;
 		goto sf_out;
 	}
 
-	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
+	for (i = 0; i < frame->fmt->colplanes; i++)
+		frame->payload[i] = pix->plane_fmt[i].bytesperline * pix->height;
+
+	frame->f_width	= pix->plane_fmt[0].bytesperline * 8 /
+		frame->fmt->depth[0];
 	frame->f_height	= pix->height;
 	frame->width	= pix->width;
 	frame->height	= pix->height;
@@ -881,7 +940,6 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	frame->o_height = pix->height;
 	frame->offs_h	= 0;
 	frame->offs_v	= 0;
-	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
 
 	spin_lock_irqsave(&ctx->slock, flags);
 	ctx->state |= FIMC_PARAMS;
@@ -1134,7 +1192,8 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *f;
-	u32 min_size, halign;
+	u32 min_size, halign, depth = 0;
+	int i;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
 		v4l2_err(&fimc->m2m.v4l2_dev,
@@ -1142,9 +1201,9 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		return -EINVAL;
 	}
 
-	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		f = (ctx->state & FIMC_CTX_CAP) ? &ctx->s_frame : &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		 ctx->state & FIMC_CTX_M2M)
 		f = &ctx->s_frame;
 	else
@@ -1164,10 +1223,13 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		halign = 4;
 	}
 
+	for (i = 0; i < f->fmt->colplanes; i++)
+		depth += f->fmt->depth[i];
+
 	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
 			      ffs(min_size) - 1,
 			      &cr->c.height, min_size, f->o_height,
-			      halign, 64/(ALIGN(f->fmt->depth, 8)));
+			      halign, 64/(ALIGN(depth, 8)));
 
 	/* adjust left/top if cropping rectangle is out of bounds */
 	if (cr->c.left + cr->c.width > f->o_width)
@@ -1199,7 +1261,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	if (ret)
 		return ret;
 
-	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		&ctx->s_frame : &ctx->d_frame;
 
 	if (mutex_lock_interruptible(&fimc->lock))
@@ -1208,7 +1270,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	spin_lock_irqsave(&ctx->slock, flags);
 	if (~ctx->state & (FIMC_SRC_FMT | FIMC_DST_FMT)) {
 		/* Check to see if scaling ratio is within supported range */
-		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
 		else
 			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
@@ -1234,17 +1296,17 @@ scr_unlock:
 static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_querycap		= fimc_m2m_querycap,
 
-	.vidioc_enum_fmt_vid_cap	= fimc_vidioc_enum_fmt,
-	.vidioc_enum_fmt_vid_out	= fimc_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= fimc_vidioc_enum_fmt_mplane,
 
-	.vidioc_g_fmt_vid_cap		= fimc_vidioc_g_fmt,
-	.vidioc_g_fmt_vid_out		= fimc_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_vidioc_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= fimc_vidioc_g_fmt_mplane,
 
-	.vidioc_try_fmt_vid_cap		= fimc_vidioc_try_fmt,
-	.vidioc_try_fmt_vid_out		= fimc_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_vidioc_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= fimc_vidioc_try_fmt_mplane,
 
-	.vidioc_s_fmt_vid_cap		= fimc_m2m_s_fmt,
-	.vidioc_s_fmt_vid_out		= fimc_m2m_s_fmt,
+	.vidioc_s_fmt_vid_cap_mplane	= fimc_m2m_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= fimc_m2m_s_fmt_mplane,
 
 	.vidioc_reqbufs			= fimc_m2m_reqbufs,
 	.vidioc_querybuf		= fimc_m2m_querybuf,
@@ -1265,7 +1327,8 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 
 };
 
-static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
 {
 	struct fimc_ctx *ctx = priv;
 	int ret;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 590fbf2..1f1beaa 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -151,18 +151,18 @@ enum fimc_color_fmt {
  * @name: format description
  * @fourcc: the fourcc code for this format, 0 if not applicable
  * @color: the corresponding fimc_color_fmt
- * @depth: driver's private 'number of bits per pixel'
- * @buff_cnt: number of physically non-contiguous data planes
- * @planes_cnt: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @memplanes: number of physically non-contiguous data planes
+ * @colplanes: number of physically contiguous data planes
  */
 struct fimc_fmt {
 	enum v4l2_mbus_pixelcode mbus_code;
 	char	*name;
 	u32	fourcc;
 	u32	color;
-	u16	buff_cnt;
-	u16	planes_cnt;
-	u16	depth;
+	u16	memplanes;
+	u16	colplanes;
+	u8	depth[VIDEO_MAX_PLANES];
 	u16	flags;
 #define FMT_FLAGS_CAM	(1 << 0)
 #define FMT_FLAGS_M2M	(1 << 1)
@@ -272,7 +272,7 @@ struct fimc_vid_buffer {
  * @height:	image pixel weight
  * @paddr:	image frame buffer physical addresses
  * @buf_cnt:	number of buffers depending on a color format
- * @size:	image size in bytes
+ * @payload:	image size in bytes (w x h x bpp)
  * @color:	color format
  * @dma_offset:	DMA offset in bytes
  */
@@ -285,7 +285,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	u32	size;
+	unsigned long		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
@@ -479,7 +479,7 @@ struct fimc_ctx {
 
 static inline int tiled_fmt(struct fimc_fmt *fmt)
 {
-	return 0;
+	return fmt->fourcc == V4L2_PIX_FMT_NV12MT;
 }
 
 static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
@@ -535,12 +535,12 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 {
 	struct fimc_frame *frame;
 
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == type) {
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
 		if (ctx->state & FIMC_CTX_M2M)
 			frame = &ctx->s_frame;
 		else
 			return ERR_PTR(-EINVAL);
-	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == type) {
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
 		frame = &ctx->d_frame;
 	} else {
 		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
@@ -582,7 +582,7 @@ void fimc_hw_set_input_path(struct fimc_ctx *ctx);
 void fimc_hw_set_output_path(struct fimc_ctx *ctx);
 void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
 void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
-			      int index);
+			     int index);
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 			      struct s3c_fimc_isp_info *cam);
 int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
@@ -593,12 +593,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 
 /* -----------------------------------------------------*/
 /* fimc-core.c */
-int fimc_vidioc_enum_fmt(struct file *file, void *priv,
-		      struct v4l2_fmtdesc *f);
-int fimc_vidioc_g_fmt(struct file *file, void *priv,
-		      struct v4l2_format *f);
-int fimc_vidioc_try_fmt(struct file *file, void *priv,
-			struct v4l2_format *f);
+int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f);
+int fimc_vidioc_g_fmt_mplane(struct file *file, void *priv,
+			     struct v4l2_format *f);
+int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
+			       struct v4l2_format *f);
 int fimc_vidioc_queryctrl(struct file *file, void *priv,
 			  struct v4l2_queryctrl *qc);
 int fimc_vidioc_g_ctrl(struct file *file, void *priv,
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 511631a..5ed8f06 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -143,7 +143,7 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
 	case S5P_FIMC_YCRYCB422:
 	case S5P_FIMC_CBYCRY422:
 	case S5P_FIMC_CRYCBY422:
-		if (frame->fmt->planes_cnt == 1)
+		if (frame->fmt->colplanes == 1)
 			cfg |= S5P_CITRGFMT_YCBCR422_1P;
 		else
 			cfg |= S5P_CITRGFMT_YCBCR422;
@@ -219,11 +219,11 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
 	cfg &= ~(S5P_CIOCTRL_ORDER2P_MASK | S5P_CIOCTRL_ORDER422_MASK |
 		 S5P_CIOCTRL_YCBCR_PLANE_MASK);
 
-	if (frame->fmt->planes_cnt == 1)
+	if (frame->fmt->colplanes == 1)
 		cfg |= ctx->out_order_1p;
-	else if (frame->fmt->planes_cnt == 2)
+	else if (frame->fmt->colplanes == 2)
 		cfg |= ctx->out_order_2p | S5P_CIOCTRL_YCBCR_2PLANE;
-	else if (frame->fmt->planes_cnt == 3)
+	else if (frame->fmt->colplanes == 3)
 		cfg |= S5P_CIOCTRL_YCBCR_3PLANE;
 
 	writel(cfg, dev->regs + S5P_CIOCTRL);
@@ -428,7 +428,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	case S5P_FIMC_YCBCR420:
 		cfg |= S5P_MSCTRL_INFORMAT_YCBCR420;
 
-		if (frame->fmt->planes_cnt == 2)
+		if (frame->fmt->colplanes == 2)
 			cfg |= ctx->in_order_2p | S5P_MSCTRL_C_INT_IN_2PLANE;
 		else
 			cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
@@ -438,13 +438,13 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 	case S5P_FIMC_YCRYCB422:
 	case S5P_FIMC_CBYCRY422:
 	case S5P_FIMC_CRYCBY422:
-		if (frame->fmt->planes_cnt == 1) {
+		if (frame->fmt->colplanes == 1) {
 			cfg |= ctx->in_order_1p
 				| S5P_MSCTRL_INFORMAT_YCBCR422_1P;
 		} else {
 			cfg |= S5P_MSCTRL_INFORMAT_YCBCR422;
 
-			if (frame->fmt->planes_cnt == 2)
+			if (frame->fmt->colplanes == 2)
 				cfg |= ctx->in_order_2p
 					| S5P_MSCTRL_C_INT_IN_2PLANE;
 			else
-- 
1.7.2.3

