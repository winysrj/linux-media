Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0074.outbound.protection.outlook.com ([104.47.38.74]:43344
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751988AbeECCnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:12 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 6/8] v4l: xilinx: dma: Add multi-planar support
Date: Wed, 2 May 2018 19:42:51 -0700
Message-ID: <baa903ee39bea47aee4ab5b46f03f025fd663227.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current v4l driver supports single plane formats. This patch
adds support to handle multi-planar formats. Driver can handle
both single and multi-planar formats.

Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
Changes in v5:
 - Added default height
 - Corrected sizeimage declaration with u32

Changes in v4:
 - Single plane implementation is removed as multi-plane supports both
 - num_buffers and bpl_factor parameters are removed to have clean
   implementation

 drivers/media/platform/xilinx/xilinx-dma.c  | 150 +++++++++++++++++-----------
 drivers/media/platform/xilinx/xilinx-dma.h  |   4 +-
 drivers/media/platform/xilinx/xilinx-vipp.c |  16 +--
 3 files changed, 104 insertions(+), 66 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 518d572..2ffc276 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -74,8 +74,8 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
 		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
 
 	if (dma->fmtinfo->code != fmt.format.code ||
-	    dma->format.height != fmt.format.height ||
-	    dma->format.width != fmt.format.width)
+	    dma->format.fmt.pix_mp.width != fmt.format.width ||
+	    dma->format.fmt.pix_mp.height != fmt.format.height)
 		return -EINVAL;
 
 	return 0;
@@ -310,7 +310,8 @@ static void xvip_dma_complete(void *param)
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = dma->sequence++;
 	buf->buf.vb2_buf.timestamp = ktime_get_ns();
-	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0,
+			      dma->format.fmt.pix_mp.plane_fmt[0].sizeimage);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
@@ -320,13 +321,15 @@ xvip_dma_queue_setup(struct vb2_queue *vq,
 		     unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
+	u32 sizeimage;
 
 	/* Make sure the image size is large enough. */
+	sizeimage = dma->format.fmt.pix_mp.plane_fmt[0].sizeimage;
 	if (*nplanes)
-		return sizes[0] < dma->format.sizeimage ? -EINVAL : 0;
+		return sizes[0] < sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-	sizes[0] = dma->format.sizeimage;
+	sizes[0] = sizeimage;
 
 	return 0;
 }
@@ -350,8 +353,9 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 	struct dma_async_tx_descriptor *desc;
 	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	u32 flags;
+	struct v4l2_pix_format_mplane *pix_mp = &dma->format.fmt.pix_mp;
 
-	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
 		dma->xt.dir = DMA_DEV_TO_MEM;
 		dma->xt.src_sgl = false;
@@ -365,10 +369,11 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 		dma->xt.src_start = addr;
 	}
 
-	dma->xt.frame_size = 1;
-	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp[0];
-	dma->sgl[0].icg = dma->format.bytesperline - dma->sgl[0].size;
-	dma->xt.numf = dma->format.height;
+	dma->xt.frame_size = dma->fmtinfo->num_planes;
+	dma->sgl[0].size = pix_mp->width * dma->fmtinfo->bpp[0];
+	dma->sgl[0].icg = pix_mp->plane_fmt[0].bytesperline - dma->sgl[0].size;
+	dma->xt.numf = pix_mp->height;
+	dma->sgl[0].dst_icg = 0;
 
 	desc = dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
 	if (!desc) {
@@ -496,11 +501,12 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | dma->xdev->v4l2_caps;
+	cap->device_caps = V4L2_CAP_STREAMING;
 
-	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 	else
-		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 
 	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
 	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
@@ -524,7 +530,7 @@ xvip_dma_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 	if (f->index > 0)
 		return -EINVAL;
 
-	f->pixelformat = dma->format.pixelformat;
+	f->pixelformat = dma->format.fmt.pix_mp.pixelformat;
 	strlcpy(f->description, dma->fmtinfo->description,
 		sizeof(f->description));
 
@@ -537,13 +543,14 @@ xvip_dma_get_format(struct file *file, void *fh, struct v4l2_format *format)
 	struct v4l2_fh *vfh = file->private_data;
 	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
 
-	format->fmt.pix = dma->format;
+	format->fmt.pix_mp = dma->format.fmt.pix_mp;
 
 	return 0;
 }
 
 static void
-__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
+__xvip_dma_try_format(struct xvip_dma *dma,
+		      struct v4l2_format *format,
 		      const struct xvip_video_format **fmtinfo)
 {
 	const struct xvip_video_format *info;
@@ -551,19 +558,20 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
 	unsigned int max_width;
 	unsigned int min_bpl;
 	unsigned int max_bpl;
-	unsigned int width;
+	unsigned int width, height;
 	unsigned int align;
 	unsigned int bpl;
+	struct v4l2_pix_format_mplane *pix_mp = &format->fmt.pix_mp;
+	struct v4l2_plane_pix_format *plane_fmt = pix_mp->plane_fmt;
 
 	/* Retrieve format information and select the default format if the
 	 * requested format isn't supported.
 	 */
-	info = xvip_get_format_by_fourcc(pix->pixelformat);
+	info = xvip_get_format_by_fourcc(pix_mp->pixelformat);
 	if (IS_ERR(info))
 		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
 
-	pix->pixelformat = info->fourcc;
-	pix->field = V4L2_FIELD_NONE;
+	pix_mp->field = V4L2_FIELD_NONE;
 
 	/* The transfer alignment requirements are expressed in bytes. Compute
 	 * the minimum and maximum values, clamp the requested width and convert
@@ -572,22 +580,41 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
 	align = lcm(dma->align, info->bpp[0]);
 	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
 	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
-	width = rounddown(pix->width * info->bpp[0], align);
+	pix_mp->width = clamp(pix_mp->width, min_width, max_width);
+	pix_mp->height = clamp(pix_mp->height, XVIP_DMA_MIN_HEIGHT,
+			       XVIP_DMA_MAX_HEIGHT);
 
-	pix->width = clamp(width, min_width, max_width) / info->bpp[0];
-	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
-			    XVIP_DMA_MAX_HEIGHT);
-
-	/* Clamp the requested bytes per line value. If the maximum bytes per
-	 * line value is zero, the module doesn't support user configurable line
-	 * sizes. Override the requested value with the minimum in that case.
+	/*
+	 * Clamp the requested bytes per line value. If the maximum
+	 * bytes per line value is zero, the module doesn't support
+	 * user configurable line sizes. Override the requested value
+	 * with the minimum in that case.
 	 */
-	min_bpl = pix->width * info->bpp[0];
-	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
-	bpl = rounddown(pix->bytesperline, dma->align);
-
-	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
-	pix->sizeimage = pix->bytesperline * pix->height;
+	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, align);
+	min_bpl = pix_mp->width * info->bpp[0];
+	min_bpl = roundup(min_bpl, align);
+	bpl = roundup(plane_fmt[0].bytesperline, align);
+	plane_fmt[0].bytesperline = clamp(bpl, min_bpl, max_bpl);
+
+	if (info->num_planes == 1) {
+		/* Single plane formats */
+		plane_fmt[0].sizeimage = plane_fmt[0].bytesperline *
+					 pix_mp->height;
+	} else {
+		/*
+		 * Supports Multi plane formats in a contiguous buffer,
+		 * so we need only one buffer
+		 */
+		unsigned int i;
+
+		plane_fmt[0].sizeimage = 0;
+		for (i = 0; i < info->num_planes; i++) {
+			width = plane_fmt[0].bytesperline /
+				(i ? info->hsub : 1);
+			height = pix_mp->height / (i ? info->vsub : 1);
+			plane_fmt[0].sizeimage += width * info->bpp[i] * height;
+		}
+	}
 
 	if (fmtinfo)
 		*fmtinfo = info;
@@ -599,7 +626,7 @@ xvip_dma_try_format(struct file *file, void *fh, struct v4l2_format *format)
 	struct v4l2_fh *vfh = file->private_data;
 	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
 
-	__xvip_dma_try_format(dma, &format->fmt.pix, NULL);
+	__xvip_dma_try_format(dma, format, NULL);
 	return 0;
 }
 
@@ -610,12 +637,13 @@ xvip_dma_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
 	const struct xvip_video_format *info;
 
-	__xvip_dma_try_format(dma, &format->fmt.pix, &info);
+	__xvip_dma_try_format(dma, format, &info);
 
 	if (vb2_is_busy(&dma->queue))
 		return -EBUSY;
 
-	dma->format = format->fmt.pix;
+	dma->format.fmt.pix_mp = format->fmt.pix_mp;
+
 	dma->fmtinfo = info;
 
 	return 0;
@@ -623,13 +651,14 @@ xvip_dma_set_format(struct file *file, void *fh, struct v4l2_format *format)
 
 static const struct v4l2_ioctl_ops xvip_dma_ioctl_ops = {
 	.vidioc_querycap		= xvip_dma_querycap,
-	.vidioc_enum_fmt_vid_cap	= xvip_dma_enum_format,
-	.vidioc_g_fmt_vid_cap		= xvip_dma_get_format,
-	.vidioc_g_fmt_vid_out		= xvip_dma_get_format,
-	.vidioc_s_fmt_vid_cap		= xvip_dma_set_format,
-	.vidioc_s_fmt_vid_out		= xvip_dma_set_format,
-	.vidioc_try_fmt_vid_cap		= xvip_dma_try_format,
-	.vidioc_try_fmt_vid_out		= xvip_dma_try_format,
+	.vidioc_enum_fmt_vid_cap_mplane	= xvip_dma_enum_format,
+	.vidioc_enum_fmt_vid_out_mplane	= xvip_dma_enum_format,
+	.vidioc_g_fmt_vid_cap_mplane	= xvip_dma_get_format,
+	.vidioc_g_fmt_vid_out_mplane	= xvip_dma_get_format,
+	.vidioc_s_fmt_vid_cap_mplane	= xvip_dma_set_format,
+	.vidioc_s_fmt_vid_out_mplane	= xvip_dma_set_format,
+	.vidioc_try_fmt_vid_cap_mplane	= xvip_dma_try_format,
+	.vidioc_try_fmt_vid_out_mplane	= xvip_dma_try_format,
 	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
@@ -662,6 +691,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 {
 	char name[16];
 	int ret;
+	struct v4l2_pix_format_mplane *pix_mp;
 
 	dma->xdev = xdev;
 	dma->port = port;
@@ -671,17 +701,22 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	spin_lock_init(&dma->queued_lock);
 
 	dma->fmtinfo = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
-	dma->format.pixelformat = dma->fmtinfo->fourcc;
-	dma->format.colorspace = V4L2_COLORSPACE_SRGB;
-	dma->format.field = V4L2_FIELD_NONE;
-	dma->format.width = XVIP_DMA_DEF_WIDTH;
-	dma->format.height = XVIP_DMA_DEF_HEIGHT;
-	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp[0];
-	dma->format.sizeimage = dma->format.bytesperline * dma->format.height;
+	dma->format.type = type;
+
+	pix_mp = &dma->format.fmt.pix_mp;
+	pix_mp->pixelformat = dma->fmtinfo->fourcc;
+	pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->width = XVIP_DMA_DEF_WIDTH;
+	pix_mp->height = XVIP_DMA_DEF_HEIGHT;
+	pix_mp->plane_fmt[0].bytesperline = pix_mp->width *
+					    dma->fmtinfo->bpp[0];
+	pix_mp->plane_fmt[0].sizeimage = pix_mp->plane_fmt[0].bytesperline *
+					 pix_mp->height;
 
 	/* Initialize the media entity... */
-	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
-		       ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
+			? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
 	ret = media_entity_pads_init(&dma->video.entity, 1, &dma->pad);
 	if (ret < 0)
@@ -693,11 +728,14 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	dma->video.queue = &dma->queue;
 	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
 		 xdev->dev->of_node->name,
-		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
+		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
+					? "output" : "input",
 		 port);
+
 	dma->video.vfl_type = VFL_TYPE_GRABBER;
-	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
-			   ? VFL_DIR_RX : VFL_DIR_TX;
+	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
+				? VFL_DIR_RX : VFL_DIR_TX;
+
 	dma->video.release = video_device_release_empty;
 	dma->video.ioctl_ops = &xvip_dma_ioctl_ops;
 	dma->video.lock = &dma->lock;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
index e95d136..96933ed 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.h
+++ b/drivers/media/platform/xilinx/xilinx-dma.h
@@ -62,7 +62,7 @@ static inline struct xvip_pipeline *to_xvip_pipeline(struct media_entity *e)
  * @pipe: pipeline belonging to the DMA channel
  * @port: composite device DT node port number for the DMA channel
  * @lock: protects the @format, @fmtinfo and @queue fields
- * @format: active V4L2 pixel format
+ * @format: V4L2 format
  * @fmtinfo: format information corresponding to the active @format
  * @queue: vb2 buffers queue
  * @sequence: V4L2 buffers sequence number
@@ -83,7 +83,7 @@ struct xvip_dma {
 	unsigned int port;
 
 	struct mutex lock;
-	struct v4l2_pix_format format;
+	struct v4l2_format format;
 	const struct xvip_video_format *fmtinfo;
 
 	struct vb2_queue queue;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 6bb28cd..509b50f 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -433,12 +433,15 @@ static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
 	if (ret < 0)
 		return ret;
 
-	if (strcmp(direction, "input") == 0)
-		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	else if (strcmp(direction, "output") == 0)
-		type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	else
+	if (strcmp(direction, "input") == 0) {
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		xdev->v4l2_caps |= V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+	} else if (strcmp(direction, "output") == 0) {
+		type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+		xdev->v4l2_caps |= V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	} else {
 		return -EINVAL;
+	}
 
 	of_property_read_u32(node, "reg", &index);
 
@@ -454,9 +457,6 @@ static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
 
 	list_add_tail(&dma->list, &xdev->dmas);
 
-	xdev->v4l2_caps |= type == V4L2_BUF_TYPE_VIDEO_CAPTURE
-			 ? V4L2_CAP_VIDEO_CAPTURE : V4L2_CAP_VIDEO_OUTPUT;
-
 	return 0;
 }
 
-- 
2.7.4
