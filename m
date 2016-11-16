Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49689 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 20/35] [media] dib7000m: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:52 -0200
Message-Id: <4a5a79f4d18298e67413359806329a47266fd66d.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/dvb-frontends/dib7000m.c | 73 +++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index b3ddae8885ac..910a6dcf8a1d 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -8,6 +8,9 @@
  *	modify it under the terms of the GNU General Public License as
  *	published by the Free Software Foundation, version 2.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -21,7 +24,11 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 
-#define dprintk(args...) do { if (debug) { printk(KERN_DEBUG "DiB7000M: "); printk(args); printk("\n"); } } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 struct dib7000m_state {
 	struct dvb_frontend demod;
@@ -74,7 +81,7 @@ static u16 dib7000m_read_word(struct dib7000m_state *state, u16 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -92,7 +99,7 @@ static u16 dib7000m_read_word(struct dib7000m_state *state, u16 reg)
 	state->msg[1].len = 2;
 
 	if (i2c_transfer(state->i2c_adap, state->msg, 2) != 2)
-		dprintk("i2c read error on %d",reg);
+		dprintk("i2c read error on %d\n",reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
 	mutex_unlock(&state->i2c_buffer_lock);
@@ -105,7 +112,7 @@ static int dib7000m_write_word(struct dib7000m_state *state, u16 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -154,7 +161,7 @@ static int dib7000m_set_output_mode(struct dib7000m_state *state, int mode)
 	fifo_threshold = 1792;
 	smo_mode = (dib7000m_read_word(state, 294 + state->reg_offs) & 0x0010) | (1 << 1);
 
-	dprintk( "setting output mode for demod %p to %d", &state->demod, mode);
+	dprintk("setting output mode for demod %p to %d\n", &state->demod, mode);
 
 	switch (mode) {
 		case OUTMODE_MPEG2_PAR_GATED_CLK:   // STBs with parallel gated clock
@@ -181,7 +188,7 @@ static int dib7000m_set_output_mode(struct dib7000m_state *state, int mode)
 			outreg = 0;
 			break;
 		default:
-			dprintk( "Unhandled output_mode passed to be set for demod %p",&state->demod);
+			dprintk("Unhandled output_mode passed to be set for demod %p\n",&state->demod);
 			break;
 	}
 
@@ -302,7 +309,7 @@ static int dib7000m_set_adc_state(struct dib7000m_state *state, enum dibx000_adc
 			break;
 	}
 
-//	dprintk( "913: %x, 914: %x", reg_913, reg_914);
+//	dprintk("913: %x, 914: %x\n", reg_913, reg_914);
 	ret |= dib7000m_write_word(state, 913, reg_913);
 	ret |= dib7000m_write_word(state, 914, reg_914);
 
@@ -320,10 +327,10 @@ static int dib7000m_set_bandwidth(struct dib7000m_state *state, u32 bw)
 	state->current_bandwidth = bw;
 
 	if (state->timf == 0) {
-		dprintk( "using default timf");
+		dprintk("using default timf\n");
 		timf = state->timf_default;
 	} else {
-		dprintk( "using updated timf");
+		dprintk("using updated timf\n");
 		timf = state->timf;
 	}
 
@@ -340,7 +347,7 @@ static int dib7000m_set_diversity_in(struct dvb_frontend *demod, int onoff)
 	struct dib7000m_state *state = demod->demodulator_priv;
 
 	if (state->div_force_off) {
-		dprintk( "diversity combination deactivated - forced by COFDM parameters");
+		dprintk("diversity combination deactivated - forced by COFDM parameters\n");
 		onoff = 0;
 	}
 	state->div_state = (u8)onoff;
@@ -580,10 +587,10 @@ static int dib7000m_demod_reset(struct dib7000m_state *state)
 		dib7000mc_reset_pll(state);
 
 	if (dib7000m_reset_gpio(state) != 0)
-		dprintk( "GPIO reset was not successful.");
+		dprintk("GPIO reset was not successful.\n");
 
 	if (dib7000m_set_output_mode(state, OUTMODE_HIGH_Z) != 0)
-		dprintk( "OUTPUT_MODE could not be reset.");
+		dprintk("OUTPUT_MODE could not be reset.\n");
 
 	/* unforce divstr regardless whether i2c enumeration was done or not */
 	dib7000m_write_word(state, 1794, dib7000m_read_word(state, 1794) & ~(1 << 1) );
@@ -650,7 +657,7 @@ static int dib7000m_agc_soft_split(struct dib7000m_state *state)
 			(agc - state->current_agc->split.min_thres) /
 			(state->current_agc->split.max_thres - state->current_agc->split.min_thres);
 
-	dprintk( "AGC split_offset: %d",split_offset);
+	dprintk("AGC split_offset: %d\n",split_offset);
 
 	// P_agc_force_split and P_agc_split_offset
 	return dib7000m_write_word(state, 103, (dib7000m_read_word(state, 103) & 0xff00) | split_offset);
@@ -687,7 +694,7 @@ static int dib7000m_set_agc_config(struct dib7000m_state *state, u8 band)
 		}
 
 	if (agc == NULL) {
-		dprintk( "no valid AGC configuration found for band 0x%02x",band);
+		dprintk("no valid AGC configuration found for band 0x%02x\n",band);
 		return -EINVAL;
 	}
 
@@ -703,7 +710,7 @@ static int dib7000m_set_agc_config(struct dib7000m_state *state, u8 band)
 	dib7000m_write_word(state, 98, (agc->alpha_mant << 5) | agc->alpha_exp);
 	dib7000m_write_word(state, 99, (agc->beta_mant  << 6) | agc->beta_exp);
 
-	dprintk( "WBD: ref: %d, sel: %d, active: %d, alpha: %d",
+	dprintk("WBD: ref: %d, sel: %d, active: %d, alpha: %d\n",
 		state->wbd_ref != 0 ? state->wbd_ref : agc->wbd_ref, agc->wbd_sel, !agc->perform_agc_softsplit, agc->wbd_sel);
 
 	/* AGC continued */
@@ -724,7 +731,7 @@ static int dib7000m_set_agc_config(struct dib7000m_state *state, u8 band)
 
 	if (state->revision > 0x4000) { // settings for the MC
 		dib7000m_write_word(state, 71,   agc->agc1_pt3);
-//		dprintk( "929: %x %d %d",
+//		dprintk("929: %x %d %d\n",
 //			(dib7000m_read_word(state, 929) & 0xffe3) | (agc->wbd_inv << 4) | (agc->wbd_sel << 2), agc->wbd_inv, agc->wbd_sel);
 		dib7000m_write_word(state, 929, (dib7000m_read_word(state, 929) & 0xffe3) | (agc->wbd_inv << 4) | (agc->wbd_sel << 2));
 	} else {
@@ -742,7 +749,7 @@ static void dib7000m_update_timf(struct dib7000m_state *state)
 	state->timf = timf * 160 / (state->current_bandwidth / 50);
 	dib7000m_write_word(state, 23, (u16) (timf >> 16));
 	dib7000m_write_word(state, 24, (u16) (timf & 0xffff));
-	dprintk( "updated timf_frequency: %d (default: %d)",state->timf, state->timf_default);
+	dprintk("updated timf_frequency: %d (default: %d)\n",state->timf, state->timf_default);
 }
 
 static int dib7000m_agc_startup(struct dvb_frontend *demod)
@@ -804,7 +811,7 @@ static int dib7000m_agc_startup(struct dvb_frontend *demod)
 
 			dib7000m_restart_agc(state);
 
-			dprintk( "SPLIT %p: %hd", demod, agc_split);
+			dprintk("SPLIT %p: %hd\n", demod, agc_split);
 
 			(*agc_state)++;
 			ret = 5;
@@ -1013,12 +1020,12 @@ static int dib7000m_autosearch_irq(struct dib7000m_state *state, u16 reg)
 	u16 irq_pending = dib7000m_read_word(state, reg);
 
 	if (irq_pending & 0x1) { // failed
-		dprintk( "autosearch failed");
+		dprintk("autosearch failed\n");
 		return 1;
 	}
 
 	if (irq_pending & 0x2) { // succeeded
-		dprintk( "autosearch succeeded");
+		dprintk("autosearch succeeded\n");
 		return 2;
 	}
 	return 0; // still pending
@@ -1102,7 +1109,7 @@ static int dib7000m_wakeup(struct dvb_frontend *demod)
 	dib7000m_set_power_mode(state, DIB7000M_POWER_ALL);
 
 	if (dib7000m_set_adc_state(state, DIBX000_SLOW_ADC_ON) != 0)
-		dprintk( "could not start Slow ADC");
+		dprintk("could not start Slow ADC\n");
 
 	return 0;
 }
@@ -1121,7 +1128,7 @@ static int dib7000m_identify(struct dib7000m_state *state)
 	u16 value;
 
 	if ((value = dib7000m_read_word(state, 896)) != 0x01b3) {
-		dprintk( "wrong Vendor ID (0x%x)",value);
+		dprintk("wrong Vendor ID (0x%x)\n",value);
 		return -EREMOTEIO;
 	}
 
@@ -1130,21 +1137,21 @@ static int dib7000m_identify(struct dib7000m_state *state)
 		state->revision != 0x4001 &&
 		state->revision != 0x4002 &&
 		state->revision != 0x4003) {
-		dprintk( "wrong Device ID (0x%x)",value);
+		dprintk("wrong Device ID (0x%x)\n",value);
 		return -EREMOTEIO;
 	}
 
 	/* protect this driver to be used with 7000PC */
 	if (state->revision == 0x4000 && dib7000m_read_word(state, 769) == 0x4000) {
-		dprintk( "this driver does not work with DiB7000PC");
+		dprintk("this driver does not work with DiB7000PC\n");
 		return -EREMOTEIO;
 	}
 
 	switch (state->revision) {
-		case 0x4000: dprintk( "found DiB7000MA/PA/MB/PB"); break;
-		case 0x4001: state->reg_offs = 1; dprintk( "found DiB7000HC"); break;
-		case 0x4002: state->reg_offs = 1; dprintk( "found DiB7000MC"); break;
-		case 0x4003: state->reg_offs = 1; dprintk( "found DiB9000"); break;
+		case 0x4000: dprintk("found DiB7000MA/PA/MB/PB\n"); break;
+		case 0x4001: state->reg_offs = 1; dprintk("found DiB7000HC\n"); break;
+		case 0x4002: state->reg_offs = 1; dprintk("found DiB7000MC\n"); break;
+		case 0x4003: state->reg_offs = 1; dprintk("found DiB9000\n"); break;
 	}
 
 	return 0;
@@ -1242,7 +1249,7 @@ static int dib7000m_set_frontend(struct dvb_frontend *fe)
 			found = dib7000m_autosearch_is_irq(fe);
 		} while (found == 0 && i--);
 
-		dprintk("autosearch returns: %d",found);
+		dprintk("autosearch returns: %d\n",found);
 		if (found == 0 || found == 1)
 			return 0; // no channel found
 
@@ -1330,7 +1337,7 @@ int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	struct dib7000m_state *state = fe->demodulator_priv;
 	u16 val = dib7000m_read_word(state, 294 + state->reg_offs) & 0xffef;
 	val |= (onoff & 0x1) << 4;
-	dprintk("PID filter enabled %d", onoff);
+	dprintk("PID filter enabled %d\n", onoff);
 	return dib7000m_write_word(state, 294 + state->reg_offs, val);
 }
 EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
@@ -1338,7 +1345,7 @@ EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
 int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
 	struct dib7000m_state *state = fe->demodulator_priv;
-	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
+	dprintk("PID filter: index %x, PID %d, OnOff %d\n", id, pid, onoff);
 	return dib7000m_write_word(state, 300 + state->reg_offs + id,
 			onoff ? (1 << 13) | pid : 0);
 }
@@ -1362,7 +1369,7 @@ int dib7000m_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
 		if (dib7000m_identify(&st) != 0) {
 			st.i2c_addr = default_addr;
 			if (dib7000m_identify(&st) != 0) {
-				dprintk("DiB7000M #%d: not identified", k);
+				dprintk("DiB7000M #%d: not identified\n", k);
 				return -EIO;
 			}
 		}
@@ -1375,7 +1382,7 @@ int dib7000m_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
 		/* set new i2c address and force divstart */
 		dib7000m_write_word(&st, 1794, (new_addr << 2) | 0x2);
 
-		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
+		dprintk("IC %d initialized (to i2c_address 0x%x)\n", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-- 
2.7.4


