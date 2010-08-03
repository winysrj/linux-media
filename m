Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51795 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: [PATCH 05/11] mt9m111: changed MIN_DARK_COLS to MT9M131 spec count
Date: Tue,  3 Aug 2010 12:57:43 +0200
Message-Id: <1280833069-26993-6-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 1b21522..944e0cb 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -130,7 +130,7 @@
 #define reg_clear(reg, val) mt9m111_reg_clear(client, MT9M111_##reg, (val))
 
 #define MT9M111_MIN_DARK_ROWS	8
-#define MT9M111_MIN_DARK_COLS	24
+#define MT9M111_MIN_DARK_COLS	26
 #define MT9M111_MAX_HEIGHT	1024
 #define MT9M111_MAX_WIDTH	1280
 
-- 
1.7.1

