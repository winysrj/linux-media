Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42385 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdFODbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/15] af9013: remove unneeded register writes
Date: Thu, 15 Jun 2017 06:31:02 +0300
Message-Id: <20170615033105.13517-12-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed register writes are already chip defaults, are not required,
are set later or belong to AF9015 USB interface.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 42 ------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 6b86437..63c532a 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -894,11 +894,6 @@ static int af9013_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* enable ADC */
-	ret = regmap_write(state->regmap, 0xd73a, 0xa4);
-	if (ret)
-		goto err;
-
 	/* write API version to firmware */
 	ret = regmap_bulk_write(state->regmap, 0x9bf2, state->api_version, 4);
 	if (ret)
@@ -935,43 +930,6 @@ static int af9013_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* set I2C master clock */
-	ret = regmap_write(state->regmap, 0xd416, 0x14);
-	if (ret)
-		goto err;
-
-	/* set 16 embx */
-	ret = regmap_update_bits(state->regmap, 0xd700, 0x02, 0x02);
-	if (ret)
-		goto err;
-
-	/* set no trigger */
-	ret = regmap_update_bits(state->regmap, 0xd700, 0x04, 0x00);
-	if (ret)
-		goto err;
-
-	/* set read-update bit for constellation */
-	ret = regmap_update_bits(state->regmap, 0xd371, 0x02, 0x02);
-	if (ret)
-		goto err;
-
-	/* settings for mp2if */
-	if (state->ts_mode == AF9013_TS_MODE_USB) {
-		/* AF9015 split PSB to 1.5k + 0.5k */
-		ret = regmap_update_bits(state->regmap, 0xd50b, 0x04, 0x04);
-		if (ret)
-			goto err;
-	} else {
-		/* AF9013 set mpeg to full speed */
-		ret = regmap_update_bits(state->regmap, 0xd502, 0x10, 0x10);
-		if (ret)
-			goto err;
-	}
-
-	ret = regmap_update_bits(state->regmap, 0xd520, 0x10, 0x10);
-	if (ret)
-		goto err;
-
 	/* load OFSM settings */
 	dev_dbg(&client->dev, "load ofsm settings\n");
 	len = ARRAY_SIZE(ofsm_init);
-- 
http://palosaari.fi/
