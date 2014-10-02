Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:46646 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaJBF3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 01:29:14 -0400
Subject: [PATCH 1/2] af9033: fix DVBv3 signal strength value not correct
 issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-fDVgPVWzsA3vkEAo3S6+"
Date: Thu, 02 Oct 2014 13:32:34 +0800
Message-ID: <1412227954.1699.2.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-fDVgPVWzsA3vkEAo3S6+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.

--=-fDVgPVWzsA3vkEAo3S6+
Content-Disposition: attachment; filename*0=0001-af9033-fix-DVBv3-signal-strength-value-not-correct-i.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-af9033-fix-DVBv3-signal-strength-value-not-correct-i.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 02ee7de4600a43a322f75cf04d273effa04d3a42 Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Wed, 1 Oct 2014 18:28:54 +0800
Subject: [PATCH 1/2] af9033: fix DVBv3 signal strength value not correct issue

Register 0x800048 is not dB measure but relative scale. Fix it and conform to NorDig specifications.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   43 +++++++++++++++++++++++-----
 drivers/media/dvb-frontends/af9033_priv.h |    6 ++++
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
1.7.0.4


--=-fDVgPVWzsA3vkEAo3S6+--

