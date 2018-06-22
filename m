Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55393 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933961AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 06/16] gpu: ipu-v3: image-convert: calculate tile dimensions and offsets outside fill_image
Date: Fri, 22 Jun 2018 17:52:07 +0200
Message-Id: <20180622155217.29302-7-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow to calculate seam positions after initializing the
ipu_image base structure but before calculating tile dimensions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index c3358e83bcc1..06d65c63262d 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1447,9 +1447,6 @@ static int fill_image(struct ipu_image_convert_ctx *ctx,
 	else
 		ic_image->stride  = ic_image->base.pix.bytesperline;
 
-	calc_tile_dimensions(ctx, ic_image);
-	calc_tile_offsets(ctx, ic_image);
-
 	return 0;
 }
 
@@ -1654,10 +1651,6 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	ctx->num_tiles = d_image->num_cols * d_image->num_rows;
 	ctx->rot_mode = rot_mode;
 
-	ret = calc_image_resize_coefficients(ctx, in, out);
-	if (ret)
-		goto out_free;
-
 	ret = fill_image(ctx, s_image, in, IMAGE_CONVERT_IN);
 	if (ret)
 		goto out_free;
@@ -1665,6 +1658,16 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	if (ret)
 		goto out_free;
 
+	ret = calc_image_resize_coefficients(ctx, in, out);
+	if (ret)
+		goto out_free;
+
+	calc_tile_dimensions(ctx, s_image);
+	calc_tile_offsets(ctx, s_image);
+
+	calc_tile_dimensions(ctx, d_image);
+	calc_tile_offsets(ctx, d_image);
+
 	calc_out_tile_map(ctx);
 	calc_tile_resize_coefficients(ctx);
 
-- 
2.17.1
