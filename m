Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60289 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934025AbeFVPwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 09/16] gpu: ipu-v3: image-convert: fix debug output for varying tile sizes
Date: Fri, 22 Jun 2018 17:52:10 +0200
Message-Id: <20180622155217.29302-10-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since tile dimensions now vary between tiles, add debug output for each
tile's position and dimensions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index fbb46d296170..edd59c935710 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -302,12 +302,11 @@ static void dump_format(struct ipu_image_convert_ctx *ctx,
 	struct ipu_image_convert_priv *priv = chan->priv;
 
 	dev_dbg(priv->ipu->dev,
-		"task %u: ctx %p: %s format: %dx%d (%dx%d tiles of size %dx%d), %c%c%c%c\n",
+		"task %u: ctx %p: %s format: %dx%d (%dx%d tiles), %c%c%c%c\n",
 		chan->ic_task, ctx,
 		ic_image->type == IMAGE_CONVERT_OUT ? "Output" : "Input",
 		ic_image->base.pix.width, ic_image->base.pix.height,
 		ic_image->num_cols, ic_image->num_rows,
-		ic_image->tile[0].width, ic_image->tile[0].height,
 		ic_image->fmt->fourcc & 0xff,
 		(ic_image->fmt->fourcc >> 8) & 0xff,
 		(ic_image->fmt->fourcc >> 16) & 0xff,
@@ -755,6 +754,8 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 				 struct ipu_image_convert_image *image)
 {
+	struct ipu_image_convert_chan *chan = ctx->chan;
+	struct ipu_image_convert_priv *priv = chan->priv;
 	unsigned int i;
 
 	for (i = 0; i < ctx->num_tiles; i++) {
@@ -779,6 +780,13 @@ static void calc_tile_dimensions(struct ipu_image_convert_ctx *ctx,
 			tile->rot_stride =
 				(image->fmt->bpp * tile->height) >> 3;
 		}
+
+		dev_dbg(priv->ipu->dev,
+			"task %u: ctx %p: %s@[%u,%u]: %ux%u@%u,%u\n",
+			chan->ic_task, ctx,
+			image->type == IMAGE_CONVERT_IN ? "Input" : "Output",
+			row, col,
+			tile->width, tile->height, tile->left, tile->top);
 	}
 }
 
-- 
2.17.1
