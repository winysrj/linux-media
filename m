Return-path: <linux-media-owner@vger.kernel.org>
Received: from HC210-202-87-179.vdslpro.static.apol.com.tw ([210.202.87.179]:38932
	"EHLO ironport.ite.com.tw" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755368AbaIWJlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 05:41:14 -0400
Subject: [1/2] af9033: fix it9135 strength value not correct issue
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Content-Type: multipart/mixed; boundary="=-pemMrNFEWBloMOQ0v5mt"
Date: Tue, 23 Sep 2014 17:44:02 +0800
Message-ID: <1411465442.1919.6.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pemMrNFEWBloMOQ0v5mt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Register 0x800048 does not work in it9135. Fix it and conform to NorDig specifications.

--=-pemMrNFEWBloMOQ0v5mt
Content-Disposition: attachment; filename="0001-af9033-fix-it9135-strength-value-not-correct-issue.patch"
Content-Type: text/x-patch; name="0001-af9033-fix-it9135-strength-value-not-correct-issue.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 5d2f434dd4737a97a954dc775c26295e785a20c6 Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Tue, 23 Sep 2014 15:31:44 +0800
Subject: [PATCH 1/2] af9033: fix it9135 strength value not correct issue

Register 0x800048 does not work in it9135. Fix it and conform to NorDig specifications.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/dvb-frontends/af9033.c      |   50 ++++++++++++++++++++++++-----
 drivers/media/dvb-frontends/af9033_priv.h |    6 +++
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 5c90ea6..0a0aeaf 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -28,6 +28,7 @@ struct af9033_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
+	bool is_af9035;
 
 	u32 bandwidth_hz;
 	bool ts_mode_parallel;
@@ -892,16 +893,46 @@ err:
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct af9033_state *state = fe->demodulator_priv;
-	int ret;
-	u8 strength2;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, power_real;
+	u8 strength2, gain_offset, buf[8];
 
-	/* read signal strength of 0-100 scale */
-	ret = af9033_rd_reg(state, 0x800048, &strength2);
-	if (ret < 0)
-		goto err;
+	if (state->is_af9035) {
+		/* read signal strength of 0-100 scale */
+		ret = af9033_rd_reg(state, 0x800048, &strength2);
+		if (ret < 0)
+			goto err;
 
-	/* scale value to 0x0000-0xffff */
-	*strength = strength2 * 0xffff / 100;
+		/* scale value to 0x0000-0xffff */
+		*strength = strength2 * 0xffff / 100;
+	} else {
+		ret = af9033_rd_reg(state, 0x8000f7, &strength2);
+		ret |= af9033_rd_regs(state, 0x80f900, buf, sizeof(buf));
+		if (ret < 0)
+			goto err;
+
+		if (c->frequency <= 300000000)
+			gain_offset = 7; /* VHF */
+		else
+			gain_offset = 4; /* UHF */
+
+		power_real = (strength2 - 100 - gain_offset) -
+			power_reference[((buf[3] >> 0) & 3)][((buf[6] >> 0) & 7)];
+
+		if (power_real < -15)
+			*strength = 0;
+		else if ((power_real >= -15) && (power_real < 0))
+			*strength = (u8)((2 * (power_real + 15)) / 3);
+		else if ((power_real >= 0) && (power_real < 20))
+			*strength = (u8)(4 * power_real + 10);
+		else if ((power_real >= 20) && (power_real < 35))
+			*strength = (u8)((2 * (power_real - 20)) / 3 + 90);
+		else
+			*strength = 100;
+
+		/* scale value to 0x0000-0xffff */
+		*strength = *strength * 0xffff / 100;
+	}
 
 	return 0;
 
@@ -1103,6 +1134,7 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
 		/* IT9135 did not like to sleep at that early */
+		state->is_af9035 = false;
 		break;
 	default:
 		ret = af9033_wr_reg(state, 0x80004c, 1);
@@ -1112,6 +1144,8 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 		ret = af9033_wr_reg(state, 0x800000, 0);
 		if (ret < 0)
 			goto err;
+
+		state->is_af9035 = true;
 	}
 
 	/* configure internal TS mode */
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index ded7b67..58315e0 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -2050,4 +2050,10 @@ static const struct reg_val tuner_init_it9135_62[] = {
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


--=-pemMrNFEWBloMOQ0v5mt--

