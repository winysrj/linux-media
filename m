Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43252 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcF2Xj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:39:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] m88ds3103: improve ts clock setting
Date: Thu, 30 Jun 2016 02:39:46 +0300
Message-Id: <1467243588-26204-3-git-send-email-crope@iki.fi>
In-Reply-To: <1467243588-26204-1-git-send-email-crope@iki.fi>
References: <1467243588-26204-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify TS clock divider calculation and programming slightly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 39 ++++++++++++++-------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 6f03ca8..fae9251 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -306,7 +306,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	const struct m88ds3103_reg_val *init;
 	u8 u8tmp, u8tmp1 = 0, u8tmp2 = 0; /* silence compiler warning */
 	u8 buf[3];
-	u16 u16tmp, divide_ratio = 0;
+	u16 u16tmp;
 	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
 
@@ -522,37 +522,25 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		ret = m88ds3103_update_bits(dev, 0x29, 0x20, u8tmp1);
 		if (ret)
 			goto err;
-		u8tmp1 = 0;
-		u8tmp2 = 0;
+		u16tmp = 0;
+		u8tmp1 = 0x3f;
+		u8tmp2 = 0x3f;
 		break;
 	default:
-		if (dev->cfg->ts_clk) {
-			divide_ratio = DIV_ROUND_UP(target_mclk, dev->cfg->ts_clk);
-			u8tmp1 = divide_ratio / 2;
-			u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
-		}
+		u16tmp = DIV_ROUND_UP(target_mclk, dev->cfg->ts_clk);
+		u8tmp1 = u16tmp / 2 - 1;
+		u8tmp2 = DIV_ROUND_UP(u16tmp, 2) - 1;
 	}
 
-	dev_dbg(&client->dev,
-		"target_mclk=%d ts_clk=%d divide_ratio=%d\n",
-		target_mclk, dev->cfg->ts_clk, divide_ratio);
+	dev_dbg(&client->dev, "target_mclk=%d ts_clk=%d ts_clk_divide_ratio=%u\n",
+		target_mclk, dev->cfg->ts_clk, u16tmp);
 
-	u8tmp1--;
-	u8tmp2--;
 	/* u8tmp1[5:2] => fe[3:0], u8tmp1[1:0] => ea[7:6] */
-	u8tmp1 &= 0x3f;
 	/* u8tmp2[5:0] => ea[5:0] */
-	u8tmp2 &= 0x3f;
-
-	ret = regmap_bulk_read(dev->regmap, 0xfe, &u8tmp, 1);
-	if (ret)
-		goto err;
-
-	u8tmp = ((u8tmp  & 0xf0) << 0) | u8tmp1 >> 2;
-	ret = regmap_write(dev->regmap, 0xfe, u8tmp);
+	u8tmp = (u8tmp1 >> 2) & 0x0f;
+	ret = regmap_update_bits(dev->regmap, 0xfe, 0x0f, u8tmp);
 	if (ret)
 		goto err;
-
 	u8tmp = ((u8tmp1 & 0x03) << 6) | u8tmp2 >> 0;
 	ret = regmap_write(dev->regmap, 0xea, u8tmp);
 	if (ret)
@@ -1444,6 +1432,11 @@ static int m88ds3103_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
+	if (!pdata->ts_clk) {
+		ret = -EINVAL;
+		goto err_kfree;
+	}
+
 	/* 0x29 register is defined differently for m88rs6000. */
 	/* set internal tuner address to 0x21 */
 	if (dev->chip_id == M88RS6000_CHIP_ID)
-- 
http://palosaari.fi/

