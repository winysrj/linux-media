Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37475 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605AbaLWUu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/66] rtl2830: fix logging
Date: Tue, 23 Dec 2014 22:49:03 +0200
Message-Id: <1419367799-14263-10-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass correct device for dev_foo() logging in order to print logs
correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 43 +++++++++++++++++------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index e7ba665..fa73575 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -46,9 +46,8 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&dev->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
@@ -59,8 +58,8 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -89,8 +88,8 @@ static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -259,7 +258,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -314,9 +313,8 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		{0xae, 0xba, 0xf3, 0x26, 0x66, 0x64}, /* 8 MHz */
 	};
 
-	dev_dbg(&dev->i2c->dev,
-			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
-			__func__, c->frequency, c->bandwidth_hz, c->inversion);
+	dev_dbg(&client->dev, "frequency=%u bandwidth_hz=%u inversion=%u\n",
+			c->frequency, c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -333,7 +331,8 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		i = 2;
 		break;
 	default:
-		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth\n", __func__);
+		dev_err(&client->dev, "invalid bandwidth_hz %u\n",
+				c->bandwidth_hz);
 		return -EINVAL;
 	}
 
@@ -355,8 +354,8 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	num = div_u64(num, dev->cfg.xtal);
 	num = -num;
 	if_ctl = num & 0x3fffff;
-	dev_dbg(&dev->i2c->dev, "%s: if_frequency=%d if_ctl=%08x\n",
-			__func__, if_frequency, if_ctl);
+	dev_dbg(&client->dev, "if_frequency=%d if_ctl=%08x\n",
+			if_frequency, if_ctl);
 
 	ret = rtl2830_rd_reg_mask(client, 0x119, &tmp, 0xc0); /* b[7:6] */
 	if (ret)
@@ -387,7 +386,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -410,7 +409,7 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
+	dev_dbg(&client->dev, "TPS=%*ph\n", 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -500,7 +499,7 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -529,7 +528,7 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -579,7 +578,7 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -601,7 +600,7 @@ static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -638,7 +637,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -728,7 +727,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	return 0;
 
 err:
-	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/

