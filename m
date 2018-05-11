Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:59793 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbeEKJ7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 05:59:53 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4/5] media: rcar-vin: Do not use crop if not configured
Date: Fri, 11 May 2018 11:59:40 +0200
Message-Id: <1526032781-14319-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The crop_scale routine uses the crop rectangle memebers to configure the
VIN clipping rectangle. When crop is not configured all its fields are
0s, and setting the clipping rectangle vertical and horizontal extensions
to (0 - 1) causes the registers to be written with an incorrect
0xffffffff value.

Fix this by using the actual format width and height when no crop
rectangle has been programmed.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index b41ba9a..ea7a120 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -579,22 +579,25 @@ static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
 
 void rvin_crop_scale_comp(struct rvin_dev *vin)
 {
-	/* Set Start/End Pixel/Line Pre-Clip */
+	u32 width = vin->crop.width ? vin->crop.left + vin->crop.width :
+				      vin->format.width;
+	u32 height = vin->crop.height ? vin->crop.top + vin->crop.height :
+					vin->format.height;
+
+	/* Set Start/End Pixel/Line Pre-Clip if crop is configured. */
 	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
-	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
+	rvin_write(vin, width - 1, VNEPPRC_REG);
 
 	switch (vin->format.field) {
 	case V4L2_FIELD_INTERLACED:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
 		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
-		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
-			   VNELPRC_REG);
+		rvin_write(vin, height / 2 - 1, VNELPRC_REG);
 		break;
 	default:
 		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
-		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
-			   VNELPRC_REG);
+		rvin_write(vin, height - 1, VNELPRC_REG);
 		break;
 	}
 
-- 
2.7.4
