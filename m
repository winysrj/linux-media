Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:62278 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaBGILZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 03:11:25 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 3/3] [media] ths8200: Format adjustment.
Date: Fri,  7 Feb 2014 09:11:05 +0100
Message-Id: <1391760665-24784-4-git-send-email-marbugge@cisco.com>
In-Reply-To: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
References: <1391760665-24784-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Closer inspection on excact transmitted format showed that
we needed to add 1 on vertical sync.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/ths8200.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index bcacf52..f72561e 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -318,15 +318,15 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
 			     (htotal(bt) >> 8) & 0x1f);
 	ths8200_write(sd, THS8200_DTG2_HLENGTH_HDLY_LSB, htotal(bt));
 
-	/* v sync width transmitted */
-	ths8200_write(sd, THS8200_DTG2_VLENGTH1_LSB, (bt->vsync) & 0xff);
+	/* v sync width transmitted (must add 1 to get correct output) */
+	ths8200_write(sd, THS8200_DTG2_VLENGTH1_LSB, (bt->vsync + 1) & 0xff);
 	ths8200_write_and_or(sd, THS8200_DTG2_VLENGTH1_MSB_VDLY1_MSB, 0x3f,
-			     ((bt->vsync) >> 2) & 0xc0);
+			     ((bt->vsync + 1) >> 2) & 0xc0);
 
-	/* The pixel value v sync is asserted on */
+	/* The pixel value v sync is asserted on (must add 1 to get correct output) */
 	ths8200_write_and_or(sd, THS8200_DTG2_VLENGTH1_MSB_VDLY1_MSB, 0xf8,
-			     (vtotal(bt)>>8) & 0x7);
-	ths8200_write(sd, THS8200_DTG2_VDLY1_LSB, vtotal(bt));
+			     ((vtotal(bt) + 1) >> 8) & 0x7);
+	ths8200_write(sd, THS8200_DTG2_VDLY1_LSB, vtotal(bt) + 1);
 
 	/* For progressive video vlength2 must be set to all 0 and vdly2 must
 	 * be set to all 1.
@@ -336,11 +336,11 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
 	ths8200_write(sd, THS8200_DTG2_VDLY2_LSB, 0xff);
 
 	/* Internal delay factors to synchronize the sync pulses and the data */
-	/* Experimental values delays (hor 4, ver 1) */
-	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_MSB, (htotal(bt)>>8) & 0x1f);
-	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_LSB, (htotal(bt) - 4) & 0xff);
+	/* Experimental values delays (hor 0, ver 0) */
+	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_MSB, 0);
+	ths8200_write(sd, THS8200_DTG2_HS_IN_DLY_LSB, 0);
 	ths8200_write(sd, THS8200_DTG2_VS_IN_DLY_MSB, 0);
-	ths8200_write(sd, THS8200_DTG2_VS_IN_DLY_LSB, 1);
+	ths8200_write(sd, THS8200_DTG2_VS_IN_DLY_LSB, 0);
 
 	/* Polarity of received and transmitted sync signals */
 	if (bt->polarities & V4L2_DV_HSYNC_POS_POL) {
-- 
1.8.1.4

