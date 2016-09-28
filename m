Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55817 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754457AbcI1VYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:24:03 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 35/35] media: ti-vpe: vpe: Add proper support single and multi-plane buffer
Date: Wed, 28 Sep 2016 16:24:00 -0500
Message-ID: <20160928212400.27895-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VPE was restricting the number of plane per buffer based on
the fact that if a particular format had color separation it was
meant to need 2 planes.

However NV12/NV16 are color separate format which are meant to be
presented in a single contiguous buffer/plane.
It could also be presented in a multi-plane as well if need be.
So we must support both modes for more flexibility.

The number of plane requested by user space was previously ignored
and was therefore always overwritten.
The driver now use the requested num plane as hint to calculate needed
offset when required.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 58 ++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ae5acb5f42b8..c3ff7df780a9 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -327,6 +327,7 @@ static struct vpe_fmt vpe_formats[] = {
 struct vpe_q_data {
 	unsigned int		width;				/* frame width */
 	unsigned int		height;				/* frame height */
+	unsigned int		nplanes;			/* Current number of planes */
 	unsigned int		bytesperline[VPE_MAX_PLANES];	/* bytes per line in memory */
 	enum v4l2_colorspace	colorspace;
 	enum v4l2_field		field;				/* supported field value */
@@ -1042,6 +1043,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	int mv_buf_selector = !ctx->src_mv_buf_selector;
 	dma_addr_t dma_addr;
 	u32 flags = 0;
+	u32 offset = 0;
 
 	if (port == VPE_PORT_MV_OUT) {
 		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
@@ -1052,13 +1054,27 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		/*
+		 * If we are using a single plane buffer and
+		 * we need to set a separate vpdma chroma channel.
+		 */
+		if (q_data->nplanes == 1 && plane) {
+			dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+			/* Compute required offset */
+			offset = q_data->bytesperline[0] * q_data->height;
+		} else {
+			dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+			/* Use address as is, no offset */
+			offset = 0;
+		}
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring output buffer(%d) dma_addr failed\n",
 				port);
 			return;
 		}
+		/* Apply the offset */
+		dma_addr += offset;
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -1087,6 +1103,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 	int frame_width, frame_height;
 	dma_addr_t dma_addr;
 	u32 flags = 0;
+	u32 offset = 0;
 
 	if (port == VPE_PORT_MV_IN) {
 		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
@@ -1096,14 +1113,27 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
-
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		/*
+		 * If we are using a single plane buffer and
+		 * we need to set a separate vpdma chroma channel.
+		 */
+		if (q_data->nplanes == 1 && plane) {
+			dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+			/* Compute required offset */
+			offset = q_data->bytesperline[0] * q_data->height;
+		} else {
+			dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+			/* Use address as is, no offset */
+			offset = 0;
+		}
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
-				"acquiring input buffer(%d) dma_addr failed\n",
+				"acquiring output buffer(%d) dma_addr failed\n",
 				port);
 			return;
 		}
+		/* Apply the offset */
+		dma_addr += offset;
 
 		if (q_data->flags & Q_DATA_INTERLACED_SEQ_TB) {
 			/*
@@ -1549,7 +1579,7 @@ static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		pix->colorspace = s_q_data->colorspace;
 	}
 
-	pix->num_planes = q_data->fmt->coplanar ? 2 : 1;
+	pix->num_planes = q_data->nplanes;
 
 	for (i = 0; i < pix->num_planes; i++) {
 		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
@@ -1605,7 +1635,11 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 			      &pix->height, MIN_H, MAX_H, H_ALIGN,
 			      S_ALIGN);
 
-	pix->num_planes = fmt->coplanar ? 2 : 1;
+	if (!pix->num_planes)
+		pix->num_planes = fmt->coplanar ? 2 : 1;
+	else if (pix->num_planes > 1 && !fmt->coplanar)
+		pix->num_planes = 1;
+
 	pix->pixelformat = fmt->fourcc;
 
 	/*
@@ -1641,6 +1675,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		else
 			plane_fmt->bytesperline = pix->width;
 
+		if (pix->num_planes == 1 && fmt->coplanar)
+			depth += fmt->vpdma_fmt[VPE_CHROMA]->depth;
 		plane_fmt->sizeimage =
 				(pix->height * pix->width * depth) >> 3;
 
@@ -1687,6 +1723,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	q_data->height		= pix->height;
 	q_data->colorspace	= pix->colorspace;
 	q_data->field		= pix->field;
+	q_data->nplanes		= pix->num_planes;
 
 	for (i = 0; i < pix->num_planes; i++) {
 		plane_fmt = &pix->plane_fmt[i];
@@ -1714,7 +1751,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	vpe_dbg(ctx->dev, "Setting format for type %d, wxh: %dx%d, fmt: %d bpl_y %d",
 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
 		q_data->bytesperline[VPE_LUMA]);
-	if (q_data->fmt->coplanar)
+	if (q_data->nplanes == 2)
 		vpe_dbg(ctx->dev, " bpl_uv %d\n",
 			q_data->bytesperline[VPE_CHROMA]);
 
@@ -1966,14 +2003,14 @@ static int vpe_queue_setup(struct vb2_queue *vq,
 
 	q_data = get_q_data(ctx, vq->type);
 
-	*nplanes = q_data->fmt->coplanar ? 2 : 1;
+	*nplanes = q_data->nplanes;
 
 	for (i = 0; i < *nplanes; i++)
 		sizes[i] = q_data->sizeimage[i];
 
 	vpe_dbg(ctx->dev, "get %d buffer(s) of size %d", *nbuffers,
 		sizes[VPE_LUMA]);
-	if (q_data->fmt->coplanar)
+	if (q_data->nplanes == 2)
 		vpe_dbg(ctx->dev, " and %d\n", sizes[VPE_CHROMA]);
 
 	return 0;
@@ -1989,7 +2026,7 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	vpe_dbg(ctx->dev, "type: %d\n", vb->vb2_queue->type);
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
-	num_planes = q_data->fmt->coplanar ? 2 : 1;
+	num_planes = q_data->nplanes;
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (!(q_data->flags & Q_IS_INTERLACED)) {
@@ -2249,6 +2286,7 @@ static int vpe_open(struct file *file)
 	s_q_data->fmt = &vpe_formats[2];
 	s_q_data->width = 1920;
 	s_q_data->height = 1080;
+	s_q_data->nplanes = 1;
 	s_q_data->bytesperline[VPE_LUMA] = (s_q_data->width *
 			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
 	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->bytesperline[VPE_LUMA] *
-- 
2.9.0

