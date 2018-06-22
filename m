Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58727 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933953AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 02/16] gpu: ipu-v3: image-convert: prepare for per-tile configuration
Date: Fri, 22 Jun 2018 17:52:03 +0200
Message-Id: <20180622155217.29302-3-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let convert_start start from a given tile index, allocate intermediate
tile with maximum tile size.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 60 +++++++++++++++-----------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 524a717ab28e..7eef51decc97 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -605,7 +605,8 @@ static void init_idmac_channel(struct ipu_image_convert_ctx *ctx,
 			       struct ipuv3_channel *channel,
 			       struct ipu_image_convert_image *image,
 			       enum ipu_rotate_mode rot_mode,
-			       bool rot_swap_width_height)
+			       bool rot_swap_width_height,
+			       unsigned int tile)
 {
 	struct ipu_image_convert_chan *chan = ctx->chan;
 	unsigned int burst_size;
@@ -615,23 +616,23 @@ static void init_idmac_channel(struct ipu_image_convert_ctx *ctx,
 	unsigned int tile_idx[2];
 
 	if (image->type == IMAGE_CONVERT_OUT) {
-		tile_idx[0] = ctx->out_tile_map[0];
+		tile_idx[0] = ctx->out_tile_map[tile];
 		tile_idx[1] = ctx->out_tile_map[1];
 	} else {
-		tile_idx[0] = 0;
+		tile_idx[0] = tile;
 		tile_idx[1] = 1;
 	}
 
 	if (rot_swap_width_height) {
-		width = image->tile[0].height;
-		height = image->tile[0].width;
-		stride = image->tile[0].rot_stride;
+		width = image->tile[tile_idx[0]].height;
+		height = image->tile[tile_idx[0]].width;
+		stride = image->tile[tile_idx[0]].rot_stride;
 		addr0 = ctx->rot_intermediate[0].phys;
 		if (ctx->double_buffering)
 			addr1 = ctx->rot_intermediate[1].phys;
 	} else {
-		width = image->tile[0].width;
-		height = image->tile[0].height;
+		width = image->tile[tile_idx[0]].width;
+		height = image->tile[tile_idx[0]].height;
 		stride = image->stride;
 		addr0 = image->base.phys0 +
 			image->tile[tile_idx[0]].offset;
@@ -681,7 +682,7 @@ static void init_idmac_channel(struct ipu_image_convert_ctx *ctx,
 	ipu_idmac_set_double_buffer(channel, ctx->double_buffering);
 }
 
-static int convert_start(struct ipu_image_convert_run *run)
+static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 {
 	struct ipu_image_convert_ctx *ctx = run->ctx;
 	struct ipu_image_convert_chan *chan = ctx->chan;
@@ -689,28 +690,29 @@ static int convert_start(struct ipu_image_convert_run *run)
 	struct ipu_image_convert_image *s_image = &ctx->in;
 	struct ipu_image_convert_image *d_image = &ctx->out;
 	enum ipu_color_space src_cs, dest_cs;
+	unsigned int dst_tile = ctx->out_tile_map[tile];
 	unsigned int dest_width, dest_height;
 	int ret;
 
-	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p\n",
-		__func__, chan->ic_task, ctx, run);
+	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
+		__func__, chan->ic_task, ctx, run, tile, dst_tile);
 
 	src_cs = ipu_pixelformat_to_colorspace(s_image->fmt->fourcc);
 	dest_cs = ipu_pixelformat_to_colorspace(d_image->fmt->fourcc);
 
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		/* swap width/height for resizer */
-		dest_width = d_image->tile[0].height;
-		dest_height = d_image->tile[0].width;
+		dest_width = d_image->tile[dst_tile].height;
+		dest_height = d_image->tile[dst_tile].width;
 	} else {
-		dest_width = d_image->tile[0].width;
-		dest_height = d_image->tile[0].height;
+		dest_width = d_image->tile[dst_tile].width;
+		dest_height = d_image->tile[dst_tile].height;
 	}
 
 	/* setup the IC resizer and CSC */
 	ret = ipu_ic_task_init(chan->ic,
-			       s_image->tile[0].width,
-			       s_image->tile[0].height,
+			       s_image->tile[tile].width,
+			       s_image->tile[tile].height,
 			       dest_width,
 			       dest_height,
 			       src_cs, dest_cs);
@@ -721,27 +723,27 @@ static int convert_start(struct ipu_image_convert_run *run)
 
 	/* init the source MEM-->IC PP IDMAC channel */
 	init_idmac_channel(ctx, chan->in_chan, s_image,
-			   IPU_ROTATE_NONE, false);
+			   IPU_ROTATE_NONE, false, tile);
 
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		/* init the IC PP-->MEM IDMAC channel */
 		init_idmac_channel(ctx, chan->out_chan, d_image,
-				   IPU_ROTATE_NONE, true);
+				   IPU_ROTATE_NONE, true, tile);
 
 		/* init the MEM-->IC PP ROT IDMAC channel */
 		init_idmac_channel(ctx, chan->rotation_in_chan, d_image,
-				   ctx->rot_mode, true);
+				   ctx->rot_mode, true, tile);
 
 		/* init the destination IC PP ROT-->MEM IDMAC channel */
 		init_idmac_channel(ctx, chan->rotation_out_chan, d_image,
-				   IPU_ROTATE_NONE, false);
+				   IPU_ROTATE_NONE, false, tile);
 
 		/* now link IC PP-->MEM to MEM-->IC PP ROT */
 		ipu_idmac_link(chan->out_chan, chan->rotation_in_chan);
 	} else {
 		/* init the destination IC PP-->MEM IDMAC channel */
 		init_idmac_channel(ctx, chan->out_chan, d_image,
-				   ctx->rot_mode, false);
+				   ctx->rot_mode, false, tile);
 	}
 
 	/* enable the IC */
@@ -799,7 +801,7 @@ static int do_run(struct ipu_image_convert_run *run)
 	list_del(&run->list);
 	chan->current_run = run;
 
-	return convert_start(run);
+	return convert_start(run, 0);
 }
 
 /* hold irqlock when calling */
@@ -1430,14 +1432,22 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 				 !d_image->fmt->planar);
 
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
+		unsigned long intermediate_size = d_image->tile[0].size;
+		unsigned int i;
+
+		for (i = 1; i < ctx->num_tiles; i++) {
+			if (d_image->tile[i].size > intermediate_size)
+				intermediate_size = d_image->tile[i].size;
+		}
+
 		ret = alloc_dma_buf(priv, &ctx->rot_intermediate[0],
-				    d_image->tile[0].size);
+				    intermediate_size);
 		if (ret)
 			goto out_free;
 		if (ctx->double_buffering) {
 			ret = alloc_dma_buf(priv,
 					    &ctx->rot_intermediate[1],
-					    d_image->tile[0].size);
+					    intermediate_size);
 			if (ret)
 				goto out_free_dmabuf0;
 		}
-- 
2.17.1
