Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab3DQAmu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gn2P003901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 11/31] [media] rtl2832: properly set en_bbin for r820t
Date: Tue, 16 Apr 2013 21:42:22 -0300
Message-Id: <1366159362-3773-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBT_EN_BBIN should be set on both places where IF is set. So,
move it to a function and call it where needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/rtl2832.c | 63 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index b6f50c7..2f5a2b5 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -380,13 +380,37 @@ err:
 	return ret;
 }
 
-static int rtl2832_init(struct dvb_frontend *fe)
+
+static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
-	int i, ret, len;
-	u8 en_bbin;
+	int ret;
 	u64 pset_iffreq;
+	u8 en_bbin = (if_freq == 0 ? 0x1 : 0x0);
+
+	/*
+	* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
+	*		/ CrystalFreqHz)
+	*/
+
+	pset_iffreq = if_freq % priv->cfg.xtal;
+	pset_iffreq *= 0x400000;
+	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
+	pset_iffreq = pset_iffreq & 0x3fffff;
+	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
+	if (ret)
+		return ret;
+
+	ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
+
+	return (ret);
+}
+
+static int rtl2832_init(struct dvb_frontend *fe)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
 	const struct rtl2832_reg_value *init;
+	int i, ret, len;
 
 	/* initialization values for the demodulator registers */
 	struct rtl2832_reg_value rtl2832_initial_regs[] = {
@@ -436,8 +460,6 @@ static int rtl2832_init(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
-	en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
-
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
 		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs[i].reg,
 			rtl2832_initial_regs[i].value);
@@ -477,27 +499,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/*
-	 * if frequency settings
-	 * Some tuners (r820t) don't initialize IF here; instead; they do it
-	 * at set_params()
-	 */
 	if (!fe->ops.tuner_ops.get_if_frequency) {
-		/*
-		* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
-		*		/ CrystalFreqHz)
-		*/
-		pset_iffreq = priv->cfg.if_dvbt % priv->cfg.xtal;
-		pset_iffreq *= 0x400000;
-		pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
-		pset_iffreq = pset_iffreq & 0x3fffff;
-		ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
-			if (ret)
-				goto err;
-
-		ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
-			if (ret)
-				goto err;
+		ret = rtl2832_set_if(fe, priv->cfg.if_dvbt);
+		if (ret)
+			goto err;
 	}
 
 	/*
@@ -590,18 +595,12 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	/* If the frontend has get_if_frequency(), use it */
 	if (fe->ops.tuner_ops.get_if_frequency) {
 		u32 if_freq;
-		u64 pset_iffreq;
 
 		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
 		if (ret)
 			goto err;
 
-		pset_iffreq = if_freq % priv->cfg.xtal;
-		pset_iffreq *= 0x400000;
-		pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
-		pset_iffreq = pset_iffreq & 0x3fffff;
-
-		ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
+		ret = rtl2832_set_if(fe, if_freq);
 		if (ret)
 			goto err;
 	}
-- 
1.8.1.4

