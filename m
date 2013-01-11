Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30468 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3AKKgd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 05:36:33 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG0068OISV6A50@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 19:36:31 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGG005GOISL9O40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 19:36:30 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Fix bytesperline value for V4L2_PIX_FMT_YUV420M
 format
Date: Fri, 11 Jan 2013 11:36:19 +0100
Message-id: <1357900579-22267-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure bytesperline for Cb, Cr planes for V4L2_PIX_FMT_YUV420M
format is half of the Y plane value, rather than having same
bytesperline for all planes.

While at it, simplify the bytesperline parameter handling by
storing it when image format is set and returning those values
when getting the format, instead of recalculating bytesperline
from intermediate parameters.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    8 ++++---
 drivers/media/platform/s5p-fimc/fimc-core.c    |   27 +++++++++++-------------
 drivers/media/platform/s5p-fimc/fimc-core.h    |    4 +++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    7 +++---
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 1ef682b..784ed1e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -960,9 +960,9 @@ static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;

-	return fimc_fill_format(&ctx->d_frame, f);
+	__fimc_get_format(&fimc->vid_cap.ctx->d_frame, f);
+	return 0;
 }

 static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
@@ -1084,8 +1084,10 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 			return ret;
 	}

-	for (i = 0; i < ff->fmt->memplanes; i++)
+	for (i = 0; i < ff->fmt->memplanes; i++) {
+		ff->bytesperline[i] = pix->plane_fmt[i].bytesperline;
 		ff->payload[i] = pix->plane_fmt[i].sizeimage;
+	}

 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index d0b748e..800b837 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -697,7 +697,7 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
 	v4l2_ctrl_unlock(ctrl);
 }

-int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
+void __fimc_get_format(struct fimc_frame *frame, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
 	int i;
@@ -710,19 +710,9 @@ int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f)
 	pixm->num_planes = frame->fmt->memplanes;

 	for (i = 0; i < pixm->num_planes; ++i) {
-		int bpl = frame->f_width;
-		if (frame->fmt->colplanes == 1) /* packed formats */
-			bpl = (bpl * frame->fmt->depth[0]) / 8;
-		pixm->plane_fmt[i].bytesperline = bpl;
-
-		if (frame->fmt->flags & FMT_FLAGS_COMPRESSED) {
-			pixm->plane_fmt[i].sizeimage = frame->payload[i];
-			continue;
-		}
-		pixm->plane_fmt[i].sizeimage = (frame->o_width *
-			frame->o_height * frame->fmt->depth[i]) / 8;
+		pixm->plane_fmt[i].bytesperline = frame->bytesperline[i];
+		pixm->plane_fmt[i].sizeimage = frame->payload[i];
 	}
-	return 0;
 }

 void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f)
@@ -771,9 +761,16 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 		if (fmt->colplanes == 1 && /* Packed */
 		    (bpl == 0 || ((bpl * 8) / fmt->depth[i]) < pix->width))
 			bpl = (pix->width * fmt->depth[0]) / 8;
-
-		if (i == 0) /* Same bytesperline for each plane. */
+		/*
+		 * Currently bytesperline for each plane is same, except
+		 * V4L2_PIX_FMT_YUV420M format. This calculation may need
+		 * to be changed when other multi-planar formats are added
+		 * to the fimc_formats[] array.
+		 */
+		if (i == 0)
 			bytesperline = bpl;
+		else if (i == 1 && fmt->memplanes == 3)
+			bytesperline /= 2;

 		plane_fmt->bytesperline = bytesperline;
 		plane_fmt->sizeimage = max((pix->width * pix->height *
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index be2c8d7..4555035 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -266,6 +266,7 @@ struct fimc_vid_buffer {
  * @width:	image pixel width
  * @height:	image pixel weight
  * @payload:	image size in bytes (w x h x bpp)
+ * @bytesperline: bytesperline value for each plane
  * @paddr:	image frame buffer physical addresses
  * @dma_offset:	DMA offset in bytes
  * @fmt:	fimc color format pointer
@@ -280,6 +281,7 @@ struct fimc_frame {
 	u32	width;
 	u32	height;
 	unsigned int		payload[VIDEO_MAX_PLANES];
+	unsigned int		bytesperline[VIDEO_MAX_PLANES];
 	struct fimc_addr	paddr;
 	struct fimc_dma_offset	dma_offset;
 	struct fimc_fmt		*fmt;
@@ -639,7 +641,7 @@ int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
 void fimc_alpha_ctrl_update(struct fimc_ctx *ctx);
-int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
+void __fimc_get_format(struct fimc_frame *frame, struct v4l2_format *f);
 void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 			       struct v4l2_pix_format_mplane *pix);
 struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 1d57f3b..1eabd7e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -294,7 +294,8 @@ static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);

-	return fimc_fill_format(frame, f);
+	__fimc_get_format(frame, f);
+	return 0;
 }

 static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
@@ -389,8 +390,8 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	fimc_alpha_ctrl_update(ctx);

 	for (i = 0; i < frame->fmt->colplanes; i++) {
-		frame->payload[i] =
-			(pix->width * pix->height * frame->fmt->depth[i]) / 8;
+		frame->bytesperline[i] = pix->plane_fmt[i].bytesperline;
+		frame->payload[i] = pix->plane_fmt[i].sizeimage;
 	}

 	fimc_fill_frame(frame, f);
--
1.7.9.5

