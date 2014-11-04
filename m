Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52030 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaKDBHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] af9033: fix DVBv3 signal strength value not correct issue
Date: Tue,  4 Nov 2014 03:06:59 +0200
Message-Id: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bimow Chen <Bimow.Chen@ite.com.tw>

Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 43 +++++++++++++++++++++++++------
 drivers/media/dvb-frontends/af9033_priv.h |  6 +++++
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 63a89c1..2b3d2f0 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -862,16 +862,43 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret;
-	u8 strength2;
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
+	int ret, tmp, power_real;
+	u8 u8tmp, gain_offset, buf[7];
 
-	/* read signal strength of 0-100 scale */
-	ret = af9033_rd_reg(dev, 0x800048, &strength2);
-	if (ret < 0)
-		goto err;
+	if (dev->is_af9035) {
+		ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
+		/* scale value to 0x0000-0xffff */
+		*strength = u8tmp * 0xffff / 100;
+	} else {
+		ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
+		ret |= af9033_rd_regs(dev, 0x80f900, buf, 7);
+
+		if (c->frequency <= 300000000)
+			gain_offset = 7; /* VHF */
+		else
+			gain_offset = 4; /* UHF */
+
+		power_real = (u8tmp - 100 - gain_offset) -
+			power_reference[((buf[3] >> 0) & 3)][((buf[6] >> 0) & 7)];
+
+		if (power_real < -15)
+			tmp = 0;
+		else if ((power_real >= -15) && (power_real < 0))
+			tmp = (2 * (power_real + 15)) / 3;
+		else if ((power_real >= 0) && (power_real < 20))
+			tmp = 4 * power_real + 10;
+		else if ((power_real >= 20) && (power_real < 35))
+			tmp = (2 * (power_real - 20)) / 3 + 90;
+		else
+			tmp = 100;
+
+		/* scale value to 0x0000-0xffff */
+		*strength = tmp * 0xffff / 100;
+	}
 
-	/* scale value to 0x0000-0xffff */
-	*strength = strength2 * 0xffff / 100;
+	if (ret)
+		goto err;
 
 	return 0;
 
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index c12c92c..c9c8798 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -2051,4 +2051,10 @@ static const struct reg_val tuner_init_it9135_62[] = {
 	{ 0x80fd8b, 0x00 },
 };
 
+/* NorDig power reference table */
+static const int power_reference[][5] = {
+	{-93, -91, -90, -89, -88}, /* QPSK 1/2 ~ 7/8 */
+	{-87, -85, -84, -83, -82}, /* 16QAM 1/2 ~ 7/8 */
+	{-82, -80, -78, -77, -76}, /* 64QAM 1/2 ~ 7/8 */
+};
 #endif /* AF9033_PRIV_H */
-- 
http://palosaari.fi/

