Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37445 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934043AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 11/16] gpu: ipu-v3: image-convert: relax input alignment restrictions
Date: Fri, 22 Jun 2018 17:52:12 +0200
Message-Id: <20180622155217.29302-12-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we allow the 8-pixel DMA bursts to overshoot the end of the line, the
only input alignment restrictions are dictated by the pixel format and
8-byte aligned line start address.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 68d84fae9b9d..04113b1c7a92 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1851,13 +1851,6 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 		num_in_cols = num_out_cols;
 	}
 
-	/* align input width/height */
-	w_align = ilog2(tile_width_align(infmt) * num_in_cols);
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_IN, rot_mode) *
-			num_in_rows);
-	in->pix.width = clamp_align(in->pix.width, MIN_W, MAX_W, w_align);
-	in->pix.height = clamp_align(in->pix.height, MIN_H, MAX_H, h_align);
-
 	/* align output width/height */
 	w_align = ilog2(tile_width_align(outfmt) * num_out_cols);
 	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, rot_mode) *
-- 
2.17.1
