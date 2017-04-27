Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:57478 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032285AbdD0Wmz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:42:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 09/27] rcar-vin: all Gen2 boards can scale simplify logic
Date: Fri, 28 Apr 2017 00:41:45 +0200
Message-Id: <20170427224203.14611-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic to preserve the requested format width and height are too
complex and come from a premature optimization for Gen3. All Gen2 SoC
can scale and the Gen3 implementation will not use these functions at
all so simply preserve the width and hight when interacting with the
subdevice much like the field is preserved simplifies the logic quiet a
bit.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  |  8 --------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 22 ++++++++++------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 --
 3 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index eff5d8f719e4ab26..286aafab533cda9d 100644
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
index 709ee828f2ac2173..40bb3d7e73131d3b 100644
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
 
 	format.pad = vin->digital.source_pad;
 
+	/* Allow the video device to override field and to scale */
 	field = pix->field;
+	width = pix->width;
+	height = pix->height;
 
 	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -191,6 +195,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	source->width = pix->width;
 	source->height = pix->height;
 
+	pix->width = width;
+	pix->height = height;
+
 	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
 		source->height);
 
@@ -205,13 +212,9 @@ static int __rvin_try_format(struct rvin_dev *vin,
 			     struct rvin_source_fmt *source)
 {
 	const struct rvin_video_format *info;
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
@@ -254,10 +257,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 		break;
 	}
 
-	/* If source can't match format try if VIN can scale */
-	if (source->width != rwidth || source->height != rheight)
-		rvin_scale_try(vin, pix, rwidth, rheight);
-
 	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
 	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
 
@@ -276,9 +275,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
index 32d9d130dd6e2e44..6bf2e4ff8f6076c7 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -176,8 +176,6 @@ void rvin_v4l2_remove(struct rvin_dev *vin);
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
 /* Cropping, composing and scaling */
-void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
-		    u32 width, u32 height);
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
 #endif
-- 
2.12.2
