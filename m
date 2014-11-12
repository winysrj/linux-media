Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55719 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/9] mn88473: add support for DVB-T2
Date: Wed, 12 Nov 2014 06:19:24 +0200
Message-Id: <1415765971-24378-3-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DVB-T2.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c | 45 +++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index afe59f3..68bfb65 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -116,19 +116,38 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 {
 	struct mn88473_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
+	int ret, i;
 	u32 if_frequency = 0;
+	u8 params[10], delivery_system;
 
 	dev_dbg(&dev->i2c->dev,
-			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
+			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%d stream_id=%d\n",
 			__func__, c->delivery_system, c->modulation,
-			c->frequency, c->symbol_rate, c->inversion);
+			c->frequency, c->bandwidth_hz, c->symbol_rate,
+			c->inversion, c->stream_id);
 
 	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
+	switch (c->delivery_system) {
+	case SYS_DVBT2:
+		delivery_system = 0x03;
+		if (c->bandwidth_hz <= 7000000)
+			memcpy(params, "\x2e\xcb\xfb\xc8\x00\x00\x17\x0a\x17\x0a", 10);
+		else if (c->bandwidth_hz <= 8000000)
+			memcpy(params, "\x2e\xcb\xfb\xaf\x00\x00\x11\xec\x11\xec", 10);
+		break;
+	case SYS_DVBC_ANNEX_A:
+		delivery_system = 0x04;
+		memcpy(params, "\x33\xea\xb3\xaf\x00\x00\x11\xec\x11\xec", 10);
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params) {
 		ret = fe->ops.tuner_ops.set_params(fe);
@@ -145,7 +164,11 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 				__func__, if_frequency);
 	}
 
-	if (if_frequency != 5070000) {
+	switch (if_frequency) {
+	case 4570000:
+	case 5070000:
+		break;
+	default:
 		dev_err(&dev->i2c->dev, "%s: IF frequency %d not supported\n",
 				KBUILD_MODNAME, if_frequency);
 		ret = -EINVAL;
@@ -159,9 +182,15 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	ret = mn88473_wregs(dev, 0x1c00, "\x18", 1);
 	ret = mn88473_wregs(dev, 0x1c01, "\x01", 1);
 	ret = mn88473_wregs(dev, 0x1c02, "\x21", 1);
-	ret = mn88473_wregs(dev, 0x1c03, "\x04", 1);
+	ret = mn88473_wreg(dev, 0x1c03, delivery_system);
 	ret = mn88473_wregs(dev, 0x1c0b, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x1c10, "\x33\xea\xb3\xaf\x00\x00\x11\xec\x11\xec", 10);
+
+	for (i = 0; i < 10; i++) {
+		ret = mn88473_wreg(dev, 0x1c10 + i, params[i]);
+		if (ret)
+			goto err;
+	}
+
 	ret = mn88473_wregs(dev, 0x1c2d, "\x3b", 1);
 	ret = mn88473_wregs(dev, 0x1c2e, "\x00", 1);
 	ret = mn88473_wregs(dev, 0x1c56, "\x0d", 1);
@@ -193,6 +222,8 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	ret = mn88473_wregs(dev, 0x1c08, "\x1d", 1);
 	ret = mn88473_wregs(dev, 0x18b2, "\x37", 1);
 	ret = mn88473_wregs(dev, 0x18d7, "\x04", 1);
+	ret = mn88473_wregs(dev, 0x1c32, "\x80", 1);
+	ret = mn88473_wregs(dev, 0x1c36, "\x00", 1);
 	ret = mn88473_wregs(dev, 0x1cf8, "\x9f", 1);
 	if (ret)
 		goto err;
@@ -351,7 +382,7 @@ err:
 EXPORT_SYMBOL(mn88473_attach);
 
 static struct dvb_frontend_ops mn88473_ops = {
-	.delsys = {SYS_DVBC_ANNEX_AC},
+	.delsys = {SYS_DVBT2, SYS_DVBC_ANNEX_AC},
 	.info = {
 		.name = "Panasonic MN88473",
 		.caps =	FE_CAN_FEC_1_2			|
-- 
http://palosaari.fi/

