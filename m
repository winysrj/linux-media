Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:60153 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751141AbeDNMA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:00:27 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 15/33] rcar-vin: break out format alignment and checking
Date: Sat, 14 Apr 2018 13:57:08 +0200
Message-Id: <20180414115726.5075-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of the format alignment and checking can be shared with the Gen3
format handling. Break that part out to a separate function.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 85 ++++++++++++++++-------------
 1 file changed, 48 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index d9231a074aa2c29d..f3a0310c43a9877f 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -87,6 +87,53 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
 	return pix->bytesperline * pix->height;
 }
 
+static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+{
+	u32 walign;
+
+	if (!rvin_format_from_pixel(pix->pixelformat) ||
+	    (vin->info->model == RCAR_M1 &&
+	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
+		pix->pixelformat = RVIN_DEFAULT_FORMAT;
+
+	switch (pix->field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	case V4L2_FIELD_ALTERNATE:
+		/*
+		 * Driver does not (yet) support outputting ALTERNATE to a
+		 * userspace. It does support outputting INTERLACED so use
+		 * the VIN hardware to combine the two fields.
+		 */
+		pix->field = V4L2_FIELD_INTERLACED;
+		pix->height *= 2;
+		break;
+	default:
+		pix->field = RVIN_DEFAULT_FIELD;
+		break;
+	}
+
+	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
+	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
+
+	/* Limit to VIN capabilities */
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
+
+	pix->bytesperline = rvin_format_bytesperline(pix);
+	pix->sizeimage = rvin_format_sizeimage(pix);
+
+	vin_dbg(vin, "Format %ux%u bpl: %u size: %u\n",
+		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2
  */
@@ -186,7 +233,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 			     struct v4l2_pix_format *pix,
 			     struct rvin_source_fmt *source)
 {
-	u32 walign;
 	int ret;
 
 	if (!rvin_format_from_pixel(pix->pixelformat) ||
@@ -199,42 +245,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	if (ret)
 		return ret;
 
-	switch (pix->field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_NONE:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-	case V4L2_FIELD_INTERLACED:
-		break;
-	case V4L2_FIELD_ALTERNATE:
-		/*
-		 * Driver does not (yet) support outputting ALTERNATE to a
-		 * userspace. It does support outputting INTERLACED so use
-		 * the VIN hardware to combine the two fields.
-		 */
-		pix->field = V4L2_FIELD_INTERLACED;
-		pix->height *= 2;
-		break;
-	default:
-		pix->field = RVIN_DEFAULT_FIELD;
-		break;
-	}
-
-	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
-	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
-
-	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
-			      &pix->height, 4, vin->info->max_height, 2, 0);
-
-	pix->bytesperline = rvin_format_bytesperline(pix);
-	pix->sizeimage = rvin_format_sizeimage(pix);
-
-	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
-		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
-
-	return 0;
+	return rvin_format_align(vin, pix);
 }
 
 static int rvin_querycap(struct file *file, void *priv,
-- 
2.16.2
