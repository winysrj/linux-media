Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58029 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933923AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 03/16] gpu: ipu-v3: image-convert: calculate per-tile resize coefficients
Date: Fri, 22 Jun 2018 17:52:04 +0200
Message-Id: <20180622155217.29302-4-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Slightly modifying resize coefficients per-tile allows to completely
hide the seams between tiles and to sample the correct input pixels at
the bottom and right edges of the image.

Tiling requires a bilinear interpolator reset at each tile start, which
causes the image to be slightly shifted if the starting pixel should not
have been sampled from an integer pixel position in the source image
according to the full image resizing ratio. To work around this
hardware limitation, calculate per-tile resizing coefficients that make
sure that the correct input pixels are sampled at the tile end.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 236 ++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 7eef51decc97..12da0772bff0 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -135,6 +135,12 @@ struct ipu_image_convert_ctx {
 	struct ipu_image_convert_image in;
 	struct ipu_image_convert_image out;
 	enum ipu_rotate_mode rot_mode;
+	u32 downsize_coeff_h;
+	u32 downsize_coeff_v;
+	u32 image_resize_coeff_h;
+	u32 image_resize_coeff_v;
+	u32 resize_coeffs_h[MAX_STRIPES_W];
+	u32 resize_coeffs_v[MAX_STRIPES_H];
 
 	/* intermediate buffer for rotation */
 	struct ipu_image_convert_dma_buf rot_intermediate[2];
@@ -355,6 +361,69 @@ static inline int num_stripes(int dim)
 		return 4;
 }
 
+/*
+ * Calculate downsizing coefficients, which are the same for all tiles,
+ * and bilinear resizing coefficients, which are used to find the best
+ * seam positions.
+ */
+static int calc_image_resize_coefficients(struct ipu_image_convert_ctx *ctx,
+					  struct ipu_image *in,
+					  struct ipu_image *out)
+{
+	u32 downsized_width = in->rect.width;
+	u32 downsized_height = in->rect.height;
+	u32 downsize_coeff_v = 0;
+	u32 downsize_coeff_h = 0;
+	u32 resized_width = out->rect.width;
+	u32 resized_height = out->rect.height;
+	u32 resize_coeff_h;
+	u32 resize_coeff_v;
+
+	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
+		resized_width = out->rect.height;
+		resized_height = out->rect.width;
+	}
+
+	/* Do not let invalid input lead to an endless loop below */
+	if (WARN_ON(resized_width == 0 || resized_height == 0))
+		return -EINVAL;
+
+	while (downsized_width >= resized_width * 2) {
+		downsized_width >>= 1;
+		downsize_coeff_h++;
+	}
+
+	while (downsized_height >= resized_height * 2) {
+		downsized_height >>= 1;
+		downsize_coeff_v++;
+	}
+
+	/*
+	 * Calculate the bilinear resizing coefficients that could be used if
+	 * we were converting with a single tile. The bottom right output pixel
+	 * should sample as close as possible to the bottom right input pixel
+	 * out of the decimator, but not overshoot it:
+	 */
+	resize_coeff_h = 8192 * (downsized_width - 1) / (resized_width - 1);
+	resize_coeff_v = 8192 * (downsized_height - 1) / (resized_height - 1);
+
+	dev_dbg(ctx->chan->priv->ipu->dev,
+		"%s: hscale: >>%u, *8192/%u vscale: >>%u, *8192/%u, %ux%u tiles\n",
+		__func__, downsize_coeff_h, resize_coeff_h, downsize_coeff_v,
+		resize_coeff_v, ctx->in.num_cols, ctx->in.num_rows);
+
+	if (downsize_coeff_h > 2 || downsize_coeff_v  > 2 ||
+	    resize_coeff_h > 0x3fff || resize_coeff_v > 0x3fff)
+		return -EINVAL;
+
+	ctx->downsize_coeff_h = downsize_coeff_h;
+	ctx->downsize_coeff_v = downsize_coeff_v;
+	ctx->image_resize_coeff_h = resize_coeff_h;
+	ctx->image_resize_coeff_v = resize_coeff_v;
+
+	return 0;
+}
+
 static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 				 struct ipu_image_convert_image *image)
 {
@@ -558,6 +627,149 @@ static void calc_tile_offsets(struct ipu_image_convert_ctx *ctx,
 		calc_tile_offsets_packed(ctx, image);
 }
 
+/*
+ * Calculate the resizing ratio for the IC main processing section given input
+ * size, fixed downsizing coefficient, and output size.
+ * Either round to closest for the next tile's first pixel to minimize seams
+ * and distortion (for all but right column / bottom row), or round down to
+ * avoid sampling beyond the edges of the input image for this tile's last
+ * pixel.
+ * Returns the resizing coefficient, resizing ratio is 8192.0 / resize_coeff.
+ */
+static u32 calc_resize_coeff(u32 input_size, u32 downsize_coeff,
+			     u32 output_size, bool allow_overshoot)
+{
+	u32 downsized = input_size >> downsize_coeff;
+
+	if (allow_overshoot)
+		return DIV_ROUND_CLOSEST(8192 * downsized, output_size);
+	else
+		return 8192 * (downsized - 1) / (output_size - 1);
+}
+
+/*
+ * Slightly modify resize coefficients per tile to hide the bilinear
+ * interpolator reset at tile borders, shifting the right / bottom edge
+ * by up to a half input pixel. This removes noticeable seams between
+ * tiles at higher upscaling factors.
+ */
+static void calc_tile_resize_coefficients(struct ipu_image_convert_ctx *ctx)
+{
+	struct ipu_image_convert_chan *chan = ctx->chan;
+	struct ipu_image_convert_priv *priv = chan->priv;
+	struct ipu_image_tile *in_tile, *out_tile;
+	unsigned int col, row, tile_idx;
+	unsigned int last_output;
+
+	for (col = 0; col < ctx->in.num_cols; col++) {
+		bool closest = (col < ctx->in.num_cols - 1) &&
+			       !(ctx->rot_mode & IPU_ROT_BIT_HFLIP);
+		u32 resized_width;
+		u32 resize_coeff_h;
+
+		tile_idx = col;
+		in_tile = &ctx->in.tile[tile_idx];
+		out_tile = &ctx->out.tile[ctx->out_tile_map[tile_idx]];
+
+		if (ipu_rot_mode_is_irt(ctx->rot_mode))
+			resized_width = out_tile->height;
+		else
+			resized_width = out_tile->width;
+
+		resize_coeff_h = calc_resize_coeff(in_tile->width,
+						   ctx->downsize_coeff_h,
+						   resized_width, closest);
+
+		dev_dbg(priv->ipu->dev, "%s: column %u hscale: *8192/%u\n",
+			__func__, col, resize_coeff_h);
+
+
+		for (row = 0; row < ctx->in.num_rows; row++) {
+			tile_idx = row * ctx->in.num_cols + col;
+			in_tile = &ctx->in.tile[tile_idx];
+			out_tile = &ctx->out.tile[ctx->out_tile_map[tile_idx]];
+
+			/*
+			 * With the horizontal scaling factor known, round up
+			 * resized width (output width or height) to burst size.
+			 */
+			if (ipu_rot_mode_is_irt(ctx->rot_mode))
+				out_tile->height = round_up(resized_width, 8);
+			else
+				out_tile->width = round_up(resized_width, 8);
+
+			/*
+			 * Calculate input width from the last accessed input
+			 * pixel given resized width and scaling coefficients.
+			 * Round up to burst size.
+			 */
+			last_output = round_up(resized_width, 8) - 1;
+			if (closest)
+				last_output++;
+			in_tile->width = round_up(
+				(DIV_ROUND_UP(last_output * resize_coeff_h,
+					      8192) + 1)
+				<< ctx->downsize_coeff_h, 8);
+		}
+
+		ctx->resize_coeffs_h[col] = resize_coeff_h;
+	}
+
+	for (row = 0; row < ctx->in.num_rows; row++) {
+		bool closest = (row < ctx->in.num_rows - 1) &&
+			       !(ctx->rot_mode & IPU_ROT_BIT_VFLIP);
+		u32 resized_height;
+		u32 resize_coeff_v;
+
+		tile_idx = row * ctx->in.num_cols;
+		in_tile = &ctx->in.tile[tile_idx];
+		out_tile = &ctx->out.tile[ctx->out_tile_map[tile_idx]];
+
+		if (ipu_rot_mode_is_irt(ctx->rot_mode))
+			resized_height = out_tile->width;
+		else
+			resized_height = out_tile->height;
+
+		resize_coeff_v = calc_resize_coeff(in_tile->height,
+						   ctx->downsize_coeff_v,
+						   resized_height, closest);
+
+		dev_dbg(priv->ipu->dev, "%s: row %u vscale: *8192/%u\n",
+			__func__, row, resize_coeff_v);
+
+		for (col = 0; col < ctx->in.num_cols; col++) {
+			tile_idx = row * ctx->in.num_cols + col;
+			in_tile = &ctx->in.tile[tile_idx];
+			out_tile = &ctx->out.tile[ctx->out_tile_map[tile_idx]];
+
+			/*
+			 * With the vertical scaling factor known, round up
+			 * resized height (output width or height) to IDMAC
+			 * limitations.
+			 */
+			if (ipu_rot_mode_is_irt(ctx->rot_mode))
+				out_tile->width = round_up(resized_height, 2);
+			else
+				out_tile->height = round_up(resized_height, 2);
+
+			/*
+			 * Calculate input width from the last accessed input
+			 * pixel given resized height and scaling coefficients.
+			 * Align to IDMAC restrictions.
+			 */
+			last_output = round_up(resized_height, 2) - 1;
+			if (closest)
+				last_output++;
+			in_tile->height = round_up(
+				(DIV_ROUND_UP(last_output * resize_coeff_v,
+					      8192) + 1)
+				<< ctx->downsize_coeff_v, 2);
+		}
+
+		ctx->resize_coeffs_v[row] = resize_coeff_v;
+	}
+}
+
 /*
  * return the number of runs in given queue (pending_q or done_q)
  * for this context. hold irqlock when calling.
@@ -692,6 +904,8 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 	enum ipu_color_space src_cs, dest_cs;
 	unsigned int dst_tile = ctx->out_tile_map[tile];
 	unsigned int dest_width, dest_height;
+	unsigned int col, row;
+	u32 rsc;
 	int ret;
 
 	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
@@ -709,13 +923,26 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 		dest_height = d_image->tile[dst_tile].height;
 	}
 
+	row = tile / s_image->num_cols;
+	col = tile % s_image->num_cols;
+
+	rsc =  (ctx->downsize_coeff_v << 30) |
+	       (ctx->resize_coeffs_v[row] << 16) |
+	       (ctx->downsize_coeff_h << 14) |
+	       (ctx->resize_coeffs_h[col]);
+
+	dev_dbg(priv->ipu->dev, "%s: %ux%u -> %ux%u (rsc = 0x%x)\n",
+		__func__, s_image->tile[tile].width,
+		s_image->tile[tile].height, dest_width, dest_height, rsc);
+
 	/* setup the IC resizer and CSC */
-	ret = ipu_ic_task_init(chan->ic,
+	ret = ipu_ic_task_init_rsc(chan->ic,
 			       s_image->tile[tile].width,
 			       s_image->tile[tile].height,
 			       dest_width,
 			       dest_height,
-			       src_cs, dest_cs);
+			       src_cs, dest_cs,
+			       rsc);
 	if (ret) {
 		dev_err(priv->ipu->dev, "ipu_ic_task_init failed, %d\n", ret);
 		return ret;
@@ -1401,6 +1628,10 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	ctx->num_tiles = d_image->num_cols * d_image->num_rows;
 	ctx->rot_mode = rot_mode;
 
+	ret = calc_image_resize_coefficients(ctx, in, out);
+	if (ret)
+		goto out_free;
+
 	ret = fill_image(ctx, s_image, in, IMAGE_CONVERT_IN);
 	if (ret)
 		goto out_free;
@@ -1409,6 +1640,7 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 		goto out_free;
 
 	calc_out_tile_map(ctx);
+	calc_tile_resize_coefficients(ctx);
 
 	dump_format(ctx, s_image);
 	dump_format(ctx, d_image);
-- 
2.17.1
