Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:39883 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdLYED1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Dec 2017 23:03:27 -0500
Received: by mail-qk0-f195.google.com with SMTP id u184so40674149qkd.6
        for <linux-media@vger.kernel.org>; Sun, 24 Dec 2017 20:03:27 -0800 (PST)
From: Dan Gopstein <dgopstein@nyu.edu>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Dan Gopstein <dgopstein@nyu.edu>
Subject: [PATCH v3] media: ABS macro parameter parenthesization
Date: Sun, 24 Dec 2017 23:03:08 -0500
Message-Id: <1514174588-22694-1-git-send-email-dgopstein@nyu.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Gopstein <dgopstein@nyu.edu>

Replace usages of the locally defined ABS() macro with calls to the
canonical abs() from kernel.h and remove the old definitions of ABS()

Signed-off-by: Dan Gopstein <dgopstein@nyu.edu>
---
v2->v3:
* replace local ABS() with kernel's abs()

v1->v2:
* unmangled the patch
* added example to commit text

 drivers/media/dvb-frontends/dib0090.c        | 4 ++--
 drivers/media/dvb-frontends/dib7000p.c       | 2 +-
 drivers/media/dvb-frontends/dib8000.c        | 2 +-
 drivers/media/dvb-frontends/dibx000_common.h | 2 --
 drivers/media/dvb-frontends/mb86a16.c        | 8 +++-----
 drivers/media/dvb-frontends/stv0367_priv.h   | 1 -
 drivers/media/dvb-frontends/stv0900_priv.h   | 1 -
 drivers/media/dvb-frontends/stv0900_sw.c     | 6 +++---
 8 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index d9d730d..633a961 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1285,7 +1285,7 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 #endif
 
 			if (*tune_state == CT_AGC_STEP_1) {	/* quickly go to the correct range of the ADC power */
-				if (ABS(adc_error) < 50 || state->agc_step++ > 5) {
+				if (abs(adc_error) < 50 || state->agc_step++ > 5) {
 
 #ifdef CONFIG_STANDARD_DAB
 					if (state->fe->dtv_property_cache.delivery_system == STANDARD_DAB) {
@@ -1754,7 +1754,7 @@ static int dib0090_dc_offset_calibration(struct dib0090_state *state, enum front
 			*tune_state = CT_TUNER_STEP_1;
 		} else {
 			/* the minimum was what we have seen in the step before */
-			if (ABS(state->adc_diff) > ABS(state->min_adc_diff)) {
+			if (abs(state->adc_diff) > abs(state->min_adc_diff)) {
 				dprintk("Since adc_diff N = %d  > adc_diff step N-1 = %d, Come back one step\n", state->adc_diff, state->min_adc_diff);
 				state->step--;
 			}
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 0fbaabe..6fc34b3 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -809,7 +809,7 @@ static int dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
 {
 	u32 internal = dib7000p_get_internal_freq(state);
 	s32 unit_khz_dds_val;
-	u32 abs_offset_khz = ABS(offset_khz);
+	u32 abs_offset_khz = abs(offset_khz);
 	u32 dds = state->cfg.bw->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.bw->ifreq & (1 << 25));
 	if (internal == 0) {
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 5d93815..4680a8b 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2677,7 +2677,7 @@ static void dib8000_viterbi_state(struct dib8000_state *state, u8 onoff)
 static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 {
 	s16 unit_khz_dds_val;
-	u32 abs_offset_khz = ABS(offset_khz);
+	u32 abs_offset_khz = abs(offset_khz);
 	u32 dds = state->cfg.pll->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.pll->ifreq & (1 << 25));
 	u8 ratio;
diff --git a/drivers/media/dvb-frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
index 8784af9..12b58f5 100644
--- a/drivers/media/dvb-frontends/dibx000_common.h
+++ b/drivers/media/dvb-frontends/dibx000_common.h
@@ -223,8 +223,6 @@ struct dvb_frontend_parametersContext {
 
 #define FE_CALLBACK_TIME_NEVER 0xffffffff
 
-#define ABS(x) ((x < 0) ? (-x) : (x))
-
 #define DATA_BUS_ACCESS_MODE_8BIT                 0x01
 #define DATA_BUS_ACCESS_MODE_16BIT                0x02
 #define DATA_BUS_ACCESS_MODE_NO_ADDRESS_INCREMENT 0x10
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index dfe322e..ced59f9 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -31,8 +31,6 @@
 static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 
-#define ABS(x)		((x) < 0 ? (-x) : (x))
-
 struct mb86a16_state {
 	struct i2c_adapter		*i2c_adap;
 	const struct mb86a16_config	*config;
@@ -1201,12 +1199,12 @@ static int mb86a16_set_fe(struct mb86a16_state *state)
 
 			signal_dupl = 0;
 			for (j = 0; j < prev_freq_num; j++) {
-				if ((ABS(prev_swp_freq[j] - swp_freq)) < (swp_ofs * 3 / 2)) {
+				if ((abs(prev_swp_freq[j] - swp_freq)) < (swp_ofs * 3 / 2)) {
 					signal_dupl = 1;
 					dprintk(verbose, MB86A16_INFO, 1, "Probably Duplicate Signal, j = %d", j);
 				}
 			}
-			if ((signal_dupl == 0) && (swp_freq > 0) && (ABS(swp_freq - state->frequency * 1000) < fcp + state->srate / 6)) {
+			if ((signal_dupl == 0) && (swp_freq > 0) && (abs(swp_freq - state->frequency * 1000) < fcp + state->srate / 6)) {
 				dprintk(verbose, MB86A16_DEBUG, 1, "------ Signal detect ------ [swp_freq=[%07d, srate=%05d]]", swp_freq, state->srate);
 				prev_swp_freq[prev_freq_num] = swp_freq;
 				prev_freq_num++;
@@ -1380,7 +1378,7 @@ static int mb86a16_set_fe(struct mb86a16_state *state)
 			dprintk(verbose, MB86A16_INFO, 1, "SWEEP Frequency = %d", swp_freq);
 			swp_freq += delta_freq;
 			dprintk(verbose, MB86A16_INFO, 1, "Adjusting .., DELTA Freq = %d, SWEEP Freq=%d", delta_freq, swp_freq);
-			if (ABS(state->frequency * 1000 - swp_freq) > 3800) {
+			if (abs(state->frequency * 1000 - swp_freq) > 3800) {
 				dprintk(verbose, MB86A16_INFO, 1, "NO  --  SIGNAL !");
 			} else {
 
diff --git a/drivers/media/dvb-frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
index 8abc451..460066a 100644
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -35,7 +35,6 @@
 #endif
 
 /* MACRO definitions */
-#define ABS(X) ((X) < 0 ? (-1 * (X)) : (X))
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
 #define INRANGE(X, Y, Z) \
diff --git a/drivers/media/dvb-frontends/stv0900_priv.h b/drivers/media/dvb-frontends/stv0900_priv.h
index 7a95f95..97c1237 100644
--- a/drivers/media/dvb-frontends/stv0900_priv.h
+++ b/drivers/media/dvb-frontends/stv0900_priv.h
@@ -24,7 +24,6 @@
 
 #include <linux/i2c.h>
 
-#define ABS(X) ((X) < 0 ? (-1 * (X)) : (X))
 #define INRANGE(X, Y, Z) ((((X) <= (Y)) && ((Y) <= (Z))) \
 		|| (((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
 
diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index c97a391..d406c83 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1255,14 +1255,14 @@ fe_stv0900_signal_type stv0900_get_signal_params(struct dvb_frontend *fe)
 		else
 			intp->freq[d] = stv0900_get_tuner_freq(fe);
 
-		if (ABS(offsetFreq) <= ((intp->srch_range[d] / 2000) + 500))
+		if (abs(offsetFreq) <= ((intp->srch_range[d] / 2000) + 500))
 			range = STV0900_RANGEOK;
-		else if (ABS(offsetFreq) <=
+		else if (abs(offsetFreq) <=
 				(stv0900_carrier_width(result->symbol_rate,
 						result->rolloff) / 2000))
 			range = STV0900_RANGEOK;
 
-	} else if (ABS(offsetFreq) <= ((intp->srch_range[d] / 2000) + 500))
+	} else if (abs(offsetFreq) <= ((intp->srch_range[d] / 2000) + 500))
 		range = STV0900_RANGEOK;
 
 	dprintk("%s: range %d\n", __func__, range);
-- 
2.7.4
