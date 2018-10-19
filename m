Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 09/22] gpu: ipu-v3: image-convert: Catch unaligned tile offsets
Date: Fri, 19 Oct 2018 14:15:26 +0200
Message-Id: <20181019121539.12778-10-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Catch calculated tile offsets that are not 8-byte aligned as required by the
IDMAC engine and return error in calc_tile_offsets().

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 61 ++++++++++++++++----------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index b8a400182a00..5fccba176e39 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -459,8 +459,8 @@ static void calc_out_tile_map(struct ipu_image_convert_ctx *ctx)
 	}
 }
 
-static void calc_tile_offsets_planar(struct ipu_image_convert_ctx *ctx,
-				     struct ipu_image_convert_image *image)
+static int calc_tile_offsets_planar(struct ipu_image_convert_ctx *ctx,
+				    struct ipu_image_convert_image *image)
 {
 	struct ipu_image_convert_chan *chan = ctx->chan;
 	struct ipu_image_convert_priv *priv = chan->priv;
@@ -509,24 +509,30 @@ static void calc_tile_offsets_planar(struct ipu_image_convert_ctx *ctx,
 			image->tile[tile].u_off = u_off;
 			image->tile[tile++].v_off = v_off;
 
-			dev_dbg(priv->ipu->dev,
-				"task %u: ctx %p: %s@[%d,%d]: y_off %08x, u_off %08x, v_off %08x\n",
-				chan->ic_task, ctx,
-				image->type == IMAGE_CONVERT_IN ?
-				"Input" : "Output", row, col,
-				y_off, u_off, v_off);
+			if ((y_off & 0x7) || (u_off & 0x7) || (v_off & 0x7)) {
+				dev_err(priv->ipu->dev,
+					"task %u: ctx %p: %s@[%d,%d]: "
+					"y_off %08x, u_off %08x, v_off %08x\n",
+					chan->ic_task, ctx,
+					image->type == IMAGE_CONVERT_IN ?
+					"Input" : "Output", row, col,
+					y_off, u_off, v_off);
+				return -EINVAL;
+			}
 		}
 	}
+
+	return 0;
 }
 
-static void calc_tile_offsets_packed(struct ipu_image_convert_ctx *ctx,
-				     struct ipu_image_convert_image *image)
+static int calc_tile_offsets_packed(struct ipu_image_convert_ctx *ctx,
+				    struct ipu_image_convert_image *image)
 {
 	struct ipu_image_convert_chan *chan = ctx->chan;
 	struct ipu_image_convert_priv *priv = chan->priv;
 	const struct ipu_image_pixfmt *fmt = image->fmt;
 	unsigned int row, col, tile = 0;
-	u32 w, h, bpp, stride;
+	u32 w, h, bpp, stride, offset;
 	u32 row_off, col_off;
 
 	/* setup some convenience vars */
@@ -541,27 +547,35 @@ static void calc_tile_offsets_packed(struct ipu_image_convert_ctx *ctx,
 		for (col = 0; col < image->num_cols; col++) {
 			col_off = (col * w * bpp) >> 3;
 
-			image->tile[tile].offset = row_off + col_off;
+			offset = row_off + col_off;
+
+			image->tile[tile].offset = offset;
 			image->tile[tile].u_off = 0;
 			image->tile[tile++].v_off = 0;
 
-			dev_dbg(priv->ipu->dev,
-				"task %u: ctx %p: %s@[%d,%d]: phys %08x\n",
-				chan->ic_task, ctx,
-				image->type == IMAGE_CONVERT_IN ?
-				"Input" : "Output", row, col,
-				row_off + col_off);
+			if (offset & 0x7) {
+				dev_err(priv->ipu->dev,
+					"task %u: ctx %p: %s@[%d,%d]: "
+					"phys %08x\n",
+					chan->ic_task, ctx,
+					image->type == IMAGE_CONVERT_IN ?
+					"Input" : "Output", row, col,
+					row_off + col_off);
+				return -EINVAL;
+			}
 		}
 	}
+
+	return 0;
 }
 
-static void calc_tile_offsets(struct ipu_image_convert_ctx *ctx,
+static int calc_tile_offsets(struct ipu_image_convert_ctx *ctx,
 			      struct ipu_image_convert_image *image)
 {
 	if (image->fmt->planar)
-		calc_tile_offsets_planar(ctx, image);
-	else
-		calc_tile_offsets_packed(ctx, image);
+		return calc_tile_offsets_planar(ctx, image);
+
+	return calc_tile_offsets_packed(ctx, image);
 }
 
 /*
@@ -1199,9 +1213,8 @@ static int fill_image(struct ipu_image_convert_ctx *ctx,
 		ic_image->stride  = ic_image->base.pix.bytesperline;
 
 	calc_tile_dimensions(ctx, ic_image);
-	calc_tile_offsets(ctx, ic_image);
 
-	return 0;
+	return calc_tile_offsets(ctx, ic_image);
 }
 
 /* borrowed from drivers/media/v4l2-core/v4l2-common.c */
-- 
2.19.0
