Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0569DC10F02
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06B0217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518163;
	bh=SLpI1BUVvLF9J8i+oDasa1T+QN5bD7LdPC388iIYbHo=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=W4td8DTjdyYpEZDJ6C0NoBzBHlRJYU2YDHVHQDK2JWL2WrUPNkC/qxU2XCPuIbxyh
	 6G6uJ01PW86DB1P2Naet5mDqxg/HaZ3eFE6XO2pDhcx98JuuMw2ZWbbYYk4tj03BgQ
	 xrLuULSCu2q+eJlfBav+r/UjkEkDoMVDIgGoSHRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfBRT3W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfBRT3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D1MRWGEVf0jf5ABGZwBCSdPpOyF0gvGPm9AqEheL+Ok=; b=C4F6e04ah+7a2Ujn6r6ao0RnR
        BCHZlgqltHdvR4z33hVpcsXg+Fwq4skMOX1kPewjrsiRX1N3qWbJINdMd+dro3vuvCcfX1emIub0Q
        q4MufdE+2JUKGK55aCh1Xq0mgJBVFpNCq4pSC9fbUunpTzuTnAmeuaGQwjFYH6VrMxwwJAGhGGULo
        xlZYX0modk1YMNEiyJLl/8nL+jPikTWQWRu/Vr35KHTpk+BwwGmjo7O/zVIKCRccsEb5Tma+yZErI
        /Fwhwr43x1fMl6uF1NQdTkZbE9nCUC4WlPQjhwQU5FQN/rnPqexSfNNT5g16Fwv+23FgMd+hZQ15q
        lC6/+qwZQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Un-6b; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fb-70; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/14] media: dvb-frontends: fix several typos
Date:   Mon, 18 Feb 2019 14:28:55 -0500
Message-Id: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/cxd2841er.c       |  2 +-
 drivers/media/dvb-frontends/dib0090.c         |  2 +-
 drivers/media/dvb-frontends/dib7000m.c        |  4 +-
 drivers/media/dvb-frontends/dib7000p.c        |  8 ++--
 drivers/media/dvb-frontends/dib8000.c         | 12 ++---
 drivers/media/dvb-frontends/dib9000.c         |  4 +-
 .../dvb-frontends/drx39xyj/drx_dap_fasi.h     |  8 ++--
 .../media/dvb-frontends/drx39xyj/drx_driver.h |  8 ++--
 drivers/media/dvb-frontends/drx39xyj/drxj.c   | 48 +++++++++----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h   | 12 ++---
 drivers/media/dvb-frontends/drxd_firm.c       |  2 +-
 drivers/media/dvb-frontends/drxk.h            |  2 +-
 drivers/media/dvb-frontends/drxk_hard.c       |  8 ++--
 drivers/media/dvb-frontends/ds3000.c          |  4 +-
 drivers/media/dvb-frontends/isl6421.c         |  2 +-
 drivers/media/dvb-frontends/m88rs2000.c       |  2 +-
 drivers/media/dvb-frontends/nxt200x.c         |  4 +-
 drivers/media/dvb-frontends/or51211.c         |  2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c     |  2 +-
 drivers/media/dvb-frontends/s5h1409.c         |  2 +-
 drivers/media/dvb-frontends/stb0899_algo.c    |  6 +--
 drivers/media/dvb-frontends/stv0367_defs.h    |  2 +-
 drivers/media/dvb-frontends/stv0900_core.c    |  4 +-
 drivers/media/dvb-frontends/stv0910.c         |  4 +-
 drivers/media/dvb-frontends/stv6110.c         |  2 +-
 drivers/media/dvb-frontends/tda1004x.h        |  2 +-
 drivers/media/dvb-frontends/tda10086.c        |  2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c    |  6 +--
 28 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index c98093ed3dd7..8acf0b91b437 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2947,7 +2947,7 @@ static int cxd2841er_sleep_tc_to_active_t(struct cxd2841er_priv *priv,
 		((priv->flags & CXD2841ER_ASCOT) ? 0x01 : 0x00), 0x01);
 	/* Set SLV-T Bank : 0x18 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x18);
-	/* Pre-RS BER moniter setting */
+	/* Pre-RS BER monitor setting */
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x36, 0x40, 0x07);
 	/* FEC Auto Recovery setting */
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x30, 0x01, 0x01);
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 4813a88eb9f7..18c41cfef8d6 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2459,7 +2459,7 @@ static int dib0090_tune(struct dvb_frontend *fe)
 		state->current_standard = state->fe->dtv_property_cache.delivery_system;
 
 		ret = 20;
-		state->calibrate = CAPTRIM_CAL;	/* captrim serach now */
+		state->calibrate = CAPTRIM_CAL;	/* captrim search now */
 	}
 
 	else if (*tune_state == CT_TUNER_STEP_0) {	/* Warning : because of captrim cal, if you change this step, change it also in _cal.c file because it is the step following captrim cal state machine */
diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index b79358d09de6..389db9077ad5 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -369,7 +369,7 @@ static int dib7000m_sad_calib(struct dib7000m_state *state)
 {
 
 /* internal */
-//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writting in set_bandwidth
+//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writing in set_bandwidth
 	dib7000m_write_word(state, 929, (0 << 1) | (0 << 0));
 	dib7000m_write_word(state, 930, 776); // 0.625*3.3 / 4096
 
@@ -928,7 +928,7 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dtv_fronte
 	}
 	state->div_sync_wait = (value * 3) / 2 + 32; // add 50% SFN margin + compensate for one DVSY-fifo TODO
 
-	/* deactive the possibility of diversity reception if extended interleave - not for 7000MC */
+	/* deactivate the possibility of diversity reception if extended interleave - not for 7000MC */
 	/* P_dvsy_sync_mode = 0, P_dvsy_sync_enable=1, P_dvcb_comb_mode=2 */
 	if (1 == 1 || state->revision > 0x4000)
 		state->div_force_off = 0;
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 2818e8def1b3..f8040f6def62 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -94,7 +94,7 @@ enum dib7000p_power_mode {
 	DIB7000P_POWER_INTERFACE_ONLY,
 };
 
-/* dib7090 specific fonctions */
+/* dib7090 specific functions */
 static int dib7090_set_output_mode(struct dvb_frontend *fe, int mode);
 static int dib7090_set_diversity_in(struct dvb_frontend *fe, int onoff);
 static void dib7090_setDibTxMux(struct dib7000p_state *state, int mode);
@@ -319,7 +319,7 @@ static void dib7000p_set_adc_state(struct dib7000p_state *state, enum dibx000_ad
 
 			dib7000p_write_word(state, 1925, reg | (1 << 4) | (1 << 2));	/* en_slowAdc = 1 & reset_sladc = 1 */
 
-			reg = dib7000p_read_word(state, 1925);	/* read acces to make it works... strange ... */
+			reg = dib7000p_read_word(state, 1925);	/* read access to make it works... strange ... */
 			msleep(200);
 			dib7000p_write_word(state, 1925, reg & ~(1 << 4));	/* en_slowAdc = 1 & reset_sladc = 0 */
 
@@ -1101,7 +1101,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state,
 	else
 		state->div_sync_wait = (value * 3) / 2 + state->cfg.diversity_delay;
 
-	/* deactive the possibility of diversity reception if extended interleaver */
+	/* deactivate the possibility of diversity reception if extended interleaver */
 	state->div_force_off = !1 && ch->transmission_mode != TRANSMISSION_MODE_8K;
 	dib7000p_set_diversity_in(&state->demod, state->div_state);
 
@@ -2378,7 +2378,7 @@ static int dib7090_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[]
 		}
 	}
 
-	if (apb_address != 0)	/* R/W acces via APB */
+	if (apb_address != 0)	/* R/W access via APB */
 		return dib7090p_rw_on_apb(i2c_adap, msg, num, apb_address);
 	else			/* R/W access via SERPAR  */
 		return w7090p_tuner_rw_serpar(i2c_adap, msg, num);
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 3c3f8cb14845..85c429cce23e 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -564,7 +564,7 @@ static int dib8000_set_adc_state(struct dib8000_state *state, enum dibx000_adc_s
 			dib8000_write_word(state, 1925, reg |
 					(1<<4) | (1<<2));
 
-			/* read acces to make it works... strange ... */
+			/* read access to make it works... strange ... */
 			reg = dib8000_read_word(state, 1925);
 			msleep(20);
 			/* en_slowAdc = 1 & reset_sladc = 0 */
@@ -1091,7 +1091,7 @@ static int dib8000_reset(struct dvb_frontend *fe)
 
 	if ((state->revision != 0x8090) &&
 			(dib8000_set_output_mode(fe, OUTMODE_HIGH_Z) != 0))
-		dprintk("OUTPUT_MODE could not be resetted.\n");
+		dprintk("OUTPUT_MODE could not be reset.\n");
 
 	state->current_agc = NULL;
 
@@ -1867,7 +1867,7 @@ static int dib8096p_tuner_xfer(struct i2c_adapter *i2c_adap,
 			}
 	}
 
-	if (apb_address != 0) /* R/W acces via APB */
+	if (apb_address != 0) /* R/W access via APB */
 		return dib8096p_rw_on_apb(i2c_adap, msg, num, apb_address);
 	else  /* R/W access via SERPAR  */
 		return dib8096p_tuner_rw_serpar(i2c_adap, msg, num);
@@ -3082,7 +3082,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			state->autosearch_state = AS_DONE;
 			*tune_state = CT_DEMOD_STOP; /* else we are done here */
 			break;
-		case 2: /* Succes */
+		case 2: /* Success */
 			state->status = FE_STATUS_FFT_SUCCESS; /* signal to the upper layer, that there was a channel found and the parameters can be read */
 			*tune_state = CT_DEMOD_STEP_3;
 			if (state->autosearch_state == AS_SEARCHING_GUARD)
@@ -3193,10 +3193,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	case CT_DEMOD_STEP_6: /* (36)  if there is an input (diversity) */
 		if ((state->fe[1] != NULL) && (state->output_mode != OUTMODE_DIVERSITY)) {
-			/* if there is a diversity fe in input and this fe is has not already failled : wait here until this this fe has succedeed or failled */
+			/* if there is a diversity fe in input and this fe is has not already failed : wait here until this this fe has succedeed or failed */
 			if (dib8000_get_status(state->fe[1]) <= FE_STATUS_STD_SUCCESS) /* Something is locked on the input fe */
 				*tune_state = CT_DEMOD_STEP_8; /* go for mpeg */
-			else if (dib8000_get_status(state->fe[1]) >= FE_STATUS_TUNE_TIME_TOO_SHORT) { /* fe in input failled also, break the current one */
+			else if (dib8000_get_status(state->fe[1]) >= FE_STATUS_TUNE_TIME_TOO_SHORT) { /* fe in input failed also, break the current one */
 				*tune_state = CT_DEMOD_STOP; /* else we are done here ; step 8 will close the loops and exit */
 				dib8000_viterbi_state(state, 1); /* start viterbi chandec */
 				dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 0183fb1346ef..1875da07c150 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -1020,7 +1020,7 @@ static int dib9000_risc_apb_access_read(struct dib9000_state *state, u32 address
 	if (address >= 1024 || !state->platform.risc.fw_is_running)
 		return -EINVAL;
 
-	/* dprintk( "APB access thru rd fw %d %x\n", address, attribute); */
+	/* dprintk( "APB access through rd fw %d %x\n", address, attribute); */
 
 	mb[0] = (u16) address;
 	mb[1] = len / 2;
@@ -1050,7 +1050,7 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
 	if (len > 18)
 		return -EINVAL;
 
-	/* dprintk( "APB access thru wr fw %d %x\n", address, attribute); */
+	/* dprintk( "APB access through wr fw %d %x\n", address, attribute); */
 
 	mb[0] = (u16)address;
 	for (i = 0; i + 1 < len; i += 2)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 23ae72468025..739dc5590fa4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -67,7 +67,7 @@
 * (2 bytes). The DAP can operate in 3 modes:
 * (1) only short
 * (2) only long
-* (3) both long and short but short preferred and long only when necesarry
+* (3) both long and short but short preferred and long only when necessary
 *
 * These modes must be selected compile time via compile switches.
 * Compile switch settings for the different modes:
@@ -112,14 +112,14 @@
 *  + single master mode means no use of repeated starts
 *  + multi master mode means use of repeated starts
 *  Default is single master.
-*  Default can be overriden by setting the compile switch DRXDAP_SINGLE_MASTER.
+*  Default can be overridden by setting the compile switch DRXDAP_SINGLE_MASTER.
 *
 * Slave:
 * Single/multi master selected via the flags in the FASI protocol.
 *  + single master means remember memory address between i2c packets
 *  + multimaster means flush memory address between i2c packets
 *  Default is single master, DAP FASI changes multi-master setting silently
-*  into single master setting. This cannot be overrriden.
+*  into single master setting. This cannot be overridden.
 *
 */
 /* set default */
@@ -139,7 +139,7 @@
 * In single master mode, data can be written by sending the register address
 * first, then two or four bytes of data in the next packet.
 * Because the device address plus a register address equals five bytes,
-* the mimimum chunk size must be five.
+* the minimum chunk size must be five.
 * If ten-bit I2C device addresses are used, the minimum chunk size must be six,
 * because the I2C device address will then occupy two bytes when writing.
 *
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 1ec20eecc433..15f7e58c5a30 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -94,7 +94,7 @@ int drxbsp_i2c_term(void);
 * \param r_count   The number of bytes to read
 * \param r_data    The array to read the data from
 * \return int Return status.
-* \retval 0 Succes.
+* \retval 0 Success.
 * \retval -EIO Failure.
 * \retval -EINVAL Parameter 'wcount' is not zero but parameter
 *                                       'wdata' contains NULL.
@@ -986,7 +986,7 @@ struct drx_filter_info {
 * \struct struct drx_channel * \brief The set of parameters describing a single channel.
 *
 * Used by DRX_CTRL_SET_CHANNEL and DRX_CTRL_GET_CHANNEL.
-* Only certain fields need to be used for a specfic standard.
+* Only certain fields need to be used for a specific standard.
 *
 */
 struct drx_channel {
@@ -1606,7 +1606,7 @@ struct drx_version_list {
 		DRX_AUD_I2S_MATRIX_B_MONO,
 					/*< B sound only, stereo or mono     */
 		DRX_AUD_I2S_MATRIX_STEREO,
-					/*< A+B sound, transparant           */
+					/*< A+B sound, transparent           */
 		DRX_AUD_I2S_MATRIX_MONO	/*< A+B mixed to mono sum, (L+R)/2   */};
 
 /*
@@ -1870,7 +1870,7 @@ struct drx_reg_dump {
 				      /*< current power management mode      */
 
 		/* Tuner */
-		u8 tuner_port_nr;     /*< nr of I2C port to wich tuner is    */
+		u8 tuner_port_nr;     /*< nr of I2C port to which tuner is    */
 		s32 tuner_min_freq_rf;
 				      /*< minimum RF input frequency, in kHz */
 		s32 tuner_max_freq_rf;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 551b7d65fa66..f30374ba7800 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -380,10 +380,10 @@ DEFINES
 */
 
 /*****************************************************************************/
-/* Audio block 0x103 is write only. To avoid shadowing in driver accessing    */
-/* RAM adresses directly. This must be READ ONLY to avoid problems.           */
-/* Writing to the interface adresses is more than only writing the RAM        */
-/* locations                                                                  */
+/* Audio block 0x103 is write only. To avoid shadowing in driver accessing   */
+/* RAM addresses directly. This must be READ ONLY to avoid problems.         */
+/* Writing to the interface addresses is more than only writing the RAM      */
+/* locations                                                                 */
 /*****************************************************************************/
 /*
 * \brief RAM location of MODUS registers
@@ -656,8 +656,8 @@ static struct drxj_data drxj_data_g = {
 	false,			/* flag: true=bypass             */
 	ATV_TOP_VID_PEAK__PRE,	/* shadow of ATV_TOP_VID_PEAK__A */
 	ATV_TOP_NOISE_TH__PRE,	/* shadow of ATV_TOP_NOISE_TH__A */
-	true,			/* flag CVBS ouput enable        */
-	false,			/* flag SIF ouput enable         */
+	true,			/* flag CVBS output enable       */
+	false,			/* flag SIF output enable        */
 	DRXJ_SIF_ATTENUATION_0DB,	/* current SIF att setting       */
 	{			/* qam_rf_agc_cfg */
 	 DRX_STANDARD_ITU_B,	/* standard            */
@@ -832,7 +832,7 @@ static struct drx_common_attr drxj_default_comm_attr_g = {
 	false,			/* If true mirror frequency spectrum            */
 	{
 	 /* MPEG output configuration */
-	 true,			/* If true, enable MPEG ouput    */
+	 true,			/* If true, enable MPEG output   */
 	 false,			/* If true, insert RS byte       */
 	 false,			/* If true, parallel out otherwise serial */
 	 false,			/* If true, invert DATA signals  */
@@ -848,7 +848,7 @@ static struct drx_common_attr drxj_default_comm_attr_g = {
 	 DRX_MPEG_STR_WIDTH_1	/* MPEG Start width in clock cycles */
 	 },
 	/* Initilisations below can be omitted, they require no user input and
-	   are initialy 0, NULL or false. The compiler will initialize them to these
+	   are initially 0, NULL or false. The compiler will initialize them to these
 	   values when omitted.  */
 	false,			/* is_opened */
 
@@ -869,7 +869,7 @@ static struct drx_common_attr drxj_default_comm_attr_g = {
 	DRX_POWER_UP,
 
 	/* Tuner */
-	1,			/* nr of I2C port to wich tuner is     */
+	1,			/* nr of I2C port to which tuner is    */
 	0L,			/* minimum RF input frequency, in kHz  */
 	0L,			/* maximum RF input frequency, in kHz  */
 	false,			/* Rf Agc Polarity                     */
@@ -1656,7 +1656,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		   sequense will be visible: (1) write address {i2c addr,
 		   4 bytes chip address} (2) write data {i2c addr, 4 bytes data }
 		   (3) write address (4) write data etc...
-		   Address must be rewriten because HI is reset after data transport and
+		   Address must be rewritten because HI is reset after data transport and
 		   expects an address.
 		 */
 		todo = (block_size < datasize ? block_size : datasize);
@@ -1820,7 +1820,7 @@ static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
 * \param wdata    Data to write
 * \param rdata    Buffer for data to read
 * \return int
-* \retval 0 Succes
+* \retval 0 Success
 * \retval -EIO Timeout, I2C error, illegal bank
 *
 * 16 bits register read modify write access using short addressing format only.
@@ -1897,7 +1897,7 @@ static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 * \param addr
 * \param data
 * \return int
-* \retval 0 Succes
+* \retval 0 Success
 * \retval -EIO Timeout, I2C error, illegal bank
 *
 * 16 bits register read access via audio token ring interface.
@@ -2004,7 +2004,7 @@ static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
 * \param addr
 * \param data
 * \return int
-* \retval 0 Succes
+* \retval 0 Success
 * \retval -EIO Timeout, I2C error, illegal bank
 *
 * 16 bits register write access via audio token ring interface.
@@ -2094,7 +2094,7 @@ static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
 * \param datasize size of data buffer in bytes
 * \param data     pointer to data buffer
 * \return int
-* \retval 0 Succes
+* \retval 0 Success
 * \retval -EIO Timeout, I2C error, illegal bank
 *
 */
@@ -2338,7 +2338,7 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 	if ((cmd->cmd) == SIO_HI_RA_RAM_CMD_RESET)
 		msleep(1);
 
-	/* Detect power down to ommit reading result */
+	/* Detect power down to omit reading result */
 	powerdown_cmd = (bool) ((cmd->cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
 				  (((cmd->
 				     param5) & SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M)
@@ -2754,7 +2754,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if (cfg_data->enable_mpeg_output == true) {
-		/* quick and dirty patch to set MPEG incase current std is not
+		/* quick and dirty patch to set MPEG in case current std is not
 		   producing MPEG */
 		switch (ext_attr->standard) {
 		case DRX_STANDARD_8VSB:
@@ -2894,7 +2894,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 			break;
 		default:
 			break;
-		}		/* swtich (standard) */
+		}		/* switch (standard) */
 
 		/* Check insertion of the Reed-Solomon parity bytes */
 		rc = drxj_dap_read_reg16(dev_addr, FEC_OC_MODE__A, &fec_oc_reg_mode, 0);
@@ -4127,7 +4127,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 * \param datasize size of data buffer in bytes
 * \param data     pointer to data buffer
 * \return int
-* \retval 0 Succes
+* \retval 0 Success
 * \retval -EIO Timeout, I2C error, illegal bank
 *
 */
@@ -8989,7 +8989,7 @@ qam64auto(struct drx_demod_instance *demod,
 	     ((jiffies_to_msecs(jiffies) - start_time) <
 	      (DRXJ_QAM_MAX_WAITTIME + timeout_ofs))
 	    );
-	/* Returning control to apllication ... */
+	/* Returning control to application ... */
 
 	return 0;
 rw_error:
@@ -9309,7 +9309,7 @@ get_qamrs_err_count(struct i2c_device_addr *dev_addr,
 		return -EINVAL;
 
 	/* all reported errors are received in the  */
-	/* most recently finished measurment period */
+	/* most recently finished measurement period */
 	/*   no of pre RS bit errors */
 	rc = drxj_dap_read_reg16(dev_addr, FEC_RS_NR_BIT_ERRORS__A, &nr_bit_errors, 0);
 	if (rc != 0) {
@@ -9689,7 +9689,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
       (3) SIF AGC (used to amplify the output signal in case input to low)
 
       The SIF AGC is now coupled to the RF/IF AGCs.
-      The SIF AGC is needed for both SIF ouput and the internal SIF signal to
+      The SIF AGC is needed for both SIF output and the internal SIF signal to
       the AUD block.
 
       RF and IF AGCs DACs are part of AFE, Video and SIF AGC DACs are part of
@@ -9702,11 +9702,11 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
        later on because of the schedule)
 
       Several HW/SCU "settings" can be used for ATV. The standard selection
-      will reset most of these settings. To avoid that the end user apllication
+      will reset most of these settings. To avoid that the end user application
       has to perform these settings each time the ATV or FM standards is
       selected the driver will shadow these settings. This enables the end user
       to perform the settings only once after a drx_open(). The driver must
-      write the shadow settings to HW/SCU incase:
+      write the shadow settings to HW/SCU in case:
 	 ( setstandard FM/ATV) ||
 	 ( settings have changed && FM/ATV standard is active)
       The shadow settings will be stored in the device specific data container.
@@ -9908,7 +9908,7 @@ static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 #define IMPULSE_COSINE_ALPHA_0_5    { 2, 0, -2, -2, 2, 5, 2, -10, -20, -14, 20, 74, 125, 145}	/*sqrt raised-cosine filter with alpha=0.5 */
 #define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0, -7, -15, -16,  0, 34, 77, 114, 128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
 
-/* Coefficients for the nyquist fitler (total: 27 taps) */
+/* Coefficients for the nyquist filter (total: 27 taps) */
 #define NYQFILTERLEN 27
 
 static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_param)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index d3ee1c23bb2f..d62412f71c88 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -49,7 +49,7 @@ INCLUDES
 #if ((DRXDAP_SINGLE_MASTER == 0) && (DRXDAPFASI_LONG_ADDR_ALLOWED == 0))
 #error "Multi master mode and short addressing only is an illegal combination"
 	*;			/* Generate a fatal compiler error to make sure it stops here,
-				   this is necesarry because not all compilers stop after a #error. */
+				   this is necessary because not all compilers stop after a #error. */
 #endif
 
 /*-------------------------------------------------------------------------
@@ -203,7 +203,7 @@ struct drxj_agc_status {
 * /struct drxjrs_errors
 * Available failure information in DRXJ_FEC_RS.
 *
-* Container for errors that are received in the most recently finished measurment period
+* Container for errors that are received in the most recently finished measurement period
 *
 */
 	struct drxjrs_errors {
@@ -405,7 +405,7 @@ struct drxj_cfg_atv_output {
 *
 */
 	struct drxj_data {
-		/* device capabilties (determined during drx_open()) */
+		/* device capabilities (determined during drx_open()) */
 		bool has_lna;		  /*< true if LNA (aka PGA) present */
 		bool has_oob;		  /*< true if OOB supported */
 		bool has_ntsc;		  /*< true if NTSC supported */
@@ -455,7 +455,7 @@ struct drxj_cfg_atv_output {
 
 		/* IQM fs frequecy shift and inversion */
 		u32 iqm_fs_rate_ofs;	   /*< frequency shifter setting after setchannel      */
-		bool pos_image;	   /*< Ture: positive image                            */
+		bool pos_image;	   /*< True: positive image                            */
 		/* IQM RC frequecy shift */
 		u32 iqm_rc_rate_ofs;	   /*< frequency shifter setting after setchannel      */
 
@@ -468,8 +468,8 @@ struct drxj_cfg_atv_output {
 		bool phase_correction_bypass;/*< flag: true=bypass */
 		s16 atv_top_vid_peak;	  /*< shadow of ATV_TOP_VID_PEAK__A */
 		u16 atv_top_noise_th;	  /*< shadow of ATV_TOP_NOISE_TH__A */
-		bool enable_cvbs_output;  /*< flag CVBS ouput enable */
-		bool enable_sif_output;	  /*< flag SIF ouput enable */
+		bool enable_cvbs_output;  /*< flag CVBS output enable */
+		bool enable_sif_output;	  /*< flag SIF output enable */
 		 enum drxjsif_attenuation sif_attenuation;
 					  /*< current SIF att setting */
 		/* Agc configuration for QAM and VSB */
diff --git a/drivers/media/dvb-frontends/drxd_firm.c b/drivers/media/dvb-frontends/drxd_firm.c
index 4e1d8905e06a..412871d6636b 100644
--- a/drivers/media/dvb-frontends/drxd_firm.c
+++ b/drivers/media/dvb-frontends/drxd_firm.c
@@ -890,7 +890,7 @@ u8 DRXD_StartDiversityEnd[] = {
 	/* End demod, combining RF in and diversity in, MPEG TS out */
 	WR16(B_FE_CF_REG_IMP_VAL__A, 0x0),	/* disable impulse noise cruncher */
 	WR16(B_FE_AD_REG_INVEXT__A, 0x0),	/* clock inversion (for sohard board) */
-	WR16(B_CP_REG_BR_STR_DEL__A, 10),	/* apperently no mb delay matching is best */
+	WR16(B_CP_REG_BR_STR_DEL__A, 10),	/* apparently no mb delay matching is best */
 
 	WR16(B_EQ_REG_RC_SEL_CAR__A, B_EQ_REG_RC_SEL_CAR_DIV_ON |	/* org = 0x81 combining enabled */
 	     B_EQ_REG_RC_SEL_CAR_MEAS_A_CC |
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index 76466f7ec3a0..ee06e89187e4 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -24,7 +24,7 @@
  * @microcode_name:	Name of the firmware file with the microcode
  * @qam_demod_parameter_count:	The number of parameters used for the command
  *				to set the demodulator parameters. All
- *				firmwares are using the 2-parameter commmand.
+ *				firmwares are using the 2-parameter command.
  *				An exception is the ``drxk_a3.mc`` firmware,
  *				which uses the 4-parameter command.
  *				A value of 0 (default) or lower indicates that
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 8ea1e45be710..86652a4ef9ce 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -723,7 +723,7 @@ static int init_state(struct drxk_state *state)
 	state->m_drxk_state = DRXK_UNINITIALIZED;
 
 	/* MPEG output configuration */
-	state->m_enable_mpeg_output = true;	/* If TRUE; enable MPEG ouput */
+	state->m_enable_mpeg_output = true;	/* If TRUE; enable MPEG output */
 	state->m_insert_rs_byte = false;	/* If TRUE; insert RS byte */
 	state->m_invert_data = false;	/* If TRUE; invert DATA signals */
 	state->m_invert_err = false;	/* If TRUE; invert ERR signal */
@@ -3870,7 +3870,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 		goto error;
 	}
 #else
-	/* Set Priorty high */
+	/* Set Priority high */
 	transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
 	status = write16(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
 	if (status < 0)
@@ -3901,7 +3901,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 	}
 
 	/*
-	 * SAW filter selection: normaly not necesarry, but if wanted
+	 * SAW filter selection: normally not necessary, but if wanted
 	 * the application can select a SAW filter via the driver by
 	 * using UIOs
 	 */
@@ -5423,7 +5423,7 @@ static int qam_demodulator_command(struct drxk_state *state,
 
 		set_param_parameters[3] |= (QAM_MIRROR_AUTO_ON);
 		/* Env parameters */
-		/* check for LOCKRANGE Extented */
+		/* check for LOCKRANGE Extended */
 		/* set_param_parameters[3] |= QAM_LOCKRANGE_NORMAL; */
 
 		status = scu_command(state,
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 46a55146cb07..2b422d3ac5fa 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -914,7 +914,7 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 	/* ds3000 global reset */
 	ds3000_writereg(state, 0x07, 0x80);
 	ds3000_writereg(state, 0x07, 0x00);
-	/* ds3000 build-in uC reset */
+	/* ds3000 built-in uC reset */
 	ds3000_writereg(state, 0xb2, 0x01);
 	/* ds3000 software reset */
 	ds3000_writereg(state, 0x00, 0x01);
@@ -1023,7 +1023,7 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 
 	/* ds3000 out of software reset */
 	ds3000_writereg(state, 0x00, 0x00);
-	/* start ds3000 build-in uC */
+	/* start ds3000 built-in uC */
 	ds3000_writereg(state, 0xb2, 0x00);
 
 	if (fe->ops.tuner_ops.get_frequency) {
diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
index ae8ec59b665c..7de11d5062c2 100644
--- a/drivers/media/dvb-frontends/isl6421.c
+++ b/drivers/media/dvb-frontends/isl6421.c
@@ -98,7 +98,7 @@ static int isl6421_set_voltage(struct dvb_frontend *fe,
 	if (ret != 2)
 		return -EIO;
 
-	/* Store off status now incase future commands fail */
+	/* Store off status now in case future commands fail */
 	isl6421->is_off = is_off;
 
 	/* On overflow, the device will try again after 900 ms (typically) */
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index d5bc85501f9e..13888732951c 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -701,7 +701,7 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 
 	if (status & FE_HAS_LOCK) {
 		state->fec_inner = m88rs2000_get_fec(state);
-		/* Uknown suspect SNR level */
+		/* Unknown suspect SNR level */
 		reg = m88rs2000_readreg(state, 0x65);
 	}
 
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 0961e686ff68..0ef72d6c6f8b 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -153,7 +153,7 @@ static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8*
 	u8 attr, len2, buf;
 	dprintk("%s\n", __func__);
 
-	/* set mutli register register */
+	/* set multi register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
 
 	/* send the actual data */
@@ -214,7 +214,7 @@ static int nxt200x_readreg_multibyte (struct nxt200x_state* state, u8 reg, u8* d
 	u8 buf, len2, attr;
 	dprintk("%s\n", __func__);
 
-	/* set mutli register register */
+	/* set multi register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
 
 	switch (state->demod_chip) {
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index a39bbd8ff1f0..7343da11a1d8 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -59,7 +59,7 @@ struct or51211_state {
 
 	/* Demodulator private data */
 	u8 initialized:1;
-	u32 snr; /* Result of last SNR claculation */
+	u32 snr; /* Result of last SNR calculation */
 
 	/* Tuner private data */
 	u32 current_frequency;
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index d6673f4fb47b..57fb05bb7e96 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -471,7 +471,7 @@ static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 
-	/* Don't allow queing new buffers after device disconnection */
+	/* Don't allow queueing new buffers after device disconnection */
 	if (!dev->udev)
 		return -ENODEV;
 
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index ceeb0c3551ce..a2907d035fe2 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -490,7 +490,7 @@ static void s5h1409_set_qam_amhum_mode(struct dvb_frontend *fe)
 
 	if (state->qam_state == QAM_STATE_QAM_OPTIMIZED_L3) {
 		/* We've already reached the maximum optimization level, so
-		   dont bother banging on the status registers */
+		   don't bother banging on the status registers */
 		return;
 	}
 
diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index bd2defde7a77..b5debb61bca5 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -835,8 +835,8 @@ static u32 stb0899_dvbs2_calc_dev(struct stb0899_state *state)
 	dec_ratio = (internal->master_clk * 2) / (5 * internal->srate);
 	dec_ratio = (dec_ratio == 0) ? 1 : dec_ratio;
 
-	master_clk = internal->master_clk / 1000;	/* for integer Caculation*/
-	srate = internal->srate / 1000;	/* for integer Caculation*/
+	master_clk = internal->master_clk / 1000;	/* for integer Calculation*/
+	srate = internal->srate / 1000;	/* for integer Calculation*/
 	correction = (512 * master_clk) / (2 * dec_ratio * srate);
 
 	return	correction;
@@ -864,7 +864,7 @@ static void stb0899_dvbs2_set_srate(struct stb0899_state *state)
 		win_sel = dec_rate - 4;
 
 	decim = (1 << dec_rate);
-	/* (FSamp/Fsymbol *100) for integer Caculation */
+	/* (FSamp/Fsymbol *100) for integer Calculation */
 	f_sym = internal->master_clk / ((decim * internal->srate) / 1000);
 
 	if (f_sym <= 2250)	/* don't band limit signal going into btr block*/
diff --git a/drivers/media/dvb-frontends/stv0367_defs.h b/drivers/media/dvb-frontends/stv0367_defs.h
index 277d2971ed3f..4afe8248a667 100644
--- a/drivers/media/dvb-frontends/stv0367_defs.h
+++ b/drivers/media/dvb-frontends/stv0367_defs.h
@@ -1096,7 +1096,7 @@ static const struct st_register def0367dd_ofdm[] = {
 };
 
 static const struct st_register def0367dd_qam[] = {
-	{R367CAB_CTRL_1,                  0x06}, /* Orginal 0x04 */
+	{R367CAB_CTRL_1,                  0x06}, /* Original 0x04 */
 	{R367CAB_CTRL_2,                  0x03},
 	{R367CAB_IT_STATUS1,              0x2b},
 	{R367CAB_IT_STATUS2,              0x08},
diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 254618a06140..fa1a0fb577ad 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -744,12 +744,12 @@ static int stv0900_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
 	if (stv0900_get_standard(fe, demod) == STV0900_DVBS2_STANDARD) {
 		/* DVB-S2 delineator errors count */
 
-		/* retreiving number for errnous headers */
+		/* retrieving number for errnous headers */
 		err_val1 = stv0900_read_reg(intp, BBFCRCKO1);
 		err_val0 = stv0900_read_reg(intp, BBFCRCKO0);
 		header_err_val = (err_val1 << 8) | err_val0;
 
-		/* retreiving number for errnous packets */
+		/* retrieving number for errnous packets */
 		err_val1 = stv0900_read_reg(intp, UPCRCKO1);
 		err_val0 = stv0900_read_reg(intp, UPCRCKO0);
 		*ucblocks = (err_val1 << 8) | err_val0;
diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index fc2440d8af36..68d7c7b41071 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1238,7 +1238,7 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 	 * mutex_lock note: Concurrent I2C gate bus accesses must be
 	 * prevented (STV0910 = dual demod on a single IC with a single I2C
 	 * gate/bus, and two tuners attached), similar to most (if not all)
-	 * other I2C host interfaces/busses.
+	 * other I2C host interfaces/buses.
 	 *
 	 * enable=1 (open I2C gate) will grab the lock
 	 * enable=0 (close I2C gate) releases the lock
@@ -1500,7 +1500,7 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 				  RSTV0910_P2_FBERCPT4 + state->regoff, 0x00);
 			/*
 			 * Reset the packet Error counter2 (and Set it to
-			 * infinit error count mode)
+			 * infinite error count mode)
 			 */
 			write_reg(state,
 				  RSTV0910_P2_ERRCTRL2 + state->regoff, 0xc1);
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 7db9a5bceccc..e54708eb4fb0 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -202,7 +202,7 @@ static int stv6110_set_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
 		i++;
 	}
 
-	/* RCCLKOFF = 1 calibration done, desactivate the calibration Clock */
+	/* RCCLKOFF = 1 calibration done, deactivate the calibration Clock */
 	priv->regs[RSTV6110_CTRL3] |= (1 << 6);
 	stv6110_write_regs(fe, &priv->regs[RSTV6110_CTRL3], RSTV6110_CTRL3, 1);
 	return 0;
diff --git a/drivers/media/dvb-frontends/tda1004x.h b/drivers/media/dvb-frontends/tda1004x.h
index efd7659dace9..26f504a830e3 100644
--- a/drivers/media/dvb-frontends/tda1004x.h
+++ b/drivers/media/dvb-frontends/tda1004x.h
@@ -33,7 +33,7 @@ enum tda10046_xtal {
 
 enum tda10046_agc {
 	TDA10046_AGC_DEFAULT,		/* original configuration */
-	TDA10046_AGC_IFO_AUTO_NEG,	/* IF AGC only, automatic, negtive */
+	TDA10046_AGC_IFO_AUTO_NEG,	/* IF AGC only, automatic, negative */
 	TDA10046_AGC_IFO_AUTO_POS,	/* IF AGC only, automatic, positive */
 	TDA10046_AGC_TDA827X,		/* IF AGC only, special setup for tda827x */
 };
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index 8323e4e53d66..85dddfce8ef4 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -437,7 +437,7 @@ static int tda10086_set_frontend(struct dvb_frontend *fe)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	/* calcluate the frequency offset (in *Hz* not kHz) */
+	/* calculate the frequency offset (in *Hz* not kHz) */
 	freqoff = fe_params->frequency - freq;
 	freqoff = ((1<<16) * freqoff) / (SACLK/1000);
 	tda10086_write_byte(state, 0x3d, 0x80 | ((freqoff >> 8) & 0x7f));
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index eeb2318c102f..e064e2b22d9d 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -105,7 +105,7 @@ struct tda_state {
 	s32   m_RF_B2[7];
 	u32   m_RF3[7];
 
-	u8    m_TMValue_RFCal;    /* Calibration temperatur */
+	u8    m_TMValue_RFCal;    /* Calibration temperature */
 
 	bool  m_bFMInput;         /* true to use Pin 8 for FM Radio */
 
@@ -400,7 +400,7 @@ static int CalibrateRF(struct tda_state *state,
 			break;
 
 		/* Switching off LT (as datasheet says) causes calibration on C1 to fail */
-		/* (Readout of Cprog is allways 255) */
+		/* (Readout of Cprog is always 255) */
 		if (state->m_Regs[ID] != 0x83)    /* C1: ID == 83, C2: ID == 84 */
 			state->m_Regs[EP3] |= 0x40; /* SM_LT = 1 */
 
@@ -644,7 +644,7 @@ static int PowerScan(struct tda_state *state,
 		if (status < 0)
 			break;
 		CID_Gain = Regs[EB10] & 0x3F;
-		state->m_Regs[ID] = Regs[ID];  /* Chip version, (needed for C1 workarround in CalibrateRF) */
+		state->m_Regs[ID] = Regs[ID];  /* Chip version, (needed for C1 workaround in CalibrateRF) */
 
 		*pRF_Out = RF_in;
 
-- 
2.20.1

