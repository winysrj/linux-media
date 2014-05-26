Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42719 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaEZNzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 09:55:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] mt9v032: fix hblank calculation
Date: Mon, 26 May 2014 15:55:51 +0200
Message-Id: <1401112551-21046-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since (min_row_time - crop->width) can be negative, we have to do a signed
comparison here. Otherwise max_t casts the negative value to unsigned int
and sets min_hblank to that invalid value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Remove now unneeded casts to (int).
---
 drivers/media/i2c/mt9v032.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 40172b8..f04d0bb 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -305,8 +305,8 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
 
 	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
 		min_hblank += (mt9v032->hratio - 1) * 10;
-	min_hblank = max_t(unsigned int, (int)mt9v032->model->data->min_row_time - crop->width,
-			   (int)min_hblank);
+	min_hblank = max_t(int, mt9v032->model->data->min_row_time - crop->width,
+			   min_hblank);
 	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
 
 	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);
-- 
2.0.0.rc2

