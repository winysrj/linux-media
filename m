Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51800 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: [PATCH 02/11] mt9m111: init chip after read CHIP_VERSION
Date: Tue,  3 Aug 2010 12:57:40 +0200
Message-Id: <1280833069-26993-3-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moved mt9m111_init after the chip version detection passage: I
don't like the idea of writing on a device we haven't identified
yet.

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 68f3df6..e7618da 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -969,10 +969,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	mt9m111->swap_rgb_even_odd = 1;
 	mt9m111->swap_rgb_red_blue = 1;
 
-	ret = mt9m111_init(client);
-	if (ret)
-		goto ei2c;
-
 	data = reg_read(CHIP_VERSION);
 
 	switch (data) {
@@ -993,6 +989,8 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
+	ret = mt9m111_init(client);
+
 ei2c:
 	return ret;
 }
-- 
1.7.1

