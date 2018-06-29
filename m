Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39321 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934638AbeF2Mqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:46:55 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 2/3] media: coda: jpeg: only queue two buffers into the bitstream for JPEG on CODA7541
Date: Fri, 29 Jun 2018 14:46:47 +0200
Message-Id: <20180629124648.31739-2-p.zabel@pengutronix.de>
In-Reply-To: <20180629124648.31739-1-p.zabel@pengutronix.de>
References: <20180629124648.31739-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Padding the bitstream buffer is not enough to reliably avoid prefetch
failures.  Picture runs with the next buffer's header already visible to
the CODA7541 succeed much more reliably, so always queue two JPEG frames
into the bitstream buffer.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 68ed2a564ad1..b4ff89200869 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -261,12 +261,13 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 
 	while (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) > 0) {
 		/*
-		 * Only queue a single JPEG into the bitstream buffer, except
-		 * to increase payload over 512 bytes or if in hold state.
+		 * Only queue two JPEGs into the bitstream buffer to keep
+		 * latency low. We need at least one complete buffer and the
+		 * header of another buffer (for prescan) in the bitstream.
 		 */
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG &&
-		    (coda_get_bitstream_payload(ctx) >= 512) && !ctx->hold)
-			break;
+		    ctx->num_metas > 1)
+			break;
 
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-- 
2.17.1
