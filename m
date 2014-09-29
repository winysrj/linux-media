Return-path: <linux-media-owner@vger.kernel.org>
Received: from HC210-202-87-179.vdslpro.static.apol.com.tw ([210.202.87.179]:27147
	"EHLO ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI2Ik4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 04:40:56 -0400
Subject: [PATCH 1/2] af9033: fix signal strength value not correct issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-T3C5IvHu5Yk5HSLNTMmz"
Date: Mon, 29 Sep 2014 16:43:45 +0800
Message-ID: <1411980225.1747.10.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-T3C5IvHu5Yk5HSLNTMmz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.

--=-T3C5IvHu5Yk5HSLNTMmz
Content-Disposition: attachment; filename="0001-af9033-fix-signal-strength-value-not-correct-issue.patch"
Content-Type: text/x-patch; name="0001-af9033-fix-signal-strength-value-not-correct-issue.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From b85ad9df69884b80cce62877039aa9130243ef3a Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Mon, 29 Sep 2014 13:57:07 +0800
Subject: [PATCH 1/2] af9033: fix signal strength value not correct issue

Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   54 ++++++++++++++++++-----------
 drivers/media/dvb-frontends/af9033_priv.h |    6 +++
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 63a89c1..e191bd5 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -862,23 +862,14 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret;
-	u8 strength2;
-
-	/* read signal strength of 0-100 scale */
-	ret = af9033_rd_reg(dev, 0x800048, &strength2);
-	if (ret < 0)
-		goto err;
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 
-	/* scale value to 0x0000-0xffff */
-	*strength = strength2 * 0xffff / 100;
+	if (c->strength.stat[0].scale == FE_SCALE_RELATIVE)
+		*strength = c->strength.stat[0].uvalue;
+	else
+		*strength = 0;
 
 	return 0;
-
-err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
-	return ret;
 }
 
 static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
@@ -974,8 +965,8 @@ static void af9033_stat_work(struct work_struct *work)
 {
 	struct af9033_dev *dev = container_of(work, struct af9033_dev, stat_work.work);
 	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
-	int ret, tmp, i, len;
-	u8 u8tmp, buf[7];
+	int ret, tmp, i, len, power_real;
+	u8 u8tmp, gain_offset, buf[7];
 
 	dev_dbg(&dev->client->dev, "\n");
 
@@ -983,17 +974,40 @@ static void af9033_stat_work(struct work_struct *work)
 	if (dev->fe_status & FE_HAS_SIGNAL) {
 		if (dev->is_af9035) {
 			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
-			tmp = -u8tmp * 1000;
+			/* scale value to 0x0000-0xffff */
+			tmp = u8tmp * 0xffff / 100;
 		} else {
 			ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
-			tmp = (u8tmp - 100) * 1000;
+			ret |= af9033_rd_regs(dev, 0x80f900, buf, 7);
+
+			if (c->frequency <= 300000000)
+				gain_offset = 7; /* VHF */
+			else
+				gain_offset = 4; /* UHF */
+
+			power_real = (u8tmp - 100 - gain_offset) -
+				power_reference[((buf[3] >> 0) & 3)][((buf[6] >> 0) & 7)];
+
+			if (power_real < -15)
+				tmp = 0;
+			else if ((power_real >= -15) && (power_real < 0))
+				tmp = (2 * (power_real + 15)) / 3;
+			else if ((power_real >= 0) && (power_real < 20))
+				tmp = 4 * power_real + 10;
+			else if ((power_real >= 20) && (power_real < 35))
+				tmp = (2 * (power_real - 20)) / 3 + 90;
+			else
+				tmp = 100;
+
+			/* scale value to 0x0000-0xffff */
+			tmp = tmp * 0xffff / 100;
 		}
 		if (ret)
 			goto err;
 
 		c->strength.len = 1;
-		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
-		c->strength.stat[0].svalue = tmp;
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = tmp;
 	} else {
 		c->strength.len = 1;
 		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
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
1.7.0.4


--=-T3C5IvHu5Yk5HSLNTMmz--

