Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:53300 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752565Ab0ATTBn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 14:01:43 -0500
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH] MT9T031: write xskip and yskip at each set_params call
Date: Wed, 20 Jan 2010 19:54:56 +0100
Message-Id: <1264013696-11315-1-git-send-email-valentin.longchamp@epfl.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prevents the registers to be different to the computed values
the second time you open the same camera with the sames parameters.

The images were different between the first device open and the
second one with the same parameters.

Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
---
 drivers/media/video/mt9t031.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index a9061bf..e4a9095 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
+
 /*
  * mt9t031 i2c address 0x5d
  * The platform has to define i2c_board_info and link to it from
@@ -337,15 +338,13 @@ static int mt9t031_set_params(struct i2c_client *client,
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_VERTICAL_BLANKING, vblank);
 
-	if (yskip != mt9t031->yskip || xskip != mt9t031->xskip) {
-		/* Binning, skipping */
-		if (ret >= 0)
-			ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
-					((xbin - 1) << 4) | (xskip - 1));
-		if (ret >= 0)
-			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
-					((ybin - 1) << 4) | (yskip - 1));
-	}
+	/* Binning, skipping */
+	if (ret >= 0)
+		ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
+				((xbin - 1) << 4) | (xskip - 1));
+	if (ret >= 0)
+		ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
+				((ybin - 1) << 4) | (yskip - 1));
 	dev_dbg(&client->dev, "new physical left %u, top %u\n",
 		rect->left, rect->top);
 
-- 
1.6.3.3

