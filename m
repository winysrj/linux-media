Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KTO42 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:28 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuRJT018474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/8] [media] Properly implement ITU-T J.88 Annex C support
Date: Sun, 20 Nov 2011 12:56:12 -0200
Message-Id: <1321800978-27912-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Annex C support were broken with the previous implementation,
as, at xc5000 and tda18271c2dd, it were choosing the wrong bandwidth
for some symbol rates.

At DRX-J, it were always selecting Annex A, even having Annex C
support coded there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc5000.c       |   26 +++++++++++-----------
 drivers/media/dvb/frontends/drxk_hard.c    |    7 ++++++
 drivers/media/dvb/frontends/tda18271c2dd.c |   32 ++++++++++++++-------------
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index aa1b2e8..88b329c 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -628,20 +628,12 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
 }
 
-/*
- * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
- * So, the amount of the needed bandwith is given by:
- * 	Bw = Symbol_rate * (1 + 0.15)
- * As such, the maximum symbol rate supported by 6 MHz is given by:
- *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
- */
-#define MAX_SYMBOL_RATE_6MHz	5217391
-
 static int xc5000_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
+	u32 bw;
 
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
@@ -707,11 +699,19 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 			dprintk(1, "%s() QAM modulation\n", __func__);
 			priv->rf_mode = XC_RF_MODE_CABLE;
 			/*
-			 * Using a 8MHz bandwidth sometimes fail
-			 * with 6MHz-spaced channels, due to inter-carrier
-			 * interference. So, use DTV6 firmware
+			 * Using a higher bandwidth at the tuner filter may
+			 * allow inter-carrier interference.
+			 * So, determine the minimal channel spacing, in order
+			 * to better adjust the tuner filter.
+			 * According with ITU-T J.83, the bandwidth is given by:
+			 * bw = Simbol Rate * (1 + roll_off), where the roll_off
+			 * is equal to 0.15 for Annex A, and 0.13 for annex C
 			 */
-			if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz) {
+			if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
+				bw = (params->u.qam.symbol_rate * 13) / 10;
+			else
+				bw = (params->u.qam.symbol_rate * 15) / 10;
+			if (bw <= 6000000) {
 				priv->bandwidth = BANDWIDTH_6_MHZ;
 				priv->video_standard = DTV6;
 				priv->freq_hz = params->frequency - 1750000;
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index f6431ef..dc13fd8 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6218,6 +6218,13 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
+	if (state->m_OperationMode == OM_QAM_ITU_A ||
+	    state->m_OperationMode == OM_QAM_ITU_C) {
+		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
+			state->m_OperationMode = OM_QAM_ITU_C;
+		else
+			state->m_OperationMode = OM_QAM_ITU_A;
+	}
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 1b1bf20..de544f6 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1123,20 +1123,6 @@ static int release(struct dvb_frontend *fe)
 	return 0;
 }
 
-/*
- * As defined on EN 300 429 Annex A and on ITU-T J.83 annex A, the DVB-C
- * roll-off factor is 0.15.
- * According with the specs, the amount of the needed bandwith is given by:
- *	Bw = Symbol_rate * (1 + 0.15)
- * As such, the maximum symbol rate supported by 6 MHz is
- *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
- *NOTE: For ITU-T J.83 Annex C, the roll-off factor is 0.13. So:
- *	max_symbol_rate = 6 MHz / 1.13 = 5309735 Baud
- *	That means that an adjustment is needed for Japan,
- *	but, as currently DRX-K is hardcoded to Annex A, let's stick
- *	with 0.15 roll-off factor.
- */
-#define MAX_SYMBOL_RATE_6MHz	5217391
 
 static int set_params(struct dvb_frontend *fe,
 		      struct dvb_frontend_parameters *params)
@@ -1144,6 +1130,7 @@ static int set_params(struct dvb_frontend *fe,
 	struct tda_state *state = fe->tuner_priv;
 	int status = 0;
 	int Standard;
+	u32 bw;
 
 	state->m_Frequency = params->frequency;
 
@@ -1161,8 +1148,23 @@ static int set_params(struct dvb_frontend *fe,
 			break;
 		}
 	else if (fe->ops.info.type == FE_QAM) {
-		if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz)
+		/*
+		 * Using a higher bandwidth at the tuner filter may
+		 * allow inter-carrier interference.
+		 * So, determine the minimal channel spacing, in order
+		 * to better adjust the tuner filter.
+		 * According with ITU-T J.83, the bandwidth is given by:
+		 * bw = Simbol Rate * (1 + roll_off), where the roll_off
+		 * is equal to 0.15 for Annex A, and 0.13 for annex C
+		 */
+		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
+			bw = (params->u.qam.symbol_rate * 13) / 10;
+		else
+			bw = (params->u.qam.symbol_rate * 15) / 10;
+		if (bw <= 6000000)
 			Standard = HF_DVBC_6MHZ;
+		else if (bw <= 7000000)
+			Standard = HF_DVBC_7MHZ;
 		else
 			Standard = HF_DVBC_8MHZ;
 	} else
-- 
1.7.7.1

