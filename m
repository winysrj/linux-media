Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51764 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 14/20] mt9m111: added reg_mask function
Date: Fri, 30 Jul 2010 16:53:32 +0200
Message-Id: <1280501618-23634-15-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

reg_mask is basically the same as clearing & setting registers,
but it is more convenient and faster (saves one rw cycle).

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 4dbaf31..161c751 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -128,6 +128,8 @@
 #define reg_write(reg, val) mt9m111_reg_write(client, MT9M111_##reg, (val))
 #define reg_set(reg, val) mt9m111_reg_set(client, MT9M111_##reg, (val))
 #define reg_clear(reg, val) mt9m111_reg_clear(client, MT9M111_##reg, (val))
+#define reg_mask(reg, val, mask) mt9m111_reg_mask(client, MT9M111_##reg, \
+		(val), (mask))
 
 #define MT9M111_MIN_DARK_ROWS	8
 #define MT9M111_MIN_DARK_COLS	26
@@ -265,6 +267,15 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 	return mt9m111_reg_write(client, reg, ret & ~data);
 }
 
+static int mt9m111_reg_mask(struct i2c_client *client, const u16 reg,
+			    const u16 data, const u16 mask)
+{
+	int ret;
+
+	ret = mt9m111_reg_read(client, reg);
+	return mt9m111_reg_write(client, reg, (ret & ~mask) | data);
+}
+
 static int mt9m111_set_context(struct i2c_client *client,
 			       enum mt9m111_context ctxt)
 {
-- 
1.7.1

