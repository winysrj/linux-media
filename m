Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 06/20] mt9m111: changed MAX_{HEIGHT,WIDTH} values to silicon pixelcount
Date: Fri, 30 Jul 2010 16:53:24 +0200
Message-Id: <1280501618-23634-7-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 5f0c55e..2080615 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -131,8 +131,8 @@
 
 #define MT9M111_MIN_DARK_ROWS	8
 #define MT9M111_MIN_DARK_COLS	24
-#define MT9M111_MAX_HEIGHT	1024
-#define MT9M111_MAX_WIDTH	1280
+#define MT9M111_MAX_HEIGHT	1032
+#define MT9M111_MAX_WIDTH	1288
 #define MT9M111_DEF_DARK_ROWS	12
 #define MT9M111_DEF_DARK_COLS	30
 #define MT9M111_DEF_HEIGHT	1024
-- 
1.7.1

