Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37616 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbdFODbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/15] af9013: refactor power control
Date: Thu, 15 Jun 2017 06:31:05 +0300
Message-Id: <20170615033105.13517-15-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move power-up and power-down functionality to init/sleep ops and
get rid of old function.

Fixes and simplifies power-up functionality slightly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 93 ++++++++++++++----------------------
 1 file changed, 36 insertions(+), 57 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 40fd2ea..128d915 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -101,59 +101,6 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	return ret;
 }
 
-static int af9013_power_ctrl(struct af9013_state *state, u8 onoff)
-{
-	struct i2c_client *client = state->client;
-	int ret;
-	unsigned int utmp;
-
-	dev_dbg(&client->dev, "onoff %d\n", onoff);
-
-	/* enable reset */
-	ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x10);
-	if (ret)
-		goto err;
-
-	/* start reset mechanism */
-	ret = regmap_write(state->regmap, 0xaeff, 0x01);
-	if (ret)
-		goto err;
-
-	/* wait reset performs */
-	ret = regmap_read_poll_timeout(state->regmap, 0xd417, utmp,
-				       (utmp >> 1) & 0x01, 5000, 1000000);
-	if (ret)
-		goto err;
-
-	if (!((utmp >> 1) & 0x01))
-		return -ETIMEDOUT;
-
-	if (onoff) {
-		/* clear reset */
-		ret = regmap_update_bits(state->regmap, 0xd417, 0x02, 0x00);
-		if (ret)
-			goto err;
-		/* disable reset */
-		ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x00);
-		if (ret)
-			goto err;
-		/* power on */
-		ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x00);
-		if (ret)
-			goto err;
-	} else {
-		/* power off */
-		ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x08);
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
 static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
@@ -889,8 +836,18 @@ static int af9013_init(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	/* power on */
-	ret = af9013_power_ctrl(state, 1);
+	/* ADC on */
+	ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x00);
+	if (ret)
+		goto err;
+
+	/* Clear reset */
+	ret = regmap_update_bits(state->regmap, 0xd417, 0x02, 0x00);
+	if (ret)
+		goto err;
+
+	/* Disable reset */
+	ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x00);
 	if (ret)
 		goto err;
 
@@ -1070,6 +1027,7 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret;
+	unsigned int utmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -1081,8 +1039,29 @@ static int af9013_sleep(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* power off */
-	ret = af9013_power_ctrl(state, 0);
+	/* Enable reset */
+	ret = regmap_update_bits(state->regmap, 0xd417, 0x10, 0x10);
+	if (ret)
+		goto err;
+
+	/* Start reset execution */
+	ret = regmap_write(state->regmap, 0xaeff, 0x01);
+	if (ret)
+		goto err;
+
+	/* Wait reset performs */
+	ret = regmap_read_poll_timeout(state->regmap, 0xd417, utmp,
+				       (utmp >> 1) & 0x01, 5000, 1000000);
+	if (ret)
+		goto err;
+
+	if (!((utmp >> 1) & 0x01)) {
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	/* ADC off */
+	ret = regmap_update_bits(state->regmap, 0xd73a, 0x08, 0x08);
 	if (ret)
 		goto err;
 
-- 
http://palosaari.fi/
