Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753823AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 22/35] [media] dib8000: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:54 -0200
Message-Id: <d7e12366463b1ccb7d001a94fd1fed1c75961cfb.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/dvb-frontends/dib8000.c | 261 +++++++++++++++++-----------------
 1 file changed, 134 insertions(+), 127 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index ddf9c44877a2..215bba390a9f 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -7,6 +7,9 @@
  *  modify it under the terms of the GNU General Public License as
  *  published by the Free Software Foundation, version 2.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
@@ -31,7 +34,11 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 
-#define dprintk(args...) do { if (debug) { printk(KERN_DEBUG "DiB8000: "); printk(args); printk("\n"); } } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 struct i2c_device {
 	struct i2c_adapter *adap;
@@ -147,7 +154,7 @@ static u16 dib8000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	};
 
 	if (mutex_lock_interruptible(i2c->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -157,7 +164,7 @@ static u16 dib8000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	msg[1].buf    = i2c->i2c_read_buffer;
 
 	if (i2c_transfer(i2c->adap, msg, 2) != 2)
-		dprintk("i2c read error on %d", reg);
+		dprintk("i2c read error on %d\n", reg);
 
 	ret = (msg[1].buf[0] << 8) | msg[1].buf[1];
 	mutex_unlock(i2c->i2c_buffer_lock);
@@ -182,7 +189,7 @@ static u16 __dib8000_read_word(struct dib8000_state *state, u16 reg)
 	state->msg[1].len = 2;
 
 	if (i2c_transfer(state->i2c.adap, state->msg, 2) != 2)
-		dprintk("i2c read error on %d", reg);
+		dprintk("i2c read error on %d\n", reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
 
@@ -194,7 +201,7 @@ static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -210,7 +217,7 @@ static u32 dib8000_read32(struct dib8000_state *state, u16 reg)
 	u16 rw[2];
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -228,7 +235,7 @@ static int dib8000_i2c_write16(struct i2c_device *i2c, u16 reg, u16 val)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(i2c->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -249,7 +256,7 @@ static int dib8000_write_word(struct dib8000_state *state, u16 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 
@@ -395,7 +402,7 @@ static void dib8000_set_acquisition_mode(struct dib8000_state *state)
 {
 	u16 nud = dib8000_read_word(state, 298);
 	nud |= (1 << 3) | (1 << 0);
-	dprintk("acquisition mode activated");
+	dprintk("acquisition mode activated\n");
 	dib8000_write_word(state, 298, nud);
 }
 static int dib8000_set_output_mode(struct dvb_frontend *fe, int mode)
@@ -408,7 +415,7 @@ static int dib8000_set_output_mode(struct dvb_frontend *fe, int mode)
 	fifo_threshold = 1792;
 	smo_mode = (dib8000_read_word(state, 299) & 0x0050) | (1 << 1);
 
-	dprintk("-I-	Setting output mode for demod %p to %d",
+	dprintk("-I-	Setting output mode for demod %p to %d\n",
 			&state->fe[0], mode);
 
 	switch (mode) {
@@ -443,7 +450,7 @@ static int dib8000_set_output_mode(struct dvb_frontend *fe, int mode)
 		break;
 
 	default:
-		dprintk("Unhandled output_mode passed to be set for demod %p",
+		dprintk("Unhandled output_mode passed to be set for demod %p\n",
 				&state->fe[0]);
 		return -EINVAL;
 	}
@@ -464,7 +471,7 @@ static int dib8000_set_diversity_in(struct dvb_frontend *fe, int onoff)
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 tmp, sync_wait = dib8000_read_word(state, 273) & 0xfff0;
 
-	dprintk("set diversity input to %i", onoff);
+	dprintk("set diversity input to %i\n", onoff);
 	if (!state->differential_constellation) {
 		dib8000_write_word(state, 272, 1 << 9);	//dvsy_off_lmod4 = 1
 		dib8000_write_word(state, 273, sync_wait | (1 << 2) | 2);	// sync_enable = 1; comb_mode = 2
@@ -531,7 +538,7 @@ static void dib8000_set_power_mode(struct dib8000_state *state, enum dib8000_pow
 		break;
 	}
 
-	dprintk("powermode : 774 : %x ; 775 : %x; 776 : %x ; 900 : %x; 1280 : %x", reg_774, reg_775, reg_776, reg_900, reg_1280);
+	dprintk("powermode : 774 : %x ; 775 : %x; 776 : %x ; 900 : %x; 1280 : %x\n", reg_774, reg_775, reg_776, reg_900, reg_1280);
 	dib8000_write_word(state, 774, reg_774);
 	dib8000_write_word(state, 775, reg_775);
 	dib8000_write_word(state, 776, reg_776);
@@ -619,10 +626,10 @@ static int dib8000_set_bandwidth(struct dvb_frontend *fe, u32 bw)
 		bw = 6000;
 
 	if (state->timf == 0) {
-		dprintk("using default timf");
+		dprintk("using default timf\n");
 		timf = state->timf_default;
 	} else {
-		dprintk("using updated timf");
+		dprintk("using updated timf\n");
 		timf = state->timf;
 	}
 
@@ -667,7 +674,7 @@ static int dib8000_set_wbd_ref(struct dvb_frontend *fe, u16 value)
 
 static void dib8000_reset_pll_common(struct dib8000_state *state, const struct dibx000_bandwidth_config *bw)
 {
-	dprintk("ifreq: %d %x, inversion: %d", bw->ifreq, bw->ifreq, bw->ifreq >> 25);
+	dprintk("ifreq: %d %x, inversion: %d\n", bw->ifreq, bw->ifreq, bw->ifreq >> 25);
 	if (state->revision != 0x8090) {
 		dib8000_write_word(state, 23,
 				(u16) (((bw->internal * 1000) >> 16) & 0xffff));
@@ -704,7 +711,7 @@ static void dib8000_reset_pll(struct dib8000_state *state)
 		clk_cfg1 = (clk_cfg1 & 0xfff7) | (pll->pll_bypass << 3);
 		dib8000_write_word(state, 902, clk_cfg1);
 
-		dprintk("clk_cfg1: 0x%04x", clk_cfg1);
+		dprintk("clk_cfg1: 0x%04x\n", clk_cfg1);
 
 		/* smpl_cfg: P_refclksel=2, P_ensmplsel=1 nodivsmpl=1 */
 		if (state->cfg.pll->ADClkSrc == 0)
@@ -754,7 +761,7 @@ static int dib8000_update_pll(struct dvb_frontend *fe,
 				pll->pll_ratio == loopdiv))
 		return -EINVAL;
 
-	dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)", prediv, pll->pll_prediv, loopdiv, pll->pll_ratio);
+	dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)\n", prediv, pll->pll_prediv, loopdiv, pll->pll_ratio);
 	if (state->revision == 0x8090) {
 		reg_1856 &= 0xf000;
 		reg_1857 = dib8000_read_word(state, 1857);
@@ -767,11 +774,11 @@ static int dib8000_update_pll(struct dvb_frontend *fe,
 
 		/* write new system clk into P_sec_len */
 		internal = dib8000_read32(state, 23) / 1000;
-		dprintk("Old Internal = %d", internal);
+		dprintk("Old Internal = %d\n", internal);
 		xtal = 2 * (internal / loopdiv) * prediv;
 		internal = 1000 * (xtal/pll->pll_prediv) * pll->pll_ratio;
-		dprintk("Xtal = %d , New Fmem = %d New Fdemod = %d, New Fsampling = %d", xtal, internal/1000, internal/2000, internal/8000);
-		dprintk("New Internal = %d", internal);
+		dprintk("Xtal = %d , New Fmem = %d New Fdemod = %d, New Fsampling = %d\n", xtal, internal/1000, internal/2000, internal/8000);
+		dprintk("New Internal = %d\n", internal);
 
 		dib8000_write_word(state, 23,
 				(u16) (((internal / 2) >> 16) & 0xffff));
@@ -780,22 +787,22 @@ static int dib8000_update_pll(struct dvb_frontend *fe,
 		dib8000_write_word(state, 1857, reg_1857 | (1 << 15));
 
 		while (((dib8000_read_word(state, 1856)>>15)&0x1) != 1)
-			dprintk("Waiting for PLL to lock");
+			dprintk("Waiting for PLL to lock\n");
 
 		/* verify */
 		reg_1856 = dib8000_read_word(state, 1856);
-		dprintk("PLL Updated with prediv = %d and loopdiv = %d",
+		dprintk("PLL Updated with prediv = %d and loopdiv = %d\n",
 				reg_1856&0x3f, (reg_1856>>6)&0x3f);
 	} else {
 		if (bw != state->current_demod_bw) {
 			/** Bandwidth change => force PLL update **/
-			dprintk("PLL: Bandwidth Change %d MHz -> %d MHz (prediv: %d->%d)", state->current_demod_bw / 1000, bw / 1000, oldprediv, state->cfg.pll->pll_prediv);
+			dprintk("PLL: Bandwidth Change %d MHz -> %d MHz (prediv: %d->%d)\n", state->current_demod_bw / 1000, bw / 1000, oldprediv, state->cfg.pll->pll_prediv);
 
 			if (state->cfg.pll->pll_prediv != oldprediv) {
 				/** Full PLL change only if prediv is changed **/
 
 				/** full update => bypass and reconfigure **/
-				dprintk("PLL: New Setting for %d MHz Bandwidth (prediv: %d, ratio: %d)", bw/1000, state->cfg.pll->pll_prediv, state->cfg.pll->pll_ratio);
+				dprintk("PLL: New Setting for %d MHz Bandwidth (prediv: %d, ratio: %d)\n", bw/1000, state->cfg.pll->pll_prediv, state->cfg.pll->pll_ratio);
 				dib8000_write_word(state, 902, dib8000_read_word(state, 902) | (1<<3)); /* bypass PLL */
 				dib8000_reset_pll(state);
 				dib8000_write_word(state, 898, 0x0004); /* sad */
@@ -807,7 +814,7 @@ static int dib8000_update_pll(struct dvb_frontend *fe,
 
 		if (ratio != 0) {
 			/** ratio update => only change ratio **/
-			dprintk("PLL: Update ratio (prediv: %d, ratio: %d)", state->cfg.pll->pll_prediv, ratio);
+			dprintk("PLL: Update ratio (prediv: %d, ratio: %d)\n", state->cfg.pll->pll_prediv, ratio);
 			dib8000_write_word(state, 901, (state->cfg.pll->pll_prediv << 8) | (ratio << 0)); /* only the PLL ratio is updated. */
 		}
 	}
@@ -841,7 +848,7 @@ static int dib8000_cfg_gpio(struct dib8000_state *st, u8 num, u8 dir, u8 val)
 	st->cfg.gpio_val |= (val & 0x01) << num;	/* set the new value */
 	dib8000_write_word(st, 1030, st->cfg.gpio_val);
 
-	dprintk("gpio dir: %x: gpio val: %x", st->cfg.gpio_dir, st->cfg.gpio_val);
+	dprintk("gpio dir: %x: gpio val: %x\n", st->cfg.gpio_dir, st->cfg.gpio_val);
 
 	return 0;
 }
@@ -958,29 +965,29 @@ static u16 dib8000_identify(struct i2c_device *client)
 	value = dib8000_i2c_read16(client, 896);
 
 	if ((value = dib8000_i2c_read16(client, 896)) != 0x01b3) {
-		dprintk("wrong Vendor ID (read=0x%x)", value);
+		dprintk("wrong Vendor ID (read=0x%x)\n", value);
 		return 0;
 	}
 
 	value = dib8000_i2c_read16(client, 897);
 	if (value != 0x8000 && value != 0x8001 &&
 			value != 0x8002 && value != 0x8090) {
-		dprintk("wrong Device ID (%x)", value);
+		dprintk("wrong Device ID (%x)\n", value);
 		return 0;
 	}
 
 	switch (value) {
 	case 0x8000:
-		dprintk("found DiB8000A");
+		dprintk("found DiB8000A\n");
 		break;
 	case 0x8001:
-		dprintk("found DiB8000B");
+		dprintk("found DiB8000B\n");
 		break;
 	case 0x8002:
-		dprintk("found DiB8000C");
+		dprintk("found DiB8000C\n");
 		break;
 	case 0x8090:
-		dprintk("found DiB8096P");
+		dprintk("found DiB8096P\n");
 		break;
 	}
 	return value;
@@ -1037,7 +1044,7 @@ static int dib8000_reset(struct dvb_frontend *fe)
 		dib8000_write_word(state, 1287, 0x0003);
 
 	if (state->revision == 0x8000)
-		dprintk("error : dib8000 MA not supported");
+		dprintk("error : dib8000 MA not supported\n");
 
 	dibx000_reset_i2c_master(&state->i2c_master);
 
@@ -1069,7 +1076,7 @@ static int dib8000_reset(struct dvb_frontend *fe)
 		if (state->cfg.drives)
 			dib8000_write_word(state, 906, state->cfg.drives);
 		else {
-			dprintk("using standard PAD-drive-settings, please adjust settings in config-struct to be optimal.");
+			dprintk("using standard PAD-drive-settings, please adjust settings in config-struct to be optimal.\n");
 			/* min drive SDRAM - not optimal - adjust */
 			dib8000_write_word(state, 906, 0x2d98);
 		}
@@ -1080,11 +1087,11 @@ static int dib8000_reset(struct dvb_frontend *fe)
 		dib8000_write_word(state, 898, 0x0004);
 
 	if (dib8000_reset_gpio(state) != 0)
-		dprintk("GPIO reset was not successful.");
+		dprintk("GPIO reset was not successful.\n");
 
 	if ((state->revision != 0x8090) &&
 			(dib8000_set_output_mode(fe, OUTMODE_HIGH_Z) != 0))
-		dprintk("OUTPUT_MODE could not be resetted.");
+		dprintk("OUTPUT_MODE could not be resetted.\n");
 
 	state->current_agc = NULL;
 
@@ -1176,7 +1183,7 @@ static int dib8000_set_agc_config(struct dib8000_state *state, u8 band)
 		}
 
 	if (agc == NULL) {
-		dprintk("no valid AGC configuration found for band 0x%02x", band);
+		dprintk("no valid AGC configuration found for band 0x%02x\n", band);
 		return -EINVAL;
 	}
 
@@ -1192,7 +1199,7 @@ static int dib8000_set_agc_config(struct dib8000_state *state, u8 band)
 	dib8000_write_word(state, 102, (agc->alpha_mant << 5) | agc->alpha_exp);
 	dib8000_write_word(state, 103, (agc->beta_mant << 6) | agc->beta_exp);
 
-	dprintk("WBD: ref: %d, sel: %d, active: %d, alpha: %d",
+	dprintk("WBD: ref: %d, sel: %d, active: %d, alpha: %d\n",
 		state->wbd_ref != 0 ? state->wbd_ref : agc->wbd_ref, agc->wbd_sel, !agc->perform_agc_softsplit, agc->wbd_sel);
 
 	/* AGC continued */
@@ -1251,7 +1258,7 @@ static int dib8000_agc_soft_split(struct dib8000_state *state)
 			(agc - state->current_agc->split.min_thres) /
 			(state->current_agc->split.max_thres - state->current_agc->split.min_thres);
 
-	dprintk("AGC split_offset: %d", split_offset);
+	dprintk("AGC split_offset: %d\n", split_offset);
 
 	// P_agc_force_split and P_agc_split_offset
 	dib8000_write_word(state, 107, (dib8000_read_word(state, 107) & 0xff00) | split_offset);
@@ -1395,7 +1402,7 @@ static void dib8096p_cfg_DibTx(struct dib8000_state *state, u32 P_Kin,
 		u32 P_Kout, u32 insertExtSynchro, u32 synchroMode,
 		u32 syncWord, u32 syncSize)
 {
-	dprintk("Configure DibStream Tx");
+	dprintk("Configure DibStream Tx\n");
 
 	dib8000_write_word(state, 1615, 1);
 	dib8000_write_word(state, 1603, P_Kin);
@@ -1414,7 +1421,7 @@ static void dib8096p_cfg_DibRx(struct dib8000_state *state, u32 P_Kin,
 {
 	u32 syncFreq;
 
-	dprintk("Configure DibStream Rx synchroMode = %d", synchroMode);
+	dprintk("Configure DibStream Rx synchroMode = %d\n", synchroMode);
 
 	if ((P_Kin != 0) && (P_Kout != 0)) {
 		syncFreq = dib8096p_calcSyncFreq(P_Kin, P_Kout,
@@ -1456,7 +1463,7 @@ static void dib8096p_configMpegMux(struct dib8000_state *state,
 {
 	u16 reg_1287;
 
-	dprintk("Enable Mpeg mux");
+	dprintk("Enable Mpeg mux\n");
 
 	dib8096p_enMpegMux(state, 0);
 
@@ -1477,15 +1484,15 @@ static void dib8096p_setDibTxMux(struct dib8000_state *state, int mode)
 
 	switch (mode) {
 	case MPEG_ON_DIBTX:
-			dprintk("SET MPEG ON DIBSTREAM TX");
+			dprintk("SET MPEG ON DIBSTREAM TX\n");
 			dib8096p_cfg_DibTx(state, 8, 5, 0, 0, 0, 0);
 			reg_1288 |= (1 << 9); break;
 	case DIV_ON_DIBTX:
-			dprintk("SET DIV_OUT ON DIBSTREAM TX");
+			dprintk("SET DIV_OUT ON DIBSTREAM TX\n");
 			dib8096p_cfg_DibTx(state, 5, 5, 0, 0, 0, 0);
 			reg_1288 |= (1 << 8); break;
 	case ADC_ON_DIBTX:
-			dprintk("SET ADC_OUT ON DIBSTREAM TX");
+			dprintk("SET ADC_OUT ON DIBSTREAM TX\n");
 			dib8096p_cfg_DibTx(state, 20, 5, 10, 0, 0, 0);
 			reg_1288 |= (1 << 7); break;
 	default:
@@ -1500,17 +1507,17 @@ static void dib8096p_setHostBusMux(struct dib8000_state *state, int mode)
 
 	switch (mode) {
 	case DEMOUT_ON_HOSTBUS:
-			dprintk("SET DEM OUT OLD INTERF ON HOST BUS");
+			dprintk("SET DEM OUT OLD INTERF ON HOST BUS\n");
 			dib8096p_enMpegMux(state, 0);
 			reg_1288 |= (1 << 6);
 			break;
 	case DIBTX_ON_HOSTBUS:
-			dprintk("SET DIBSTREAM TX ON HOST BUS");
+			dprintk("SET DIBSTREAM TX ON HOST BUS\n");
 			dib8096p_enMpegMux(state, 0);
 			reg_1288 |= (1 << 5);
 			break;
 	case MPEG_ON_HOSTBUS:
-			dprintk("SET MPEG MUX ON HOST BUS");
+			dprintk("SET MPEG MUX ON HOST BUS\n");
 			reg_1288 |= (1 << 4);
 			break;
 	default:
@@ -1526,7 +1533,7 @@ static int dib8096p_set_diversity_in(struct dvb_frontend *fe, int onoff)
 
 	switch (onoff) {
 	case 0: /* only use the internal way - not the diversity input */
-			dprintk("%s mode OFF : by default Enable Mpeg INPUT",
+			dprintk("%s mode OFF : by default Enable Mpeg INPUT\n",
 					__func__);
 			/* outputRate = 8 */
 			dib8096p_cfg_DibRx(state, 8, 5, 0, 0, 0, 8, 0);
@@ -1544,7 +1551,7 @@ static int dib8096p_set_diversity_in(struct dvb_frontend *fe, int onoff)
 			break;
 	case 1: /* both ways */
 	case 2: /* only the diversity input */
-			dprintk("%s ON : Enable diversity INPUT", __func__);
+			dprintk("%s ON : Enable diversity INPUT\n", __func__);
 			dib8096p_cfg_DibRx(state, 5, 5, 0, 0, 0, 0, 0);
 			state->input_mode_mpeg = 0;
 			break;
@@ -1576,11 +1583,11 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 
 	case OUTMODE_MPEG2_SERIAL:
 			if (prefer_mpeg_mux_use) {
-				dprintk("dib8096P setting output mode TS_SERIAL using Mpeg Mux");
+				dprintk("dib8096P setting output mode TS_SERIAL using Mpeg Mux\n");
 				dib8096p_configMpegMux(state, 3, 1, 1);
 				dib8096p_setHostBusMux(state, MPEG_ON_HOSTBUS);
 			} else {/* Use Smooth block */
-				dprintk("dib8096P setting output mode TS_SERIAL using Smooth bloc");
+				dprintk("dib8096P setting output mode TS_SERIAL using Smooth bloc\n");
 				dib8096p_setHostBusMux(state,
 						DEMOUT_ON_HOSTBUS);
 				outreg |= (2 << 6) | (0 << 1);
@@ -1589,11 +1596,11 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 
 	case OUTMODE_MPEG2_PAR_GATED_CLK:
 			if (prefer_mpeg_mux_use) {
-				dprintk("dib8096P setting output mode TS_PARALLEL_GATED using Mpeg Mux");
+				dprintk("dib8096P setting output mode TS_PARALLEL_GATED using Mpeg Mux\n");
 				dib8096p_configMpegMux(state, 2, 0, 0);
 				dib8096p_setHostBusMux(state, MPEG_ON_HOSTBUS);
 			} else { /* Use Smooth block */
-				dprintk("dib8096P setting output mode TS_PARALLEL_GATED using Smooth block");
+				dprintk("dib8096P setting output mode TS_PARALLEL_GATED using Smooth block\n");
 				dib8096p_setHostBusMux(state,
 						DEMOUT_ON_HOSTBUS);
 				outreg |= (0 << 6);
@@ -1601,7 +1608,7 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 			break;
 
 	case OUTMODE_MPEG2_PAR_CONT_CLK: /* Using Smooth block only */
-			dprintk("dib8096P setting output mode TS_PARALLEL_CONT using Smooth block");
+			dprintk("dib8096P setting output mode TS_PARALLEL_CONT using Smooth block\n");
 			dib8096p_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 			outreg |= (1 << 6);
 			break;
@@ -1609,7 +1616,7 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 	case OUTMODE_MPEG2_FIFO:
 			/* Using Smooth block because not supported
 			   by new Mpeg Mux bloc */
-			dprintk("dib8096P setting output mode TS_FIFO using Smooth block");
+			dprintk("dib8096P setting output mode TS_FIFO using Smooth block\n");
 			dib8096p_setHostBusMux(state, DEMOUT_ON_HOSTBUS);
 			outreg |= (5 << 6);
 			smo_mode |= (3 << 1);
@@ -1617,13 +1624,13 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 			break;
 
 	case OUTMODE_DIVERSITY:
-			dprintk("dib8096P setting output mode MODE_DIVERSITY");
+			dprintk("dib8096P setting output mode MODE_DIVERSITY\n");
 			dib8096p_setDibTxMux(state, DIV_ON_DIBTX);
 			dib8096p_setHostBusMux(state, DIBTX_ON_HOSTBUS);
 			break;
 
 	case OUTMODE_ANALOG_ADC:
-			dprintk("dib8096P setting output mode MODE_ANALOG_ADC");
+			dprintk("dib8096P setting output mode MODE_ANALOG_ADC\n");
 			dib8096p_setDibTxMux(state, ADC_ON_DIBTX);
 			dib8096p_setHostBusMux(state, DIBTX_ON_HOSTBUS);
 			break;
@@ -1632,7 +1639,7 @@ static int dib8096p_set_output_mode(struct dvb_frontend *fe, int mode)
 	if (mode != OUTMODE_HIGH_Z)
 		outreg |= (1<<10);
 
-	dprintk("output_mpeg2_in_188_bytes = %d",
+	dprintk("output_mpeg2_in_188_bytes = %d\n",
 			state->cfg.output_mpeg2_in_188_bytes);
 	if (state->cfg.output_mpeg2_in_188_bytes)
 		smo_mode |= (1 << 5);
@@ -1678,7 +1685,7 @@ static int dib8096p_tuner_write_serpar(struct i2c_adapter *i2c_adap,
 		n_overflow = (dib8000_read_word(state, 1984) >> 1) & 0x1;
 		i--;
 		if (i == 0)
-			dprintk("Tuner ITF: write busy (overflow)");
+			dprintk("Tuner ITF: write busy (overflow)\n");
 	}
 	dib8000_write_word(state, 1985, (1 << 6) | (serpar_num & 0x3f));
 	dib8000_write_word(state, 1986, (msg[0].buf[1] << 8) | msg[0].buf[2]);
@@ -1699,7 +1706,7 @@ static int dib8096p_tuner_read_serpar(struct i2c_adapter *i2c_adap,
 		n_overflow = (dib8000_read_word(state, 1984) >> 1) & 0x1;
 		i--;
 		if (i == 0)
-			dprintk("TunerITF: read busy (overflow)");
+			dprintk("TunerITF: read busy (overflow)\n");
 	}
 	dib8000_write_word(state, 1985, (0<<6) | (serpar_num&0x3f));
 
@@ -1708,7 +1715,7 @@ static int dib8096p_tuner_read_serpar(struct i2c_adapter *i2c_adap,
 		n_empty = dib8000_read_word(state, 1984)&0x1;
 		i--;
 		if (i == 0)
-			dprintk("TunerITF: read busy (empty)");
+			dprintk("TunerITF: read busy (empty)\n");
 	}
 
 	read_word = dib8000_read_word(state, 1987);
@@ -1889,7 +1896,7 @@ static int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff)
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 en_cur_state;
 
-	dprintk("sleep dib8096p: %d", onoff);
+	dprintk("sleep dib8096p: %d\n", onoff);
 
 	en_cur_state = dib8000_read_word(state, 1922);
 
@@ -1958,7 +1965,7 @@ static void dib8000_update_timf(struct dib8000_state *state)
 
 	dib8000_write_word(state, 29, (u16) (timf >> 16));
 	dib8000_write_word(state, 30, (u16) (timf & 0xffff));
-	dprintk("Updated timing frequency: %d (default: %d)", state->timf, state->timf_default);
+	dprintk("Updated timing frequency: %d (default: %d)\n", state->timf, state->timf_default);
 }
 
 static u32 dib8000_ctrl_timf(struct dvb_frontend *fe, uint8_t op, uint32_t timf)
@@ -2118,7 +2125,7 @@ static u16 dib8000_get_init_prbs(struct dib8000_state *state, u16 subchannel)
 	int sub_channel_prbs_group = 0;
 
 	sub_channel_prbs_group = (subchannel / 3) + 1;
-	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
+	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
 
 	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
 	case TRANSMISSION_MODE_2K:
@@ -2604,7 +2611,7 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 					slist = 0;
 			}
 		}
-		dprintk("Using list for autosearch : %d", slist);
+		dprintk("Using list for autosearch : %d\n", slist);
 
 		dib8000_set_isdbt_common_channel(state, slist, 1);
 
@@ -2638,17 +2645,17 @@ static int dib8000_autosearch_irq(struct dvb_frontend *fe)
 	if ((state->revision >= 0x8002) &&
 	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		if (irq_pending & 0x1) {
-			dprintk("dib8000_autosearch_irq: max correlation result available");
+			dprintk("dib8000_autosearch_irq: max correlation result available\n");
 			return 3;
 		}
 	} else {
 		if (irq_pending & 0x1) {	/* failed */
-			dprintk("dib8000_autosearch_irq failed");
+			dprintk("dib8000_autosearch_irq failed\n");
 			return 1;
 		}
 
 		if (irq_pending & 0x2) {	/* succeeded */
-			dprintk("dib8000_autosearch_irq succeeded");
+			dprintk("dib8000_autosearch_irq succeeded\n");
 			return 2;
 		}
 	}
@@ -2699,7 +2706,7 @@ static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 			dds += abs_offset_khz * unit_khz_dds_val;
 	}
 
-	dprintk("setting a DDS frequency offset of %c%dkHz", invert ? '-' : ' ', dds / unit_khz_dds_val);
+	dprintk("setting a DDS frequency offset of %c%dkHz\n", invert ? '-' : ' ', dds / unit_khz_dds_val);
 
 	if (abs_offset_khz <= (state->cfg.pll->internal / ratio)) {
 		/* Max dds offset is the half of the demod freq */
@@ -2738,7 +2745,7 @@ static void dib8000_set_frequency_offset(struct dib8000_state *state)
 		}
 	}
 
-	dprintk("%dkhz tuner offset (frequency = %dHz & current_rf = %dHz) total_dds_offset_hz = %d", c->frequency - current_rf, c->frequency, current_rf, total_dds_offset_khz);
+	dprintk("%dkhz tuner offset (frequency = %dHz & current_rf = %dHz) total_dds_offset_hz = %d\n", c->frequency - current_rf, c->frequency, current_rf, total_dds_offset_khz);
 
 	/* apply dds offset now */
 	dib8000_set_dds(state, total_dds_offset_khz);
@@ -2890,7 +2897,7 @@ static u16 dib8000_read_lock(struct dvb_frontend *fe)
 static int dib8090p_init_sdram(struct dib8000_state *state)
 {
 	u16 reg = 0;
-	dprintk("init sdram");
+	dprintk("init sdram\n");
 
 	reg = dib8000_read_word(state, 274) & 0xfff0;
 	dib8000_write_word(state, 274, reg | 0x7); /* P_dintlv_delay_ram = 7 because of MobileSdram */
@@ -2931,7 +2938,7 @@ static int is_manual_mode(struct dtv_frontend_properties *c)
 	 * Transmission mode is only detected on auto mode, currently
 	 */
 	if (c->transmission_mode == TRANSMISSION_MODE_AUTO) {
-		dprintk("transmission mode auto");
+		dprintk("transmission mode auto\n");
 		return 0;
 	}
 
@@ -2939,7 +2946,7 @@ static int is_manual_mode(struct dtv_frontend_properties *c)
 	 * Guard interval is only detected on auto mode, currently
 	 */
 	if (c->guard_interval == GUARD_INTERVAL_AUTO) {
-		dprintk("guard interval auto");
+		dprintk("guard interval auto\n");
 		return 0;
 	}
 
@@ -2948,7 +2955,7 @@ static int is_manual_mode(struct dtv_frontend_properties *c)
 	 * layer should be enabled
 	 */
 	if (!c->isdbt_layer_enabled) {
-		dprintk("no layer modulation specified");
+		dprintk("no layer modulation specified\n");
 		return 0;
 	}
 
@@ -2970,7 +2977,7 @@ static int is_manual_mode(struct dtv_frontend_properties *c)
 
 		if ((c->layer[i].modulation == QAM_AUTO) ||
 		    (c->layer[i].fec == FEC_AUTO)) {
-			dprintk("layer %c has either modulation or FEC auto",
+			dprintk("layer %c has either modulation or FEC auto\n",
 				'A' + i);
 			return 0;
 		}
@@ -2981,7 +2988,7 @@ static int is_manual_mode(struct dtv_frontend_properties *c)
 	 *	fallback to auto mode.
 	 */
 	if (n_segs == 0 || n_segs > 13) {
-		dprintk("number of segments is invalid");
+		dprintk("number of segments is invalid\n");
 		return 0;
 	}
 
@@ -3009,7 +3016,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 #if 0
 	if (*tune_state < CT_DEMOD_STOP)
-		dprintk("IN: context status = %d, TUNE_STATE %d autosearch step = %u jiffies = %lu",
+		dprintk("IN: context status = %d, TUNE_STATE %d autosearch step = %u jiffies = %lu\n",
 			state->channel_parameters_set, *tune_state, state->autosearch_state, now);
 #endif
 
@@ -3022,7 +3029,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		state->status = FE_STATUS_TUNE_PENDING;
 		state->channel_parameters_set = is_manual_mode(c);
 
-		dprintk("Tuning channel on %s search mode",
+		dprintk("Tuning channel on %s search mode\n",
 			state->channel_parameters_set ? "manual" : "auto");
 
 		dib8000_viterbi_state(state, 0); /* force chan dec in restart */
@@ -3102,7 +3109,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				corm[1] = (dib8000_read_word(state, 596) << 16) | (dib8000_read_word(state, 597));
 				corm[0] = (dib8000_read_word(state, 598) << 16) | (dib8000_read_word(state, 599));
 			}
-			/* dprintk("corm fft: %u %u %u", corm[0], corm[1], corm[2]); */
+			/* dprintk("corm fft: %u %u %u\n", corm[0], corm[1], corm[2]); */
 
 			max_value = 0;
 			for (find_index = 1 ; find_index < 3 ; find_index++) {
@@ -3122,7 +3129,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				state->found_nfft = TRANSMISSION_MODE_8K;
 				break;
 			}
-			/* dprintk("Autosearch FFT has found Mode %d", max_value + 1); */
+			/* dprintk("Autosearch FFT has found Mode %d\n", max_value + 1); */
 
 			*tune_state = CT_DEMOD_SEARCH_NEXT;
 			state->autosearch_state = AS_SEARCHING_GUARD;
@@ -3137,7 +3144,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				state->found_guard = dib8000_read_word(state, 572) & 0x3;
 			else
 				state->found_guard = dib8000_read_word(state, 570) & 0x3;
-			/* dprintk("guard interval found=%i", state->found_guard); */
+			/* dprintk("guard interval found=%i\n", state->found_guard); */
 
 			*tune_state = CT_DEMOD_STEP_3;
 			break;
@@ -3233,7 +3240,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			/* defines timeout for mpeg lock depending on interleaver length of longest layer */
 			for (i = 0; i < 3; i++) {
 				if (c->layer[i].interleaving >= deeper_interleaver) {
-					dprintk("layer%i: time interleaver = %d ", i, c->layer[i].interleaving);
+					dprintk("layer%i: time interleaver = %d \n", i, c->layer[i].interleaving);
 					if (c->layer[i].segment_count > 0) { /* valid layer */
 						deeper_interleaver = c->layer[0].interleaving;
 						state->longest_intlv_layer = i;
@@ -3252,7 +3259,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				locks *= 2;
 
 			*timeout = now + msecs_to_jiffies(200 * locks); /* give the mpeg lock 800ms if sram is present */
-			dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %ld",
+			dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %ld\n",
 				deeper_interleaver, state->longest_intlv_layer, locks, *timeout);
 
 			*tune_state = CT_DEMOD_STEP_10;
@@ -3263,7 +3270,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 	case CT_DEMOD_STEP_10: /* 40 */
 		locks = dib8000_read_lock(fe);
 		if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
-			dprintk("ISDB-T layer locks: Layer A %s, Layer B %s, Layer C %s",
+			dprintk("ISDB-T layer locks: Layer A %s, Layer B %s, Layer C %s\n",
 				c->layer[0].segment_count ? (locks >> 7) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
 				c->layer[1].segment_count ? (locks >> 6) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
 				c->layer[2].segment_count ? (locks >> 5) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled");
@@ -3283,7 +3290,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				*tune_state = CT_DEMOD_STEP_11;
 			} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
 				if (locks & (0x7 << 5)) {
-					dprintk("Not all ISDB-T layers locked in %d ms: Layer A %s, Layer B %s, Layer C %s",
+					dprintk("Not all ISDB-T layers locked in %d ms: Layer A %s, Layer B %s, Layer C %s\n",
 						jiffies_to_msecs(now - *timeout),
 						c->layer[0].segment_count ? (locks >> 7) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
 						c->layer[1].segment_count ? (locks >> 6) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
@@ -3348,7 +3355,7 @@ static int dib8000_wakeup(struct dvb_frontend *fe)
 	dib8000_set_power_mode(state, DIB8000_POWER_ALL);
 	dib8000_set_adc_state(state, DIBX000_ADC_ON);
 	if (dib8000_set_adc_state(state, DIBX000_SLOW_ADC_ON) != 0)
-		dprintk("could not start Slow ADC");
+		dprintk("could not start Slow ADC\n");
 
 	if (state->revision == 0x8090)
 		dib8000_sad_calib(state);
@@ -3401,11 +3408,11 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 	if (!(stat & FE_HAS_SYNC))
 		return 0;
 
-	dprintk("dib8000_get_frontend: TMCC lock");
+	dprintk("dib8000_get_frontend: TMCC lock\n");
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_status(state->fe[index_frontend], &stat);
 		if (stat&FE_HAS_SYNC) {
-			dprintk("TMCC lock on the slave%i", index_frontend);
+			dprintk("TMCC lock on the slave%i\n", index_frontend);
 			/* synchronize the cache with the other frontends */
 			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL); sub_index_frontend++) {
@@ -3437,41 +3444,41 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 	switch ((val & 0x30) >> 4) {
 	case 1:
 		c->transmission_mode = TRANSMISSION_MODE_2K;
-		dprintk("dib8000_get_frontend: transmission mode 2K");
+		dprintk("dib8000_get_frontend: transmission mode 2K\n");
 		break;
 	case 2:
 		c->transmission_mode = TRANSMISSION_MODE_4K;
-		dprintk("dib8000_get_frontend: transmission mode 4K");
+		dprintk("dib8000_get_frontend: transmission mode 4K\n");
 		break;
 	case 3:
 	default:
 		c->transmission_mode = TRANSMISSION_MODE_8K;
-		dprintk("dib8000_get_frontend: transmission mode 8K");
+		dprintk("dib8000_get_frontend: transmission mode 8K\n");
 		break;
 	}
 
 	switch (val & 0x3) {
 	case 0:
 		c->guard_interval = GUARD_INTERVAL_1_32;
-		dprintk("dib8000_get_frontend: Guard Interval = 1/32 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/32 \n");
 		break;
 	case 1:
 		c->guard_interval = GUARD_INTERVAL_1_16;
-		dprintk("dib8000_get_frontend: Guard Interval = 1/16 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/16 \n");
 		break;
 	case 2:
-		dprintk("dib8000_get_frontend: Guard Interval = 1/8 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/8 \n");
 		c->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		dprintk("dib8000_get_frontend: Guard Interval = 1/4 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/4 \n");
 		c->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	val = dib8000_read_word(state, 505);
 	c->isdbt_partial_reception = val & 1;
-	dprintk("dib8000_get_frontend: partial_reception = %d ", c->isdbt_partial_reception);
+	dprintk("dib8000_get_frontend: partial_reception = %d \n", c->isdbt_partial_reception);
 
 	for (i = 0; i < 3; i++) {
 		int show;
@@ -3485,7 +3492,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 			show = 1;
 
 		if (show)
-			dprintk("dib8000_get_frontend: Layer %d segments = %d ",
+			dprintk("dib8000_get_frontend: Layer %d segments = %d \n",
 				i, c->layer[i].segment_count);
 
 		val = dib8000_read_word(state, 499 + i) & 0x3;
@@ -3494,7 +3501,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 			val = 4;
 		c->layer[i].interleaving = val;
 		if (show)
-			dprintk("dib8000_get_frontend: Layer %d time_intlv = %d ",
+			dprintk("dib8000_get_frontend: Layer %d time_intlv = %d \n",
 				i, c->layer[i].interleaving);
 
 		val = dib8000_read_word(state, 481 + i);
@@ -3502,27 +3509,27 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 		case 1:
 			c->layer[i].fec = FEC_1_2;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d Code Rate = 1/2 ", i);
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 1/2 \n", i);
 			break;
 		case 2:
 			c->layer[i].fec = FEC_2_3;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d Code Rate = 2/3 ", i);
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 2/3 \n", i);
 			break;
 		case 3:
 			c->layer[i].fec = FEC_3_4;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d Code Rate = 3/4 ", i);
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 3/4 \n", i);
 			break;
 		case 5:
 			c->layer[i].fec = FEC_5_6;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d Code Rate = 5/6 ", i);
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 5/6 \n", i);
 			break;
 		default:
 			c->layer[i].fec = FEC_7_8;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d Code Rate = 7/8 ", i);
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 7/8 \n", i);
 			break;
 		}
 
@@ -3531,23 +3538,23 @@ static int dib8000_get_frontend(struct dvb_frontend *fe,
 		case 0:
 			c->layer[i].modulation = DQPSK;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d DQPSK ", i);
+				dprintk("dib8000_get_frontend: Layer %d DQPSK \n", i);
 			break;
 		case 1:
 			c->layer[i].modulation = QPSK;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d QPSK ", i);
+				dprintk("dib8000_get_frontend: Layer %d QPSK \n", i);
 			break;
 		case 2:
 			c->layer[i].modulation = QAM_16;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d QAM16 ", i);
+				dprintk("dib8000_get_frontend: Layer %d QAM16 \n", i);
 			break;
 		case 3:
 		default:
 			c->layer[i].modulation = QAM_64;
 			if (show)
-				dprintk("dib8000_get_frontend: Layer %d QAM64 ", i);
+				dprintk("dib8000_get_frontend: Layer %d QAM64 \n", i);
 			break;
 		}
 	}
@@ -3578,12 +3585,12 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 	unsigned long delay, callback_time;
 
 	if (c->frequency == 0) {
-		dprintk("dib8000: must at least specify frequency ");
+		dprintk("dib8000: must at least specify frequency \n");
 		return 0;
 	}
 
 	if (c->bandwidth_hz == 0) {
-		dprintk("dib8000: no bandwidth specified, set to default ");
+		dprintk("dib8000: no bandwidth specified, set to default \n");
 		c->bandwidth_hz = 6000000;
 	}
 
@@ -3671,7 +3678,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 			/* we are in autosearch */
 			if (state->channel_parameters_set == 0) { /* searching */
 				if ((dib8000_get_status(state->fe[index_frontend]) == FE_STATUS_DEMOD_SUCCESS) || (dib8000_get_status(state->fe[index_frontend]) == FE_STATUS_FFT_SUCCESS)) {
-					dprintk("autosearch succeeded on fe%i", index_frontend);
+					dprintk("autosearch succeeded on fe%i\n", index_frontend);
 					dib8000_get_frontend(state->fe[index_frontend], c); /* we read the channel parameters from the frontend which was successful */
 					state->channel_parameters_set = 1;
 
@@ -3708,11 +3715,11 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 					active = 1;
 			}
 			if (active == 0)
-				dprintk("tuning done with status %d", dib8000_get_status(state->fe[0]));
+				dprintk("tuning done with status %d\n", dib8000_get_status(state->fe[0]));
 		}
 
 		if ((active == 1) && (callback_time == 0)) {
-			dprintk("strange callback time something went wrong");
+			dprintk("strange callback time something went wrong\n");
 			active = 0;
 		}
 
@@ -4172,7 +4179,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, enum fe_status stat)
 		time_us = dib8000_get_time_us(fe, -1);
 		state->ber_jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
 
-		dprintk("Next all layers stats available in %u us.", time_us);
+		dprintk("Next all layers stats available in %u us.\n", time_us);
 
 		dib8000_read_ber(fe, &val);
 		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
@@ -4239,12 +4246,12 @@ static int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_fronte
 	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
 		index_frontend++;
 	if (index_frontend < MAX_NUMBER_OF_FRONTENDS) {
-		dprintk("set slave fe %p to index %i", fe_slave, index_frontend);
+		dprintk("set slave fe %p to index %i\n", fe_slave, index_frontend);
 		state->fe[index_frontend] = fe_slave;
 		return 0;
 	}
 
-	dprintk("too many slave frontend");
+	dprintk("too many slave frontend\n");
 	return -ENOMEM;
 }
 
@@ -4256,12 +4263,12 @@ static int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
 	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
 		index_frontend++;
 	if (index_frontend != 1) {
-		dprintk("remove slave fe %p (index %i)", state->fe[index_frontend-1], index_frontend-1);
+		dprintk("remove slave fe %p (index %i)\n", state->fe[index_frontend-1], index_frontend-1);
 		state->fe[index_frontend] = NULL;
 		return 0;
 	}
 
-	dprintk("no frontend to be removed");
+	dprintk("no frontend to be removed\n");
 	return -ENODEV;
 }
 
@@ -4283,18 +4290,18 @@ static int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
 
 	client.i2c_write_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
 	if (!client.i2c_write_buffer) {
-		dprintk("%s: not enough memory", __func__);
+		dprintk("%s: not enough memory\n", __func__);
 		return -ENOMEM;
 	}
 	client.i2c_read_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
 	if (!client.i2c_read_buffer) {
-		dprintk("%s: not enough memory", __func__);
+		dprintk("%s: not enough memory\n", __func__);
 		ret = -ENOMEM;
 		goto error_memory_read;
 	}
 	client.i2c_buffer_lock = kzalloc(sizeof(struct mutex), GFP_KERNEL);
 	if (!client.i2c_buffer_lock) {
-		dprintk("%s: not enough memory", __func__);
+		dprintk("%s: not enough memory\n", __func__);
 		ret = -ENOMEM;
 		goto error_memory_lock;
 	}
@@ -4313,7 +4320,7 @@ static int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
 				dib8000_i2c_write16(&client, 1287, 0x0003);
 			client.addr = default_addr;
 			if (dib8000_identify(&client) == 0) {
-				dprintk("#%d: not identified", k);
+				dprintk("#%d: not identified\n", k);
 				ret  = -EINVAL;
 				goto error;
 			}
@@ -4327,7 +4334,7 @@ static int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
 		client.addr = new_addr;
 		dib8000_identify(&client);
 
-		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
+		dprintk("IC %d initialized (to i2c_address 0x%x)\n", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
@@ -4385,14 +4392,14 @@ static int dib8000_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	u16 val = dib8000_read_word(st, 299) & 0xffef;
 	val |= (onoff & 0x1) << 4;
 
-	dprintk("pid filter enabled %d", onoff);
+	dprintk("pid filter enabled %d\n", onoff);
 	return dib8000_write_word(st, 299, val);
 }
 
 static int dib8000_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
 	struct dib8000_state *st = fe->demodulator_priv;
-	dprintk("Index %x, PID %d, OnOff %d", id, pid, onoff);
+	dprintk("Index %x, PID %d, OnOff %d\n", id, pid, onoff);
 	return dib8000_write_word(st, 305 + id, onoff ? (1 << 13) | pid : 0);
 }
 
@@ -4431,7 +4438,7 @@ static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_ad
 	struct dvb_frontend *fe;
 	struct dib8000_state *state;
 
-	dprintk("dib8000_init");
+	dprintk("dib8000_init\n");
 
 	state = kzalloc(sizeof(struct dib8000_state), GFP_KERNEL);
 	if (state == NULL)
-- 
2.7.4


