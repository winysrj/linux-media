Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54695 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934003AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 05/16] gpu: ipu-v3: image-convert: store tile top/left position
Date: Fri, 22 Jun 2018 17:52:06 +0200
Message-Id: <20180622155217.29302-6-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Store tile top/left position in pixels in the tile structure.
This will allow overlapping tiles with different sizes later.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 27 ++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 3907fb7dae13..c3358e83bcc1 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -84,6 +84,8 @@ struct ipu_image_convert_dma_chan {
 struct ipu_image_tile {
 	u32 width;
 	u32 height;
+	u32 left;
+	u32 top;
 	/* size and strides are in bytes */
 	u32 size;
 	u32 stride;
@@ -427,13 +429,17 @@ static int calc_image_resize_coefficients(struct ipu_image_convert_ctx *ctx,
 static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 				 struct ipu_image_convert_image *image)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < ctx->num_tiles; i++) {
 		struct ipu_image_tile *tile = &image->tile[i];
+		const unsigned int row = i / image->num_cols;
+		const unsigned int col = i % image->num_cols;
 
 		tile->height = image->base.pix.height / image->num_rows;
 		tile->width = image->base.pix.width / image->num_cols;
+		tile->left = col * tile->width;
+		tile->top = row * tile->height;
 		tile->size = ((tile->height * image->fmt->bpp) >> 3) *
 			tile->width;
 
@@ -529,7 +535,7 @@ static void calc_tile_offsets_planar(struct ipu_image_convert_ctx *ctx,
 	struct ipu_image_convert_priv *priv = chan->priv;
 	const struct ipu_image_pixfmt *fmt = image->fmt;
 	unsigned int row, col, tile = 0;
-	u32 H, w, h, y_stride, uv_stride;
+	u32 H, top, y_stride, uv_stride;
 	u32 uv_row_off, uv_col_off, uv_off, u_off, v_off, tmp;
 	u32 y_row_off, y_col_off, y_off;
 	u32 y_size, uv_size;
@@ -546,13 +552,12 @@ static void calc_tile_offsets_planar(struct ipu_image_convert_ctx *ctx,
 	uv_size = y_size / (fmt->uv_width_dec * fmt->uv_height_dec);
 
 	for (row = 0; row < image->num_rows; row++) {
-		w = image->tile[tile].width;
-		h = image->tile[tile].height;
-		y_row_off = row * h * y_stride;
-		uv_row_off = (row * h * uv_stride) / fmt->uv_height_dec;
+		top = image->tile[tile].top;
+		y_row_off = top * y_stride;
+		uv_row_off = (top * uv_stride) / fmt->uv_height_dec;
 
 		for (col = 0; col < image->num_cols; col++) {
-			y_col_off = col * w;
+			y_col_off = image->tile[tile].left;
 			uv_col_off = y_col_off / fmt->uv_width_dec;
 			if (fmt->uv_packed)
 				uv_col_off *= 2;
@@ -589,7 +594,7 @@ static void calc_tile_offsets_packed(struct ipu_image_convert_ctx *ctx,
 	struct ipu_image_convert_priv *priv = chan->priv;
 	const struct ipu_image_pixfmt *fmt = image->fmt;
 	unsigned int row, col, tile = 0;
-	u32 w, h, bpp, stride;
+	u32 bpp, stride;
 	u32 row_off, col_off;
 
 	/* setup some convenience vars */
@@ -597,12 +602,10 @@ static void calc_tile_offsets_packed(struct ipu_image_convert_ctx *ctx,
 	bpp = fmt->bpp;
 
 	for (row = 0; row < image->num_rows; row++) {
-		w = image->tile[tile].width;
-		h = image->tile[tile].height;
-		row_off = row * h * stride;
+		row_off = image->tile[tile].top * stride;
 
 		for (col = 0; col < image->num_cols; col++) {
-			col_off = (col * w * bpp) >> 3;
+			col_off = (image->tile[tile].left * bpp) >> 3;
 
 			image->tile[tile].offset = row_off + col_off;
 			image->tile[tile].u_off = 0;
-- 
2.17.1
