Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57124 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3LCLvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 06:51:22 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>
CC: <linux-omap@vger.kernel.org>, <hverkuil@xs4all.nl>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 2/2] v4l: ti-vpe: make sure VPDMA line stride constraints are met
Date: Tue, 3 Dec 2013 17:21:13 +0530
Message-ID: <1386071473-10808-3-git-send-email-archit@ti.com>
In-Reply-To: <1386071473-10808-1-git-send-email-archit@ti.com>
References: <1386071473-10808-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When VPDMA fetches or writes to an image buffer, the line stride must be a
multiple of 16 bytes. If it isn't, VPDMA HW will write/fetch until the next
16 byte boundry. This causes VPE to work incorrectly for source or destination
widths which don't satisfy the above alignment requirement.

In order to prevent this, we now make sure that when we set pix format for the
input and output buffers, the VPE source and destination image line strides are
16 byte aligned. Also, the motion vector buffers for the de-interlacer are
allocated in such a way that it ensures the same alignment.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c |  4 +--
 drivers/media/platform/ti-vpe/vpdma.h |  5 +++-
 drivers/media/platform/ti-vpe/vpe.c   | 53 ++++++++++++++++++++++++++---------
 3 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index af0a5ff..f97253f 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -602,7 +602,7 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect *c_rect,
 	if (fmt->data_type == DATA_TYPE_C420)
 		depth = 8;
 
-	stride = (depth * c_rect->width) >> 3;
+	stride = ALIGN((depth * c_rect->width) >> 3, VPDMA_STRIDE_ALIGN);
 	dma_addr += (c_rect->left * depth) >> 3;
 
 	dtd = list->next;
@@ -655,7 +655,7 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
 		depth = 8;
 	}
 
-	stride = (depth * c_rect->width) >> 3;
+	stride = ALIGN((depth * c_rect->width) >> 3, VPDMA_STRIDE_ALIGN);
 	dma_addr += (c_rect->left * depth) >> 3;
 
 	dtd = list->next;
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index eaa2a71..62dd143 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -45,7 +45,10 @@ struct vpdma_data_format {
 };
 
 #define VPDMA_DESC_ALIGN		16	/* 16-byte descriptor alignment */
-
+#define VPDMA_STRIDE_ALIGN		16	/*
+						 * line stride of source and dest
+						 * buffers should be 16 byte aligned
+						 */
 #define VPDMA_DTD_DESC_SIZE		32	/* 8 words */
 #define VPDMA_CFD_CTD_DESC_SIZE		16	/* 4 words */
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4e58069..a5f7a35 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
+#include <linux/log2.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -54,10 +55,6 @@
 /* required alignments */
 #define S_ALIGN		0	/* multiple of 1 */
 #define H_ALIGN		1	/* multiple of 2 */
-#define W_ALIGN		1	/* multiple of 2 */
-
-/* multiple of 128 bits, line stride, 16 bytes */
-#define L_ALIGN		4
 
 /* flags that indicate a format can be used for capture/output */
 #define VPE_FMT_TYPE_CAPTURE	(1 << 0)
@@ -780,12 +777,21 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 
 	if ((s_q_data->flags & Q_DATA_INTERLACED) &&
 			!(d_q_data->flags & Q_DATA_INTERLACED)) {
+		int bytes_per_line;
 		const struct vpdma_data_format *mv =
 			&vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
 
 		ctx->deinterlacing = 1;
-		mv_buf_size =
-			(s_q_data->width * s_q_data->height * mv->depth) >> 3;
+		/*
+		 * we make sure that the source image has a 16 byte aligned
+		 * stride, we need to do the same for the motion vector buffer
+		 * by aligning it's stride to the next 16 byte boundry. this
+		 * extra space will not be used by the de-interlacer, but will
+		 * ensure that vpdma operates correctly
+		 */
+		bytes_per_line = ALIGN((s_q_data->width * mv->depth) >> 3,
+					VPDMA_STRIDE_ALIGN);
+		mv_buf_size = bytes_per_line * s_q_data->height;
 	} else {
 		ctx->deinterlacing = 0;
 		mv_buf_size = 0;
@@ -1352,7 +1358,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 {
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *plane_fmt;
-	int i;
+	unsigned int w_align;
+	int i, depth, depth_bytes;
 
 	if (!fmt || !(fmt->types & type)) {
 		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
@@ -1363,7 +1370,31 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE)
 		pix->field = V4L2_FIELD_NONE;
 
-	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
+	depth = fmt->vpdma_fmt[VPE_LUMA]->depth;
+
+	/*
+	 * the line stride should 16 byte aligned for VPDMA to work, based on
+	 * the bytes per pixel, figure out how much the width should be aligned
+	 * to make sure line stride is 16 byte aligned
+	 */
+	depth_bytes = depth >> 3;
+
+	if (depth_bytes == 3)
+		/*
+		 * if bpp is 3(as in some RGB formats), the pixel width doesn't
+		 * really help in ensuring line stride is 16 byte aligned
+		 */
+		w_align = 4;
+	else
+		/*
+		 * for the remainder bpp(4, 2 and 1), the pixel width alignment
+		 * can ensure a line stride alignment of 16 bytes. For example,
+		 * if bpp is 2, then the line stride can be 16 byte aligned if
+		 * the width is 8 byte aligned
+		 */
+		w_align = order_base_2(VPDMA_DESC_ALIGN / depth_bytes);
+
+	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, w_align,
 			      &pix->height, MIN_H, MAX_H, H_ALIGN,
 			      S_ALIGN);
 
@@ -1383,15 +1414,11 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	}
 
 	for (i = 0; i < pix->num_planes; i++) {
-		int depth;
-
 		plane_fmt = &pix->plane_fmt[i];
 		depth = fmt->vpdma_fmt[i]->depth;
 
 		if (i == VPE_LUMA)
-			plane_fmt->bytesperline =
-					round_up((pix->width * depth) >> 3,
-						1 << L_ALIGN);
+			plane_fmt->bytesperline = (pix->width * depth) >> 3;
 		else
 			plane_fmt->bytesperline = pix->width;
 
-- 
1.8.3.2

