Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56990 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbERFJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/8] m88ds3103: wrap legacy DVBv3 BER to DVBv5 BER
Date: Mon, 18 May 2015 08:08:48 +0300
Message-Id: <1431925731-7499-5-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use DVBv5 BER logic to calculate DVBv3 BER too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 77 ++--------------------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |  2 +-
 2 files changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 3cf89b6..33d8c19 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -329,6 +329,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				post_bit_count = 0x800000;
 				priv->post_bit_error += post_bit_error;
 				priv->post_bit_count += post_bit_count;
+				priv->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
 				u8tmp |= 0x10;
@@ -354,6 +355,7 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				post_bit_count = 32 * utmp; /* TODO: FEC */
 				priv->post_bit_error += post_bit_error;
 				priv->post_bit_count += post_bit_count;
+				priv->dvbv3_ber = post_bit_error;
 
 				/* restart measurement */
 				ret = m88ds3103_wr_reg(priv, 0xd1, 0x01);
@@ -1085,83 +1087,10 @@ static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	unsigned int utmp;
-	u8 buf[3], u8tmp;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-		ret = m88ds3103_wr_reg(priv, 0xf9, 0x04);
-		if (ret)
-			goto err;
 
-		ret = m88ds3103_rd_reg(priv, 0xf8, &u8tmp);
-		if (ret)
-			goto err;
-
-		if (!(u8tmp & 0x10)) {
-			u8tmp |= 0x10;
-
-			ret = m88ds3103_rd_regs(priv, 0xf6, buf, 2);
-			if (ret)
-				goto err;
-
-			priv->ber = (buf[1] << 8) | (buf[0] << 0);
-
-			/* restart counters */
-			ret = m88ds3103_wr_reg(priv, 0xf8, u8tmp);
-			if (ret)
-				goto err;
-		}
-		break;
-	case SYS_DVBS2:
-		ret = m88ds3103_rd_regs(priv, 0xd5, buf, 3);
-		if (ret)
-			goto err;
-
-		utmp = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
-
-		if (utmp > 3000) {
-			ret = m88ds3103_rd_regs(priv, 0xf7, buf, 2);
-			if (ret)
-				goto err;
-
-			priv->ber = (buf[1] << 8) | (buf[0] << 0);
-
-			/* restart counters */
-			ret = m88ds3103_wr_reg(priv, 0xd1, 0x01);
-			if (ret)
-				goto err;
-
-			ret = m88ds3103_wr_reg(priv, 0xf9, 0x01);
-			if (ret)
-				goto err;
-
-			ret = m88ds3103_wr_reg(priv, 0xf9, 0x00);
-			if (ret)
-				goto err;
-
-			ret = m88ds3103_wr_reg(priv, 0xd1, 0x00);
-			if (ret)
-				goto err;
-		}
-		break;
-	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	*ber = priv->ber;
+	*ber = priv->dvbv3_ber;
 
 	return 0;
-err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
 }
 
 static int m88ds3103_set_tone(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index aafa28c..78e58e3 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -38,7 +38,7 @@ struct m88ds3103_priv {
 	struct dvb_frontend fe;
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
-	u32 ber;
+	u32 dvbv3_ber; /* for old DVBv3 API read_ber */
 	bool warm; /* FW running */
 	struct i2c_adapter *i2c_adapter;
 	/* auto detect chip id to do different config */
-- 
http://palosaari.fi/

