Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61789 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1LAKU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 05:20:59 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVI00B6HSQXU7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVI007QESQWCW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Dec 2011 10:20:57 +0000 (GMT)
Date: Thu, 01 Dec 2011 11:20:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v2 3/4] s5p-fimc: Add support for media bus framesamples
 parameter
In-reply-to: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1322734853-8759-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1322734853-8759-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The framesamples field of struct v4l2_mbus_framefmt is used to
retrieve an exact required maximum memory buffer size for a
compressed data frame from the sensor subdev. This allows to
avoid allocating huge buffers in the host driver.

To make sure the size of allocated buffers is correct for a
subdev configuration during VIDIOC_STREAMON ioctl, the video
pipeline validation has been extended with an additional
check.

Flag FMT_FLAGS_COMPRESSED indicates the buffer size should
be determined through the framesamples member of struct
v4l2_mbus_framefmt.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   53 +++++++++++++++++++++++++--
 drivers/media/video/s5p-fimc/fimc-core.c    |    7 +++-
 drivers/media/video/s5p-fimc/fimc-core.h    |    5 ++-
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 8ca4d32..48b2592 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -250,6 +250,10 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 {
 	if (!fr || plane >= fr->fmt->memplanes)
 		return 0;
+
+	if (fimc_fmt_is_jpeg(fr->fmt->color))
+		return fr->payload[0];
+
 	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
 }
 
@@ -722,6 +726,29 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	return 0;
 }
 
+/* Query the sensor for required buffer size (applicable to compressed data). */
+static int fimc_capture_get_sizeimage(struct fimc_dev *fimc, unsigned int *size)
+{
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_subdev_format sfmt;
+	int ret;
+
+	sfmt.pad = 0;
+	sfmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sfmt);
+	if (ret < 0)
+		return ret;
+
+	if (sfmt.format.framesamples > FIMC_MAX_JPEG_BUF_SIZE) {
+		v4l2_err(sd, "Unsupported frame buffer size\n");
+		return -EINVAL;
+	}
+
+	*size = sfmt.format.framesamples;
+
+	return 0;
+}
+
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
@@ -774,7 +801,11 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	}
 
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
-	return 0;
+
+	if (!(ffmt->flags & FMT_FLAGS_COMPRESSED))
+		return 0;
+
+	return fimc_capture_get_sizeimage(fimc, &pix->plane_fmt[0].sizeimage);
 }
 
 static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx, bool jpeg)
@@ -837,9 +868,17 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		pix->height = mf->height;
 	}
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-	for (i = 0; i < ff->fmt->colplanes; i++)
-		ff->payload[i] =
-			(pix->width * pix->height * ff->fmt->depth[i]) / 8;
+
+	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
+		ret = fimc_capture_get_sizeimage(fimc, &ff->payload[0]);
+		if (ret < 0)
+			return ret;
+		pix->plane_fmt[0].sizeimage = ff->payload[0];
+	} else {
+		for (i = 0; i < ff->fmt->colplanes; i++)
+			ff->payload[i] = pix->width * pix->height *
+					 ff->fmt->depth[i] / 8;
+	}
 
 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
@@ -948,6 +987,12 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.height != sink_fmt.format.height ||
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
+
+		if (sd == fimc->pipeline.sensor &&
+		    src_fmt.format.code == V4L2_MBUS_FMT_JPEG_1X8 &&
+		    vid_cap->ctx->d_frame.payload[0] <
+		    src_fmt.format.framesamples)
+			return -EPIPE;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index caf1c08..331beda 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -183,7 +183,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 1,
 		.colplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
-		.flags		= FMT_FLAGS_CAM,
+		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
 
@@ -965,6 +965,11 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
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
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 21e4ad4..643dc0e 100644
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
@@ -168,6 +170,7 @@ struct fimc_fmt {
 #define FMT_FLAGS_M2M_OUT	(1 << 2)
 #define FMT_FLAGS_M2M		(1 << 1 | 1 << 2)
 #define FMT_HAS_ALPHA		(1 << 3)
+#define FMT_FLAGS_COMPRESSED	(1 << 4)
 };
 
 /**
@@ -285,7 +288,7 @@ struct fimc_frame {
 	u32	offs_v;
 	u32	width;
 	u32	height;
-	unsigned long		payload[VIDEO_MAX_PLANES];
+	unsigned int		payload[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
-- 
1.7.7.2

