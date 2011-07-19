Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50944 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1GSN1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:27:09 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH v2] mt9m111: move lastpage to struct mt9m111 for multi instances
Date: Tue, 19 Jul 2011 15:26:35 +0200
Message-Id: <1311081995-25409-1-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1310485146-27759-3-git-send-email-m.grzeschik@pengutronix.de>
References: <1310485146-27759-3-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
v1 -> v2: added initial value -1 for lastpage

 drivers/media/video/mt9m111.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index a357aa8..07af26e 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -184,6 +184,7 @@ struct mt9m111 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
+	int lastpage;	/* PageMap cache value */
 	unsigned int gain;
 	unsigned char autoexposure;
 	unsigned char datawidth;
@@ -202,17 +203,17 @@ static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 {
 	int ret;
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
 
@@ -932,6 +933,8 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	BUG_ON(!icd->parent ||
 	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
+	mt9m111->lastpage = -1;
+
 	mt9m111->autoexposure = 1;
 	mt9m111->autowhitebalance = 1;
 
-- 
1.7.5.4

