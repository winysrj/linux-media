Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47999 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbeJSUVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 14/22] gpu: ipu-v3: image-convert: calculate tile dimensions and offsets outside fill_image
Date: Fri, 19 Oct 2018 14:15:31 +0200
Message-Id: <20181019121539.12778-15-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow to calculate seam positions after initializing the
ipu_image base structure but before calculating tile dimensions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index d14ee7b303a1..542c091cfef1 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1467,9 +1467,7 @@ static int fill_image(struct ipu_image_convert_ctx *ctx,
 	else
 		ic_image->stride  = ic_image->base.pix.bytesperline;
 
-	calc_tile_dimensions(ctx, ic_image);
-
-	return calc_tile_offsets(ctx, ic_image);
+	return 0;
 }
 
 /* borrowed from drivers/media/v4l2-core/v4l2-common.c */
@@ -1673,14 +1671,24 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	ctx->num_tiles = d_image->num_cols * d_image->num_rows;
 	ctx->rot_mode = rot_mode;
 
+	ret = fill_image(ctx, s_image, in, IMAGE_CONVERT_IN);
+	if (ret)
+		goto out_free;
+	ret = fill_image(ctx, d_image, out, IMAGE_CONVERT_OUT);
+	if (ret)
+		goto out_free;
+
 	ret = calc_image_resize_coefficients(ctx, in, out);
 	if (ret)
 		goto out_free;
 
-	ret = fill_image(ctx, s_image, in, IMAGE_CONVERT_IN);
+	calc_tile_dimensions(ctx, s_image);
+	ret = calc_tile_offsets(ctx, s_image);
 	if (ret)
 		goto out_free;
-	ret = fill_image(ctx, d_image, out, IMAGE_CONVERT_OUT);
+
+	calc_tile_dimensions(ctx, d_image);
+	ret = calc_tile_offsets(ctx, d_image);
 	if (ret)
 		goto out_free;
 
-- 
2.19.0
