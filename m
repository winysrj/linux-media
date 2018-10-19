Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36717 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727583AbeJSUVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 12/22] gpu: ipu-v3: image-convert: reconfigure IC per tile
Date: Fri, 19 Oct 2018 14:15:29 +0200
Message-Id: <20181019121539.12778-13-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For differently sized tiles or if the resizing coefficients change,
we have to stop, reconfigure, and restart the IC between tiles.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 65 +++++++++++++++++---------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 31e7186bcc00..cb47981741b4 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1151,6 +1151,24 @@ static irqreturn_t do_bh(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static bool ic_settings_changed(struct ipu_image_convert_ctx *ctx)
+{
+	unsigned int cur_tile = ctx->next_tile - 1;
+	unsigned int next_tile = ctx->next_tile;
+
+	if (ctx->resize_coeffs_h[cur_tile % ctx->in.num_cols] !=
+	    ctx->resize_coeffs_h[next_tile % ctx->in.num_cols] ||
+	    ctx->resize_coeffs_v[cur_tile / ctx->in.num_cols] !=
+	    ctx->resize_coeffs_v[next_tile / ctx->in.num_cols] ||
+	    ctx->in.tile[cur_tile].width != ctx->in.tile[next_tile].width ||
+	    ctx->in.tile[cur_tile].height != ctx->in.tile[next_tile].height ||
+	    ctx->out.tile[cur_tile].width != ctx->out.tile[next_tile].width ||
+	    ctx->out.tile[cur_tile].height != ctx->out.tile[next_tile].height)
+		return true;
+
+	return false;
+}
+
 /* hold irqlock when calling */
 static irqreturn_t do_irq(struct ipu_image_convert_run *run)
 {
@@ -1194,27 +1212,32 @@ static irqreturn_t do_irq(struct ipu_image_convert_run *run)
 	 * not done, place the next tile buffers.
 	 */
 	if (!ctx->double_buffering) {
-
-		src_tile = &s_image->tile[ctx->next_tile];
-		dst_idx = ctx->out_tile_map[ctx->next_tile];
-		dst_tile = &d_image->tile[dst_idx];
-
-		ipu_cpmem_set_buffer(chan->in_chan, 0,
-				     s_image->base.phys0 + src_tile->offset);
-		ipu_cpmem_set_buffer(outch, 0,
-				     d_image->base.phys0 + dst_tile->offset);
-		if (s_image->fmt->planar)
-			ipu_cpmem_set_uv_offset(chan->in_chan,
-						src_tile->u_off,
-						src_tile->v_off);
-		if (d_image->fmt->planar)
-			ipu_cpmem_set_uv_offset(outch,
-						dst_tile->u_off,
-						dst_tile->v_off);
-
-		ipu_idmac_select_buffer(chan->in_chan, 0);
-		ipu_idmac_select_buffer(outch, 0);
-
+		if (ic_settings_changed(ctx)) {
+			convert_stop(run);
+			convert_start(run, ctx->next_tile);
+		} else {
+			src_tile = &s_image->tile[ctx->next_tile];
+			dst_idx = ctx->out_tile_map[ctx->next_tile];
+			dst_tile = &d_image->tile[dst_idx];
+
+			ipu_cpmem_set_buffer(chan->in_chan, 0,
+					     s_image->base.phys0 +
+					     src_tile->offset);
+			ipu_cpmem_set_buffer(outch, 0,
+					     d_image->base.phys0 +
+					     dst_tile->offset);
+			if (s_image->fmt->planar)
+				ipu_cpmem_set_uv_offset(chan->in_chan,
+							src_tile->u_off,
+							src_tile->v_off);
+			if (d_image->fmt->planar)
+				ipu_cpmem_set_uv_offset(outch,
+							dst_tile->u_off,
+							dst_tile->v_off);
+
+			ipu_idmac_select_buffer(chan->in_chan, 0);
+			ipu_idmac_select_buffer(outch, 0);
+		}
 	} else if (ctx->next_tile < ctx->num_tiles - 1) {
 
 		src_tile = &s_image->tile[ctx->next_tile + 1];
-- 
2.19.0
