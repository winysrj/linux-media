Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49681 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 21/35] [media] dib7000p: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:53 -0200
Message-Id: <8182ea1bced7dba15d3a9b941afc66a6678017b8.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/dvb-frontends/dib7000p.c | 127 +++++++++++++++++----------------
 1 file changed, 67 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index b861d4437f2a..e38286cd533d 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -7,6 +7,9 @@
  *	modify it under the terms of the GNU General Public License as
  *	published by the Free Software Foundation, version 2.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -26,7 +29,11 @@ static int buggy_sfn_workaround;
 module_param(buggy_sfn_workaround, int, 0644);
 MODULE_PARM_DESC(buggy_sfn_workaround, "Enable work-around for buggy SFNs (default: 0)");
 
-#define dprintk(args...) do { if (debug) { printk(KERN_DEBUG "DiB7000P: "); printk(args); printk("\n"); } } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 struct i2c_device {
 	struct i2c_adapter *i2c_adap;
@@ -98,7 +105,7 @@ static u16 dib7000p_read_word(struct dib7000p_state *state, u16 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -116,7 +123,7 @@ static u16 dib7000p_read_word(struct dib7000p_state *state, u16 reg)
 	state->msg[1].len = 2;
 
 	if (i2c_transfer(state->i2c_adap, state->msg, 2) != 2)
-		dprintk("i2c read error on %d", reg);
+		dprintk("i2c read error on %d\n", reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
 	mutex_unlock(&state->i2c_buffer_lock);
@@ -128,7 +135,7 @@ static int dib7000p_write_word(struct dib7000p_state *state, u16 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -174,7 +181,7 @@ static int dib7000p_set_output_mode(struct dib7000p_state *state, int mode)
 	fifo_threshold = 1792;
 	smo_mode = (dib7000p_read_word(state, 235) & 0x0050) | (1 << 1);
 
-	dprintk("setting output mode for demod %p to %d", &state->demod, mode);
+	dprintk("setting output mode for demod %p to %d\n", &state->demod, mode);
 
 	switch (mode) {
 	case OUTMODE_MPEG2_PAR_GATED_CLK:
@@ -204,7 +211,7 @@ static int dib7000p_set_output_mode(struct dib7000p_state *state, int mode)
 		outreg = 0;
 		break;
 	default:
-		dprintk("Unhandled output_mode passed to be set for demod %p", &state->demod);
+		dprintk("Unhandled output_mode passed to be set for demod %p\n", &state->demod);
 		break;
 	}
 
@@ -224,7 +231,7 @@ static int dib7000p_set_diversity_in(struct dvb_frontend *demod, int onoff)
 	struct dib7000p_state *state = demod->demodulator_priv;
 
 	if (state->div_force_off) {
-		dprintk("diversity combination deactivated - forced by COFDM parameters");
+		dprintk("diversity combination deactivated - forced by COFDM parameters\n");
 		onoff = 0;
 		dib7000p_write_word(state, 207, 0);
 	} else
@@ -374,10 +381,10 @@ static int dib7000p_set_bandwidth(struct dib7000p_state *state, u32 bw)
 	state->current_bandwidth = bw;
 
 	if (state->timf == 0) {
-		dprintk("using default timf");
+		dprintk("using default timf\n");
 		timf = state->cfg.bw->timf;
 	} else {
-		dprintk("using updated timf");
+		dprintk("using updated timf\n");
 		timf = state->timf;
 	}
 
@@ -494,7 +501,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
 	loopdiv = (reg_1856 >> 6) & 0x3f;
 
 	if ((bw != NULL) && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
-		dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)", prediv, bw->pll_prediv, loopdiv, bw->pll_ratio);
+		dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)\n", prediv, bw->pll_prediv, loopdiv, bw->pll_ratio);
 		reg_1856 &= 0xf000;
 		reg_1857 = dib7000p_read_word(state, 1857);
 		dib7000p_write_word(state, 1857, reg_1857 & ~(1 << 15));
@@ -511,7 +518,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
 		dib7000p_write_word(state, 1857, reg_1857 | (1 << 15));
 
 		while (((dib7000p_read_word(state, 1856) >> 15) & 0x1) != 1)
-			dprintk("Waiting for PLL to lock");
+			dprintk("Waiting for PLL to lock\n");
 
 		return 0;
 	}
@@ -521,7 +528,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
 static int dib7000p_reset_gpio(struct dib7000p_state *st)
 {
 	/* reset the GPIOs */
-	dprintk("gpio dir: %x: val: %x, pwm_pos: %x", st->gpio_dir, st->gpio_val, st->cfg.gpio_pwm_pos);
+	dprintk("gpio dir: %x: val: %x, pwm_pos: %x\n", st->gpio_dir, st->gpio_val, st->cfg.gpio_pwm_pos);
 
 	dib7000p_write_word(st, 1029, st->gpio_dir);
 	dib7000p_write_word(st, 1030, st->gpio_val);
@@ -669,7 +676,7 @@ static int dib7000p_demod_reset(struct dib7000p_state *state)
 	dib7000p_reset_pll(state);
 
 	if (dib7000p_reset_gpio(state) != 0)
-		dprintk("GPIO reset was not successful.");
+		dprintk("GPIO reset was not successful.\n");
 
 	if (state->version == SOC7090) {
 		dib7000p_write_word(state, 899, 0);
@@ -681,7 +688,7 @@ static int dib7000p_demod_reset(struct dib7000p_state *state)
 		dib7000p_write_word(state, 273, (0<<6) | 30);
 	}
 	if (dib7000p_set_output_mode(state, OUTMODE_HIGH_Z) != 0)
-		dprintk("OUTPUT_MODE could not be reset.");
+		dprintk("OUTPUT_MODE could not be reset.\n");
 
 	dib7000p_set_adc_state(state, DIBX000_SLOW_ADC_ON);
 	dib7000p_sad_calib(state);
@@ -759,7 +766,7 @@ static int dib7000p_set_agc_config(struct dib7000p_state *state, u8 band)
 		}
 
 	if (agc == NULL) {
-		dprintk("no valid AGC configuration found for band 0x%02x", band);
+		dprintk("no valid AGC configuration found for band 0x%02x\n", band);
 		return -EINVAL;
 	}
 
@@ -776,7 +783,7 @@ static int dib7000p_set_agc_config(struct dib7000p_state *state, u8 band)
 	dib7000p_write_word(state, 102, (agc->beta_mant << 6) | agc->beta_exp);
 
 	/* AGC continued */
-	dprintk("WBD: ref: %d, sel: %d, active: %d, alpha: %d",
+	dprintk("WBD: ref: %d, sel: %d, active: %d, alpha: %d\n",
 		state->wbd_ref != 0 ? state->wbd_ref : agc->wbd_ref, agc->wbd_sel, !agc->perform_agc_softsplit, agc->wbd_sel);
 
 	if (state->wbd_ref != 0)
@@ -806,7 +813,7 @@ static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
 	u32 dds = state->cfg.bw->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.bw->ifreq & (1 << 25));
 
-	dprintk("setting a frequency offset of %dkHz internal freq = %d invert = %d", offset_khz, internal, invert);
+	dprintk("setting a frequency offset of %dkHz internal freq = %d invert = %d\n", offset_khz, internal, invert);
 
 	if (offset_khz < 0)
 		unit_khz_dds_val *= -1;
@@ -902,7 +909,7 @@ static int dib7000p_agc_startup(struct dvb_frontend *demod)
 
 		dib7000p_restart_agc(state);
 
-		dprintk("SPLIT %p: %hd", demod, agc_split);
+		dprintk("SPLIT %p: %hd\n", demod, agc_split);
 
 		(*agc_state)++;
 		ret = 5;
@@ -934,7 +941,7 @@ static void dib7000p_update_timf(struct dib7000p_state *state)
 	state->timf = timf * 160 / (state->current_bandwidth / 50);
 	dib7000p_write_word(state, 23, (u16) (timf >> 16));
 	dib7000p_write_word(state, 24, (u16) (timf & 0xffff));
-	dprintk("updated timf_frequency: %d (default: %d)", state->timf, state->cfg.bw->timf);
+	dprintk("updated timf_frequency: %d (default: %d)\n", state->timf, state->cfg.bw->timf);
 
 }
 
@@ -1202,7 +1209,7 @@ static void dib7000p_spur_protect(struct dib7000p_state *state, u32 rf_khz, u32
 	int bw_khz = bw;
 	u32 pha;
 
-	dprintk("relative position of the Spur: %dk (RF: %dk, XTAL: %dk)", f_rel, rf_khz, xtal);
+	dprintk("relative position of the Spur: %dk (RF: %dk, XTAL: %dk)\n", f_rel, rf_khz, xtal);
 
 	if (f_rel < -bw_khz / 2 || f_rel > bw_khz / 2)
 		return;
@@ -1252,7 +1259,7 @@ static void dib7000p_spur_protect(struct dib7000p_state *state, u32 rf_khz, u32
 			coef_im[k] = (1 << 24) - 1;
 		coef_im[k] /= (1 << 15);
 
-		dprintk("PALF COEF: %d re: %d im: %d", k, coef_re[k], coef_im[k]);
+		dprintk("PALF COEF: %d re: %d im: %d\n", k, coef_re[k], coef_im[k]);
 
 		dib7000p_write_word(state, 143, (0 << 14) | (k << 10) | (coef_re[k] & 0x3ff));
 		dib7000p_write_word(state, 144, coef_im[k] & 0x3ff);
@@ -1280,7 +1287,7 @@ static int dib7000p_tune(struct dvb_frontend *demod)
 	/* P_ctrl_inh_cor=0, P_ctrl_alpha_cor=4, P_ctrl_inh_isi=0, P_ctrl_alpha_isi=3, P_ctrl_inh_cor4=1, P_ctrl_alpha_cor4=3 */
 	tmp = (0 << 14) | (4 << 10) | (0 << 9) | (3 << 5) | (1 << 4) | (0x3);
 	if (state->sfn_workaround_active) {
-		dprintk("SFN workaround is active");
+		dprintk("SFN workaround is active\n");
 		tmp |= (1 << 9);
 		dib7000p_write_word(state, 166, 0x4000);
 	} else {
@@ -1390,15 +1397,15 @@ static int dib7000p_sleep(struct dvb_frontend *demod)
 static int dib7000p_identify(struct dib7000p_state *st)
 {
 	u16 value;
-	dprintk("checking demod on I2C address: %d (%x)", st->i2c_addr, st->i2c_addr);
+	dprintk("checking demod on I2C address: %d (%x)\n", st->i2c_addr, st->i2c_addr);
 
 	if ((value = dib7000p_read_word(st, 768)) != 0x01b3) {
-		dprintk("wrong Vendor ID (read=0x%x)", value);
+		dprintk("wrong Vendor ID (read=0x%x)\n", value);
 		return -EREMOTEIO;
 	}
 
 	if ((value = dib7000p_read_word(st, 769)) != 0x4000) {
-		dprintk("wrong Device ID (%x)", value);
+		dprintk("wrong Device ID (%x)\n", value);
 		return -EREMOTEIO;
 	}
 
@@ -1536,7 +1543,7 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe)
 			found = dib7000p_autosearch_is_irq(fe);
 		} while (found == 0 && i--);
 
-		dprintk("autosearch returns: %d", found);
+		dprintk("autosearch returns: %d\n", found);
 		if (found == 0 || found == 1)
 			return 0;
 
@@ -1951,7 +1958,7 @@ static int dib7000p_get_stats(struct dvb_frontend *demod, enum fe_status stat)
 		time_us = dib7000p_get_time_us(demod);
 		state->ber_jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
 
-		dprintk("Next all layers stats available in %u us.", time_us);
+		dprintk("Next all layers stats available in %u us.\n", time_us);
 
 		dib7000p_read_ber(demod, &val);
 		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
@@ -2019,7 +2026,7 @@ static int dib7000pc_detection(struct i2c_adapter *i2c_adap)
 
 	if (i2c_transfer(i2c_adap, msg, 2) == 2)
 		if (rx[0] == 0x01 && rx[1] == 0xb3) {
-			dprintk("-D-  DiB7000PC detected");
+			dprintk("-D-  DiB7000PC detected\n");
 			return 1;
 		}
 
@@ -2027,11 +2034,11 @@ static int dib7000pc_detection(struct i2c_adapter *i2c_adap)
 
 	if (i2c_transfer(i2c_adap, msg, 2) == 2)
 		if (rx[0] == 0x01 && rx[1] == 0xb3) {
-			dprintk("-D-  DiB7000PC detected");
+			dprintk("-D-  DiB7000PC detected\n");
 			return 1;
 		}
 
-	dprintk("-D-  DiB7000PC not detected");
+	dprintk("-D-  DiB7000PC not detected\n");
 
 	kfree(rx);
 rx_memory_error:
@@ -2050,14 +2057,14 @@ static int dib7000p_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 val = dib7000p_read_word(state, 235) & 0xffef;
 	val |= (onoff & 0x1) << 4;
-	dprintk("PID filter enabled %d", onoff);
+	dprintk("PID filter enabled %d\n", onoff);
 	return dib7000p_write_word(state, 235, val);
 }
 
 static int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
-	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
+	dprintk("PID filter: index %x, PID %d, OnOff %d\n", id, pid, onoff);
 	return dib7000p_write_word(state, 241 + id, onoff ? (1 << 13) | pid : 0);
 }
 
@@ -2100,7 +2107,7 @@ static int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u
 		/* set new i2c address and force divstart */
 		dib7000p_write_word(dpst, 1285, (new_addr << 2) | 0x2);
 
-		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
+		dprintk("IC %d initialized (to i2c_address 0x%x)\n", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
@@ -2136,21 +2143,21 @@ static s32 dib7000p_get_adc_power(struct dvb_frontend *fe)
 	buf[0] = dib7000p_read_word(state, 0x184);
 	buf[1] = dib7000p_read_word(state, 0x185);
 	pow_i = (buf[0] << 16) | buf[1];
-	dprintk("raw pow_i = %d", pow_i);
+	dprintk("raw pow_i = %d\n", pow_i);
 
 	tmp_val = pow_i;
 	while (tmp_val >>= 1)
 		exp++;
 
 	mant = (pow_i * 1000 / (1 << exp));
-	dprintk(" mant = %d exp = %d", mant / 1000, exp);
+	dprintk(" mant = %d exp = %d\n", mant / 1000, exp);
 
 	ix = (u8) ((mant - 1000) / 100);	/* index of the LUT */
-	dprintk(" ix = %d", ix);
+	dprintk(" ix = %d\n", ix);
 
 	pow_i = (lut_1000ln_mant[ix] + 693 * (exp - 20) - 6908);
 	pow_i = (pow_i << 8) / 1000;
-	dprintk(" pow_i = %d", pow_i);
+	dprintk(" pow_i = %d\n", pow_i);
 
 	return pow_i;
 }
@@ -2185,7 +2192,7 @@ static int w7090p_tuner_write_serpar(struct i2c_adapter *i2c_adap, struct i2c_ms
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
 		i--;
 		if (i == 0)
-			dprintk("Tuner ITF: write busy (overflow)");
+			dprintk("Tuner ITF: write busy (overflow)\n");
 	}
 	dib7000p_write_word(state, 1985, (1 << 6) | (serpar_num & 0x3f));
 	dib7000p_write_word(state, 1986, (msg[0].buf[1] << 8) | msg[0].buf[2]);
@@ -2205,7 +2212,7 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
 		i--;
 		if (i == 0)
-			dprintk("TunerITF: read busy (overflow)");
+			dprintk("TunerITF: read busy (overflow)\n");
 	}
 	dib7000p_write_word(state, 1985, (0 << 6) | (serpar_num & 0x3f));
 
@@ -2214,7 +2221,7 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 		n_empty = dib7000p_read_word(state, 1984) & 0x1;
 		i--;
 		if (i == 0)
-			dprintk("TunerITF: read busy (empty)");
+			dprintk("TunerITF: read busy (empty)\n");
 	}
 	read_word = dib7000p_read_word(state, 1987);
 	msg[1].buf[0] = (read_word >> 8) & 0xff;
@@ -2435,7 +2442,7 @@ static u32 dib7090_calcSyncFreq(u32 P_Kin, u32 P_Kout, u32 insertExtSynchro, u32
 
 static int dib7090_cfg_DibTx(struct dib7000p_state *state, u32 P_Kin, u32 P_Kout, u32 insertExtSynchro, u32 synchroMode, u32 syncWord, u32 syncSize)
 {
-	dprintk("Configure DibStream Tx");
+	dprintk("Configure DibStream Tx\n");
 
 	dib7000p_write_word(state, 1615, 1);
 	dib7000p_write_word(state, 1603, P_Kin);
@@ -2455,7 +2462,7 @@ static int dib7090_cfg_DibRx(struct dib7000p_state *state, u32 P_Kin, u32 P_Kout
 {
 	u32 syncFreq;
 
-	dprintk("Configure DibStream Rx");
+	dprintk("Configure DibStream Rx\n");
 	if ((P_Kin != 0) && (P_Kout != 0)) {
 		syncFreq = dib7090_calcSyncFreq(P_Kin, P_Kout, insertExtSynchro, syncSize);
 		dib7000p_write_word(state, 1542, syncFreq);
@@ -2492,7 +2499,7 @@ static void dib7090_enMpegMux(struct dib7000p_state *state, int onoff)
 static void dib7090_configMpegMux(struct dib7000p_state *state,
 		u16 pulseWidth, u16 enSerialMode, u16 enSerialClkDiv2)
 {
-	dprintk("Enable Mpeg mux");
+	dprintk("Enable Mpeg mux\n");
 
 	dib7090_enMpegMux(state, 0);
 
@@ -2513,17 +2520,17 @@ static void dib7090_setDibTxMux(struct dib7000p_state *state, int mode)
 
 	switch (mode) {
 	case MPEG_ON_DIBTX:
-			dprintk("SET MPEG ON DIBSTREAM TX");
+			dprintk("SET MPEG ON DIBSTREAM TX\n");
 			dib7090_cfg_DibTx(state, 8, 5, 0, 0, 0, 0);
 			reg_1288 |= (1<<9);
 			break;
 	case DIV_ON_DIBTX:
-			dprintk("SET DIV_OUT ON DIBSTREAM TX");
+			dprintk("SET DIV_OUT ON DIBSTREAM TX\n");
 			dib7090_cfg_DibTx(state, 5, 5, 0, 0, 0, 0);
 			reg_1288 |= (1<<8);
 			break;
 	case ADC_ON_DIBTX:
-			dprintk("SET ADC_OUT ON DIBSTREAM TX");
+			dprintk("SET ADC_OUT ON DIBSTREAM TX\n");
 			dib7090_cfg_DibTx(state, 20, 5, 10, 0, 0, 0);
 			reg_1288 |= (1<<7);
 			break;
@@ -2539,17 +2546,17 @@ static void dib7090_setHostBusMux(struct dib7000p_state *state, int mode)
 
 	switch (mode) {
 	case DEMOUT_ON_HOSTBUS:
-			dprintk("SET DEM OUT OLD INTERF ON HOST BUS");
+			dprintk("SET DEM OUT OLD INTERF ON HOST BUS\n");
 			dib7090_enMpegMux(state, 0);
 			reg_1288 |= (1<<6);
 			break;
 	case DIBTX_ON_HOSTBUS:
-			dprintk("SET DIBSTREAM TX ON HOST BUS");
+			dprintk("SET DIBSTREAM TX ON HOST BUS\n");
 			dib7090_enMpegMux(state, 0);
 			reg_1288 |= (1<<5);
 			break;
 	case MPEG_ON_HOSTBUS:
-			dprintk("SET MPEG MUX ON HOST BUS");
+			dprintk("SET MPEG MUX ON HOST BUS\n");
 			reg_1288 |= (1<<4);
 			break;
 	default:
@@ -2565,7 +2572,7 @@ static int dib7090_set_diversity_in(struct dvb_frontend *fe, int onoff)
 
 	switch (onoff) {
 	case 0: /* only use the internal way - not the diversity input */
-			dprintk("%s mode OFF : by default Enable Mpeg INPUT", __func__);
+			dprintk("%s mode OFF : by default Enable Mpeg INPUT\n", __func__);
 			dib7090_cfg_DibRx(state, 8, 5, 0, 0, 0, 8, 0);
 
 			/* Do not divide the serial clock of MPEG MUX */
@@ -2581,7 +2588,7 @@ static int dib7090_set_diversity_in(struct dvb_frontend *fe, int onoff)
 			break;
 	case 1: /* both ways */
 	case 2: /* only the diversity input */
-			dprintk("%s ON : Enable diversity INPUT", __func__);
+			dprintk("%s ON : Enable diversity INPUT\n", __func__);
 			dib7090_cfg_DibRx(state, 5, 5, 0, 0, 0, 0, 0);
 			state->input_mode_mpeg = 0;
 			break;
@@ -2612,11 +2619,11 @@ static int dib7090_set_output_mode(struct dvb_frontend *fe, int mode)
 
 	case OUTMODE_MPEG2_SERIAL:
 		if (prefer_mpeg_mux_use) {
-			dprintk("setting output mode TS_SERIAL using Mpeg Mux");
+			dprintk("setting output mode TS_SERIAL using Mpeg Mux\n");
 			dib7090_configMpegMux(state, 3, 1, 1);
 			dib7090_setHostBusMux(state, MPEG_ON_HOSTBUS);
 		} else {/* Use Smooth block */
-			dprintk("setting output mode TS_SERIAL using Smooth bloc");
+			dprintk("setting output mode TS_SERIAL using Smooth bloc\n");
 			dib7090_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 			outreg |= (2<<6) | (0 << 1);
 		}
@@ -2624,24 +2631,24 @@ static int dib7090_set_output_mode(struct dvb_frontend *fe, int mode)
 
 	case OUTMODE_MPEG2_PAR_GATED_CLK:
 		if (prefer_mpeg_mux_use) {
-			dprintk("setting output mode TS_PARALLEL_GATED using Mpeg Mux");
+			dprintk("setting output mode TS_PARALLEL_GATED using Mpeg Mux\n");
 			dib7090_configMpegMux(state, 2, 0, 0);
 			dib7090_setHostBusMux(state, MPEG_ON_HOSTBUS);
 		} else { /* Use Smooth block */
-			dprintk("setting output mode TS_PARALLEL_GATED using Smooth block");
+			dprintk("setting output mode TS_PARALLEL_GATED using Smooth block\n");
 			dib7090_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 			outreg |= (0<<6);
 		}
 		break;
 
 	case OUTMODE_MPEG2_PAR_CONT_CLK:	/* Using Smooth block only */
-		dprintk("setting output mode TS_PARALLEL_CONT using Smooth block");
+		dprintk("setting output mode TS_PARALLEL_CONT using Smooth block\n");
 		dib7090_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 		outreg |= (1<<6);
 		break;
 
 	case OUTMODE_MPEG2_FIFO:	/* Using Smooth block because not supported by new Mpeg Mux bloc */
-		dprintk("setting output mode TS_FIFO using Smooth block");
+		dprintk("setting output mode TS_FIFO using Smooth block\n");
 		dib7090_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 		outreg |= (5<<6);
 		smo_mode |= (3 << 1);
@@ -2649,13 +2656,13 @@ static int dib7090_set_output_mode(struct dvb_frontend *fe, int mode)
 		break;
 
 	case OUTMODE_DIVERSITY:
-		dprintk("setting output mode MODE_DIVERSITY");
+		dprintk("setting output mode MODE_DIVERSITY\n");
 		dib7090_setDibTxMux(state, DIV_ON_DIBTX);
 		dib7090_setHostBusMux(state, DIBTX_ON_HOSTBUS);
 		break;
 
 	case OUTMODE_ANALOG_ADC:
-		dprintk("setting output mode MODE_ANALOG_ADC");
+		dprintk("setting output mode MODE_ANALOG_ADC\n");
 		dib7090_setDibTxMux(state, ADC_ON_DIBTX);
 		dib7090_setHostBusMux(state, DIBTX_ON_HOSTBUS);
 		break;
@@ -2678,7 +2685,7 @@ static int dib7090_tuner_sleep(struct dvb_frontend *fe, int onoff)
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 en_cur_state;
 
-	dprintk("sleep dib7090: %d", onoff);
+	dprintk("sleep dib7090: %d\n", onoff);
 
 	en_cur_state = dib7000p_read_word(state, 1922);
 
-- 
2.7.4


