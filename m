Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42978 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3IPVdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 17:33:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Andreas Matthies <a.matthies@gmx.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] tda10071: change firmware download condition
Date: Tue, 17 Sep 2013 00:32:05 +0300
Message-Id: <1379367125-19732-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andreas Matthies <a.matthies@gmx.net>

Reading firmware status register to detect whether firmware is
running or not didn't worked 100% reliably. That register was
likely set by firmware itself which means it could not contain
reasonable values until firmware is up and running. Usually it
just worked as some garbage value was returned accidentally but it
appears that in some cases returned garbage value was 0x00 which
was considered "firmware is up and running" by the driver and
firmware loading was skipped leaving device to non-working state.

Fix problem by removing unreliable check and let the driver keep
count whether firmware is loaded or not.

Signed-off-by: Andreas Matthies <a.matthies@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 2521f7e..e79749c 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -912,14 +912,8 @@ static int tda10071_init(struct dvb_frontend *fe)
 		{ 0xd5, 0x03, 0x03 },
 	};
 
-	/* firmware status */
-	ret = tda10071_rd_reg(priv, 0x51, &tmp);
-	if (ret)
-		goto error;
-
-	if (!tmp) {
+	if (priv->warm) {
 		/* warm state - wake up device from sleep */
-		priv->warm = 1;
 
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
 			ret = tda10071_wr_reg_mask(priv, tab[i].reg,
@@ -937,7 +931,6 @@ static int tda10071_init(struct dvb_frontend *fe)
 			goto error;
 	} else {
 		/* cold state - try to download firmware */
-		priv->warm = 0;
 
 		/* request the firmware, this will block and timeout */
 		ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
-- 
1.7.11.7

