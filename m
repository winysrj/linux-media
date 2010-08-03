Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51801 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: [PATCH 04/11] mt9m111: added new bit offset defines
Date: Tue,  3 Aug 2010 12:57:42 +0200
Message-Id: <1280833069-26993-5-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 8c076e5..1b21522 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -63,6 +63,12 @@
 #define MT9M111_RESET_RESTART_FRAME	(1 << 1)
 #define MT9M111_RESET_RESET_MODE	(1 << 0)
 
+#define MT9M111_RM_FULL_POWER_RD	(0 << 10)
+#define MT9M111_RM_LOW_POWER_RD		(1 << 10)
+#define MT9M111_RM_COL_SKIP_4X		(1 << 5)
+#define MT9M111_RM_ROW_SKIP_4X		(1 << 4)
+#define MT9M111_RM_COL_SKIP_2X		(1 << 3)
+#define MT9M111_RM_ROW_SKIP_2X		(1 << 2)
 #define MT9M111_RMB_MIRROR_COLS		(1 << 1)
 #define MT9M111_RMB_MIRROR_ROWS		(1 << 0)
 #define MT9M111_CTXT_CTRL_RESTART	(1 << 15)
-- 
1.7.1

