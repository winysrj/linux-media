Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43685 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1GOUSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 16:18:30 -0400
Received: from localhost.localdomain (unknown [91.178.94.100])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4C705359A4
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2011 20:18:29 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: mt9v032: Fix Bayer pattern
Date: Fri, 15 Jul 2011 22:18:26 +0200
Message-Id: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9v032.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

If there's no comment I'll send a pull request for this patch in a couple of
days.

diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index 1319c2c..c64e1dc 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -31,14 +31,14 @@
 #define MT9V032_CHIP_VERSION				0x00
 #define		MT9V032_CHIP_ID_REV1			0x1311
 #define		MT9V032_CHIP_ID_REV3			0x1313
-#define MT9V032_ROW_START				0x01
-#define		MT9V032_ROW_START_MIN			4
-#define		MT9V032_ROW_START_DEF			10
-#define		MT9V032_ROW_START_MAX			482
-#define MT9V032_COLUMN_START				0x02
+#define MT9V032_COLUMN_START				0x01
 #define		MT9V032_COLUMN_START_MIN		1
-#define		MT9V032_COLUMN_START_DEF		2
+#define		MT9V032_COLUMN_START_DEF		1
 #define		MT9V032_COLUMN_START_MAX		752
+#define MT9V032_ROW_START				0x02
+#define		MT9V032_ROW_START_MIN			4
+#define		MT9V032_ROW_START_DEF			5
+#define		MT9V032_ROW_START_MAX			482
 #define MT9V032_WINDOW_HEIGHT				0x03
 #define		MT9V032_WINDOW_HEIGHT_MIN		1
 #define		MT9V032_WINDOW_HEIGHT_DEF		480
@@ -420,13 +420,13 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 	struct v4l2_rect *__crop;
 	struct v4l2_rect rect;
 
-	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
-	 * pixels.
+	/* Clamp the crop rectangle boundaries and align them to a non multiple
+	 * of 2 pixels to ensure a GRBG Bayer pattern.
 	 */
-	rect.left = clamp(ALIGN(crop->rect.left, 2),
+	rect.left = clamp(ALIGN(crop->rect.left + 1, 2) - 1,
 			  MT9V032_COLUMN_START_MIN,
 			  MT9V032_COLUMN_START_MAX);
-	rect.top = clamp(ALIGN(crop->rect.top, 2),
+	rect.top = clamp(ALIGN(crop->rect.top + 1, 2) - 1,
 			 MT9V032_ROW_START_MIN,
 			 MT9V032_ROW_START_MAX);
 	rect.width = clamp(ALIGN(crop->rect.width, 2),
-- 
Regards,

Laurent Pinchart

