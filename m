Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab3CTOCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:22 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2KE2MjL009813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 10:02:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] [media] drxk: use a better calculus for RF strength
Date: Wed, 20 Mar 2013 11:02:14 -0300
Message-Id: <1363788136-14393-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
References: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The AZ6007 driver released by Terratec has a better way to
estimate the signal strength, at CtrlSigStrength(). Port it
to the driver.

It should be noticed that there are two parameters there that
are tuner-specific.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 126 +++++++++++++++++++++++++++-----
 1 file changed, 109 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index cd5084b..8a5b2cc 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6390,6 +6390,107 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int get_strength(struct drxk_state *state, u64 *strength)
+{
+	int status;
+	struct SCfgAgc   rfAgc, ifAgc;
+	u32          totalGain  = 0;
+	u32          atten      = 0;
+	u32          agcRange   = 0;
+	u16            scu_lvl  = 0;
+	u16            scu_coc  = 0;
+	/* FIXME: those are part of the tuner presets */
+	u16 tunerRfGain         = 50; /* Default value on az6007 driver */
+	u16 tunerIfGain         = 40; /* Default value on az6007 driver */
+
+	*strength = 0;
+
+	if (IsDVBT(state)) {
+		rfAgc = state->m_dvbtRfAgcCfg;
+		ifAgc = state->m_dvbtIfAgcCfg;
+	} else if (IsQAM(state)) {
+		rfAgc = state->m_qamRfAgcCfg;
+		ifAgc = state->m_qamIfAgcCfg;
+	} else {
+		rfAgc = state->m_atvRfAgcCfg;
+		ifAgc = state->m_atvIfAgcCfg;
+	}
+
+	if (rfAgc.ctrlMode == DRXK_AGC_CTRL_AUTO) {
+		/* SCU outputLevel */
+		status = read16(state, SCU_RAM_AGC_RF_IACCU_HI__A, &scu_lvl);
+		if (status < 0)
+			return status;
+
+		/* SCU c.o.c. */
+		read16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, &scu_coc);
+		if (status < 0)
+			return status;
+
+		if (((u32) scu_lvl + (u32) scu_coc) < 0xffff)
+			rfAgc.outputLevel = scu_lvl + scu_coc;
+		else
+			rfAgc.outputLevel = 0xffff;
+
+		/* Take RF gain into account */
+		totalGain += tunerRfGain;
+
+		/* clip output value */
+		if (rfAgc.outputLevel < rfAgc.minOutputLevel)
+			rfAgc.outputLevel = rfAgc.minOutputLevel;
+		if (rfAgc.outputLevel > rfAgc.maxOutputLevel)
+			rfAgc.outputLevel = rfAgc.maxOutputLevel;
+
+		agcRange = (u32) (rfAgc.maxOutputLevel - rfAgc.minOutputLevel);
+		if (agcRange > 0) {
+			atten += 100UL *
+				((u32)(tunerRfGain)) *
+				((u32)(rfAgc.outputLevel - rfAgc.minOutputLevel))
+				/ agcRange;
+		}
+	}
+
+	if (ifAgc.ctrlMode == DRXK_AGC_CTRL_AUTO) {
+		status = read16(state, SCU_RAM_AGC_IF_IACCU_HI__A,
+				&ifAgc.outputLevel);
+		if (status < 0)
+			return status;
+
+		status = read16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A,
+				&ifAgc.top);
+		if (status < 0)
+			return status;
+
+		/* Take IF gain into account */
+		totalGain += (u32) tunerIfGain;
+
+		/* clip output value */
+		if (ifAgc.outputLevel < ifAgc.minOutputLevel)
+			ifAgc.outputLevel = ifAgc.minOutputLevel;
+		if (ifAgc.outputLevel > ifAgc.maxOutputLevel)
+			ifAgc.outputLevel = ifAgc.maxOutputLevel;
+
+		agcRange  = (u32) (ifAgc.maxOutputLevel - ifAgc.minOutputLevel);
+		if (agcRange > 0) {
+			atten += 100UL *
+				((u32)(tunerIfGain)) *
+				((u32)(ifAgc.outputLevel - ifAgc.minOutputLevel))
+				/ agcRange;
+		}
+	}
+
+	/*
+	 * Convert to 0..65535 scale.
+	 * If it can't be measured (AGC is disabled), just show 100%.
+	 */
+	if (totalGain > 0)
+		*strength = (65535UL * atten / totalGain);
+	else
+		*strength = 65535;
+
+	return 0;
+}
+
 static int drxk_get_stats(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -6404,7 +6505,7 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 	u32 pre_bit_count;
 	u32 pkt_count;
 	u32 pkt_error_count;
-	s32 cnr, gain;
+	s32 cnr;
 
 	if (state->m_DrxkState == DRXK_NO_DEV)
 		return -ENODEV;
@@ -6421,6 +6522,13 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 	if (stat == DEMOD_LOCK)
 		state->fe_status |= 0x07;
 
+	/*
+	 * Estimate signal strength from AGC
+	 */
+	get_strength(state, &c->strength.stat[0].uvalue);
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+
+
 	if (stat >= DEMOD_LOCK) {
 		GetSignalToNoise(state, &cnr);
 		c->cnr.stat[0].svalue = cnr * 10;
@@ -6500,22 +6608,6 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_count.stat[0].uvalue += post_bit_count;
 
-	/*
-	 * Read AGC gain
-	 *
-	 * IFgain = (IQM_AF_AGC_IF__A * 26.75) (nA)
-	 */
-	status = read16(state, IQM_AF_AGC_IF__A, &reg16);
-	if (status < 0) {
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
-		return status;
-	}
-	gain = 2675 * (reg16 - DRXK_AGC_DAC_OFFSET) / 100;
-
-	/* FIXME: it makes sense to fix the scale here to dBm */
-	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	c->strength.stat[0].uvalue = gain;
-
 error:
 	return status;
 }
-- 
1.8.1.4

