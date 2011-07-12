Return-path: <mchehab@localhost>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1GLPjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 11:39:08 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 3/5] mt9m111: move lastpage to struct mt9m111 for multi instances
Date: Tue, 12 Jul 2011 17:39:04 +0200
Message-Id: <1310485146-27759-3-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index e08b46c..8ad99a9 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -170,6 +170,7 @@ struct mt9m111 {
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
 	const struct mt9m111_datafmt *fmt;
+	int lastpage;
 	unsigned int gain;
 	unsigned char autoexposure;
 	unsigned char datawidth;
@@ -192,17 +193,17 @@ static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 {
 	int ret = 0;
 	u16 page;
-	static int lastpage = -1;	/* PageMap cache value */
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	page = (reg >> 8);
-	if (page == lastpage)
+	if (page == mt9m111->lastpage)
 		return 0;
 	if (page > 2)
 		return -EINVAL;
 
 	ret = i2c_smbus_write_word_data(client, MT9M111_PAGE_MAP, swab16(page));
 	if (!ret)
-		lastpage = page;
+		mt9m111->lastpage = page;
 	return ret;
 }
 
-- 
1.7.5.4

