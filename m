Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52997 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935026AbcHBOvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 10:51:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 4/7] media: rcar-vin: fix height for TOP and BOTTOM fields
Date: Tue,  2 Aug 2016 16:51:04 +0200
Message-Id: <20160802145107.24829-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The height used for V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM where wrong.
The frames only contain one filed so the height should be half of the
frame.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 33435d7..c31ac73 100644
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
@@ -221,21 +223,13 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
@@ -245,6 +239,17 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
2.9.0

