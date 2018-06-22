Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54111 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934044AbeFVPwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:22 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 12/16] gpu: ipu-v3: image-convert: relax output alignment restrictions
Date: Fri, 22 Jun 2018 17:52:13 +0200
Message-Id: <20180622155217.29302-13-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we allow different tile sizes, the output tile with / height
alignment doesn't need to be multiplied by number of columns / rows.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 04113b1c7a92..3eb74d41733f 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1852,9 +1852,8 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 	}
 
 	/* align output width/height */
-	w_align = ilog2(tile_width_align(outfmt) * num_out_cols);
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, rot_mode) *
-			num_out_rows);
+	w_align = ilog2(tile_width_align(outfmt));
+	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, rot_mode));
 	out->pix.width = clamp_align(out->pix.width, MIN_W, MAX_W, w_align);
 	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
 
-- 
2.17.1
