Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35274 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbeFENeN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 09:34:13 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-mfc: Fix buffer look up in s5p_mfc_handle_frame_{new,
 copy_time} functions
Date: Tue, 05 Jun 2018 15:33:59 +0200
Message-id: <20180605133359.10203-1-s.nawrocki@samsung.com>
References: <CGME20180605133410epcas1p36084a2286fb9e7ad27d6488cc6b99b4e@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Look up of buffers in s5p_mfc_handle_frame_new, s5p_mfc_handle_frame_copy_time
functions is not working properly for DMA addresses above 2 GiB. As a result
flags and timestamp of returned buffers are not set correctly and it breaks
operation of GStreamer/OMX plugins which rely on the CAPTURE buffer queue
flags.

Due to improper return type of the get_dec_y_adr, get_dspl_y_adr callbacks
and sign bit extension these callbacks return incorrect address values,
e.g. 0xfffffffffefc0000 instead of 0x00000000fefc0000. Then the statement:

"if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0) == dec_y_addr)"

is always false, which breaks looking up capture queue buffers.

To ensure proper matching by address u32 type is used for the DMA
addresses. This should work on all related SoCs, since the MFC DMA
address width is not larger than 32-bit.

Changes done in this patch are minimal as there is a larger patch series
pending refactoring the whole driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index a80251ed3143..780548dd650e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -254,24 +254,24 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_buf  *dst_buf, *src_buf;
-	size_t dec_y_addr;
+	struct s5p_mfc_buf *dst_buf, *src_buf;
+	u32 dec_y_addr;
 	unsigned int frame_type;
 
 	/* Make sure we actually have a new frame before continuing. */
 	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
 	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED)
 		return;
-	dec_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dec_y_adr, dev);
+	dec_y_addr = (u32)s5p_mfc_hw_call(dev->mfc_ops, get_dec_y_adr, dev);
 
 	/* Copy timestamp / timecode from decoded src to dst and set
 	   appropriate flags. */
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
-		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0)
-				== dec_y_addr) {
-			dst_buf->b->timecode =
-						src_buf->b->timecode;
+		u32 addr = (u32)vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0);
+
+		if (addr == dec_y_addr) {
+			dst_buf->b->timecode = src_buf->b->timecode;
 			dst_buf->b->vb2_buf.timestamp =
 						src_buf->b->vb2_buf.timestamp;
 			dst_buf->b->flags &=
@@ -307,10 +307,10 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf;
-	size_t dspl_y_addr;
+	u32 dspl_y_addr;
 	unsigned int frame_type;
 
-	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
+	dspl_y_addr = (u32)s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
 	if (IS_MFCV6_PLUS(dev))
 		frame_type = s5p_mfc_hw_call(dev->mfc_ops,
 			get_disp_frame_type, ctx);
@@ -329,9 +329,10 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	/* The MFC returns address of the buffer, now we have to
 	 * check which videobuf does it correspond to */
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		u32 addr = (u32)vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0);
+
 		/* Check if this is the buffer we're looking for */
-		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0)
-				== dspl_y_addr) {
+		if (addr == dspl_y_addr) {
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
 			dst_buf->b->sequence = ctx->sequence;
-- 
2.14.2
