Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35875 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaEWHsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 03:48:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] mt9v032: fix hblank calculation
Date: Fri, 23 May 2014 09:47:57 +0200
Message-Id: <1400831277-2108-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since (min_row_time - crop->width) can be negative, we have to do a signed
comparison here. Otherwise max_t casts the negative value to unsigned int
and sets min_hblank to that invalid value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/mt9v032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 40172b8..4d7afad 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -305,7 +305,7 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
 
 	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
 		min_hblank += (mt9v032->hratio - 1) * 10;
-	min_hblank = max_t(unsigned int, (int)mt9v032->model->data->min_row_time - crop->width,
+	min_hblank = max_t(int, (int)mt9v032->model->data->min_row_time - crop->width,
 			   (int)min_hblank);
 	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
 
-- 
2.0.0.rc0

