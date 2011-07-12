Return-path: <mchehab@localhost>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1GLPjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 11:39:07 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 2/5] mt9m111: fix missing return value check mt9m111_reg_clear
Date: Tue, 12 Jul 2011 17:39:03 +0200
Message-Id: <1310485146-27759-2-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index f10dcf0..e08b46c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -248,7 +248,9 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 	int ret = 0;
 
 	ret = mt9m111_reg_read(client, reg);
-	return mt9m111_reg_write(client, reg, ret & ~data);
+	if (ret >= 0)
+		ret = mt9m111_reg_write(client, reg, ret & ~data);
+	return ret;
 }
 
 static int mt9m111_set_context(struct i2c_client *client,
-- 
1.7.5.4

