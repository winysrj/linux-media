Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1LRAV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:21:26 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0LQ7v025064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:21:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/6] [media] Remove Annex A/C selection via roll-off factor
Date: Sat, 17 Dec 2011 22:21:09 -0200
Message-Id: <1324167673-20787-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324167673-20787-2-git-send-email-mchehab@redhat.com>
References: <1324167673-20787-1-git-send-email-mchehab@redhat.com>
 <1324167673-20787-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a roll-off factor, change DRX-K & friends to select
the bandwidth filter and the Nyquist half roll-off via delivery system.

This provides a cleaner support for Annex A/C switch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc5000.c       |  137 +++++++++++----------------
 drivers/media/dvb/dvb-core/dvb_frontend.c  |   25 ++++-
 drivers/media/dvb/frontends/drxk_hard.c    |   15 ++-
 drivers/media/dvb/frontends/tda18271c2dd.c |   44 ++++-----
 include/linux/dvb/frontend.h               |    2 -
 5 files changed, 106 insertions(+), 117 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 97ad338..5c56d3c 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -629,11 +629,13 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 }
 
 static int xc5000_set_params(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+			     struct dvb_frontend_parameters *params)
 {
+	int ret, b;
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret;
-	u32 bw;
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	u32 freq = fe->dtv_property_cache.frequency;
+	u32 delsys  = fe->dtv_property_cache.delivery_system;
 
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
@@ -642,104 +644,77 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 		}
 	}
 
-	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
+	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, freq);
 
-	if (fe->ops.info.type == FE_ATSC) {
-		dprintk(1, "%s() ATSC\n", __func__);
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-		case VSB_16:
-			dprintk(1, "%s() VSB modulation\n", __func__);
-			priv->rf_mode = XC_RF_MODE_AIR;
-			priv->freq_hz = params->frequency - 1750000;
-			priv->bandwidth = BANDWIDTH_6_MHZ;
-			priv->video_standard = DTV6;
-			break;
-		case QAM_64:
-		case QAM_256:
-		case QAM_AUTO:
-			dprintk(1, "%s() QAM modulation\n", __func__);
-			priv->rf_mode = XC_RF_MODE_CABLE;
-			priv->freq_hz = params->frequency - 1750000;
-			priv->bandwidth = BANDWIDTH_6_MHZ;
-			priv->video_standard = DTV6;
-			break;
-		default:
-			return -EINVAL;
-		}
-	} else if (fe->ops.info.type == FE_OFDM) {
+	switch (delsys) {
+	case SYS_ATSC:
+		dprintk(1, "%s() VSB modulation\n", __func__);
+		priv->rf_mode = XC_RF_MODE_AIR;
+		priv->freq_hz = freq - 1750000;
+		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->video_standard = DTV6;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		dprintk(1, "%s() QAM modulation\n", __func__);
+		priv->rf_mode = XC_RF_MODE_CABLE;
+		priv->freq_hz = freq - 1750000;
+		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->video_standard = DTV6;
+		break;
+	case SYS_DVBT:
+	case SYS_DVBT2:
 		dprintk(1, "%s() OFDM\n", __func__);
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		switch (bw) {
+		case 6000000:
 			priv->bandwidth = BANDWIDTH_6_MHZ;
 			priv->video_standard = DTV6;
-			priv->freq_hz = params->frequency - 1750000;
+			priv->freq_hz = freq - 1750000;
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			priv->bandwidth = BANDWIDTH_7_MHZ;
 			priv->video_standard = DTV7;
-			priv->freq_hz = params->frequency - 2250000;
+			priv->freq_hz = freq - 2250000;
 			break;
-		case BANDWIDTH_8_MHZ:
+		case 8000000:
 			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = DTV8;
-			priv->freq_hz = params->frequency - 2750000;
+			priv->freq_hz = freq - 2750000;
 			break;
 		default:
 			printk(KERN_ERR "xc5000 bandwidth not set!\n");
 			return -EINVAL;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
-	} else if (fe->ops.info.type == FE_QAM) {
-		switch (params->u.qam.modulation) {
-		case QAM_256:
-		case QAM_AUTO:
-		case QAM_16:
-		case QAM_32:
-		case QAM_64:
-		case QAM_128:
-			dprintk(1, "%s() QAM modulation\n", __func__);
-			priv->rf_mode = XC_RF_MODE_CABLE;
-			/*
-			 * Using a higher bandwidth at the tuner filter may
-			 * allow inter-carrier interference.
-			 * So, determine the minimal channel spacing, in order
-			 * to better adjust the tuner filter.
-			 * According with ITU-T J.83, the bandwidth is given by:
-			 * bw = Simbol Rate * (1 + roll_off), where the roll_off
-			 * is equal to 0.15 for Annex A, and 0.13 for annex C
-			 */
-			if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-				bw = (params->u.qam.symbol_rate * 113) / 100;
-			else
-				bw = (params->u.qam.symbol_rate * 115) / 100;
-			if (bw <= 6000000) {
-				priv->bandwidth = BANDWIDTH_6_MHZ;
-				priv->video_standard = DTV6;
-				priv->freq_hz = params->frequency - 1750000;
-			} else if (bw <= 7000000) {
-				priv->bandwidth = BANDWIDTH_7_MHZ;
-				priv->video_standard = DTV7;
-				priv->freq_hz = params->frequency - 2250000;
-			} else {
-				priv->bandwidth = BANDWIDTH_8_MHZ;
-				priv->video_standard = DTV7_8;
-				priv->freq_hz = params->frequency - 2750000;
-			}
-			dprintk(1, "%s() Bandwidth %dMHz (%d)\n", __func__,
-				BANDWIDTH_6_MHZ ? 6: 8, bw);
-			break;
-		default:
-			dprintk(1, "%s() Unsupported QAM type\n", __func__);
-			return -EINVAL;
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		dprintk(1, "%s() QAM modulation\n", __func__);
+		priv->rf_mode = XC_RF_MODE_CABLE;
+		if (bw <= 6000000) {
+			priv->bandwidth = BANDWIDTH_6_MHZ;
+			priv->video_standard = DTV6;
+			priv->freq_hz = freq - 1750000;
+			b = 6;
+		} else if (bw <= 7000000) {
+			priv->bandwidth = BANDWIDTH_7_MHZ;
+			priv->video_standard = DTV7;
+			priv->freq_hz = freq - 2250000;
+			b = 7;
+		} else {
+			priv->bandwidth = BANDWIDTH_8_MHZ;
+			priv->video_standard = DTV7_8;
+			priv->freq_hz = freq - 2750000;
+			b = 8;
 		}
-	} else {
-		printk(KERN_ERR "xc5000 modulation type not supported!\n");
+		dprintk(1, "%s() Bandwidth %dMHz (%d)\n", __func__,
+			b, bw);
+		break;
+	default:
+		printk(KERN_ERR "xc5000: delivery system is not supported!\n");
 		return -EINVAL;
 	}
 
-	dprintk(1, "%s() frequency=%d (compensated)\n",
-		__func__, priv->freq_hz);
+	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
+		__func__, freq, priv->freq_hz);
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 821b225..66537b1 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1011,7 +1011,7 @@ static void dtv_property_dump(struct dtv_property *tvp)
 
 static int is_legacy_delivery_system(fe_delivery_system_t s)
 {
-	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_AC) ||
+	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_A) ||
 	   (s == SYS_DVBC_ANNEX_B) || (s == SYS_DVBT) || (s == SYS_DVBS) ||
 	   (s == SYS_ATSC))
 		return 1;
@@ -1032,8 +1032,7 @@ static void dtv_property_cache_init(struct dvb_frontend *fe,
 		c->delivery_system = SYS_DVBS;
 		break;
 	case FE_QAM:
-		c->delivery_system = SYS_DVBC_ANNEX_AC;
-		c->rolloff = ROLLOFF_15; /* implied for Annex A */
+		c->delivery_system = SYS_DVBC_ANNEX_A;
 		break;
 	case FE_OFDM:
 		c->delivery_system = SYS_DVBT;
@@ -1144,9 +1143,10 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
  */
 static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 {
-	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
+	u32 rolloff = 0;
 
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
@@ -1178,6 +1178,23 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 		else
 			p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
 	}
+
+	/*
+	 * On DVB-C, the bandwidth is a function of roll-off and symbol rate.
+	 * The bandwidth is required for DVB-C tuners, in order to avoid
+	 * inter-channel noise. Instead of estimating the minimal required
+	 * bandwidth on every single driver, calculates it here and fills
+	 * it at the cache bandwidth parameter.
+	 * While not officially supported, a side effect of handling it at
+	 * the cache level is that a program could retrieve the bandwidth
+	 * via DTV_BANDWIDTH_HZ, wich may be useful for test programs.
+	 */
+	if (c->delivery_system == SYS_DVBC_ANNEX_A)
+		rolloff = 115;
+	if (c->delivery_system == SYS_DVBC_ANNEX_C)
+		rolloff = 113;
+	if (rolloff)
+		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;
 }
 
 static void dtv_property_cache_submit(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 038e470..a2c8196 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6215,6 +6215,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *p)
 {
 	struct drxk_state *state = fe->demodulator_priv;
+	u32 delsys  = fe->dtv_property_cache.delivery_system;
 	u32 IF;
 
 	dprintk(1, "\n");
@@ -6225,11 +6226,15 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	if (fe->ops.info.type == FE_QAM) {
-		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			state->m_itut_annex_c = true;
-		else
-			state->m_itut_annex_c = false;
+	switch (delsys) {
+	case SYS_DVBC_ANNEX_A:
+		state->m_itut_annex_c = false;
+		break;
+	case SYS_DVBC_ANNEX_C:
+		state->m_itut_annex_c = true;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index b66ca29..0f8e962 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1130,50 +1130,44 @@ static int set_params(struct dvb_frontend *fe,
 	struct tda_state *state = fe->tuner_priv;
 	int status = 0;
 	int Standard;
-	u32 bw;
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	u32 delsys  = fe->dtv_property_cache.delivery_system;
 
-	state->m_Frequency = params->frequency;
+	state->m_Frequency = fe->dtv_property_cache.frequency;
 
-	if (fe->ops.info.type == FE_OFDM)
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+	switch (delsys) {
+	case  SYS_DVBT:
+	case  SYS_DVBT2:
+		switch (bw) {
+		case 6000000:
 			Standard = HF_DVBT_6MHZ;
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			Standard = HF_DVBT_7MHZ;
 			break;
-		default:
-		case BANDWIDTH_8_MHZ:
+		case 8000000:
 			Standard = HF_DVBT_8MHZ;
 			break;
+		default:
+			return -EINVAL;
 		}
-	else if (fe->ops.info.type == FE_QAM) {
-		/*
-		 * Using a higher bandwidth at the tuner filter may
-		 * allow inter-carrier interference.
-		 * So, determine the minimal channel spacing, in order
-		 * to better adjust the tuner filter.
-		 * According with ITU-T J.83, the bandwidth is given by:
-		 * bw = Simbol Rate * (1 + roll_off), where the roll_off
-		 * is equal to 0.15 for Annex A, and 0.13 for annex C
-		 */
-		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			bw = (params->u.qam.symbol_rate * 113) / 100;
-		else
-			bw = (params->u.qam.symbol_rate * 115) / 100;
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
 		if (bw <= 6000000)
 			Standard = HF_DVBC_6MHZ;
 		else if (bw <= 7000000)
 			Standard = HF_DVBC_7MHZ;
 		else
 			Standard = HF_DVBC_8MHZ;
-	} else
+	default:
 		return -EINVAL;
+	}
 	do {
-		status = RFTrackingFiltersCorrection(state, params->frequency);
+		status = RFTrackingFiltersCorrection(state, state->m_Frequency);
 		if (status < 0)
 			break;
-		status = ChannelConfiguration(state, params->frequency, Standard);
+		status = ChannelConfiguration(state, state->m_Frequency,
+					      Standard);
 		if (status < 0)
 			break;
 
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index b2a939f8..a3c7623 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -331,8 +331,6 @@ typedef enum fe_rolloff {
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
-	ROLLOFF_15,	/* DVB-C Annex A */
-	ROLLOFF_13,	/* DVB-C Annex C */
 } fe_rolloff_t;
 
 typedef enum fe_delivery_system {
-- 
1.7.8

