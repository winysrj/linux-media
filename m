Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47807 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732164AbeGSQOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 12:14:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v2 08/16] gpu: ipu-v3: image-convert: select optimal seam positions
Date: Thu, 19 Jul 2018 17:30:34 +0200
Message-Id: <20180719153042.533-9-p.zabel@pengutronix.de>
In-Reply-To: <20180719153042.533-1-p.zabel@pengutronix.de>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Select seam positions that minimize distortions during seam hiding while
satifying input and output IDMAC, rotator, and image format constraints.

This code looks for aligned output seam positions that minimize the
difference between the fractional corresponding ideal input positions
and the input positions rounded to alignment requirements.

Since now tiles can be sized differently, alignment restrictions of the
complete image can be relaxed in the next step.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1 [1]:
 - Fix inverted allow_overshoot logic
 - Correctly switch horizontal / vertical tile alignment when
   determining seam positions with the 90° rotator active.

[1] https://patchwork.linuxtv.org/patch/50521/
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 320 ++++++++++++++++++++++++-
 1 file changed, 314 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index da6f18475b6b..6615cea694ed 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -426,6 +426,115 @@ static int calc_image_resize_coefficients(struct ipu_image_convert_ctx *ctx,
 	return 0;
 }
 
+#define round_closest(x, y) round_down((x) + (y)/2, (y))
+
+/*
+ * Find the best aligned seam position in the inverval [out_start, out_end].
+ * Rotation and image offsets are out of scope.
+ *
+ * @out_start: start of inverval, must be within 1024 pixels / lines
+ *             of out_end
+ * @out_end: output right / bottom edge, end of interval
+ * @in_align: input alignment, either horizontal 8-byte line start address
+ *            alignment, or pixel alignment due to image format
+ * @out_align: output alignment, either horizontal 8-byte line start address
+ *             alignment, or pixel alignment due to image format or rotator
+ *             block size
+ * @out_burst: horizontal output burst size or rotator block size
+ * @downsize_coeff: downsizing section coefficient
+ * @resize_coeff: main processing section resizing coefficient
+ * @allow_overshoot: ignore out_burst if true
+ * @_in_seam: aligned input seam position return value
+ * @_out_seam: aligned output seam position return value
+ */
+static void find_best_seam(struct ipu_image_convert_ctx *ctx,
+			   unsigned int out_start,
+			   unsigned int out_end,
+			   unsigned int in_align,
+			   unsigned int out_align,
+			   unsigned int out_burst,
+			   unsigned int downsize_coeff,
+			   unsigned int resize_coeff,
+			   bool allow_overshoot,
+			   u32 *_in_seam,
+			   u32 *_out_seam)
+{
+	struct device *dev = ctx->chan->priv->ipu->dev;
+	unsigned int out_pos;
+	/* Input / output seam position candidates */
+	unsigned int out_seam = 0;
+	unsigned int in_seam = 0;
+	unsigned int min_diff = UINT_MAX;
+
+	/*
+	 * Output tiles must start at a multiple of 8 bytes horizontally and
+	 * possibly at an even line horizontally depending on the pixel format.
+	 * Only consider output aligned positions for the seam.
+	 */
+	out_start = round_up(out_start, out_align);
+	for (out_pos = out_start; out_pos < out_end; out_pos += out_align) {
+		unsigned int in_pos;
+		unsigned int in_pos_aligned;
+		unsigned int abs_diff;
+
+		/*
+		 * Tiles in the right row / bottom column may not be allowed to
+		 * overshoot horizontally / vertically. out_burst may be the
+		 * actual DMA burst size, or the rotator block size.
+		 */
+		if (!allow_overshoot && (out_end - out_pos) % out_burst)
+			continue;
+
+		/*
+		 * Input sample position, corresponding to out_pos, 19.13 fixed
+		 * point.
+		 */
+		in_pos = (out_pos * resize_coeff) << downsize_coeff;
+		/*
+		 * The closest input sample position that we could actually
+		 * start the input tile at, 19.13 fixed point.
+		 */
+		in_pos_aligned = round_closest(in_pos, 8192U * in_align);
+
+		if (in_pos < in_pos_aligned)
+			abs_diff = in_pos_aligned - in_pos;
+		else
+			abs_diff = in_pos - in_pos_aligned;
+
+		if (abs_diff < min_diff) {
+			in_seam = in_pos_aligned;
+			out_seam = out_pos;
+			min_diff = abs_diff;
+		}
+	}
+
+	*_out_seam = out_seam;
+	/* Convert 19.13 fixed point to integer seam position */
+	*_in_seam = DIV_ROUND_CLOSEST(in_seam, 8192U);
+
+	dev_dbg(dev, "%s: out_seam %u in [%u, %u], in_seam %u diff %u.%03u\n",
+		__func__, out_seam, out_start, out_end, *_in_seam,
+		min_diff / 8192,
+		DIV_ROUND_CLOSEST(min_diff % 8192 * 1000, 8192));
+}
+
+/*
+ * Tile left edges are required to be aligned to multiples of 8 bytes
+ * by the IDMAC.
+ */
+static inline u32 tile_left_align(const struct ipu_image_pixfmt *fmt)
+{
+	return fmt->planar ? 8 * fmt->uv_width_dec : 64 / fmt->bpp;
+}
+
+/*
+ * Tile top edge alignment is only limited by chroma subsampling.
+ */
+static inline u32 tile_top_align(const struct ipu_image_pixfmt *fmt)
+{
+	return fmt->uv_height_dec > 1 ? 2 : 1;
+}
+
 /*
  * We have to adjust the tile width such that the tile physaddrs and
  * U and V plane offsets are multiples of 8 bytes as required by
@@ -453,20 +562,216 @@ static inline u32 tile_height_align(enum ipu_image_convert_type type,
 		ipu_rot_mode_is_irt(rot_mode)) ? 8 : 2;
 }
 
+/*
+ * Fill in left position and width and for all tiles in an input column, and
+ * for all corresponding output tiles. If the 90° rotator is used, the output
+ * tiles are in a row, and output tile top position and height are set.
+ */
+static void fill_tile_column(struct ipu_image_convert_ctx *ctx,
+			     unsigned int col,
+			     struct ipu_image_convert_image *in,
+			     unsigned int in_left, unsigned int in_width,
+			     struct ipu_image_convert_image *out,
+			     unsigned int out_left, unsigned int out_width)
+{
+	unsigned int row, tile_idx;
+	struct ipu_image_tile *in_tile, *out_tile;
+
+	for (row = 0; row < in->num_rows; row++) {
+		tile_idx = in->num_cols * row + col;
+		in_tile = &in->tile[tile_idx];
+		out_tile = &out->tile[ctx->out_tile_map[tile_idx]];
+
+		in_tile->left = in_left;
+		in_tile->width = in_width;
+
+		if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
+			out_tile->top = out_left;
+			out_tile->height = out_width;
+		} else {
+			out_tile->left = out_left;
+			out_tile->width = out_width;
+		}
+	}
+}
+
+/*
+ * Fill in top position and height and for all tiles in an input row, and
+ * for all corresponding output tiles. If the 90° rotator is used, the output
+ * tiles are in a column, and output tile left position and width are set.
+ */
+static void fill_tile_row(struct ipu_image_convert_ctx *ctx, unsigned int row,
+			  struct ipu_image_convert_image *in,
+			  unsigned int in_top, unsigned int in_height,
+			  struct ipu_image_convert_image *out,
+			  unsigned int out_top, unsigned int out_height)
+{
+	unsigned int col, tile_idx;
+	struct ipu_image_tile *in_tile, *out_tile;
+
+	for (col = 0; col < in->num_cols; col++) {
+		tile_idx = in->num_cols * row + col;
+		in_tile = &in->tile[tile_idx];
+		out_tile = &out->tile[ctx->out_tile_map[tile_idx]];
+
+		in_tile->top = in_top;
+		in_tile->height = in_height;
+
+		if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
+			out_tile->left = out_top;
+			out_tile->width = out_height;
+		} else {
+			out_tile->top = out_top;
+			out_tile->height = out_height;
+		}
+	}
+}
+
+/*
+ * Find the best horizontal and vertical seam positions to split into tiles.
+ * Minimize the fractional part of the input sampling position for the
+ * top / left pixels of each tile.
+ */
+static void find_seams(struct ipu_image_convert_ctx *ctx,
+		       struct ipu_image_convert_image *in,
+		       struct ipu_image_convert_image *out)
+{
+	struct device *dev = ctx->chan->priv->ipu->dev;
+	unsigned int resized_width = out->base.rect.width;
+	unsigned int resized_height = out->base.rect.height;
+	unsigned int col;
+	unsigned int row;
+	unsigned int in_left_align = tile_left_align(in->fmt);
+	unsigned int in_top_align = tile_top_align(in->fmt);
+	unsigned int out_left_align = tile_left_align(out->fmt);
+	unsigned int out_top_align = tile_top_align(out->fmt);
+	unsigned int out_width_align = tile_width_align(out->fmt);
+	unsigned int out_height_align = tile_height_align(out->type,
+							  ctx->rot_mode);
+	unsigned int in_right = in->base.rect.width;
+	unsigned int in_bottom = in->base.rect.height;
+	unsigned int out_right = out->base.rect.width;
+	unsigned int out_bottom = out->base.rect.height;
+	unsigned int flipped_out_left;
+	unsigned int flipped_out_top;
+
+	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
+		resized_width = out->base.rect.height;
+		resized_height = out->base.rect.width;
+		out_left_align = tile_top_align(out->fmt);
+		out_top_align = tile_left_align(out->fmt);
+		out_width_align = tile_height_align(out->type,
+						    ctx->rot_mode);
+		out_height_align = tile_width_align(out->fmt);
+		out_right = out->base.rect.height;
+		out_bottom = out->base.rect.width;
+	}
+
+	for (col = in->num_cols - 1; col > 0; col--) {
+		bool allow_overshoot = (col < in->num_cols - 1) &&
+				       !(ctx->rot_mode & IPU_ROT_BIT_HFLIP);
+		unsigned int out_start;
+		unsigned int out_end;
+		unsigned int in_left;
+		unsigned int out_left;
+
+		/* Start within 1024 pixels of the right edge */
+		out_start = max_t(int, 0, out_right - 1024);
+		/* End before having to add more columns to the left */
+		out_end = min_t(unsigned int, out_right, col * 1024);
+
+		find_best_seam(ctx, out_start, out_end,
+			       in_left_align, out_left_align, out_width_align,
+			       ctx->downsize_coeff_h, ctx->image_resize_coeff_h,
+			       allow_overshoot, &in_left, &out_left);
+
+		if (ctx->rot_mode & IPU_ROT_BIT_HFLIP)
+			flipped_out_left = resized_width - out_right;
+		else
+			flipped_out_left = out_left;
+
+		fill_tile_column(ctx, col, in, in_left, in_right - in_left,
+				 out, flipped_out_left, out_right - out_left);
+
+		dev_dbg(dev, "%s: col %u: %u, %u -> %u, %u\n", __func__, col,
+			in_left, in_right - in_left,
+			flipped_out_left, out_right - out_left);
+
+		in_right = in_left;
+		out_right = out_left;
+	}
+
+	flipped_out_left = (ctx->rot_mode & IPU_ROT_BIT_HFLIP) ?
+			   resized_width - out_right : 0;
+
+	fill_tile_column(ctx, 0, in, 0, in_right,
+			 out, flipped_out_left, out_right);
+
+	dev_dbg(dev, "%s: col 0: 0, %u -> %u, %u\n", __func__,
+		in_right, flipped_out_left, out_right);
+
+	for (row = in->num_rows - 1; row > 0; row--) {
+		bool allow_overshoot = row < in->num_rows - 1;
+		unsigned int out_start;
+		unsigned int out_end;
+		unsigned int in_top;
+		unsigned int out_top;
+
+		/* Start within 1024 lines of the bottom edge */
+		out_start = max_t(int, 0, out_bottom - 1024);
+		/* End before having to add more rows above */
+		out_end = min_t(unsigned int, out_right, row * 1024);
+
+		find_best_seam(ctx, out_start, out_end,
+			       in_top_align, out_top_align, out_height_align,
+			       ctx->downsize_coeff_v, ctx->image_resize_coeff_v,
+			       allow_overshoot, &in_top, &out_top);
+
+		if ((ctx->rot_mode & IPU_ROT_BIT_VFLIP) ^
+		    ipu_rot_mode_is_irt(ctx->rot_mode))
+			flipped_out_top = resized_height - out_bottom;
+		else
+			flipped_out_top = out_top;
+
+		fill_tile_row(ctx, row, in, in_top, in_bottom - in_top,
+			      out, flipped_out_top, out_bottom - out_top);
+
+		dev_dbg(dev, "%s: row %u: %u, %u -> %u, %u\n", __func__, row,
+			in_top, in_bottom - in_top,
+			flipped_out_top, out_bottom - out_top);
+
+		in_bottom = in_top;
+		out_bottom = out_top;
+	}
+
+	if ((ctx->rot_mode & IPU_ROT_BIT_VFLIP) ^
+	    ipu_rot_mode_is_irt(ctx->rot_mode))
+		flipped_out_top = resized_height - out_bottom;
+	else
+		flipped_out_top = 0;
+
+	fill_tile_row(ctx, 0, in, 0, in_bottom,
+		      out, flipped_out_top, out_bottom);
+
+	dev_dbg(dev, "%s: row 0: 0, %u -> %u, %u\n", __func__,
+		in_bottom, flipped_out_top, out_bottom);
+}
+
 static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 				 struct ipu_image_convert_image *image)
 {
 	unsigned int i;
 
 	for (i = 0; i < ctx->num_tiles; i++) {
-		struct ipu_image_tile *tile = &image->tile[i];
+		struct ipu_image_tile *tile;
 		const unsigned int row = i / image->num_cols;
 		const unsigned int col = i % image->num_cols;
 
-		tile->height = image->base.pix.height / image->num_rows;
-		tile->width = image->base.pix.width / image->num_cols;
-		tile->left = col * tile->width;
-		tile->top = row * tile->height;
+		if (image->type == IMAGE_CONVERT_OUT)
+			tile = &image->tile[ctx->out_tile_map[i]];
+		else
+			tile = &image->tile[i];
+
 		tile->size = ((tile->height * image->fmt->bpp) >> 3) *
 			tile->width;
 
@@ -1662,13 +1967,16 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	if (ret)
 		goto out_free;
 
+	calc_out_tile_map(ctx);
+
+	find_seams(ctx, s_image, d_image);
+
 	calc_tile_dimensions(ctx, s_image);
 	calc_tile_offsets(ctx, s_image);
 
 	calc_tile_dimensions(ctx, d_image);
 	calc_tile_offsets(ctx, d_image);
 
-	calc_out_tile_map(ctx);
 	calc_tile_resize_coefficients(ctx);
 
 	dump_format(ctx, s_image);
-- 
2.18.0
