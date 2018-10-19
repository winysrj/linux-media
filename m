Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50823 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbeJSUVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 18/22] gpu: ipu-v3: image-convert: relax alignment restrictions
Date: Fri, 19 Oct 2018 14:15:35 +0200
Message-Id: <20181019121539.12778-19-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the planar but U/V-packed formats NV12 and NV16, 8 pixel width
alignment is good enough to fulfill the 8 byte stride requirement.
If we allow the input 8-pixel DMA bursts to overshoot the end of the
line, the only input alignment restrictions are dictated by the pixel
format and 8-byte aligned line start address.
Since different tile sizes are allowed, the output tile with / height
alignment doesn't need to be multiplied by number of columns / rows.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[slongerbeam@gmail.com: Bring in the fixes to format width and
 height alignment restrictions from imx-media-mem2mem.c.]
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 81 +++++++++++++-------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 0451d699f515..0829723a7599 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -551,31 +551,46 @@ static inline u32 tile_top_align(const struct ipu_image_pixfmt *fmt)
 	return fmt->uv_height_dec > 1 ? 2 : 1;
 }
 
-/*
- * We have to adjust the tile width such that the tile physaddrs and
- * U and V plane offsets are multiples of 8 bytes as required by
- * the IPU DMA Controller. For the planar formats, this corresponds
- * to a pixel alignment of 16 (but use a more formal equation since
- * the variables are available). For all the packed formats, 8 is
- * good enough.
- */
-static inline u32 tile_width_align(const struct ipu_image_pixfmt *fmt)
+static inline u32 tile_width_align(enum ipu_image_convert_type type,
+				   const struct ipu_image_pixfmt *fmt,
+				   enum ipu_rotate_mode rot_mode)
 {
-	return fmt->planar ? 8 * fmt->uv_width_dec : 8;
+	if (type == IMAGE_CONVERT_IN) {
+		/*
+		 * The IC burst reads 8 pixels at a time. Reading beyond the
+		 * end of the line is usually acceptable. Those pixels are
+		 * ignored, unless the IC has to write the scaled line in
+		 * reverse.
+		 */
+		return (!ipu_rot_mode_is_irt(rot_mode) &&
+			(rot_mode & IPU_ROT_BIT_HFLIP)) ? 8 : 2;
+	}
+
+	/*
+	 * Align to 16x16 pixel blocks for planar 4:2:0 chroma subsampled
+	 * formats to guarantee 8-byte aligned line start addresses in the
+	 * chroma planes when IRT is used. Align to 8x8 pixel IRT block size
+	 * for all other formats.
+	 */
+	return (ipu_rot_mode_is_irt(rot_mode) &&
+		fmt->planar && !fmt->uv_packed) ?
+		8 * fmt->uv_width_dec : 8;
 }
 
-/*
- * For tile height alignment, we have to ensure that the output tile
- * heights are multiples of 8 lines if the IRT is required by the
- * given rotation mode (the IRT performs rotations on 8x8 blocks
- * at a time). If the IRT is not used, or for input image tiles,
- * 2 lines are good enough.
- */
 static inline u32 tile_height_align(enum ipu_image_convert_type type,
+				    const struct ipu_image_pixfmt *fmt,
 				    enum ipu_rotate_mode rot_mode)
 {
-	return (type == IMAGE_CONVERT_OUT &&
-		ipu_rot_mode_is_irt(rot_mode)) ? 8 : 2;
+	if (type == IMAGE_CONVERT_IN || !ipu_rot_mode_is_irt(rot_mode))
+		return 2;
+
+	/*
+	 * Align to 16x16 pixel blocks for planar 4:2:0 chroma subsampled
+	 * formats to guarantee 8-byte aligned line start addresses in the
+	 * chroma planes when IRT is used. Align to 8x8 pixel IRT block size
+	 * for all other formats.
+	 */
+	return (fmt->planar && !fmt->uv_packed) ? 8 * fmt->uv_width_dec : 8;
 }
 
 /*
@@ -661,8 +676,9 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 	unsigned int in_top_align = tile_top_align(in->fmt);
 	unsigned int out_left_align = tile_left_align(out->fmt);
 	unsigned int out_top_align = tile_top_align(out->fmt);
-	unsigned int out_width_align = tile_width_align(out->fmt);
-	unsigned int out_height_align = tile_height_align(out->type,
+	unsigned int out_width_align = tile_width_align(out->type, out->fmt,
+							ctx->rot_mode);
+	unsigned int out_height_align = tile_height_align(out->type, out->fmt,
 							  ctx->rot_mode);
 	unsigned int in_right = in->base.rect.width;
 	unsigned int in_bottom = in->base.rect.height;
@@ -1855,8 +1871,6 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 			      enum ipu_rotate_mode rot_mode)
 {
 	const struct ipu_image_pixfmt *infmt, *outfmt;
-	unsigned int num_in_rows, num_in_cols;
-	unsigned int num_out_rows, num_out_cols;
 	u32 w_align, h_align;
 
 	infmt = get_format(in->pix.pixelformat);
@@ -1888,28 +1902,15 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 					in->pix.height / 4);
 	}
 
-	/* get tiling rows/cols from output format */
-	num_out_rows = num_stripes(out->pix.height);
-	num_out_cols = num_stripes(out->pix.width);
-	if (ipu_rot_mode_is_irt(rot_mode)) {
-		num_in_rows = num_out_cols;
-		num_in_cols = num_out_rows;
-	} else {
-		num_in_rows = num_out_rows;
-		num_in_cols = num_out_cols;
-	}
-
 	/* align input width/height */
-	w_align = ilog2(tile_width_align(infmt) * num_in_cols);
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_IN, rot_mode) *
-			num_in_rows);
+	w_align = ilog2(tile_width_align(IMAGE_CONVERT_IN, infmt, rot_mode));
+	h_align = ilog2(tile_height_align(IMAGE_CONVERT_IN, infmt, rot_mode));
 	in->pix.width = clamp_align(in->pix.width, MIN_W, MAX_W, w_align);
 	in->pix.height = clamp_align(in->pix.height, MIN_H, MAX_H, h_align);
 
 	/* align output width/height */
-	w_align = ilog2(tile_width_align(outfmt) * num_out_cols);
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, rot_mode) *
-			num_out_rows);
+	w_align = ilog2(tile_width_align(IMAGE_CONVERT_OUT, outfmt, rot_mode));
+	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, outfmt, rot_mode));
 	out->pix.width = clamp_align(out->pix.width, MIN_W, MAX_W, w_align);
 	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
 
-- 
2.19.0
