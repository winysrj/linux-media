Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60799 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 04/21] [media] coda: move meta out of padding
Date: Fri, 23 Jan 2015 17:51:18 +0100
Message-Id: <1422031895-7740-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle an empty buffer metadata list without crashing. This can happen
if the decoder is fed a broken stream, or multiple compressed frames in
a single queued buffer.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index b4029ae..f6cf337 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1565,6 +1565,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct vb2_buffer *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
+	struct coda_buffer_meta *meta;
 	u32 reg_addr, reg_stride;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -1643,12 +1644,12 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
-	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG) {
-		struct coda_buffer_meta *meta;
+	meta = list_first_entry_or_null(&ctx->buffer_meta_list,
+					struct coda_buffer_meta, list);
+
+	if (meta && ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG) {
 
 		/* If this is the last buffer in the bitstream, add padding */
-		meta = list_first_entry(&ctx->buffer_meta_list,
-				      struct coda_buffer_meta, list);
 		if (meta->end == (ctx->bitstream_fifo.kfifo.in &
 				  ctx->bitstream_fifo.kfifo.mask)) {
 			static unsigned char buf[512];
-- 
2.1.4

