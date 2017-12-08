Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44926 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdLHBJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 18/28] rcar-vin: break out format alignment and checking
Date: Fri,  8 Dec 2017 02:08:32 +0100
Message-Id: <20171208010842.20047-19-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of the format alignment and checking can be shared with the Gen3
format handling. Break that part out to its own function. While doing
this clean up the checking and add more checks.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 98 +++++++++++++++--------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 56c5183f55922e1d..0ffbf0c16fb7b00e 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -86,6 +86,56 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
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
+	/* Check that colorspace is reasonable, if not keep current */
+	if (!pix->colorspace || pix->colorspace >= 0xff)
+		pix->colorspace = vin->format.colorspace;
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
+	if (vin->info->chip == RCAR_M1 &&
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
@@ -191,64 +241,18 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
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
-
-	/* Always recalculate */
-	pix->bytesperline = 0;
-	pix->sizeimage = 0;
-
 	/* Limit to source capabilities */
 	ret = __rvin_try_format_source(vin, which, pix);
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
-	if (vin->info->chip == RCAR_M1 &&
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
2.15.0
