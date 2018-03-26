Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:32058 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752138AbeCZVqf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 10/33] rcar-vin: all Gen2 boards can scale simplify logic
Date: Mon, 26 Mar 2018 23:44:33 +0200
Message-Id: <20180326214456.6655-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic to preserve the requested format width and height are too
complex and come from a premature optimization for Gen3. All Gen2 SoC
can scale and the Gen3 implementation will not use these functions at
all so simply preserve the width and height when interacting with the
subdevice much like the field is preserved simplifies the logic quite a
bit.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  |  8 --------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 25 +++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 --
 3 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 23120901b0a062ed..4f48575f2008fe34 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -585,14 +585,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 		0, 0);
 }
 
-void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
-		    u32 width, u32 height)
-{
-	/* All VIN channels on Gen2 have scalers */
-	pix->width = width;
-	pix->height = height;
-}
-
 /* -----------------------------------------------------------------------------
  * Hardware setup
  */
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 8805d7911a761019..c2265324c7c96308 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -166,6 +166,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 		.which = which,
 	};
 	enum v4l2_field field;
+	u32 width, height;
 	int ret;
 
 	sd = vin_to_source(vin);
@@ -178,7 +179,10 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	format.pad = vin->digital->source_pad;
 
+	/* Allow the video device to override field and to scale */
 	field = pix->field;
+	width = pix->width;
+	height = pix->height;
 
 	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -186,11 +190,13 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	v4l2_fill_pix_format(pix, &format.format);
 
-	pix->field = field;
-
 	source->width = pix->width;
 	source->height = pix->height;
 
+	pix->field = field;
+	pix->width = width;
+	pix->height = height;
+
 	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
 		source->height);
 
@@ -204,13 +210,9 @@ static int __rvin_try_format(struct rvin_dev *vin,
 			     struct v4l2_pix_format *pix,
 			     struct rvin_source_fmt *source)
 {
-	u32 rwidth, rheight, walign;
+	u32 walign;
 	int ret;
 
-	/* Requested */
-	rwidth = pix->width;
-	rheight = pix->height;
-
 	/* Keep current field if no specific one is asked for */
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = vin->format.field;
@@ -248,10 +250,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 		break;
 	}
 
-	/* If source can't match format try if VIN can scale */
-	if (source->width != rwidth || source->height != rheight)
-		rvin_scale_try(vin, pix, rwidth, rheight);
-
 	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
 	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
 
@@ -270,9 +268,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 		return -EINVAL;
 	}
 
-	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
-		rwidth, rheight, pix->width, pix->height,
-		pix->bytesperline, pix->sizeimage);
+	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
+		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
 
 	return 0;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8d135ed3f7abd855..1c91b774205a7750 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -175,8 +175,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
 /* Cropping, composing and scaling */
-void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
-		    u32 width, u32 height);
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
 #endif
-- 
2.16.2
