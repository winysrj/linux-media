Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49192 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934138AbaKLELh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/11] mn88472: implement DVB-T and DVB-T2
Date: Wed, 12 Nov 2014 06:11:14 +0200
Message-Id: <1415765477-23153-9-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement initial support for DVB-T and DVB-T2 modes. Now driver has
basic support for all the modes, DVB-C/T/T2.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c | 176 ++++++++++++++++++++++++++--------
 1 file changed, 135 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index c680154..52de8f8 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -28,8 +28,9 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
+	int ret, i;
 	u32 if_frequency = 0;
+	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
 
 	dev_dbg(&client->dev,
 			"delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
@@ -41,6 +42,55 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		delivery_system_val = 0x02;
+		break;
+	case SYS_DVBT2:
+		delivery_system_val = 0x03;
+		break;
+	case SYS_DVBC_ANNEX_A:
+		delivery_system_val = 0x04;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		if (c->bandwidth_hz <= 6000000) {
+			/* IF 3570000 Hz, BW 6000000 Hz */
+			memcpy(if_val, "\x2c\x94\xdb", 3);
+			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
+			bw_val2 = 0x02;
+		} else if (c->bandwidth_hz <= 7000000) {
+			/* IF 4570000 Hz, BW 7000000 Hz */
+			memcpy(if_val, "\x39\x11\xbc", 3);
+			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
+			bw_val2 = 0x01;
+		} else if (c->bandwidth_hz <= 8000000) {
+			/* IF 4570000 Hz, BW 8000000 Hz */
+			memcpy(if_val, "\x39\x11\xbc", 3);
+			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
+			bw_val2 = 0x00;
+		} else {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		/* IF 5070000 Hz, BW 8000000 Hz */
+		memcpy(if_val, "\x3f\x50\x2c", 3);
+		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
+		bw_val2 = 0x00;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params) {
 		ret = fe->ops.tuner_ops.set_params(fe);
@@ -56,67 +106,98 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
 	}
 
-	if (if_frequency != 5070000) {
+	switch (if_frequency) {
+	case 3570000:
+	case 4570000:
+	case 5070000:
+		break;
+	default:
 		dev_err(&client->dev, "IF frequency %d not supported\n",
 				if_frequency);
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[2], 0x83, 0x01);
+	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
 	if (ret)
 		goto err;
 
-	ret = regmap_bulk_write(dev->regmap[2], 0x00,
-			"\x66\x00\x01\x04\x00", 5);
+	ret = regmap_write(dev->regmap[2], 0x00, 0x66);
 	if (ret)
 		goto err;
-
-	ret = regmap_bulk_write(dev->regmap[2], 0x10,
-			"\x3f\x50\x2c\x8f\x80\x00\x08\xee\x08\xee", 10);
+	ret = regmap_write(dev->regmap[2], 0x01, 0x00);
 	if (ret)
 		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x02, 0x01);
 	if (ret)
 		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0xb0, 0x0b);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x03, delivery_system_val);
 	if (ret)
 		goto err;
-
-	ret = regmap_write(dev->regmap[0], 0xcd, 0x17);
+	ret = regmap_write(dev->regmap[2], 0x04, bw_val2);
 	if (ret)
 		goto err;
 
-	ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
-	if (ret)
-		goto err;
+	for (i = 0; i < sizeof(if_val); i++) {
+		ret = regmap_write(dev->regmap[2], 0x10 + i, if_val[i]);
+		if (ret)
+			goto err;
+	}
 
-	ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
-	if (ret)
-		goto err;
+	for (i = 0; i < sizeof(bw_val); i++) {
+		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
+		if (ret)
+			goto err;
+	}
 
-	ret = regmap_write(dev->regmap[1], 0x00, 0xb0);
-	if (ret)
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		ret = regmap_write(dev->regmap[0], 0x07, 0x26);
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x1f);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
+		ret = regmap_write(dev->regmap[0], 0x00, 0xba);
+		ret = regmap_write(dev->regmap[0], 0x01, 0x13);
+		if (ret)
+			goto err;
+		break;
+	case SYS_DVBT2:
+		ret = regmap_write(dev->regmap[2], 0x2b, 0x13);
+		ret = regmap_write(dev->regmap[2], 0x4f, 0x05);
+		ret = regmap_write(dev->regmap[1], 0xf6, 0x05);
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0xf6);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x01);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x46);
+		ret = regmap_write(dev->regmap[2], 0x30, 0x80);
+		ret = regmap_write(dev->regmap[2], 0x32, 0x00);
+		if (ret)
+			goto err;
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0b);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x17);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
+		ret = regmap_write(dev->regmap[1], 0x00, 0xb0);
+		if (ret)
+			goto err;
+		break;
+	default:
+		ret = -EINVAL;
 		goto err;
+	}
 
+	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
+	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
 	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
 		goto err;
@@ -133,6 +214,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int utmp;
 
@@ -143,9 +225,21 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	ret = regmap_read(dev->regmap[1], 0x84, &utmp);
-	if (ret)
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		/* FIXME: implement me */
+		utmp = 0x08; /* DVB-C lock value */
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_read(dev->regmap[1], 0x84, &utmp);
+		if (ret)
+			goto err;
+		break;
+	default:
+		ret = -EINVAL;
 		goto err;
+	}
 
 	if (utmp == 0x08)
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
@@ -255,7 +349,7 @@ err:
 }
 
 static struct dvb_frontend_ops mn88472_ops = {
-	.delsys = {SYS_DVBC_ANNEX_A},
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Panasonic MN88472",
 		.caps =	FE_CAN_FEC_1_2                 |
-- 
http://palosaari.fi/

