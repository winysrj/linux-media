Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41787 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 03/22] gpu: ipu-v3: Add chroma plane offset overrides to ipu_cpmem_set_image()
Date: Fri, 19 Oct 2018 14:15:20 +0200
Message-Id: <20181019121539.12778-4-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Allow the caller of ipu_cpmem_set_image() to override the latters
calculation of the chroma plane offsets, by adding override U/V
plane offsets to 'struct ipu_image'.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-cpmem.c         | 46 +++++++++++++++-----------
 drivers/gpu/ipu-v3/ipu-image-convert.c | 10 +++---
 include/video/imx-ipu-v3.h             |  3 ++
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 7e65954f13c2..163fadb8a33a 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -745,48 +745,56 @@ int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 		offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = U_OFFSET(pix, image->rect.left,
-				    image->rect.top) - offset;
-		v_offset = V_OFFSET(pix, image->rect.left,
-				    image->rect.top) - offset;
+		u_offset = image->u_offset ?
+			image->u_offset : U_OFFSET(pix, image->rect.left,
+						   image->rect.top) - offset;
+		v_offset = image->v_offset ?
+			image->v_offset : V_OFFSET(pix, image->rect.left,
+						   image->rect.top) - offset;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->bytesperline / 2,
 					      u_offset, v_offset);
 		break;
 	case V4L2_PIX_FMT_YVU420:
 		offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = U_OFFSET(pix, image->rect.left,
-				    image->rect.top) - offset;
-		v_offset = V_OFFSET(pix, image->rect.left,
-				    image->rect.top) - offset;
+		u_offset = image->u_offset ?
+			image->u_offset : V_OFFSET(pix, image->rect.left,
+						   image->rect.top) - offset;
+		v_offset = image->v_offset ?
+			image->v_offset : U_OFFSET(pix, image->rect.left,
+						   image->rect.top) - offset;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->bytesperline / 2,
-					      v_offset, u_offset);
+					      u_offset, v_offset);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 		offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = U2_OFFSET(pix, image->rect.left,
-				     image->rect.top) - offset;
-		v_offset = V2_OFFSET(pix, image->rect.left,
-				     image->rect.top) - offset;
+		u_offset = image->u_offset ?
+			image->u_offset : U2_OFFSET(pix, image->rect.left,
+						    image->rect.top) - offset;
+		v_offset = image->v_offset ?
+			image->v_offset : V2_OFFSET(pix, image->rect.left,
+						    image->rect.top) - offset;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->bytesperline / 2,
 					      u_offset, v_offset);
 		break;
 	case V4L2_PIX_FMT_NV12:
 		offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = UV_OFFSET(pix, image->rect.left,
-				     image->rect.top) - offset;
-		v_offset = 0;
+		u_offset = image->u_offset ?
+			image->u_offset : UV_OFFSET(pix, image->rect.left,
+						    image->rect.top) - offset;
+		v_offset = image->v_offset ? image->v_offset : 0;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->bytesperline,
 					      u_offset, v_offset);
 		break;
 	case V4L2_PIX_FMT_NV16:
 		offset = Y_OFFSET(pix, image->rect.left, image->rect.top);
-		u_offset = UV2_OFFSET(pix, image->rect.left,
-				      image->rect.top) - offset;
-		v_offset = 0;
+		u_offset = image->u_offset ?
+			image->u_offset : UV2_OFFSET(pix, image->rect.left,
+						     image->rect.top) - offset;
+		v_offset = image->v_offset ? image->v_offset : 0;
 
 		ipu_cpmem_set_yuv_planar_full(ch, pix->bytesperline,
 					      u_offset, v_offset);
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index f4081962784c..41fb62b88c54 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -655,12 +655,12 @@ static void init_idmac_channel(struct ipu_image_convert_ctx *ctx,
 	tile_image.pix.pixelformat =  image->fmt->fourcc;
 	tile_image.phys0 = addr0;
 	tile_image.phys1 = addr1;
-	ipu_cpmem_set_image(channel, &tile_image);
+	if (image->fmt->planar && !rot_swap_width_height) {
+		tile_image.u_offset = image->tile[tile_idx[0]].u_off;
+		tile_image.v_offset = image->tile[tile_idx[0]].v_off;
+	}
 
-	if (image->fmt->planar && !rot_swap_width_height)
-		ipu_cpmem_set_uv_offset(channel,
-					image->tile[tile_idx[0]].u_off,
-					image->tile[tile_idx[0]].v_off);
+	ipu_cpmem_set_image(channel, &tile_image);
 
 	if (rot_mode)
 		ipu_cpmem_set_rotation(channel, rot_mode);
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index abbad94e14a1..8bb163cd9314 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -246,6 +246,9 @@ struct ipu_image {
 	struct v4l2_rect rect;
 	dma_addr_t phys0;
 	dma_addr_t phys1;
+	/* chroma plane offset overrides */
+	u32 u_offset;
+	u32 v_offset;
 };
 
 void ipu_cpmem_zero(struct ipuv3_channel *ch);
-- 
2.19.0
