Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50799 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbaJJO1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 10:27:13 -0400
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [RFC PATCH 4/4] [media] ti-vpe: Add support for SEQ_TB buffers
Date: Fri, 10 Oct 2014 19:57:03 +0530
Message-ID: <1412951223-4711-5-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1412951223-4711-1-git-send-email-nikhil.nd@ti.com>
References: <1412951223-4711-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video source can generate the data in the SEQ_TB buffer format.
In the case of TI SoC, the IVA_HD can generate the interlaced content in
the SEQ_TB buffer format. This is the format where the top and bottom field
data can be contained in a single buffer. For example, for NV12, interlaced
format, the data in Y buffer will be arranged as Y-top followed by Y-bottom.
And likewise for UV plane.

Also, queueing one buffer of SEQ_TB is euivalent to queueing two different
buffers for top and bottom fields. Driver needs to take care of this when
handling source buffer lists.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c |  122 +++++++++++++++++++++++++++++------
 1 file changed, 101 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e37102b..4cc7dc7 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -319,9 +319,13 @@ struct vpe_q_data {
 };
 
 /* vpe_q_data flag bits */
-#define	Q_DATA_FRAME_1D		(1 << 0)
-#define	Q_DATA_MODE_TILED	(1 << 1)
-#define	Q_DATA_INTERLACED	(1 << 2)
+#define	Q_DATA_FRAME_1D			(1 << 0)
+#define	Q_DATA_MODE_TILED		(1 << 1)
+#define	Q_DATA_INTERLACED_ALTERNATE	(1 << 2)
+#define	Q_DATA_INTERLACED_SEQ_TB	(1 << 3)
+
+#define Q_IS_INTERLACED		(Q_DATA_INTERLACED_ALTERNATE | \
+				Q_DATA_INTERLACED_SEQ_TB)
 
 enum {
 	Q_DATA_SRC = 0,
@@ -647,7 +651,7 @@ static void set_us_coefficients(struct vpe_ctx *ctx)
 
 	cp = &us_coeffs[0].anchor_fid0_c0;
 
-	if (s_q_data->flags & Q_DATA_INTERLACED)	/* interlaced */
+	if (s_q_data->flags & Q_IS_INTERLACED)		/* interlaced */
 		cp += sizeof(us_coeffs[0]) / sizeof(*cp);
 
 	end_cp = cp + sizeof(us_coeffs[0]) / sizeof(*cp);
@@ -774,8 +778,7 @@ static void set_dei_regs(struct vpe_ctx *ctx)
 	 * for both progressive and interlace content in interlace bypass mode.
 	 * It has been recommended not to use progressive bypass mode.
 	 */
-	if ((!ctx->deinterlacing && (s_q_data->flags & Q_DATA_INTERLACED)) ||
-			!(s_q_data->flags & Q_DATA_INTERLACED)) {
+	if (!(s_q_data->flags & Q_IS_INTERLACED) || !ctx->deinterlacing) {
 		deinterlace = false;
 		val = VPE_DEI_INTERLACE_BYPASS;
 	}
@@ -843,8 +846,8 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	ctx->sequence = 0;
 	ctx->field = V4L2_FIELD_TOP;
 
-	if ((s_q_data->flags & Q_DATA_INTERLACED) &&
-			!(d_q_data->flags & Q_DATA_INTERLACED)) {
+	if ((s_q_data->flags & Q_IS_INTERLACED) &&
+			!(d_q_data->flags & Q_IS_INTERLACED)) {
 		int bytes_per_line;
 		const struct vpdma_data_format *mv =
 			&vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
@@ -1068,6 +1071,28 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 		vpdma_fmt = fmt->vpdma_fmt[plane];
 
 		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
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
+				/* bottom field of a SEQ_TB buffer
+				 * Skip the top field data by */
+				int height = q_data->height / 2;
+				int bpp = fmt->fourcc == V4L2_PIX_FMT_NV12 ?
+						1 : (vpdma_fmt->depth >> 3);
+				if (plane)
+					height /= 2;
+				field = !field;
+				dma_addr += q_data->width * height * bpp;
+			}
+		}
+
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring input buffer(%d) dma_addr failed\n",
@@ -1122,9 +1147,22 @@ static void device_run(void *priv)
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
+		ctx->src_vbs[0] = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+		WARN_ON(ctx->src_vbs[0] == NULL);
+	} else {
+		ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		WARN_ON(ctx->src_vbs[0] == NULL);
+	}
 
-	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	WARN_ON(ctx->src_vbs[0] == NULL);
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
@@ -1256,6 +1294,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	struct vpe_dev *dev = (struct vpe_dev *)data;
 	struct vpe_ctx *ctx;
 	struct vpe_q_data *d_q_data;
+	struct vpe_q_data *s_q_data;
 	struct vb2_buffer *s_vb, *d_vb;
 	struct v4l2_buffer *s_buf, *d_buf;
 	unsigned long flags;
@@ -1332,7 +1371,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	d_buf->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
-	if (d_q_data->flags & Q_DATA_INTERLACED) {
+	if (d_q_data->flags & Q_IS_INTERLACED) {
 		d_buf->field = ctx->field;
 		if (ctx->field == V4L2_FIELD_BOTTOM) {
 			ctx->sequence++;
@@ -1346,12 +1385,28 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		ctx->sequence++;
 	}
 
-	if (ctx->deinterlacing)
-		s_vb = ctx->src_vbs[2];
+	s_q_data = &ctx->q_data[Q_DATA_SRC];
+
+	if (ctx->deinterlacing) {
+		/* Allow source buffer to be dequeued only if it won't be used
+		 * in the next iteration. All vbs are initialized to first
+		 * buffer and we are shifting buffers every iteration, for the
+		 * first two iterations, no buffer will be dequeued.
+		 * This ensures that driver will keep (n-2)th (n-1)th and (n)th
+		 * field when deinterlacing is enabled */
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
@@ -1467,7 +1522,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *plane_fmt;
 	unsigned int w_align;
-	int i, depth, depth_bytes;
+	int i, depth, depth_bytes, height;
 
 	if (!fmt || !(fmt->types & type)) {
 		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
@@ -1475,7 +1530,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		return -EINVAL;
 	}
 
-	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE)
+	if (pix->field != V4L2_FIELD_NONE && pix->field != V4L2_FIELD_ALTERNATE
+			&& pix->field != V4L2_FIELD_SEQ_TB)
 		pix->field = V4L2_FIELD_NONE;
 
 	depth = fmt->vpdma_fmt[VPE_LUMA]->depth;
@@ -1509,6 +1565,14 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	pix->num_planes = fmt->coplanar ? 2 : 1;
 	pix->pixelformat = fmt->fourcc;
 
+	/* for the actual image parameters, we need to consider the field height
+	 * of the image for SEQ_TB buffers.
+	 */
+	if (pix->field == V4L2_FIELD_SEQ_TB)
+		height = pix->height / 2;
+	else
+		height = pix->height;
+
 	if (!pix->colorspace) {
 		if (fmt->fourcc == V4L2_PIX_FMT_RGB24 ||
 				fmt->fourcc == V4L2_PIX_FMT_BGR24 ||
@@ -1516,7 +1580,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 				fmt->fourcc == V4L2_PIX_FMT_BGR32) {
 			pix->colorspace = V4L2_COLORSPACE_SRGB;
 		} else {
-			if (pix->height > 1280)	/* HD */
+			if (height > 1280)	/* HD */
 				pix->colorspace = V4L2_COLORSPACE_REC709;
 			else			/* SD */
 				pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
@@ -1593,9 +1657,15 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
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
@@ -1631,6 +1701,7 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
 {
 	struct vpe_q_data *q_data;
+	int height;
 
 	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
 	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
@@ -1665,13 +1736,22 @@ static int __vpe_try_selection(struct vpe_ctx *ctx, struct v4l2_selection *s)
 		return -EINVAL;
 	}
 
+	/*
+	* For SEQ_TB buffers, crop height should be less than the height of
+	* the field height, not the buffer height
+	*/
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
@@ -1919,7 +1999,7 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	num_planes = q_data->fmt->coplanar ? 2 : 1;
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		if (!(q_data->flags & Q_DATA_INTERLACED)) {
+		if (!(q_data->flags & Q_IS_INTERLACED)) {
 			vb->v4l2_buf.field = V4L2_FIELD_NONE;
 		} else {
 			if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
-- 
1.7.9.5

