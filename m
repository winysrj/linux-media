Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753787AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 16/35] [media] dib0070: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:48 -0200
Message-Id: <bbf624944e008aa101f04e18aba338d922d9ce42.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/dvb-frontends/dib0070.c | 52 +++++++++++++++++------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index ee7d66997ccd..ba25eb1b0543 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
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
-		printk(KERN_DEBUG "DiB0070: "); \
-		printk(args); \
-		printk("\n"); \
-	} \
-} while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 #define DIB0070_P1D  0x00
 #define DIB0070_P1F  0x01
@@ -87,7 +87,7 @@ static u16 dib0070_read_reg(struct dib0070_state *state, u8 reg)
 	u16 ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return 0;
 	}
 
@@ -104,7 +104,7 @@ static u16 dib0070_read_reg(struct dib0070_state *state, u8 reg)
 	state->msg[1].len = 2;
 
 	if (i2c_transfer(state->i2c, state->msg, 2) != 2) {
-		printk(KERN_WARNING "DiB0070 I2C read failed\n");
+		pr_warn("DiB0070 I2C read failed\n");
 		ret = 0;
 	} else
 		ret = (state->i2c_read_buffer[0] << 8)
@@ -119,7 +119,7 @@ static int dib0070_write_reg(struct dib0070_state *state, u8 reg, u16 val)
 	int ret;
 
 	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
+		dprintk("could not acquire lock\n");
 		return -EINVAL;
 	}
 	state->i2c_write_buffer[0] = reg;
@@ -133,7 +133,7 @@ static int dib0070_write_reg(struct dib0070_state *state, u8 reg, u16 val)
 	state->msg[0].len = 3;
 
 	if (i2c_transfer(state->i2c, state->msg, 1) != 1) {
-		printk(KERN_WARNING "DiB0070 I2C write failed\n");
+		pr_warn("DiB0070 I2C write failed\n");
 		ret = -EREMOTEIO;
 	} else
 		ret = 0;
@@ -205,7 +205,7 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 
 		adc = dib0070_read_reg(state, 0x19);
 
-		dprintk("CAPTRIM=%hd; ADC = %hd (ADC) & %dmV", state->captrim, adc, (u32) adc*(u32)1800/(u32)1024);
+		dprintk("CAPTRIM=%hd; ADC = %hd (ADC) & %dmV\n", state->captrim, adc, (u32) adc*(u32)1800/(u32)1024);
 
 		if (adc >= 400) {
 			adc -= 400;
@@ -216,7 +216,7 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 		}
 
 		if (adc < state->adc_diff) {
-			dprintk("CAPTRIM=%hd is closer to target (%hd/%hd)", state->captrim, adc, state->adc_diff);
+			dprintk("CAPTRIM=%hd is closer to target (%hd/%hd)\n", state->captrim, adc, state->adc_diff);
 			state->adc_diff = adc;
 			state->fcaptrim = state->captrim;
 		}
@@ -241,7 +241,7 @@ static int dib0070_set_ctrl_lo5(struct dvb_frontend *fe, u8 vco_bias_trim, u8 hf
 	struct dib0070_state *state = fe->tuner_priv;
 	u16 lo5 = (third_order_filt << 14) | (0 << 13) | (1 << 12) | (3 << 9) | (cp_current << 6) | (hf_div_trim << 3) | (vco_bias_trim << 0);
 
-	dprintk("CTRL_LO5: 0x%x", lo5);
+	dprintk("CTRL_LO5: 0x%x\n", lo5);
 	return dib0070_write_reg(state, 0x15, lo5);
 }
 
@@ -256,7 +256,7 @@ void dib0070_ctrl_agc_filter(struct dvb_frontend *fe, u8 open)
 		dib0070_write_reg(state, 0x1b, 0x4112);
 		if (state->cfg->vga_filter != 0) {
 			dib0070_write_reg(state, 0x1a, state->cfg->vga_filter);
-			dprintk("vga filter register is set to %x", state->cfg->vga_filter);
+			dprintk("vga filter register is set to %x\n", state->cfg->vga_filter);
 		} else
 			dib0070_write_reg(state, 0x1a, 0x0009);
 	}
@@ -380,7 +380,7 @@ static int dib0070_tune_digital(struct dvb_frontend *fe)
 	}
 
 	if (*tune_state == CT_TUNER_START) {
-		dprintk("Tuning for Band: %hd (%d kHz)", band, freq);
+		dprintk("Tuning for Band: %hd (%d kHz)\n", band, freq);
 		if (state->current_rf != freq) {
 			u8 REFDIV;
 			u32 FBDiv, Rest, FREF, VCOF_kHz;
@@ -458,12 +458,12 @@ static int dib0070_tune_digital(struct dvb_frontend *fe)
 			dib0070_write_reg(state, 0x20,
 				0x0040 | 0x0020 | 0x0010 | 0x0008 | 0x0002 | 0x0001 | state->current_tune_table_index->tuner_enable);
 
-			dprintk("REFDIV: %hd, FREF: %d", REFDIV, FREF);
-			dprintk("FBDIV: %d, Rest: %d", FBDiv, Rest);
-			dprintk("Num: %hd, Den: %hd, SD: %hd", (u16) Rest, Den, (state->lo4 >> 12) & 0x1);
-			dprintk("HFDIV code: %hd", state->current_tune_table_index->hfdiv);
-			dprintk("VCO = %hd", state->current_tune_table_index->vco_band);
-			dprintk("VCOF: ((%hd*%d) << 1))", state->current_tune_table_index->vco_multi, freq);
+			dprintk("REFDIV: %hd, FREF: %d\n", REFDIV, FREF);
+			dprintk("FBDIV: %d, Rest: %d\n", FBDiv, Rest);
+			dprintk("Num: %hd, Den: %hd, SD: %hd\n", (u16) Rest, Den, (state->lo4 >> 12) & 0x1);
+			dprintk("HFDIV code: %hd\n", state->current_tune_table_index->hfdiv);
+			dprintk("VCO = %hd\n", state->current_tune_table_index->vco_band);
+			dprintk("VCOF: ((%hd*%d) << 1))\n", state->current_tune_table_index->vco_multi, freq);
 
 			*tune_state = CT_TUNER_STEP_0;
 		} else { /* we are already tuned to this frequency - the configuration is correct  */
@@ -625,7 +625,7 @@ static void dib0070_wbd_offset_calibration(struct dib0070_state *state)
 	u8 gain;
 	for (gain = 6; gain < 8; gain++) {
 		state->wbd_offset_3_3[gain - 6] = ((dib0070_read_wbd_offset(state, gain) * 8 * 18 / 33 + 1) / 2);
-		dprintk("Gain: %d, WBDOffset (3.3V) = %hd", gain, state->wbd_offset_3_3[gain-6]);
+		dprintk("Gain: %d, WBDOffset (3.3V) = %hd\n", gain, state->wbd_offset_3_3[gain-6]);
 	}
 }
 
@@ -665,10 +665,10 @@ static int dib0070_reset(struct dvb_frontend *fe)
 	state->revision = DIB0070S_P1A;
 
 	/* P1F or not */
-	dprintk("Revision: %x", state->revision);
+	dprintk("Revision: %x\n", state->revision);
 
 	if (state->revision == DIB0070_P1D) {
-		dprintk("Error: this driver is not to be used meant for P1D or earlier");
+		dprintk("Error: this driver is not to be used meant for P1D or earlier\n");
 		return -EINVAL;
 	}
 
@@ -761,7 +761,7 @@ struct dvb_frontend *dib0070_attach(struct dvb_frontend *fe, struct i2c_adapter
 	if (dib0070_reset(fe) != 0)
 		goto free_mem;
 
-	printk(KERN_INFO "DiB0070: successfully identified\n");
+	pr_info("DiB0070: successfully identified\n");
 	memcpy(&fe->ops.tuner_ops, &dib0070_ops, sizeof(struct dvb_tuner_ops));
 
 	fe->tuner_priv = state;
-- 
2.7.4


