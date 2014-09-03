Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 27/46] [media] drxk_hard: simplify test logic
Date: Wed,  3 Sep 2014 17:32:59 -0300
Message-Id: <6669469965f67fe39007bd0d5d603f8d06994ff3.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of testing if it is false or true, just use
if (!foo) or if (foo). That makes the code easier to
read and shorter.

Also, properly initialize booleans with true or false.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index cce94a75b2e1..88182c18e186 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -1028,7 +1028,7 @@ static int hi_command(struct drxk_state *state, u16 cmd, u16 *p_result)
 		    ((state->m_hi_cfg_ctrl) &
 		     SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M) ==
 		    SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ);
-	if (powerdown_cmd == false) {
+	if (!powerdown_cmd) {
 		/* Wait until command rdy */
 		u32 retry_count = 0;
 		u16 wait_cmd;
@@ -1129,7 +1129,7 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 	if (status < 0)
 		goto error;
 
-	if (mpeg_enable == false) {
+	if (!mpeg_enable) {
 		/*  Set MPEG TS pads to inputmode */
 		status = write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
 		if (status < 0)
@@ -1190,7 +1190,7 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 		if (status < 0)
 			goto error;
 
-		if (state->m_enable_parallel == true) {
+		if (state->m_enable_parallel) {
 			/* parallel -> enable MD1 to MD7 */
 			status = write16(state, SIO_PDR_MD1_CFG__A,
 					 sio_pdr_mdx_cfg);
@@ -1392,7 +1392,7 @@ static int dvbt_enable_ofdm_token_ring(struct drxk_state *state, bool enable)
 
 	dprintk(1, "\n");
 
-	if (enable == false) {
+	if (!enable) {
 		desired_ctrl = SIO_OFDM_SH_OFDM_RING_ENABLE_OFF;
 		desired_status = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
 	}
@@ -2012,7 +2012,7 @@ static int mpegts_dto_setup(struct drxk_state *state,
 		goto error;
 	fec_oc_reg_mode &= (~FEC_OC_MODE_PARITY__M);
 	fec_oc_reg_ipr_mode &= (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
-	if (state->m_insert_rs_byte == true) {
+	if (state->m_insert_rs_byte) {
 		/* enable parity symbol forward */
 		fec_oc_reg_mode |= FEC_OC_MODE_PARITY__M;
 		/* MVAL disable during parity bytes */
@@ -2023,7 +2023,7 @@ static int mpegts_dto_setup(struct drxk_state *state,
 
 	/* Check serial or parallel output */
 	fec_oc_reg_ipr_mode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
-	if (state->m_enable_parallel == false) {
+	if (!state->m_enable_parallel) {
 		/* MPEG data output is serial -> set ipr_mode[0] */
 		fec_oc_reg_ipr_mode |= FEC_OC_IPR_MODE_SERIAL__M;
 	}
@@ -2136,19 +2136,19 @@ static int mpegts_configure_polarity(struct drxk_state *state)
 
 	/* Control selective inversion of output bits */
 	fec_oc_reg_ipr_invert &= (~(invert_data_mask));
-	if (state->m_invert_data == true)
+	if (state->m_invert_data)
 		fec_oc_reg_ipr_invert |= invert_data_mask;
 	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MERR__M));
-	if (state->m_invert_err == true)
+	if (state->m_invert_err)
 		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MERR__M;
 	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MSTRT__M));
-	if (state->m_invert_str == true)
+	if (state->m_invert_str)
 		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MSTRT__M;
 	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MVAL__M));
-	if (state->m_invert_val == true)
+	if (state->m_invert_val)
 		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MVAL__M;
 	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
-	if (state->m_invert_clk == true)
+	if (state->m_invert_clk)
 		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MCLK__M;
 
 	return write16(state, FEC_OC_IPR_INVERT__A, fec_oc_reg_ipr_invert);
@@ -3352,7 +3352,7 @@ static int dvbt_ctrl_set_inc_enable(struct drxk_state *state, bool *enabled)
 	int status;
 
 	dprintk(1, "\n");
-	if (*enabled == true)
+	if (*enabled)
 		status = write16(state, IQM_CF_BYPASSDET__A, 0);
 	else
 		status = write16(state, IQM_CF_BYPASSDET__A, 1);
@@ -3368,7 +3368,7 @@ static int dvbt_ctrl_set_fr_enable(struct drxk_state *state, bool *enabled)
 	int status;
 
 	dprintk(1, "\n");
-	if (*enabled == true) {
+	if (*enabled) {
 		/* write mask to 1 */
 		status = write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A,
 				   DEFAULT_FR_THRES_8K);
@@ -6794,11 +6794,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->enable_merr_cfg = config->enable_merr_cfg;
 
 	if (config->dynamic_clk) {
-		state->m_dvbt_static_clk = 0;
-		state->m_dvbc_static_clk = 0;
+		state->m_dvbt_static_clk = false;
+		state->m_dvbc_static_clk = false;
 	} else {
-		state->m_dvbt_static_clk = 1;
-		state->m_dvbc_static_clk = 1;
+		state->m_dvbt_static_clk = true;
+		state->m_dvbc_static_clk = true;
 	}
 
 
-- 
1.9.3

