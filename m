Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49701 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753804AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/35] [media] dib0090: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:49 -0200
Message-Id: <d8f78c773d144bccc678ecc5f3b49764e14b180d.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dprintk() macro relies on continuation lines. This is not
a good practice and will break after commit 563873318d32
("Merge branch 'printk-cleanups").

So, instead of directly calling printk(), use pr_foo() macros,
adding a \n leading char on each macro call.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dib0090.c | 164 +++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 81 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 14c403254fe0..c07508319106 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -24,6 +24,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -38,13 +40,11 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 
-#define dprintk(args...) do { \
-	if (debug) { \
-		printk(KERN_DEBUG "DiB0090: "); \
-		printk(args); \
-		printk("\n"); \
-	} \
-} while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 #define CONFIG_SYS_DVBT
 #define CONFIG_SYS_ISDBT
@@ -218,7 +218,7 @@ static u16 dib0090_read_reg(struct dib0090_state *state, u8 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -235,7 +235,7 @@ static u16 dib0090_read_reg(struct dib0090_state *state, u8 reg)
 	state->msg[1].len = 2;
 
 	if (i2c_transfer(state->i2c, state->msg, 2) != 2) {
-		printk(KERN_WARNING "DiB0090 I2C read failed\n");
+		pr_warn("DiB0090 I2C read failed\n");
 		ret = 0;
 	} else
 		ret = (state->i2c_read_buffer[0] << 8)
@@ -250,7 +250,7 @@ static int dib0090_write_reg(struct dib0090_state *state, u32 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -265,7 +265,7 @@ static int dib0090_write_reg(struct dib0090_state *state, u32 reg, u16 val)
 	state->msg[0].len = 3;
 
 	if (i2c_transfer(state->i2c, state->msg, 1) != 1) {
-		printk(KERN_WARNING "DiB0090 I2C write failed\n");
+		pr_warn("DiB0090 I2C write failed\n");
 		ret = -EREMOTEIO;
 	} else
 		ret = 0;
@@ -279,7 +279,7 @@ static u16 dib0090_fw_read_reg(struct dib0090_fw_state *state, u8 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -291,7 +291,7 @@ static u16 dib0090_fw_read_reg(struct dib0090_fw_state *state, u8 reg)
 	state->msg.buf = state->i2c_read_buffer;
 	state->msg.len = 2;
 	if (i2c_transfer(state->i2c, &state->msg, 1) != 1) {
-		printk(KERN_WARNING "DiB0090 I2C read failed\n");
+		pr_warn("DiB0090 I2C read failed\n");
 		ret = 0;
 	} else
 		ret = (state->i2c_read_buffer[0] << 8)
@@ -306,7 +306,7 @@ static int dib0090_fw_write_reg(struct dib0090_fw_state *state, u8 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -319,7 +319,7 @@ static int dib0090_fw_write_reg(struct dib0090_fw_state *state, u8 reg, u16 val)
 	state->msg.buf = state->i2c_write_buffer;
 	state->msg.len = 2;
 	if (i2c_transfer(state->i2c, &state->msg, 1) != 1) {
-		printk(KERN_WARNING "DiB0090 I2C write failed\n");
+		pr_warn("DiB0090 I2C write failed\n");
 		ret = -EREMOTEIO;
 	} else
 		ret = 0;
@@ -351,7 +351,7 @@ static int dib0090_identify(struct dvb_frontend *fe)
 	identity->p1g = 0;
 	identity->in_soc = 0;
 
-	dprintk("Tuner identification (Version = 0x%04x)", v);
+	dprintk("Tuner identification (Version = 0x%04x)\n", v);
 
 	/* without PLL lock info */
 	v &= ~KROSUS_PLL_LOCKED;
@@ -366,19 +366,19 @@ static int dib0090_identify(struct dvb_frontend *fe)
 		identity->in_soc = 1;
 		switch (identity->version) {
 		case SOC_8090_P1G_11R1:
-			dprintk("SOC 8090 P1-G11R1 Has been detected");
+			dprintk("SOC 8090 P1-G11R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_8090_P1G_21R1:
-			dprintk("SOC 8090 P1-G21R1 Has been detected");
+			dprintk("SOC 8090 P1-G21R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_7090_P1G_11R1:
-			dprintk("SOC 7090 P1-G11R1 Has been detected");
+			dprintk("SOC 7090 P1-G11R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_7090_P1G_21R1:
-			dprintk("SOC 7090 P1-G21R1 Has been detected");
+			dprintk("SOC 7090 P1-G21R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		default:
@@ -387,16 +387,16 @@ static int dib0090_identify(struct dvb_frontend *fe)
 	} else {
 		switch ((identity->version >> 5) & 0x7) {
 		case MP001:
-			dprintk("MP001 : 9090/8096");
+			dprintk("MP001 : 9090/8096\n");
 			break;
 		case MP005:
-			dprintk("MP005 : Single Sband");
+			dprintk("MP005 : Single Sband\n");
 			break;
 		case MP008:
-			dprintk("MP008 : diversity VHF-UHF-LBAND");
+			dprintk("MP008 : diversity VHF-UHF-LBAND\n");
 			break;
 		case MP009:
-			dprintk("MP009 : diversity 29098 CBAND-UHF-LBAND-SBAND");
+			dprintk("MP009 : diversity 29098 CBAND-UHF-LBAND-SBAND\n");
 			break;
 		default:
 			goto identification_error;
@@ -404,21 +404,21 @@ static int dib0090_identify(struct dvb_frontend *fe)
 
 		switch (identity->version & 0x1f) {
 		case P1G_21R2:
-			dprintk("P1G_21R2 detected");
+			dprintk("P1G_21R2 detected\n");
 			identity->p1g = 1;
 			break;
 		case P1G:
-			dprintk("P1G detected");
+			dprintk("P1G detected\n");
 			identity->p1g = 1;
 			break;
 		case P1D_E_F:
-			dprintk("P1D/E/F detected");
+			dprintk("P1D/E/F detected\n");
 			break;
 		case P1C:
-			dprintk("P1C detected");
+			dprintk("P1C detected\n");
 			break;
 		case P1A_B:
-			dprintk("P1-A/B detected: driver is deactivated - not available");
+			dprintk("P1-A/B detected: driver is deactivated - not available\n");
 			goto identification_error;
 			break;
 		default:
@@ -441,7 +441,7 @@ static int dib0090_fw_identify(struct dvb_frontend *fe)
 	identity->p1g = 0;
 	identity->in_soc = 0;
 
-	dprintk("FE: Tuner identification (Version = 0x%04x)", v);
+	dprintk("FE: Tuner identification (Version = 0x%04x)\n", v);
 
 	/* without PLL lock info */
 	v &= ~KROSUS_PLL_LOCKED;
@@ -456,19 +456,19 @@ static int dib0090_fw_identify(struct dvb_frontend *fe)
 		identity->in_soc = 1;
 		switch (identity->version) {
 		case SOC_8090_P1G_11R1:
-			dprintk("SOC 8090 P1-G11R1 Has been detected");
+			dprintk("SOC 8090 P1-G11R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_8090_P1G_21R1:
-			dprintk("SOC 8090 P1-G21R1 Has been detected");
+			dprintk("SOC 8090 P1-G21R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_7090_P1G_11R1:
-			dprintk("SOC 7090 P1-G11R1 Has been detected");
+			dprintk("SOC 7090 P1-G11R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		case SOC_7090_P1G_21R1:
-			dprintk("SOC 7090 P1-G21R1 Has been detected");
+			dprintk("SOC 7090 P1-G21R1 Has been detected\n");
 			identity->p1g = 1;
 			break;
 		default:
@@ -477,16 +477,16 @@ static int dib0090_fw_identify(struct dvb_frontend *fe)
 	} else {
 		switch ((identity->version >> 5) & 0x7) {
 		case MP001:
-			dprintk("MP001 : 9090/8096");
+			dprintk("MP001 : 9090/8096\n");
 			break;
 		case MP005:
-			dprintk("MP005 : Single Sband");
+			dprintk("MP005 : Single Sband\n");
 			break;
 		case MP008:
-			dprintk("MP008 : diversity VHF-UHF-LBAND");
+			dprintk("MP008 : diversity VHF-UHF-LBAND\n");
 			break;
 		case MP009:
-			dprintk("MP009 : diversity 29098 CBAND-UHF-LBAND-SBAND");
+			dprintk("MP009 : diversity 29098 CBAND-UHF-LBAND-SBAND\n");
 			break;
 		default:
 			goto identification_error;
@@ -494,21 +494,21 @@ static int dib0090_fw_identify(struct dvb_frontend *fe)
 
 		switch (identity->version & 0x1f) {
 		case P1G_21R2:
-			dprintk("P1G_21R2 detected");
+			dprintk("P1G_21R2 detected\n");
 			identity->p1g = 1;
 			break;
 		case P1G:
-			dprintk("P1G detected");
+			dprintk("P1G detected\n");
 			identity->p1g = 1;
 			break;
 		case P1D_E_F:
-			dprintk("P1D/E/F detected");
+			dprintk("P1D/E/F detected\n");
 			break;
 		case P1C:
-			dprintk("P1C detected");
+			dprintk("P1C detected\n");
 			break;
 		case P1A_B:
-			dprintk("P1-A/B detected: driver is deactivated - not available");
+			dprintk("P1-A/B detected: driver is deactivated - not available\n");
 			goto identification_error;
 			break;
 		default:
@@ -574,7 +574,7 @@ static void dib0090_reset_digital(struct dvb_frontend *fe, const struct dib0090_
 		} while (--i);
 
 		if (i == 0) {
-			dprintk("Pll: Unable to lock Pll");
+			dprintk("Pll: Unable to lock Pll\n");
 			return;
 		}
 
@@ -596,7 +596,7 @@ static int dib0090_fw_reset_digital(struct dvb_frontend *fe, const struct dib009
 	u16 v;
 	int i;
 
-	dprintk("fw reset digital");
+	dprintk("fw reset digital\n");
 	HARD_RESET(state);
 
 	dib0090_fw_write_reg(state, 0x24, EN_PLL | EN_CRYSTAL);
@@ -645,7 +645,7 @@ static int dib0090_fw_reset_digital(struct dvb_frontend *fe, const struct dib009
 		} while (--i);
 
 		if (i == 0) {
-			dprintk("Pll: Unable to lock Pll");
+			dprintk("Pll: Unable to lock Pll\n");
 			return -EIO;
 		}
 
@@ -922,7 +922,7 @@ static void dib0090_wbd_target(struct dib0090_state *state, u32 rf)
 #endif
 
 	state->wbd_target = dib0090_wbd_to_db(state, state->wbd_offset + offset);
-	dprintk("wbd-target: %d dB", (u32) state->wbd_target);
+	dprintk("wbd-target: %d dB\n", (u32) state->wbd_target);
 }
 
 static const int gain_reg_addr[4] = {
@@ -1019,7 +1019,7 @@ static void dib0090_gain_apply(struct dib0090_state *state, s16 gain_delta, s16
 	gain_reg[3] |= ((bb % 10) * 100) / 125;
 
 #ifdef DEBUG_AGC
-	dprintk("GA CALC: DB: %3d(rf) + %3d(bb) = %3d gain_reg[0]=%04x gain_reg[1]=%04x gain_reg[2]=%04x gain_reg[0]=%04x", rf, bb, rf + bb,
+	dprintk("GA CALC: DB: %3d(rf) + %3d(bb) = %3d gain_reg[0]=%04x gain_reg[1]=%04x gain_reg[2]=%04x gain_reg[0]=%04x\n", rf, bb, rf + bb,
 		gain_reg[0], gain_reg[1], gain_reg[2], gain_reg[3]);
 #endif
 
@@ -1050,7 +1050,7 @@ static void dib0090_set_rframp_pwm(struct dib0090_state *state, const u16 * cfg)
 
 	dib0090_write_reg(state, 0x2a, 0xffff);
 
-	dprintk("total RF gain: %ddB, step: %d", (u32) cfg[0], dib0090_read_reg(state, 0x2a));
+	dprintk("total RF gain: %ddB, step: %d\n", (u32) cfg[0], dib0090_read_reg(state, 0x2a));
 
 	dib0090_write_regs(state, 0x2c, cfg + 3, 6);
 	dib0090_write_regs(state, 0x3e, cfg + 9, 2);
@@ -1069,7 +1069,7 @@ static void dib0090_set_bbramp_pwm(struct dib0090_state *state, const u16 * cfg)
 	dib0090_set_boost(state, cfg[0] > 500);	/* we want the boost if the gain is higher that 50dB */
 
 	dib0090_write_reg(state, 0x33, 0xffff);
-	dprintk("total BB gain: %ddB, step: %d", (u32) cfg[0], dib0090_read_reg(state, 0x33));
+	dprintk("total BB gain: %ddB, step: %d\n", (u32) cfg[0], dib0090_read_reg(state, 0x33));
 	dib0090_write_regs(state, 0x35, cfg + 3, 4);
 }
 
@@ -1122,7 +1122,7 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 
 		/* activate the ramp generator using PWM control */
 		if (state->rf_ramp)
-			dprintk("ramp RF gain = %d BAND = %s version = %d",
+			dprintk("ramp RF gain = %d BAND = %s version = %d\n",
 				state->rf_ramp[0],
 				(state->current_band == BAND_CBAND) ? "CBAND" : "NOT CBAND",
 				state->identity.version & 0x1f);
@@ -1130,10 +1130,10 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 		if (rf_ramp && ((state->rf_ramp && state->rf_ramp[0] == 0) ||
 		    (state->current_band == BAND_CBAND &&
 		    (state->identity.version & 0x1f) <= P1D_E_F))) {
-			dprintk("DE-Engage mux for direct gain reg control");
+			dprintk("DE-Engage mux for direct gain reg control\n");
 			en_pwm_rf_mux = 0;
 		} else
-			dprintk("Engage mux for PWM control");
+			dprintk("Engage mux for PWM control\n");
 
 		dib0090_write_reg(state, 0x32, (en_pwm_rf_mux << 12) | (en_pwm_rf_mux << 11));
 
@@ -1352,7 +1352,7 @@ u16 dib0090_get_wbd_target(struct dvb_frontend *fe)
 	while (f_MHz > wbd->max_freq)
 		wbd++;
 
-	dprintk("using wbd-table-entry with max freq %d", wbd->max_freq);
+	dprintk("using wbd-table-entry with max freq %d\n", wbd->max_freq);
 
 	if (current_temp < 0)
 		current_temp = 0;
@@ -1373,8 +1373,8 @@ u16 dib0090_get_wbd_target(struct dvb_frontend *fe)
 	wbd_tcold += ((wbd_thot - wbd_tcold) * current_temp) >> 7;
 
 	state->wbd_target = dib0090_wbd_to_db(state, state->wbd_offset + wbd_tcold);
-	dprintk("wbd-target: %d dB", (u32) state->wbd_target);
-	dprintk("wbd offset applied is %d", wbd_tcold);
+	dprintk("wbd-target: %d dB\n", (u32) state->wbd_target);
+	dprintk("wbd offset applied is %d\n", wbd_tcold);
 
 	return state->wbd_offset + wbd_tcold;
 }
@@ -1415,7 +1415,7 @@ int dib0090_update_rframp_7090(struct dvb_frontend *fe, u8 cfg_sensitivity)
 	if ((!state->identity.p1g) || (!state->identity.in_soc)
 			|| ((state->identity.version != SOC_7090_P1G_21R1)
 				&& (state->identity.version != SOC_7090_P1G_11R1))) {
-		dprintk("%s() function can only be used for dib7090P", __func__);
+		dprintk("%s() function can only be used for dib7090P\n", __func__);
 		return -ENODEV;
 	}
 
@@ -1598,7 +1598,7 @@ static int dib0090_reset(struct dvb_frontend *fe)
 		dib0090_write_reg(state, 0x14, 1);
 	else
 		dib0090_write_reg(state, 0x14, 2);
-	dprintk("Pll lock : %d", (dib0090_read_reg(state, 0x1a) >> 11) & 0x1);
+	dprintk("Pll lock : %d\n", (dib0090_read_reg(state, 0x1a) >> 11) & 0x1);
 
 	state->calibrate = DC_CAL | WBD_CAL | TEMP_CAL;	/* enable iq-offset-calibration and wbd-calibration when tuning next time */
 
@@ -1711,7 +1711,8 @@ static int dib0090_dc_offset_calibration(struct dib0090_state *state, enum front
 
 		/* fall through */
 	case CT_TUNER_STEP_0:
-		dprintk("Start/continue DC calibration for %s path", (state->dc->i == 1) ? "I" : "Q");
+		dprintk("Start/continue DC calibration for %s path\n",
+			(state->dc->i == 1) ? "I" : "Q");
 		dib0090_write_reg(state, 0x01, state->dc->bb1);
 		dib0090_write_reg(state, 0x07, state->bb7 | (state->dc->i << 7));
 
@@ -1733,13 +1734,13 @@ static int dib0090_dc_offset_calibration(struct dib0090_state *state, enum front
 		break;
 
 	case CT_TUNER_STEP_5:	/* found an offset */
-		dprintk("adc_diff = %d, current step= %d", (u32) state->adc_diff, state->step);
+		dprintk("adc_diff = %d, current step= %d\n", (u32) state->adc_diff, state->step);
 		if (state->step == 0 && state->adc_diff < 0) {
 			state->min_adc_diff = -1023;
-			dprintk("Change of sign of the minimum adc diff");
+			dprintk("Change of sign of the minimum adc diff\n");
 		}
 
-		dprintk("adc_diff = %d, min_adc_diff = %d current_step = %d", state->adc_diff, state->min_adc_diff, state->step);
+		dprintk("adc_diff = %d, min_adc_diff = %d current_step = %d\n", state->adc_diff, state->min_adc_diff, state->step);
 
 		/* first turn for this frequency */
 		if (state->step == 0) {
@@ -1758,12 +1759,12 @@ static int dib0090_dc_offset_calibration(struct dib0090_state *state, enum front
 		} else {
 			/* the minimum was what we have seen in the step before */
 			if (ABS(state->adc_diff) > ABS(state->min_adc_diff)) {
-				dprintk("Since adc_diff N = %d  > adc_diff step N-1 = %d, Come back one step", state->adc_diff, state->min_adc_diff);
+				dprintk("Since adc_diff N = %d  > adc_diff step N-1 = %d, Come back one step\n", state->adc_diff, state->min_adc_diff);
 				state->step--;
 			}
 
 			dib0090_set_trim(state);
-			dprintk("BB Offset Cal, BBreg=%hd,Offset=%hd,Value Set=%hd", state->dc->addr, state->adc_diff, state->step);
+			dprintk("BB Offset Cal, BBreg=%hd,Offset=%hd,Value Set=%hd\n", state->dc->addr, state->adc_diff, state->step);
 
 			state->dc++;
 			if (state->dc->addr == 0)	/* done */
@@ -1819,7 +1820,7 @@ static int dib0090_wbd_calibration(struct dib0090_state *state, enum frontend_tu
 
 	case CT_TUNER_STEP_0:
 		state->wbd_offset = dib0090_get_slow_adc_val(state);
-		dprintk("WBD calibration offset = %d", state->wbd_offset);
+		dprintk("WBD calibration offset = %d\n", state->wbd_offset);
 		*tune_state = CT_TUNER_START;	/* reset done -> real tuning can now begin */
 		state->calibrate &= ~WBD_CAL;
 		break;
@@ -2064,7 +2065,7 @@ int dib0090_update_tuning_table_7090(struct dvb_frontend *fe,
 	if ((!state->identity.p1g) || (!state->identity.in_soc)
 			|| ((state->identity.version != SOC_7090_P1G_21R1)
 				&& (state->identity.version != SOC_7090_P1G_11R1))) {
-		dprintk("%s() function can only be used for dib7090", __func__);
+		dprintk("%s() function can only be used for dib7090\n", __func__);
 		return -ENODEV;
 	}
 
@@ -2098,7 +2099,8 @@ static int dib0090_captrim_search(struct dib0090_state *state, enum frontend_tun
 		force_soft_search = 1;
 
 	if (*tune_state == CT_TUNER_START) {
-		dprintk("Start Captrim search : %s", (force_soft_search == 1) ? "FORCE SOFT SEARCH" : "AUTO");
+		dprintk("Start Captrim search : %s\n",
+			(force_soft_search == 1) ? "FORCE SOFT SEARCH" : "AUTO");
 		dib0090_write_reg(state, 0x10, 0x2B1);
 		dib0090_write_reg(state, 0x1e, 0x0032);
 
@@ -2140,13 +2142,13 @@ static int dib0090_captrim_search(struct dib0090_state *state, enum frontend_tun
 			dib0090_read_reg(state, 0x40);
 
 			state->fcaptrim = dib0090_read_reg(state, 0x18) & 0x7F;
-			dprintk("***Final Captrim= 0x%x", state->fcaptrim);
+			dprintk("***Final Captrim= 0x%x\n", state->fcaptrim);
 			*tune_state = CT_TUNER_STEP_3;
 
 		} else {
 			/* MERGE for all krosus before P1G */
 			adc = dib0090_get_slow_adc_val(state);
-			dprintk("CAPTRIM=%d; ADC = %d (ADC) & %dmV", (u32) state->captrim, (u32) adc, (u32) (adc) * (u32) 1800 / (u32) 1024);
+			dprintk("CAPTRIM=%d; ADC = %d (ADC) & %dmV\n", (u32) state->captrim, (u32) adc, (u32) (adc) * (u32) 1800 / (u32) 1024);
 
 			if (state->rest == 0 || state->identity.in_soc) {	/* Just for 8090P SOCS where auto captrim HW bug : TO CHECK IN ACI for SOCS !!! if 400 for 8090p SOC => tune issue !!! */
 				adc_target = 200;
@@ -2162,7 +2164,7 @@ static int dib0090_captrim_search(struct dib0090_state *state, enum frontend_tun
 			}
 
 			if (adc < state->adc_diff) {
-				dprintk("CAPTRIM=%d is closer to target (%d/%d)", (u32) state->captrim, (u32) adc, (u32) state->adc_diff);
+				dprintk("CAPTRIM=%d is closer to target (%d/%d)\n", (u32) state->captrim, (u32) adc, (u32) state->adc_diff);
 				state->adc_diff = adc;
 				state->fcaptrim = state->captrim;
 			}
@@ -2216,7 +2218,7 @@ static int dib0090_get_temperature(struct dib0090_state *state, enum frontend_tu
 		val = dib0090_get_slow_adc_val(state);
 		state->temperature = ((s16) ((val - state->adc_diff) * 180) >> 8) + 55;
 
-		dprintk("temperature: %d C", state->temperature - 30);
+		dprintk("temperature: %d C\n", state->temperature - 30);
 
 		*tune_state = CT_TUNER_STEP_2;
 		break;
@@ -2478,13 +2480,13 @@ static int dib0090_tune(struct dvb_frontend *fe)
 			wbd++;
 
 		dib0090_write_reg(state, 0x1e, 0x07ff);
-		dprintk("Final Captrim: %d", (u32) state->fcaptrim);
-		dprintk("HFDIV code: %d", (u32) pll->hfdiv_code);
-		dprintk("VCO = %d", (u32) pll->vco_band);
-		dprintk("VCOF in kHz: %d ((%d*%d) << 1))", (u32) ((pll->hfdiv * state->rf_request) * 2), (u32) pll->hfdiv, (u32) state->rf_request);
-		dprintk("REFDIV: %d, FREF: %d", (u32) 1, (u32) state->config->io.clock_khz);
-		dprintk("FBDIV: %d, Rest: %d", (u32) dib0090_read_reg(state, 0x15), (u32) dib0090_read_reg(state, 0x17));
-		dprintk("Num: %d, Den: %d, SD: %d", (u32) dib0090_read_reg(state, 0x17), (u32) (dib0090_read_reg(state, 0x16) >> 8),
+		dprintk("Final Captrim: %d\n", (u32) state->fcaptrim);
+		dprintk("HFDIV code: %d\n", (u32) pll->hfdiv_code);
+		dprintk("VCO = %d\n", (u32) pll->vco_band);
+		dprintk("VCOF in kHz: %d ((%d*%d) << 1))\n", (u32) ((pll->hfdiv * state->rf_request) * 2), (u32) pll->hfdiv, (u32) state->rf_request);
+		dprintk("REFDIV: %d, FREF: %d\n", (u32) 1, (u32) state->config->io.clock_khz);
+		dprintk("FBDIV: %d, Rest: %d\n", (u32) dib0090_read_reg(state, 0x15), (u32) dib0090_read_reg(state, 0x17));
+		dprintk("Num: %d, Den: %d, SD: %d\n", (u32) dib0090_read_reg(state, 0x17), (u32) (dib0090_read_reg(state, 0x16) >> 8),
 			(u32) dib0090_read_reg(state, 0x1c) & 0x3);
 
 #define WBD     0x781		/* 1 1 1 1 0000 0 0 1 */
@@ -2498,7 +2500,7 @@ static int dib0090_tune(struct dvb_frontend *fe)
 		dib0090_write_reg(state, 0x10, state->wbdmux);
 
 		if ((tune->tuner_enable == EN_CAB) && state->identity.p1g) {
-			dprintk("P1G : The cable band is selected and lna_tune = %d", tune->lna_tune);
+			dprintk("P1G : The cable band is selected and lna_tune = %d\n", tune->lna_tune);
 			dib0090_write_reg(state, 0x09, tune->lna_bias);
 			dib0090_write_reg(state, 0x0b, 0xb800 | (tune->lna_tune << 6) | (tune->switch_trim));
 		} else
@@ -2643,7 +2645,7 @@ struct dvb_frontend *dib0090_register(struct dvb_frontend *fe, struct i2c_adapte
 	if (dib0090_reset(fe) != 0)
 		goto free_mem;
 
-	printk(KERN_INFO "DiB0090: successfully identified\n");
+	pr_info("DiB0090: successfully identified\n");
 	memcpy(&fe->ops.tuner_ops, &dib0090_ops, sizeof(struct dvb_tuner_ops));
 
 	return fe;
@@ -2670,7 +2672,7 @@ struct dvb_frontend *dib0090_fw_register(struct dvb_frontend *fe, struct i2c_ada
 	if (dib0090_fw_reset_digital(fe, st->config) != 0)
 		goto free_mem;
 
-	dprintk("DiB0090 FW: successfully identified");
+	dprintk("DiB0090 FW: successfully identified\n");
 	memcpy(&fe->ops.tuner_ops, &dib0090_fw_ops, sizeof(struct dvb_tuner_ops));
 
 	return fe;
-- 
2.7.4


