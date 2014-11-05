Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49270 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaKEO7J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 09:59:09 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so949977pab.0
        for <linux-media@vger.kernel.org>; Wed, 05 Nov 2014 06:59:09 -0800 (PST)
Date: Wed, 5 Nov 2014 22:59:07 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 3/3] m88ds3103: change ts clock config for serial mode
Message-ID: <201411052259039219070@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1> When m88ds3103 works in serial ts mode, its serial ts clock is equal to ts master clock and the clock divider is bypassed.
2> The serial ts clock is configed by the bridge driver just like parallel ts clock.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/dvb-frontends/m88ds3103.c | 55 +++++++++++++++------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 621d20f..0cd445c 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -245,9 +245,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len;
 	const struct m88ds3103_reg_val *init;
-	u8 u8tmp, u8tmp1, u8tmp2;
+	u8 u8tmp, u8tmp1 = 0, u8tmp2 = 0; /* silence compiler warning */
 	u8 buf[3];
-	u16 u16tmp, divide_ratio;
+	u16 u16tmp, divide_ratio = 0;
 	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
 
@@ -319,32 +319,29 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	/* set M88DS3103 mclk and ts mclk. */
 		priv->mclk_khz = 96000;
 
-		if (c->delivery_system == SYS_DVBS)
-			target_mclk = 96000;
-		else {
-			switch (priv->cfg->ts_mode) {
-			case M88DS3103_TS_SERIAL:
-			case M88DS3103_TS_SERIAL_D7:
-				if (c->symbol_rate < 18000000)
-					target_mclk = 96000;
-				else
-					target_mclk = 144000;
-				break;
-			case M88DS3103_TS_PARALLEL:
-			case M88DS3103_TS_CI:
+		switch (priv->cfg->ts_mode) {
+		case M88DS3103_TS_SERIAL:
+		case M88DS3103_TS_SERIAL_D7:
+			target_mclk = priv->cfg->ts_clk;
+			break;
+		case M88DS3103_TS_PARALLEL:
+		case M88DS3103_TS_CI:
+			if (c->delivery_system == SYS_DVBS)
+				target_mclk = 96000;
+			else {
 				if (c->symbol_rate < 18000000)
 					target_mclk = 96000;
 				else if (c->symbol_rate < 28000000)
 					target_mclk = 144000;
 				else
 					target_mclk = 192000;
-				break;
-			default:
-				dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
-						__func__);
-				ret = -EINVAL;
-				goto err;
 			}
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev, "%s: invalid ts_mode\n",
+					__func__);
+			ret = -EINVAL;
+			goto err;
 		}
 
 		switch (target_mclk) {
@@ -434,7 +431,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	u8tmp1 = 0; /* silence compiler warning */
 	switch (priv->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 		u8tmp1 = 0x00;
@@ -470,16 +466,15 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		ret = m88ds3103_wr_reg_mask(priv, 0x29, u8tmp1, 0x20);
 		if (ret)
 			goto err;
-	}
-
-	if (priv->cfg->ts_clk) {
-		divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
-		u8tmp1 = divide_ratio / 2;
-		u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
-	} else {
-		divide_ratio = 0;
 		u8tmp1 = 0;
 		u8tmp2 = 0;
+		break;
+	default:
+		if (priv->cfg->ts_clk) {
+			divide_ratio = DIV_ROUND_UP(target_mclk, priv->cfg->ts_clk);
+			u8tmp1 = divide_ratio / 2;
+			u8tmp2 = DIV_ROUND_UP(divide_ratio, 2);
+		}
 	}
 
 	dev_dbg(&priv->i2c->dev,

-- 
1.9.1

