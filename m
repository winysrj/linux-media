Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab3DQAm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0guQX003927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 09/31] [media] rtl2832: add code to bind r820t on it
Date: Tue, 16 Apr 2013 21:42:20 -0300
Message-Id: <1366159362-3773-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some init stuff to be done for each new tuner at the
demod code. Add the code there for r820t.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/rtl2832.c      | 76 +++++++++++++++++++++++-------
 drivers/media/dvb-frontends/rtl2832.h      |  1 +
 drivers/media/dvb-frontends/rtl2832_priv.h | 28 +++++++++++
 3 files changed, 88 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7388769..b6f50c7 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -432,22 +432,12 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		{DVBT_TR_THD_SET2,		0x6},
 		{DVBT_TRK_KC_I2,		0x5},
 		{DVBT_CR_THD_SET2,		0x1},
-		{DVBT_SPEC_INV,			0x0},
 	};
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
 
-	/*
-	* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
-	*		/ CrystalFreqHz)
-	*/
-	pset_iffreq = priv->cfg.if_dvbt % priv->cfg.xtal;
-	pset_iffreq *= 0x400000;
-	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
-	pset_iffreq = pset_iffreq & 0x3fffff;
-
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
 		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs[i].reg,
 			rtl2832_initial_regs[i].value);
@@ -472,6 +462,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(rtl2832_tuner_init_e4000);
 		init = rtl2832_tuner_init_e4000;
 		break;
+	case RTL2832_TUNER_R820T:
+		len = ARRAY_SIZE(rtl2832_tuner_init_r820t);
+		init = rtl2832_tuner_init_r820t;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err;
@@ -483,14 +477,43 @@ static int rtl2832_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/* if frequency settings */
-	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
-		if (ret)
-			goto err;
+	/*
+	 * if frequency settings
+	 * Some tuners (r820t) don't initialize IF here; instead; they do it
+	 * at set_params()
+	 */
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		/*
+		* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
+		*		/ CrystalFreqHz)
+		*/
+		pset_iffreq = priv->cfg.if_dvbt % priv->cfg.xtal;
+		pset_iffreq *= 0x400000;
+		pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
+		pset_iffreq = pset_iffreq & 0x3fffff;
+		ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
+			if (ret)
+				goto err;
+
+		ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
+			if (ret)
+				goto err;
+	}
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
-		if (ret)
-			goto err;
+	/*
+	 * r820t NIM code does a software reset here at the demod -
+	 * may not be needed, as there's already a software reset at set_params()
+	 */
+#if 1
+	/* soft reset */
+	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
+	if (ret)
+		goto err;
+#endif
 
 	priv->sleeping = false;
 
@@ -564,6 +587,25 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
+	/* If the frontend has get_if_frequency(), use it */
+	if (fe->ops.tuner_ops.get_if_frequency) {
+		u32 if_freq;
+		u64 pset_iffreq;
+
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
+		if (ret)
+			goto err;
+
+		pset_iffreq = if_freq % priv->cfg.xtal;
+		pset_iffreq *= 0x400000;
+		pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
+		pset_iffreq = pset_iffreq & 0x3fffff;
+
+		ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
+		if (ret)
+			goto err;
+	}
+
 	switch (c->bandwidth_hz) {
 	case 6000000:
 		i = 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index fefba0e..91b2dcf 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -52,6 +52,7 @@ struct rtl2832_config {
 #define RTL2832_TUNER_FC0012    0x26
 #define RTL2832_TUNER_E4000     0x27
 #define RTL2832_TUNER_FC0013    0x29
+#define RTL2832_TUNER_R820T	0x2a
 	u8 tuner;
 };
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 7d97ce9..b5f2b80 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -267,6 +267,7 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_tua9001[] = {
 	{DVBT_OPT_ADC_IQ,                0x1},
 	{DVBT_AD_AVI,                    0x0},
 	{DVBT_AD_AVQ,                    0x0},
+	{DVBT_SPEC_INV,			 0x0},
 };
 
 static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
@@ -300,6 +301,7 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_fc0012[] = {
 	{DVBT_GI_PGA_STATE,              0x0},
 	{DVBT_EN_AGC_PGA,                0x1},
 	{DVBT_IF_AGC_MAN,                0x0},
+	{DVBT_SPEC_INV,			 0x0},
 };
 
 static const struct rtl2832_reg_value rtl2832_tuner_init_e4000[] = {
@@ -337,6 +339,32 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_e4000[] = {
 	{DVBT_REG_MONSEL,                0x1},
 	{DVBT_REG_MON,                   0x1},
 	{DVBT_REG_4MSEL,                 0x0},
+	{DVBT_SPEC_INV,			 0x0},
+};
+
+static const struct rtl2832_reg_value rtl2832_tuner_init_r820t[] = {
+	{DVBT_DAGC_TRG_VAL,		0x39},
+	{DVBT_AGC_TARG_VAL_0,		0x0},
+	{DVBT_AGC_TARG_VAL_8_1,		0x40},
+	{DVBT_AAGC_LOOP_GAIN,		0x16},
+	{DVBT_LOOP_GAIN2_3_0,		0x8},
+	{DVBT_LOOP_GAIN2_4,		0x1},
+	{DVBT_LOOP_GAIN3,		0x18},
+	{DVBT_VTOP1,			0x35},
+	{DVBT_VTOP2,			0x21},
+	{DVBT_VTOP3,			0x21},
+	{DVBT_KRF1,			0x0},
+	{DVBT_KRF2,			0x40},
+	{DVBT_KRF3,			0x10},
+	{DVBT_KRF4,			0x10},
+	{DVBT_IF_AGC_MIN,		0x80},
+	{DVBT_IF_AGC_MAX,		0x7f},
+	{DVBT_RF_AGC_MIN,		0x80},
+	{DVBT_RF_AGC_MAX,		0x7f},
+	{DVBT_POLAR_RF_AGC,		0x0},
+	{DVBT_POLAR_IF_AGC,		0x0},
+	{DVBT_AD7_SETTING,		0xe9f4},
+	{DVBT_SPEC_INV,			0x1},
 };
 
 #endif /* RTL2832_PRIV_H */
-- 
1.8.1.4

