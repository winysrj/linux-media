Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:32917 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932940AbcIBQq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:46:58 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 5/6] media: rcar-vin: fix height for TOP and BOTTOM fields
Date: Fri,  2 Sep 2016 18:45:00 +0200
Message-Id: <20160902164501.19535-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The height used for V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM where wrong.
The frames only contain one field so the height should be half of the
frame.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 47d8d97..1392514 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -125,6 +125,8 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+		vin->format.height /= 2;
+		break;
 	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
@@ -220,21 +222,13 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	/* Limit to source capabilities */
 	__rvin_try_format_source(vin, which, pix, source);
 
-	/* If source can't match format try if VIN can scale */
-	if (source->width != rwidth || source->height != rheight)
-		rvin_scale_try(vin, pix, rwidth, rheight);
-
-	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
-	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
-
-	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
-			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
-
 	switch (pix->field) {
-	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+		pix->height /= 2;
+		source->height /= 2;
+		break;
+	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
 	case V4L2_FIELD_INTERLACED:
@@ -244,6 +238,17 @@ static int __rvin_try_format(struct rvin_dev *vin,
 		break;
 	}
 
+	/* If source can't match format try if VIN can scale */
+	if (source->width != rwidth || source->height != rheight)
+		rvin_scale_try(vin, pix, rwidth, rheight);
+
+	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
+	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
+
+	/* Limit to VIN capabilities */
+	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
+			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
+
 	pix->bytesperline = max_t(u32, pix->bytesperline,
 				  rvin_format_bytesperline(pix));
 	pix->sizeimage = max_t(u32, pix->sizeimage,
-- 
2.9.3

