Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:17470 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753335AbcKRXVE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:04 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 07/35] media: ti-vpe: Add support for SEQ_TB buffers
Date: Fri, 18 Nov 2016 17:20:17 -0600
Message-ID: <20161118232045.24665-8-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

The video source can generate the data in the SEQ_TB buffer format.
In the case of TI SoC, the IVA_HD can generate the interlaced content in
the SEQ_TB buffer format. This is the format where the top and bottom field
data can be contained in a single buffer. For example, for NV12, interlaced
format, the data in Y buffer will be arranged as Y-top followed by
Y-bottom. And likewise for UV plane.

Also, queuing one buffer of SEQ_TB is equivalent to queuing two different
buffers for top and bottom fields. Driver needs to take care of this when
handling source buffer lists.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 125 +++++++++++++++++++++++++++++-------
 1 file changed, 103 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 9b7b9be5641d..e5d55575350f 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -320,9 +320,13 @@ struct vpe_q_data {
 };
 
 /* vpe_q_data flag bits */
-#define	Q_DATA_FRAME_1D		(1 << 0)
-#define	Q_DATA_MODE_TILED	(1 << 1)
-#define	Q_DATA_INTERLACED	(1 << 2)
+#define	Q_DATA_FRAME_1D			BIT(0)
+#define	Q_DATA_MODE_TILED		BIT(1)
+#define	Q_DATA_INTERLACED_ALTERNATE	BIT(2)
+#define	Q_DATA_INTERLACED_SEQ_TB	BIT(3)
+
+#define Q_IS_INTERLACED		(Q_DATA_INTERLACED_ALTERNATE | \
+				Q_DATA_INTERLACED_SEQ_TB)
 
 enum {
 	Q_DATA_SRC = 0,
@@ -638,7 +642,7 @@ static void set_us_coefficients(struct vpe_ctx *ctx)
 
 	cp = &us_coeffs[0].anchor_fid0_c0;
 
-	if (s_q_data->flags & Q_DATA_INTERLACED)	/* interlaced */
+	if (s_q_data->flags & Q_IS_INTERLACED)		/* interlaced */
 		cp += sizeof(us_coeffs[0]) / sizeof(*cp);
 
 	end_cp = cp + sizeof(us_coeffs[0]) / sizeof(*cp);
@@ -765,8 +769,7 @@ static void set_dei_regs(struct vpe_ctx *ctx)
 	 * for both progressive and interlace content in interlace bypass mode.
 	 * It has been recommended not to use progressive bypass mode.
 	 */
-	if ((!ctx->deinterlacing && (s_q_data->flags & Q_DATA_INTERLACED)) ||
-			!(s_q_data->flags & Q_DATA_INTERLACED)) {
+	if (!(s_q_data->flags & Q_IS_INTERLACED) || !ctx->deinterlacing) {
 		deinterlace = false;
 		val = VPE_DEI_INTERLACE_BYPASS;
 	}
@@ -834,8 +837,8 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	ctx->sequence = 0;
 	ctx->field = V4L2_FIELD_TOP;
 
-	if ((s_q_data->flags & Q_DATA_INTERLACED) &&
-			!(d_q_data->flags & Q_DATA_INTERLACED)) {
+	if ((s_q_data->flags & Q_IS_INTERLACED) &&
+			!(d_q_data->flags & Q_IS_INTERLACED)) {
 		int bytes_per_line;
 		const struct vpdma_data_format *mv =
 			&vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
@@ -1066,6 +1069,28 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 				port);
 			return;
 		}
+
+		if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB) {
+			/*
+			 * Use top or bottom field from same vb alternately
+			 * f,f-1,f-2 = TBT when seq is even
+			 * f,f-1,f-2 = BTB when seq is odd
+			 */
+			field = (p_data->vb_index + (ctx->sequence % 2)) % 2;
+
+			if (field) {
+				/*
+				 * bottom field of a SEQ_TB buffer
+				 * Skip the top field data by
+				 */
+				int height = q_data->height / 2;
+				int bpp = fmt->fourcc == V4L2_PIX_FMT_NV12 ?
+						1 : (vpdma_fmt->depth >> 3);
+				if (plane)
+					height /= 2;
+				dma_addr += q_data->width * height * bpp;
+			}
+		}
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -1114,9 +1139,22 @@ static void device_run(void *priv)
 	struct vpe_ctx *ctx = priv;
 	struct sc_data *sc = ctx->dev->sc;
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
+	struct vpe_q_data *s_q_data = &ctx->q_data[Q_DATA_SRC];
+
+	if (ctx->deinterlacing && s_q_data->flags & Q_DATA_INTERLACED_SEQ_TB &&
+		ctx->sequence % 2 == 0) {
+		/* When using SEQ_TB buffers, When using it first time,
+		 * No need to remove the buffer as the next field is present
+		 * in the same buffer. (so that job_ready won't fail)
+		 * It will be removed when using bottom field
+		 */
+		ctx->src_vbs[0] = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		WARN_ON(ctx->src_vbs[0] == NULL);
+	} else {
+		ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		WARN_ON(ctx->src_vbs[0] == NULL);
+	}
 
-	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-	WARN_ON(ctx->src_vbs[0] == NULL);
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
@@ -1320,7 +1358,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	d_vb->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
-	if (d_q_data->flags & Q_DATA_INTERLACED) {
+	if (d_q_data->flags & Q_IS_INTERLACED) {
 		d_vb->field = ctx->field;
 		if (ctx->field == V4L2_FIELD_BOTTOM) {
 			ctx->sequence++;
@@ -1334,12 +1372,28 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		ctx->sequence++;
 	}
 
-	if (ctx->deinterlacing)
-		s_vb = ctx->src_vbs[2];
+	if (ctx->deinterlacing) {
+		/*
+		 * Allow source buffer to be dequeued only if it won't be used
+		 * in the next iteration. All vbs are initialized to first
+		 * buffer and we are shifting buffers every iteration, for the
+		 * first two iterations, no buffer will be dequeued.
+		 * This ensures that driver will keep (n-2)th (n-1)th and (n)th
+		 * field when deinterlacing is enabled
+		 */
+		if (ctx->src_vbs[2] != ctx->src_vbs[1])
+			s_vb = ctx->src_vbs[2];
+		else
+			s_vb = NULL;
+	}
 
 	spin_lock_irqsave(&dev->lock, flags);
-	v4l2_m2m_buf_done(s_vb, VB2_BUF_STATE_DONE);
+
+	if (s_vb)
+		v4l2_m2m_buf_done(s_vb, VB2_BUF_STATE_DONE);
+
 	v4l2_m2m_buf_done(d_vb, VB2_BUF_STATE_DONE);
+
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (ctx->deinterlacing) {
@@ -1455,7 +1509,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *plane_fmt;
 	unsigned int w_align;
-	int i, depth, depth_bytes;
+	int i, depth, depth_bytes, height;
 
 	if (!fmt || !(fmt->types & type)) {
 		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
@@ -1463,7 +1517,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		return -EINVAL;
 	}
 
-	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE)
+	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE
+			&& pix->field != V4L2_FIELD_SEQ_TB)
 		pix->field = V4L2_FIELD_NONE;
 
 	depth = fmt->vpdma_fmt[VPE_LUMA]->depth;
@@ -1497,6 +1552,15 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	pix->num_planes = fmt->coplanar ? 2 : 1;
 	pix->pixelformat = fmt->fourcc;
 
+	/*
+	 * For the actual image parameters, we need to consider the field
+	 * height of the image for SEQ_TB buffers.
+	 */
+	if (pix->field == V4L2_FIELD_SEQ_TB)
+		height = pix->height / 2;
+	else
+		height = pix->height;
+
 	if (!pix->colorspace) {
 		if (fmt->fourcc == V4L2_PIX_FMT_RGB24 ||
 				fmt->fourcc == V4L2_PIX_FMT_BGR24 ||
@@ -1504,7 +1568,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 				fmt->fourcc == V4L2_PIX_FMT_BGR32) {
 			pix->colorspace = V4L2_COLORSPACE_SRGB;
 		} else {
-			if (pix->height > 1280)	/* HD */
+			if (height > 1280)	/* HD */
 				pix->colorspace = V4L2_COLORSPACE_REC709;
 			else			/* SD */
 				pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
@@ -1581,9 +1645,15 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	q_data->c_rect.height	= q_data->height;
 
 	if (q_data->field == V4L2_FIELD_ALTERNATE)
-		q_data->flags |= Q_DATA_INTERLACED;
+		q_data->flags |= Q_DATA_INTERLACED_ALTERNATE;
+	else if (q_data->field == V4L2_FIELD_SEQ_TB)
+		q_data->flags |= Q_DATA_INTERLACED_SEQ_TB;
 	else
-		q_data->flags &= ~Q_DATA_INTERLACED;
+		q_data->flags &= ~Q_IS_INTERLACED;
+
+	/* the crop height is halved for the case of SEQ_TB buffers */
+	if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB)
+		q_data->c_rect.height /= 2;
 
 	vpe_dbg(ctx->dev, "Setting format for type %d, wxh: %dx%d, fmt: %d bpl_y %d",
 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
@@ -1619,6 +1689,7 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
 {
 	struct vpe_q_data *q_data;
+	int height;
 
 	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
 	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
@@ -1653,13 +1724,22 @@ static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
 		return -EINVAL;
 	}
 
+	/*
+	 * For SEQ_TB buffers, crop height should be less than the height of
+	 * the field height, not the buffer height
+	 */
+	if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB)
+		height = q_data->height / 2;
+	else
+		height = q_data->height;
+
 	if (s->r.top < 0 || s->r.left < 0) {
 		vpe_err(ctx->dev, "negative values for top and left\n");
 		s->r.top = s->r.left = 0;
 	}
 
 	v4l_bound_align_image(&s->r.width, MIN_W, q_data->width, 1,
-		&s->r.height, MIN_H, q_data->height, H_ALIGN, S_ALIGN);
+		&s->r.height, MIN_H, height, H_ALIGN, S_ALIGN);
 
 	/* adjust left/top if cropping rectangle is out of bounds */
 	if (s->r.left + s->r.width > q_data->width)
@@ -1855,11 +1935,12 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	num_planes = q_data->fmt->coplanar ? 2 : 1;
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		if (!(q_data->flags & Q_DATA_INTERLACED)) {
+		if (!(q_data->flags & Q_IS_INTERLACED)) {
 			vbuf->field = V4L2_FIELD_NONE;
 		} else {
 			if (vbuf->field != V4L2_FIELD_TOP &&
-					vbuf->field != V4L2_FIELD_BOTTOM)
+			    vbuf->field != V4L2_FIELD_BOTTOM &&
+			    vbuf->field != V4L2_FIELD_SEQ_TB)
 				return -EINVAL;
 		}
 	}
-- 
2.9.0

