Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39749 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbeIRPG3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:06:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v3 15/16] gpu: ipu-v3: image-convert: disable double buffering if necessary
Date: Tue, 18 Sep 2018 11:34:20 +0200
Message-Id: <20180918093421.12930-16-p.zabel@pengutronix.de>
In-Reply-To: <20180918093421.12930-1-p.zabel@pengutronix.de>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Double-buffering only works if tile sizes are the same and the resizing
coefficient does not change between tiles, even for non-planar formats.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v2.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 27 ++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 6179d8bd123c..6ab880416919 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1973,6 +1973,7 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	struct ipu_image_convert_chan *chan;
 	struct ipu_image_convert_ctx *ctx;
 	unsigned long flags;
+	unsigned int i;
 	bool get_res;
 	int ret;
 
@@ -2056,15 +2057,37 @@ ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
 	 * for every tile, and therefore would have to be updated for
 	 * each buffer which is not possible. So double-buffering is
 	 * impossible when either the source or destination images are
-	 * a planar format (YUV420, YUV422P, etc.).
+	 * a planar format (YUV420, YUV422P, etc.). Further, differently
+	 * sized tiles or different resizing coefficients per tile
+	 * prevent double-buffering as well.
 	 */
 	ctx->double_buffering = (ctx->num_tiles > 1 &&
 				 !s_image->fmt->planar &&
 				 !d_image->fmt->planar);
+	for (i = 1; i < ctx->num_tiles; i++) {
+		if (ctx->in.tile[i].width != ctx->in.tile[0].width ||
+		    ctx->in.tile[i].height != ctx->in.tile[0].height ||
+		    ctx->out.tile[i].width != ctx->out.tile[0].width ||
+		    ctx->out.tile[i].height != ctx->out.tile[0].height) {
+			ctx->double_buffering = false;
+			break;
+		}
+	}
+	for (i = 1; i < ctx->in.num_cols; i++) {
+		if (ctx->resize_coeffs_h[i] != ctx->resize_coeffs_h[0]) {
+			ctx->double_buffering = false;
+			break;
+		}
+	}
+	for (i = 1; i < ctx->in.num_rows; i++) {
+		if (ctx->resize_coeffs_v[i] != ctx->resize_coeffs_v[0]) {
+			ctx->double_buffering = false;
+			break;
+		}
+	}
 
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		unsigned long intermediate_size = d_image->tile[0].size;
-		unsigned int i;
 
 		for (i = 1; i < ctx->num_tiles; i++) {
 			if (d_image->tile[i].size > intermediate_size)
-- 
2.19.0
