Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbbD2XG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/27] dib0070: Fix indenting
Date: Wed, 29 Apr 2015 20:05:56 -0300
Message-Id: <e2e7d35c1b768ca92ffd6c498a6c0504b4cdd153.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The indentation on this driver were deadly broken. On lots
of places, it was using 4 spaces instead of tab to indent.
On other parts, it were using tabs.

Also, on several places, it were not even being properly aligned,
as reported by smatch:
	drivers/media/dvb-frontends/dib0070.c:179 dib0070_set_bandwidth() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:198 dib0070_captrim() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:246 dib0070_set_ctrl_lo5() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:260 dib0070_ctrl_agc_filter() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:494 dib0070_tune_digital() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:498 dib0070_tune_digital() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:655 dib0070_reset() warn: inconsistent indenting
	drivers/media/dvb-frontends/dib0070.c:711 dib0070_reset() warn: curly braces intended?
	drivers/media/dvb-frontends/dib0070.c:713 dib0070_reset() warn: inconsistent indenting

My first idea were to leave it as-is or to just touch the above.

However, this won't be fixing anything. So, as painful as it
is, let's fix indentation globally on the driver, and then
address the inconsistencies.

Hopefully, this driver doesn't have much patches, so it likely
won't conflict to any other patch during this merge window.

Besides the big size of this patch, no functional changes
were done.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index 3b024bfe980a..0b8fb5dd1889 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -58,10 +58,10 @@ struct dib0070_state {
 	u16 wbd_ff_offset;
 	u8 revision;
 
-    enum frontend_tune_state tune_state;
-    u32 current_rf;
+	enum frontend_tune_state tune_state;
+	u32 current_rf;
 
-    /* for the captrim binary search */
+	/* for the captrim binary search */
 	s8 step;
 	u16 adc_diff;
 
@@ -72,7 +72,7 @@ struct dib0070_state {
 	const struct dib0070_tuning *current_tune_table_index;
 	const struct dib0070_lna_match *lna_match;
 
-    u8  wbd_gain_current;
+	u8  wbd_gain_current;
 	u16 wbd_offset_3_3[2];
 
 	/* for the I2C transfer */
@@ -151,31 +151,31 @@ static int dib0070_write_reg(struct dib0070_state *state, u8 reg, u16 val)
 } while (0)
 
 static int dib0070_set_bandwidth(struct dvb_frontend *fe)
-{
-    struct dib0070_state *state = fe->tuner_priv;
-    u16 tmp = dib0070_read_reg(state, 0x02) & 0x3fff;
+	{
+	struct dib0070_state *state = fe->tuner_priv;
+	u16 tmp = dib0070_read_reg(state, 0x02) & 0x3fff;
 
-    if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 7000)
-	tmp |= (0 << 14);
-    else if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 6000)
-	tmp |= (1 << 14);
-    else if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 5000)
-	tmp |= (2 << 14);
-    else
-	tmp |= (3 << 14);
+	if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 7000)
+		tmp |= (0 << 14);
+	else if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 6000)
+		tmp |= (1 << 14);
+	else if (state->fe->dtv_property_cache.bandwidth_hz/1000 > 5000)
+		tmp |= (2 << 14);
+	else
+		tmp |= (3 << 14);
 
-    dib0070_write_reg(state, 0x02, tmp);
+	dib0070_write_reg(state, 0x02, tmp);
 
-    /* sharpen the BB filter in ISDB-T to have higher immunity to adjacent channels */
-    if (state->fe->dtv_property_cache.delivery_system == SYS_ISDBT) {
-	u16 value = dib0070_read_reg(state, 0x17);
+	/* sharpen the BB filter in ISDB-T to have higher immunity to adjacent channels */
+	if (state->fe->dtv_property_cache.delivery_system == SYS_ISDBT) {
+		u16 value = dib0070_read_reg(state, 0x17);
 
-	dib0070_write_reg(state, 0x17, value & 0xfffc);
-	tmp = dib0070_read_reg(state, 0x01) & 0x01ff;
-	dib0070_write_reg(state, 0x01, tmp | (60 << 9));
+		dib0070_write_reg(state, 0x17, value & 0xfffc);
+		tmp = dib0070_read_reg(state, 0x01) & 0x01ff;
+		dib0070_write_reg(state, 0x01, tmp | (60 << 9));
 
-	dib0070_write_reg(state, 0x17, value);
-    }
+		dib0070_write_reg(state, 0x17, value);
+	}
 	return 0;
 }
 
@@ -186,7 +186,6 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 	int ret = 0;
 
 	if (*tune_state == CT_TUNER_STEP_0) {
-
 		dib0070_write_reg(state, 0x0f, 0xed10);
 		dib0070_write_reg(state, 0x17,    0x0034);
 
@@ -195,7 +194,7 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 		state->adc_diff = 3000;
 		ret = 20;
 
-	*tune_state = CT_TUNER_STEP_1;
+		*tune_state = CT_TUNER_STEP_1;
 	} else if (*tune_state == CT_TUNER_STEP_1) {
 		state->step /= 2;
 		dib0070_write_reg(state, 0x14, state->lo4 | state->captrim);
@@ -220,9 +219,6 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 			dprintk("CAPTRIM=%hd is closer to target (%hd/%hd)", state->captrim, adc, state->adc_diff);
 			state->adc_diff = adc;
 			state->fcaptrim = state->captrim;
-
-
-
 		}
 		state->captrim += (step_sign * state->step);
 
@@ -243,7 +239,8 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 static int dib0070_set_ctrl_lo5(struct dvb_frontend *fe, u8 vco_bias_trim, u8 hf_div_trim, u8 cp_current, u8 third_order_filt)
 {
 	struct dib0070_state *state = fe->tuner_priv;
-    u16 lo5 = (third_order_filt << 14) | (0 << 13) | (1 << 12) | (3 << 9) | (cp_current << 6) | (hf_div_trim << 3) | (vco_bias_trim << 0);
+	u16 lo5 = (third_order_filt << 14) | (0 << 13) | (1 << 12) | (3 << 9) | (cp_current << 6) | (hf_div_trim << 3) | (vco_bias_trim << 0);
+
 	dprintk("CTRL_LO5: 0x%x", lo5);
 	return dib0070_write_reg(state, 0x15, lo5);
 }
@@ -257,281 +254,282 @@ void dib0070_ctrl_agc_filter(struct dvb_frontend *fe, u8 open)
 		dib0070_write_reg(state, 0x1a, 0x0000);
 	} else {
 		dib0070_write_reg(state, 0x1b, 0x4112);
-	if (state->cfg->vga_filter != 0) {
-		dib0070_write_reg(state, 0x1a, state->cfg->vga_filter);
-		dprintk("vga filter register is set to %x", state->cfg->vga_filter);
-	} else
-		dib0070_write_reg(state, 0x1a, 0x0009);
+		if (state->cfg->vga_filter != 0) {
+			dib0070_write_reg(state, 0x1a, state->cfg->vga_filter);
+			dprintk("vga filter register is set to %x", state->cfg->vga_filter);
+		} else
+			dib0070_write_reg(state, 0x1a, 0x0009);
 	}
 }
 
 EXPORT_SYMBOL(dib0070_ctrl_agc_filter);
 struct dib0070_tuning {
-    u32 max_freq; /* for every frequency less than or equal to that field: this information is correct */
-    u8 switch_trim;
-    u8 vco_band;
-    u8 hfdiv;
-    u8 vco_multi;
-    u8 presc;
-    u8 wbdmux;
-    u16 tuner_enable;
+	u32 max_freq; /* for every frequency less than or equal to that field: this information is correct */
+	u8 switch_trim;
+	u8 vco_band;
+	u8 hfdiv;
+	u8 vco_multi;
+	u8 presc;
+	u8 wbdmux;
+	u16 tuner_enable;
 };
 
 struct dib0070_lna_match {
-    u32 max_freq; /* for every frequency less than or equal to that field: this information is correct */
-    u8 lna_band;
+	u32 max_freq; /* for every frequency less than or equal to that field: this information is correct */
+	u8 lna_band;
 };
 
 static const struct dib0070_tuning dib0070s_tuning_table[] = {
-    {     570000, 2, 1, 3, 6, 6, 2, 0x4000 | 0x0800 }, /* UHF */
-    {     700000, 2, 0, 2, 4, 2, 2, 0x4000 | 0x0800 },
-    {     863999, 2, 1, 2, 4, 2, 2, 0x4000 | 0x0800 },
-    {    1500000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 }, /* LBAND */
-    {    1600000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 },
-    {    2000000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 },
-    { 0xffffffff, 0, 0, 8, 1, 2, 1, 0x8000 | 0x1000 }, /* SBAND */
+	{     570000, 2, 1, 3, 6, 6, 2, 0x4000 | 0x0800 }, /* UHF */
+	{     700000, 2, 0, 2, 4, 2, 2, 0x4000 | 0x0800 },
+	{     863999, 2, 1, 2, 4, 2, 2, 0x4000 | 0x0800 },
+	{    1500000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 }, /* LBAND */
+	{    1600000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 },
+	{    2000000, 0, 1, 1, 2, 2, 4, 0x2000 | 0x0400 },
+	{ 0xffffffff, 0, 0, 8, 1, 2, 1, 0x8000 | 0x1000 }, /* SBAND */
 };
 
 static const struct dib0070_tuning dib0070_tuning_table[] = {
-    {     115000, 1, 0, 7, 24, 2, 1, 0x8000 | 0x1000 }, /* FM below 92MHz cannot be tuned */
-    {     179500, 1, 0, 3, 16, 2, 1, 0x8000 | 0x1000 }, /* VHF */
-    {     189999, 1, 1, 3, 16, 2, 1, 0x8000 | 0x1000 },
-    {     250000, 1, 0, 6, 12, 2, 1, 0x8000 | 0x1000 },
-    {     569999, 2, 1, 5,  6, 2, 2, 0x4000 | 0x0800 }, /* UHF */
-    {     699999, 2, 0, 1,  4, 2, 2, 0x4000 | 0x0800 },
-    {     863999, 2, 1, 1,  4, 2, 2, 0x4000 | 0x0800 },
-    { 0xffffffff, 0, 1, 0,  2, 2, 4, 0x2000 | 0x0400 }, /* LBAND or everything higher than UHF */
+	{     115000, 1, 0, 7, 24, 2, 1, 0x8000 | 0x1000 }, /* FM below 92MHz cannot be tuned */
+	{     179500, 1, 0, 3, 16, 2, 1, 0x8000 | 0x1000 }, /* VHF */
+	{     189999, 1, 1, 3, 16, 2, 1, 0x8000 | 0x1000 },
+	{     250000, 1, 0, 6, 12, 2, 1, 0x8000 | 0x1000 },
+	{     569999, 2, 1, 5,  6, 2, 2, 0x4000 | 0x0800 }, /* UHF */
+	{     699999, 2, 0, 1,  4, 2, 2, 0x4000 | 0x0800 },
+	{     863999, 2, 1, 1,  4, 2, 2, 0x4000 | 0x0800 },
+	{ 0xffffffff, 0, 1, 0,  2, 2, 4, 0x2000 | 0x0400 }, /* LBAND or everything higher than UHF */
 };
 
 static const struct dib0070_lna_match dib0070_lna_flip_chip[] = {
-    {     180000, 0 }, /* VHF */
-    {     188000, 1 },
-    {     196400, 2 },
-    {     250000, 3 },
-    {     550000, 0 }, /* UHF */
-    {     590000, 1 },
-    {     666000, 3 },
-    {     864000, 5 },
-    {    1500000, 0 }, /* LBAND or everything higher than UHF */
-    {    1600000, 1 },
-    {    2000000, 3 },
-    { 0xffffffff, 7 },
+	{     180000, 0 }, /* VHF */
+	{     188000, 1 },
+	{     196400, 2 },
+	{     250000, 3 },
+	{     550000, 0 }, /* UHF */
+	{     590000, 1 },
+	{     666000, 3 },
+	{     864000, 5 },
+	{    1500000, 0 }, /* LBAND or everything higher than UHF */
+	{    1600000, 1 },
+	{    2000000, 3 },
+	{ 0xffffffff, 7 },
 };
 
 static const struct dib0070_lna_match dib0070_lna[] = {
-    {     180000, 0 }, /* VHF */
-    {     188000, 1 },
-    {     196400, 2 },
-    {     250000, 3 },
-    {     550000, 2 }, /* UHF */
-    {     650000, 3 },
-    {     750000, 5 },
-    {     850000, 6 },
-    {     864000, 7 },
-    {    1500000, 0 }, /* LBAND or everything higher than UHF */
-    {    1600000, 1 },
-    {    2000000, 3 },
-    { 0xffffffff, 7 },
+	{     180000, 0 }, /* VHF */
+	{     188000, 1 },
+	{     196400, 2 },
+	{     250000, 3 },
+	{     550000, 2 }, /* UHF */
+	{     650000, 3 },
+	{     750000, 5 },
+	{     850000, 6 },
+	{     864000, 7 },
+	{    1500000, 0 }, /* LBAND or everything higher than UHF */
+	{    1600000, 1 },
+	{    2000000, 3 },
+	{ 0xffffffff, 7 },
 };
 
 #define LPF	100
 static int dib0070_tune_digital(struct dvb_frontend *fe)
 {
-    struct dib0070_state *state = fe->tuner_priv;
+	struct dib0070_state *state = fe->tuner_priv;
 
-    const struct dib0070_tuning *tune;
-    const struct dib0070_lna_match *lna_match;
+	const struct dib0070_tuning *tune;
+	const struct dib0070_lna_match *lna_match;
 
-    enum frontend_tune_state *tune_state = &state->tune_state;
-    int ret = 10; /* 1ms is the default delay most of the time */
+	enum frontend_tune_state *tune_state = &state->tune_state;
+	int ret = 10; /* 1ms is the default delay most of the time */
 
-    u8  band = (u8)BAND_OF_FREQUENCY(fe->dtv_property_cache.frequency/1000);
-    u32 freq = fe->dtv_property_cache.frequency/1000 + (band == BAND_VHF ? state->cfg->freq_offset_khz_vhf : state->cfg->freq_offset_khz_uhf);
+	u8  band = (u8)BAND_OF_FREQUENCY(fe->dtv_property_cache.frequency/1000);
+	u32 freq = fe->dtv_property_cache.frequency/1000 + (band == BAND_VHF ? state->cfg->freq_offset_khz_vhf : state->cfg->freq_offset_khz_uhf);
 
 #ifdef CONFIG_SYS_ISDBT
-    if (state->fe->dtv_property_cache.delivery_system == SYS_ISDBT && state->fe->dtv_property_cache.isdbt_sb_mode == 1)
-		if (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2)
-		     && (state->fe->dtv_property_cache.isdbt_sb_segment_idx == ((state->fe->dtv_property_cache.isdbt_sb_segment_count / 2) + 1)))
-		    || (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2) == 0)
-			&& (state->fe->dtv_property_cache.isdbt_sb_segment_idx == (state->fe->dtv_property_cache.isdbt_sb_segment_count / 2)))
-		    || (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2) == 0)
-			&& (state->fe->dtv_property_cache.isdbt_sb_segment_idx == ((state->fe->dtv_property_cache.isdbt_sb_segment_count / 2) + 1))))
-			freq += 850;
+	if (state->fe->dtv_property_cache.delivery_system == SYS_ISDBT && state->fe->dtv_property_cache.isdbt_sb_mode == 1)
+			if (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2)
+			&& (state->fe->dtv_property_cache.isdbt_sb_segment_idx == ((state->fe->dtv_property_cache.isdbt_sb_segment_count / 2) + 1)))
+			|| (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2) == 0)
+				&& (state->fe->dtv_property_cache.isdbt_sb_segment_idx == (state->fe->dtv_property_cache.isdbt_sb_segment_count / 2)))
+			|| (((state->fe->dtv_property_cache.isdbt_sb_segment_count % 2) == 0)
+				&& (state->fe->dtv_property_cache.isdbt_sb_segment_idx == ((state->fe->dtv_property_cache.isdbt_sb_segment_count / 2) + 1))))
+				freq += 850;
 #endif
-    if (state->current_rf != freq) {
-
-	switch (state->revision) {
-	case DIB0070S_P1A:
-	    tune = dib0070s_tuning_table;
-	    lna_match = dib0070_lna;
-	    break;
-	default:
-	    tune = dib0070_tuning_table;
-	    if (state->cfg->flip_chip)
-		lna_match = dib0070_lna_flip_chip;
-	    else
-		lna_match = dib0070_lna;
-	    break;
-	}
-	while (freq > tune->max_freq) /* find the right one */
-	    tune++;
-	while (freq > lna_match->max_freq) /* find the right one */
-	    lna_match++;
-
-	state->current_tune_table_index = tune;
-	state->lna_match = lna_match;
-    }
-
-    if (*tune_state == CT_TUNER_START) {
-	dprintk("Tuning for Band: %hd (%d kHz)", band, freq);
 	if (state->current_rf != freq) {
-		u8 REFDIV;
-		u32 FBDiv, Rest, FREF, VCOF_kHz;
-		u8 Den;
-
-		state->current_rf = freq;
-		state->lo4 = (state->current_tune_table_index->vco_band << 11) | (state->current_tune_table_index->hfdiv << 7);
-
-
-		dib0070_write_reg(state, 0x17, 0x30);
-
-
-		VCOF_kHz = state->current_tune_table_index->vco_multi * freq * 2;
-
-		switch (band) {
-		case BAND_VHF:
-			REFDIV = (u8) ((state->cfg->clock_khz + 9999) / 10000);
-			break;
-		case BAND_FM:
-			REFDIV = (u8) ((state->cfg->clock_khz) / 1000);
-			break;
-		default:
-			REFDIV = (u8) (state->cfg->clock_khz  / 10000);
-			break;
-		}
-		FREF = state->cfg->clock_khz / REFDIV;
-
-
 
 		switch (state->revision) {
 		case DIB0070S_P1A:
-			FBDiv = (VCOF_kHz / state->current_tune_table_index->presc / FREF);
-			Rest  = (VCOF_kHz / state->current_tune_table_index->presc) - FBDiv * FREF;
-			break;
-
-		case DIB0070_P1G:
-		case DIB0070_P1F:
+		tune = dib0070s_tuning_table;
+		lna_match = dib0070_lna;
+		break;
 		default:
-			FBDiv = (freq / (FREF / 2));
-			Rest  = 2 * freq - FBDiv * FREF;
-			break;
+		tune = dib0070_tuning_table;
+		if (state->cfg->flip_chip)
+			lna_match = dib0070_lna_flip_chip;
+		else
+			lna_match = dib0070_lna;
+		break;
 		}
+		while (freq > tune->max_freq) /* find the right one */
+			tune++;
+		while (freq > lna_match->max_freq) /* find the right one */
+			lna_match++;
 
-		if (Rest < LPF)
-			Rest = 0;
-		else if (Rest < 2 * LPF)
-			Rest = 2 * LPF;
-		else if (Rest > (FREF - LPF)) {
-			Rest = 0;
-			FBDiv += 1;
-		} else if (Rest > (FREF - 2 * LPF))
-			Rest = FREF - 2 * LPF;
-		Rest = (Rest * 6528) / (FREF / 10);
-
-		Den = 1;
-		if (Rest > 0) {
-			state->lo4 |= (1 << 14) | (1 << 12);
-			Den = 255;
-		}
+		state->current_tune_table_index = tune;
+		state->lna_match = lna_match;
+	}
 
+	if (*tune_state == CT_TUNER_START) {
+		dprintk("Tuning for Band: %hd (%d kHz)", band, freq);
+		if (state->current_rf != freq) {
+			u8 REFDIV;
+			u32 FBDiv, Rest, FREF, VCOF_kHz;
+			u8 Den;
 
-		dib0070_write_reg(state, 0x11, (u16)FBDiv);
-		dib0070_write_reg(state, 0x12, (Den << 8) | REFDIV);
-		dib0070_write_reg(state, 0x13, (u16) Rest);
+			state->current_rf = freq;
+			state->lo4 = (state->current_tune_table_index->vco_band << 11) | (state->current_tune_table_index->hfdiv << 7);
 
-		if (state->revision == DIB0070S_P1A) {
 
-			if (band == BAND_SBAND) {
-				dib0070_set_ctrl_lo5(fe, 2, 4, 3, 0);
-				dib0070_write_reg(state, 0x1d, 0xFFFF);
-			} else
-				dib0070_set_ctrl_lo5(fe, 5, 4, 3, 1);
-		}
+			dib0070_write_reg(state, 0x17, 0x30);
 
-		dib0070_write_reg(state, 0x20,
-			0x0040 | 0x0020 | 0x0010 | 0x0008 | 0x0002 | 0x0001 | state->current_tune_table_index->tuner_enable);
 
-		dprintk("REFDIV: %hd, FREF: %d", REFDIV, FREF);
-		dprintk("FBDIV: %d, Rest: %d", FBDiv, Rest);
-		dprintk("Num: %hd, Den: %hd, SD: %hd", (u16) Rest, Den, (state->lo4 >> 12) & 0x1);
-		dprintk("HFDIV code: %hd", state->current_tune_table_index->hfdiv);
-		dprintk("VCO = %hd", state->current_tune_table_index->vco_band);
-		dprintk("VCOF: ((%hd*%d) << 1))", state->current_tune_table_index->vco_multi, freq);
+			VCOF_kHz = state->current_tune_table_index->vco_multi * freq * 2;
 
-		*tune_state = CT_TUNER_STEP_0;
-	} else { /* we are already tuned to this frequency - the configuration is correct  */
-		ret = 50; /* wakeup time */
-		*tune_state = CT_TUNER_STEP_5;
-	}
-    } else if ((*tune_state > CT_TUNER_START) && (*tune_state < CT_TUNER_STEP_4)) {
-
-	ret = dib0070_captrim(state, tune_state);
-
-    } else if (*tune_state == CT_TUNER_STEP_4) {
-	const struct dib0070_wbd_gain_cfg *tmp = state->cfg->wbd_gain;
-	if (tmp != NULL) {
-		while (freq/1000 > tmp->freq) /* find the right one */
-			tmp++;
-		dib0070_write_reg(state, 0x0f,
-			(0 << 15) | (1 << 14) | (3 << 12)
-			| (tmp->wbd_gain_val << 9) | (0 << 8) | (1 << 7)
-			| (state->current_tune_table_index->wbdmux << 0));
-		state->wbd_gain_current = tmp->wbd_gain_val;
-	} else {
+			switch (band) {
+			case BAND_VHF:
+				REFDIV = (u8) ((state->cfg->clock_khz + 9999) / 10000);
+				break;
+			case BAND_FM:
+				REFDIV = (u8) ((state->cfg->clock_khz) / 1000);
+				break;
+			default:
+				REFDIV = (u8) (state->cfg->clock_khz  / 10000);
+				break;
+			}
+			FREF = state->cfg->clock_khz / REFDIV;
+
+
+
+			switch (state->revision) {
+			case DIB0070S_P1A:
+				FBDiv = (VCOF_kHz / state->current_tune_table_index->presc / FREF);
+				Rest  = (VCOF_kHz / state->current_tune_table_index->presc) - FBDiv * FREF;
+				break;
+
+			case DIB0070_P1G:
+			case DIB0070_P1F:
+			default:
+				FBDiv = (freq / (FREF / 2));
+				Rest  = 2 * freq - FBDiv * FREF;
+				break;
+			}
+
+			if (Rest < LPF)
+				Rest = 0;
+			else if (Rest < 2 * LPF)
+				Rest = 2 * LPF;
+			else if (Rest > (FREF - LPF)) {
+				Rest = 0;
+				FBDiv += 1;
+			} else if (Rest > (FREF - 2 * LPF))
+				Rest = FREF - 2 * LPF;
+			Rest = (Rest * 6528) / (FREF / 10);
+
+			Den = 1;
+			if (Rest > 0) {
+				state->lo4 |= (1 << 14) | (1 << 12);
+				Den = 255;
+			}
+
+
+			dib0070_write_reg(state, 0x11, (u16)FBDiv);
+			dib0070_write_reg(state, 0x12, (Den << 8) | REFDIV);
+			dib0070_write_reg(state, 0x13, (u16) Rest);
+
+			if (state->revision == DIB0070S_P1A) {
+
+				if (band == BAND_SBAND) {
+					dib0070_set_ctrl_lo5(fe, 2, 4, 3, 0);
+					dib0070_write_reg(state, 0x1d, 0xFFFF);
+				} else
+					dib0070_set_ctrl_lo5(fe, 5, 4, 3, 1);
+			}
+
+			dib0070_write_reg(state, 0x20,
+				0x0040 | 0x0020 | 0x0010 | 0x0008 | 0x0002 | 0x0001 | state->current_tune_table_index->tuner_enable);
+
+			dprintk("REFDIV: %hd, FREF: %d", REFDIV, FREF);
+			dprintk("FBDIV: %d, Rest: %d", FBDiv, Rest);
+			dprintk("Num: %hd, Den: %hd, SD: %hd", (u16) Rest, Den, (state->lo4 >> 12) & 0x1);
+			dprintk("HFDIV code: %hd", state->current_tune_table_index->hfdiv);
+			dprintk("VCO = %hd", state->current_tune_table_index->vco_band);
+			dprintk("VCOF: ((%hd*%d) << 1))", state->current_tune_table_index->vco_multi, freq);
+
+			*tune_state = CT_TUNER_STEP_0;
+		} else { /* we are already tuned to this frequency - the configuration is correct  */
+			ret = 50; /* wakeup time */
+			*tune_state = CT_TUNER_STEP_5;
+		}
+	} else if ((*tune_state > CT_TUNER_START) && (*tune_state < CT_TUNER_STEP_4)) {
+
+		ret = dib0070_captrim(state, tune_state);
+
+	} else if (*tune_state == CT_TUNER_STEP_4) {
+		const struct dib0070_wbd_gain_cfg *tmp = state->cfg->wbd_gain;
+		if (tmp != NULL) {
+			while (freq/1000 > tmp->freq) /* find the right one */
+				tmp++;
 			dib0070_write_reg(state, 0x0f,
-					  (0 << 15) | (1 << 14) | (3 << 12) | (6 << 9) | (0 << 8) | (1 << 7) | (state->current_tune_table_index->
-														wbdmux << 0));
-	    state->wbd_gain_current = 6;
-	}
+				(0 << 15) | (1 << 14) | (3 << 12)
+				| (tmp->wbd_gain_val << 9) | (0 << 8) | (1 << 7)
+				| (state->current_tune_table_index->wbdmux << 0));
+			state->wbd_gain_current = tmp->wbd_gain_val;
+		} else {
+			dib0070_write_reg(state, 0x0f,
+					  (0 << 15) | (1 << 14) | (3 << 12)
+					  | (6 << 9) | (0 << 8) | (1 << 7)
+					  | (state->current_tune_table_index->wbdmux << 0));
+			state->wbd_gain_current = 6;
+		}
 
-	dib0070_write_reg(state, 0x06, 0x3fff);
+		dib0070_write_reg(state, 0x06, 0x3fff);
 		dib0070_write_reg(state, 0x07,
 				  (state->current_tune_table_index->switch_trim << 11) | (7 << 8) | (state->lna_match->lna_band << 3) | (3 << 0));
-	dib0070_write_reg(state, 0x08, (state->lna_match->lna_band << 10) | (3 << 7) | (127));
-	dib0070_write_reg(state, 0x0d, 0x0d80);
+		dib0070_write_reg(state, 0x08, (state->lna_match->lna_band << 10) | (3 << 7) | (127));
+		dib0070_write_reg(state, 0x0d, 0x0d80);
 
 
-	dib0070_write_reg(state, 0x18,   0x07ff);
-	dib0070_write_reg(state, 0x17, 0x0033);
+		dib0070_write_reg(state, 0x18,   0x07ff);
+		dib0070_write_reg(state, 0x17, 0x0033);
 
 
-	*tune_state = CT_TUNER_STEP_5;
-    } else if (*tune_state == CT_TUNER_STEP_5) {
-	dib0070_set_bandwidth(fe);
-	*tune_state = CT_TUNER_STOP;
-    } else {
-	ret = FE_CALLBACK_TIME_NEVER; /* tuner finished, time to call again infinite */
-    }
-    return ret;
+		*tune_state = CT_TUNER_STEP_5;
+	} else if (*tune_state == CT_TUNER_STEP_5) {
+		dib0070_set_bandwidth(fe);
+		*tune_state = CT_TUNER_STOP;
+	} else {
+		ret = FE_CALLBACK_TIME_NEVER; /* tuner finished, time to call again infinite */
+	}
+	return ret;
 }
 
 
 static int dib0070_tune(struct dvb_frontend *fe)
 {
-    struct dib0070_state *state = fe->tuner_priv;
-    uint32_t ret;
+	struct dib0070_state *state = fe->tuner_priv;
+	uint32_t ret;
 
-    state->tune_state = CT_TUNER_START;
+	state->tune_state = CT_TUNER_START;
 
-    do {
-	ret = dib0070_tune_digital(fe);
-	if (ret != FE_CALLBACK_TIME_NEVER)
-		msleep(ret/10);
-	else
-	    break;
-    } while (state->tune_state != CT_TUNER_STOP);
+	do {
+		ret = dib0070_tune_digital(fe);
+		if (ret != FE_CALLBACK_TIME_NEVER)
+			msleep(ret/10);
+		else
+		break;
+	} while (state->tune_state != CT_TUNER_STOP);
 
-    return 0;
+	return 0;
 }
 
 static int dib0070_wakeup(struct dvb_frontend *fe)
@@ -610,48 +608,48 @@ static const u16 dib0070_p1f_defaults[] =
 
 static u16 dib0070_read_wbd_offset(struct dib0070_state *state, u8 gain)
 {
-    u16 tuner_en = dib0070_read_reg(state, 0x20);
-    u16 offset;
+	u16 tuner_en = dib0070_read_reg(state, 0x20);
+	u16 offset;
 
-    dib0070_write_reg(state, 0x18, 0x07ff);
-    dib0070_write_reg(state, 0x20, 0x0800 | 0x4000 | 0x0040 | 0x0020 | 0x0010 | 0x0008 | 0x0002 | 0x0001);
-    dib0070_write_reg(state, 0x0f, (1 << 14) | (2 << 12) | (gain << 9) | (1 << 8) | (1 << 7) | (0 << 0));
-    msleep(9);
-    offset = dib0070_read_reg(state, 0x19);
-    dib0070_write_reg(state, 0x20, tuner_en);
-    return offset;
+	dib0070_write_reg(state, 0x18, 0x07ff);
+	dib0070_write_reg(state, 0x20, 0x0800 | 0x4000 | 0x0040 | 0x0020 | 0x0010 | 0x0008 | 0x0002 | 0x0001);
+	dib0070_write_reg(state, 0x0f, (1 << 14) | (2 << 12) | (gain << 9) | (1 << 8) | (1 << 7) | (0 << 0));
+	msleep(9);
+	offset = dib0070_read_reg(state, 0x19);
+	dib0070_write_reg(state, 0x20, tuner_en);
+	return offset;
 }
 
 static void dib0070_wbd_offset_calibration(struct dib0070_state *state)
 {
-    u8 gain;
-    for (gain = 6; gain < 8; gain++) {
-	state->wbd_offset_3_3[gain - 6] = ((dib0070_read_wbd_offset(state, gain) * 8 * 18 / 33 + 1) / 2);
-	dprintk("Gain: %d, WBDOffset (3.3V) = %hd", gain, state->wbd_offset_3_3[gain-6]);
-    }
+	u8 gain;
+	for (gain = 6; gain < 8; gain++) {
+		state->wbd_offset_3_3[gain - 6] = ((dib0070_read_wbd_offset(state, gain) * 8 * 18 / 33 + 1) / 2);
+		dprintk("Gain: %d, WBDOffset (3.3V) = %hd", gain, state->wbd_offset_3_3[gain-6]);
+	}
 }
 
 u16 dib0070_wbd_offset(struct dvb_frontend *fe)
 {
-    struct dib0070_state *state = fe->tuner_priv;
-    const struct dib0070_wbd_gain_cfg *tmp = state->cfg->wbd_gain;
-    u32 freq = fe->dtv_property_cache.frequency/1000;
+	struct dib0070_state *state = fe->tuner_priv;
+	const struct dib0070_wbd_gain_cfg *tmp = state->cfg->wbd_gain;
+	u32 freq = fe->dtv_property_cache.frequency/1000;
 
-    if (tmp != NULL) {
-	while (freq/1000 > tmp->freq) /* find the right one */
-	    tmp++;
-	state->wbd_gain_current = tmp->wbd_gain_val;
+	if (tmp != NULL) {
+		while (freq/1000 > tmp->freq) /* find the right one */
+			tmp++;
+		state->wbd_gain_current = tmp->wbd_gain_val;
 	} else
-	state->wbd_gain_current = 6;
+		state->wbd_gain_current = 6;
 
-    return state->wbd_offset_3_3[state->wbd_gain_current - 6];
+	return state->wbd_offset_3_3[state->wbd_gain_current - 6];
 }
 EXPORT_SYMBOL(dib0070_wbd_offset);
 
 #define pgm_read_word(w) (*w)
 static int dib0070_reset(struct dvb_frontend *fe)
 {
-    struct dib0070_state *state = fe->tuner_priv;
+	struct dib0070_state *state = fe->tuner_priv;
 	u16 l, r, *n;
 
 	HARD_RESET(state);
@@ -664,7 +662,7 @@ static int dib0070_reset(struct dvb_frontend *fe)
 #else
 #warning forcing SBAND
 #endif
-		state->revision = DIB0070S_P1A;
+	state->revision = DIB0070S_P1A;
 
 	/* P1F or not */
 	dprintk("Revision: %x", state->revision);
@@ -703,24 +701,25 @@ static int dib0070_reset(struct dvb_frontend *fe)
 		dib0070_write_reg(state, 0x02, r | (1 << 5));
 	}
 
-    if (state->revision == DIB0070S_P1A)
-	dib0070_set_ctrl_lo5(fe, 2, 4, 3, 0);
-    else
-		dib0070_set_ctrl_lo5(fe, 5, 4, state->cfg->charge_pump, state->cfg->enable_third_order_filter);
+	if (state->revision == DIB0070S_P1A)
+		dib0070_set_ctrl_lo5(fe, 2, 4, 3, 0);
+	else
+		dib0070_set_ctrl_lo5(fe, 5, 4, state->cfg->charge_pump,
+				     state->cfg->enable_third_order_filter);
 
 	dib0070_write_reg(state, 0x01, (54 << 9) | 0xc8);
 
-    dib0070_wbd_offset_calibration(state);
+	dib0070_wbd_offset_calibration(state);
 
-    return 0;
+	return 0;
 }
 
 static int dib0070_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-    struct dib0070_state *state = fe->tuner_priv;
+	struct dib0070_state *state = fe->tuner_priv;
 
-    *frequency = 1000 * state->current_rf;
-    return 0;
+	*frequency = 1000 * state->current_rf;
+	return 0;
 }
 
 static int dib0070_release(struct dvb_frontend *fe)
-- 
2.1.0

