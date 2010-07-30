Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 03/20] mt9m111: register cleanup hex to dec bitoffset
Date: Fri, 30 Jul 2010 16:53:21 +0200
Message-Id: <1280501618-23634-4-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 39dff7c..c72c4b0 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -100,14 +100,14 @@
 #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
 #define MT9M111_OUTFMT_INV_PIX_CLOCK	(1 << 9)
 #define MT9M111_OUTFMT_RGB		(1 << 8)
-#define MT9M111_OUTFMT_RGB565		(0x0 << 6)
-#define MT9M111_OUTFMT_RGB555		(0x1 << 6)
-#define MT9M111_OUTFMT_RGB444x		(0x2 << 6)
-#define MT9M111_OUTFMT_RGBx444		(0x3 << 6)
-#define MT9M111_OUTFMT_TST_RAMP_OFF	(0x0 << 4)
-#define MT9M111_OUTFMT_TST_RAMP_COL	(0x1 << 4)
-#define MT9M111_OUTFMT_TST_RAMP_ROW	(0x2 << 4)
-#define MT9M111_OUTFMT_TST_RAMP_FRAME	(0x3 << 4)
+#define MT9M111_OUTFMT_RGB565		(0 << 6)
+#define MT9M111_OUTFMT_RGB555		(1 << 6)
+#define MT9M111_OUTFMT_RGB444x		(2 << 6)
+#define MT9M111_OUTFMT_RGBx444		(3 << 6)
+#define MT9M111_OUTFMT_TST_RAMP_OFF	(0 << 4)
+#define MT9M111_OUTFMT_TST_RAMP_COL	(1 << 4)
+#define MT9M111_OUTFMT_TST_RAMP_ROW	(2 << 4)
+#define MT9M111_OUTFMT_TST_RAMP_FRAME	(3 << 4)
 #define MT9M111_OUTFMT_SHIFT_3_UP	(1 << 3)
 #define MT9M111_OUTFMT_AVG_CHROMA	(1 << 2)
 #define MT9M111_OUTFMT_SWAP_YCbCr_C_Y	(1 << 1)
-- 
1.7.1

