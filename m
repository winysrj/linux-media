Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2433 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaBYKQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/13] vivi: add multiplanar support
Date: Tue, 25 Feb 2014 11:15:55 +0100
Message-Id: <1393323363-30058-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new multiplanar module option. If set to 1, switch to the multiplanar
BUF_TYPE. This makes it possible to test multiplanar formats in applications
without requiring access to often hard-to-find hardware.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c  | 390 +++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/videodev2.h |   1 +
 2 files changed, 361 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 0cc2a20..49a8f89 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -66,6 +66,10 @@ static unsigned n_devs = 1;
 module_param(n_devs, uint, 0644);
 MODULE_PARM_DESC(n_devs, "number of video devices to create");
 
+static bool multiplanar;
+module_param(multiplanar, bool, 0644);
+MODULE_PARM_DESC(multiplanar, "select multiplanar formats");
+
 static unsigned debug;
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
@@ -160,6 +164,15 @@ static const struct vivi_fmt formats[] = {
 	},
 };
 
+static const struct vivi_fmt mplane_formats[] = {
+	{
+		.name     = "4:2:2, planar, YUV",
+		.fourcc   = V4L2_PIX_FMT_YUV422M,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+};
+
 static const struct vivi_fmt *__get_format(u32 pixelformat)
 {
 	const struct vivi_fmt *fmt;
@@ -168,13 +181,17 @@ static const struct vivi_fmt *__get_format(u32 pixelformat)
 	for (k = 0; k < ARRAY_SIZE(formats); k++) {
 		fmt = &formats[k];
 		if (fmt->fourcc == pixelformat)
-			break;
+			return fmt;
 	}
 
-	if (k == ARRAY_SIZE(formats))
+	if (!multiplanar)
 		return NULL;
-
-	return &formats[k];
+	for (k = 0; k < ARRAY_SIZE(mplane_formats); k++) {
+		fmt = &mplane_formats[k];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+	return NULL;
 }
 
 static const struct vivi_fmt *get_format(struct v4l2_format *f)
@@ -348,6 +365,7 @@ static void precalculate_bars(struct vivi_dev *dev)
 		case V4L2_PIX_FMT_UYVY:
 		case V4L2_PIX_FMT_YVYU:
 		case V4L2_PIX_FMT_VYUY:
+		case V4L2_PIX_FMT_YUV422M:
 		case V4L2_PIX_FMT_RGB24:
 		case V4L2_PIX_FMT_BGR24:
 		case V4L2_PIX_FMT_RGB32:
@@ -368,7 +386,7 @@ static void precalculate_bars(struct vivi_dev *dev)
 }
 
 /* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
-static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
+static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, unsigned plane, bool odd)
 {
 	u8 r_y, g_u, b_v;
 	u8 alpha = dev->alpha_component;
@@ -383,6 +401,7 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 		p = buf + color;
 
 		switch (dev->fmt->fourcc) {
+		case V4L2_PIX_FMT_YUV422M:
 		case V4L2_PIX_FMT_YUYV:
 			switch (color) {
 			case 0:
@@ -538,11 +557,26 @@ static void precalculate_line(struct vivi_dev *dev)
 		int wend   = (colorpos+1) * dev->width / 8;
 		int w;
 
-		gen_twopix(dev, &pix[0],        colorpos % 8, 0);
-		gen_twopix(dev, &pix[pixsize],  colorpos % 8, 1);
-
-		for (w = wstart/2*2, pos = dev->line + w*pixsize; w < wend; w += 2, pos += pixsize2)
-			memcpy(pos, pix, pixsize2);
+		gen_twopix(dev, &pix[0],        colorpos % 8, 0, 0);
+		gen_twopix(dev, &pix[pixsize],  colorpos % 8, 0, 1);
+
+		if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M) {
+			u8 tmp;
+
+			/* Change YUYV to YYUV */
+			tmp = pix[1];
+			pix[1] = pix[2];
+			pix[2] = tmp;
+			for (w = wstart/2*2, pos = dev->line + w*pixsize; w < wend; w += 2, pos += pixsize)
+				memcpy(pos, pix, pixsize);
+			for (w = wstart/2*2, pos = dev->line + MAX_WIDTH * 2 + w*pixsize/2; w < wend; w += 2, pos += pixsize / 2)
+				memcpy(pos, pix + 1, pixsize / 2);
+			for (w = wstart/2*2, pos = dev->line + MAX_WIDTH * 4 + w*pixsize/2; w < wend; w += 2, pos += pixsize / 2)
+				memcpy(pos, pix + 2, pixsize / 2);
+		} else {
+			for (w = wstart/2*2, pos = dev->line + w*pixsize; w < wend; w += 2, pos += pixsize2)
+				memcpy(pos, pix, pixsize2);
+		}
 	}
 }
 
@@ -600,6 +634,7 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
 	int stride = dev->width * dev->pixelsize;
+	unsigned planes = 1;
 	int hmax = dev->height;
 	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned ms;
@@ -611,15 +646,38 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	if (!vbuf)
 		return;
 
-	linestart = dev->line + (dev->mv_count % dev->width) * dev->pixelsize;
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+
+	if (planes > 1) {
+		void *vbuf1 = vb2_plane_vaddr(&buf->vb, 1);
+		void *vbuf2 = vb2_plane_vaddr(&buf->vb, 2);
+
+		memset(vbuf, 128, 128);
+		vbuf += 128;
+		linestart = dev->line + (dev->mv_count % dev->width) * dev->pixelsize / 2;
+		for (h = 0; h < hmax; h++)
+			memcpy(vbuf + h * stride / 2, linestart, stride / 2);
 
-	for (h = 0; h < hmax; h++)
-		memcpy(vbuf + h * stride, linestart, stride);
+		linestart = dev->line + MAX_WIDTH * 2 + ((dev->mv_count % dev->width) * dev->pixelsize) / 4;
+		for (h = 0; h < hmax; h++)
+			memcpy(vbuf1 + h * stride / 4, linestart, stride / 4);
+
+		linestart = dev->line + MAX_WIDTH * 4 + ((dev->mv_count % dev->width) * dev->pixelsize) / 4;
+		for (h = 0; h < hmax; h++)
+			memcpy(vbuf2 + h * stride / 4, linestart, stride / 4);
+		goto done;
+	} else {
+		linestart = dev->line + (dev->mv_count % dev->width) * dev->pixelsize;
+
+		for (h = 0; h < hmax; h++)
+			memcpy(vbuf + h * stride, linestart, stride);
+	}
 
 	/* Updates stream time */
 
-	gen_twopix(dev, (u8 *)&dev->textbg, TEXT_BLACK, /*odd=*/ 0);
-	gen_twopix(dev, (u8 *)&dev->textfg, WHITE, /*odd=*/ 0);
+	gen_twopix(dev, (u8 *)&dev->textbg, TEXT_BLACK, 0, /*odd=*/ 0);
+	gen_twopix(dev, (u8 *)&dev->textfg, WHITE, 0, /*odd=*/ 0);
 
 	dev->ms += jiffies_to_msecs(jiffies - dev->jiffies);
 	dev->jiffies = jiffies;
@@ -669,6 +727,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 
 	dev->mv_count += 2;
 
+done:
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	buf->vb.v4l2_buf.sequence = dev->seq_count++;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
@@ -822,8 +881,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 			return -EINVAL;
 	}
 
-	*nplanes = 1;
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
 
+	*nplanes = 1;
 	sizes[0] = size;
 
 	/*
@@ -872,6 +933,121 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int queue_setup_mplane(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	unsigned planes = 1;
+	unsigned size = dev->width * dev->height * dev->pixelsize;
+
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+	if (fmt) {
+		if (fmt->fmt.pix_mp.num_planes != planes)
+			return -EINVAL;
+		sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
+		if (planes == 3) {
+			sizes[1] = fmt->fmt.pix_mp.plane_fmt[1].sizeimage;
+			sizes[2] = fmt->fmt.pix_mp.plane_fmt[2].sizeimage;
+			if (sizes[0] < dev->width * dev->height + 128 ||
+			    sizes[1] < dev->width * dev->height / 2 ||
+			    sizes[2] < dev->width * dev->height / 2)
+				return -EINVAL;
+		} else if (sizes[0] < size) {
+			return -EINVAL;
+		}
+	} else {
+		if (planes == 3) {
+			sizes[0] = dev->width * dev->height + 128;
+			sizes[1] = sizes[0] / 2;
+			sizes[2] = sizes[0] / 2;
+		} else {
+			sizes[0] = size;
+		}
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = planes;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	if (planes == 3)
+		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u, %u\n", __func__,
+			*nbuffers, sizes[0], sizes[1], sizes[2]);
+	else
+		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
+			*nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int buffer_prepare_mplane(struct vb2_buffer *vb)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size;
+	unsigned planes = 1;
+
+	dprintk(dev, 1, "%s, field=%d\n", __func__, vb->v4l2_buf.field);
+
+	if (WARN_ON(NULL == dev->fmt))
+		return -EINVAL;
+
+	/*
+	 * Theses properties only change when queue is idle, see s_fmt.
+	 * The below checks should not be performed here, on each
+	 * buffer_prepare (i.e. on each qbuf). Most of the code in this function
+	 * should thus be moved to buffer_init and s_fmt.
+	 */
+	if (dev->width  < 48 || dev->width  > MAX_WIDTH ||
+	    dev->height < 32 || dev->height > MAX_HEIGHT)
+		return -EINVAL;
+
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+	size = dev->width * dev->height;
+	if (planes == 3) {
+		if (vb2_plane_size(vb, 0) < size + 128) {
+			dprintk(dev, 1, "%s data will not fit into plane 0 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size);
+			return -EINVAL;
+		}
+		if (vb2_plane_size(vb, 1) < size / 4) {
+			dprintk(dev, 1, "%s data will not fit into plane 1 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 1), size / 4);
+			return -EINVAL;
+		}
+		if (vb2_plane_size(vb, 2) < size / 4) {
+			dprintk(dev, 1, "%s data will not fit into plane 2 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 2), size / 4);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(vb, 0, size + 128);
+		vb->v4l2_planes[0].data_offset = 128;
+		vb2_set_plane_payload(vb, 1, size / 2);
+		vb2_set_plane_payload(vb, 2, size / 2);
+	} else {
+		size *= dev->pixelsize;
+		if (vb2_plane_size(vb, 0) < size) {
+			dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, 0, size);
+	}
+
+	precalculate_bars(dev);
+	precalculate_line(dev);
+
+	return 0;
+}
+
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
@@ -936,6 +1112,16 @@ static const struct vb2_ops vivi_video_qops = {
 	.wait_finish		= vivi_lock,
 };
 
+static const struct vb2_ops vivi_video_mplane_qops = {
+	.queue_setup		= queue_setup_mplane,
+	.buf_prepare		= buffer_prepare_mplane,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vivi_unlock,
+	.wait_finish		= vivi_lock,
+};
+
 /* ------------------------------------------------------------------
 	IOCTL vidioc handling
    ------------------------------------------------------------------*/
@@ -948,8 +1134,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->card, "vivi");
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", dev->v4l2_dev.name);
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_READWRITE;
+	cap->device_caps = multiplanar ? V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+			 V4L2_CAP_VIDEO_CAPTURE;
+	cap->device_caps |= V4L2_CAP_STREAMING  | V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -1041,6 +1228,123 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct vivi_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats) + ARRAY_SIZE(mplane_formats))
+		return -EINVAL;
+
+	if (f->index < ARRAY_SIZE(formats))
+		fmt = &formats[f->index];
+	else
+		fmt = &mplane_formats[f->index - ARRAY_SIZE(formats)];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+
+	mp->width        = dev->width;
+	mp->height       = dev->height;
+	mp->field        = V4L2_FIELD_INTERLACED;
+	mp->pixelformat  = dev->fmt->fourcc;
+	if (dev->fmt->is_yuv)
+		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		mp->colorspace = V4L2_COLORSPACE_SRGB;
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M) {
+		mp->num_planes = 3;
+		mp->plane_fmt[0].sizeimage = mp->width * mp->height + 128;
+		mp->plane_fmt[0].bytesperline = mp->width;
+		mp->plane_fmt[1].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[1].bytesperline = mp->width / 2;
+		mp->plane_fmt[2].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[2].bytesperline = mp->width / 2;
+	} else {
+		mp->num_planes = 1;
+		mp->plane_fmt[0].bytesperline = (mp->width * dev->fmt->depth) >> 3;
+		mp->plane_fmt[0].sizeimage =
+			mp->height * mp->plane_fmt[0].bytesperline;
+	}
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+
+	fmt = get_format(f);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			mp->pixelformat);
+		mp->pixelformat = V4L2_PIX_FMT_YUV422M;
+		fmt = get_format(f);
+	}
+
+	mp->field = V4L2_FIELD_INTERLACED;
+	v4l_bound_align_image(&mp->width, 48, MAX_WIDTH, 2,
+			      &mp->height, 32, MAX_HEIGHT, 0, 0);
+	if (fmt->fourcc == V4L2_PIX_FMT_YUV422M) {
+		mp->num_planes = 3;
+		memset(mp->plane_fmt, 0,
+		       mp->num_planes * sizeof(mp->plane_fmt[0]));
+		mp->plane_fmt[0].sizeimage = mp->width * mp->height + 128;
+		mp->plane_fmt[0].bytesperline = mp->width;
+		mp->plane_fmt[1].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[1].bytesperline = mp->width / 2;
+		mp->plane_fmt[2].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[2].bytesperline = mp->width / 2;
+	} else {
+		mp->num_planes = 1;
+		memset(mp->plane_fmt, 0,
+		       mp->num_planes * sizeof(mp->plane_fmt[0]));
+		mp->plane_fmt[0].bytesperline = (mp->width * fmt->depth) >> 3;
+		mp->plane_fmt[0].sizeimage =
+			mp->height * mp->plane_fmt[0].bytesperline;
+	}
+	if (fmt->is_yuv)
+		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		mp->colorspace = V4L2_COLORSPACE_SRGB;
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct vivi_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_vidq;
+	int ret = vidioc_try_fmt_vid_cap_mplane(file, priv, f);
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(q)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	dev->fmt = get_format(f);
+	dev->pixelsize = dev->fmt->depth / 8;
+	dev->width = mp->width;
+	dev->height = mp->height;
+
+	return 0;
+}
+
 static int vidioc_enum_framesizes(struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize)
 {
@@ -1141,7 +1445,8 @@ static int vidioc_g_parm(struct file *file, void *priv,
 {
 	struct vivi_dev *dev = video_drvdata(file);
 
-	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (parm->type != multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+					V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
@@ -1159,7 +1464,8 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	struct vivi_dev *dev = video_drvdata(file);
 	struct v4l2_fract tpf;
 
-	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (parm->type != multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+					V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	tpf = parm->parm.capture.timeperframe;
@@ -1313,7 +1619,7 @@ static const struct v4l2_file_operations vivi_fops = {
 	.release        = vb2_fop_release,
 	.read           = vb2_fop_read,
 	.poll		= vb2_fop_poll,
-	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl = video_ioctl2,
 	.mmap           = vb2_fop_mmap,
 };
 
@@ -1330,6 +1636,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_querybuf      = vb2_ioctl_querybuf,
 	.vidioc_qbuf          = vb2_ioctl_qbuf,
 	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_expbuf        = vb2_ioctl_expbuf,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
@@ -1343,11 +1650,31 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static const struct video_device vivi_template = {
-	.name		= "vivi",
-	.fops           = &vivi_fops,
-	.ioctl_ops 	= &vivi_ioctl_ops,
-	.release	= video_device_release_empty,
+static const struct v4l2_ioctl_ops vivi_mplanar_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane  = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_g_fmt_vid_cap_mplane     = vidioc_g_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_cap_mplane   = vidioc_try_fmt_vid_cap_mplane,
+	.vidioc_s_fmt_vid_cap_mplane     = vidioc_s_fmt_vid_cap_mplane,
+	.vidioc_enum_framesizes   = vidioc_enum_framesizes,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_expbuf        = vb2_ioctl_expbuf,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_g_parm        = vidioc_g_parm,
+	.vidioc_s_parm        = vidioc_s_parm,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /* -----------------------------------------------------------------
@@ -1436,11 +1763,12 @@ static int __init vivi_create_instance(int inst)
 
 	/* initialize queue */
 	q = &dev->vb_vidq;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->type = multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+				V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct vivi_buffer);
-	q->ops = &vivi_video_qops;
+	q->ops = multiplanar ? &vivi_video_mplane_qops : &vivi_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
@@ -1455,8 +1783,10 @@ static int __init vivi_create_instance(int inst)
 	init_waitqueue_head(&dev->vidq.wq);
 
 	vfd = &dev->vdev;
-	*vfd = vivi_template;
-	vfd->debug = debug;
+	strlcpy(vfd->name, "vivi", sizeof(vfd->name));
+	vfd->fops = &vivi_fops;
+	vfd->ioctl_ops = multiplanar ? &vivi_mplanar_ioctl_ops : &vivi_ioctl_ops;
+	vfd->release = video_device_release_empty;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->queue = q;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..39c4ab4 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -356,6 +356,7 @@ struct v4l2_pix_format {
 /* three non contiguous planes - Y, Cb, Cr */
 #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
 #define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'M', '2', '1') /* 12  YVU420 planar */
+#define V4L2_PIX_FMT_YUV422M v4l2_fourcc('4', '2', '2', 'M') /* 16  YVU422 planar */
 
 /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
-- 
1.9.0

