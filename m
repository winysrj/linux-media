Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50613 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab1KCRBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 13:01:46 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LU300MJSGMWWO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU3006MQGMW98@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Date: Thu, 03 Nov 2011 18:01:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 2/3] s5p-fimc: Add g_framesamples subdev operation support
In-reply-to: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320339694-9027-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usually only the subdevs have exact knowledge about buffer size
requirements for a compressed data transfer over the video bus.

The .g_framesamples() subdev callback is used to retrieve an exact
required maximum  memory buffer size for a compressed data frame from
a subdev. This allows to avoid allocating huge buffers in the host
driver.

To make sure the allocated buffers are big enough for a subdev
configuration at the time of VIDIOC_STREAMON, the video pipeline
validation has been extended with an additional check.

Flag FMT_FLAGS_COMPRESSED indicates that the buffer size have to be
determined by means of .s_framesamples() callback.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   63 +++++++++++++++++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.c    |   11 ++++-
 drivers/media/video/s5p-fimc/fimc-core.h    |    9 +++-
 3 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2092bcb..08fb9c5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -246,6 +246,10 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 {
 	if (!fr || plane >= fr->fmt->memplanes)
 		return 0;
+
+	if (fr->fmt->flags & FMT_FLAGS_COMPRESSED)
+		return fr->payload[0];
+
 	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
 }
 
@@ -730,6 +734,28 @@ static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 	return fimc_fill_format(&ctx->d_frame, f);
 }
 
+/*
+ * For all compressed image formats supported by this driver one
+ * media bus sample corresponds to one byte in the output buffer.
+ */
+static int fimc_capture_get_bufsize(struct fimc_dev *fimc,
+				    struct v4l2_mbus_framefmt *mf,
+				    unsigned int *size)
+{
+	unsigned int buf_size = 0;
+
+	int ret = v4l2_subdev_call(fimc->pipeline.sensor, video,
+				   g_mbus_framesamples, mf, &buf_size);
+	if (ret)
+		return ret;
+
+	if (buf_size > FIMC_MAX_JPEG_BUF_SIZE)
+		return -EINVAL;
+
+	*size = max(min(*size, (u32)FIMC_MAX_JPEG_BUF_SIZE), buf_size);
+	return 0;
+}
+
 static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 				   struct v4l2_format *f)
 {
@@ -770,7 +796,11 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	}
 
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
-	return 0;
+
+	if (!(ffmt->flags & FMT_FLAGS_COMPRESSED))
+		return 0;
+
+	return fimc_capture_get_bufsize(fimc, &mf, &pix->plane_fmt[0].sizeimage);
 }
 
 static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx, bool jpeg)
@@ -827,9 +857,19 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		pix->height = mf->height;
 	}
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-	for (i = 0; i < ff->fmt->colplanes; i++)
-		ff->payload[i] =
-			(pix->width * pix->height * ff->fmt->depth[i]) / 8;
+
+	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
+		ret = fimc_capture_get_bufsize(fimc, mf,
+					       &pix->plane_fmt[0].sizeimage);
+		if (ret)
+			return ret;
+		ff->payload[0] = pix->plane_fmt[0].sizeimage;
+	} else {
+		for (i = 0; i < ff->fmt->colplanes; i++) {
+			ff->payload[i] = pix->width * pix->height *
+				ff->fmt->depth[i] / 8;
+		}
+	}
 
 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
@@ -938,6 +978,21 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.height != sink_fmt.format.height ||
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
+
+		if (sd == fimc->pipeline.sensor) {
+			unsigned int buf_size = 0;
+
+			if (sink_fmt.format.code != V4L2_MBUS_FMT_JPEG_1X8)
+				continue;
+
+			ret = v4l2_subdev_call(sd, video, g_mbus_framesamples,
+					       &src_fmt.format, &buf_size);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return -EPIPE;
+
+			if (!ret && vid_cap->ctx->d_frame.payload[0] < buf_size)
+				return -EPIPE;
+		}
 	}
 	return 0;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 1cc6e9e..574df1d 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -163,11 +163,10 @@ static struct fimc_fmt fimc_formats[] = {
 		.name		= "JPEG encoded data",
 		.fourcc		= V4L2_PIX_FMT_JPEG,
 		.color		= S5P_FIMC_JPEG,
-		.depth		= { 8 },
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
-		.flags		= FMT_FLAGS_CAM,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
 
@@ -900,6 +899,11 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 		if (frame->fmt->colplanes == 1) /* packed formats */
 			bpl = (bpl * frame->fmt->depth[0]) / 8;
 		pixm->plane_fmt[i].bytesperline = bpl;
+
+		if (frame->fmt->flags & FMT_FLAGS_COMPRESSED) {
+			pixm->plane_fmt[i].sizeimage = frame->payload[i];
+			continue;
+		}
 		pixm->plane_fmt[i].sizeimage = (frame->o_width *
 			frame->o_height * frame->fmt->depth[i]) / 8;
 	}
@@ -941,6 +945,9 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 	pix->height = height;
 	pix->width = width;
 
+	if (fmt->flags & FMT_FLAGS_COMPRESSED)
+		return;
+
 	for (i = 0; i < pix->num_planes; ++i) {
 		u32 bpl = pix->plane_fmt[i].bytesperline;
 		u32 *sizeimage = &pix->plane_fmt[i].sizeimage;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index c7f01c4..25b2a86 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <asm/sizes.h>
 
 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
@@ -44,6 +45,7 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
+#define FIMC_MAX_JPEG_BUF_SIZE	(10 * SZ_1M)
 
 /* indices to the clocks array */
 enum {
@@ -160,8 +162,9 @@ struct fimc_fmt {
 	u16	colplanes;
 	u8	depth[VIDEO_MAX_PLANES];
 	u16	flags;
-#define FMT_FLAGS_CAM	(1 << 0)
-#define FMT_FLAGS_M2M	(1 << 1)
+#define FMT_FLAGS_CAM		(1 << 0)
+#define FMT_FLAGS_M2M		(1 << 1)
+#define FMT_FLAGS_COMPRESSED	(1 << 2)
 };
 
 /**
@@ -279,7 +282,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	unsigned long		payload[VIDEO_MAX_PLANES];
+	unsigned int		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
-- 
1.7.7.1

