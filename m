Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35202 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932122AbdC2QnY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:24 -0400
Received: by mail-wr0-f193.google.com with SMTP id p52so4573520wrc.2
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 07/13] [media] dvb-frontends/stv0367: support reading if_khz from tuner config
Date: Wed, 29 Mar 2017 18:43:07 +0200
Message-Id: <20170329164313.14636-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Currently, if_khz is set and provided using the configuration var in
struct stv0367_config. However, in some constellations, the value might be
different for differing channel bandwidths or even -T and -C operation.
When e.g. used in conjunction with TDA18212 tuners, the tuner frontend
might be aware of the different freqs. This factors if_khz retrieval in a
function, which checks a new flag if an automatic retrieval attempt should
be made, and if the tuner provides it, use it whenever needed.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 45 +++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 9370afa..74fee3f 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -94,6 +94,7 @@ struct stv0367_state {
 	u8 use_i2c_gatectrl;
 	u8 deftabs;
 	u8 reinit_on_setfrontend;
+	u8 auto_if_khz;
 };
 
 #define RF_LOOKUP_TABLE_SIZE  31
@@ -319,6 +320,17 @@ static void stv0367_pll_setup(struct stv0367_state *state,
 	stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
 }
 
+static int stv0367_get_if_khz(struct stv0367_state *state, u32 *ifkhz)
+{
+	if (state->auto_if_khz && state->fe.ops.tuner_ops.get_if_frequency) {
+		state->fe.ops.tuner_ops.get_if_frequency(&state->fe, ifkhz);
+		*ifkhz = *ifkhz / 1000; /* hz -> khz */
+	} else
+		*ifkhz = state->config->if_khz;
+
+	return 0;
+}
+
 static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -992,10 +1004,12 @@ static int stv0367ter_algo(struct dvb_frontend *fe)
 	u8 /*constell,*/ counter;
 	s8 step;
 	s32 timing_offset = 0;
-	u32 trl_nomrate = 0, InternalFreq = 0, temp = 0;
+	u32 trl_nomrate = 0, InternalFreq = 0, temp = 0, ifkhz = 0;
 
 	dprintk("%s:\n", __func__);
 
+	stv0367_get_if_khz(state, &ifkhz);
+
 	ter_state->frequency = p->frequency;
 	ter_state->force = FE_TER_FORCENONE
 			+ stv0367_readbits(state, F367TER_FORCE) * 2;
@@ -1098,8 +1112,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe)
 			stv0367_readbits(state, F367TER_GAIN_SRC_LO);
 
 	temp = (int)
-		((InternalFreq - state->config->if_khz) * (1 << 16)
-							/ (InternalFreq));
+		((InternalFreq - ifkhz) * (1 << 16) / (InternalFreq));
 
 	dprintk("DEROT temp=0x%x\n", temp);
 	stv0367_writebits(state, F367TER_INC_DEROT_HI, temp / 256);
@@ -1720,6 +1733,7 @@ struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 	state->use_i2c_gatectrl = 1;
 	state->deftabs = STV0367_DEFTAB_GENERIC;
 	state->reinit_on_setfrontend = 1;
+	state->auto_if_khz = 0;
 
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
@@ -2229,7 +2243,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 {
 	struct stv0367cab_state *cab_state = state->cab_state;
 	enum stv0367_cab_signal_type signalType = FE_CAB_NOAGC;
-	u32	QAMFEC_Lock, QAM_Lock, u32_tmp,
+	u32	QAMFEC_Lock, QAM_Lock, u32_tmp, ifkhz,
 		LockTime, TRLTimeOut, AGCTimeOut, CRLSymbols,
 		CRLTimeOut, EQLTimeOut, DemodTimeOut, FECTimeOut;
 	u8	TrackAGCAccum;
@@ -2237,6 +2251,8 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 
 	dprintk("%s:\n", __func__);
 
+	stv0367_get_if_khz(state, &ifkhz);
+
 	/* Timeouts calculation */
 	/* A max lock time of 25 ms is allowed for delayed AGC */
 	AGCTimeOut = 25;
@@ -2315,7 +2331,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	/* The sweep function is never used, Sweep rate must be set to 0 */
 	/* Set the derotator frequency in Hz */
 	stv0367cab_set_derot_freq(state, cab_state->adc_clk,
-		(1000 * (s32)state->config->if_khz + cab_state->derot_offset));
+		(1000 * (s32)ifkhz + cab_state->derot_offset));
 	/* Disable the Allpass Filter when the symbol rate is out of range */
 	if ((p->symbol_rate > 10800000) | (p->symbol_rate < 1800000)) {
 		stv0367_writebits(state, F367CAB_ADJ_EN, 0);
@@ -2405,17 +2421,17 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 							F367CAB_QUAD_INV);
 #if 0
 /* not clear for me */
-		if (state->config->if_khz != 0) {
-			if (state->config->if_khz > cab_state->adc_clk / 1000) {
+		if (ifkhz != 0) {
+			if (ifkhz > cab_state->adc_clk / 1000) {
 				cab_state->freq_khz =
 					FE_Cab_TunerGetFrequency(pIntParams->hTuner)
 				- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
-				- cab_state->adc_clk / 1000 + state->config->if_khz;
+				- cab_state->adc_clk / 1000 + ifkhz;
 			} else {
 				cab_state->freq_khz =
 						FE_Cab_TunerGetFrequency(pIntParams->hTuner)
 						- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
-										+ state->config->if_khz;
+						+ ifkhz;
 			}
 		} else {
 			cab_state->freq_khz =
@@ -2546,11 +2562,13 @@ static int stv0367cab_get_frontend(struct dvb_frontend *fe,
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
+	u32 ifkhz = 0;
 
 	enum stv0367cab_mod QAMSize;
 
 	dprintk("%s:\n", __func__);
 
+	stv0367_get_if_khz(state, &ifkhz);
 	p->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
 
 	QAMSize = stv0367_readbits(state, F367CAB_QAM_MODE);
@@ -2578,19 +2596,19 @@ static int stv0367cab_get_frontend(struct dvb_frontend *fe,
 
 	dprintk("%s: tuner frequency = %d\n", __func__, p->frequency);
 
-	if (state->config->if_khz == 0) {
+	if (ifkhz == 0) {
 		p->frequency +=
 			(stv0367cab_get_derot_freq(state, cab_state->adc_clk) -
 			cab_state->adc_clk / 4000);
 		return 0;
 	}
 
-	if (state->config->if_khz > cab_state->adc_clk / 1000)
-		p->frequency += (state->config->if_khz
+	if (ifkhz > cab_state->adc_clk / 1000)
+		p->frequency += (ifkhz
 			- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
 			- cab_state->adc_clk / 1000);
 	else
-		p->frequency += (state->config->if_khz
+		p->frequency += (ifkhz
 			- stv0367cab_get_derot_freq(state, cab_state->adc_clk));
 
 	return 0;
@@ -2840,6 +2858,7 @@ struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 	state->use_i2c_gatectrl = 1;
 	state->deftabs = STV0367_DEFTAB_GENERIC;
 	state->reinit_on_setfrontend = 1;
+	state->auto_if_khz = 0;
 
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
-- 
2.10.2
