Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2GWSfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:35:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 4/4] mt9p031: Fix horizontal and vertical blanking configuration
Date: Mon, 23 Jul 2012 20:35:02 +0200
Message-Id: <1343068502-7431-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the horizontal blanking value according to the datasheet. The
value written to the hblank and vblank registers must be equal to the
number of blank columns and rows minus one.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 3be537e..2c0f407 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -55,9 +55,9 @@
 #define		MT9P031_HORIZONTAL_BLANK_MIN		0
 #define		MT9P031_HORIZONTAL_BLANK_MAX		4095
 #define MT9P031_VERTICAL_BLANK				0x06
-#define		MT9P031_VERTICAL_BLANK_MIN		0
-#define		MT9P031_VERTICAL_BLANK_MAX		4095
-#define		MT9P031_VERTICAL_BLANK_DEF		25
+#define		MT9P031_VERTICAL_BLANK_MIN		1
+#define		MT9P031_VERTICAL_BLANK_MAX		4096
+#define		MT9P031_VERTICAL_BLANK_DEF		26
 #define MT9P031_OUTPUT_CONTROL				0x07
 #define		MT9P031_OUTPUT_CONTROL_CEN		2
 #define		MT9P031_OUTPUT_CONTROL_SYN		1
@@ -368,13 +368,13 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
 	/* Blanking - use minimum value for horizontal blanking and default
 	 * value for vertical blanking.
 	 */
-	hblank = 346 * ybin + 64 + (80 >> max_t(unsigned int, xbin, 3));
+	hblank = 346 * ybin + 64 + (80 >> min_t(unsigned int, xbin, 3));
 	vblank = MT9P031_VERTICAL_BLANK_DEF;
 
-	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank);
+	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank - 1);
 	if (ret < 0)
 		return ret;
-	ret = mt9p031_write(client, MT9P031_VERTICAL_BLANK, vblank);
+	ret = mt9p031_write(client, MT9P031_VERTICAL_BLANK, vblank - 1);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.8.6

