Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:35093 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751611AbeA2Qff (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:35 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 15/30] rcar-vin: break out format alignment and checking
Date: Mon, 29 Jan 2018 17:34:20 +0100
Message-Id: <20180129163435.24936-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of the format alignment and checking can be shared with the Gen3
format handling. Break that part out to a separate function.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 93 ++++++++++++++++-------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c606942e59b5d934..1169e6a279ecfb55 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -86,6 +86,55 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
 	return pix->bytesperline * pix->height;
 }
 
+static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+{
+	u32 walign;
+
+	/* If requested format is not supported fallback to the default */
+	if (!rvin_format_from_pixel(pix->pixelformat)) {
+		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
+			pix->pixelformat, RVIN_DEFAULT_FORMAT);
+		pix->pixelformat = RVIN_DEFAULT_FORMAT;
+	}
+
+	/* Reject ALTERNATE  until support is added to the driver */
+	switch (pix->field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		pix->field = V4L2_FIELD_NONE;
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
+	pix->bytesperline = max_t(u32, pix->bytesperline,
+				  rvin_format_bytesperline(pix));
+	pix->sizeimage = max_t(u32, pix->sizeimage,
+			       rvin_format_sizeimage(pix));
+
+	if (vin->info->model == RCAR_M1 &&
+	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
+		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
+		return -EINVAL;
+	}
+
+	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
+		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2
  */
@@ -215,19 +264,12 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 static int __rvin_try_format(struct rvin_dev *vin,
 			     u32 which, struct v4l2_pix_format *pix)
 {
-	u32 walign;
 	int ret;
 
 	/* Keep current field if no specific one is asked for */
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = vin->format.field;
 
-	/* If requested format is not supported fallback to the default */
-	if (!rvin_format_from_pixel(pix->pixelformat)) {
-		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
-			pix->pixelformat, RVIN_DEFAULT_FORMAT);
-		pix->pixelformat = RVIN_DEFAULT_FORMAT;
-	}
 
 	/* Always recalculate */
 	pix->bytesperline = 0;
@@ -238,42 +280,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	if (ret)
 		return ret;
 
-	/* Reject ALTERNATE  until support is added to the driver */
-	switch (pix->field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_NONE:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		pix->field = V4L2_FIELD_NONE;
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
-	pix->bytesperline = max_t(u32, pix->bytesperline,
-				  rvin_format_bytesperline(pix));
-	pix->sizeimage = max_t(u32, pix->sizeimage,
-			       rvin_format_sizeimage(pix));
-
-	if (vin->info->model == RCAR_M1 &&
-	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
-		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
-		return -EINVAL;
-	}
-
-	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
-		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
-
-	return 0;
+	return rvin_format_align(vin, pix);
 }
 
 static int rvin_querycap(struct file *file, void *priv,
-- 
2.16.1
