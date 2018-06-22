Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33963 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933962AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 07/16] gpu: ipu-v3: image-convert: move tile alignment helpers
Date: Fri, 22 Jun 2018 17:52:08 +0200
Message-Id: <20180622155217.29302-8-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move tile_width_align and tile_height_align up so they
can be used by the tile edge position calculation code.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 54 +++++++++++++-------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 06d65c63262d..da6f18475b6b 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -426,6 +426,33 @@ static int calc_image_resize_coefficients(struct ipu_image_convert_ctx *ctx,
 	return 0;
 }
 
+/*
+ * We have to adjust the tile width such that the tile physaddrs and
+ * U and V plane offsets are multiples of 8 bytes as required by
+ * the IPU DMA Controller. For the planar formats, this corresponds
+ * to a pixel alignment of 16 (but use a more formal equation since
+ * the variables are available). For all the packed formats, 8 is
+ * good enough.
+ */
+static inline u32 tile_width_align(const struct ipu_image_pixfmt *fmt)
+{
+	return fmt->planar ? 8 * fmt->uv_width_dec : 8;
+}
+
+/*
+ * For tile height alignment, we have to ensure that the output tile
+ * heights are multiples of 8 lines if the IRT is required by the
+ * given rotation mode (the IRT performs rotations on 8x8 blocks
+ * at a time). If the IRT is not used, or for input image tiles,
+ * 2 lines are good enough.
+ */
+static inline u32 tile_height_align(enum ipu_image_convert_type type,
+				    enum ipu_rotate_mode rot_mode)
+{
+	return (type == IMAGE_CONVERT_OUT &&
+		ipu_rot_mode_is_irt(rot_mode)) ? 8 : 2;
+}
+
 static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 				 struct ipu_image_convert_image *image)
 {
@@ -1467,33 +1494,6 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 	return x;
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
-{
-	return fmt->planar ? 8 * fmt->uv_width_dec : 8;
-}
-
-/*
- * For tile height alignment, we have to ensure that the output tile
- * heights are multiples of 8 lines if the IRT is required by the
- * given rotation mode (the IRT performs rotations on 8x8 blocks
- * at a time). If the IRT is not used, or for input image tiles,
- * 2 lines are good enough.
- */
-static inline u32 tile_height_align(enum ipu_image_convert_type type,
-				    enum ipu_rotate_mode rot_mode)
-{
-	return (type == IMAGE_CONVERT_OUT &&
-		ipu_rot_mode_is_irt(rot_mode)) ? 8 : 2;
-}
-
 /* Adjusts input/output images to IPU restrictions */
 void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 			      enum ipu_rotate_mode rot_mode)
-- 
2.17.1
