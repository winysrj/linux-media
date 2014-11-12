Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38208 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/9] mn88473: improve IF frequency and BW handling
Date: Wed, 12 Nov 2014 06:19:26 +0200
Message-Id: <1415765971-24378-5-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Separate IF and BW based registers.
Add support for DVB-T and DVB-T2 6MHz channel bandwidth.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c | 64 +++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index cda0bdb..2c81a83 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -117,8 +117,8 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	struct mn88473_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
-	u32 if_frequency = 0;
-	u8 params[10], delivery_system;
+	u32 if_frequency;
+	u8 delivery_system_val, if_val[3], bw_val[7];
 
 	dev_dbg(&dev->i2c->dev,
 			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%d stream_id=%d\n",
@@ -133,22 +133,43 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
-		delivery_system = 0x02;
-		if (c->bandwidth_hz <= 7000000)
-			memcpy(params, "\x2e\xcb\xfb\xc8\x00\x00\x17\x0a\x17\x0a", 10);
-		else if (c->bandwidth_hz <= 8000000)
-			memcpy(params, "\x2e\xcb\xfb\xaf\x00\x00\x11\xec\x11\xec", 10);
+		delivery_system_val = 0x02;
 		break;
 	case SYS_DVBT2:
-		delivery_system = 0x03;
-		if (c->bandwidth_hz <= 7000000)
-			memcpy(params, "\x2e\xcb\xfb\xc8\x00\x00\x17\x0a\x17\x0a", 10);
-		else if (c->bandwidth_hz <= 8000000)
-			memcpy(params, "\x2e\xcb\xfb\xaf\x00\x00\x11\xec\x11\xec", 10);
+		delivery_system_val = 0x03;
 		break;
 	case SYS_DVBC_ANNEX_A:
-		delivery_system = 0x04;
-		memcpy(params, "\x33\xea\xb3\xaf\x00\x00\x11\xec\x11\xec", 10);
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
+			memcpy(if_val, "\x24\x8e\x8a", 3);
+			memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
+		} else if (c->bandwidth_hz <= 7000000) {
+			/* IF 4570000 Hz, BW 7000000 Hz */
+			memcpy(if_val, "\x2e\xcb\xfb", 3);
+			memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
+		} else if (c->bandwidth_hz <= 8000000) {
+			/* IF 4570000 Hz, BW 8000000 Hz */
+			memcpy(if_val, "\x2e\xcb\xfb", 3);
+			memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
+		} else {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		/* IF 5070000 Hz, BW 8000000 Hz */
+		memcpy(if_val, "\x33\xea\xb3", 3);
+		memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
 		break;
 	default:
 		ret = -EINVAL;
@@ -169,9 +190,12 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 
 		dev_dbg(&dev->i2c->dev, "%s: get_if_frequency=%d\n",
 				__func__, if_frequency);
+	} else {
+		if_frequency = 0;
 	}
 
 	switch (if_frequency) {
+	case 3570000:
 	case 4570000:
 	case 5070000:
 		break;
@@ -189,11 +213,17 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	ret = mn88473_wregs(dev, 0x1c00, "\x18", 1);
 	ret = mn88473_wregs(dev, 0x1c01, "\x01", 1);
 	ret = mn88473_wregs(dev, 0x1c02, "\x21", 1);
-	ret = mn88473_wreg(dev, 0x1c03, delivery_system);
+	ret = mn88473_wreg(dev, 0x1c03, delivery_system_val);
 	ret = mn88473_wregs(dev, 0x1c0b, "\x00", 1);
 
-	for (i = 0; i < 10; i++) {
-		ret = mn88473_wreg(dev, 0x1c10 + i, params[i]);
+	for (i = 0; i < sizeof(if_val); i++) {
+		ret = mn88473_wreg(dev, 0x1c10 + i, if_val[i]);
+		if (ret)
+			goto err;
+	}
+
+	for (i = 0; i < sizeof(bw_val); i++) {
+		ret = mn88473_wreg(dev, 0x1c13 + i, bw_val[i]);
 		if (ret)
 			goto err;
 	}
-- 
http://palosaari.fi/

