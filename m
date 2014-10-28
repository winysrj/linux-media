Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 12/13] [media] lgdt3306a: Break long lines
Date: Tue, 28 Oct 2014 13:00:47 -0200
Message-Id: <dbb4116cf8e670a5c9df7c5c5464ff925c0254b9.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix most of checkpatch warnings like:
	WARNING: line over 80 characters

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index ad483be1b64e..4e0cf443b9ff 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -220,13 +220,17 @@ static int lgdt3306a_mpeg_mode(struct lgdt3306a_state *state,
 	int ret;
 
 	dbg_info("(%d)\n", mode);
-	/* transport packet format */
-	ret = lgdt3306a_set_reg_bit(state, 0x0071, 7, mode == LGDT3306A_MPEG_PARALLEL?1:0); /* TPSENB=0x80 */
+	/* transport packet format - TPSENB=0x80 */
+	ret = lgdt3306a_set_reg_bit(state, 0x0071, 7,
+				     mode == LGDT3306A_MPEG_PARALLEL ? 1 : 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
-	/* start of packet signal duration */
-	ret = lgdt3306a_set_reg_bit(state, 0x0071, 6, 0); /* TPSSOPBITEN=0x40; 0=byte duration, 1=bit duration */
+	/*
+	 * start of packet signal duration
+	 * TPSSOPBITEN=0x40; 0=byte duration, 1=bit duration
+	 */
+	ret = lgdt3306a_set_reg_bit(state, 0x0071, 6, 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
@@ -285,17 +289,23 @@ static int lgdt3306a_mpeg_tristate(struct lgdt3306a_state *state,
 		ret = lgdt3306a_read_reg(state, 0x0070, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= ~0xa8; /* Tristate bus; TPOUTEN=0x80, TPCLKOUTEN=0x20, TPDATAOUTEN=0x08 */
+		/*
+		 * Tristate bus; TPOUTEN=0x80, TPCLKOUTEN=0x20,
+		 * TPDATAOUTEN=0x08
+		 */
+		val &= ~0xa8;
 		ret = lgdt3306a_write_reg(state, 0x0070, val);
 		if (lg_chkerr(ret))
 			goto fail;
 
-		ret = lgdt3306a_set_reg_bit(state, 0x0003, 6, 1); /* AGCIFOUTENB=0x40; 1=Disable IFAGC pin */
+		/* AGCIFOUTENB=0x40; 1=Disable IFAGC pin */
+		ret = lgdt3306a_set_reg_bit(state, 0x0003, 6, 1);
 		if (lg_chkerr(ret))
 			goto fail;
 
 	} else {
-		ret = lgdt3306a_set_reg_bit(state, 0x0003, 6, 0); /* enable IFAGC pin */
+		/* enable IFAGC pin */
+		ret = lgdt3306a_set_reg_bit(state, 0x0003, 6, 0);
 		if (lg_chkerr(ret))
 			goto fail;
 
@@ -331,20 +341,24 @@ static int lgdt3306a_power(struct lgdt3306a_state *state,
 	dbg_info("(%d)\n", mode);
 
 	if (mode == 0) {
-		ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 0); /* into reset */
+		/* into reset */
+		ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 0);
 		if (lg_chkerr(ret))
 			goto fail;
 
-		ret = lgdt3306a_set_reg_bit(state, 0x0000, 0, 0); /* power down */
+		/* power down */
+		ret = lgdt3306a_set_reg_bit(state, 0x0000, 0, 0);
 		if (lg_chkerr(ret))
 			goto fail;
 
 	} else {
-		ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 1); /* out of reset */
+		/* out of reset */
+		ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 1);
 		if (lg_chkerr(ret))
 			goto fail;
 
-		ret = lgdt3306a_set_reg_bit(state, 0x0000, 0, 1); /* power up */
+		/* power up */
+		ret = lgdt3306a_set_reg_bit(state, 0x0000, 0, 1);
 		if (lg_chkerr(ret))
 			goto fail;
 	}
@@ -658,8 +672,8 @@ static int lgdt3306a_set_inversion_auto(struct lgdt3306a_state *state,
 
 	dbg_info("(%d)\n", enabled);
 
-	/* 0=Manual 1=Auto(QAM only) */
-	ret = lgdt3306a_set_reg_bit(state, 0x0002, 3, enabled);/* SPECINVAUTO=0x04 */
+	/* 0=Manual 1=Auto(QAM only) - SPECINVAUTO=0x04 */
+	ret = lgdt3306a_set_reg_bit(state, 0x0002, 3, enabled);
 	return ret;
 }
 
@@ -671,17 +685,22 @@ static int lgdt3306a_spectral_inversion(struct lgdt3306a_state *state,
 
 	dbg_info("(%d)\n", inversion);
 #if 0
-/* FGR - spectral_inversion defaults already set for VSB and QAM; can enable later if desired */
+	/*
+	 * FGR - spectral_inversion defaults already set for VSB and QAM;
+	 * can enable later if desired
+	 */
 
 	ret = lgdt3306a_set_inversion(state, inversion);
 
 	switch (p->modulation) {
 	case VSB_8:
-		ret = lgdt3306a_set_inversion_auto(state, 0); /* Manual only for VSB */
+		/* Manual only for VSB */
+		ret = lgdt3306a_set_inversion_auto(state, 0);
 		break;
 	case QAM_64:
 	case QAM_256:
-		ret = lgdt3306a_set_inversion_auto(state, 1); /* Auto ok for QAM */
+		/* Auto ok for QAM */
+		ret = lgdt3306a_set_inversion_auto(state, 1);
 		break;
 	default:
 		ret = -EINVAL;
@@ -711,7 +730,8 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 
 	switch (if_freq_khz) {
 	default:
-	    pr_warn("IF=%d KHz is not supportted, 3250 assumed\n", if_freq_khz);
+		pr_warn("IF=%d KHz is not supportted, 3250 assumed\n",
+			if_freq_khz);
 		/* fallthrough */
 	case 3250: /* 3.25Mhz */
 		nco1 = 0x34;
@@ -758,7 +778,8 @@ static int lgdt3306a_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	}
 	dbg_info("(%d)\n", enable);
 
-	return lgdt3306a_set_reg_bit(state, 0x0002, 7, enable ? 0 : 1); /* NI2CRPTEN=0x80 */
+	/* NI2CRPTEN=0x80 */
+	return lgdt3306a_set_reg_bit(state, 0x0002, 7, enable ? 0 : 1);
 }
 
 static int lgdt3306a_sleep(struct lgdt3306a_state *state)
@@ -810,22 +831,30 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 		goto fail;
 
 	/* 4. Peak-to-peak voltage of ADC input signal */
-	ret = lgdt3306a_set_reg_bit(state, 0x0004, 7, 1); /* ADCSEL1V=0x80=1Vpp; 0x00=2Vpp */
+
+	/* ADCSEL1V=0x80=1Vpp; 0x00=2Vpp */
+	ret = lgdt3306a_set_reg_bit(state, 0x0004, 7, 1);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 5. ADC output data capture clock phase */
-	ret = lgdt3306a_set_reg_bit(state, 0x0004, 2, 0); /* 0=same phase as ADC clock */
+
+	/* 0=same phase as ADC clock */
+	ret = lgdt3306a_set_reg_bit(state, 0x0004, 2, 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 5a. ADC sampling clock source */
-	ret = lgdt3306a_set_reg_bit(state, 0x0004, 3, 0); /* ADCCLKPLLSEL=0x08; 0=use ext clock, not PLL */
+
+	/* ADCCLKPLLSEL=0x08; 0=use ext clock, not PLL */
+	ret = lgdt3306a_set_reg_bit(state, 0x0004, 3, 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 6. Automatic PLL set */
-	ret = lgdt3306a_set_reg_bit(state, 0x0005, 6, 0); /* PLLSETAUTO=0x40; 0=off */
+
+	/* PLLSETAUTO=0x40; 0=off */
+	ret = lgdt3306a_set_reg_bit(state, 0x0005, 6, 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
@@ -980,7 +1009,7 @@ static int lgdt3306a_set_parameters(struct dvb_frontend *fe)
 		goto fail;
 
 	ret = lgdt3306a_spectral_inversion(state, p,
-					  state->cfg->spectral_inversion ? 1 : 0);
+					state->cfg->spectral_inversion ? 1 : 0);
 	if (lg_chkerr(ret))
 		goto fail;
 
@@ -1015,7 +1044,8 @@ static int lgdt3306a_get_frontend(struct dvb_frontend *fe)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	dbg_info("(%u, %d)\n", state->current_frequency, state->current_modulation);
+	dbg_info("(%u, %d)\n",
+		 state->current_frequency, state->current_modulation);
 
 	p->modulation = state->current_modulation;
 	p->frequency = state->current_frequency;
@@ -1071,7 +1101,9 @@ static int lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 	if (ret)
 		return ret;
 	val &= 0xf8;
-	if ((snrRef > 18) && (maxPowerMan > 0x68) && (nCombDet == 0x01) && ((fbDlyCir == 0x03FF) || (fbDlyCir < 0x6C)))	{
+	if ((snrRef > 18) && (maxPowerMan > 0x68)
+	    && (nCombDet == 0x01)
+	    && ((fbDlyCir == 0x03FF) || (fbDlyCir < 0x6C))) {
 		/* SNR is over 18dB and no ghosting */
 		val |= 0x00; /* final bandwidth = 0 */
 	} else {
@@ -1104,7 +1136,8 @@ static int lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 	return ret;
 }
 
-static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_state *state)
+static enum lgdt3306a_modulation
+lgdt3306a_check_oper_mode(struct lgdt3306a_state *state)
 {
 	u8 val = 0;
 	int ret;
@@ -1134,8 +1167,9 @@ err:
 	return LG3306_UNKNOWN_MODE;
 }
 
-static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_state *state,
-			enum lgdt3306a_lock_check whatLock)
+static enum lgdt3306a_lock_status
+lgdt3306a_check_lock_status(struct lgdt3306a_state *state,
+			    enum lgdt3306a_lock_check whatLock)
 {
 	u8 val = 0;
 	int ret;
@@ -1219,7 +1253,8 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 	return lockStatus;
 }
 
-static enum lgdt3306a_neverlock_status lgdt3306a_check_neverlock_status(struct lgdt3306a_state *state)
+static enum lgdt3306a_neverlock_status
+lgdt3306a_check_neverlock_status(struct lgdt3306a_state *state)
 {
 	u8 val = 0;
 	int ret;
@@ -1267,7 +1302,8 @@ static int lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 		snrRef, mainStrong, aiccrejStatus, currChDiffACQ);
 
 #if 0
-	if ((mainStrong == 0) && (currChDiffACQ > 0x70)) /* Dynamic ghost exists */
+	/* Dynamic ghost exists */
+	if ((mainStrong == 0) && (currChDiffACQ > 0x70))
 #endif
 	if (mainStrong == 0) {
 		ret = lgdt3306a_read_reg(state, 0x2135, &val);
@@ -1317,7 +1353,8 @@ static int lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 	return 0;
 }
 
-static enum lgdt3306a_lock_status lgdt3306a_sync_lock_poll(struct lgdt3306a_state *state)
+static enum lgdt3306a_lock_status
+lgdt3306a_sync_lock_poll(struct lgdt3306a_state *state)
 {
 	enum lgdt3306a_lock_status syncLockStatus = LG3306_UNLOCK;
 	int	i;
@@ -1325,7 +1362,8 @@ static enum lgdt3306a_lock_status lgdt3306a_sync_lock_poll(struct lgdt3306a_stat
 	for (i = 0; i < 2; i++)	{
 		msleep(30);
 
-		syncLockStatus = lgdt3306a_check_lock_status(state, LG3306_SYNC_LOCK);
+		syncLockStatus = lgdt3306a_check_lock_status(state,
+							     LG3306_SYNC_LOCK);
 
 		if (syncLockStatus == LG3306_LOCK) {
 			dbg_info("locked(%d)\n", i);
@@ -1336,7 +1374,8 @@ static enum lgdt3306a_lock_status lgdt3306a_sync_lock_poll(struct lgdt3306a_stat
 	return LG3306_UNLOCK;
 }
 
-static enum lgdt3306a_lock_status lgdt3306a_fec_lock_poll(struct lgdt3306a_state *state)
+static enum lgdt3306a_lock_status
+lgdt3306a_fec_lock_poll(struct lgdt3306a_state *state)
 {
 	enum lgdt3306a_lock_status FECLockStatus = LG3306_UNLOCK;
 	int	i;
@@ -1344,7 +1383,8 @@ static enum lgdt3306a_lock_status lgdt3306a_fec_lock_poll(struct lgdt3306a_state
 	for (i = 0; i < 2; i++)	{
 		msleep(30);
 
-		FECLockStatus = lgdt3306a_check_lock_status(state, LG3306_FEC_LOCK);
+		FECLockStatus = lgdt3306a_check_lock_status(state,
+							    LG3306_FEC_LOCK);
 
 		if (FECLockStatus == LG3306_LOCK) {
 			dbg_info("locked(%d)\n", i);
@@ -1355,7 +1395,8 @@ static enum lgdt3306a_lock_status lgdt3306a_fec_lock_poll(struct lgdt3306a_state
 	return FECLockStatus;
 }
 
-static enum lgdt3306a_neverlock_status lgdt3306a_neverlock_poll(struct lgdt3306a_state *state)
+static enum lgdt3306a_neverlock_status
+lgdt3306a_neverlock_poll(struct lgdt3306a_state *state)
 {
 	enum lgdt3306a_neverlock_status NLLockStatus = LG3306_NL_FAIL;
 	int	i;
@@ -1458,7 +1499,8 @@ static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
 	return snr_x100;
 }
 
-static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state *state)
+static enum lgdt3306a_lock_status
+lgdt3306a_vsb_lock_poll(struct lgdt3306a_state *state)
 {
 	int ret;
 	u8 cnt = 0;
@@ -1488,7 +1530,8 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 	return LG3306_UNLOCK;
 }
 
-static enum lgdt3306a_lock_status lgdt3306a_qam_lock_poll(struct lgdt3306a_state *state)
+static enum lgdt3306a_lock_status
+lgdt3306a_qam_lock_poll(struct lgdt3306a_state *state)
 {
 	u8 cnt;
 	u8 packet_error;
@@ -1632,7 +1675,7 @@ static int lgdt3306a_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	*ber = 0;
 #if 1
-	/* FGR - BUGBUG - I don't know what value is expected by dvb_core
+	/* FGR - FIXME - I don't know what value is expected by dvb_core
 	 * what is the scale of the value?? */
 	tmp =              read_reg(state, 0x00fc); /* NBERVALUE[24-31] */
 	tmp = (tmp << 8) | read_reg(state, 0x00fd); /* NBERVALUE[16-23] */
@@ -1650,7 +1693,7 @@ static int lgdt3306a_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 	*ucblocks = 0;
 #if 1
-	/* FGR - BUGBUG - I don't know what value is expected by dvb_core
+	/* FGR - FIXME - I don't know what value is expected by dvb_core
 	 * what happens when value wraps? */
 	*ucblocks = read_reg(state, 0x00f4); /* TPIFTPERRCNT[0-7] */
 	dbg_info("ucblocks=%u\n", *ucblocks);
@@ -1659,7 +1702,9 @@ static int lgdt3306a_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int lgdt3306a_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+static int lgdt3306a_tune(struct dvb_frontend *fe, bool re_tune,
+			  unsigned int mode_flags, unsigned int *delay,
+			  fe_status_t *status)
 {
 	int ret = 0;
 	struct lgdt3306a_state *state = fe->demodulator_priv;
@@ -1761,7 +1806,8 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if ((val & 0x74) != 0x74) {
 		pr_warn("expected 0x74, got 0x%x\n", (val & 0x74));
 #if 0
-		goto fail;	/* BUGBUG - re-enable when we know this is right */
+		/* FIXME - re-enable when we know this is right */
+		goto fail;
 #endif
 	}
 	ret = lgdt3306a_read_reg(state, 0x0001, &val);
@@ -1770,7 +1816,8 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if ((val & 0xf6) != 0xc6) {
 		pr_warn("expected 0xc6, got 0x%x\n", (val & 0xf6));
 #if 0
-		goto fail;	/* BUGBUG - re-enable when we know this is right */
+		/* FIXME - re-enable when we know this is right */
+		goto fail;
 #endif
 	}
 	ret = lgdt3306a_read_reg(state, 0x0002, &val);
@@ -1779,7 +1826,8 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if ((val & 0x73) != 0x03) {
 		pr_warn("expected 0x03, got 0x%x\n", (val & 0x73));
 #if 0
-		goto fail;	/* BUGBUG - re-enable when we know this is right */
+		/* FIXME - re-enable when we know this is right */
+		goto fail;
 #endif
 	}
 
-- 
1.9.3

