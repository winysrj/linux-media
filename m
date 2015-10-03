Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36500 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbbJCWaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2015 18:30:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mark Clarkstone <hello@markclarkstone.co.uk>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] m88ds3103: use own reg update_bits() implementation
Date: Sun,  4 Oct 2015 01:29:30 +0300
Message-Id: <1443911370-8195-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device stopped to tuning some channels after regmap conversion.
Reason is that regmap_update_bits() works a bit differently for
partially volatile registers than old homemade routine. Return
back to old routine in order to fix issue.

Fixes: 478932b16052f5ded74685d096ae920cd17d6424
Cc: <stable@kernel.org> # 4.2+
Reported-by: Mark Clarkstone <hello@markclarkstone.co.uk>
Tested-by: Mark Clarkstone <hello@markclarkstone.co.uk>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 73 +++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index ff31e7a..feeeb70 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -18,6 +18,27 @@
 
 static struct dvb_frontend_ops m88ds3103_ops;
 
+/* write single register with mask */
+static int m88ds3103_update_bits(struct m88ds3103_dev *dev,
+				u8 reg, u8 mask, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	/* no need for read if whole reg is written */
+	if (mask != 0xff) {
+		ret = regmap_bulk_read(dev->regmap, reg, &tmp, 1);
+		if (ret)
+			return ret;
+
+		val &= mask;
+		tmp &= ~mask;
+		val |= tmp;
+	}
+
+	return regmap_bulk_write(dev->regmap, reg, &val, 1);
+}
+
 /* write reg val table using reg addr auto increment */
 static int m88ds3103_wr_reg_val_tab(struct m88ds3103_dev *dev,
 		const struct m88ds3103_reg_val *tab, int tab_len)
@@ -394,10 +415,10 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			u8tmp2 = 0x00; /* 0b00 */
 			break;
 		}
-		ret = regmap_update_bits(dev->regmap, 0x22, 0xc0, u8tmp1 << 6);
+		ret = m88ds3103_update_bits(dev, 0x22, 0xc0, u8tmp1 << 6);
 		if (ret)
 			goto err;
-		ret = regmap_update_bits(dev->regmap, 0x24, 0xc0, u8tmp2 << 6);
+		ret = m88ds3103_update_bits(dev, 0x24, 0xc0, u8tmp2 << 6);
 		if (ret)
 			goto err;
 	}
@@ -455,13 +476,13 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			if (ret)
 				goto err;
 		}
-		ret = regmap_update_bits(dev->regmap, 0x9d, 0x08, 0x08);
+		ret = m88ds3103_update_bits(dev, 0x9d, 0x08, 0x08);
 		if (ret)
 			goto err;
 		ret = regmap_write(dev->regmap, 0xf1, 0x01);
 		if (ret)
 			goto err;
-		ret = regmap_update_bits(dev->regmap, 0x30, 0x80, 0x80);
+		ret = m88ds3103_update_bits(dev, 0x30, 0x80, 0x80);
 		if (ret)
 			goto err;
 	}
@@ -498,7 +519,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	switch (dev->cfg->ts_mode) {
 	case M88DS3103_TS_SERIAL:
 	case M88DS3103_TS_SERIAL_D7:
-		ret = regmap_update_bits(dev->regmap, 0x29, 0x20, u8tmp1);
+		ret = m88ds3103_update_bits(dev, 0x29, 0x20, u8tmp1);
 		if (ret)
 			goto err;
 		u8tmp1 = 0;
@@ -567,11 +588,11 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = regmap_update_bits(dev->regmap, 0x4d, 0x02, dev->cfg->spec_inv << 1);
+	ret = m88ds3103_update_bits(dev, 0x4d, 0x02, dev->cfg->spec_inv << 1);
 	if (ret)
 		goto err;
 
-	ret = regmap_update_bits(dev->regmap, 0x30, 0x10, dev->cfg->agc_inv << 4);
+	ret = m88ds3103_update_bits(dev, 0x30, 0x10, dev->cfg->agc_inv << 4);
 	if (ret)
 		goto err;
 
@@ -625,13 +646,13 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev->warm = false;
 
 	/* wake up device from sleep */
-	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x01);
+	ret = m88ds3103_update_bits(dev, 0x08, 0x01, 0x01);
 	if (ret)
 		goto err;
-	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x00);
+	ret = m88ds3103_update_bits(dev, 0x04, 0x01, 0x00);
 	if (ret)
 		goto err;
-	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x00);
+	ret = m88ds3103_update_bits(dev, 0x23, 0x10, 0x00);
 	if (ret)
 		goto err;
 
@@ -749,18 +770,18 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 		utmp = 0x29;
 	else
 		utmp = 0x27;
-	ret = regmap_update_bits(dev->regmap, utmp, 0x01, 0x00);
+	ret = m88ds3103_update_bits(dev, utmp, 0x01, 0x00);
 	if (ret)
 		goto err;
 
 	/* sleep */
-	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x00);
+	ret = m88ds3103_update_bits(dev, 0x08, 0x01, 0x00);
 	if (ret)
 		goto err;
-	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x01);
+	ret = m88ds3103_update_bits(dev, 0x04, 0x01, 0x01);
 	if (ret)
 		goto err;
-	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x10);
+	ret = m88ds3103_update_bits(dev, 0x23, 0x10, 0x10);
 	if (ret)
 		goto err;
 
@@ -992,12 +1013,12 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	}
 
 	utmp = tone << 7 | dev->cfg->envelope_mode << 5;
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
 	utmp = 1 << 2;
-	ret = regmap_update_bits(dev->regmap, 0xa1, reg_a1_mask, utmp);
+	ret = m88ds3103_update_bits(dev, 0xa1, reg_a1_mask, utmp);
 	if (ret)
 		goto err;
 
@@ -1047,7 +1068,7 @@ static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 	voltage_dis ^= dev->cfg->lnb_en_pol;
 
 	utmp = voltage_dis << 1 | voltage_sel << 0;
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0x03, utmp);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0x03, utmp);
 	if (ret)
 		goto err;
 
@@ -1080,7 +1101,7 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	}
 
 	utmp = dev->cfg->envelope_mode << 5;
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
@@ -1115,12 +1136,12 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	} else {
 		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = regmap_update_bits(dev->regmap, 0xa1, 0xc0, 0x40);
+		ret = m88ds3103_update_bits(dev, 0xa1, 0xc0, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0xc0, 0x80);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0xc0, 0x80);
 	if (ret)
 		goto err;
 
@@ -1152,7 +1173,7 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	}
 
 	utmp = dev->cfg->envelope_mode << 5;
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0xe0, utmp);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0xe0, utmp);
 	if (ret)
 		goto err;
 
@@ -1194,12 +1215,12 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	} else {
 		dev_dbg(&client->dev, "diseqc tx timeout\n");
 
-		ret = regmap_update_bits(dev->regmap, 0xa1, 0xc0, 0x40);
+		ret = m88ds3103_update_bits(dev, 0xa1, 0xc0, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	ret = regmap_update_bits(dev->regmap, 0xa2, 0xc0, 0x80);
+	ret = m88ds3103_update_bits(dev, 0xa2, 0xc0, 0x80);
 	if (ret)
 		goto err;
 
@@ -1435,13 +1456,13 @@ static int m88ds3103_probe(struct i2c_client *client,
 		goto err_kfree;
 
 	/* sleep */
-	ret = regmap_update_bits(dev->regmap, 0x08, 0x01, 0x00);
+	ret = m88ds3103_update_bits(dev, 0x08, 0x01, 0x00);
 	if (ret)
 		goto err_kfree;
-	ret = regmap_update_bits(dev->regmap, 0x04, 0x01, 0x01);
+	ret = m88ds3103_update_bits(dev, 0x04, 0x01, 0x01);
 	if (ret)
 		goto err_kfree;
-	ret = regmap_update_bits(dev->regmap, 0x23, 0x10, 0x10);
+	ret = m88ds3103_update_bits(dev, 0x23, 0x10, 0x10);
 	if (ret)
 		goto err_kfree;
 
-- 
http://palosaari.fi/

